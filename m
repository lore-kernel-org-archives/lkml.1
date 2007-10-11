Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbXJKWjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbXJKWjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXJKWjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:39:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:37967 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbXJKWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RcavLsDdy0QUOC0JLcRMflWyYAS/heot73pDkT0woXBuR8RN0C9c8iW1YviGbc6rX8ido4HydAu9kfasylHueNrRj4SB5slusvIozBAO9szSBAsXcbXqJLyxsWpmibV7VpjxM/xyC9AR+s6zQM8CLSPoprimRhvui479Hidx17Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates (part 1)
Date: Fri, 12 Oct 2007 00:34:48 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120034.49730.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


What's in:

* platform IDE host driver
  (Anton Vorontsov <avorontsov@ru.mvista.com>)

* hook ACPI _PSx method to IDE power on/off
  (Shaohua Li <shaohua.li@intel.com>)

* support for ATI SB700 in combined mode
  (Shane Huang <Shane.Huang@amd.com>)

* various host driver fixes: hpt366, pdc202xx_new, jmicron, amd74xx,
  via82cxxx, sgiioc4, icside, ide-pmac, siimage...
  (Sergei, Tejun and me)

* move all mode limiting and the best PIO mode selection logic from
  host drivers to the core code - this greatly reduces complexity,
  kills some duplicated code and fixes a bunch of bugs along the way

* Kconfig facelift - as a result of this change users have three less
  config options to worry about (BLK_DEV_IDEPCI, BLK_DEV_IDEDMA_PCI
  and IDE_CHIPSETS) and can just select host drivers that they need


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/acpi/bus.c                |    4 +-
 drivers/ide/Kconfig               |  110 ++++++++++++----------
 drivers/ide/arm/icside.c          |   29 ++----
 drivers/ide/cris/ide-cris.c       |   13 +--
 drivers/ide/ide-acpi.c            |   42 +++++++++
 drivers/ide/ide-dma.c             |   48 +++++++---
 drivers/ide/ide-io.c              |   39 +++++++-
 drivers/ide/ide-iops.c            |    6 -
 drivers/ide/ide-lib.c             |   85 +++++++++++------
 drivers/ide/ide-probe.c           |    6 +-
 drivers/ide/ide.c                 |   20 +++-
 drivers/ide/legacy/Makefile       |    2 +
 drivers/ide/legacy/ali14xx.c      |   10 +--
 drivers/ide/legacy/dtc2278.c      |    6 +-
 drivers/ide/legacy/ht6560b.c      |   11 +-
 drivers/ide/legacy/ide_platform.c |  182 +++++++++++++++++++++++++++++++++++++
 drivers/ide/legacy/qd65xx.c       |   60 +++++++------
 drivers/ide/legacy/umc8672.c      |    7 +-
 drivers/ide/mips/au1xxx-ide.c     |   17 +---
 drivers/ide/pci/aec62xx.c         |   13 +--
 drivers/ide/pci/alim15x3.c        |   47 +++++-----
 drivers/ide/pci/amd74xx.c         |   29 ++----
 drivers/ide/pci/atiixp.c          |   22 ++---
 drivers/ide/pci/cmd640.c          |   35 ++++----
 drivers/ide/pci/cmd64x.c          |   49 ++++------
 drivers/ide/pci/cs5520.c          |   57 ++++-------
 drivers/ide/pci/cs5530.c          |   26 ++----
 drivers/ide/pci/cs5535.c          |   19 ++--
 drivers/ide/pci/cy82c693.c        |   20 +----
 drivers/ide/pci/hpt34x.c          |   10 +-
 drivers/ide/pci/hpt366.c          |   44 +++++----
 drivers/ide/pci/it8213.c          |   28 ++----
 drivers/ide/pci/it821x.c          |   26 +----
 drivers/ide/pci/jmicron.c         |   81 ++++++----------
 drivers/ide/pci/opti621.c         |   19 ++--
 drivers/ide/pci/pdc202xx_new.c    |   72 ++++++++-------
 drivers/ide/pci/pdc202xx_old.c    |   17 ++--
 drivers/ide/pci/piix.c            |   40 +++-----
 drivers/ide/pci/sc1200.c          |   32 ++-----
 drivers/ide/pci/scc_pata.c        |   19 +---
 drivers/ide/pci/serverworks.c     |   15 +--
 drivers/ide/pci/sgiioc4.c         |   88 +++++++++---------
 drivers/ide/pci/siimage.c         |   43 +++++----
 drivers/ide/pci/sis5513.c         |   51 +++++-----
 drivers/ide/pci/sl82c105.c        |   27 +-----
 drivers/ide/pci/slc90e66.c        |   22 +---
 drivers/ide/pci/tc86c001.c        |   11 +--
 drivers/ide/pci/triflex.c         |   12 +--
 drivers/ide/pci/via82cxxx.c       |   32 ++----
 drivers/ide/ppc/mpc8xx.c          |   21 +----
 drivers/ide/ppc/pmac.c            |   40 +++------
 include/linux/ide.h               |   34 ++++++-
 52 files changed, 945 insertions(+), 853 deletions(-)
 create mode 100644 drivers/ide/legacy/ide_platform.c


Anton Vorontsov (1):
      ide: Platform IDE driver

Bartlomiej Zolnierkiewicz (17):
      ide: add missing ide_rate_filter() calls to ->speedproc()-s
      ide: mode limiting fixes for user requested speed changes
      sis5513: add ->udma_filter method for chipset_family >= ATA_133
      ide: move ide_rate_filter() calls to the upper layer (take 2)
      ide: Kconfig face-lift
      ide: add ide_set{_max}_pio() (take 4)
      amd74xx/via82cxxx: use ide_tune_dma()
      sgiioc4: use ide_tune_dma()
      icside: fix ->speedproc to return on unsupported modes (take 5)
      ide-pmac: PIO mode setup fixes (take 3)
      sc1200: remove redundant warning message from sc1200_tune_chipset()
      cs5520: don't enable VDMA in ->speedproc
      siimage: fix ->set_pio_mode method to select PIO data transfer
      alim15x3: PIO mode setup fixes
      it8213/piix/slc90e66: don't change DMA settings when programming PIO
      sis5513: don't change UDMA settings when programming PIO
      ide: use only ->set_pio_mode method for programming PIO modes (take 2)

Sergei Shtylyov (3):
      hpt366: MWDMA filter for SATA cards (take 2)
      pdc202xx_new: switch to using pci_get_slot() (take 2)
      ide: call udma_filter() before resorting to the UltraDMA mask

Shane Huang (1):
      atiixp: SB700 contains more than one IDE channel

Shaohua Li (1):
      ide: hook ACPI _PSx method to IDE power on/off

Tejun Heo (1):
      ide: make jmicron match vendor and device class


diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 9ba778a..feab124 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -262,10 +262,12 @@ int acpi_bus_set_power(acpi_handle handle, int state)
 		printk(KERN_WARNING PREFIX
 			      "Transitioning device [%s] to D%d\n",
 			      device->pnp.bus_id, state);
-	else
+	else {
+		device->power.state = state;
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Device [%s] transitioned to D%d\n",
 				  device->pnp.bus_id, state));
+	}
 
 	return result;
 }
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 4200251..aa0e0c9 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -308,6 +308,14 @@ config IDE_GENERIC
 	help
 	  If unsure, say N.
 
+config BLK_DEV_PLATFORM
+	tristate "Platform driver for IDE interfaces"
+	help
+	  This is the platform IDE driver, used mostly for Memory Mapped
+	  IDE devices, like Compact Flashes running in True IDE mode.
+
+	  If unsure, say N.
+
 config BLK_DEV_CMD640
 	bool "CMD640 chipset bugfix/support"
 	depends on X86
@@ -351,17 +359,16 @@ config BLK_DEV_IDEPNP
 	  would like the kernel to automatically detect and activate
 	  it, say Y here.
 
+if PCI
+
+comment "PCI IDE chipsets support"
+
 config BLK_DEV_IDEPCI
-	bool "PCI IDE chipset support" if PCI
-	default BLK_DEV_IDEDMA_PMAC if PPC_PMAC && BLK_DEV_IDEDMA_PMAC
-	help
-	  Say Y here for PCI systems which use IDE drive(s).
-	  This option helps the IDE driver to automatically detect and
-	  configure all PCI-based IDE interfaces in your system.
+	bool
 
 config IDEPCI_SHARE_IRQ
 	bool "Sharing PCI IDE interrupts support"
-	depends on PCI && BLK_DEV_IDEPCI
+	depends on BLK_DEV_IDEPCI
 	help
 	  Some ATA/IDE chipsets have hardware support which allows for
 	  sharing a single IRQ with other cards. To enable support for
@@ -371,11 +378,11 @@ config IDEPCI_SHARE_IRQ
 	  If unsure, say N.
 
 config IDEPCI_PCIBUS_ORDER
-	def_bool PCI && BLK_DEV_IDE=y && BLK_DEV_IDEPCI
+	def_bool BLK_DEV_IDE=y && BLK_DEV_IDEPCI
 
 config BLK_DEV_OFFBOARD
 	bool "Boot off-board chipsets first support"
-	depends on PCI && BLK_DEV_IDEPCI
+	depends on BLK_DEV_IDEPCI
 	help
 	  Normally, IDE controllers built into the motherboard (on-board
 	  controllers) are assigned to ide0 and ide1 while those on add-in PCI
@@ -398,21 +405,23 @@ config BLK_DEV_OFFBOARD
 
 config BLK_DEV_GENERIC
 	tristate "Generic PCI IDE Chipset Support"
-	depends on BLK_DEV_IDEPCI
+	select BLK_DEV_IDEPCI
         help
           This option provides generic support for various PCI IDE Chipsets
           which otherwise might not be supported.
 
 config BLK_DEV_OPTI621
 	tristate "OPTi 82C621 chipset enhanced support (EXPERIMENTAL)"
-	depends on PCI && BLK_DEV_IDEPCI && EXPERIMENTAL
+	depends on EXPERIMENTAL
+	select BLK_DEV_IDEPCI
 	help
 	  This is a driver for the OPTi 82C621 EIDE controller.
 	  Please read the comments at the top of <file:drivers/ide/pci/opti621.c>.
 
 config BLK_DEV_RZ1000
 	tristate "RZ1000 chipset bugfix/support"
-	depends on PCI && BLK_DEV_IDEPCI && X86
+	depends on X86
+	select BLK_DEV_IDEPCI
 	help
 	  The PC-Technologies RZ1000 IDE chip is used on many common 486 and
 	  Pentium motherboards, usually along with the "Neptune" chipset.
@@ -423,35 +432,21 @@ config BLK_DEV_RZ1000
 	  things will operate 100% reliably.
 
 config BLK_DEV_IDEDMA_PCI
-	bool "Generic PCI bus-master DMA support"
-	depends on PCI && BLK_DEV_IDEPCI
-	---help---
-	  If your PCI system uses IDE drive(s) (as opposed to SCSI, say) and
-	  is capable of bus-master DMA operation (most Pentium PCI systems),
-	  you will want to say Y here to reduce CPU overhead. You can then use
-	  the "hdparm" utility to enable DMA for drives for which it was not
-	  enabled automatically. By default, DMA is not enabled automatically
-	  for these drives, but you can change that by saying Y to the
-	  following question "Use DMA by default when available". You can get
-	  the latest version of the hdparm utility from
-	  <ftp://ibiblio.org/pub/Linux/system/hardware/>.
-
-	  Read the comments at the beginning of <file:drivers/ide/ide-dma.c>
-	  and the file <file:Documentation/ide.txt> for more information.
-
-	  It is safe to say Y to this question.
-
-if BLK_DEV_IDEDMA_PCI
+	bool
+	select BLK_DEV_IDEPCI
 
 config BLK_DEV_IDEDMA_FORCED
 	bool "Force enable legacy 2.0.X HOSTS to use DMA"
+	depends on BLK_DEV_IDEDMA_PCI
 	help
 	  This is an old piece of lost code from Linux 2.0 Kernels.
 
 	  Generally say N here.
 
+# TODO: remove it
 config IDEDMA_ONLYDISK
 	bool "Enable DMA only for disks "
+	depends on BLK_DEV_IDEDMA_PCI
 	help
 	  This is used if you know your ATAPI Devices are going to fail DMA
 	  Transfers.
@@ -460,6 +455,7 @@ config IDEDMA_ONLYDISK
 
 config BLK_DEV_AEC62XX
 	tristate "AEC62XX chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds explicit support for Acard AEC62xx (Artop ATP8xx)
 	  IDE controllers. This allows the kernel to change PIO, DMA and UDMA
@@ -467,6 +463,7 @@ config BLK_DEV_AEC62XX
 
 config BLK_DEV_ALI15X3
 	tristate "ALI M15x3 chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver ensures (U)DMA support for ALI 1533, 1543 and 1543C
 	  onboard chipsets.  It also tests for Simplex mode and enables
@@ -495,6 +492,7 @@ config WDC_ALI15X3
 
 config BLK_DEV_AMD74XX
 	tristate "AMD and nVidia IDE support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds explicit support for AMD-7xx and AMD-8111 chips
 	  and also for the nVidia nForce chip.  This allows the kernel to
@@ -504,6 +502,7 @@ config BLK_DEV_AMD74XX
 config BLK_DEV_ATIIXP
 	tristate "ATI IXP chipset IDE support"
 	depends on X86
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds explicit support for ATI IXP chipset.
 	  This allows the kernel to change PIO, DMA and UDMA speeds
@@ -513,18 +512,21 @@ config BLK_DEV_ATIIXP
 
 config BLK_DEV_CMD64X
 	tristate "CMD64{3|6|8|9} chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  Say Y here if you have an IDE controller which uses any of these
 	  chipsets: CMD643, CMD646, or CMD648.
 
 config BLK_DEV_TRIFLEX
 	tristate "Compaq Triflex IDE support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  Say Y here if you have a Compaq Triflex IDE controller, such
 	  as those commonly found on Compaq Pentium-Pro systems
 
 config BLK_DEV_CY82C693
 	tristate "CY82C693 chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds detection and support for the CY82C693 chipset
 	  used on Digital's PC-Alpha 164SX boards.
@@ -535,6 +537,7 @@ config BLK_DEV_CY82C693
 config BLK_DEV_CS5520
 	tristate "Cyrix CS5510/20 MediaGX chipset support (VERY EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  Include support for PIO tuning and virtual DMA on the Cyrix MediaGX
 	  5510/5520 chipset. This will automatically be detected and
@@ -544,6 +547,7 @@ config BLK_DEV_CS5520
 
 config BLK_DEV_CS5530
 	tristate "Cyrix/National Semiconductor CS5530 MediaGX chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  Include support for UDMA on the Cyrix MediaGX 5530 chipset. This
 	  will automatically be detected and configured if found.
@@ -553,6 +557,7 @@ config BLK_DEV_CS5530
 config BLK_DEV_CS5535
 	tristate "AMD CS5535 chipset support"
 	depends on X86 && !X86_64
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  Include support for UDMA on the NSC/AMD CS5535 companion chipset.
 	  This will automatically be detected and configured if found.
@@ -561,6 +566,7 @@ config BLK_DEV_CS5535
 
 config BLK_DEV_HPT34X
 	tristate "HPT34X chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds up to 4 more EIDE devices sharing a single
 	  interrupt. The HPT343 chipset in its current form is a non-bootable
@@ -581,7 +587,8 @@ config HPT34X_AUTODMA
 
 config BLK_DEV_HPT366
 	tristate "HPT36X/37X chipset support"
-	---help---
+	select BLK_DEV_IDEDMA_PCI
+	help
 	  HPT366 is an Ultra DMA chipset for ATA-66.
 	  HPT368 is an Ultra DMA chipset for ATA-66 RAID Based.
 	  HPT370 is an Ultra DMA chipset for ATA-100.
@@ -605,18 +612,21 @@ config BLK_DEV_HPT366
 
 config BLK_DEV_JMICRON
 	tristate "JMicron JMB36x support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  Basic support for the JMicron ATA controllers. For full support
 	  use the libata drivers.
 
 config BLK_DEV_SC1200
 	tristate "National SCx200 chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds support for the built in IDE on the National
 	  SCx200 series of embedded x86 "Geode" systems
 
 config BLK_DEV_PIIX
 	tristate "Intel PIIXn chipsets support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds explicit support for Intel PIIX and ICH chips
 	  and also for the Efar Victory66 (slc90e66) chip.  This allows
@@ -625,17 +635,20 @@ config BLK_DEV_PIIX
 
 config BLK_DEV_IT8213
 	tristate "IT8213 IDE support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	 This driver adds support for the ITE 8213 IDE controller.
 
 config BLK_DEV_IT821X
 	tristate "IT821X IDE support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds support for the ITE 8211 IDE controller and the
 	  IT 8212 IDE RAID controller in both RAID and pass-through mode.
 
 config BLK_DEV_NS87415
 	tristate "NS87415 chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds detection and support for the NS87415 chip
 	  (used mainly on SPARC64 and PA-RISC machines).
@@ -644,6 +657,7 @@ config BLK_DEV_NS87415
 
 config BLK_DEV_PDC202XX_OLD
 	tristate "PROMISE PDC202{46|62|65|67} support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  Promise Ultra33 or PDC20246
 	  Promise Ultra66 or PDC20262
@@ -685,9 +699,11 @@ config PDC202XX_BURST
 
 config BLK_DEV_PDC202XX_NEW
 	tristate "PROMISE PDC202{68|69|70|71|75|76|77} support"
+	select BLK_DEV_IDEDMA_PCI
 
 config BLK_DEV_SVWKS
 	tristate "ServerWorks OSB4/CSB5/CSB6 chipsets support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds PIO/(U)DMA support for the ServerWorks OSB4/CSB5
 	  chipsets.
@@ -696,6 +712,7 @@ config BLK_DEV_SGIIOC4
 	tristate "Silicon Graphics IOC4 chipset ATA/ATAPI support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC) && SGI_IOC4
 	select IDEPCI_SHARE_IRQ
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds PIO & MultiMode DMA-2 support for the SGI IOC4
 	  chipset, which has one channel and can support two devices.
@@ -703,6 +720,7 @@ config BLK_DEV_SGIIOC4
 
 config BLK_DEV_SIIMAGE
 	tristate "Silicon Image chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds PIO/(U)DMA support for the SI CMD680 and SII
 	  3112 (Serial ATA) chips.
@@ -710,7 +728,8 @@ config BLK_DEV_SIIMAGE
 config BLK_DEV_SIS5513
 	tristate "SiS5513 chipset support"
 	depends on X86
-	---help---
+	select BLK_DEV_IDEDMA_PCI
+	help
 	  This driver ensures (U)DMA support for SIS5513 chipset family based
 	  mainboards.
 
@@ -729,6 +748,7 @@ config BLK_DEV_SIS5513
 config BLK_DEV_SL82C105
 	tristate "Winbond SL82c105 support"
 	depends on (PPC || ARM)
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  If you have a Winbond SL82c105 IDE controller, say Y here to enable
 	  special configuration for this chip. This is common on various CHRP
@@ -736,6 +756,7 @@ config BLK_DEV_SL82C105
 
 config BLK_DEV_SLC90E66
 	tristate "SLC90E66 chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver ensures (U)DMA support for Victory66 SouthBridges for
 	  SMsC with Intel NorthBridges.  This is an Ultra66 based chipset.
@@ -751,6 +772,7 @@ config BLK_DEV_SLC90E66
 
 config BLK_DEV_TRM290
 	tristate "Tekram TRM290 chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds support for bus master DMA transfers
 	  using the Tekram TRM290 PCI IDE chip. Volunteers are
@@ -759,6 +781,7 @@ config BLK_DEV_TRM290
 
 config BLK_DEV_VIA82CXXX
 	tristate "VIA82CXXX chipset support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds explicit support for VIA BusMastering IDE chips.
 	  This allows the kernel to change PIO, DMA and UDMA speeds and to
@@ -766,12 +789,14 @@ config BLK_DEV_VIA82CXXX
 
 config BLK_DEV_TC86C001
 	tristate "Toshiba TC86C001 support"
+	select BLK_DEV_IDEDMA_PCI
 	help
 	This driver adds support for Toshiba TC86C001 GOKU-S chip.
 
 config BLK_DEV_CELLEB
 	tristate "Toshiba's Cell Reference Set IDE support"
 	depends on PPC_CELLEB
+	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver provides support for the built-in IDE controller on
 	  Toshiba Cell Reference Board.
@@ -985,24 +1010,9 @@ config IDE_EXT_DIRECT
 endchoice
 
 # no isa -> no vlb
