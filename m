Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYCKBX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYCKBX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYCKBXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:23:24 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:60248 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYCKBXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:23:23 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080311223.655043226@firstfloor.org>
In-Reply-To: <20080311223.655043226@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] [2/3] Move early exception handlers into init.text
Message-Id: <20080311012321.ACDFA1B41CE@basil.firstfloor.org>
Date: Tue, 11 Mar 2008 02:23:21 +0100 (CET)
X-OriginalArrivalTime: 11 Mar 2008 01:16:50.0049 (UTC) FILETIME=[952EE710:01C88315]
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
 
