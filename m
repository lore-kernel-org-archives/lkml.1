Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbYKHFp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbYKHFp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 00:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYKHFps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 00:45:48 -0500
Received: from kroah.org ([198.145.64.141]:37127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750971AbYKHFpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 00:45:47 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] Staging: only build the tree if we really want to
Date: Fri,  7 Nov 2008 21:45:42 -0800
Message-Id: <1226123143-28859-1-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081108054511.GA28846@kroah.com>
References: <20081108054511.GA28846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

This Kconfig change allows the common 'make allmodconfig' and
'make allyesconfig' build options to skip the staging tree, which is
probably what you want to have happen anyway.

This makes the linux-next developer's life a lot easier so he doesn't
have to worry about changes that break the staging tree, that's for me
to worry about...

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/Kconfig |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index e1654f5..0a49cd7 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -21,7 +21,23 @@ menuconfig STAGING
 
 	  If in doubt, say N here.
 
-if STAGING
+
+config STAGING_EXCLUDE_BUILD
+	bool "Exclude Staging drivers from being built"
+	default y
+	---help---
+	  Are you sure you really want to build the staging drivers?
+	  They taint your kernel, don't live up to the normal Linux
+	  kernel quality standards, are a bit crufty around the edges,
+	  and might go off and kick your dog when you aren't paying
+	  attention.
+
+	  Say N here to be able to select and build the Staging drivers.
+	  This option is primarily here to prevent them from being built
+	  when selecting 'make allyesconfg' and 'make allmodconfig' so
+	  don't be all that put off, your dog will be just fine.
+
+if !STAGING_EXCLUDE_BUILD
 
 source "drivers/staging/et131x/Kconfig"
 
@@ -45,4 +61,4 @@ source "drivers/staging/at76_usb/Kconfig"
 
 source "drivers/staging/poch/Kconfig"
 
-endif # STAGING
+endif # !STAGING_EXCLUDE_BUILD
-- 
1.5.6

