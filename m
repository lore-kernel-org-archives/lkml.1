Return-Path: <linux-kernel-owner+w=401wt.eu-S1765474AbXEUUEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765474AbXEUUEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758183AbXEUUEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:04:04 -0400
Received: from www.osadl.org ([213.239.205.134]:55003 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757631AbXEUUEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:04:01 -0400
Subject: [PATCH -ak] Fix missing include
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 21 May 2007 22:03:59 +0200
Message-Id: <1179777839.12708.42.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ftp://firstfloor.org/pub/ak/x86_64/quilt/x86_64-2.6.22-rc2-070521-1.bz2

explodes in various places due to missing defines of __cold. We can't
rely on the assumption that linux/compiler.h is included magically
before bug.h is included. Include it explicitely.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6.22-rc2-ak/include/asm-i386/bug.h
===================================================================
--- linux-2.6.22-rc2-ak.orig/include/asm-i386/bug.h
+++ linux-2.6.22-rc2-ak/include/asm-i386/bug.h
@@ -8,6 +8,9 @@
  */
 
 #ifdef CONFIG_BUG
+
+#include <linux/compiler.h>
+
 #define HAVE_ARCH_BUG
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
Index: linux-2.6.22-rc2-ak/include/asm-x86_64/bug.h
===================================================================
--- linux-2.6.22-rc2-ak.orig/include/asm-x86_64/bug.h
+++ linux-2.6.22-rc2-ak/include/asm-x86_64/bug.h
@@ -2,6 +2,9 @@
 #define __ASM_X8664_BUG_H 1
 
 #ifdef CONFIG_BUG
+
+#include <linux/compiler.h>
+
 #define HAVE_ARCH_BUG
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE






