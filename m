Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbXKUJEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbXKUJEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 04:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbXKUJEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 04:04:11 -0500
Received: from nic2.axis.se ([193.13.178.10]:48082 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbXKUJEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 04:04:07 -0500
Date: Wed, 21 Nov 2007 10:03:46 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       Jan Dittmer <jdi@l4x.org>
Subject: [PATCH] CRIS: avoid using arch links in Kconfig
Message-ID: <20071121090346.GD14797@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Improve including of architecture dependent Kconfig files.

- Always include the architecture dependent Kconfig files.
- Wrap architecture dependent Kconfig files inside an appropriate
  "if ETRAX_ARCH_Vxx" block.

This makes it possible to run the configuration even without the arch links,
which are created later in the build process.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 Kconfig                  |    5 +++--
 arch-v10/Kconfig         |    4 ++++
 arch-v10/drivers/Kconfig |    4 ++++
 arch-v32/Kconfig         |    4 ++++
 arch-v32/drivers/Kconfig |    4 ++++
 5 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 222da15..d296e55 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -150,6 +150,7 @@ config ETRAX_FLASH_BUSWIDTH
 	  Width in bytes of the Flash bus (1, 2 or 4). Is usually 2.
 
 source arch/cris/arch-v10/Kconfig
+source arch/cris/arch-v32/Kconfig
 
 endmenu
 
@@ -157,8 +158,8 @@ source "net/Kconfig"
 
 # bring in ETRAX built-in drivers
 menu "Drivers for built-in interfaces"
-# arch/cris/arch is a symlink to correct arch (arch-v10 or arch-v32)
-source arch/cris/arch/drivers/Kconfig
+source arch/cris/arch-v10/drivers/Kconfig
+source arch/cris/arch-v32/drivers/Kconfig
 
 endmenu
 
diff --git a/arch/cris/arch-v10/Kconfig b/arch/cris/arch-v10/Kconfig
index f1ce6f6..1d61fae 100644
--- a/arch/cris/arch-v10/Kconfig
+++ b/arch/cris/arch-v10/Kconfig
@@ -1,3 +1,5 @@
+if ETRAX_ARCH_V10
+
 # ETRAX 100LX v1 has a MMU "feature" requiring a low mapping
 config CRIS_LOW_MAP
 	bool
@@ -451,3 +453,5 @@ config ETRAX_POWERBUTTON_BIT
 	default "25"
 	help
 	  Configure where power button is connected.
+
+endif
diff --git a/arch/cris/arch-v10/drivers/Kconfig b/arch/cris/arch-v10/drivers/Kconfig
index faf8b4d..6011ff4 100644
--- a/arch/cris/arch-v10/drivers/Kconfig
+++ b/arch/cris/arch-v10/drivers/Kconfig
@@ -1,3 +1,5 @@
+if ETRAX_ARCH_V10
+
 config ETRAX_ETHERNET
 	bool "Ethernet support"
 	depends on ETRAX_ARCH_V10
@@ -845,3 +847,5 @@ config ETRAX_DS1302_TRICKLE_CHARGE
 	  1 = 2kohm, 2 = 4kohm, 3 = 4kohm
 	  4 = 1 diode, 8 = 2 diodes
 	  Allowed values are (increasing current): 0, 11, 10, 9, 7, 6, 5
+
+endif
diff --git a/arch/cris/arch-v32/Kconfig b/arch/cris/arch-v32/Kconfig
index 4f79d8e..d8acaa9 100644
--- a/arch/cris/arch-v32/Kconfig
+++ b/arch/cris/arch-v32/Kconfig
@@ -1,3 +1,5 @@
+if ETRAX_ARCH_V32
+
 config ETRAX_DRAM_VIRTUAL_BASE
 	hex
 	depends on ETRAX_ARCH_V32
@@ -294,3 +296,5 @@ config ETRAX_DEF_GIO_PE_OUT
 	help
 	  Configures the initial data for the general port E bits.  Most
 	  products should use 00000 here.
+
+endif
diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index 7f72d7c..7952ee8 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -1,3 +1,5 @@
+if ETRAX_ARCH_V32
+
 config ETRAX_ETHERNET
 	bool "Ethernet support"
 	depends on ETRAX_ARCH_V32
@@ -622,3 +624,5 @@ config ETRAX_STREAMCOPROC
 	help
 	  This option enables a driver for the stream co-processor
 	  for cryptographic operations.
+
+endif

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
