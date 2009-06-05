Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZFEXl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZFEXl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZFEXlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:11 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45048 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbZFEXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:08 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Frans Pop <elendil@planet.nl>, Andres Salomon <dilinger@debian.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 02/39] kbuild, deb-pkg: minor general improvements in builddeb script
Date: Sat,  6 Jun 2009 01:42:20 +0200
Message-Id: <1244245377-17441-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

Minor coding style improvements and typo fix in leading comment.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Andres Salomon <dilinger@debian.org>
Acked-by: maximilian attems <max@stro.at>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 1264b8e..eff7f9d 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -4,7 +4,7 @@
 # Copyright 2003 Wichert Akkerman <wichert@wiggy.net>
 #
 # Simple script to generate a deb package for a Linux kernel. All the
-# complexity of what to do with a kernel after it is installer or removed
+# complexity of what to do with a kernel after it is installed or removed
 # is left to other scripts and packages: they can install scripts in the
 # /etc/kernel/{pre,post}{inst,rm}.d/ directories that will be called on
 # package install and removal.
@@ -13,13 +13,13 @@ set -e
 
 # Some variables and settings used throughout the script
 version=$KERNELRELEASE
-revision=`cat .version`
+revision=$(cat .version)
 tmpdir="$objtree/debian/tmp"
 fwdir="$objtree/debian/fwtmp"
 packagename=linux-$version
 fwpackagename=linux-firmware-image
 
-if [ "$ARCH" == "um" ] ; then
+if [ "$ARCH" = "um" ] ; then
 	packagename=user-mode-linux-$version
 fi
 
@@ -27,12 +27,12 @@ fi
 rm -rf "$tmpdir" "$fwdir"
 mkdir -p "$tmpdir/DEBIAN" "$tmpdir/lib" "$tmpdir/boot"
 mkdir -p "$fwdir/DEBIAN" "$fwdir/lib"
-if [ "$ARCH" == "um" ] ; then
+if [ "$ARCH" = "um" ] ; then
 	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/share/doc/$packagename" "$tmpdir/usr/bin"
 fi
 
 # Build and install the kernel
-if [ "$ARCH" == "um" ] ; then
+if [ "$ARCH" = "um" ] ; then
 	$MAKE linux
 	cp System.map "$tmpdir/usr/lib/uml/modules/$version/System.map"
 	cp .config "$tmpdir/usr/share/doc/$packagename/config"
@@ -46,7 +46,7 @@ fi
 
 if grep -q '^CONFIG_MODULES=y' .config ; then
 	INSTALL_MOD_PATH="$tmpdir" make KBUILD_SRC= modules_install
-	if [ "$ARCH" == "um" ] ; then
+	if [ "$ARCH" = "um" ] ; then
 		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
 		rmdir "$tmpdir/lib/modules/$version"
 	fi
@@ -77,9 +77,8 @@ linux ($version-$revision) unstable; urgency=low
 EOF
 
 # Generate a control file
-if [ "$ARCH" == "um" ]; then
-
-cat <<EOF > debian/control
+if [ "$ARCH" = "um" ]; then
+	cat <<EOF > debian/control
 Source: linux
 Section: base
 Priority: optional
@@ -101,7 +100,7 @@ Description: User Mode Linux kernel, version $version
 EOF
 
 else
-cat <<EOF > debian/control
+	cat <<EOF > debian/control
 Source: linux
 Section: base
 Priority: optional
@@ -116,6 +115,7 @@ Description: Linux kernel, version $version
  This package contains the Linux kernel, modules and corresponding other
  files version $version
 EOF
+
 fi
 
 # Fix some ownership and permissions
@@ -143,4 +143,3 @@ dpkg-gencontrol -isp -p$packagename
 dpkg --build "$tmpdir" ..
 
 exit 0
-
-- 
1.6.3.rc3.40.g75b44

