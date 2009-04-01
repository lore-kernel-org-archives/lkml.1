Return-Path: <linux-kernel-owner+w=401wt.eu-S933759AbZDATnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759AbZDATnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760427AbZDATmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:42:50 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:59669 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758915AbZDATmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:42:49 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kbuild@vger.kernel.org
Subject: [PATCH 1/5] deb-pkg: minor general improvements in builddeb script
Date: Wed, 1 Apr 2009 21:42:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <200904012133.37387.elendil@planet.nl>
In-Reply-To: <200904012133.37387.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904012142.46145.elendil@planet.nl>
X-OriginalArrivalTime: 01 Apr 2009 19:42:46.0764 (UTC) FILETIME=[085192C0:01C9B302]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* minor coding style improvements
* typo fix in leading comment
* better changelog entry
* minor improvements in package descriptions

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 1264b8e..462ee45 100644
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
@@ -71,13 +71,13 @@ name="Kernel Compiler <$(id -nu)@$(hostname -f)>"
 cat <<EOF > debian/changelog
 linux ($version-$revision) unstable; urgency=low
 
-  * A standard release
+  * Custom built Linux kernel.
 
  -- $name  $(date -R)
 EOF
 
 # Generate a control file
-if [ "$ARCH" == "um" ]; then
+if [ "$ARCH" = "um" ]; then
 
 cat <<EOF > debian/control
 Source: linux
@@ -97,7 +97,7 @@ Description: User Mode Linux kernel, version $version
  many other things.
  .
  This package contains the Linux kernel, modules and corresponding other
- files version $version
+ files. Version: $version.
 EOF
 
 else
@@ -114,7 +114,7 @@ Suggests: $fwpackagename
 Architecture: any
 Description: Linux kernel, version $version
  This package contains the Linux kernel, modules and corresponding other
- files version $version
+ files. Version: $version.
 EOF
 fi
 
@@ -143,4 +143,3 @@ dpkg-gencontrol -isp -p$packagename
 dpkg --build "$tmpdir" ..
 
 exit 0
-
