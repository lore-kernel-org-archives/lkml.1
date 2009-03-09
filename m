Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZCIRWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZCIRWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZCIRWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:22:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:32667 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZCIRWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lSuZxz1lbiNOXe3NiUNxByqBrZ4180fk/dIWAY/u6a7KtxMuuEkFP7P9jGOA/ufyYh
         s5qOxUmLLXQZkMdSVFIqZu9JS/Nba+Wjt8hrbZhd0lRCvcFx6uMPLaEWtAnvkaCQeTci
         0HObbN6Aw1YW0qiHwhR0xJkz2KgXhXVAofz5U=
Date: Mon, 9 Mar 2009 20:19:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: shrink __ALIGN and __ALIGN_STR definitions
Message-ID: <20090309171951.GE9945@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

1) .p2align 4 and .align 16 are the same meaning
   (until a.out format for i386 is used which is
    not our case for CONFIG_X86_ALIGNMENT_16 anyway)
2) having 15 as max allowed bytes to be skipped
   does not make sense on modulo 16

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Check it please

 arch/x86/include/asm/linkage.h |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/linkage.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/linkage.h
+++ linux-2.6.git/arch/x86/include/asm/linkage.h
@@ -53,14 +53,9 @@
 	.globl name;	\
 	name:
 
-#ifdef CONFIG_X86_64
-#define __ALIGN .p2align 4,,15
-#define __ALIGN_STR ".p2align 4,,15"
-#endif
-
-#ifdef CONFIG_X86_ALIGNMENT_16
-#define __ALIGN .align 16,0x90
-#define __ALIGN_STR ".align 16,0x90"
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_ALIGNMENT_16)
+#define __ALIGN .p2align 4,0x90
+#define __ALIGN_STR ".p2align 4,0x90"
 #endif
 
 #endif /* __ASSEMBLY__ */
