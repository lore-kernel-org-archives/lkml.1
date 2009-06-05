Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZFEXo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZFEXo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZFEXlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:23 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36390 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZFEXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:09 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Frans Pop <elendil@planet.nl>, Andres Salomon <dilinger@debian.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 09/39] kbuild, deb-pkg: generate debian/copyright file
Date: Sat,  6 Jun 2009 01:42:27 +0200
Message-Id: <1244245377-17441-9-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

On Thursday 23 April 2009, Frans Pop wrote:
Add a basic debian/copyright to the binary packages.

Based on an earlier patch from Maximilian Attems.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: maximilian attems <max@stro.at>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 0449147..122becc 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -15,6 +15,8 @@ set -e
 create_package() {
 	local pname="$1" pdir="$2"
 
+	cp debian/copyright "$pdir/usr/share/doc/$pname/"
+
 	# Fix ownership and permissions
 	chown -R root:root "$pdir"
 	chmod -R go-w "$pdir"
@@ -43,10 +45,10 @@ fi
 
 # Setup the directory structure
 rm -rf "$tmpdir" "$fwdir"
-mkdir -p "$tmpdir/DEBIAN" "$tmpdir/lib" "$tmpdir/boot"
-mkdir -p "$fwdir/DEBIAN" "$fwdir/lib"
+mkdir -p "$tmpdir/DEBIAN" "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
+mkdir -p "$fwdir/DEBIAN" "$fwdir/lib" "$fwdir/usr/share/doc/$fwpackagename"
 if [ "$ARCH" = "um" ] ; then
-	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/share/doc/$packagename" "$tmpdir/usr/bin"
+	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/bin"
 fi
 
 # Build and install the kernel
@@ -103,6 +105,26 @@ linux ($packageversion) unstable; urgency=low
  -- $name  $(date -R)
 EOF
 
+# Generate copyright file
+cat <<EOF > debian/copyright
+This is a packacked upstream version of the Linux kernel.
+
+The sources may be found at most Linux ftp sites, including:
+ftp://ftp.kernel.org/pub/linux/kernel
+
+Copyright: 1991 - 2009 Linus Torvalds and others.
+
+The git repository for mainline kernel development is at:
+git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; version 2 dated June, 1991.
+
+On Debian GNU/Linux systems, the complete text of the GNU General Public
+License version 2 can be found in \`/usr/share/common-licenses/GPL-2'.
+EOF
+
 # Generate a control file
 cat <<EOF > debian/control
 Source: linux
-- 
1.6.3.rc3.40.g75b44