-config IDE_CHIPSETS
-	bool "Other IDE chipset support"
-	depends on ISA
-	---help---
-	  Say Y here if you want to include enhanced support for various IDE
-	  interface chipsets used on motherboards and add-on cards. You can
-	  then pick your particular IDE chip from among the following options.
-	  This enhanced support may be necessary for Linux to be able to
-	  access the 3rd/4th drives in some systems. It may also enable
-	  setting of higher speed I/O rates to improve system performance with
-	  these chipsets. Most of these also require special kernel boot
-	  parameters to actually turn on the support at runtime; you can find
-	  a list of these in the file <file:Documentation/ide.txt>.
-
-	  People with SCSI-only systems can say N here.
-
-if IDE_CHIPSETS
+if ISA
 
+comment "Other IDE chipsets support"
 comment "Note: most of these also require special kernel boot parameters"
 
 config BLK_DEV_4DRIVES
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 8a9b98f..7912a47 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -248,15 +248,9 @@ static void icside_build_sglist(ide_drive_t *drive, struct request *rq)
  *	MW1	80	50	50	150	C
  *	MW2	70	25	25	120	C
  */
-static int icside_set_speed(ide_drive_t *drive, u8 xfer_mode)
+static int icside_set_speed(ide_drive_t *drive, const u8 xfer_mode)
 {
-	int on = 0, cycle_time = 0, use_dma_info = 0;
-
-	/*
-	 * Limit the transfer speed to MW_DMA_2.
-	 */
-	if (xfer_mode > XFER_MW_DMA_2)
-		xfer_mode = XFER_MW_DMA_2;
+	int cycle_time, use_dma_info = 0;
 
 	switch (xfer_mode) {
 	case XFER_MW_DMA_2:
@@ -278,6 +272,8 @@ static int icside_set_speed(ide_drive_t *drive, u8 xfer_mode)
 	case XFER_SW_DMA_0:
 		cycle_time = 480;
 		break;
+	default:
+		return 1;
 	}
 
 	/*
@@ -289,17 +285,10 @@ static int icside_set_speed(ide_drive_t *drive, u8 xfer_mode)
 
 	drive->drive_data = cycle_time;
 
-	if (cycle_time && ide_config_drive_speed(drive, xfer_mode) == 0)
-		on = 1;
-	else
-		drive->drive_data = 480;
-
 	printk("%s: %s selected (peak %dMB/s)\n", drive->name,
 		ide_xfer_verbose(xfer_mode), 2000 / drive->drive_data);
 
-	drive->current_speed = xfer_mode;
-
-	return on;
+	return ide_config_drive_speed(drive, xfer_mode);
 }
 
 static void icside_dma_host_off(ide_drive_t *drive)
@@ -326,8 +315,7 @@ static int icside_dma_check(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
 	ide_hwif_t *hwif = HWIF(drive);
-	int xfer_mode = XFER_PIO_2;
-	int on;
+	int xfer_mode = 0;
 
 	if (!(id->capability & 1) || !hwif->autodma)
 		goto out;
@@ -356,9 +344,10 @@ static int icside_dma_check(ide_drive_t *drive)
 	}
 
 out:
-	on = icside_set_speed(drive, xfer_mode);
+	if (xfer_mode == 0)
+		return -1;
 
-	return on ? 0 : -1;
+	return icside_set_speed(drive, xfer_mode) ? -1 : 0;
 }
 
 static int icside_dma_end(ide_drive_t *drive)
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 04636f7..4bb42b3 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -680,12 +680,10 @@ static void cris_dma_off(ide_drive_t *drive)
 {
 }
 
-static void tune_cris_ide(ide_drive_t *drive, u8 pio)
+static void cris_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	int setup, strobe, hold;
 
-	pio = ide_get_best_pio_mode(drive, pio, 4);
-
 	switch(pio)
 	{
 		case 0:
@@ -722,15 +720,10 @@ static void tune_cris_ide(ide_drive_t *drive, u8 pio)
 	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
-static int speed_cris_ide(ide_drive_t *drive, u8 speed)
+static int speed_cris_ide(ide_drive_t *drive, const u8 speed)
 {
 	int cyc = 0, dvs = 0, strobe = 0, hold = 0;
 
-	if (speed >= XFER_PIO_0 && speed <= XFER_PIO_4) {
-		tune_cris_ide(drive, speed - XFER_PIO_0);
-		return ide_config_drive_speed(drive, speed);
-	}
-
 	switch(speed)
 	{
 		case XFER_UDMA_0:
@@ -797,7 +790,7 @@ init_e100_ide (void)
 		ide_register_hw(&hw, 1, &hwif);
 		hwif->mmio = 1;
 		hwif->chipset = ide_etrax100;
-		hwif->tuneproc = &tune_cris_ide;
+		hwif->set_pio_mode = &cris_set_pio_mode;
 		hwif->speedproc = &speed_cris_ide;
 		hwif->ata_input_data = &cris_ide_input_data;
 		hwif->ata_output_data = &cris_ide_output_data;
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 17aea65..6bff81a 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -612,6 +612,46 @@ void ide_acpi_push_timing(ide_hwif_t *hwif)
 EXPORT_SYMBOL_GPL(ide_acpi_push_timing);
 
 /**
+ * ide_acpi_set_state - set the channel power state
+ * @hwif: target IDE interface
+ * @on: state, on/off
+ *
+ * This function executes the _PS0/_PS3 ACPI method to set the power state.
+ * ACPI spec requires _PS0 when IDE power on and _PS3 when power off
+ */
+void ide_acpi_set_state(ide_hwif_t *hwif, int on)
+{
+	int unit;
+
+	if (ide_noacpi)
+		return;
+
+	DEBPRINT("ENTER:\n");
+
+	if (!hwif->acpidata) {
+		DEBPRINT("no ACPI data for %s\n", hwif->name);
+		return;
+	}
+	/* channel first and then drives for power on and verse versa for power off */
+	if (on)
+		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D0);
+	for (unit = 0; unit < MAX_DRIVES; ++unit) {
+		ide_drive_t *drive = &hwif->drives[unit];
+
+		if (!drive->acpidata->obj_handle)
+			drive->acpidata->obj_handle = ide_acpi_drive_get_handle(drive);
+
+		if (drive->acpidata->obj_handle && drive->present) {
+			acpi_bus_set_power(drive->acpidata->obj_handle,
+				on? ACPI_STATE_D0: ACPI_STATE_D3);
+		}
+	}
+	if (!on)
+		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D3);
+}
+EXPORT_SYMBOL_GPL(ide_acpi_set_state);
+
+/**
  * ide_acpi_init - initialize the ACPI link for an IDE interface
  * @hwif: target IDE interface (channel)
  *
@@ -679,6 +719,8 @@ void ide_acpi_init(ide_hwif_t *hwif)
 		return;
 	}
 
+	/* ACPI _PS0 before _STM */
+	ide_acpi_set_state(hwif, 1);
 	/*
 	 * ACPI requires us to call _STM on startup
 	 */
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index ff644a5..6000c08 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -653,7 +653,7 @@ static const u8 xfer_mode_bases[] = {
 	XFER_SW_DMA_0,
 };
 
-static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base)
+static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
 {
 	struct hd_driveid *id = drive->id;
 	ide_hwif_t *hwif = drive->hwif;
@@ -664,17 +664,28 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base)
 		if ((id->field_valid & 4) == 0)
 			break;
 
-		mask = id->dma_ultra & hwif->ultra_mask;
-
 		if (hwif->udma_filter)
-			mask &= hwif->udma_filter(drive);
+			mask = hwif->udma_filter(drive);
+		else
+			mask = hwif->ultra_mask;
+		mask &= id->dma_ultra;
 
-		if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
-			mask &= 0x07;
+		/*
+		 * avoid false cable warning from eighty_ninty_three()
+		 */
+		if (req_mode > XFER_UDMA_2) {
+			if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
+				mask &= 0x07;
+		}
 		break;
 	case XFER_MW_DMA_0:
-		if (id->field_valid & 2)
-			mask = id->dma_mword & hwif->mwdma_mask;
+		if ((id->field_valid & 2) == 0)
+			break;
+		if (hwif->mdma_filter)
+			mask = hwif->mdma_filter(drive);
+		else
+			mask = hwif->mwdma_mask;
+		mask &= id->dma_mword;
 		break;
 	case XFER_SW_DMA_0:
 		if (id->field_valid & 2) {
@@ -703,15 +714,18 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base)
 }
 
 /**
- *	ide_max_dma_mode	-	compute DMA speed
+ *	ide_find_dma_mode	-	compute DMA speed
  *	@drive: IDE device
+ *	@req_mode: requested mode
+ *
+ *	Checks the drive/host capabilities and finds the speed to use for
+ *	the DMA transfer.  The speed is then limited by the requested mode.
  *
- *	Checks the drive capabilities and returns the speed to use
- *	for the DMA transfer.  Returns 0 if the drive is incapable
- *	of DMA transfers.
+ *	Returns 0 if the drive/host combination is incapable of DMA transfers
+ *	or if the requested mode is not a DMA mode.
  */
 
-u8 ide_max_dma_mode(ide_drive_t *drive)
+u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned int mask;
@@ -722,7 +736,9 @@ u8 ide_max_dma_mode(ide_drive_t *drive)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(xfer_mode_bases); i++) {
-		mask = ide_get_mode_mask(drive, xfer_mode_bases[i]);
+		if (req_mode < xfer_mode_bases[i])
+			continue;
+		mask = ide_get_mode_mask(drive, xfer_mode_bases[i], req_mode);
 		x = fls(mask) - 1;
 		if (x >= 0) {
 			mode = xfer_mode_bases[i] + x;
@@ -732,10 +748,10 @@ u8 ide_max_dma_mode(ide_drive_t *drive)
 
 	printk(KERN_DEBUG "%s: selected mode 0x%x\n", drive->name, mode);
 
-	return mode;
+	return min(mode, req_mode);
 }
 
-EXPORT_SYMBOL_GPL(ide_max_dma_mode);
+EXPORT_SYMBOL_GPL(ide_find_dma_mode);
 
 int ide_tune_dma(ide_drive_t *drive)
 {
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index aa9f5f0..9560a8f 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -201,8 +201,7 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 		return do_rw_taskfile(drive, args);
 
 	case idedisk_pm_restore_pio:	/* Resume step 1 (restore PIO) */
-		if (drive->hwif->tuneproc != NULL)
-			drive->hwif->tuneproc(drive, 255);
+		ide_set_max_pio(drive);
 		/*
 		 * skip idedisk_pm_idle for ATAPI devices
 		 */
@@ -788,6 +787,30 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 	return ide_started;
 }
 
+/*
+ * handle HDIO_SET_PIO_MODE ioctl abusers here, eventually it will go away
+ */
+static int set_pio_mode_abuse(ide_hwif_t *hwif, u8 req_pio)
+{
+	switch (req_pio) {
+	case 202:
+	case 201:
+	case 200:
+	case 102:
+	case 101:
+	case 100:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_DMA_MODES) ? 1 : 0;
+	case 9:
+	case 8:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_PREFETCH) ? 1 : 0;
+	case 7:
+	case 6:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_FAST_DEVSEL) ? 1 : 0;
+	default:
+		return 0;
+	}
+}
+
 /**
  *	do_special		-	issue some special commands
  *	@drive: drive the command is for
@@ -805,9 +828,17 @@ static ide_startstop_t do_special (ide_drive_t *drive)
 	printk("%s: do_special: 0x%02x\n", drive->name, s->all);
 #endif
 	if (s->b.set_tune) {
+		ide_hwif_t *hwif = drive->hwif;
+		u8 req_pio = drive->tune_req;
+
 		s->b.set_tune = 0;
-		if (HWIF(drive)->tuneproc != NULL)
-			HWIF(drive)->tuneproc(drive, drive->tune_req);
+
+		if (set_pio_mode_abuse(drive->hwif, req_pio)) {
+			if (hwif->set_pio_mode)
+				hwif->set_pio_mode(drive, req_pio);
+		} else
+			ide_set_pio(drive, req_pio);
+
 		return ide_stopped;
 	} else {
 		if (drive->media == ide_disk)
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 646a54e..cf0678b 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -780,12 +780,6 @@ int ide_driveid_update (ide_drive_t *drive)
 
 /*
  * Similar to ide_wait_stat(), except it never calls ide_error internally.
- * This is a kludge to handle the new ide_config_drive_speed() function,
- * and should not otherwise be used anywhere.  Eventually, the tuneproc's
- * should be updated to return ide_startstop_t, in which case we can get
- * rid of this abomination again.  :)   -ml
- *
- * It is gone..........
  *
  * const char *msg == consider adding for verbose errors.
  */
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 92a6c7b..d97390c 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -76,41 +76,26 @@ EXPORT_SYMBOL(ide_xfer_verbose);
  *	Given the available transfer modes this function returns
  *	the best available speed at or below the speed requested.
  *
- *	FIXME: filter also PIO/SWDMA/MWDMA modes
+ *	TODO: check device PIO capabilities
  */
 
-u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
+static u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
 {
-#ifdef CONFIG_BLK_DEV_IDEDMA
 	ide_hwif_t *hwif = drive->hwif;
-	u8 mask = hwif->ultra_mask, mode = XFER_MW_DMA_2;
+	u8 mode = ide_find_dma_mode(drive, speed);
 
-	if (hwif->udma_filter)
-		mask = hwif->udma_filter(drive);
-
-	/*
-	 * TODO: speed > XFER_UDMA_2 extra check is needed to avoid false
-	 * cable warning from eighty_ninty_three(), moving ide_rate_filter()
-	 * calls from ->speedproc to core code will make this hack go away
-	 */
-	if (speed > XFER_UDMA_2) {
-		if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
-			mask &= 0x07;
+	if (mode == 0) {
+		if (hwif->pio_mask)
+			mode = fls(hwif->pio_mask) - 1 + XFER_PIO_0;
+		else
+			mode = XFER_PIO_4;
 	}
 
-	if (mask)
-		mode = fls(mask) - 1 + XFER_UDMA_0;
-
 //	printk("%s: mode 0x%02x, speed 0x%02x\n", __FUNCTION__, mode, speed);
 
 	return min(speed, mode);
-#else /* !CONFIG_BLK_DEV_IDEDMA */
-	return min(speed, (u8)XFER_PIO_4);
-#endif /* CONFIG_BLK_DEV_IDEDMA */
 }
 
-EXPORT_SYMBOL(ide_rate_filter);
-
 int ide_use_fast_pio(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
@@ -340,6 +325,35 @@ u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode)
 
 EXPORT_SYMBOL_GPL(ide_get_best_pio_mode);
 
+/* req_pio == "255" for auto-tune */
+void ide_set_pio(ide_drive_t *drive, u8 req_pio)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 host_pio, pio;
+
+	if (hwif->set_pio_mode == NULL)
+		return;
+
+	BUG_ON(hwif->pio_mask == 0x00);
+
+	host_pio = fls(hwif->pio_mask) - 1;
+
+	pio = ide_get_best_pio_mode(drive, req_pio, host_pio);
+
+	/*
+	 * TODO:
+	 * - report device max PIO mode
+	 * - check req_pio != 255 against device max PIO mode
+	 */
+	printk(KERN_DEBUG "%s: host max PIO%d wanted PIO%d%s selected PIO%d\n",
+			  drive->name, host_pio, req_pio,
+			  req_pio == 255 ? "(auto-tune)" : "", pio);
+
+	hwif->set_pio_mode(drive, pio);
+}
+
+EXPORT_SYMBOL_GPL(ide_set_pio);
+
 /**
  *	ide_toggle_bounce	-	handle bounce buffering
  *	@drive: drive to update
@@ -377,13 +391,26 @@ void ide_toggle_bounce(ide_drive_t *drive, int on)
  
 int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
 {
-#ifndef CONFIG_BLK_DEV_IDEDMA
-	rate = min(rate, (u8) XFER_PIO_4);
-#endif
-	if(HWIF(drive)->speedproc)
-		return HWIF(drive)->speedproc(drive, rate);
-	else
+	ide_hwif_t *hwif = drive->hwif;
+
+	if (hwif->speedproc == NULL)
 		return -1;
+
+	rate = ide_rate_filter(drive, rate);
+
+	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_5) {
+		if (hwif->set_pio_mode)
+			hwif->set_pio_mode(drive, rate - XFER_PIO_0);
+
+		/*
+		 * FIXME: this is incorrect to return zero here but
+		 * since all users of ide_set_xfer_rate() ignore
+		 * the return value it is not a problem currently
+		 */
+		return 0;
+	}
+
+	return hwif->speedproc(drive, rate);
 }
 
 static void ide_dump_opcode(ide_drive_t *drive)
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 3a2a9a3..b4c9f63 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -827,10 +827,8 @@ static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 		ide_drive_t *drive = &hwif->drives[unit];
 
 		if (drive->present) {
-			if (hwif->tuneproc != NULL && 
-				drive->autotune == IDE_TUNE_AUTO)
-				/* auto-tune PIO mode */
-				hwif->tuneproc(drive, 255);
+			if (drive->autotune == IDE_TUNE_AUTO)
+				ide_set_max_pio(drive);
 
 			if (drive->autotune != IDE_TUNE_DEFAULT &&
 			    drive->autotune != IDE_TUNE_AUTO)
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 5e88a06..e96212c 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -396,8 +396,9 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 	hwif->cds			= tmp_hwif->cds;
 #endif
 
-	hwif->tuneproc			= tmp_hwif->tuneproc;
+	hwif->set_pio_mode		= tmp_hwif->set_pio_mode;
 	hwif->speedproc			= tmp_hwif->speedproc;
+	hwif->mdma_filter		= tmp_hwif->mdma_filter;
 	hwif->udma_filter		= tmp_hwif->udma_filter;
 	hwif->selectproc		= tmp_hwif->selectproc;
 	hwif->reset_poll		= tmp_hwif->reset_poll;
@@ -866,8 +867,9 @@ int set_pio_mode(ide_drive_t *drive, int arg)
 	if (arg < 0 || arg > 255)
 		return -EINVAL;
 
-	if (!HWIF(drive)->tuneproc)
+	if (drive->hwif->set_pio_mode == NULL)
 		return -ENOSYS;
+
 	if (drive->special.b.set_tune)
 		return -EBUSY;
 	ide_init_drive_cmd(&rq);
@@ -914,6 +916,7 @@ static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	struct request rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
+	int ret;
 
 	/* Call ACPI _GTM only once */
 	if (!(drive->dn % 2))
@@ -930,7 +933,14 @@ static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 		mesg.event = PM_EVENT_FREEZE;
 	rqpm.pm_state = mesg.event;
 
-	return ide_do_drive_cmd(drive, &rq, ide_wait);
+	ret = ide_do_drive_cmd(drive, &rq, ide_wait);
+	/* only call ACPI _PS3 after both drivers are suspended */
+	if (!ret && (((drive->dn % 2) && hwif->drives[0].present
+		 && hwif->drives[1].present)
+		 || !hwif->drives[0].present
+		 || !hwif->drives[1].present))
+		ide_acpi_set_state(hwif, 0);
+	return ret;
 }
 
 static int generic_ide_resume(struct device *dev)
@@ -943,8 +953,10 @@ static int generic_ide_resume(struct device *dev)
 	int err;
 
 	/* Call ACPI _STM only once */
-	if (!(drive->dn % 2))
+	if (!(drive->dn % 2)) {
+		ide_acpi_set_state(hwif, 1);
 		ide_acpi_push_timing(hwif);
+	}
 
 	ide_acpi_exec_tfs(drive);
 
diff --git a/drivers/ide/legacy/Makefile b/drivers/ide/legacy/Makefile
index c797106..4098223 100644
--- a/drivers/ide/legacy/Makefile
+++ b/drivers/ide/legacy/Makefile
@@ -7,6 +7,8 @@ obj-$(CONFIG_BLK_DEV_UMC8672)		+= umc8672.o
 
 obj-$(CONFIG_BLK_DEV_IDECS)		+= ide-cs.o
 
+obj-$(CONFIG_BLK_DEV_PLATFORM)		+= ide_platform.o
+
 # Last of all
 obj-$(CONFIG_BLK_DEV_HD)		+= hd.o
 
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 9b9c476..2f0ef9b 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -68,8 +68,6 @@ static RegInitializer initData[] __initdata = {
 	{0x35, 0x03}, {0x00, 0x00}
 };
 
