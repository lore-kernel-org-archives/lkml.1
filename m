Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbXAXWgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbXAXWgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXAXWgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:36:46 -0500
Received: from raven.upol.cz ([158.194.120.4]:43878 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932835AbXAXWgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:36:43 -0500
To: Rob Landley <rob@landley.net>, Andrew Morton <akpm@osdl.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [patch, rft] scripts/gen_initramfs_list.sh: replace gawk with shell, whitespace cleanup
In-Reply-To: <E1H9pHf-0002Iu-4D@flower>
References: <200701151624.18033.rob@landley.net> <20070115221146.GA12698@uranus.ravnborg.org> <20070123164944.db8acbad.akpm@osdl.org> <200701241230.40996.rob@landley.net> <E1H9pHf-0002Iu-4D@flower>
Organization: Palacky University in Olomouc, experimental physics department.
Date: Wed, 24 Jan 2007 22:44:34 +0000
Message-Id: <E1H9qr4-0002Nu-RL@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/gen_initramfs_list.sh: replace gawk with shell, whitespace cleanup

Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
---
-o--=O`C
 #oo'L O
<___=E M

--- linux~2.6.20-rc5/scripts/gen_initramfs_list.sh~	2007-01-12 19:54:26.000000000 +0100
+++ linux~2.6.20-rc5/scripts/gen_initramfs_list.sh	2007-01-24 22:54:49.721441250 +0100
@@ -1,5 +1,6 @@
 #!/bin/bash
 # Copyright (C) Martin Schlemmer <azarah@nosferatu.za.org>
-# Copyright (c) 2006           Sam Ravnborg <sam@ravnborg.org>
+# Copyright (C) 2006 Sam Ravnborg <sam@ravnborg.org>
+# Copyright (C) 2007 Oleg Verych <olecom@flower.upol.cz>
 #
 # Released under the terms of the GNU GPL
@@ -18,13 +19,13 @@
 $0 [-o <file>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} ...
 	-o <file>      Create gzipped initramfs file named <file> using
-	               gen_init_cpio and gzip
+		       gen_init_cpio and gzip
 	-u <uid>       User ID to map to user ID 0 (root).
-	               <uid> is only meaningful if <cpio_source>
-	               is a directory.
+		       <uid> is only meaningful if <cpio_source>
+		       is a directory.
 	-g <gid>       Group ID to map to group ID 0 (root).
-	               <gid> is only meaningful if <cpio_source>
-	               is a directory.
+		       <gid> is only meaningful if <cpio_source>
+		       is a directory.
 	<cpio_source>  File list or directory for cpio archive.
-	               If <cpio_source> is a .cpio file it will be used
+		       If <cpio_source> is a .cpio file it will be used
 		       as direct input to initramfs.
 	-d             Output the default cpio list.
@@ -95,4 +96,11 @@
 }
 
+# accessing fields, as in `awk'
+# $1 - field number; rest is argument string
+pos_param() {
+	shift $1
+	echo $1
+}
+
 # for each file print a line in following format
 # <filetype> <name> <path to file> <octal mode> <uid> <gid>
@@ -120,9 +128,7 @@
 			;;
 		"nod")
-			local dev_type=
-			local maj=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{sub(/,/, "", $5); print $5}')
-			local min=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{print $6}')
+			maj=`pos_param 5 $(LC_ALL=C ls -l "${location}")`
+			min=`pos_param 6 $(LC_ALL=C ls -l "${location}")`
+			maj=${maj%,}
 
 			if [ -b "${location}" ]; then
@@ -134,6 +140,5 @@
 			;;
 		"slink")
-			local target=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{print $11}')
+			target=`pos_param 11 $(LC_ALL=C ls -l "${location}")`
 			str="${ftype} ${name} ${target} ${str}"
 			;;
