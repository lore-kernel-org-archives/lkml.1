Return-Path: <linux-kernel-owner+w=401wt.eu-S1765459AbXGSJ7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765459AbXGSJ7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbXGSJyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbXGSJyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:54 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: jh@suse.cz, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/58] x86_64: Always use builtin memcpy on gcc 4.3
Message-Id: <20070719095453.5434214E04@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Jan asked to always use the builtin memcpy on gcc 4.3 mainline because
it should generate better code than the old macro. Let's try it.

Cc: jh@suse.cz

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/string.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/include/asm-x86_64/string.h
===================================================================
--- linux.orig/include/asm-x86_64/string.h
+++ linux/include/asm-x86_64/string.h
@@ -29,6 +29,9 @@ return (to);
    function. */
 
 #define __HAVE_ARCH_MEMCPY 1
+#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
+extern void *memcpy(void *to, const void *from, size_t len);
+#else
 extern void *__memcpy(void *to, const void *from, size_t len); 
 #define memcpy(dst,src,len) \
 	({ size_t __len = (len);				\
@@ -38,7 +41,7 @@ extern void *__memcpy(void *to, const vo
 	   else							\
 		 __ret = __builtin_memcpy((dst),(src),__len);	\
 	   __ret; }) 
-
+#endif
 
 #define __HAVE_ARCH_MEMSET
 void *memset(void *s, int c, size_t n);