-#define ALI_MAX_PIO 4
-
 /* timing parameter registers for each drive */
 static struct { u8 reg1, reg2, reg3, reg4; } regTab[4] = {
 	{0x03, 0x26, 0x04, 0x27},     /* drive 0 */
@@ -109,7 +107,7 @@ static void outReg (u8 data, u8 reg)
  * This function computes timing parameters
  * and sets controller registers accordingly.
  */
-static void ali14xx_tune_drive (ide_drive_t *drive, u8 pio)
+static void ali14xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	int driveNum;
 	int time1, time2;
@@ -117,8 +115,6 @@ static void ali14xx_tune_drive (ide_drive_t *drive, u8 pio)
 	unsigned long flags;
 	int bus_speed = system_bus_clock();
 
-	pio = ide_get_best_pio_mode(drive, pio, ALI_MAX_PIO);
-
 	/* calculate timing, according to PIO mode */
 	time1 = ide_pio_cycle_time(drive, pio);
 	time2 = ide_pio_timings[pio].active_time;
@@ -212,12 +208,12 @@ static int __init ali14xx_probe(void)
 
 	hwif->chipset = ide_ali14xx;
 	hwif->pio_mask = ATA_PIO4;
-	hwif->tuneproc = &ali14xx_tune_drive;
+	hwif->set_pio_mode = &ali14xx_set_pio_mode;
 	hwif->mate = mate;
 
 	mate->chipset = ide_ali14xx;
 	mate->pio_mask = ATA_PIO4;
-	mate->tuneproc = &ali14xx_tune_drive;
+	mate->set_pio_mode = &ali14xx_set_pio_mode;
 	mate->mate = hwif;
 	mate->channel = 1;
 
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index 6c01d95..f165212 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -67,12 +67,10 @@ static void sub22 (char b, char c)
 	}
 }
 
-static void tune_dtc2278 (ide_drive_t *drive, u8 pio)
+static void dtc2278_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	unsigned long flags;
 
-	pio = ide_get_best_pio_mode(drive, pio, 4);
-
 	if (pio >= 3) {
 		spin_lock_irqsave(&ide_lock, flags);
 		/*
@@ -124,7 +122,7 @@ static int __init dtc2278_probe(void)
 	hwif->serialized = 1;
 	hwif->chipset = ide_dtc2278;
 	hwif->pio_mask = ATA_PIO4;
-	hwif->tuneproc = &tune_dtc2278;
+	hwif->set_pio_mode = &dtc2278_set_pio_mode;
 	hwif->drives[0].no_unmask = 1;
 	hwif->drives[1].no_unmask = 1;
 	hwif->mate = mate;
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index bfaa202..2e5a9cc 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -199,7 +199,7 @@ static int __init try_to_init_ht6560b(void)
 	return 1;
 }
 
-static u8 ht_pio2timings(ide_drive_t *drive, u8 pio)
+static u8 ht_pio2timings(ide_drive_t *drive, const u8 pio)
 {
 	int active_time, recovery_time;
 	int active_cycles, recovery_cycles;
@@ -208,7 +208,6 @@ static u8 ht_pio2timings(ide_drive_t *drive, u8 pio)
         if (pio) {
 		unsigned int cycle_time;
 
-		pio = ide_get_best_pio_mode(drive, pio, 5);
 		cycle_time = ide_pio_cycle_time(drive, pio);
 
 		/*
@@ -277,7 +276,7 @@ static void ht_set_prefetch(ide_drive_t *drive, u8 state)
 #endif
 }
 
-static void tune_ht6560b (ide_drive_t *drive, u8 pio)
+static void ht6560b_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	unsigned long flags;
 	u8 timing;
@@ -333,15 +332,17 @@ int __init ht6560b_init(void)
 
 	hwif->chipset = ide_ht6560b;
 	hwif->selectproc = &ht6560b_selectproc;
+	hwif->host_flags = IDE_HFLAG_ABUSE_PREFETCH;
 	hwif->pio_mask = ATA_PIO5;
-	hwif->tuneproc = &tune_ht6560b;
+	hwif->set_pio_mode = &ht6560b_set_pio_mode;
 	hwif->serialized = 1;	/* is this needed? */
 	hwif->mate = mate;
 
 	mate->chipset = ide_ht6560b;
 	mate->selectproc = &ht6560b_selectproc;
+	mate->host_flags = IDE_HFLAG_ABUSE_PREFETCH;
 	mate->pio_mask = ATA_PIO5;
-	mate->tuneproc = &tune_ht6560b;
+	mate->set_pio_mode = &ht6560b_set_pio_mode;
 	mate->serialized = 1;	/* is this needed? */
 	mate->mate = hwif;
 	mate->channel = 1;
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
new file mode 100644
index 0000000..ccfb989
--- /dev/null
+++ b/drivers/ide/legacy/ide_platform.c
@@ -0,0 +1,182 @@
+/*
+ * Platform IDE driver
+ *
+ * Copyright (C) 2007 MontaVista Software
+ *
+ * Maintainer: Kumar Gala <galak@kernel.crashing.org>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/pata_platform.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+static struct {
+	void __iomem *plat_ide_mapbase;
+	void __iomem *plat_ide_alt_mapbase;
+	ide_hwif_t *hwif;
+	int index;
+} hwif_prop;
+
+static ide_hwif_t *__devinit plat_ide_locate_hwif(void __iomem *base,
+	    void __iomem *ctrl, struct pata_platform_info *pdata, int irq,
+	    int mmio)
+{
+	unsigned long port = (unsigned long)base;
+	ide_hwif_t *hwif;
+	int index, i;
+
+	for (index = 0; index < MAX_HWIFS; ++index) {
+		hwif = ide_hwifs + index;
+		if (hwif->io_ports[IDE_DATA_OFFSET] == port)
+			goto found;
+	}
+
+	for (index = 0; index < MAX_HWIFS; ++index) {
+		hwif = ide_hwifs + index;
+		if (hwif->io_ports[IDE_DATA_OFFSET] == 0)
+			goto found;
+	}
+
+	return NULL;
+
+found:
+
+	hwif->hw.io_ports[IDE_DATA_OFFSET] = port;
+
+	port += (1 << pdata->ioport_shift);
+	for (i = IDE_ERROR_OFFSET; i <= IDE_STATUS_OFFSET;
+	     i++, port += (1 << pdata->ioport_shift))
+		hwif->hw.io_ports[i] = port;
+
+	hwif->hw.io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
+
+	memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->hw.io_ports));
+	hwif->hw.irq = hwif->irq = irq;
+
+	hwif->hw.dma = NO_DMA;
+	hwif->hw.chipset = ide_generic;
+
+	if (mmio) {
+		hwif->mmio = 1;
+		default_hwif_mmiops(hwif);
+	}
+
+	hwif_prop.hwif = hwif;
+	hwif_prop.index = index;
+
+	return hwif;
+}
+
+static int __devinit plat_ide_probe(struct platform_device *pdev)
+{
+	struct resource *res_base, *res_alt, *res_irq;
+	ide_hwif_t *hwif;
+	struct pata_platform_info *pdata;
+	int ret = 0;
+	int mmio = 0;
+
+	pdata = pdev->dev.platform_data;
+
+	/* get a pointer to the register memory */
+	res_base = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	res_alt = platform_get_resource(pdev, IORESOURCE_IO, 1);
+
+	if (!res_base || !res_alt) {
+		res_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		res_alt = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!res_base || !res_alt) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		mmio = 1;
+	}
+
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res_irq) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (mmio) {
+		hwif_prop.plat_ide_mapbase = devm_ioremap(&pdev->dev,
+			res_base->start, res_base->end - res_base->start + 1);
+		hwif_prop.plat_ide_alt_mapbase = devm_ioremap(&pdev->dev,
+			res_alt->start, res_alt->end - res_alt->start + 1);
+	} else {
+		hwif_prop.plat_ide_mapbase = devm_ioport_map(&pdev->dev,
+			res_base->start, res_base->end - res_base->start + 1);
+		hwif_prop.plat_ide_alt_mapbase = devm_ioport_map(&pdev->dev,
+			res_alt->start, res_alt->end - res_alt->start + 1);
+	}
+
+	hwif = plat_ide_locate_hwif(hwif_prop.plat_ide_mapbase,
+	         hwif_prop.plat_ide_alt_mapbase, pdata, res_irq->start, mmio);
+
+	if (!hwif) {
+		ret = -ENODEV;
+		goto out;
+	}
+	hwif->gendev.parent = &pdev->dev;
+	hwif->noprobe = 0;
+
+	probe_hwif_init(hwif);
+
+	platform_set_drvdata(pdev, hwif);
+	ide_proc_register_port(hwif);
+
+	return 0;
+
+out:
+	return ret;
+}
+
+static int __devexit plat_ide_remove(struct platform_device *pdev)
+{
+	ide_hwif_t *hwif = pdev->dev.driver_data;
+
+	if (hwif != hwif_prop.hwif) {
+		dev_printk(KERN_DEBUG, &pdev->dev, "%s: hwif value error",
+		           pdev->name);
+	} else {
+		ide_unregister(hwif_prop.index);
+		hwif_prop.index = 0;
+		hwif_prop.hwif = NULL;
+	}
+
+	return 0;
+}
+
+static struct platform_driver platform_ide_driver = {
+	.driver = {
+		.name = "pata_platform",
+	},
+	.probe = plat_ide_probe,
+	.remove = __devexit_p(plat_ide_remove),
+};
+
+static int __init platform_ide_init(void)
+{
+	return platform_driver_register(&platform_ide_driver);
+}
+
+static void __exit platform_ide_exit(void)
+{
+	platform_driver_unregister(&platform_ide_driver);
+}
+
+MODULE_DESCRIPTION("Platform IDE driver");
+MODULE_LICENSE("GPL");
+
+module_init(platform_ide_init);
+module_exit(platform_ide_exit);
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 8b87a42..0c81d2d 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -224,15 +224,14 @@ static void qd_set_timing (ide_drive_t *drive, u8 timing)
 	printk(KERN_DEBUG "%s: %#x\n", drive->name, timing);
 }
 
-/*
- * qd6500_tune_drive
- */
-
-static void qd6500_tune_drive (ide_drive_t *drive, u8 pio)
+static void qd6500_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	int active_time   = 175;
 	int recovery_time = 415; /* worst case values from the dos driver */
 
+	/*
+	 * FIXME: use "pio" value
+	 */
 	if (drive->id && !qd_find_disk_type(drive, &active_time, &recovery_time)
 		&& drive->id->tPIO && (drive->id->field_valid & 0x02)
 		&& drive->id->eide_pio >= 240) {
@@ -246,11 +245,7 @@ static void qd6500_tune_drive (ide_drive_t *drive, u8 pio)
 	qd_set_timing(drive, qd6500_compute_timing(HWIF(drive), active_time, recovery_time));
 }
 
-/*
- * qd6580_tune_drive
- */
-
-static void qd6580_tune_drive (ide_drive_t *drive, u8 pio)
+static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	int base = HWIF(drive)->select_data;
 	unsigned int cycle_time;
@@ -258,7 +253,6 @@ static void qd6580_tune_drive (ide_drive_t *drive, u8 pio)
 	int recovery_time = 415; /* worst case values from the dos driver */
 
 	if (drive->id && !qd_find_disk_type(drive, &active_time, &recovery_time)) {
-		pio = ide_get_best_pio_mode(drive, pio, 4);
 		cycle_time = ide_pio_cycle_time(drive, pio);
 
 		switch (pio) {
@@ -335,8 +329,7 @@ static int __init qd_testreg(int port)
  */
 
 static void __init qd_setup(ide_hwif_t *hwif, int base, int config,
-			    unsigned int data0, unsigned int data1,
-			    void (*tuneproc) (ide_drive_t *, u8 pio))
+			    unsigned int data0, unsigned int data1)
 {
 	hwif->chipset = ide_qd65xx;
 	hwif->channel = hwif->index;
@@ -347,8 +340,6 @@ static void __init qd_setup(ide_hwif_t *hwif, int base, int config,
 	hwif->drives[0].io_32bit =
 	hwif->drives[1].io_32bit = 1;
 	hwif->pio_mask = ATA_PIO4;
-	hwif->tuneproc = tuneproc;
-	probe_hwif_init(hwif);
 }
 
 /*
@@ -361,7 +352,7 @@ static void __exit qd_unsetup(ide_hwif_t *hwif)
 {
 	u8 config = hwif->config_data;
 	int base = hwif->select_data;
-	void *tuneproc = (void *) hwif->tuneproc;
+	void *set_pio_mode = (void *)hwif->set_pio_mode;
 
 	if (hwif->chipset != ide_qd65xx)
 		return;
@@ -369,12 +360,12 @@ static void __exit qd_unsetup(ide_hwif_t *hwif)
 	printk(KERN_NOTICE "%s: back to defaults\n", hwif->name);
 
 	hwif->selectproc = NULL;
-	hwif->tuneproc = NULL;
+	hwif->set_pio_mode = NULL;
 
-	if (tuneproc == (void *) qd6500_tune_drive) {
+	if (set_pio_mode == (void *)qd6500_set_pio_mode) {
 		// will do it for both
 		qd_write_reg(QD6500_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
-	} else if (tuneproc == (void *) qd6580_tune_drive) {
+	} else if (set_pio_mode == (void *)qd6580_set_pio_mode) {
 		if (QD_CONTROL(hwif) & QD_CONTR_SEC_DISABLED) {
 			qd_write_reg(QD6580_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
 			qd_write_reg(QD6580_DEF_DATA2, QD_TIMREG(&hwif->drives[1]));
@@ -424,8 +415,11 @@ static int __init qd_probe(int base)
 			return 1;
 		}
 
-		qd_setup(hwif, base, config, QD6500_DEF_DATA, QD6500_DEF_DATA,
-			 &qd6500_tune_drive);
+		qd_setup(hwif, base, config, QD6500_DEF_DATA, QD6500_DEF_DATA);
+
+		hwif->set_pio_mode = &qd6500_set_pio_mode;
+
+		probe_hwif_init(hwif);
 
 		ide_proc_register_port(hwif);
 
@@ -455,8 +449,12 @@ static int __init qd_probe(int base)
 			printk(KERN_INFO "%s: qd6580: single IDE board\n",
 					 hwif->name);
 			qd_setup(hwif, base, config | (control << 8),
-				 QD6580_DEF_DATA, QD6580_DEF_DATA2,
-				 &qd6580_tune_drive);
+				 QD6580_DEF_DATA, QD6580_DEF_DATA2);
+
+			hwif->set_pio_mode = &qd6580_set_pio_mode;
+
+			probe_hwif_init(hwif);
+
 			qd_write_reg(QD_DEF_CONTR,QD_CONTROL_PORT);
 
 			ide_proc_register_port(hwif);
@@ -472,11 +470,19 @@ static int __init qd_probe(int base)
 					hwif->name, mate->name);
 
 			qd_setup(hwif, base, config | (control << 8),
-				 QD6580_DEF_DATA, QD6580_DEF_DATA,
-				 &qd6580_tune_drive);
+				 QD6580_DEF_DATA, QD6580_DEF_DATA);
+
+			hwif->set_pio_mode = &qd6580_set_pio_mode;
+
+			probe_hwif_init(hwif);
+
 			qd_setup(mate, base, config | (control << 8),
-				 QD6580_DEF_DATA2, QD6580_DEF_DATA2,
-				 &qd6580_tune_drive);
+				 QD6580_DEF_DATA2, QD6580_DEF_DATA2);
+
+			mate->set_pio_mode = &qd6580_set_pio_mode;
+
+			probe_hwif_init(mate);
+
 			qd_write_reg(QD_DEF_CONTR,QD_CONTROL_PORT);
 
 			ide_proc_register_port(hwif);
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index d2862e6..1151c92 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -105,12 +105,11 @@ static void umc_set_speeds (u8 speeds[])
 		speeds[0], speeds[1], speeds[2], speeds[3]);
 }
 
-static void tune_umc (ide_drive_t *drive, u8 pio)
+static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	unsigned long flags;
 	ide_hwgroup_t *hwgroup = ide_hwifs[HWIF(drive)->index^1].hwgroup;
 
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
 		drive->name, pio, pio_to_umc[pio]);
 	spin_lock_irqsave(&ide_lock, flags);
@@ -150,12 +149,12 @@ static int __init umc8672_probe(void)
 
 	hwif->chipset = ide_umc8672;
 	hwif->pio_mask = ATA_PIO4;
-	hwif->tuneproc = &tune_umc;
+	hwif->set_pio_mode = &umc_set_pio_mode;
 	hwif->mate = mate;
 
 	mate->chipset = ide_umc8672;
 	mate->pio_mask = ATA_PIO4;
-	mate->tuneproc = &tune_umc;
+	mate->set_pio_mode = &umc_set_pio_mode;
 	mate->mate = hwif;
 	mate->channel = 1;
 
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 2ba6a05..85819ae 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -99,18 +99,12 @@ void auide_outsw(unsigned long port, void *addr, u32 count)
 
 #endif
 
-static void auide_tune_drive(ide_drive_t *drive, byte pio)
+static void au1xxx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	int mem_sttime;
 	int mem_stcfg;
 	u8 speed;
 
-	/* get the best pio mode for the drive */
-	pio = ide_get_best_pio_mode(drive, pio, 4);
-
-	printk(KERN_INFO "%s: setting Au1XXX IDE to PIO mode%d\n",
-	       drive->name, pio);
-
 	mem_sttime = 0;
 	mem_stcfg  = au_readl(MEM_STCFG2);
 
@@ -175,7 +169,7 @@ static void auide_tune_drive(ide_drive_t *drive, byte pio)
 	ide_config_drive_speed(drive, speed);
 }
 
-static int auide_tune_chipset (ide_drive_t *drive, u8 speed)
+static int auide_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	int mem_sttime;
 	int mem_stcfg;
@@ -183,11 +177,6 @@ static int auide_tune_chipset (ide_drive_t *drive, u8 speed)
 	mem_sttime = 0;
 	mem_stcfg  = au_readl(MEM_STCFG2);
 
-	if (speed >= XFER_PIO_0 && speed <= XFER_PIO_4) {
-		auide_tune_drive(drive, speed - XFER_PIO_0);
-		return 0;
-	}
-
 	switch(speed) {
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 	case XFER_MW_DMA_2:
@@ -712,7 +701,7 @@ static int au_ide_probe(struct device *dev)
 	hwif->OUTSW                     = auide_outsw;
 #endif
 
-	hwif->tuneproc                  = &auide_tune_drive;
+	hwif->set_pio_mode		= &au1xxx_set_pio_mode;
 	hwif->speedproc                 = &auide_tune_chipset;
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 7443283..0d5f62c 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -87,12 +87,11 @@ static u8 pci_bus_clock_list_ultra (u8 speed, struct chipset_bus_clock_list_entr
 	return chipset_table->ultra_settings;
 }
 
-static int aec6210_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+static int aec6210_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u16 d_conf		= 0;
-	u8 speed		= ide_rate_filter(drive, xferspeed);
 	u8 ultra = 0, ultra_conf = 0;
 	u8 tmp0 = 0, tmp1 = 0, tmp2 = 0;
 	unsigned long flags;
@@ -115,11 +114,10 @@ static int aec6210_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	return(ide_config_drive_speed(drive, speed));
 }
 
-static int aec6260_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+static int aec6260_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-	u8 speed	= ide_rate_filter(drive, xferspeed);
 	u8 unit		= (drive->select.b.unit & 0x01);
 	u8 tmp1 = 0, tmp2 = 0;
 	u8 ultra = 0, drive_conf = 0, ultra_conf = 0;
@@ -140,9 +138,8 @@ static int aec6260_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	return(ide_config_drive_speed(drive, speed));
 }
 
-static void aec62xx_tune_drive (ide_drive_t *drive, u8 pio)
+static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void) HWIF(drive)->speedproc(drive, pio + XFER_PIO_0);
 }
 
