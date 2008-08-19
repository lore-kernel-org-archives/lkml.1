Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYHSW5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYHSW5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYHSWx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:53:58 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:47955 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbYHSWxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:53:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 8/8] PNP: remove old CONFIG_PNP_DEBUG option
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 16:53:52 -0600
Message-ID: <20080819225352.28206.87012.stgit@tigger.helgaas>
In-Reply-To: <20080819225310.28206.1011.stgit@tigger.helgaas>
References: <20080819225310.28206.1011.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CONFIG_PNP_DEBUG is no longer used to turn on dev_dbg() in PNP,
since we have pnp_dbg() which can be enabled at boot-time, so
this patch removes the config option.

Note that pnp_dock_event() checks "#ifdef DEBUG".  But there's
never been a clear path for enabling that via configgery.  It
happened that CONFIG_PNP_DEBUG enabled it after 1bd17e63a068db6,
but that was accidental and only in 2.6.26.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
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

