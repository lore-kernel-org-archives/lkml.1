Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYIXXFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYIXXFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYIXXEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:04:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbYIXXEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:04:53 -0400
Date: Wed, 24 Sep 2008 16:01:20 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
       Jeff Mahoney <jeffm@suse.de>
Subject: [patch 03/04] Staging: add Kconfig entries and Makefile
	infrastructure
Message-ID: <20080924230120.GE27730@suse.de>
References: <20080924224638.514504825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="staging-add-kconfig-entries-and-makefile-infrastructure.patch"
In-Reply-To: <20080924230054.GA27730@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This hooks up the drivers/staging directory to the build system

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/Kconfig          |    2 ++
 drivers/Makefile         |    1 +
 drivers/staging/Kconfig  |   27 +++++++++++++++++++++++++++
 drivers/staging/Makefile |    2 ++
 4 files changed, 32 insertions(+)

--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -101,4 +101,6 @@ source "drivers/auxdisplay/Kconfig"
 source "drivers/uio/Kconfig"
 
 source "drivers/xen/Kconfig"
+
+source "drivers/staging/Kconfig"
 endmenu
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -99,3 +99,4 @@ obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_REGULATOR)		+= regulator/
+obj-$(CONFIG_STAGING)		+= staging/
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
--- /dev/null
+++ b/drivers/staging/Makefile
@@ -0,0 +1,2 @@
+# Makefile for staging directory
+

-- 