@@ -152,7 +149,7 @@ static int aec62xx_config_drive_xfer_rate (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		aec62xx_tune_drive(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -203,7 +200,7 @@ static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 	u8 reg54 = 0,  mask	= hwif->channel ? 0xf0 : 0x0f;
 	unsigned long flags;
 
-	hwif->tuneproc = &aec62xx_tune_drive;
+	hwif->set_pio_mode = &aec_set_pio_mode;
 
 	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF) {
 		if(hwif->mate)
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 11ecb61..80013d2 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/alim15x3.c		Version 0.25	Jun 9 2007
+ * linux/drivers/ide/pci/alim15x3.c		Version 0.26	Jul 14 2007
  *
  *  Copyright (C) 1998-2000 Michel Aubry, Maintainer
  *  Copyright (C) 1998-2000 Andrzej Krzysztofowicz, Maintainer
@@ -283,17 +283,14 @@ static int ali_get_info (char *buffer, char **addr, off_t offset, int count)
 #endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
 
 /**
- *	ali15x3_tune_pio	-	set up chipset for PIO mode
- *	@drive: drive to tune
- *	@pio: desired mode
- *
- *	Select the best PIO mode for the drive in question.
- *	Then program the controller for this mode.
+ *	ali_tune_pio	-	set host controller for PIO mode
+ *	@drive: drive
+ *	@pio: PIO mode number
  *
- *	Returns the PIO mode programmed.
+ *	Program the controller for the given PIO mode.
  */
- 
-static u8 ali15x3_tune_pio (ide_drive_t *drive, u8 pio)
+
+static void ali_tune_pio(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *dev = hwif->pci_dev;
@@ -306,7 +303,6 @@ static u8 ali15x3_tune_pio (ide_drive_t *drive, u8 pio)
 	u8 cd_dma_fifo = 0;
 	int unit = drive->select.b.unit & 1;
 
-	pio = ide_get_best_pio_mode(drive, pio, 5);
 	s_time = ide_pio_timings[pio].setup_time;
 	a_time = ide_pio_timings[pio].active_time;
 	if ((s_clc = (s_time * bus_speed + 999) / 1000) >= 8)
@@ -359,22 +355,20 @@ static u8 ali15x3_tune_pio (ide_drive_t *drive, u8 pio)
 	 * { 25,   70,     25  },   PIO Mode 4 with IORDY  ns
 	 * { 20,   50,     30  }    PIO Mode 5 with IORDY (nonstandard)
 	 */
-
-	return pio;
 }
 
 /**
- *	ali15x3_tune_drive	-	set up drive for PIO mode
+ *	ali_set_pio_mode	-	set up drive for PIO mode
  *	@drive: drive to tune
  *	@pio: desired mode
  *
- *	Program the controller with the best PIO timing for the given drive.
+ *	Program the controller with the desired PIO timing for the given drive.
  *	Then set up the drive itself.
  */
 
-static void ali15x3_tune_drive (ide_drive_t *drive, u8 pio)
+static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ali15x3_tune_pio(drive, pio);
+	ali_tune_pio(drive, pio);
 	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
@@ -409,22 +403,24 @@ static u8 ali_udma_filter(ide_drive_t *drive)
 /**
  *	ali15x3_tune_chipset	-	set up chipset/drive for new speed
  *	@drive: drive to configure for
- *	@xferspeed: desired speed
+ *	@speed: desired speed
  *
  *	Configure the hardware for the desired IDE transfer mode.
  *	We also do the needed drive configuration through helpers
  */
- 
-static int ali15x3_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+
+static int ali15x3_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-	u8 speed		= ide_rate_filter(drive, xferspeed);
 	u8 speed1		= speed;
 	u8 unit			= (drive->select.b.unit & 0x01);
 	u8 tmpbyte		= 0x00;
 	int m5229_udma		= (hwif->channel) ? 0x57 : 0x56;
 
+	if (speed < XFER_PIO_0)
+		return 1;
+
 	if (speed == XFER_UDMA_6)
 		speed1 = 0x47;
 
@@ -437,8 +433,9 @@ static int ali15x3_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		tmpbyte &= ultra_enable;
 		pci_write_config_byte(dev, m5229_udma, tmpbyte);
 
-		if (speed < XFER_SW_DMA_0)
-			(void) ali15x3_tune_pio(drive, speed - XFER_PIO_0);
+		/*
+		 * FIXME: Oh, my... DMA timings are never set.
+		 */
 	} else {
 		pci_read_config_byte(dev, m5229_udma, &tmpbyte);
 		tmpbyte &= (0x0f << ((1-unit) << 2));
@@ -471,7 +468,7 @@ static int ali15x3_config_drive_for_dma(ide_drive_t *drive)
 	if (ide_tune_dma(drive))
 		return 0;
 
-	ali15x3_tune_drive(drive, 255);
+	ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -701,7 +698,7 @@ static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
 static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 {
 	hwif->autodma = 0;
-	hwif->tuneproc = &ali15x3_tune_drive;
+	hwif->set_pio_mode = &ali_set_pio_mode;
 	hwif->speedproc = &ali15x3_tune_chipset;
 	hwif->udma_filter = &ali_udma_filter;
 
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 06c15a6..513205e 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -1,5 +1,5 @@
 /*
- * Version 2.21
+ * Version 2.22
  *
  * AMD 755/756/766/8111 and nVidia nForce/2/2s/3/3s/CK804/MCP04
  * IDE driver for Linux.
@@ -234,7 +234,7 @@ static void amd_set_speed(struct pci_dev *dev, unsigned char dn, struct ide_timi
  * by upper layers.
  */
 
-static int amd_set_drive(ide_drive_t *drive, u8 speed)
+static int amd_set_drive(ide_drive_t *drive, const u8 speed)
 {
 	ide_drive_t *peer = HWIF(drive)->drives + (~drive->dn & 1);
 	struct ide_timing t, p;
@@ -266,32 +266,21 @@ static int amd_set_drive(ide_drive_t *drive, u8 speed)
 }
 
 /*
- * amd74xx_tune_drive() is a callback from upper layers for
- * PIO-only tuning.
+ * amd_set_pio_mode() is a callback from upper layers for PIO-only tuning.
  */
 
-static void amd74xx_tune_drive(ide_drive_t *drive, u8 pio)
+static void amd_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	if (pio == 255)
-		pio = ide_get_best_pio_mode(drive, 255, 5);
-
-	amd_set_drive(drive, XFER_PIO_0 + min_t(byte, pio, 5));
+	amd_set_drive(drive, XFER_PIO_0 + pio);
 }
 
 static int amd74xx_ide_dma_check(ide_drive_t *drive)
 {
-	u8 speed = ide_max_dma_mode(drive);
-
-	if (speed == 0) {
-		amd74xx_tune_drive(drive, 255);
-		return -1;
-	}
-
-	amd_set_drive(drive, speed);
-
-	if (drive->autodma)
+	if (ide_tune_dma(drive))
 		return 0;
 
+	ide_set_max_pio(drive);
+
 	return -1;
 }
 
@@ -409,7 +398,7 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 
 	hwif->autodma = 0;
 
-	hwif->tuneproc = &amd74xx_tune_drive;
+	hwif->set_pio_mode = &amd_set_pio_mode;
 	hwif->speedproc = &amd_set_drive;
 
 	for (i = 0; i < 2; i++) {
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 1725aa4..178876a 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -153,9 +153,8 @@ static void atiixp_tune_pio(ide_drive_t *drive, u8 pio)
 	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
-static void atiixp_tuneproc(ide_drive_t *drive, u8 pio)
+static void atiixp_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	atiixp_tune_pio(drive, pio);
 	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
@@ -163,28 +162,21 @@ static void atiixp_tuneproc(ide_drive_t *drive, u8 pio)
 /**
  *	atiixp_tune_chipset	-	tune a ATIIXP interface
  *	@drive: IDE drive to tune
- *	@xferspeed: speed to configure
+ *	@speed: speed to configure
  *
  *	Set a ATIIXP interface channel to the desired speeds. This involves
  *	requires the right timing data into the ATIIXP configuration space
  *	then setting the drive parameters appropriately
  */
 
-static int atiixp_speedproc(ide_drive_t *drive, u8 xferspeed)
+static int atiixp_speedproc(ide_drive_t *drive, const u8 speed)
 {
 	struct pci_dev *dev = drive->hwif->pci_dev;
 	unsigned long flags;
 	int timing_shift = (drive->dn & 2) ? 16 : 0 + (drive->dn & 1) ? 0 : 8;
 	u32 tmp32;
 	u16 tmp16;
-	u8 speed, pio;
-
-	speed = ide_rate_filter(drive, xferspeed);
-
-	if (speed >= XFER_PIO_0 && speed <= XFER_PIO_4) {
-		atiixp_tune_pio(drive, speed - XFER_PIO_0);
-		return ide_config_drive_speed(drive, speed);
-	}
+	u8 pio;
 
 	spin_lock_irqsave(&atiixp_lock, flags);
 
@@ -233,7 +225,7 @@ static int atiixp_dma_check(ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		atiixp_tuneproc(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -256,7 +248,7 @@ static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 		hwif->irq = ch ? 15 : 14;
 
 	hwif->autodma = 0;
-	hwif->tuneproc = &atiixp_tuneproc;
+	hwif->set_pio_mode = &atiixp_set_pio_mode;
 	hwif->speedproc = &atiixp_speedproc;
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
@@ -325,7 +317,7 @@ static struct pci_device_id atiixp_pci_tbl[] = {
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index 9689494..f369645 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -628,45 +628,40 @@ static void cmd640_set_mode (unsigned int index, u8 pio_mode, unsigned int cycle
 	program_drive_counts (index);
 }
 
-/*
- * Drive PIO mode selection:
- */
-static void cmd640_tune_drive (ide_drive_t *drive, u8 mode_wanted)
+static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	unsigned int index = 0, cycle_time;
 	u8 b;
 
 	while (drive != cmd_drives[index]) {
 		if (++index > 3) {
-			printk("%s: bad news in cmd640_tune_drive\n", drive->name);
+			printk(KERN_ERR "%s: bad news in %s\n",
+					drive->name, __FUNCTION__);
 			return;
 		}
 	}
-	switch (mode_wanted) {
+	switch (pio) {
 		case 6: /* set fast-devsel off */
 		case 7: /* set fast-devsel on */
-			mode_wanted &= 1;
 			b = get_cmd640_reg(CNTRL) & ~0x27;
-			if (mode_wanted)
+			if (pio & 1)
 				b |= 0x27;
 			put_cmd640_reg(CNTRL, b);
-			printk("%s: %sabled cmd640 fast host timing (devsel)\n", drive->name, mode_wanted ? "en" : "dis");
+			printk("%s: %sabled cmd640 fast host timing (devsel)\n", drive->name, (pio & 1) ? "en" : "dis");
 			return;
 
 		case 8: /* set prefetch off */
 		case 9: /* set prefetch on */
-			mode_wanted &= 1;
-			set_prefetch_mode(index, mode_wanted);
-			printk("%s: %sabled cmd640 prefetch\n", drive->name, mode_wanted ? "en" : "dis");
+			set_prefetch_mode(index, pio & 1);
+			printk("%s: %sabled cmd640 prefetch\n", drive->name, (pio & 1) ? "en" : "dis");
 			return;
 	}
 
-	mode_wanted = ide_get_best_pio_mode(drive, mode_wanted, 5);
-	cycle_time = ide_pio_cycle_time(drive, mode_wanted);
-	cmd640_set_mode(index, mode_wanted, cycle_time);
+	cycle_time = ide_pio_cycle_time(drive, pio);
+	cmd640_set_mode(index, pio, cycle_time);
 
 	printk("%s: selected cmd640 PIO mode%d (%dns)",
-		drive->name, mode_wanted, cycle_time);
+		drive->name, pio, cycle_time);
 
 	display_clocks(index);
 }
@@ -766,8 +761,10 @@ int __init ide_probe_for_cmd640x (void)
 	       cmd_hwif0->name, 'a' + cmd640_chip_version - 1, bus_type, cfr);
 	cmd_hwif0->chipset = ide_cmd640;
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
+	cmd_hwif0->host_flags = IDE_HFLAG_ABUSE_PREFETCH |
+				IDE_HFLAG_ABUSE_FAST_DEVSEL;
 	cmd_hwif0->pio_mask = ATA_PIO5;
-	cmd_hwif0->tuneproc = &cmd640_tune_drive;
+	cmd_hwif0->set_pio_mode = &cmd640_set_pio_mode;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
 	/*
@@ -822,8 +819,10 @@ int __init ide_probe_for_cmd640x (void)
 		cmd_hwif1->mate = cmd_hwif0;
 		cmd_hwif1->channel = 1;
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
+		cmd_hwif1->host_flags = IDE_HFLAG_ABUSE_PREFETCH |
+					IDE_HFLAG_ABUSE_FAST_DEVSEL;
 		cmd_hwif1->pio_mask = ATA_PIO5;
-		cmd_hwif1->tuneproc = &cmd640_tune_drive;
+		cmd_hwif1->set_pio_mode = &cmd640_set_pio_mode;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 	}
 	printk(KERN_INFO "%s: %sserialized, secondary interface %s\n", cmd_hwif1->name,
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 0e3b5de..0b568c6 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -214,28 +214,25 @@ static void program_cycle_times (ide_drive_t *drive, int cycle_time, int active_
 }
 
 /*
- * This routine selects drive's best PIO mode and writes into the chipset
- * registers setup/active/recovery timings.
+ * This routine writes into the chipset registers
+ * PIO setup/active/recovery timings.
  */
-static u8 cmd64x_tune_pio (ide_drive_t *drive, u8 mode_wanted)
+static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	unsigned int cycle_time;
-	u8 pio_mode, setup_count, arttim = 0;
+	u8 setup_count, arttim = 0;
+
 	static const u8 setup_values[] = {0x40, 0x40, 0x40, 0x80, 0, 0xc0};
 	static const u8 arttim_regs[4] = {ARTTIM0, ARTTIM1, ARTTIM23, ARTTIM23};
 
-	pio_mode = ide_get_best_pio_mode(drive, mode_wanted, 5);
-	cycle_time = ide_pio_cycle_time(drive, pio_mode);
-
-	cmdprintk("%s: PIO mode wanted %d, selected %d (%d ns)\n",
-		  drive->name, mode_wanted, pio_mode, cycle_time);
+	cycle_time = ide_pio_cycle_time(drive, pio);
 
 	program_cycle_times(drive, cycle_time,
-			    ide_pio_timings[pio_mode].active_time);
+			    ide_pio_timings[pio].active_time);
 
-	setup_count = quantize_timing(ide_pio_timings[pio_mode].setup_time,
+	setup_count = quantize_timing(ide_pio_timings[pio].setup_time,
 				      1000 / system_bus_clock());
 
 	/*
@@ -266,16 +263,14 @@ static u8 cmd64x_tune_pio (ide_drive_t *drive, u8 mode_wanted)
 	arttim |= setup_values[setup_count];
 	(void) pci_write_config_byte(dev, arttim_regs[drive->dn], arttim);
 	cmdprintk("Write 0x%02x to reg 0x%x\n", arttim, arttim_regs[drive->dn]);
-
-	return pio_mode;
 }
 
 /*
  * Attempts to set drive's PIO mode.
- * Special cases are 8: prefetch off, 9: prefetch on (both never worked),
- * and 255: auto-select best mode (used at boot time).
+ * Special cases are 8: prefetch off, 9: prefetch on (both never worked)
  */
-static void cmd64x_tune_drive (ide_drive_t *drive, u8 pio)
+
+static void cmd64x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	/*
 	 * Filter out the prefetch control values
@@ -284,19 +279,17 @@ static void cmd64x_tune_drive (ide_drive_t *drive, u8 pio)
 	if (pio == 8 || pio == 9)
 		return;
 
-	pio = cmd64x_tune_pio(drive, pio);
+	cmd64x_tune_pio(drive, pio);
 	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
-static int cmd64x_tune_chipset (ide_drive_t *drive, u8 speed)
+static int cmd64x_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u8 unit			= drive->dn & 0x01;
 	u8 regU = 0, pciU	= hwif->channel ? UDIDETCR1 : UDIDETCR0;
 
-	speed = ide_rate_filter(drive, speed);
-
 	if (speed >= XFER_SW_DMA_0) {
 		(void) pci_read_config_byte(dev, pciU, &regU);
 		regU &= ~(unit ? 0xCA : 0x35);
@@ -330,14 +323,6 @@ static int cmd64x_tune_chipset (ide_drive_t *drive, u8 speed)
 	case XFER_MW_DMA_0:
 		program_cycle_times(drive, 480, 215);
 		break;
-	case XFER_PIO_5:
-	case XFER_PIO_4:
-	case XFER_PIO_3:
-	case XFER_PIO_2:
-	case XFER_PIO_1:
-	case XFER_PIO_0:
-		(void) cmd64x_tune_pio(drive, speed - XFER_PIO_0);
-		break;
 	default:
 		return 1;
 	}
@@ -354,7 +339,7 @@ static int cmd64x_config_drive_for_dma (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		cmd64x_tune_drive(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -538,7 +523,7 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 
 	pci_read_config_byte(dev, PCI_REVISION_ID, &rev);
 
-	hwif->tuneproc  = &cmd64x_tune_drive;
+	hwif->set_pio_mode = &cmd64x_set_pio_mode;
 	hwif->speedproc = &cmd64x_tune_chipset;
 
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
@@ -622,6 +607,7 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.udma_mask	= 0x00, /* no udma */
 	},{	/* 1 */
@@ -632,6 +618,7 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.udma_mask	= 0x07, /* udma0-2 */
 	},{	/* 2 */
@@ -642,6 +629,7 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
@@ -652,6 +640,7 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.udma_mask	= 0x3f, /* udma0-5 */
 	}
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index b89e816..1217d2a 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -66,32 +66,13 @@ static struct pio_clocks cs5520_pio_clocks[]={
 	{1, 2, 1}
 };
 
-static int cs5520_tune_chipset(ide_drive_t *drive, u8 xferspeed)
+static void cs5520_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *pdev = hwif->pci_dev;
-	u8 speed = min((u8)XFER_PIO_4, xferspeed);
-	int pio = speed;
-	u8 reg;
 	int controller = drive->dn > 1 ? 1 : 0;
-	int error;
-	
-	switch(speed)
-	{
-		case XFER_PIO_4:
-		case XFER_PIO_3:
-		case XFER_PIO_2:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-			pio -= XFER_PIO_0;
-			break;
-		default:
-			pio = 0;
-			printk(KERN_ERR "cs55x0: bad ide timing.\n");
-	}
-	
-	printk("PIO clocking = %d\n", pio);
-	
+	u8 reg;
+
 	/* FIXME: if DMA = 1 do we need to set the DMA bit here ? */
 
 	/* 8bit CAT/CRT - 8bit command timing for channel */
@@ -115,25 +96,28 @@ static int cs5520_tune_chipset(ide_drive_t *drive, u8 xferspeed)
 	reg = inb(hwif->dma_base + 0x02 + 8*controller);
 	reg |= 1<<((drive->dn&1)+5);
 	outb(reg, hwif->dma_base + 0x02 + 8*controller);
-		
-	error = ide_config_drive_speed(drive, speed);
-	/* ATAPI is harder so leave it for now */
-	if(!error && drive->media == ide_disk)
-		error = hwif->ide_dma_on(drive);
 
-	return error;
-}	
-	
-static void cs5520_tune_drive(ide_drive_t *drive, u8 pio)
+	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
+}
+
+static int cs5520_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
-	cs5520_tune_chipset(drive, (XFER_PIO_0 + pio));
+	printk(KERN_ERR "cs55x0: bad ide timing.\n");
+
+	cs5520_set_pio_mode(drive, 0);
+
+	/*
+	 * FIXME: this is incorrect to return zero here but
+	 * since all users of ide_set_xfer_rate() ignore
+	 * the return value it is not a problem currently
+	 */
+	return 0;
 }
 
 static int cs5520_config_drive_xfer_rate(ide_drive_t *drive)
 {
 	/* Tune the drive for PIO modes up to PIO 4 */	
-	cs5520_tune_drive(drive, 255);
+	ide_set_max_pio(drive);
 
 	/* Then tell the core to use DMA operations */
 	return 0;
@@ -165,7 +149,7 @@ static int cs5520_dma_on(ide_drive_t *drive)
 
 static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 {
-	hwif->tuneproc = &cs5520_tune_drive;
+	hwif->set_pio_mode = &cs5520_set_pio_mode;
 	hwif->speedproc = &cs5520_tune_chipset;
 	hwif->ide_dma_check = &cs5520_config_drive_xfer_rate;
 	hwif->ide_dma_on = &cs5520_dma_on;
@@ -179,7 +163,8 @@ static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 		hwif->drives[1].autotune = 1;
 		return;
 	}
-	
+
+	/* ATAPI is harder so leave it for now */
 	hwif->atapi_dma = 0;
 	hwif->ultra_mask = 0;
 	hwif->swdma_mask = 0;
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index e5949b1..741507b 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -71,19 +71,18 @@ static void cs5530_tunepio(ide_drive_t *drive, u8 pio)
 }
 
 /**
- *	cs5530_tuneproc		-	select/set PIO modes
+ *	cs5530_set_pio_mode	-	set PIO mode
+ *	@drive: drive
+ *	@pio: PIO mode number
  *
- *	cs5530_tuneproc() handles selection/setting of PIO modes
- *	for both the chipset and drive.
+ *	Handles setting of PIO mode for both the chipset and drive.
  *
- *	The ide_init_cs5530() routine guarantees that all drives
+ *	The init_hwif_cs5530() routine guarantees that all drives
  *	will have valid default PIO timings set up before we get here.
  */
 
-static void cs5530_tuneproc (ide_drive_t *drive, u8 pio)	/* pio=255 means "autotune" */
+static void cs5530_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
-
 	if (cs5530_set_xfer_mode(drive, XFER_PIO_0 + pio) == 0)
 		cs5530_tunepio(drive, pio);
 }
