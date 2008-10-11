Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbYJKGlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbYJKGlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYJKGhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:23 -0400
Received: from vms172071pub.verizon.net ([206.46.172.71]:52181 "EHLO
	vms172071pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYJKGhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:14 -0400
Date: Sat, 11 Oct 2008 02:36:28 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 68/85] PNP: remove old CONFIG_PNP_DEBUG option
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <ac88a8f3f7df04774b386ddaf586040adb819b58.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bjorn.helgaas@hp.com>

CONFIG_PNP_DEBUG is no longer used to turn on dev_dbg() in PNP,
since we have pnp_dbg() which can be enabled at boot-time, so
this patch removes the config option.

Note that pnp_dock_event() checks "#ifdef DEBUG".  But there's
never been a clear path for enabling that via configgery.  It
happened that CONFIG_PNP_DEBUG enabled it after 1bd17e63a068db6,
but that was accidental and only in 2.6.26.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/pnp/Kconfig          |    6 ------
 drivers/pnp/Makefile         |    4 ----
 drivers/pnp/isapnp/Makefile  |    4 ----
 drivers/pnp/pnpacpi/Makefile |    4 ----
 drivers/pnp/pnpbios/Makefile |    4 ----
 5 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/pnp/Kconfig b/drivers/pnp/Kconfig
index 8a3237f..2a37b3f 100644
--- a/drivers/pnp/Kconfig
+++ b/drivers/pnp/Kconfig
@@ -36,12 +36,6 @@ config PNP_DEBUG_MESSAGES
 
 if PNP
 
-config PNP_DEBUG
-	bool "PnP Debug Messages"
-	help
-	  Say Y if you want the Plug and Play Layer to print debug messages.
-	  This is useful if you are developing a PnP driver or troubleshooting.
-
 comment "Protocols"
 
 source "drivers/pnp/isapnp/Kconfig"
diff --git a/drivers/pnp/Makefile b/drivers/pnp/Makefile
index 26f5abc..a381a92 100644
--- a/drivers/pnp/Makefile
+++ b/drivers/pnp/Makefile
@@ -7,7 +7,3 @@ obj-y		:= core.o card.o driver.o resource.o manager.o support.o interface.o quir
 obj-$(CONFIG_PNPACPI)		+= pnpacpi/
 obj-$(CONFIG_PNPBIOS)		+= pnpbios/
 obj-$(CONFIG_ISAPNP)		+= isapnp/
-
-ifeq ($(CONFIG_PNP_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
diff --git a/drivers/pnp/isapnp/Makefile b/drivers/pnp/isapnp/Makefile
index 3e38f06..cac18bb 100644
--- a/drivers/pnp/isapnp/Makefile
+++ b/drivers/pnp/isapnp/Makefile
@@ -5,7 +5,3 @@
 isapnp-proc-$(CONFIG_PROC_FS) = proc.o
 
 obj-y := core.o compat.o $(isapnp-proc-y)
-
-ifeq ($(CONFIG_PNP_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
diff --git a/drivers/pnp/pnpacpi/Makefile b/drivers/pnp/pnpacpi/Makefile
index 2d7a1e6..905326f 100644
--- a/drivers/pnp/pnpacpi/Makefile
+++ b/drivers/pnp/pnpacpi/Makefile
@@ -3,7 +3,3 @@
 #
 
 obj-y := core.o rsparser.o
-
-ifeq ($(CONFIG_PNP_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
diff --git a/drivers/pnp/pnpbios/Makefile b/drivers/pnp/pnpbios/Makefile
index 310e2b3..3cd3ed7 100644
--- a/drivers/pnp/pnpbios/Makefile
+++ b/drivers/pnp/pnpbios/Makefile
@@ -5,7 +5,3 @@
 pnpbios-proc-$(CONFIG_PNPBIOS_PROC_FS) = proc.o
 
 obj-y := core.o bioscalls.o rsparser.o $(pnpbios-proc-y)
-
-ifeq ($(CONFIG_PNP_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
-- 
1.5.5.1

