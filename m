Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZFEXmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZFEXmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZFEXlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:18 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36382 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZFEXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:08 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Frans Pop <elendil@planet.nl>, Andres Salomon <dilinger@debian.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 06/39] kbuild, deb-pkg: allow to specify a custom revision for .deb packages
Date: Sat,  6 Jun 2009 01:42:24 +0200
Message-Id: <1244245377-17441-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

Allow to specify a custom revision for the generated .deb by
exporting the environment variable KDEB_PKGVERSION.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: maximilian attems <max@stro.at>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 5eecbbe..5868c0f 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -26,6 +26,11 @@ create_package() {
 # Some variables and settings used throughout the script
 version=$KERNELRELEASE
 revision=$(cat .version)
+if [ -n "$KDEB_PKGVERSION" ]; then
+	packageversion=$KDEB_PKGVERSION
+else
+	packageversion=$version-$revision
+fi
 tmpdir="$objtree/debian/tmp"
 fwdir="$objtree/debian/fwtmp"
 packagename=linux-$version
@@ -87,7 +92,7 @@ done
 name="Kernel Compiler <$(id -nu)@$(hostname -f)>"
 # Generate a simple changelog template
 cat <<EOF > debian/changelog
-linux ($version-$revision) unstable; urgency=low
+linux ($packageversion) unstable; urgency=low
 
   * A standard release
 
-- 
1.6.3.rc3.40.g75b44