@@ -143,13 +142,11 @@ static int cs5530_config_dma(ide_drive_t *drive)
 	return 1;
 }
 
-static int cs5530_tune_chipset(ide_drive_t *drive, u8 mode)
+static int cs5530_tune_chipset(ide_drive_t *drive, const u8 mode)
 {
 	unsigned long basereg;
 	unsigned int reg, timings = 0;
 
-	mode = ide_rate_filter(drive, mode);
-
 	/*
 	 * Tell the drive to switch to the new mode; abort on failure.
 	 */
@@ -166,13 +163,6 @@ static int cs5530_tune_chipset(ide_drive_t *drive, u8 mode)
 		case XFER_MW_DMA_0:	timings = 0x00077771; break;
 		case XFER_MW_DMA_1:	timings = 0x00012121; break;
 		case XFER_MW_DMA_2:	timings = 0x00002020; break;
-		case XFER_PIO_4:
-		case XFER_PIO_3:
-		case XFER_PIO_2:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-			cs5530_tunepio(drive, mode - XFER_PIO_0);
-			return 0;
 		default:
 			BUG();
 			break;
@@ -308,7 +298,7 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 	if (hwif->mate)
 		hwif->serialized = hwif->mate->serialized = 1;
 
-	hwif->tuneproc = &cs5530_tuneproc;
+	hwif->set_pio_mode = &cs5530_set_pio_mode;
 	hwif->speedproc = &cs5530_tune_chipset;
 
 	basereg = CS5530_BASEREG(hwif);
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 082ca7d..383b7ec 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -75,7 +75,7 @@ static unsigned int cs5535_udma_timings[5] =
  *
  *	cs5535_set_speed() configures the chipset to a new speed.
  */
-static void cs5535_set_speed(ide_drive_t *drive, u8 speed)
+static void cs5535_set_speed(ide_drive_t *drive, const u8 speed)
 {
 
 	u32 reg = 0, dummy;
@@ -141,23 +141,22 @@ static void cs5535_set_speed(ide_drive_t *drive, u8 speed)
  */
 static int cs5535_set_drive(ide_drive_t *drive, u8 speed)
 {
-	speed = ide_rate_filter(drive, speed);
 	ide_config_drive_speed(drive, speed);
 	cs5535_set_speed(drive, speed);
 
 	return 0;
 }
 
-/****
- *	cs5535_tuneproc    -       PIO setup
- *	@drive: drive to set up
- *	@pio: mode to use (255 for 'best possible')
+/**
+ *	cs5535_set_pio_mode	-	PIO setup
+ *	@drive: drive
+ *	@pio: PIO mode number
  *
  *	A callback from the upper layers for PIO-only tuning.
  */
-static void cs5535_tuneproc(ide_drive_t *drive, u8 pio)
+
+static void cs5535_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 	cs5535_set_speed(drive, XFER_PIO_0 + pio);
 }
@@ -170,7 +169,7 @@ static int cs5535_dma_check(ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		cs5535_tuneproc(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -199,7 +198,7 @@ static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 
 	hwif->autodma = 0;
 
-	hwif->tuneproc = &cs5535_tuneproc;
+	hwif->set_pio_mode = &cs5535_set_pio_mode;
 	hwif->speedproc = &cs5535_set_drive;
 	hwif->ide_dma_check = &cs5535_dma_check;
 
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index daa36fc..dc27802 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -97,9 +97,6 @@
 #define CY82_INDEX_CHANNEL1	0x31
 #define CY82_INDEX_TIMEOUT	0x32
 
-/* the max PIO mode - from datasheet */
-#define CY82C693_MAX_PIO	4
-
 /* the min and max PCI bus speed in MHz - from datasheet */
 #define CY82C963_MIN_BUS_SPEED	25
 #define CY82C963_MAX_BUS_SPEED	33
@@ -148,9 +145,6 @@ static void compute_clocks (u8 pio, pio_clocks_t *p_pclk)
 	 * so you can play with the idebus=xx parameter
 	 */
 
-	if (pio > CY82C693_MAX_PIO)
-		pio = CY82C693_MAX_PIO;
-
 	/* let's calc the address setup time clocks */
 	p_pclk->address_time = (u8)calc_clk(ide_pio_timings[pio].setup_time, bus_speed);
 
@@ -269,10 +263,7 @@ static int cy82c693_ide_dma_on (ide_drive_t *drive)
         return __ide_dma_on(drive);
 }
 
-/*
- * tune ide drive - set PIO mode
- */
-static void cy82c693_tune_drive (ide_drive_t *drive, u8 pio)
+static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *dev = hwif->pci_dev;
@@ -329,13 +320,6 @@ static void cy82c693_tune_drive (ide_drive_t *drive, u8 pio)
 		addrCtrl, pclk.time_16r, pclk.time_16w, pclk.time_8);
 #endif /* CY82C693_DEBUG_LOGS */
 
-	/* first let's calc the pio modes */
-	pio = ide_get_best_pio_mode(drive, pio, CY82C693_MAX_PIO);
-
-#if CY82C693_DEBUG_INFO
-	printk (KERN_INFO "%s: Selected PIO mode %d\n", drive->name, pio);
-#endif /* CY82C693_DEBUG_INFO */
-
 	/* let's calc the values for this PIO mode */
 	compute_clocks(pio, &pclk);
 
@@ -447,7 +431,7 @@ static void __devinit init_hwif_cy82c693(ide_hwif_t *hwif)
 	hwif->autodma = 0;
 
 	hwif->chipset = ide_cy82c693;
-	hwif->tuneproc = &cy82c693_tune_drive;
+	hwif->set_pio_mode = &cy82c693_set_pio_mode;
 
 	if (!hwif->dma_base) {
 		hwif->drives[0].autotune = 1;
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index cb8fe56..a1bb101 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -43,10 +43,9 @@
 
 #define HPT343_DEBUG_DRIVE_INFO		0
 
-static int hpt34x_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+static int hpt34x_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	struct pci_dev *dev	= HWIF(drive)->pci_dev;
-	u8 speed = ide_rate_filter(drive, xferspeed);
 	u32 reg1= 0, tmp1 = 0, reg2 = 0, tmp2 = 0;
 	u8			hi_speed, lo_speed;
 
@@ -78,9 +77,8 @@ static int hpt34x_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	return(ide_config_drive_speed(drive, speed));
 }
 
-static void hpt34x_tune_drive (ide_drive_t *drive, u8 pio)
+static void hpt34x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 5);
 	(void) hpt34x_tune_chipset(drive, (XFER_PIO_0 + pio));
 }
 
@@ -92,7 +90,7 @@ static int hpt34x_config_drive_xfer_rate (ide_drive_t *drive)
 		return -1;
 
 	if (ide_use_fast_pio(drive))
-		hpt34x_tune_drive(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -146,7 +144,7 @@ static void __devinit init_hwif_hpt34x(ide_hwif_t *hwif)
 
 	hwif->autodma = 0;
 
-	hwif->tuneproc = &hpt34x_tune_drive;
+	hwif->set_pio_mode = &hpt34x_set_pio_mode;
 	hwif->speedproc = &hpt34x_tune_chipset;
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 39f1c89..0e7d3b6 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.12	Aug 19, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.13	Sep 29, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -114,7 +114,7 @@
  *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
  *   the register setting lists into the table indexed by the clock selected
  * - set the correct hwif->ultra_mask for each individual chip
- * - add UltraDMA mode filtering for the HPT37[24] based SATA cards
+ * - add Ultra and MW DMA mode filtering for the HPT37[24] based SATA cards
  *	Sergei Shtylyov, <sshtylyov@ru.mvista.com> or <source@mvista.com>
  */
 
@@ -562,6 +562,24 @@ static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 	return check_in_drive_list(drive, bad_ata33) ? 0x00 : mask;
 }
 
+static u8 hpt3xx_mdma_filter(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct hpt_info *info	= pci_get_drvdata(hwif->pci_dev);
+
+	switch (info->chip_type) {
+	case HPT372 :
+	case HPT372A:
+	case HPT372N:
+	case HPT374 :
+		if (ide_dev_is_sata(drive->id))
+			return 0x00;
+		/* Fall thru */
+	default:
+		return 0x07;
+	}
+}
+
 static u32 get_speed_setting(u8 speed, struct hpt_info *info)
 {
 	int i;
@@ -582,20 +600,15 @@ static u32 get_speed_setting(u8 speed, struct hpt_info *info)
 	return (*info->settings)[i];
 }
 
-static int hpt36x_tune_chipset(ide_drive_t *drive, u8 xferspeed)
+static int hpt36x_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev  *dev	= hwif->pci_dev;
 	struct hpt_info	*info	= pci_get_drvdata(dev);
-	u8  speed		= ide_rate_filter(drive, xferspeed);
 	u8  itr_addr		= drive->dn ? 0x44 : 0x40;
 	u32 old_itr		= 0;
 	u32 itr_mask, new_itr;
 
-	/* TODO: move this to ide_rate_filter() [ check ->atapi_dma ] */
-	if (drive->media != ide_disk)
-		speed = min_t(u8, speed, XFER_PIO_4);
-
 	itr_mask = speed < XFER_MW_DMA_0 ? 0x30070000 :
 		  (speed < XFER_UDMA_0   ? 0xc0070000 : 0xc03800ff);
 
@@ -614,20 +627,15 @@ static int hpt36x_tune_chipset(ide_drive_t *drive, u8 xferspeed)
 	return ide_config_drive_speed(drive, speed);
 }
 
-static int hpt37x_tune_chipset(ide_drive_t *drive, u8 xferspeed)
+static int hpt37x_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev  *dev	= hwif->pci_dev;
 	struct hpt_info	*info	= pci_get_drvdata(dev);
-	u8  speed		= ide_rate_filter(drive, xferspeed);
 	u8  itr_addr		= 0x40 + (drive->dn * 4);
 	u32 old_itr		= 0;
 	u32 itr_mask, new_itr;
 
-	/* TODO: move this to ide_rate_filter() [ check ->atapi_dma ] */
-	if (drive->media != ide_disk)
-		speed = min_t(u8, speed, XFER_PIO_4);
-
 	itr_mask = speed < XFER_MW_DMA_0 ? 0x303c0000 :
 		  (speed < XFER_UDMA_0   ? 0xc03c0000 : 0xc1c001ff);
 
@@ -654,9 +662,8 @@ static int hpt3xx_tune_chipset(ide_drive_t *drive, u8 speed)
 		return hpt36x_tune_chipset(drive, speed);
 }
 
-static void hpt3xx_tune_drive(ide_drive_t *drive, u8 pio)
+static void hpt3xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void) hpt3xx_tune_chipset (drive, XFER_PIO_0 + pio);
 }
 
@@ -718,7 +725,7 @@ static int hpt366_config_drive_xfer_rate(ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		hpt3xx_tune_drive(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -1249,7 +1256,7 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	/* Cache the channel's MISC. control registers' offset */
 	hwif->select_data	= hwif->channel ? 0x54 : 0x50;
 
-	hwif->tuneproc		= &hpt3xx_tune_drive;
+	hwif->set_pio_mode	= &hpt3xx_set_pio_mode;
 	hwif->speedproc		= &hpt3xx_tune_chipset;
 	hwif->quirkproc		= &hpt3xx_quirkproc;
 	hwif->intrproc		= &hpt3xx_intrproc;
@@ -1257,6 +1264,7 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	hwif->busproc		= &hpt3xx_busproc;
 
 	hwif->udma_filter	= &hpt3xx_udma_filter;
+	hwif->mdma_filter	= &hpt3xx_mdma_filter;
 
 	/*
 	 * HPT3xxN chips have some complications:
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 70b3245..76e91ff 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -105,9 +105,8 @@ static void it8213_tune_pio(ide_drive_t *drive, const u8 pio)
 	spin_unlock_irqrestore(&tune_lock, flags);
 }
 
-static void it8213_tuneproc(ide_drive_t *drive, u8 pio)
+static void it8213_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	it8213_tune_pio(drive, pio);
 	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
@@ -115,20 +114,16 @@ static void it8213_tuneproc(ide_drive_t *drive, u8 pio)
 /**
  *	it8213_tune_chipset	-	set controller timings
  *	@drive: Drive to set up
- *	@xferspeed: speed we want to achieve
+ *	@speed: speed we want to achieve
  *
- *	Tune the ITE chipset for the desired mode. If we can't achieve
- *	the desired mode then tune for a lower one, but ultimately
- *	make the thing work.
+ *	Tune the ITE chipset for the desired mode.
  */
 
-static int it8213_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+static int it8213_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
-
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u8 maslave		= 0x40;
-	u8 speed		= ide_rate_filter(drive, xferspeed);
 	int a_speed		= 3 << (drive->dn * 4);
 	int u_flag		= 1 << drive->dn;
 	int v_flag		= 0x01 << drive->dn;
@@ -156,12 +151,6 @@ static int it8213_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		case XFER_MW_DMA_1:
 		case XFER_SW_DMA_2:
 			break;
-		case XFER_PIO_4:
-		case XFER_PIO_3:
-		case XFER_PIO_2:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-			break;
 		default:
 			return -1;
 	}
@@ -193,10 +182,7 @@ static int it8213_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
 	}
 
-	if (speed > XFER_PIO_4)
-		it8213_tune_pio(drive, it8213_dma_2_pio(speed));
-	else
-		it8213_tune_pio(drive, speed - XFER_PIO_0);
+	it8213_tune_pio(drive, it8213_dma_2_pio(speed));
 
 	return ide_config_drive_speed(drive, speed);
 }
@@ -216,7 +202,7 @@ static int it8213_config_drive_for_dma (ide_drive_t *drive)
 	if (ide_tune_dma(drive))
 		return 0;
 
-	it8213_tuneproc(drive, 255);
+	ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -235,7 +221,7 @@ static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 	u8 reg42h = 0;
 
 	hwif->speedproc = &it8213_tune_chipset;
-	hwif->tuneproc	= &it8213_tuneproc;
+	hwif->set_pio_mode = &it8213_set_pio_mode;
 
 	hwif->autodma = 0;
 
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 9286c99..758a982 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -274,9 +274,8 @@ static int it821x_tunepio(ide_drive_t *drive, u8 set_pio)
 	return ide_config_drive_speed(drive, XFER_PIO_0 + set_pio);
 }
 
-static void it821x_tuneproc(ide_drive_t *drive, u8 pio)
+static void it821x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void)it821x_tunepio(drive, pio);
 }
 
@@ -405,32 +404,19 @@ static int it821x_dma_end(ide_drive_t *drive)
 	return ret;
 }
 
-
 /**
  *	it821x_tune_chipset	-	set controller timings
  *	@drive: Drive to set up
- *	@xferspeed: speed we want to achieve
+ *	@speed: speed we want to achieve
  *
- *	Tune the ITE chipset for the desired mode. If we can't achieve
- *	the desired mode then tune for a lower one, but ultimately
- *	make the thing work.
+ *	Tune the ITE chipset for the desired mode.
  */
 
-static int it821x_tune_chipset (ide_drive_t *drive, byte xferspeed)
+static int it821x_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 
 	ide_hwif_t *hwif	= drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	u8 speed		= ide_rate_filter(drive, xferspeed);
-
-	switch (speed) {
-	case XFER_PIO_4:
-	case XFER_PIO_3:
-	case XFER_PIO_2:
-	case XFER_PIO_1:
-	case XFER_PIO_0:
-		return it821x_tunepio(drive, speed - XFER_PIO_0);
-	}
 
 	if (itdev->smart == 0) {
 		switch (speed) {
@@ -477,7 +463,7 @@ static int it821x_config_drive_for_dma (ide_drive_t *drive)
 	if (ide_tune_dma(drive))
 		return 0;
 
-	it821x_tuneproc(drive, 255);
+	ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -644,7 +630,7 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	}
 
 	hwif->speedproc = &it821x_tune_chipset;
-	hwif->tuneproc	= &it821x_tuneproc;
+	hwif->set_pio_mode = &it821x_set_pio_mode;
 
 	/* MWDMA/PIO clock switching for pass through mode */
 	if(!idev->smart) {
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index 65a0ff3..d379fba 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -83,26 +83,22 @@ static u8 __devinit ata66_jmicron(ide_hwif_t *hwif)
 	return ATA_CBL_PATA80;
 }
 
-static void jmicron_tuneproc(ide_drive_t *drive, u8 pio)
+static void jmicron_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 5);
 	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 /**
  *	jmicron_tune_chipset	-	set controller timings
  *	@drive: Drive to set up
- *	@xferspeed: speed we want to achieve
+ *	@speed: speed we want to achieve
  *
  *	As the JMicron snoops for timings all we actually need to do is
- *	make sure we don't set an invalid mode. We do need to honour
- *	the cable detect here.
+ *	set the transfer mode on the device.
  */
 
-static int jmicron_tune_chipset (ide_drive_t *drive, byte xferspeed)
+static int jmicron_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
-	u8 speed = ide_rate_filter(drive, xferspeed);
-
 	return ide_config_drive_speed(drive, speed);
 }
 
@@ -119,7 +115,7 @@ static int jmicron_config_drive_for_dma (ide_drive_t *drive)
 	if (ide_tune_dma(drive))
 		return 0;
 
-	jmicron_tuneproc(drive, 255);
+	ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -134,7 +130,7 @@ static int jmicron_config_drive_for_dma (ide_drive_t *drive)
 static void __devinit init_hwif_jmicron(ide_hwif_t *hwif)
 {
 	hwif->speedproc = &jmicron_tune_chipset;
-	hwif->tuneproc	= &jmicron_tuneproc;
+	hwif->set_pio_mode = &jmicron_set_pio_mode;
 
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
@@ -160,22 +156,13 @@ fallback:
 	return;
 }
 
-#define DECLARE_JMB_DEV(name_str)			\
-	{						\
-		.name		= name_str,		\
-		.init_hwif	= init_hwif_jmicron,	\
-		.autodma	= AUTODMA,		\
-		.bootable	= ON_BOARD,		\
-		.enablebits	= { {0x40, 1, 1}, {0x40, 0x10, 0x10} }, \
-		.pio_mask	= ATA_PIO5,		\
-	}
-
-static ide_pci_device_t jmicron_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_JMB_DEV("JMB361"),
-	/* 1 */ DECLARE_JMB_DEV("JMB363"),
-	/* 2 */ DECLARE_JMB_DEV("JMB365"),
-	/* 3 */ DECLARE_JMB_DEV("JMB366"),
-	/* 4 */ DECLARE_JMB_DEV("JMB368"),
+static ide_pci_device_t jmicron_chipset __devinitdata = {
+	.name		= "JMB",
+	.init_hwif	= init_hwif_jmicron,
+	.autodma	= AUTODMA,
+	.bootable	= ON_BOARD,
+	.enablebits	= { { 0x40, 0x01, 0x01 }, { 0x40, 0x10, 0x10 } },
+	.pio_mask	= ATA_PIO5,
 };
 
 /**
@@ -189,35 +176,29 @@ static ide_pci_device_t jmicron_chipsets[] __devinitdata = {
 
 static int __devinit jmicron_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_setup_pci_device(dev, &jmicron_chipsets[id->driver_data]);
+	ide_setup_pci_device(dev, &jmicron_chipset);
 	return 0;
 }
 
-/* If libata is configured, jmicron PCI quirk will configure it such
- * that the SATA ports are in AHCI function while the PATA ports are
- * in a separate IDE function.  In such cases, match device class and
- * attach only to IDE.  If libata isn't configured, keep the old
- * behavior for backward compatibility.
+/* All JMB PATA controllers have and will continue to have the same
+ * interface.  Matching vendor and device class is enough for all
+ * current and future controllers if the controller is programmed
+ * properly.
+ *
+ * If libata is configured, jmicron PCI quirk programs the controller
+ * into the correct mode.  If libata isn't configured, match known
+ * device IDs too to maintain backward compatibility.
  */
