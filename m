Return-Path: <linux-kernel-owner+w=401wt.eu-S964783AbXAXXVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783AbXAXXVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 18:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964782AbXAXXVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 18:21:40 -0500
Received: from raven.upol.cz ([158.194.120.4]:45469 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964783AbXAXXVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 18:21:39 -0500
To: Rob Landley <rob@landley.net>, Andrew Morton <akpm@osdl.org>,
       DJ Barrow <djbarrow@de.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [patch, rft] scripts/makelst: replace gawk with shell, update
In-Reply-To: <E1H9pHf-0002Iu-4D@flower>
References: <200701151624.18033.rob@landley.net> <20070115221146.GA12698@uranus.ravnborg.org> <20070123164944.db8acbad.akpm@osdl.org> <200701241230.40996.rob@landley.net> <E1H9pHf-0002Iu-4D@flower>
Organization: Palacky University in Olomouc, experimental physics department.
Date: Wed, 24 Jan 2007 23:30:01 +0000
Message-Id: <E1H9rZ3-0002T5-Po@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/makelst: replace gawk with shell, update

Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
---
-o--=O`C
 #oo'L O
<___=E M

--- linux~2.6.20-rc5/scripts/makelst~	2007-01-12 19:54:26.000000000 +0100
+++ linux~2.6.20-rc5/scripts/makelst	2007-01-24 23:21:33.273657000 +0100
@@ -1,19 +1,22 @@
-#!/bin/bash
+#!/bin/sh
 # A script to dump mixed source code & assembly
 # with correct relocations from System.map
-# Requires the following lines in Rules.make.
-# Author(s): DJ Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com) 
-#            William Stearns <wstearns@pobox.com>
+# Requires the following lines in makefile:
 #%.lst: %.c
 #	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$@) -g -c -o $*.o $<
-#	$(TOPDIR)/scripts/makelst $*.o $(TOPDIR)/System.map $(OBJDUMP)
+#	$(srctree)/scripts/makelst $*.o $(srctree)/System.map $(OBJDUMP)
 #
-#    Copyright (C) 2000 IBM Corporation
-#    Author(s): DJ Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com) 
+# Copyright (C) 2000 IBM Corporation
+# Author(s): DJ Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com)
+#            William Stearns <wstearns@pobox.com>
 #
 
+pos_param() {
+  shift $1 ; echo $1
+}
+
 t1=`$3 --syms $1 | grep .text | grep " F " | head -n 1`
 if [ -n "$t1" ]; then
-  t2=`echo $t1 | gawk '{ print $6 }'`
+  t2=`pos_param 6 $t1`
   if [ ! -r $2 ]; then
     echo "No System.map" >&2
@@ -21,6 +24,6 @@
   else
     t3=`grep $t2 $2`
-    t4=`echo $t3 | gawk '{ print $1 }'`
-    t5=`echo $t1 | gawk '{ print $1 }'`
+    t4=`pos_param 1 $t3`
+    t5=`pos_param 1 $t1`
     t6=`echo $t4 - $t5 | tr a-f A-F`
     t7=`( echo  ibase=16 ; echo $t6 ) | bc`

