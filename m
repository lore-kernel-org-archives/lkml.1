Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbZECX3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbZECX3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZECX3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:29:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36234 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbZECX3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tbZj9xqZNKetaYejrrMmK9SHaYu1SdZ00Z/fZY30ed6a+PAWNQv9jcCKpw5P5D+TR1
         du4Ogn+wj6QJtjh3uNCzCfZH/gm406wJ2Z1uo+ThAga/08D3oxDR70MCwHKmbsOU5N8B
         /jx8KTtTC/bgUie8bUST7xuMy/BFbmVmUDMqY=
Date: Mon, 4 May 2009 03:29:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 1/2] i386: ifdef out struct thread_struct::fs
Message-ID: <20090503232952.GI16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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
