Return-Path: <linux-kernel-owner+w=401wt.eu-S932278AbYCDVOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbYCDVOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbYCDVNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:13:44 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:55782 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbYCDVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:13:42 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803041013.139953228@firstfloor.org>
In-Reply-To: <200803041013.139953228@firstfloor.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] [2/3] Move early exception handlers into init.text
Message-Id: <20080304211331.2A7D01B4199@basil.firstfloor.org>
Date: Tue,  4 Mar 2008 22:13:31 +0100 (CET)
X-OriginalArrivalTime: 04 Mar 2008 21:07:01.0720 (UTC) FILETIME=[B0F6E580:01C87E3B]
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
 
