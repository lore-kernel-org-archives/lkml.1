Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbXEWHCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbXEWHCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbXEWHCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:02:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54993 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005AbXEWHCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:02:04 -0400
Date: Wed, 23 May 2007 17:01:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Introduce CONFIG_VIRT_TO_BUS
Message-Id: <20070523170155.2cb9eff8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make some offending drivers depend on it and set
CONFIG_ARCH_NO_VIRT_TO_BUS for ppc64 so that we don't build those drivers.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/Kconfig        |    3 +++
 drivers/atm/Kconfig         |    8 ++++----
 drivers/block/Kconfig       |    2 +-
 drivers/message/i2o/Kconfig |    2 +-
 drivers/net/wan/Kconfig     |    2 +-
 drivers/scsi/Kconfig        |    2 +-
 mm/Kconfig                  |    4 ++++
 sound/oss/Kconfig           |    6 +++---
 8 files changed, 18 insertions(+), 11 deletions(-)

This gets PowerPC allmodconfig and allyesconfig much closer to building.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 56d3c0d..6d6c5ca 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -66,6 +66,9 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config ARCH_NO_VIRT_TO_BUS
+	def_bool PPC64
+
 config PPC
 	bool
 	default y
diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index f5a47a4..11c2741 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -142,7 +142,7 @@ config ATM_ENI_BURST_RX_2W
 
 config ATM_FIRESTREAM
 	tristate "Fujitsu FireStream (FS50/FS155) "
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	help
 	  Driver for the Fujitsu FireStream 155 (MB86697) and
 	  FireStream 50 (MB86695) ATM PCI chips.
@@ -152,7 +152,7 @@ config ATM_FIRESTREAM
 
 config ATM_ZATM
 	tristate "ZeitNet ZN1221/ZN1225"
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	help
 	  Driver for the ZeitNet ZN1221 (MMF) and ZN1225 (UTP-5) 155 Mbps ATM
 	  adapters.
@@ -240,7 +240,7 @@ config ATM_IDT77252_USE_SUNI
 
 config ATM_AMBASSADOR
 	tristate "Madge Ambassador (Collage PCI 155 Server)"
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	select BITREVERSE
 	help
 	  This is a driver for ATMizer based ATM card produced by Madge
@@ -265,7 +265,7 @@ config ATM_AMBASSADOR_DEBUG
 
 config ATM_HORIZON
 	tristate "Madge Horizon [Ultra] (Collage PCI 25 and Collage PCI 155 Client)"
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	help
 	  This is a driver for the Horizon chipset ATM adapter cards once
 	  produced by Madge Networks Ltd. Say Y (or M to compile as a module
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index b4c8319..0c16f84 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -141,7 +141,7 @@ source "drivers/block/paride/Kconfig"
 
 config BLK_CPQ_DA
 	tristate "Compaq SMART2 support"
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	help
 	  This is the driver for Compaq Smart Array controllers.  Everyone
 	  using these boards should say Y here.  See the file
diff --git a/drivers/message/i2o/Kconfig b/drivers/message/i2o/Kconfig
index f4ac21e..01379ae 100644
--- a/drivers/message/i2o/Kconfig
+++ b/drivers/message/i2o/Kconfig
@@ -57,7 +57,7 @@ config I2O_EXT_ADAPTEC_DMA64
 
 config I2O_CONFIG
 	tristate "I2O Configuration support"
-	depends on I2O
+	depends on I2O && VIRT_TO_BUS
 	---help---
 	  Say Y for support of the configuration interface for the I2O adapters.
 	  If you have a RAID controller from Adaptec and you want to use the
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 4fc8681..a3df09e 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -61,7 +61,7 @@ config COSA
 #
 config LANMEDIA
 	tristate "LanMedia Corp. SSI/V.35, T1/E1, HSSI, T3 boards"
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	---help---
 	  Driver for the following Lan Media family of serial boards:
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d28c14e..2c2b7ac 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -539,7 +539,7 @@ config SCSI_HPTIOP
 
 config SCSI_BUSLOGIC
 	tristate "BusLogic SCSI support"
-	depends on (PCI || ISA || MCA) && SCSI && ISA_DMA_API
+	depends on (PCI || ISA || MCA) && SCSI && ISA_DMA_API && VIRT_TO_BUS
 	---help---
 	  This is support for BusLogic MultiMaster and FlashPoint SCSI Host
 	  Adapters. Consult the SCSI-HOWTO, available from
diff --git a/mm/Kconfig b/mm/Kconfig
index 8ac412b..40559cf 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -168,3 +168,7 @@ config NR_QUICK
 	depends on QUICKLIST
 	default "2" if (SUPERH && !SUPERH64)
 	default "1"
+
+config VIRT_TO_BUS
+	def_bool y
+	depends on !ARCH_NO_VIRT_TO_BUS
diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index 4b30ae6..be5801f 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -348,7 +348,7 @@ config MSND_FIFOSIZE
 
 config SOUND_VIA82CXXX
 	tristate "VIA 82C686 Audio Codec"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
+	depends on SOUND_PRIME && PCI && OSS_OBSOLETE && VIRT_TO_BUS
 	help
 	  Say Y here to include support for the audio codec found on VIA
 	  82Cxxx-based chips. Typically these are built into a motherboard.
@@ -368,7 +368,7 @@ config MIDI_VIA82CXXX
 
 config SOUND_OSS
 	tristate "OSS sound modules"
-	depends on SOUND_PRIME && ISA_DMA_API
+	depends on SOUND_PRIME && ISA_DMA_API && VIRT_TO_BUS
 	help
 	  OSS is the Open Sound System suite of sound card drivers.  They make
 	  sound programming easier since they provide a common API.  Say Y or
@@ -416,7 +416,7 @@ config SOUND_CS4232
 
 config SOUND_SSCAPE
 	tristate "Ensoniq SoundScape support"
-	depends on SOUND_OSS
+	depends on SOUND_OSS && VIRT_TO_BUS
 	help
 	  Answer Y if you have a sound card based on the Ensoniq SoundScape
 	  chipset. Such cards are being manufactured at least by Ensoniq, Spea
-- 
1.5.1.4

