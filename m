Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbYEMRAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbYEMRAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYEMRAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:00:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:48148 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYEMRAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=sRy1lKfn83A1azvOKvjDvP8lpq8RR9MknkWaUZmYiRScOGAVavbsugfPKQlnKnSWfdGkahaa99B7P79UySozOHPiqKr0jsFiAxvQYRvzkJdg6Js9VevA2hCO0FGYeigACkNNcHeY4xrZ9ASpFYWOD+8JNuNi6kGNS/V/nwyP/U0=
References: <20080513165538.952646389@gmail.com>>
User-Agent: quilt/0.46-1
Date: Tue, 13 May 2008 20:55:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, jirislaby@gmail.com
Subject: [patch 2/2] x86: head_64.S cleanup - use PMD_SHIFT instead of numeric constant
Content-Disposition: inline; filename=x86-head-64-pmd
Message-ID: <4829c921.1438560a.7242.089f@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/head_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/head_64.S	2008-05-13 20:05:04.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/head_64.S	2008-05-13 20:22:27.000000000 +0400
@@ -322,11 +322,11 @@ early_idt_ripmsg:
 ENTRY(name)
 
 /* Automate the creation of 1 to 1 mapping pmd entries */
-#define PMDS(START, PERM, COUNT)		\
-	i = 0 ;					\
-	.rept (COUNT) ;				\
-	.quad	(START) + (i << 21) + (PERM) ;	\
-	i = i + 1 ;				\
+#define PMDS(START, PERM, COUNT)			\
+	i = 0 ;						\
+	.rept (COUNT) ;					\
+	.quad	(START) + (i << PMD_SHIFT) + (PERM) ;	\
+	i = i + 1 ;					\
 	.endr
 
 	/*

-- 
