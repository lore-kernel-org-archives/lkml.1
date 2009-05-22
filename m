Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZEVE6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZEVE6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZEVEzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:50 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45240 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZEVEzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YMW3iP7nD/kXfIT/jgKxwFlQ4fCNN2IA1f1nQpGdNSvSbEpa+2jKWWE/1oT+FRcPH8
         b3mVGI5gspsILs1Cxd/M4DbzMNseTCOwoB7Wh/JRJ2PF8JSPA8ajqOH40G/9h/lhtOIP
         UMiEsOhOvUlywAx7CaBKRTnEXRdZsjN+A+jbQ=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 12/38] i386: ifdef out struct thread_struct::fs
Date: Fri, 22 May 2009 08:55:06 +0400
Message-Id: <1242968132-1044-12-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 464d1a78fbf8cf6c7fd970e7b3e2db50a320ce28 aka
"[PATCH] i386: Convert i386 PDA code to use %fs"
%fs saved during context switch moved from thread_struct to pt_regs
and value on thread_struct became unused.

I don't understand why .fs (OK, .gs first) initializer was added, kernel
clearly stopped touching it after the patch.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/x86/include/asm/processor.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c2cceae..a6732ff 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -428,7 +428,9 @@ struct thread_struct {
 	unsigned short		gsindex;
 #endif
 	unsigned long		ip;
+#ifdef CONFIG_X86_64
 	unsigned long		fs;
+#endif
 	unsigned long		gs;
 	/* Hardware debugging registers: */
 	unsigned long		debugreg0;
@@ -874,7 +876,6 @@ static inline void spin_lock_prefetch(const void *x)
 	.vm86_info		= NULL,					  \
 	.sysenter_cs		= __KERNEL_CS,				  \
 	.io_bitmap_ptr		= NULL,					  \
-	.fs			= __KERNEL_PERCPU,			  \
 }
 
 /*
-- 
1.5.6.5

