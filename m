Return-Path: <linux-kernel-owner+w=401wt.eu-S934789AbXJOSoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789AbXJOSoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933960AbXJOSeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:34:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:47970 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933946AbXJOSer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:34:47 -0400
Message-ID: <4713B29B.4020108@windriver.com>
Date: Mon, 15 Oct 2007 13:34:03 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 20/21] KGDB: Add ability to unoptimize module compiles and
 dwarf2 asm
Content-Type: multipart/mixed;
 boundary="------------010409090305030507040509"
X-OriginalArrivalTime: 15 Oct 2007 18:34:47.0110 (UTC) FILETIME=[10114660:01C80F5A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010409090305030507040509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------010409090305030507040509
Content-Type: text/x-patch;
 name="asm_debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="asm_debug.patch"

asm_debug.patch

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] Add ability to unoptimize module compiles and dwarf2 asm

This patch adds in the ability to unoptimize a single kernel module to
make source stepping more linear and not optimize out variables that
the developer might like to inspect.  It used with adding
COPTIMIZE=-O0 to the build line.

Also when creating a debug kernel add in dwarf2 sections for the
assembled code.  This makes source stepping the assembly files
possible as well as having references into the .S files in the back
trace information.  The -gdwarf2 was chosen to work around any
problems with the stabs assembly sections.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Makefile |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6-kgdb/Makefile
===================================================================
--- linux-2.6-kgdb.orig/Makefile
+++ linux-2.6-kgdb/Makefile
@@ -483,10 +483,14 @@ endif # $(dot-config)
 all: vmlinux
 
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
-CFLAGS		+= -Os
+COPTIMIZE	= -Os
 else
-CFLAGS		+= -O2
+COPTIMIZE	= -O2
 endif
+# COPTIMIZE may be overridden on the make command line with
+# 	make ... COPTIMIZE=""
+# The resulting object may be easier to debug with KGDB
+CFLAGS		+= $(COPTIMIZE)
 
 include $(srctree)/arch/$(ARCH)/Makefile
 
@@ -498,6 +502,7 @@ endif
 
 ifdef CONFIG_DEBUG_INFO
 CFLAGS		+= -g
+AFLAGS		+= -gdwarf2
 endif
 
 # Force gcc to behave correct even for buggy distributions

--------------010409090305030507040509--
