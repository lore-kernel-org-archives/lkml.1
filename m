Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbXHAWTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbXHAWTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXHAWTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:19:05 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:58728 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbXHAWTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:19:02 -0400
Date: Thu, 2 Aug 2007 00:18:38 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mundt <lethal@linux-sh.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Matthew Wilcox <matthew@wil.cx>, Kyle McMartin <kyle@parisc-linux.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix WARN_ON() on bitfield ops for all other archs
Message-ID: <20070801221838.GA9010@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fixes WARN_ON() on bitfiels ops for all architectures that have
been left out in 8d4fbcfbe0a4bfc73e7f0297c59ae514e1f1436f.

Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/asm-avr32/bug.h  |    2 +-
 include/asm-parisc/bug.h |    2 +-
 include/asm-s390/bug.h   |    2 +-
 include/asm-sh/bug.h     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/include/asm-avr32/bug.h
===================================================================
--- linux-2.6.orig/include/asm-avr32/bug.h
+++ linux-2.6/include/asm-avr32/bug.h
@@ -57,7 +57,7 @@
 
 #define WARN_ON(condition)							\
 	({								\
-		typeof(condition) __ret_warn_on = (condition);		\
+		int __ret_warn_on = !!(condition);			\
 		if (unlikely(__ret_warn_on))				\
 			_BUG_OR_WARN(BUGFLAG_WARNING);			\
 		unlikely(__ret_warn_on);				\
Index: linux-2.6/include/asm-parisc/bug.h
===================================================================
--- linux-2.6.orig/include/asm-parisc/bug.h
+++ linux-2.6/include/asm-parisc/bug.h
@@ -74,7 +74,7 @@
 
 
 #define WARN_ON(x) ({						\
-	typeof(x) __ret_warn_on = (x);				\
+	int __ret_warn_on = !!(x);				\
 	if (__builtin_constant_p(__ret_warn_on)) {		\
 		if (__ret_warn_on)				\
 			__WARN();				\
Index: linux-2.6/include/asm-s390/bug.h
===================================================================
--- linux-2.6.orig/include/asm-s390/bug.h
+++ linux-2.6/include/asm-s390/bug.h
@@ -50,7 +50,7 @@
 #define BUG()	__EMIT_BUG(0)
 
 #define WARN_ON(x) ({					\
-	typeof(x) __ret_warn_on = (x);			\
+	int __ret_warn_on = !!(x);			\
 	if (__builtin_constant_p(__ret_warn_on)) {	\
 		if (__ret_warn_on)			\
 			__EMIT_BUG(BUGFLAG_WARNING);	\
Index: linux-2.6/include/asm-sh/bug.h
===================================================================
--- linux-2.6.orig/include/asm-sh/bug.h
+++ linux-2.6/include/asm-sh/bug.h
@@ -61,7 +61,7 @@ do {							\
 } while (0)
 
 #define WARN_ON(x) ({						\
-	typeof(x) __ret_warn_on = (x);				\
+	int __ret_warn_on = !!(x);				\
 	if (__builtin_constant_p(__ret_warn_on)) {		\
 		if (__ret_warn_on)				\
 			__WARN();				\
