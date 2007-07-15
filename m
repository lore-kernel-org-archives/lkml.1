Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbXGODnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbXGODnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 23:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXGODnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 23:43:33 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51504 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbXGODnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 23:43:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: paulus@samba.org
Subject: [patch] use __attribute__ in asm-powerpc
Date: Sat, 14 Jul 2007 23:36:09 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707142336.10343.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pretty much everyone uses "__attribute__" or "attribute", no one
uses "__attribute".  This patch tweaks the three places in asm-powerpc where
this comes up.  While only asm-powerpc/types.h is interesting (for userspace),
I did asm-powerpc/processor.h as well for consistency.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-powerpc/processor.h b/include/asm-powerpc/processor.h
index d947b16..2ce6ea6 100644
--- a/include/asm-powerpc/processor.h
+++ b/include/asm-powerpc/processor.h
@@ -153,9 +153,9 @@ struct thread_struct {
 	unsigned long	dabr;		/* Data address breakpoint register */
 #ifdef CONFIG_ALTIVEC
 	/* Complete AltiVec register set */
-	vector128	vr[32] __attribute((aligned(16)));
+	vector128	vr[32] __attribute__((aligned(16)));
 	/* AltiVec status */
-	vector128	vscr __attribute((aligned(16)));
+	vector128	vscr __attribute__((aligned(16)));
 	unsigned long	vrsave;
 	int		used_vr;	/* set if process has used altivec */
 #endif /* CONFIG_ALTIVEC */
diff --git a/include/asm-powerpc/types.h b/include/asm-powerpc/types.h
index 3b36375..a584341 100644
--- a/include/asm-powerpc/types.h
+++ b/include/asm-powerpc/types.h
@@ -48,7 +48,7 @@ typedef unsigned long long __u64;
 
 typedef struct {
 	__u32 u[4];
-} __attribute((aligned(16))) __vector128;
+} __attribute__((aligned(16))) __vector128;
 
 #endif /* __ASSEMBLY__ */
 