-#if defined(CONFIG_ATA) || defined(CONFIG_ATA_MODULE)
-#define JMB_CLASS	PCI_CLASS_STORAGE_IDE << 8
-#define JMB_CLASS_MASK	0xffff00
-#else
-#define JMB_CLASS	0
-#define JMB_CLASS_MASK	0
-#endif
-
 static struct pci_device_id jmicron_pci_tbl[] = {
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361,
-	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 0},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363,
-	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 1},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365,
-	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 2},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366,
-	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 3},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368,
-	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 4},
+#if !defined(CONFIG_ATA) && !defined(CONFIG_ATA_MODULE)
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB361) },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB363) },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB365) },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB366) },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB368) },
+#endif
+	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 0 },
 	{ 0, },
 };
 
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 3a2bb27..9fa0639 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -47,7 +47,7 @@
  * The main problem with OPTi is that some timings for master
  * and slave must be the same. For example, if you have master
  * PIO 3 and slave PIO 0, driver have to set some timings of
- * master for PIO 0. Second problem is that opti621_tune_drive
+ * master for PIO 0. Second problem is that opti621_set_pio_mode
  * got only one drive to set, but have to set both drives.
  * This is solved in compute_pios. If you don't set
  * the second drive, compute_pios use ide_get_best_pio_mode
@@ -103,7 +103,7 @@
 
 #include <asm/io.h>
 
-#define OPTI621_MAX_PIO 3
+//#define OPTI621_MAX_PIO 3
 /* In fact, I do not have any PIO 4 drive
  * (address: 25 ns, data: 70 ns, recovery: 35 ns),
  * but OPTi 82C621 is programmable and it can do (minimal values):
@@ -136,8 +136,8 @@ static int reg_base;
 #define PIO_NOT_EXIST 254
 #define PIO_DONT_KNOW 255
 
-/* there are stored pio numbers from other calls of opti621_tune_drive */
-static void compute_pios(ide_drive_t *drive, u8 pio)
+/* there are stored pio numbers from other calls of opti621_set_pio_mode */
+static void compute_pios(ide_drive_t *drive, const u8 pio)
 /* Store values into drive->drive_data
  *	second_contr - 0 for primary controller, 1 for secondary
  *	slave_drive - 0 -> pio is for master, 1 -> pio is for slave
@@ -147,12 +147,13 @@ static void compute_pios(ide_drive_t *drive, u8 pio)
 	int d;
 	ide_hwif_t *hwif = HWIF(drive);
 
-	drive->drive_data = ide_get_best_pio_mode(drive, pio, OPTI621_MAX_PIO);
+	drive->drive_data = pio;
+
 	for (d = 0; d < 2; ++d) {
 		drive = &hwif->drives[d];
 		if (drive->present) {
 			if (drive->drive_data == PIO_DONT_KNOW)
-				drive->drive_data = ide_get_best_pio_mode(drive, 255, OPTI621_MAX_PIO);
+				drive->drive_data = ide_get_best_pio_mode(drive, 255, 3);
 #ifdef OPTI621_DEBUG
 			printk("%s: Selected PIO mode %d\n",
 				drive->name, drive->drive_data);
@@ -240,8 +241,7 @@ static void compute_clocks(int pio, pio_clocks_t *clks)
  
 }
 
-/* Main tune procedure, called from tuneproc. */
-static void opti621_tune_drive (ide_drive_t *drive, u8 pio)
+static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	/* primary and secondary drives share some registers,
 	 * so we have to program both drives
@@ -331,7 +331,8 @@ static void __devinit init_hwif_opti621 (ide_hwif_t *hwif)
 	hwif->autodma = 0;
 	hwif->drives[0].drive_data = PIO_DONT_KNOW;
 	hwif->drives[1].drive_data = PIO_DONT_KNOW;
-	hwif->tuneproc = &opti621_tune_drive;
+
+	hwif->set_pio_mode = &opti621_set_pio_mode;
 
 	if (!(hwif->dma_base))
 		return;
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 7b0e479..5fb1eed 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -146,14 +146,12 @@ static struct udma_timing {
 	{ 0x1a, 0x01, 0xcb },	/* UDMA mode 6 */
 };
 
-static int pdcnew_tune_chipset(ide_drive_t *drive, u8 speed)
+static int pdcnew_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	u8 adj			= (drive->dn & 1) ? 0x08 : 0x00;
 	int			err;
 
-	speed = ide_rate_filter(drive, speed);
-
 	/*
 	 * Issue SETFEATURES_XFER to the drive first. PDC202xx hardware will
 	 * automatically set the timing registers based on 100 MHz PLL output.
@@ -217,9 +215,8 @@ static int pdcnew_tune_chipset(ide_drive_t *drive, u8 speed)
 	return err;
 }
 
-static void pdcnew_tune_drive(ide_drive_t *drive, u8 pio)
+static void pdcnew_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void)pdcnew_tune_chipset(drive, XFER_PIO_0 + pio);
 }
 
@@ -239,7 +236,7 @@ static int pdcnew_config_drive_xfer_rate(ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		pdcnew_tune_drive(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -492,7 +489,8 @@ static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 {
 	hwif->autodma = 0;
 
-	hwif->tuneproc  = &pdcnew_tune_drive;
+	hwif->set_pio_mode = &pdcnew_set_pio_mode;
+
 	hwif->quirkproc = &pdcnew_quirkproc;
 	hwif->speedproc = &pdcnew_tune_chipset;
 	hwif->resetproc = &pdcnew_reset;
@@ -524,44 +522,52 @@ static int __devinit init_setup_pdcnew(struct pci_dev *dev, ide_pci_device_t *d)
 	return ide_setup_pci_device(dev, d);
 }
 
-static int __devinit init_setup_pdc20270(struct pci_dev *dev,
-					 ide_pci_device_t *d)
+static int __devinit init_setup_pdc20270(struct pci_dev *dev, ide_pci_device_t *d)
 {
-	struct pci_dev *findev = NULL;
-	int ret;
+	struct pci_dev *bridge = dev->bus->self;
+
+	if (bridge != NULL &&
+	    bridge->vendor == PCI_VENDOR_ID_DEC &&
+	    bridge->device == PCI_DEVICE_ID_DEC_21150) {
+		struct pci_dev *dev2;
 
-	if ((dev->bus->self &&
-	     dev->bus->self->vendor == PCI_VENDOR_ID_DEC) &&
-	    (dev->bus->self->device == PCI_DEVICE_ID_DEC_21150)) {
 		if (PCI_SLOT(dev->devfn) & 2)
 			return -ENODEV;
 
-		while ((findev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, findev)) != NULL) {
-			if ((findev->vendor == dev->vendor) &&
-			    (findev->device == dev->device) &&
-			    (PCI_SLOT(findev->devfn) & 2)) {
-				if (findev->irq != dev->irq) {
-					findev->irq = dev->irq;
-				}
-				ret = ide_setup_pci_devices(dev, findev, d);
-				if (ret < 0)
-					pci_dev_put(findev);
-				return ret;
+		dev2 = pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn) + 2,
+							PCI_FUNC(dev->devfn)));
+		if (dev2 != NULL &&
+		    dev2->vendor == dev->vendor &&
+		    dev2->device == dev->device) {
+			int ret;
+
+			if (dev2->irq != dev->irq) {
+				dev2->irq = dev->irq;
+
+				printk(KERN_WARNING "%s: PCI config space "
+				       "interrupt fixed.\n", d->name);
 			}
+
+			ret = ide_setup_pci_devices(dev, dev2, d);
+			if (ret < 0)
+				pci_dev_put(dev2);
+			return ret;
 		}
 	}
 	return ide_setup_pci_device(dev, d);
 }
 
-static int __devinit init_setup_pdc20276(struct pci_dev *dev,
-					 ide_pci_device_t *d)
+static int __devinit init_setup_pdc20276(struct pci_dev *dev, ide_pci_device_t *d)
 {
-	if ((dev->bus->self) &&
-	    (dev->bus->self->vendor == PCI_VENDOR_ID_INTEL) &&
-	    ((dev->bus->self->device == PCI_DEVICE_ID_INTEL_I960) ||
-	     (dev->bus->self->device == PCI_DEVICE_ID_INTEL_I960RM))) {
-		printk(KERN_INFO "ide: Skipping Promise PDC20276 "
-			"attached to I2O RAID controller.\n");
+	struct pci_dev *bridge = dev->bus->self;
+
+	if (bridge != NULL &&
+	    bridge->vendor == PCI_VENDOR_ID_INTEL &&
+	   (bridge->device == PCI_DEVICE_ID_INTEL_I960 ||
+	    bridge->device == PCI_DEVICE_ID_INTEL_I960RM)) {
+
+		printk(KERN_INFO "%s: attached to I2O RAID controller, "
+				 "skipping.\n", d->name);
 		return -ENODEV;
 	}
 	return ide_setup_pci_device(dev, d);
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index e19a891..b578307 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -63,12 +63,11 @@ static const char *pdc_quirk_drives[] = {
 
 static void pdc_old_disable_66MHz_clock(ide_hwif_t *);
 
-static int pdc202xx_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+static int pdc202xx_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u8 drive_pci		= 0x60 + (drive->dn << 2);
-	u8 speed		= ide_rate_filter(drive, xferspeed);
 
 	u8			AP = 0, BP = 0, CP = 0;
 	u8			TA = 0, TB = 0, TC = 0;
@@ -143,9 +142,8 @@ static int pdc202xx_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	return ide_config_drive_speed(drive, speed);
 }
 
-static void pdc202xx_tune_drive(ide_drive_t *drive, u8 pio)
+static void pdc202xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	pdc202xx_tune_chipset(drive, XFER_PIO_0 + pio);
 }
 
@@ -191,7 +189,7 @@ static int pdc202xx_config_drive_xfer_rate (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		pdc202xx_tune_drive(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -307,10 +305,11 @@ static void pdc202xx_reset (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	ide_hwif_t *mate	= hwif->mate;
-	
+
 	pdc202xx_reset_host(hwif);
 	pdc202xx_reset_host(mate);
-	pdc202xx_tune_drive(drive, 255);
+
+	ide_set_max_pio(drive);
 }
 
 static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
@@ -329,7 +328,9 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 		hwif->rqsize = 256;
 
 	hwif->autodma = 0;
-	hwif->tuneproc  = &pdc202xx_tune_drive;
+
+	hwif->set_pio_mode = &pdc202xx_set_pio_mode;
+
 	hwif->quirkproc = &pdc202xx_quirkproc;
 
 	if (hwif->pci_dev->device != PCI_DEVICE_ID_PROMISE_20246)
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 5cfa937..fd8214a 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.51	Jul 6, 2007
+ *  linux/drivers/ide/pci/piix.c	Version 0.52	Jul 14, 2007
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
@@ -17,11 +17,11 @@
  *                 41
  *                 43
  *
- * | PIO 0       | c0 | 80 | 0 | 	piix_tune_drive(drive, 0);
- * | PIO 2 | SW2 | d0 | 90 | 4 | 	piix_tune_drive(drive, 2);
- * | PIO 3 | MW1 | e1 | a1 | 9 | 	piix_tune_drive(drive, 3);
- * | PIO 4 | MW2 | e3 | a3 | b | 	piix_tune_drive(drive, 4);
- * 
+ * | PIO 0       | c0 | 80 | 0 |
+ * | PIO 2 | SW2 | d0 | 90 | 4 |
+ * | PIO 3 | MW1 | e1 | a1 | 9 |
+ * | PIO 4 | MW2 | e3 | a3 | b |
+ *
  * sitre = word40 & 0x4000; primary
  * sitre = word42 & 0x4000; secondary
  *
@@ -204,16 +204,16 @@ static void piix_tune_pio (ide_drive_t *drive, u8 pio)
 }
 
 /**
- *	piix_tune_drive		-	tune a drive attached to PIIX
+ *	piix_set_pio_mode	-	set PIO mode
  *	@drive: drive to tune
  *	@pio: desired PIO mode
  *
  *	Set the drive's PIO mode (might be useful if drive is not registered
  *	in CMOS for any reason).
  */
-static void piix_tune_drive (ide_drive_t *drive, u8 pio)
+
+static void piix_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	piix_tune_pio(drive, pio);
 	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
@@ -221,19 +221,18 @@ static void piix_tune_drive (ide_drive_t *drive, u8 pio)
 /**
  *	piix_tune_chipset	-	tune a PIIX interface
  *	@drive: IDE drive to tune
- *	@xferspeed: speed to configure
+ *	@speed: speed to configure
  *
  *	Set a PIIX interface channel to the desired speeds. This involves
  *	requires the right timing data into the PIIX configuration space
  *	then setting the drive parameters appropriately
  */
- 
-static int piix_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+
+static int piix_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
-	u8 speed		= ide_rate_filter(drive, xferspeed);
 	int a_speed		= 3 << (drive->dn * 4);
 	int u_flag		= 1 << drive->dn;
 	int v_flag		= 0x01 << drive->dn;
@@ -260,11 +259,6 @@ static int piix_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		case XFER_MW_DMA_2:
 		case XFER_MW_DMA_1:
 		case XFER_SW_DMA_2:	break;
-		case XFER_PIO_4:
-		case XFER_PIO_3:
-		case XFER_PIO_2:
-		case XFER_PIO_1:
-		case XFER_PIO_0:	break;
 		default:		return -1;
 	}
 
@@ -294,10 +288,7 @@ static int piix_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
 	}
 
-	if (speed > XFER_PIO_4)
-		piix_tune_pio(drive, piix_dma_2_pio(speed));
-	else
-		piix_tune_pio(drive, speed - XFER_PIO_0);
+	piix_tune_pio(drive, piix_dma_2_pio(speed));
 
 	return ide_config_drive_speed(drive, speed);
 }
@@ -318,7 +309,7 @@ static int piix_config_drive_xfer_rate (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		piix_tune_drive(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -455,7 +446,8 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 	}
 
 	hwif->autodma = 0;
-	hwif->tuneproc = &piix_tune_drive;
+
+	hwif->set_pio_mode = &piix_set_pio_mode;
 	hwif->speedproc = &piix_tune_chipset;
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 9bdc969..79ecab6 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -138,7 +138,7 @@ out:
 	return mask;
 }
 
-static int sc1200_tune_chipset(ide_drive_t *drive, u8 mode)
+static int sc1200_tune_chipset(ide_drive_t *drive, const u8 mode)
 {
 	ide_hwif_t		*hwif = HWIF(drive);
 	int			unit = drive->select.b.unit;
@@ -146,25 +146,11 @@ static int sc1200_tune_chipset(ide_drive_t *drive, u8 mode)
 	unsigned short		pci_clock;
 	unsigned int		basereg = hwif->channel ? 0x50 : 0x40;
 
-	mode = ide_rate_filter(drive, mode);
-
 	/*
 	 * Tell the drive to switch to the new mode; abort on failure.
 	 */
-	if (sc1200_set_xfer_mode(drive, mode)) {
-		printk("SC1200: set xfer mode failure\n");
+	if (sc1200_set_xfer_mode(drive, mode))
 		return 1;	/* failure */
-	}
-
-	switch (mode) {
-	case XFER_PIO_4:
-	case XFER_PIO_3:
-	case XFER_PIO_2:
-	case XFER_PIO_1:
-	case XFER_PIO_0:
-		sc1200_tunepio(drive, mode - XFER_PIO_0);
-		return 0;
-	}
 
 	pci_clock = sc1200_get_pci_clock();
 
@@ -274,19 +260,20 @@ static int sc1200_ide_dma_end (ide_drive_t *drive)
 }
 
 /*
- * sc1200_tuneproc() handles selection/setting of PIO modes
+ * sc1200_set_pio_mode() handles setting of PIO modes
  * for both the chipset and drive.
  *
  * All existing BIOSs for this chipset guarantee that all drives
  * will have valid default PIO timings set up before we get here.
  */
-static void sc1200_tuneproc (ide_drive_t *drive, byte pio)	/* mode=255 means "autotune" */
+
+static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t	*hwif = HWIF(drive);
 	int		mode = -1;
 
 	/*
-	 * bad abuse of ->tuneproc interface
+	 * bad abuse of ->set_pio_mode interface
 	 */
 	switch (pio) {
 		case 200: mode = XFER_UDMA_0;	break;
@@ -304,9 +291,6 @@ static void sc1200_tuneproc (ide_drive_t *drive, byte pio)	/* mode=255 means "au
 		return;
 	}
 
-	pio = ide_get_best_pio_mode(drive, pio, 4);
-	printk("SC1200: %s: setting PIO mode%d\n", drive->name, pio);
-
 	if (sc1200_set_xfer_mode(drive, XFER_PIO_0 + pio) == 0)
 		sc1200_tunepio(drive, pio);
 }
@@ -422,7 +406,8 @@ static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
 		hwif->ide_dma_end   = &sc1200_ide_dma_end;
         	if (!noautodma)
                 	hwif->autodma = 1;
-		hwif->tuneproc = &sc1200_tuneproc;
+
+		hwif->set_pio_mode = &sc1200_set_pio_mode;
 		hwif->speedproc = &sc1200_tune_chipset;
 	}
         hwif->atapi_dma = 1;
@@ -438,6 +423,7 @@ static ide_pci_device_t sc1200_chipset __devinitdata = {
 	.init_hwif	= init_hwif_sc1200,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
+	.host_flags	= IDE_HFLAG_ABUSE_DMA_MODES,
 	.pio_mask	= ATA_PIO4,
 };
 
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index eeb0a6d..66a526e 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -221,9 +221,8 @@ static void scc_tune_pio(ide_drive_t *drive, const u8 pio)
 	out_be32((void __iomem *)pioct_port, reg);
 }
 
-static void scc_tuneproc(ide_drive_t *drive, u8 pio)
+static void scc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	scc_tune_pio(drive, pio);
 	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
@@ -231,16 +230,15 @@ static void scc_tuneproc(ide_drive_t *drive, u8 pio)
 /**
  *	scc_tune_chipset	-	tune a drive DMA mode
  *	@drive: Drive to set up
- *	@xferspeed: speed we want to achieve
+ *	@speed: speed we want to achieve
  *
  *	Load the timing settings for this device mode into the
  *	controller.
  */
 
-static int scc_tune_chipset(ide_drive_t *drive, byte xferspeed)
+static int scc_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	u8 speed = ide_rate_filter(drive, xferspeed);
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 	unsigned long ctl_base = ports->ctl;
 	unsigned long cckctrl_port = ctl_base + 0xff0;
@@ -272,13 +270,6 @@ static int scc_tune_chipset(ide_drive_t *drive, byte xferspeed)
 	case XFER_UDMA_0:
 		idx = speed - XFER_UDMA_0;
 		break;
-	case XFER_PIO_4:
-	case XFER_PIO_3:
-	case XFER_PIO_2:
-	case XFER_PIO_1:
-	case XFER_PIO_0:
-		scc_tune_pio(drive, speed - XFER_PIO_0);
-		return ide_config_drive_speed(drive, speed);
 	default:
 		return 1;
 	}
@@ -317,7 +308,7 @@ static int scc_config_drive_for_dma(ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		scc_tuneproc(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -718,7 +709,7 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 	hwif->dma_setup = scc_dma_setup;
 	hwif->ide_dma_end = scc_ide_dma_end;
 	hwif->speedproc = scc_tune_chipset;
-	hwif->tuneproc = scc_tuneproc;
+	hwif->set_pio_mode = scc_set_pio_mode;
 	hwif->ide_dma_check = scc_config_drive_for_dma;
 	hwif->ide_dma_test_irq = scc_dma_test_irq;
 	hwif->udma_filter = scc_udma_filter;
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index 9fead2e..0351cf2 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -145,7 +145,7 @@ static void svwks_tune_pio(ide_drive_t *drive, const u8 pio)
 	}
 }
 
-static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+static int svwks_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	static const u8 udma_modes[]		= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05 };
 	static const u8 dma_modes[]		= { 0x77, 0x21, 0x20 };
@@ -153,16 +153,10 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-	u8 speed		= ide_rate_filter(drive, xferspeed);
 	u8 unit			= (drive->select.b.unit & 0x01);
 
 	u8 ultra_enable	 = 0, ultra_timing = 0, dma_timing = 0;
 
-	if (speed >= XFER_PIO_0 && speed <= XFER_PIO_4) {
-		svwks_tune_pio(drive, speed - XFER_PIO_0);
-		return ide_config_drive_speed(drive, speed);
-	}
-
 	/* If we are about to put a disk into UDMA mode we screwed up.
 	   Our code assumes we never _ever_ do this on an OSB4 */
 	   
@@ -203,9 +197,8 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	return (ide_config_drive_speed(drive, speed));
 }
 
-static void svwks_tune_drive (ide_drive_t *drive, u8 pio)
+static void svwks_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	svwks_tune_pio(drive, pio);
 	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
