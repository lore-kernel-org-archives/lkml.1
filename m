Return-Path: <linux-kernel-owner+w=401wt.eu-S933570AbZDATna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbZDATna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761992AbZDATnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:43:08 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:64862 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932564AbZDATnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:43:06 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kbuild@vger.kernel.org
Subject: [PATCH 2/5] deb-pkg: fix 'file not found' error when building .deb package for arm
Date: Wed, 1 Apr 2009 21:43:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <200904012133.37387.elendil@planet.nl>
In-Reply-To: <200904012133.37387.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904012143.02998.elendil@planet.nl>
X-OriginalArrivalTime: 01 Apr 2009 19:43:03.0384 (UTC) FILETIME=[12399580:01C9B302]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all architectures prepend the $(boot) path in $(KBUILD_IMAGE).
Allow for that fact in the builddeb script. Example is arm.

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 462ee45..5b1517d 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -41,7 +41,10 @@ if [ "$ARCH" = "um" ] ; then
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
