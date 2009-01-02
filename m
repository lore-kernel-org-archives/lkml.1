Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbZABKnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbZABKnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbZABKln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:43 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:48803 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbZABKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:37 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: hp300 core - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:17 +0100
Message-Id: <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/hp300/time.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/hp300/time.c b/arch/m68k/hp300/time.c
index dd7c8a2..f6312c7 100644
--- a/arch/m68k/hp300/time.c
+++ b/arch/m68k/hp300/time.c
@@ -70,7 +70,8 @@ void __init hp300_sched_init(irq_handler_t vector)
 
   asm volatile(" movpw %0,%1@(5)" : : "d" (INTVAL), "a" (CLOCKBASE));
 
-  request_irq(IRQ_AUTO_6, hp300_tick, IRQ_FLG_STD, "timer tick", vector);
+  if (request_irq(IRQ_AUTO_6, hp300_tick, IRQ_FLG_STD, "timer tick", vector))
+    pr_err("Couldn't register timer interrupt\n");
 
   out_8(CLOCKBASE + CLKCR2, 0x1);		/* select CR1 */
   out_8(CLOCKBASE + CLKCR1, 0x40);		/* enable irq */
-- 
1.5.6.5

