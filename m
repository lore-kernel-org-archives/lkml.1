Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbZDGPQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbZDGPQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbZDGPII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48873 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622AbZDGPIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:07 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [21/28] x86: MCE: Store record length into memory struct mce anchor
Message-Id: <20090407150804.3A39C1D046F@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This makes it easier for tools who want to extract the mcelog out of 
crash images or memory dumps to adapt to changing struct mce size.
The length field replaces padding, so it's fully compatible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h          |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:10.000000000 +0200
@@ -94,8 +94,9 @@
  */
 
 static struct mce_log mcelog = {
-	MCE_LOG_SIGNATURE,
-	MCE_LOG_LEN,
+	.signature = MCE_LOG_SIGNATURE,
+	.len = MCE_LOG_LEN,
+	.recordlen = sizeof(struct mce),
 };
 
 void mce_log(struct mce *mce)
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/include/asm/mce.h	2009-04-07 16:43:10.000000000 +0200
@@ -59,7 +59,7 @@
 	unsigned len;	    /* = MCE_LOG_LEN */
 	unsigned next;
 	unsigned flags;
-	unsigned pad0;
+	unsigned recordlen;	/* length of struct mce */
 	struct mce entry[MCE_LOG_LEN];
 };
 
