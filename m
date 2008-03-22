Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYCVVER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYCVVER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYCVVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:03:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:64920 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYCVVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=f/X3ISxBGKpVdH8nNZPoW1TxLSLfX1hff2w0kr/mVMuwJg+BUE0vZ6t6/b3/idgzGfQ8FsyQ2fM76RO8wqN3mh8yzxKc3RLRMmyCHAvjIi/mH1F8jr4zeK8kOaJ3mXs+4l3hLO74ktf4/fj6u9ngMlBgwEHbv/gBJjtdVr2lMcQ=
Message-Id: <20080322210310.893461023@gmail.com>
References: <20080322210005.117475478@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 23 Mar 2008 00:00:07 +0300
From: gorcunov@gmail.com
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, gorcunov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [patch 2/4] x86: relocate_kernel - use PAGE_SIZE instead of numeric constant
Content-Disposition: inline; filename=x86-use-PAGE_SIZE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
Index: linux-2.6.git/arch/x86/kernel/relocate_kernel_32.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/relocate_kernel_32.S	2008-03-22 21:15:37.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/relocate_kernel_32.S	2008-03-22 21:16:54.000000000 +0300
@@ -154,7 +154,7 @@ relocate_new_kernel:
 	movl	%eax, %cr3
 
 	/* setup a new stack at the end of the physical control page */
-	lea	4096(%edi), %esp
+	lea	PAGE_SIZE(%edi), %esp
 
 	/* jump to identity mapped page */
 	movl    %edi, %eax
Index: linux-2.6.git/arch/x86/kernel/relocate_kernel_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/relocate_kernel_64.S	2008-03-22 20:58:02.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/relocate_kernel_64.S	2008-03-22 21:17:13.000000000 +0300
@@ -159,7 +159,7 @@ relocate_new_kernel:
 	movq	%r9, %cr3
 
 	/* setup a new stack at the end of the physical control page */
-	lea	4096(%r8), %rsp
+	lea	PAGE_SIZE(%r8), %rsp
 
 	/* jump to identity mapped page */
 	addq	$(identity_mapped - relocate_kernel), %r8

-- 
