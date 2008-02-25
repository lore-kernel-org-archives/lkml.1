Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYBYLHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYBYLHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYBYLHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:07:13 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:23530 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYBYLHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:07:12 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200802251207.906590508@firstfloor.org>
In-Reply-To: <200802251207.906590508@firstfloor.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       roland@redhat.com
Subject: [PATCH] [2/3] Move early exception handlers into init.text
Message-Id: <20080225110709.E6A3C1B4192@basil.firstfloor.org>
Date: Mon, 25 Feb 2008 12:07:09 +0100 (CET)
X-OriginalArrivalTime: 25 Feb 2008 11:00:43.0735 (UTC) FILETIME=[AAB0E670:01C8779D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently they are in .text.head because the rest of head_64.S. 
.text.head is not removed as init data, but the early exception handlers
should be because they are not needed after early boot of the BP. 
So move them over.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/head_64.S |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/arch/x86/kernel/head_64.S
===================================================================
--- linux.orig/arch/x86/kernel/head_64.S
+++ linux/arch/x86/kernel/head_64.S
@@ -267,6 +267,7 @@ ENTRY(secondary_startup_64)
 bad_address:
 	jmp bad_address
 
+	.section ".init.text","ax"
 #ifdef CONFIG_EARLY_PRINTK
 .macro early_idt_tramp first, last
 	.ifgt \last-\first
@@ -325,6 +326,7 @@ early_idt_msg:
 early_idt_ripmsg:
 	.asciz "RIP %s\n"
 #endif /* CONFIG_EARLY_PRINTK */
+	.previous
 
 .balign PAGE_SIZE
 
