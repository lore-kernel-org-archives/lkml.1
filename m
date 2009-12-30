Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZL3DRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZL3DRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 22:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZL3DRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 22:17:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58199 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZL3DRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:17:20 -0500
Message-ID: <4B3AC5CD.1000502@cn.fujitsu.com>
Date: Wed, 30 Dec 2009 11:15:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] perf_event: fix getting symbol error if kernel is relocatable
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If the kernel is relocatable, perf tools can't get symbol
name correctly, See: http://lkml.org/lkml/2009/12/20/218

The purpose of this patchset is to fix this bug, and it base
on my previously patchset: http://lkml.org/lkml/2009/12/29/4
since it used 'inject' event

 arch/x86/boot/compressed/head_32.S |    2 ++
 arch/x86/boot/compressed/head_64.S |    3 +++
 arch/x86/include/asm/bootparam.h   |    3 ++-
 arch/x86/kernel/asm-offsets_32.c   |    1 +
 arch/x86/kernel/asm-offsets_64.c   |    1 +
 arch/x86/kernel/cpu/perf_event.c   |   10 ++++++++++
 include/linux/perf_event.h         |    1 +
 kernel/perf_event.c                |   23 +++++++++++++++++++++--
 tools/perf/builtin-record.c        |    3 +++
 tools/perf/util/session.c          |    6 ++++++
 tools/perf/util/symbol.c           |   13 +++++++++++++
 tools/perf/util/symbol.h           |    3 ++-
 12 files changed, 65 insertions(+), 4 deletions(-)

