Return-Path: <linux-kernel-owner+w=401wt.eu-S1765235AbYBMKSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765235AbYBMKSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbYBMKSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:18:18 -0500
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:18651 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022AbYBMKSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:18:16 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: allow to specify a custom revision for .deb packages
Date: Wed, 13 Feb 2008 11:18:11 +0100
User-Agent: KMail/1.9.7
Cc: sam@ravnborg.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131118.11413.elendil@planet.nl>
X-OriginalArrivalTime: 13 Feb 2008 10:18:13.0562 (UTC) FILETIME=[BDB661A0:01C86E29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

Allow to specify a custom revision for the generated .deb package
by exporting the environment variable KERNELDEBREVISION.

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index ba6bf5d..2577dec 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -14,6 +14,11 @@ set -e
 # Some variables and settings used throughout the script
 version=$KERNELRELEASE
 revision=`cat .version`
+if [ x"$KERNELDEBREVISION" = x ]; then
+	debrevision=$version-$revision
+else
+	debrevision=$KERNELDEBREVISION
+fi
 tmpdir="$objtree/debian/tmp"
 packagename=linux-$version
 
@@ -66,7 +71,7 @@ done
 name="Kernel Compiler <$(id -nu)@$(hostname -f)>"
 # Generate a simple changelog template
 cat <<EOF > debian/changelog
-linux ($version-$revision) unstable; urgency=low
+linux ($debrevision) unstable; urgency=low
 
   * A standard release
 
