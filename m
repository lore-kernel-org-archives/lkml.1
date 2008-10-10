Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYJJWqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYJJWqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYJJWp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:45:58 -0400
Received: from kroah.org ([198.145.64.141]:39630 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753464AbYJJWp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:45:57 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/23] Staging: add Kconfig entries and Makefile infrastructure
Date: Fri, 10 Oct 2008 15:42:27 -0700
Message-Id: <1223678567-30143-3-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081010224130.GA30117@kroah.com>
References: <20081010224130.GA30117@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

This hooks up the drivers/staging directory to the build system

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/Kconfig          |    2 ++
 drivers/Makefile         |    1 +
 drivers/staging/Kconfig  |   27 +++++++++++++++++++++++++++
 drivers/staging/Makefile |    2 ++
 4 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/Kconfig
 create mode 100644 drivers/staging/Makefile

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 59f33fa..d19b6f5 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -101,4 +101,6 @@ source "drivers/auxdisplay/Kconfig"
 source "drivers/uio/Kconfig"
 
 source "drivers/xen/Kconfig"
+
+source "drivers/staging/Kconfig"
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 2735bde..46c8681 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -99,3 +99,4 @@ obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_REGULATOR)		+= regulator/
+obj-$(CONFIG_STAGING)		+= staging/
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
new file mode 100644
index 0000000..84832fe
--- /dev/null
+++ b/drivers/staging/Kconfig
@@ -0,0 +1,27 @@
+menuconfig STAGING
+	bool "Staging drivers"
+	default n
+	---help---
+	  This option allows you to select a number of drivers that are
+	  not of the "normal" Linux kernel quality level.  These drivers
+	  are placed here in order to get a wider audience for use of
+	  them.  Please note that these drivers are under heavy
+	  development, may or may not work, and may contain userspace
+	  interfaces that most likely will be changed in the near
+	  future.
+
+	  Using any of these drivers will taint your kernel which might
+	  affect support options from both the community, and various
+	  commercial support orginizations.
+
+	  If you wish to work on these drivers, to help improve them, or
+	  to report problems you have with them, please see the
+	  driver_name.README file in the drivers/staging/ directory to
+	  see what needs to be worked on, and who to contact.
+
+	  If in doubt, say N here.
+
+if STAGING
+
+
+endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
new file mode 100644
index 0000000..ceb0328
--- /dev/null
+++ b/drivers/staging/Makefile
@@ -0,0 +1,2 @@
+# Makefile for staging directory
+
-- 
1.6.0.2

