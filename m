Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbYLYU67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbYLYU67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 15:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYLYU6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 15:58:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51742 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbYLYU6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 15:58:46 -0500
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Remove interrupt stack table usage from x86_64 kernel
Date: Thu, 25 Dec 2008 22:58:43 +0200
Message-Id: <1230238726-17506-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt stack table (IST) mechanism is the only thing preventing
kvm from deferring saving and reloading of some significant state.  It
is also somewhat complicated.

Remove it by switching the special exceptions to use the normal irqstack.

Avi Kivity (3):
  x86: drop the use of the tss interrupt stack table (IST)
  x86: Remove pda.irqcount
  x86: Switch critical exceptions and NMI to irqstack

 arch/x86/include/asm/desc.h      |   12 -----
 arch/x86/include/asm/page_64.h   |    7 ---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/include/asm/processor.h |   11 ----
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |   35 --------------
 arch/x86/kernel/dumpstack_64.c   |   96 --------------------------------------
 arch/x86/kernel/entry_64.S       |   49 ++++++++-----------
 arch/x86/kernel/traps.c          |   12 ++--
 9 files changed, 27 insertions(+), 198 deletions(-)

