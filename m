Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZFEXls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZFEXls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZFEXlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:12 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45052 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZFEXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:08 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Frans Pop <elendil@planet.nl>, Andres Salomon <dilinger@debian.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 04/39] kbuild, deb-pkg: fix 'file not found' error when building .deb package for arm
Date: Sat,  6 Jun 2009 01:42:22 +0200
Message-Id: <1244245377-17441-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

Not all architectures prepend the $(boot) path in $(KBUILD_IMAGE).
Allow for that fact in the builddeb script. Example is arm.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: maximilian attems <max@stro.at>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index feebd69..4876ff3 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -53,7 +53,10 @@ if [ "$ARCH" = "um" ] ; then
 else 
 	cp System.map "$tmpdir/boot/System.map-$version"
 	cp .config "$tmpdir/boot/config-$version"
-	cp $KBUILD_IMAGE "$tmpdir/boot/vmlinuz-$version"
+	# Not all arches include the boot path in KBUILD_IMAGE
+	if ! cp $KBUILD_IMAGE "$tmpdir/boot/vmlinuz-$version"; then
+		cp arch/$ARCH/boot/$KBUILD_IMAGE "$tmpdir/boot/vmlinuz-$version"
+	fi
 fi
 
 if grep -q '^CONFIG_MODULES=y' .config ; then
-- 
1.6.3.rc3.40.g75b44

