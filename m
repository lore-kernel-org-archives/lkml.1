Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZBKPYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZBKPYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbZBKPX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:23:26 -0500
Received: from mailhost.igel.co.jp ([219.106.231.130]:41200 "EHLO
	mailhost.igel.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZBKPXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:23:24 -0500
From: Katsuya Matsubara <matsu@igel.co.jp>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH RT 4/4] convert-locks-list: add sh specific spin locks
Date: Thu, 12 Feb 2009 00:01:43 +0900
Message-Id: <1234364503-857-5-git-send-email-matsu@igel.co.jp>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234364503-857-4-git-send-email-matsu@igel.co.jp>
References: <1234364503-857-1-git-send-email-matsu@igel.co.jp>
 <1234364503-857-2-git-send-email-matsu@igel.co.jp>
 <1234364503-857-3-git-send-email-matsu@igel.co.jp>
 <1234364503-857-4-git-send-email-matsu@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preempt-rt converts all spin locks into sleepable locks. However
some of the locks, for example, used in preempt-disabled code, must
keep the original behavior. The convert-locks script can revert such
locks specified by convert-locks-list. This patch add sh specific spin
locks into the list.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 scripts/convert-locks-list |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/scripts/convert-locks-list b/scripts/convert-locks-list
index daba5a8..44793fb 100644
--- a/scripts/convert-locks-list
+++ b/scripts/convert-locks-list
@@ -84,6 +84,18 @@ arch/powerpc/include/asm/mpic.h:fixup_lock
 arch/powerpc/include/asm/rtas.h:lock
 arch/powerpc/include/asm/rwsem.h:wait_lock
 
+arch/sh/kernel/irq.c:(.*)lock
+arch/sh/kernel/traps_32.c:die_lock
+arch/sh/kernel/io_trapped.c:trapped_lock
+arch/sh/kernel/cpu/sh4/sq.c:sq_mapping_lock
+arch/sh/kernel/cpu/clock.c:clock_lock
+arch/sh/drivers/pci/ops-sh4.c:sh4_pci_lock
+arch/sh/mm/pmb.c:pmb_list_lock
+
+arch/sh/include/asm/dma.h:dma_spin_lock
+arch/sh/drivers/dma/dma-api.c:dma_spin_lock
+arch/sh/drivers/dma/dma-isa.c:dma_spin_lock
+
 arch/mips/kernel/i8259.c:i8259A_lock
 arch/mips/kernel/module.c:dbe_lock
 arch/mips/kernel/smp.c:smp_call_lock
-- 
1.6.1

