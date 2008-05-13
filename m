Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbYEMRBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbYEMRBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYEMRAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:00:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:47886 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbYEMRAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=a9Lm8edr8+rFPJziTo1TvDNoKan3GUjprilXvXhsv+seskNTPvV6UTrnDBLxy2wGYakKaCnNiaD1ZSvIsTjaZy70sgOJmGeKmt9rhTQ8DT2gW+f3MfGX2lTkbVUssDXAuX/PjMHyHjqbeQ/Pesyo00MzvsgLdaVS2wTSDer37LY=
References: <20080513165538.952646389@gmail.com>>
User-Agent: quilt/0.46-1
Date: Tue, 13 May 2008 20:55:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, jirislaby@gmail.com
Subject: [patch 1/2] x86: head_64.S cleanup - use straight move to CR4 register
Content-Disposition: inline; filename=x86-head-64-S-flags
Message-ID: <4829c921.0305560a.489b.07db@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for testing the values because we already know
what they should be. Just set them in straight way.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/head_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/head_64.S	2008-05-13 19:17:31.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/head_64.S	2008-05-13 19:35:11.000000000 +0400
@@ -155,9 +155,7 @@ ENTRY(secondary_startup_64)
 	 */
 
 	/* Enable PAE mode and PGE */
-	xorq	%rax, %rax
-	btsq	$5, %rax
-	btsq	$7, %rax
+	movq	$(X86_CR4_PAE | X86_CR4_PGE), %rax
 	movq	%rax, %cr4
 
 	/* Setup early boot stage 4 level pagetables. */

-- 