@@ -218,7 +211,7 @@ static int svwks_config_drive_xfer_rate (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		svwks_tune_drive(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -390,7 +383,7 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 	if (!hwif->irq)
 		hwif->irq = hwif->channel ? 15 : 14;
 
-	hwif->tuneproc = &svwks_tune_drive;
+	hwif->set_pio_mode = &svwks_set_pio_mode;
 	hwif->speedproc = &svwks_tune_chipset;
 	hwif->udma_filter = &svwks_udma_filter;
 
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 5714576..c292e1d 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -34,6 +34,8 @@
 
 #include <linux/ide.h>
 
+#define DRV_NAME "SGIIOC4"
+
 /* IOC4 Specific Definitions */
 #define IOC4_CMD_OFFSET		0x100
 #define IOC4_CTRL_OFFSET	0x120
@@ -289,15 +291,26 @@ static void sgiioc4_dma_off_quietly(ide_drive_t *drive)
 	drive->hwif->dma_host_off(drive);
 }
 
+static int sgiioc4_speedproc(ide_drive_t *drive, const u8 speed)
+{
+	if (speed != XFER_MW_DMA_2)
+		return 1;
+
+	return ide_config_drive_speed(drive, speed);
+}
+
 static int sgiioc4_ide_dma_check(ide_drive_t *drive)
 {
-	/* FIXME: check for available DMA modes */
-	if (ide_config_drive_speed(drive, XFER_MW_DMA_2) != 0) {
-		printk(KERN_WARNING "%s: couldn't set MWDMA2 mode, "
-				    "using PIO instead\n", drive->name);
-		return -1;
-	} else
+	if (ide_tune_dma(drive))
 		return 0;
+
+	/*
+	 * ->set_pio_mode is not implemented currently
+	 * so this is just for the completness
+	 */
+	ide_set_max_pio(drive);
+
+	return -1;
 }
 
 /* returns 1 if dma irq issued, 0 otherwise */
@@ -353,7 +366,7 @@ sgiioc4_INB(unsigned long port)
 }
 
 /* Creates a dma map for the scatter-gather list entries */
-static void __devinit
+static int __devinit
 ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
 {
 	void __iomem *virt_dma_base;
@@ -369,7 +382,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
 		       "ALREADY in use\n",
 		       __FUNCTION__, hwif->name, (void *) dma_base,
 		       (void *) dma_base + num_ports - 1);
-		goto dma_alloc_failure;
+		return -1;
 	}
 
 	virt_dma_base = ioremap(dma_base, num_ports);
@@ -395,7 +408,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
 
 	if (pad) {
 		ide_set_hwifdata(hwif, pad);
-		return;
+		return 0;
 	}
 
 	pci_free_consistent(hwif->pci_dev,
@@ -413,10 +426,7 @@ dma_pci_alloc_failure:
 dma_remap_failure:
 	release_mem_region(dma_base, num_ports);
 
-dma_alloc_failure:
-	/* Disable DMA because we couldnot allocate any DMA maps */
-	hwif->autodma = 0;
-	hwif->atapi_dma = 0;
+	return -1;
 }
 
 /* Initializes the IOC4 DMA Engine */
@@ -581,14 +591,11 @@ static void __devinit
 ide_init_sgiioc4(ide_hwif_t * hwif)
 {
 	hwif->mmio = 1;
-	hwif->autodma = 1;
 	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x0;	/* Disable Ultra DMA */
-	hwif->mwdma_mask = 0x2;	/* Multimode-2 DMA  */
-	hwif->swdma_mask = 0x2;
+	hwif->mwdma_mask = 0x04;
 	hwif->pio_mask = 0x00;
-	hwif->tuneproc = NULL;	/* Sets timing for PIO mode */
-	hwif->speedproc = NULL;	/* Sets timing for DMA &/or PIO modes */
+	hwif->set_pio_mode = NULL; /* Sets timing for PIO mode */
+	hwif->speedproc = &sgiioc4_speedproc;
 	hwif->selectproc = NULL;/* Use the default routine to select drive */
 	hwif->reset_poll = NULL;/* No HBA specific reset_poll needed */
 	hwif->pre_reset = NULL;	/* No HBA specific pre_set needed */
@@ -615,7 +622,7 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 }
 
 static int __devinit
-sgiioc4_ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t * d)
+sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 {
 	unsigned long cmd_base, dma_base, irqport;
 	unsigned long bar0, cmd_phys_base, ctl;
@@ -632,7 +639,8 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t * d)
 			break;
 	}
 	if (h == MAX_HWIFS) {
-		printk(KERN_ERR "%s: too many IDE interfaces, no room in table\n", d->name);
+		printk(KERN_ERR "%s: too many IDE interfaces, no room in table\n",
+				DRV_NAME);
 		return -ENOMEM;
 	}
 
@@ -641,7 +649,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t * d)
 	virt_base = ioremap(bar0, pci_resource_len(dev, 0));
 	if (virt_base == NULL) {
 		printk(KERN_ERR "%s: Unable to remap BAR 0 address: 0x%lx\n",
-			d->name, bar0);
+				DRV_NAME, bar0);
 		return -ENOMEM;
 	}
 	cmd_base = (unsigned long) virt_base + IOC4_CMD_OFFSET;
@@ -672,7 +680,6 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t * d)
 	hwif->chipset = ide_pci;
 	hwif->pci_dev = dev;
 	hwif->channel = 0;	/* Single Channel chip */
-	hwif->cds = (struct ide_pci_device_s *) d;
 	hwif->gendev.parent = &dev->dev;/* setup proper ancestral information */
 
 	/* The IOC4 uses MMIO rather than Port IO. */
@@ -683,11 +690,14 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t * d)
 
 	ide_init_sgiioc4(hwif);
 
-	if (dma_base)
-		ide_dma_sgiioc4(hwif, dma_base);
-	else
+	hwif->autodma = 0;
+
+	if (dma_base && ide_dma_sgiioc4(hwif, dma_base) == 0) {
+		hwif->autodma = 1;
+		hwif->drives[1].autodma = hwif->drives[0].autodma = 1;
+	} else
 		printk(KERN_INFO "%s: %s Bus-Master DMA disabled\n",
-		       hwif->name, d->name);
+				 hwif->name, DRV_NAME);
 
 	if (probe_hwif_init(hwif))
 		return -EIO;
@@ -699,7 +709,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t * d)
 }
 
 static unsigned int __devinit
-pci_init_sgiioc4(struct pci_dev *dev, ide_pci_device_t * d)
+pci_init_sgiioc4(struct pci_dev *dev)
 {
 	unsigned int class_rev;
 	int ret;
@@ -707,30 +717,20 @@ pci_init_sgiioc4(struct pci_dev *dev, ide_pci_device_t * d)
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
 	class_rev &= 0xff;
 	printk(KERN_INFO "%s: IDE controller at PCI slot %s, revision %d\n",
-			d->name, pci_name(dev), class_rev);
+			 DRV_NAME, pci_name(dev), class_rev);
 	if (class_rev < IOC4_SUPPORTED_FIRMWARE_REV) {
 		printk(KERN_ERR "Skipping %s IDE controller in slot %s: "
-			"firmware is obsolete - please upgrade to revision"
-			"46 or higher\n", d->name, pci_name(dev));
+				"firmware is obsolete - please upgrade to "
+				"revision46 or higher\n",
+				DRV_NAME, pci_name(dev));
 		ret = -EAGAIN;
 		goto out;
 	}
-	ret = sgiioc4_ide_setup_pci_device(dev, d);
+	ret = sgiioc4_ide_setup_pci_device(dev);
 out:
 	return ret;
 }
 
-static ide_pci_device_t sgiioc4_chipset __devinitdata = {
-	 /* Channel 0 */
-	 .name = "SGIIOC4",
-	 .init_hwif = ide_init_sgiioc4,
-	 .init_dma = ide_dma_sgiioc4,
-	 .autodma = AUTODMA,
-	 /* SGI IOC4 doesn't have enablebits. */
-	 .bootable = ON_BOARD,
-	 .host_flags = IDE_HFLAG_SINGLE,
-};
-
 int
 ioc4_ide_attach_one(struct ioc4_driver_data *idd)
 {
@@ -740,7 +740,7 @@ ioc4_ide_attach_one(struct ioc4_driver_data *idd)
 	if (idd->idd_variant == IOC4_VARIANT_PCI_RT)
 		return 0;
 
-	return pci_init_sgiioc4(idd->idd_pdev, &sgiioc4_chipset);
+	return pci_init_sgiioc4(idd->idd_pdev);
 }
 
 static struct ioc4_submodule ioc4_ide_submodule = {
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 50f6d17..5d1e5e5 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/siimage.c		Version 1.15	Jun 29 2007
+ * linux/drivers/ide/pci/siimage.c		Version 1.16	Jul 13 2007
  *
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat <alan@redhat.com>
@@ -185,7 +185,12 @@ static void sil_tune_pio(ide_drive_t *drive, u8 pio)
 	u16 speedp		= 0;
 	unsigned long addr	= siimage_seldev(drive, 0x04);
 	unsigned long tfaddr	= siimage_selreg(hwif, 0x02);
+	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u8 tf_pio		= pio;
+	u8 addr_mask		= hwif->channel ? (hwif->mmio ? 0xF4 : 0x84)
+						: (hwif->mmio ? 0xB4 : 0x80);
+	u8 mode			= 0;
+	u8 unit			= drive->select.b.unit;
 
 	/* trim *taskfile* PIO to the slowest of the master/slave */
 	if (pair->present) {
@@ -207,6 +212,11 @@ static void sil_tune_pio(ide_drive_t *drive, u8 pio)
 			hwif->OUTW(hwif->INW(tfaddr-2)|0x200, tfaddr-2);
 		else
 			hwif->OUTW(hwif->INW(tfaddr-2)&~0x200, tfaddr-2);
+
+		mode = hwif->INB(base + addr_mask);
+		mode &= ~(unit ? 0x30 : 0x03);
+		mode |= (unit ? 0x10 : 0x01);
+		hwif->OUTB(mode, base + addr_mask);
 	} else {
 		pci_write_config_word(hwif->pci_dev, addr, speedp);
 		pci_write_config_word(hwif->pci_dev, tfaddr, speedt);
@@ -216,12 +226,16 @@ static void sil_tune_pio(ide_drive_t *drive, u8 pio)
 		if (pio > 2)
 			speedp |= 0x200;
 		pci_write_config_word(hwif->pci_dev, tfaddr-2, speedp);
+
+		pci_read_config_byte(hwif->pci_dev, addr_mask, &mode);
+		mode &= ~(unit ? 0x30 : 0x03);
+		mode |= (unit ? 0x10 : 0x01);
+		pci_write_config_byte(hwif->pci_dev, addr_mask, mode);
 	}
 }
 
-static void sil_tuneproc(ide_drive_t *drive, u8 pio)
+static void sil_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	sil_tune_pio(drive, pio);
 	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
@@ -229,14 +243,12 @@ static void sil_tuneproc(ide_drive_t *drive, u8 pio)
 /**
  *	siimage_tune_chipset	-	set controller timings
  *	@drive: Drive to set up
- *	@xferspeed: speed we want to achieve
+ *	@speed: speed we want to achieve
  *
- *	Tune the SII chipset for the desired mode. If we can't achieve
- *	the desired mode then tune for a lower one, but ultimately
- *	make the thing work.
+ *	Tune the SII chipset for the desired mode.
  */
- 
-static int siimage_tune_chipset (ide_drive_t *drive, byte xferspeed)
+
+static int siimage_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	u8 ultra6[]		= { 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 };
 	u8 ultra5[]		= { 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01 };
@@ -245,7 +257,6 @@ static int siimage_tune_chipset (ide_drive_t *drive, byte xferspeed)
 	ide_hwif_t *hwif	= HWIF(drive);
 	u16 ultra = 0, multi	= 0;
 	u8 mode = 0, unit	= drive->select.b.unit;
-	u8 speed		= ide_rate_filter(drive, xferspeed);
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u8 scsc = 0, addr_mask	= ((hwif->channel) ?
 				    ((hwif->mmio) ? 0xF4 : 0x84) :
@@ -273,14 +284,6 @@ static int siimage_tune_chipset (ide_drive_t *drive, byte xferspeed)
 	scsc = is_sata(hwif) ? 1 : scsc;
 
 	switch(speed) {
-		case XFER_PIO_4:
-		case XFER_PIO_3:
-		case XFER_PIO_2:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-			sil_tune_pio(drive, speed - XFER_PIO_0);
-			mode |= ((unit) ? 0x10 : 0x01);
-			break;
 		case XFER_MW_DMA_2:
 		case XFER_MW_DMA_1:
 		case XFER_MW_DMA_0:
@@ -331,7 +334,7 @@ static int siimage_config_drive_for_dma (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		sil_tuneproc(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -902,7 +905,7 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 	
 	hwif->resetproc = &siimage_reset;
 	hwif->speedproc = &siimage_tune_chipset;
-	hwif->tuneproc	= &sil_tuneproc;
+	hwif->set_pio_mode = &sil_set_pio_mode;
 	hwif->reset_poll = &siimage_reset_poll;
 	hwif->pre_reset = &siimage_pre_reset;
 	hwif->udma_filter = &sil_udma_filter;
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 26f2480..3e18899 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/sis5513.c	Version 0.25	Jun 10, 2007
+ * linux/drivers/ide/pci/sis5513.c	Version 0.27	Jul 14, 2007
  *
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2002		Lionel Bouton <Lionel.Bouton@inet6.fr>, Maintainer
@@ -519,27 +519,18 @@ static void config_art_rwp_pio (ide_drive_t *drive, u8 pio)
 	}
 }
 
-static int sis5513_tune_drive(ide_drive_t *drive, u8 pio)
+static void sis_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	config_art_rwp_pio(drive, pio);
-	return ide_config_drive_speed(drive, XFER_PIO_0 + pio);
+	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
-static void sis5513_tuneproc(ide_drive_t *drive, u8 pio)
-{
-	(void)sis5513_tune_drive(drive, pio);
-}
-
-static int sis5513_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+static int sis5513_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-
-	u8 drive_pci, reg, speed;
 	u32 regdw;
-
-	speed = ide_rate_filter(drive, xferspeed);
+	u8 drive_pci, reg;
 
 	/* See config_art_rwp_pio for drive pci config registers */
 	drive_pci = 0x40;
@@ -582,9 +573,6 @@ static int sis5513_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 					regdw |= (unsigned long)cycle_time_value[ATA_133][speed-XFER_UDMA_0] << 4;
 					regdw |= (unsigned long)cvs_time_value[ATA_133][speed-XFER_UDMA_0] << 8;
 				} else {
-				/* if ATA133 disable, we should not set speed above UDMA5 */
-					if (speed > XFER_UDMA_5)
-						speed = XFER_UDMA_5;
 					regdw |= (unsigned long)cycle_time_value[ATA_100][speed-XFER_UDMA_0] << 4;
 					regdw |= (unsigned long)cvs_time_value[ATA_100][speed-XFER_UDMA_0] << 8;
 				}
@@ -608,12 +596,6 @@ static int sis5513_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		case XFER_SW_DMA_1:
 		case XFER_SW_DMA_0:
 			break;
-		case XFER_PIO_4:
-		case XFER_PIO_3:
-		case XFER_PIO_2:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-			return sis5513_tune_drive(drive, speed - XFER_PIO_0);
 		default:
 			BUG();
 			break;
@@ -627,7 +609,7 @@ static int sis5513_config_xfer_rate(ide_drive_t *drive)
 	/*
 	 * TODO: always set PIO mode and remove this
 	 */
-	sis5513_tuneproc(drive, 255);
+	ide_set_max_pio(drive);
 
 	drive->init_speed = 0;
 
@@ -635,11 +617,25 @@ static int sis5513_config_xfer_rate(ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		sis5513_tuneproc(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
 
+static u8 sis5513_ata133_udma_filter(ide_drive_t *drive)
+{
+	struct pci_dev *dev = drive->hwif->pci_dev;
+	int drive_pci;
+	u32 reg54 = 0, regdw = 0;
+
+	pci_read_config_dword(dev, 0x54, &reg54);
+	drive_pci = ((reg54 & 0x40000000) ? 0x70 : 0x40) + drive->dn * 4;
+	pci_read_config_dword(dev, drive_pci, &regdw);
+
+	/* if ATA133 disable, we should not set speed above UDMA5 */
+	return (regdw & 0x08) ? ATA_UDMA6 : ATA_UDMA5;
+}
+
 /* Chip detection and general config */
 static unsigned int __devinit init_chipset_sis5513 (struct pci_dev *dev, const char *name)
 {
@@ -844,9 +840,12 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 	if (!hwif->irq)
 		hwif->irq = hwif->channel ? 15 : 14;
 
-	hwif->tuneproc = &sis5513_tuneproc;
+	hwif->set_pio_mode = &sis_set_pio_mode;
 	hwif->speedproc = &sis5513_tune_chipset;
 
+	if (chipset_family >= ATA_133)
+		hwif->udma_filter = sis5513_ata133_udma_filter;
+
 	if (!(hwif->dma_base)) {
 		hwif->drives[0].autotune = 1;
 		hwif->drives[1].autotune = 1;
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 0947cab..f492318 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -75,16 +75,12 @@ static unsigned int get_pio_timings(ide_drive_t *drive, u8 pio)
 /*
  * Configure the chipset for PIO mode.
  */
-static u8 sl82c105_tune_pio(ide_drive_t *drive, u8 pio)
+static void sl82c105_tune_pio(ide_drive_t *drive, const u8 pio)
 {
 	struct pci_dev *dev	= HWIF(drive)->pci_dev;
 	int reg			= 0x44 + drive->dn * 4;
 	u16 drv_ctrl;
 
-	DBG(("sl82c105_tune_pio(drive:%s, pio:%u)\n", drive->name, pio));
-
-	pio = ide_get_best_pio_mode(drive, pio, 5);
-
 	drv_ctrl = get_pio_timings(drive, pio);
 
 	/*
@@ -106,14 +102,12 @@ static u8 sl82c105_tune_pio(ide_drive_t *drive, u8 pio)
 	printk(KERN_DEBUG "%s: selected %s (%dns) (%04X)\n", drive->name,
 			  ide_xfer_verbose(pio + XFER_PIO_0),
 			  ide_pio_cycle_time(drive, pio), drv_ctrl);
-
-	return pio;
 }
 
 /*
  * Configure the drive and chipset for a new transfer speed.
  */
-static int sl82c105_tune_chipset(ide_drive_t *drive, u8 speed)
+static int sl82c105_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	static u16 mwdma_timings[] = {0x0707, 0x0201, 0x0200};
 	u16 drv_ctrl;
@@ -121,8 +115,6 @@ static int sl82c105_tune_chipset(ide_drive_t *drive, u8 speed)
  	DBG(("sl82c105_tune_chipset(drive:%s, speed:%s)\n",
 	     drive->name, ide_xfer_verbose(speed)));
 
-	speed = ide_rate_filter(drive, speed);
-
 	switch (speed) {
 	case XFER_MW_DMA_2:
 	case XFER_MW_DMA_1:
@@ -147,14 +139,6 @@ static int sl82c105_tune_chipset(ide_drive_t *drive, u8 speed)
 			pci_write_config_word(dev, reg, drv_ctrl);
 		}
 		break;
-	case XFER_PIO_5:
-	case XFER_PIO_4:
-	case XFER_PIO_3:
-	case XFER_PIO_2:
-	case XFER_PIO_1:
-	case XFER_PIO_0:
-		(void) sl82c105_tune_pio(drive, speed - XFER_PIO_0);
-		break;
 	default:
 		return -1;
 	}
@@ -327,11 +311,10 @@ static void sl82c105_resetproc(ide_drive_t *drive)
  * We only deal with PIO mode here - DMA mode 'using_dma' is not
  * initialised at the point that this function is called.
  */
-static void sl82c105_tune_drive(ide_drive_t *drive, u8 pio)
+static void sl82c105_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	DBG(("sl82c105_tune_drive(drive:%s, pio:%u)\n", drive->name, pio));
+	sl82c105_tune_pio(drive, pio);
 
-	pio = sl82c105_tune_pio(drive, pio);
 	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
@@ -399,7 +382,7 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 
 	DBG(("init_hwif_sl82c105(hwif: ide%d)\n", hwif->index));
 
-	hwif->tuneproc		= &sl82c105_tune_drive;
+	hwif->set_pio_mode	= &sl82c105_set_pio_mode;
 	hwif->speedproc 	= &sl82c105_tune_chipset;
 	hwif->selectproc	= &sl82c105_selectproc;
 	hwif->resetproc 	= &sl82c105_resetproc;
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index 628b066..ae8e913 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/slc90e66.c	Version 0.15	Jul 6, 2007
+ *  linux/drivers/ide/pci/slc90e66.c	Version 0.16	Jul 14, 2007
  *
  *  Copyright (C) 2000-2002 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
@@ -95,19 +95,17 @@ static void slc90e66_tune_pio (ide_drive_t *drive, u8 pio)
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
-static void slc90e66_tune_drive (ide_drive_t *drive, u8 pio)
+static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	slc90e66_tune_pio(drive, pio);
 	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
-static int slc90e66_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+static int slc90e66_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
-	u8 speed		= ide_rate_filter(drive, xferspeed);
 	int sitre = 0, a_speed	= 7 << (drive->dn * 4);
 	int u_speed = 0, u_flag = 1 << drive->dn;
 	u16			reg4042, reg44, reg48, reg4a;
@@ -127,11 +125,6 @@ static int slc90e66_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		case XFER_MW_DMA_2:
 		case XFER_MW_DMA_1:
 		case XFER_SW_DMA_2:	break;
-		case XFER_PIO_4:
-		case XFER_PIO_3:
-		case XFER_PIO_2:
-		case XFER_PIO_1:
-		case XFER_PIO_0:        break;
 		default:		return -1;
 	}
 
@@ -151,10 +144,7 @@ static int slc90e66_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
 	}
 
-	if (speed > XFER_PIO_4)
-		slc90e66_tune_pio(drive, slc90e66_dma_2_pio(speed));
-	else
-		slc90e66_tune_pio(drive, speed - XFER_PIO_0);
+	slc90e66_tune_pio(drive, slc90e66_dma_2_pio(speed));
 
 	return ide_config_drive_speed(drive, speed);
 }
@@ -167,7 +157,7 @@ static int slc90e66_config_drive_xfer_rate (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		slc90e66_tune_drive(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -183,7 +173,7 @@ static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 		hwif->irq = hwif->channel ? 15 : 14;
 
 	hwif->speedproc = &slc90e66_tune_chipset;
-	hwif->tuneproc	= &slc90e66_tune_drive;
+	hwif->set_pio_mode = &slc90e66_set_pio_mode;
 
 	pci_read_config_byte(hwif->pci_dev, 0x47, &reg47);
 
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index ec79bac..e23b9cf 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -13,14 +13,12 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
-static int tc86c001_tune_chipset(ide_drive_t *drive, u8 speed)
+static int tc86c001_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long scr_port	= hwif->config_data + (drive->dn ? 0x02 : 0x00);
 	u16 mode, scr		= hwif->INW(scr_port);
 
-	speed = ide_rate_filter(drive, speed);
-
 	switch (speed) {
 		case XFER_UDMA_4:	mode = 0x00c0; break;
 		case XFER_UDMA_3:	mode = 0x00b0; break;
@@ -45,9 +43,8 @@ static int tc86c001_tune_chipset(ide_drive_t *drive, u8 speed)
 	return ide_config_drive_speed(drive, speed);
 }
 
-static void tc86c001_tune_drive(ide_drive_t *drive, u8 pio)
+static void tc86c001_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	(void) tc86c001_tune_chipset(drive, XFER_PIO_0 + pio);
 }
 
@@ -173,7 +170,7 @@ static int tc86c001_config_drive_xfer_rate(ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		tc86c001_tune_drive(drive, 255);
+		ide_set_max_pio(drive);
 
 	return -1;
 }
@@ -195,7 +192,7 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 	/* Store the system control register base for convenience... */
 	hwif->config_data = sc_base;
 
-	hwif->tuneproc	= &tc86c001_tune_drive;
+	hwif->set_pio_mode = &tc86c001_set_pio_mode;
 	hwif->speedproc = &tc86c001_tune_chipset;
 	hwif->busproc	= &tc86c001_busproc;
 
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index 098692a..c3ff066 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -40,7 +40,7 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
-static int triflex_tune_chipset(ide_drive_t *drive, u8 xferspeed)
+static int triflex_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *dev = hwif->pci_dev;
@@ -48,7 +48,6 @@ static int triflex_tune_chipset(ide_drive_t *drive, u8 xferspeed)
 	u16 timing = 0;
 	u32 triflex_timings = 0;
 	u8 unit = (drive->select.b.unit & 0x01);
-	u8 speed = ide_rate_filter(drive, xferspeed);
 	
 	pci_read_config_dword(dev, channel_offset, &triflex_timings);
 	
@@ -94,10 +93,9 @@ static int triflex_tune_chipset(ide_drive_t *drive, u8 xferspeed)
 	return (ide_config_drive_speed(drive, speed));
 }
 
-static void triflex_tune_drive(ide_drive_t *drive, u8 pio)
+static void triflex_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	int use_pio = ide_get_best_pio_mode(drive, pio, 4);
-	(void) triflex_tune_chipset(drive, (XFER_PIO_0 + use_pio));
+	(void)triflex_tune_chipset(drive, XFER_PIO_0 + pio);
 }
 
 static int triflex_config_drive_xfer_rate(ide_drive_t *drive)
@@ -105,14 +103,14 @@ static int triflex_config_drive_xfer_rate(ide_drive_t *drive)
 	if (ide_tune_dma(drive))
 		return 0;
 
-	triflex_tune_drive(drive, 255);
+	ide_set_max_pio(drive);
 
 	return -1;
 }
 
 static void __devinit init_hwif_triflex(ide_hwif_t *hwif)
 {
-	hwif->tuneproc = &triflex_tune_drive;
+	hwif->set_pio_mode = &triflex_set_pio_mode;
 	hwif->speedproc = &triflex_tune_chipset;
 
 	if (hwif->dma_base == 0)
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index a7be779..3611ca6 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -1,6 +1,6 @@
 /*
  *
- * Version 3.47
+ * Version 3.48
  *
  * VIA IDE driver for Linux. Supported southbridges:
  *
@@ -158,7 +158,7 @@ static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
  *	by upper layers.
  */
 
-static int via_set_drive(ide_drive_t *drive, u8 speed)
+static int via_set_drive(ide_drive_t *drive, const u8 speed)
 {
 	ide_drive_t *peer = HWIF(drive)->drives + (~drive->dn & 1);
 	struct via82cxxx_dev *vdev = pci_get_drvdata(drive->hwif->pci_dev);
@@ -195,19 +195,16 @@ static int via_set_drive(ide_drive_t *drive, u8 speed)
 }
 
 /**
- *	via82cxxx_tune_drive	-	PIO setup
- *	@drive: drive to set up
- *	@pio: mode to use (255 for 'best possible')
+ *	via_set_pio_mode	-	PIO setup
+ *	@drive: drive
+ *	@pio: PIO mode number
  *
  *	A callback from the upper layers for PIO-only tuning.
  */
 
-static void via82cxxx_tune_drive(ide_drive_t *drive, u8 pio)
+static void via_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	if (pio == 255)
-		pio = ide_get_best_pio_mode(drive, 255, 5);
-
-	via_set_drive(drive, XFER_PIO_0 + min_t(u8, pio, 5));
+	via_set_drive(drive, XFER_PIO_0 + pio);
 }
 
 /**
@@ -220,18 +217,11 @@ static void via82cxxx_tune_drive(ide_drive_t *drive, u8 pio)
  
 static int via82cxxx_ide_dma_check (ide_drive_t *drive)
 {
-	u8 speed = ide_max_dma_mode(drive);
-
-	if (speed == 0) {
-		via82cxxx_tune_drive(drive, 255);
-		return -1;
-	}
-
-	via_set_drive(drive, speed);
-
-	if (drive->autodma)
+	if (ide_tune_dma(drive))
 		return 0;
 
+	ide_set_max_pio(drive);
+
 	return -1;
 }
 
@@ -465,7 +455,7 @@ static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 
 	hwif->autodma = 0;
 
-	hwif->tuneproc = &via82cxxx_tune_drive;
+	hwif->set_pio_mode = &via_set_pio_mode;
 	hwif->speedproc = &via_set_drive;
 
 
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index dab79af..df2e920 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -45,7 +45,7 @@ static void print_funcid (int func);
 static int check_ide_device (unsigned long base);
 
 static void ide_interrupt_ack (void *dev);
-static void m8xx_ide_tuneproc(ide_drive_t *drive, u8 pio);
+static void m8xx_ide_set_pio_mode(ide_drive_t *drive, const u8 pio);
 
 typedef	struct ide_ioport_desc {
 	unsigned long	base_off;		/* Offset to PCMCIA memory	*/
