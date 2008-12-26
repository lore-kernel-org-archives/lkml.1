Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYLZOWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYLZOWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 09:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYLZOWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 09:22:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47349 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYLZOWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 09:22:24 -0500
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/4] Remove interrupt stack table usage from x86_64 kernel (v2)
Date: Fri, 26 Dec 2008 16:22:20 +0200
Message-Id: <1230301344-570-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt stack table (IST) mechanism is the only thing preventing
kvm from deferring saving and reloading of some significant state.  It
is also somewhat complicated.

Remove it by switching the special exceptions to use the normal irqstack.

Changes from v1:
- rebase on tip/master
- as a step, consolidate stack switching into a single macro

Jeremy, Xen is also affected; please review.

Avi Kivity (4):
  x86: drop the use of the tss interrupt stack table (IST)
  x86: Consolidate irq stack switching to a single macro
  x86: Make interrupt stack switching atomic
  x86: Move NMI back to interrupt stack

 arch/x86/include/asm/desc.h      |   12 -----
 arch/x86/include/asm/page_64.h   |    7 ---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/include/asm/processor.h |   11 ----
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |   35 --------------
 arch/x86/kernel/dumpstack_64.c   |   96 --------------------------------------
 arch/x86/kernel/entry_64.S       |   89 ++++++++++-------------------------
 arch/x86/kernel/traps.c          |   12 ++--
 9 files changed, 33 insertions(+), 232 deletions(-)

