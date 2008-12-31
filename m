Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYLaIgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYLaIgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYLaIfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:35:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61136 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYLaIfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:35:50 -0500
Message-ID: <495B2EA6.7010808@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 16:34:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] cpuset: convert to new cpumask API
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset converts cpuset to use new cpumask API, and thus
remove on stack cpumask_t to reduce stack usage.

Before:
 # cat kernel/cpuset.c include/linux/cpuset.h | grep -c cpumask_t
 21
After:
 # cat kernel/cpuset.c include/linux/cpuset.h | grep -c cpumask_t
 0

The patchset is based on mmotm 2008-12-30-16-05.

[PATCH 1/6] cpuset: remove on stack cpumask_t in cpuset_sprintf_cpulist()
[PATCH 2/6] cpuset: remove on stack cpumask_t in cpuset_can_attach()
[PATCH 3/6] cpuset: convert cpuset_attach() to use cpumask_var_t
[PATCH 4/6] cpuset: don't allocate trial cpuset on stack
[PATCH 5/6] cpuset: convert cpuset->cpus_allowed to cpumask_var_t
[PATCH 6/6] cpuset: remove remaining pointers to cpumask_t
---
 include/linux/cpuset.h   |   10 +
 kernel/cpuset.c          |  279 ++++++++++++++++++++++++++++-------------------
 3 files changed, 174 insertions(+), 115 deletions(-)