@@ -314,9 +314,8 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
 #endif	/* CONFIG_IDE_8xx_PCCARD */
 	}
 
-	/* register routine to tune PIO mode */
 	ide_hwifs[data_port].pio_mask = ATA_PIO4;
-	ide_hwifs[data_port].tuneproc = m8xx_ide_tuneproc;
+	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
 
 	hw->ack_intr = (ide_ack_intr_t *) ide_interrupt_ack;
 	/* Enable Harddisk Interrupt,
@@ -401,9 +400,8 @@ void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
 		*irq = ioport_dsc[data_port].irq;
 	}
 
-	/* register routine to tune PIO mode */
 	ide_hwifs[data_port].pio_mask = ATA_PIO4;
-	ide_hwifs[data_port].tuneproc = m8xx_ide_tuneproc;
+	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
 
 	hw->ack_intr = (ide_ack_intr_t *) ide_interrupt_ack;
 	/* Enable Harddisk Interrupt,
@@ -427,24 +425,13 @@ void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
 #define PCMCIA_SL(t) ((t==32) ? 0 : ((t & 0x1F)<<7)) /* Strobe Length	*/
 #endif
 
-
 /* Calculate PIO timings */
-static void
-m8xx_ide_tuneproc(ide_drive_t *drive, u8 pio)
+static void m8xx_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 #if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
 	volatile pcmconf8xx_t	*pcmp;
 	ulong timing, mask, reg;
-#endif
-
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 
-#if 1
-	printk("%s[%d] %s: best PIO mode: %d\n",
-		__FILE__,__LINE__,__FUNCTION__, pio);
-#endif
-
-#if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
 	pcmp = (pcmconf8xx_t *)(&(((immap_t *)IMAP_ADDR)->im_pcmcia));
 
 	mask = ~(PCMCIA_SHT(0xFF) | PCMCIA_SST(0xFF) | PCMCIA_SL(0xFF));
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 2fb047b..f759a53 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -6,6 +6,7 @@
  * for doing DMA.
  *
  *  Copyright (C) 1998-2003 Paul Mackerras & Ben. Herrenschmidt
+ *  Copyright (C)      2007 Bartlomiej Zolnierkiewicz
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
@@ -311,7 +312,8 @@ static struct kauai_timing	kauai_pio_timings[] =
 	{ 240	, 0x0800038b },
 	{ 239	, 0x0800030c },
 	{ 180	, 0x05000249 },
-	{ 120	, 0x04000148 }
+	{ 120	, 0x04000148 },
+	{ 0	, 0 },
 };
 
 static struct kauai_timing	kauai_mdma_timings[] =
@@ -351,7 +353,8 @@ static struct kauai_timing	shasta_pio_timings[] =
 	{ 240	, 0x040003cd },
 	{ 239	, 0x040003cd },
 	{ 180	, 0x0400028b },
-	{ 120	, 0x0400010a }
+	{ 120	, 0x0400010a },
+	{ 0	, 0 },
 };
 
 static struct kauai_timing	shasta_mdma_timings[] =
@@ -411,8 +414,6 @@ kauai_lookup_timing(struct kauai_timing* table, int cycle_time)
 
 static void pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif);
 static int pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq);
-static int pmac_ide_tune_chipset(ide_drive_t *drive, u8 speed);
-static void pmac_ide_tuneproc(ide_drive_t *drive, u8 pio);
 static void pmac_ide_selectproc(ide_drive_t *drive);
 static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
 
@@ -616,7 +617,7 @@ out:
  * Old tuning functions (called on hdparm -p), sets up drive PIO timings
  */
 static void
-pmac_ide_tuneproc(ide_drive_t *drive, u8 pio)
+pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	u32 *timings;
 	unsigned accessTicks, recTicks;
@@ -630,7 +631,6 @@ pmac_ide_tuneproc(ide_drive_t *drive, u8 pio)
 	/* which drive is it ? */
 	timings = &pmif->timings[drive->select.b.unit & 0x01];
 
-	pio = ide_get_best_pio_mode(drive, pio, 4);
 	cycle_time = ide_pio_cycle_time(drive, pio);
 
 	switch (pmif->kind) {
@@ -698,8 +698,10 @@ pmac_ide_tuneproc(ide_drive_t *drive, u8 pio)
 		drive->name, pio,  *timings);
 #endif	
 
-	if (drive->select.all == HWIF(drive)->INB(IDE_SELECT_REG))
-		pmac_ide_do_update_timings(drive);
+	if (pmac_ide_do_setfeature(drive, XFER_PIO_0 + pio))
+		return;
+
+	pmac_ide_do_update_timings(drive);
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
@@ -915,13 +917,12 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 
 /* 
  * Speedproc. This function is called by the core to set any of the standard
- * timing (PIO, MDMA or UDMA) to both the drive and the controller.
+ * DMA timing (MDMA or UDMA) to both the drive and the controller.
  * You may notice we don't use this function on normal "dma check" operation,
  * our dedicated function is more precise as it uses the drive provided
  * cycle time value. We should probably fix this one to deal with that too...
  */
-static int
-pmac_ide_tune_chipset (ide_drive_t *drive, byte speed)
+static int pmac_ide_tune_chipset(ide_drive_t *drive, const u8 speed)
 {
 	int unit = (drive->select.b.unit & 0x01);
 	int ret = 0;
@@ -937,17 +938,9 @@ pmac_ide_tune_chipset (ide_drive_t *drive, byte speed)
 	switch(speed) {
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
 		case XFER_UDMA_6:
-		        if (pmif->kind != controller_sh_ata6)
-				return 1;
 		case XFER_UDMA_5:
-			if (pmif->kind != controller_un_ata6 &&
-			    pmif->kind != controller_k2_ata6 &&
-			    pmif->kind != controller_sh_ata6)
-				return 1;
 		case XFER_UDMA_4:
 		case XFER_UDMA_3:
-			if (drive->hwif->cbl != ATA_CBL_PATA80)
-				return 1;
 		case XFER_UDMA_2:
 		case XFER_UDMA_1:
 		case XFER_UDMA_0:
@@ -971,13 +964,6 @@ pmac_ide_tune_chipset (ide_drive_t *drive, byte speed)
 		case XFER_SW_DMA_0:
 			return 1;
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
-		case XFER_PIO_4:
-		case XFER_PIO_3:
-		case XFER_PIO_2:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-			pmac_ide_tuneproc(drive, speed & 0x07);
-			break;
 		default:
 			ret = 1;
 	}
@@ -1251,7 +1237,7 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	hwif->drives[0].unmask = 1;
 	hwif->drives[1].unmask = 1;
 	hwif->pio_mask = ATA_PIO4;
-	hwif->tuneproc = pmac_ide_tuneproc;
+	hwif->set_pio_mode = pmac_ide_set_pio_mode;
 	if (pmif->kind == controller_un_ata6
 	    || pmif->kind == controller_k2_ata6
 	    || pmif->kind == controller_sh_ata6)
diff --git a/include/linux/ide.h b/include/linux/ide.h
index b9f66c1..85d448b 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -634,7 +634,7 @@ typedef struct ide_drive_s {
 
 	unsigned int	bios_cyl;	/* BIOS/fdisk/LILO number of cyls */
 	unsigned int	cyl;		/* "real" number of cyls */
-	unsigned int	drive_data;	/* use by tuneproc/selectproc */
+	unsigned int	drive_data;	/* used by set_pio_mode/selectproc */
 	unsigned int	failures;	/* current failure count */
 	unsigned int	max_failures;	/* maximum allowed failure count */
 	u64		probed_capacity;/* initial reported media capacity (ide-cd only currently) */
@@ -702,10 +702,10 @@ typedef struct hwif_s {
 #if 0
 	ide_hwif_ops_t	*hwifops;
 #else
-	/* routine to tune PIO mode for drives */
-	void	(*tuneproc)(ide_drive_t *, u8);
+	/* routine to set PIO mode for drives */
+	void	(*set_pio_mode)(ide_drive_t *, const u8);
 	/* routine to retune DMA modes for drives */
-	int	(*speedproc)(ide_drive_t *, u8);
+	int	(*speedproc)(ide_drive_t *, const u8);
 	/* tweaks hardware to select drive */
 	void	(*selectproc)(ide_drive_t *);
 	/* chipset polling based on hba specifics */
@@ -723,6 +723,7 @@ typedef struct hwif_s {
 	/* driver soft-power interface */
 	int	(*busproc)(ide_drive_t *, int);
 #endif
+	u8 (*mdma_filter)(ide_drive_t *);
 	u8 (*udma_filter)(ide_drive_t *);
 
 	void (*ata_input_data)(ide_drive_t *, void *, u32);
@@ -1255,6 +1256,12 @@ enum {
 	IDE_HFLAG_PIO_NO_BLACKLIST	= (1 << 2),
 	/* don't use conservative PIO "downgrade" */
 	IDE_HFLAG_PIO_NO_DOWNGRADE	= (1 << 3),
+	/* use PIO8/9 for prefetch off/on */
+	IDE_HFLAG_ABUSE_PREFETCH	= (1 << 4),
+	/* use PIO6/7 for fast-devsel off/on */
+	IDE_HFLAG_ABUSE_FAST_DEVSEL	= (1 << 5),
+	/* use 100-102 and 200-202 PIO values to set DMA modes */
+	IDE_HFLAG_ABUSE_DMA_MODES	= (1 << 6),
 };
 
 typedef struct ide_pci_device_s {
@@ -1295,7 +1302,14 @@ int ide_in_drive_list(struct hd_driveid *, const struct drive_list_entry *);
 #ifdef CONFIG_BLK_DEV_IDEDMA
 int __ide_dma_bad_drive(ide_drive_t *);
 int __ide_dma_good_drive(ide_drive_t *);
-u8 ide_max_dma_mode(ide_drive_t *);
+
+u8 ide_find_dma_mode(ide_drive_t *, u8);
+
+static inline u8 ide_max_dma_mode(ide_drive_t *drive)
+{
+	return ide_find_dma_mode(drive, XFER_UDMA_6);
+}
+
 int ide_tune_dma(ide_drive_t *);
 void ide_dma_off(ide_drive_t *);
 void ide_dma_verbose(ide_drive_t *);
@@ -1321,6 +1335,7 @@ extern void ide_dma_timeout(ide_drive_t *);
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 #else
+static inline u8 ide_find_dma_mode(ide_drive_t *drive, u8 speed) { return 0; }
 static inline u8 ide_max_dma_mode(ide_drive_t *drive) { return 0; }
 static inline int ide_tune_dma(ide_drive_t *drive) { return 0; }
 static inline void ide_dma_off(ide_drive_t *drive) { ; }
@@ -1337,11 +1352,13 @@ extern int ide_acpi_exec_tfs(ide_drive_t *drive);
 extern void ide_acpi_get_timing(ide_hwif_t *hwif);
 extern void ide_acpi_push_timing(ide_hwif_t *hwif);
 extern void ide_acpi_init(ide_hwif_t *hwif);
+extern void ide_acpi_set_state(ide_hwif_t *hwif, int on);
 #else
 static inline int ide_acpi_exec_tfs(ide_drive_t *drive) { return 0; }
 static inline void ide_acpi_get_timing(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_push_timing(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_init(ide_hwif_t *hwif) { ; }
+static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
 extern int ide_hwif_request_regions(ide_hwif_t *hwif);
@@ -1367,7 +1384,6 @@ static inline void ide_set_hwifdata (ide_hwif_t * hwif, void *data)
 }
 
 /* ide-lib.c */
-u8 ide_rate_filter(ide_drive_t *, u8);
 extern char *ide_xfer_verbose(u8 xfer_rate);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
@@ -1404,6 +1420,12 @@ unsigned int ide_pio_cycle_time(ide_drive_t *, u8);
 u8 ide_get_best_pio_mode(ide_drive_t *, u8, u8);
 extern const ide_pio_timings_t ide_pio_timings[6];
 
+void ide_set_pio(ide_drive_t *, u8);
+
+static inline void ide_set_max_pio(ide_drive_t *drive)
+{
+	ide_set_pio(drive, 255);
+}
 
 extern spinlock_t ide_lock;
 extern struct mutex ide_cfg_mtx;
