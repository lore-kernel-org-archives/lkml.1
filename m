Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbXK2Qs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbXK2Qs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbXK2Qsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:48:35 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:48149 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXK2Qsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:48:33 -0500
Date: Thu, 29 Nov 2007 11:48:23 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH] Fix __const_udelay declaration and definition mismatches
Message-ID: <20071129164823.GA7299@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ 2.6.25 material ]

The declaration and implementation of __const_udelay use different
names for the parameter on a number of architectures:

include/asm-avr32/delay.h:15:extern void __const_udelay(unsigned long usecs);
arch/avr32/lib/delay.c:39:inline void __const_udelay(unsigned long xloops)

include/asm-sh/delay.h:15:extern void __const_udelay(unsigned long usecs);
arch/sh/lib/delay.c:22:inline void __const_udelay(unsigned long xloops)

include/asm-m32r/delay.h:15:extern void __const_udelay(unsigned long usecs);
arch/m32r/lib/delay.c:58:void __const_udelay(unsigned long xloops)

include/asm-x86/delay.h:16:extern void __const_udelay(unsigned long usecs);
arch/x86/lib/delay_32.c:82:inline void __const_udelay(unsigned long xloops)
arch/x86/lib/delay_64.c:46:inline void __const_udelay(unsigned long xloops)

The units of the parameter isn't usecs, so that name is definitely
wrong.  It's also not exactly loops, so I suppose xloops is an OK
name.

This patch changes these names from usecs to xloops.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 include/asm-avr32/delay.h |    2 +-
 include/asm-m32r/delay.h  |    2 +-
 include/asm-sh/delay.h    |    2 +-
 include/asm-x86/delay.h   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-git/include/asm-avr32/delay.h
===================================================================
--- linux-2.6-git.orig/include/asm-avr32/delay.h	2007-11-28 13:01:42.000000000 -0500
+++ linux-2.6-git/include/asm-avr32/delay.h	2007-11-29 10:28:14.000000000 -0500
@@ -12,7 +12,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 #define udelay(n) (__builtin_constant_p(n) ? \
Index: linux-2.6-git/include/asm-m32r/delay.h
===================================================================
--- linux-2.6-git.orig/include/asm-m32r/delay.h	2007-11-28 13:01:43.000000000 -0500
+++ linux-2.6-git/include/asm-m32r/delay.h	2007-11-29 10:28:14.000000000 -0500
@@ -12,7 +12,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 #define udelay(n) (__builtin_constant_p(n) ? \
Index: linux-2.6-git/include/asm-sh/delay.h
===================================================================
--- linux-2.6-git.orig/include/asm-sh/delay.h	2007-11-28 13:01:44.000000000 -0500
+++ linux-2.6-git/include/asm-sh/delay.h	2007-11-29 10:28:14.000000000 -0500
@@ -12,7 +12,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 #define udelay(n) (__builtin_constant_p(n) ? \
Index: linux-2.6-git/include/asm-x86/delay.h
===================================================================
--- linux-2.6-git.orig/include/asm-x86/delay.h	2007-11-28 13:01:47.000000000 -0500
+++ linux-2.6-git/include/asm-x86/delay.h	2007-11-29 10:28:14.000000000 -0500
@@ -13,7 +13,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 /* 0x10c7 is 2**32 / 1000000 (rounded up) */
