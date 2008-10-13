Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbYJMUNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbYJMUNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbYJMUNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:13:20 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:40870 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760006AbYJMUMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:12:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=GG8txkO3wNmk42XBL5vgPPr05YkXCbxaQuzBdcYhtuyZOUes8bGwLoxb6Oe50wNAv7
         seQPPZQedJXN/oRShJvtLowJ4OwzIhE5fDaBpMaWnBBPukdDgjcovbjwBsg6VSlrZLcJ
         yZZ0a5tHsxapf5d2LRbXkQoEAffWZ8oX8/q5Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE (a.k.a. "zombie") updates #2
Date: Mon, 13 Oct 2008 21:59:47 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200810132159.50283.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Disk shock protection support. (Elias Oltmanns)

* IDE ACPI fix for slave device-only configurations.

* Conversion of ide-{cd,floppy} to new IDE debugging macros.
  (Borislav Petkov)

* Next part of generic ATAPI support saga. (the usual suspects)

* sgiioc4 host driver fixes. (Sergei Shtylylov)

* "Short cable" quirk for EC-900 mini-notebook.
  (Herton Ronaldo Krzesinski)

* Misc fixups (Adrian Bunk, Alexander Beregalov, Elias Oltmanns).

* A ton of cleanups.


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/laptops/disk-shock-protection.txt |  149 +++++
 arch/mips/include/asm/mach-generic/ide.h        |   29 -
 arch/xtensa/kernel/setup.c                      |    5 -
 drivers/ide/Kconfig                             |   38 +--
 drivers/ide/Makefile                            |   19 +-
 drivers/ide/arm/icside.c                        |   23 +-
 drivers/ide/h8300/ide-h8300.c                   |    2 +-
 drivers/ide/ide-acpi.c                          |   12 +-
 drivers/ide/ide-atapi.c                         |  183 +++++--
 drivers/ide/ide-cd.c                            |  261 +++++++---
 drivers/ide/ide-cd.h                            |    1 -
 drivers/ide/ide-disk.c                          |  357 ++++---------
 drivers/ide/ide-disk.h                          |   32 ++
 drivers/ide/ide-disk_ioctl.c                    |   29 +
 drivers/ide/ide-disk_proc.c                     |  129 +++++
 drivers/ide/ide-dma-sff.c                       |  356 ++++++++++++
 drivers/ide/ide-dma.c                           |  481 ++---------------
 drivers/ide/ide-floppy.c                        |  392 ++++----------
 drivers/ide/ide-floppy.h                        |   19 +-
 drivers/ide/ide-floppy_ioctl.c                  |   56 ++-
 drivers/ide/ide-floppy_proc.c                   |   33 ++
 drivers/ide/ide-generic.c                       |   51 +--
 drivers/ide/ide-io.c                            |  237 ++++-----
 drivers/ide/ide-ioctls.c                        |   21 +-
 drivers/ide/ide-iops.c                          |   95 +++--
 drivers/ide/ide-lib.c                           |    2 +-
 drivers/ide/ide-park.c                          |  121 +++++
 drivers/ide/ide-probe.c                         |  215 ++++----
 drivers/ide/ide-proc.c                          |    6 +-
 drivers/ide/ide-tape.c                          |  155 ++----
 drivers/ide/ide-taskfile.c                      |  128 ++---
 drivers/ide/ide.c                               |  135 +++--
 drivers/ide/legacy/ali14xx.c                    |    2 +-
 drivers/ide/legacy/ht6560b.c                    |    9 +-
 drivers/ide/legacy/ide-4drives.c                |    2 +-
 drivers/ide/legacy/qd65xx.c                     |    2 +-
 drivers/ide/mips/au1xxx-ide.c                   |   34 +-
 drivers/ide/pci/aec62xx.c                       |    8 +-
 drivers/ide/pci/alim15x3.c                      |   15 +-
 drivers/ide/pci/amd74xx.c                       |    8 +-
 drivers/ide/pci/atiixp.c                        |    6 +-
 drivers/ide/pci/cmd640.c                        |   18 +-
 drivers/ide/pci/cmd64x.c                        |   10 +-
 drivers/ide/pci/cs5520.c                        |    4 +-
 drivers/ide/pci/cs5530.c                        |    6 +-
 drivers/ide/pci/cs5535.c                        |    8 +-
 drivers/ide/pci/cy82c693.c                      |  124 +----
 drivers/ide/pci/delkin_cb.c                     |    6 +-
 drivers/ide/pci/generic.c                       |    6 +-
 drivers/ide/pci/hpt34x.c                        |    6 +-
 drivers/ide/pci/hpt366.c                        |   15 +-
 drivers/ide/pci/it8213.c                        |    6 +-
 drivers/ide/pci/it821x.c                        |   46 +-
 drivers/ide/pci/jmicron.c                       |    6 +-
 drivers/ide/pci/ns87415.c                       |   21 +-
 drivers/ide/pci/opti621.c                       |    8 +-
 drivers/ide/pci/pdc202xx_new.c                  |    6 +-
 drivers/ide/pci/pdc202xx_old.c                  |   14 +-
 drivers/ide/pci/piix.c                          |   46 +-
 drivers/ide/pci/rz1000.c                        |    6 +-
 drivers/ide/pci/sc1200.c                        |   12 +-
 drivers/ide/pci/scc_pata.c                      |   29 +-
 drivers/ide/pci/serverworks.c                   |    8 +-
 drivers/ide/pci/sgiioc4.c                       |   59 +--
 drivers/ide/pci/siimage.c                       |   17 +-
 drivers/ide/pci/sis5513.c                       |    6 +-
 drivers/ide/pci/sl82c105.c                      |    8 +-
 drivers/ide/pci/slc90e66.c                      |    6 +-
 drivers/ide/pci/tc86c001.c                      |    8 +-
 drivers/ide/pci/triflex.c                       |   15 +-
 drivers/ide/pci/trm290.c                        |   10 +-
 drivers/ide/pci/via82cxxx.c                     |    6 +-
 drivers/ide/ppc/pmac.c                          |   71 +--
 drivers/scsi/ide-scsi.c                         |  102 ++---
 include/linux/ide.h                             |  653 +++++++++++++----------
 75 files changed, 2656 insertions(+), 2574 deletions(-)
 create mode 100644 Documentation/laptops/disk-shock-protection.txt
 create mode 100644 drivers/ide/ide-disk.h
 create mode 100644 drivers/ide/ide-disk_ioctl.c
 create mode 100644 drivers/ide/ide-disk_proc.c
 create mode 100644 drivers/ide/ide-dma-sff.c
 create mode 100644 drivers/ide/ide-floppy_proc.c
 create mode 100644 drivers/ide/ide-park.c


Adrian Bunk (1):
      xtensa: remove dead CONFIG_BLK_DEV_IDE code

Alexander Beregalov (1):
      ide-cd: fix printk format warning

Bartlomiej Zolnierkiewicz (48):
      ide: drop dsc_handle argument from ide_pc_intr()
      ide: add pointer to the current packet command to ide_drive_t
      ide: drop 'timeout' and 'expiry' arguments from ide_pc_intr()
      ide: add request_sense_{pc,rq} to ide_drive_t
      ide: add ide_retry_pc() helper
      ide: add ->pc_{update,io}_buffers methods
      ide: make ide_pc_intr() static
      ide: make ide_transfer_pc() static
      ide: remove CONFIG_BLK_DEV_IDE config option (take 2)
      ide: remove unnecessary MAX_HWIFS checks from ide-probe.c
      ide: fix IDE ACPI for slave device-only configurations
      ide-disk: set_addressing() fixes
      ide-disk: add ide_do_setfeature() helper
      ide: add device flags
      ide: DMA_PIO_RETRY -> IDE_DFLAG_DMA_PIO_RETRY
      ide: remove superfluous ->media field from ide_driver_t
      ide: remove superfluous ->dma field from ide_hwif_t
      ide: remove superfluous ->waiting_for_dma checks
      ide: fix HDIO_DRIVE_TASK[FILE] ioctls for CHS commands on LBA devices
      ide: sanitize ide*_pm_* enums
      cy82c693: remove dead CY82C693_SETDMA_CLOCK code
      cy82c693: remove no longer needed CY82C693_DEBUG_LOGS code
      ide: use 'drive->dn & 1' instead of drive->select.b.unit
      ide: remove [ata_]select_t
      ide: convert 'pio_mode' device setting to use DS_SYNC flag
      ide: factor out reset error reporting from reset_pollfunc()
      ide: merge all TASKFILE_NO_DATA data phase handlers into taskfile_no_intr()
      ide: use unique names for struct pci_driver instances
      ide: ->ide_dma_clear_irq() -> ->clear_irq()
      ide-generic: no need to probe all ports at once
      ide-generic: remove no longer needed ide_probe_legacy()
      ide: remove ide_host_alloc_all()
      ide: set IDE_AFLAG_DRQ_INTERRUPT in do_identify()
      ide-cd: no need to zero drive->special.all
      ide-floppy: move all ioctl handling to ide-floppy_ioctl.c (take 2)
      ide-floppy: move /proc handling to ide-floppy_proc.c (take 2)
      ide-disk: move all ioctl handling to ide-disk_ioctl.c
      ide-disk: move /proc handling to ide-disk_proc.c (take 3)
      pmac: remove superfluous pmif == NULL checks
      pmac: remove needless pmac_ide_destroy_dmatable() wrapper
      ide: __ide_dma_end() -> ide_dma_end()
      ide: make ide_dma_lost_irq() available also for CONFIG_BLK_DEV_IDEDMA_SFF=n
      ide: make ide_dma_timeout() available also for CONFIG_BLK_DEV_IDEDMA_SFF=n
      ide: switch to DMA-mapping API part #2
      ide: remove needless includes from ide-dma.c
      ide: cleanup ide_build_dmatable()
      ide: cleanup ide-dma.c
      ide: move SFF DMA code to ide-dma-sff.c

Borislav Petkov (10):
      ide: unify conversion macros
      ide: add drive->debug_mask switch
      ide: add a driver-wide debugging macro
      ide-floppy: convert driver to the new debugging macro
      ide-floppy: add a debug_mask module parameter
      ide-cd: convert driver to new ide debugging macro (v3)
      ide-cd: add a debug_mask module parameter
      ide: add ide_drive_t.dma flag
      ide-cd: move cdrom_info.dma to ide_drive_t.dma
      ide-atapi: assign taskfile flags per device type

Elias Oltmanns (3):
      ide: Two fixes regarding memory allocation
      ide: Implement disk shock protection support (v4)
      ata: Add documentation for hard disk shock protection interface (v3)

Herton Ronaldo Krzesinski (1):
      piix: add Hercules EC-900 mini-notebook to ich_laptop short cable list

Sergei Shtylylov (2):
      sgiioc4: sgiioc4_read_status drive busy check fix
      sgiioc4: fix messages


diff --git a/Documentation/laptops/disk-shock-protection.txt b/Documentation/laptops/disk-shock-protection.txt
new file mode 100644
index 0000000..0e6ba26
--- /dev/null
+++ b/Documentation/laptops/disk-shock-protection.txt
@@ -0,0 +1,149 @@
+Hard disk shock protection
+==========================
+
+Author: Elias Oltmanns <eo@nebensachen.de>
+Last modified: 2008-10-03
+
+
+0. Contents
+-----------
+
+1. Intro
+2. The interface
+3. References
+4. CREDITS
+
+
+1. Intro
+--------
+
+ATA/ATAPI-7 specifies the IDLE IMMEDIATE command with unload feature.
+Issuing this command should cause the drive to switch to idle mode and
+unload disk heads. This feature is being used in modern laptops in
+conjunction with accelerometers and appropriate software to implement
+a shock protection facility. The idea is to stop all I/O operations on
+the internal hard drive and park its heads on the ramp when critical
+situations are anticipated. The desire to have such a feature
+available on GNU/Linux systems has been the original motivation to
+implement a generic disk head parking interface in the Linux kernel.
+Please note, however, that other components have to be set up on your
+system in order to get disk shock protection working (see
+section 3. References below for pointers to more information about
+that).
+
+
+2. The interface
+----------------
+
+For each ATA device, the kernel exports the file
+block/*/device/unload_heads in sysfs (here assumed to be mounted under
+/sys). Access to /sys/block/*/device/unload_heads is denied with
+-EOPNOTSUPP if the device does not support the unload feature.
+Otherwise, writing an integer value to this file will take the heads
+of the respective drive off the platter and block all I/O operations
+for the specified number of milliseconds. When the timeout expires and
+no further disk head park request has been issued in the meantime,
+normal operation will be resumed. The maximal value accepted for a
+timeout is 30000 milliseconds. Exceeding this limit will return
+-EOVERFLOW, but heads will be parked anyway and the timeout will be
+set to 30 seconds. However, you can always change a timeout to any
+value between 0 and 30000 by issuing a subsequent head park request
+before the timeout of the previous one has expired. In particular, the
+total timeout can exceed 30 seconds and, more importantly, you can
+cancel a previously set timeout and resume normal operation
+immediately by specifying a timeout of 0. Values below -2 are rejected
+with -EINVAL (see below for the special meaning of -1 and -2). If the
+timeout specified for a recent head park request has not yet expired,
+reading from /sys/block/*/device/unload_heads will report the number
+of milliseconds remaining until normal operation will be resumed;
+otherwise, reading the unload_heads attribute will return 0.
+
+For example, do the following in order to park the heads of drive
+/dev/sda and stop all I/O operations for five seconds:
+
+# echo 5000 > /sys/block/sda/device/unload_heads
+
+A simple
+
+# cat /sys/block/sda/device/unload_heads
+
+will show you how many milliseconds are left before normal operation
+will be resumed.
+
+A word of caution: The fact that the interface operates on a basis of
+milliseconds may raise expectations that cannot be satisfied in
+reality. In fact, the ATA specs clearly state that the time for an
+unload operation to complete is vendor specific. The hint in ATA-7
+that this will typically be within 500 milliseconds apparently has
+been dropped in ATA-8.
+
+There is a technical detail of this implementation that may cause some
+confusion and should be discussed here. When a head park request has
+been issued to a device successfully, all I/O operations on the
+controller port this device is attached to will be deferred. That is
+to say, any other device that may be connected to the same port will
+be affected too. The only exception is that a subsequent head unload
+request to that other device will be executed immediately. Further
+operations on that port will be deferred until the timeout specified
+for either device on the port has expired. As far as PATA (old style
+IDE) configurations are concerned, there can only be two devices
+attached to any single port. In SATA world we have port multipliers
+which means that a user-issued head parking request to one device may
+actually result in stopping I/O to a whole bunch of devices. However,
+since this feature is supposed to be used on laptops and does not seem
+to be very useful in any other environment, there will be mostly one
+device per port. Even if the CD/DVD writer happens to be connected to
+the same port as the hard drive, it generally *should* recover just
+fine from the occasional buffer under-run incurred by a head park
+request to the HD. Actually, when you are using an ide driver rather
+than its libata counterpart (i.e. your disk is called /dev/hda
+instead of /dev/sda), then parking the heads of one drive (drive X)
+will generally not affect the mode of operation of another drive
+(drive Y) on the same port as described above. It is only when a port
+reset is required to recover from an exception on drive Y that further
+I/O operations on that drive (and the reset itself) will be delayed
+until drive X is no longer in the parked state.
+
+Finally, there are some hard drives that only comply with an earlier
+version of the ATA standard than ATA-7, but do support the unload
+feature nonetheless. Unfortunately, there is no safe way Linux can
+detect these devices, so you won't be able to write to the
+unload_heads attribute. If you know that your device really does
+support the unload feature (for instance, because the vendor of your
+laptop or the hard drive itself told you so), then you can tell the
+kernel to enable the usage of this feature for that drive by writing
+the special value -1 to the unload_heads attribute:
+
+# echo -1 > /sys/block/sda/device/unload_heads
+
+will enable the feature for /dev/sda, and giving -2 instead of -1 will
+disable it again.
+
+
+3. References
+-------------
+
+There are several laptops from different vendors featuring shock
+protection capabilities. As manufacturers have refused to support open
+source development of the required software components so far, Linux
+support for shock protection varies considerably between different
+hardware implementations. Ideally, this section should contain a list
+of pointers at different projects aiming at an implementation of shock
+protection on different systems. Unfortunately, I only know of a
+single project which, although still considered experimental, is fit
+for use. Please feel free to add projects that have been the victims
+of my ignorance.
+
+- http://www.thinkwiki.org/wiki/HDAPS
+  See this page for information about Linux support of the hard disk
+  active protection system as implemented in IBM/Lenovo Thinkpads.
+
+
+4. CREDITS
+----------
+
+This implementation of disk head parking has been inspired by a patch
+originally published by Jon Escombe <lists@dresco.co.uk>. My efforts
+to develop an implementation of this feature that is fit to be merged
+into mainline have been aided by various kernel developers, in
+particular by Tejun Heo and Bartlomiej Zolnierkiewicz.
diff --git a/arch/mips/include/asm/mach-generic/ide.h b/arch/mips/include/asm/mach-generic/ide.h
index 73008f7..9c93a5b 100644
--- a/arch/mips/include/asm/mach-generic/ide.h
+++ b/arch/mips/include/asm/mach-generic/ide.h
@@ -19,35 +19,6 @@
 #include <linux/stddef.h>
 #include <asm/processor.h>
 
-static __inline__ int ide_probe_legacy(void)
-{
-#ifdef CONFIG_PCI
-	struct pci_dev *dev;
-	/*
-	 * This can be called on the ide_setup() path, super-early in
-	 * boot.  But the down_read() will enable local interrupts,
-	 * which can cause some machines to crash.  So here we detect
-	 * and flag that situation and bail out early.
-	 */
-	if (no_pci_devices())
-		return 0;
-	dev = pci_get_class(PCI_CLASS_BRIDGE_EISA << 8, NULL);
-	if (dev)
-		goto found;
-	dev = pci_get_class(PCI_CLASS_BRIDGE_ISA << 8, NULL);
-	if (dev)
-		goto found;
-	return 0;
-found:
-	pci_dev_put(dev);
-	return 1;
-#elif defined(CONFIG_EISA) || defined(CONFIG_ISA)
-	return 1;
-#else
-	return 0;
-#endif
-}
-
 /* MIPS port and memory-mapped I/O string operations.  */
 static inline void __ide_flush_prologue(void)
 {
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index a00359e..9606d2b 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -53,11 +53,6 @@ extern struct fd_ops no_fd_ops;
 struct fd_ops *fd_ops;
 #endif
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-extern struct ide_ops no_ide_ops;
-struct ide_ops *ide_ops;
-#endif
-
 extern struct rtc_ops no_rtc_ops;
 struct rtc_ops *rtc_ops;
 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index b50b5da..6c6dd2f 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -54,38 +54,6 @@ menuconfig IDE
 
 if IDE
 
-config BLK_DEV_IDE
-	tristate "Enhanced IDE/MFM/RLL disk/cdrom/tape/floppy support"
-	---help---
-	  If you say Y here, you will use the full-featured IDE driver to
-	  control up to ten ATA/IDE interfaces, each being able to serve a
-	  "master" and a "slave" device, for a total of up to twenty ATA/IDE
-	  disk/cdrom/tape/floppy drives.
-
-	  Useful information about large (>540 MB) IDE disks, multiple
-	  interfaces, what to do if ATA/IDE devices are not automatically
-	  detected, sound card ATA/IDE ports, module support, and other
-	  topics, is contained in <file:Documentation/ide/ide.txt>. For detailed
-	  information about hard drives, consult the Disk-HOWTO and the
-	  Multi-Disk-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  To fine-tune ATA/IDE drive/interface parameters for improved
-	  performance, look for the hdparm package at
-	  <ftp://ibiblio.org/pub/Linux/system/hardware/>.
-
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/ide/ide.txt>. The module will be called ide-mod.
-	  Do not compile this driver as a module if your root file system (the
-	  one containing the directory /) is located on an IDE device.
-
-	  If you have one or more IDE drives, say Y or M here. If your system
-	  has no IDE drives, or if memory requirements are really tight, you
-	  could say N here, and select the "Old hard disk driver" below
-	  instead to save about 13 KB of memory in the kernel.
-
-if BLK_DEV_IDE
-
 comment "Please see Documentation/ide/ide.txt for help/info on IDE drives"
 
 config IDE_TIMINGS
@@ -348,7 +316,7 @@ config BLK_DEV_IDEPCI
 
 config IDEPCI_PCIBUS_ORDER
 	bool "Probe IDE PCI devices in the PCI bus order (DEPRECATED)"
-	depends on BLK_DEV_IDE=y && BLK_DEV_IDEPCI
+	depends on IDE=y && BLK_DEV_IDEPCI
 	default y
 	help
 	  Probe IDE PCI devices in the order in which they appear on the
@@ -729,7 +697,7 @@ endif
 
 config BLK_DEV_IDE_PMAC
 	tristate "PowerMac on-board IDE support"
-	depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y
+	depends on PPC_PMAC && IDE=y
 	select IDE_TIMINGS
 	help
 	  This driver provides support for the on-board IDE controller on
@@ -963,6 +931,4 @@ config BLK_DEV_IDEDMA
 	def_bool BLK_DEV_IDEDMA_SFF || BLK_DEV_IDEDMA_PMAC || \
 		 BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 
-endif
-
 endif # IDE
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 308b8a1..ceaf779 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -5,24 +5,25 @@
 EXTRA_CFLAGS				+= -Idrivers/ide
 
 ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
-	      ide-taskfile.o ide-pio-blacklist.o
+	      ide-taskfile.o ide-park.o ide-pio-blacklist.o
 
 # core IDE code
 ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
 ide-core-$(CONFIG_IDE_ATAPI)		+= ide-atapi.o
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
 ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide-dma.o
+ide-core-$(CONFIG_BLK_DEV_IDEDMA_SFF)	+= ide-dma-sff.o
 ide-core-$(CONFIG_IDE_PROC_FS)		+= ide-proc.o
 ide-core-$(CONFIG_BLK_DEV_IDEACPI)	+= ide-acpi.o
 
-obj-$(CONFIG_BLK_DEV_IDE)		+= ide-core.o
+obj-$(CONFIG_IDE)			+= ide-core.o
 
 ifeq ($(CONFIG_IDE_ARM), y)
 	ide-arm-core-y += arm/ide_arm.o
 	obj-y += ide-arm-core.o
 endif
 
-obj-$(CONFIG_BLK_DEV_IDE)		+= legacy/ pci/
+obj-$(CONFIG_IDE)			+= legacy/ pci/
 
 obj-$(CONFIG_IDEPCI_PCIBUS_ORDER)	+= ide-scan-pci.o
 
@@ -31,15 +32,21 @@ ifeq ($(CONFIG_BLK_DEV_CMD640), y)
 	obj-y += cmd640-core.o
 endif
 
-obj-$(CONFIG_BLK_DEV_IDE)		+= ppc/
+obj-$(CONFIG_IDE)			+= ppc/
 obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
+ide-disk_mod-y += ide-disk.o ide-disk_ioctl.o
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
 ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o
 
-obj-$(CONFIG_BLK_DEV_IDEDISK)		+= ide-disk.o
+ifeq ($(CONFIG_IDE_PROC_FS), y)
+	ide-disk_mod-y += ide-disk_proc.o
+	ide-floppy_mod-y += ide-floppy_proc.o
+endif
+
+obj-$(CONFIG_BLK_DEV_IDEDISK)		+= ide-disk_mod.o
 obj-$(CONFIG_BLK_DEV_IDECD)		+= ide-cd_mod.o
 obj-$(CONFIG_BLK_DEV_IDEFLOPPY)		+= ide-floppy_mod.o
 obj-$(CONFIG_BLK_DEV_IDETAPE)		+= ide-tape.o
@@ -54,4 +61,4 @@ ifeq ($(CONFIG_BLK_DEV_PLATFORM), y)
 	obj-y += ide-platform-core.o
 endif
 
-obj-$(CONFIG_BLK_DEV_IDE)		+= arm/ mips/
+obj-$(CONFIG_IDE)			+= arm/ mips/
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 70f5b16..76bdc9a 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -372,25 +372,6 @@ static int icside_dma_test_irq(ide_drive_t *drive)
 			ICS_ARCIN_V6_INTRSTAT_1)) & 1;
 }
 
-static void icside_dma_timeout(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	printk(KERN_ERR "%s: DMA timeout occurred: ", drive->name);
-
-	if (icside_dma_test_irq(drive))
-		return;
-
-	ide_dump_status(drive, "DMA timeout", hwif->tp_ops->read_status(hwif));
-
-	icside_dma_end(drive);
-}
-
-static void icside_dma_lost_irq(ide_drive_t *drive)
-{
-	printk(KERN_ERR "%s: IRQ lost\n", drive->name);
-}
-
 static int icside_dma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	hwif->dmatable_cpu	= NULL;
@@ -406,8 +387,8 @@ static const struct ide_dma_ops icside_v6_dma_ops = {
 	.dma_start		= icside_dma_start,
 	.dma_end		= icside_dma_end,
 	.dma_test_irq		= icside_dma_test_irq,
-	.dma_timeout		= icside_dma_timeout,
-	.dma_lost_irq		= icside_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+	.dma_lost_irq		= ide_dma_lost_irq,
 };
 #else
 #define icside_v6_dma_ops NULL
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index bde7a58..e2cdd2e 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -80,7 +80,7 @@ static void h8300_tf_load(ide_drive_t *drive, ide_task_t *task)
 		outb(tf->lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		outb((tf->device & HIHI) | drive->select.all,
+		outb((tf->device & HIHI) | drive->select,
 		     io_ports->device_addr);
 }
 
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 2427c38..244a8a0 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -290,7 +290,7 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 	DEBPRINT("ENTER: %s at %s, port#: %d, hard_port#: %d\n",
 		 hwif->name, dev->bus_id, port, hwif->channel);
 
-	if (!drive->present) {
+	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0) {
 		DEBPRINT("%s drive %d:%d not present\n",
 			 hwif->name, hwif->channel, port);
 		goto out;
@@ -420,8 +420,9 @@ static int do_drive_set_taskfiles(ide_drive_t *drive,
 
 	DEBPRINT("ENTER: %s, hard_port#: %d\n", drive->name, drive->dn);
 
-	if (!drive->present)
+	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		goto out;
+
 	if (!gtf_count)		/* shouldn't be here */
 		goto out;
 
@@ -660,7 +661,8 @@ void ide_acpi_set_state(ide_hwif_t *hwif, int on)
 		if (!drive->acpidata->obj_handle)
 			drive->acpidata->obj_handle = ide_acpi_drive_get_handle(drive);
 
-		if (drive->acpidata->obj_handle && drive->present) {
+		if (drive->acpidata->obj_handle &&
+		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
 			acpi_bus_set_power(drive->acpidata->obj_handle,
 				on? ACPI_STATE_D0: ACPI_STATE_D3);
 		}
@@ -720,7 +722,7 @@ void ide_acpi_port_init_devices(ide_hwif_t *hwif)
 
 		memset(drive->acpidata, 0, sizeof(*drive->acpidata));
 
-		if (!drive->present)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
 		err = taskfile_lib_get_identify(drive, drive->acpidata->idbuff);
@@ -745,7 +747,7 @@ void ide_acpi_port_init_devices(ide_hwif_t *hwif)
 	for (i = 0; i < MAX_DRIVES; i++) {
 		drive = &hwif->drives[i];
 
-		if (drive->present)
+		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			/* Execute ACPI startup code */
 			ide_acpi_exec_tfs(drive);
 	}
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 608c5ba..2e30571 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -124,8 +124,8 @@ EXPORT_SYMBOL_GPL(ide_init_pc);
  * the current request, so that it will be processed immediately, on the next
  * pass through the driver.
  */
-void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
-		       struct ide_atapi_pc *pc, struct request *rq)
+static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
+			      struct ide_atapi_pc *pc, struct request *rq)
 {
 	blk_rq_init(NULL, rq);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
@@ -137,7 +137,6 @@ void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
 		rq->cmd[13] = REQ_IDETAPE_PC1;
 	ide_do_drive_cmd(drive, rq);
 }
-EXPORT_SYMBOL_GPL(ide_queue_pc_head);
 
 /*
  * Add a special packet command request to the tail of the request queue,
@@ -203,25 +202,80 @@ int ide_set_media_lock(ide_drive_t *drive, struct gendisk *disk, int on)
 }
 EXPORT_SYMBOL_GPL(ide_set_media_lock);
 
-/* TODO: unify the code thus making some arguments go away */
-ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
-	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
-	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
-	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
-	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
+void ide_create_request_sense_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
+	ide_init_pc(pc);
+	pc->c[0] = REQUEST_SENSE;
+	if (drive->media == ide_floppy) {
+		pc->c[4] = 255;
+		pc->req_xfer = 18;
+	} else {
+		pc->c[4] = 20;
+		pc->req_xfer = 20;
+	}
+}
+EXPORT_SYMBOL_GPL(ide_create_request_sense_cmd);
+
+/*
+ * Called when an error was detected during the last packet command.
+ * We queue a request sense packet command in the head of the request list.
+ */
+void ide_retry_pc(ide_drive_t *drive, struct gendisk *disk)
+{
+	struct request *rq = &drive->request_sense_rq;
+	struct ide_atapi_pc *pc = &drive->request_sense_pc;
+
+	(void)ide_read_error(drive);
+	ide_create_request_sense_cmd(drive, pc);
+	if (drive->media == ide_tape)
+		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
+	ide_queue_pc_head(drive, disk, pc, rq);
+}
+EXPORT_SYMBOL_GPL(ide_retry_pc);
+
+int ide_scsi_expiry(ide_drive_t *drive)
+{
+	struct ide_atapi_pc *pc = drive->pc;
+
+	debug_log("%s called for %lu at %lu\n", __func__,
+		  pc->scsi_cmd->serial_number, jiffies);
+
+	pc->flags |= PC_FLAG_TIMEDOUT;
+
+	return 0; /* we do not want the IDE subsystem to retry */
+}
+EXPORT_SYMBOL_GPL(ide_scsi_expiry);
+
+/*
+ * This is the usual interrupt handler which will be called during a packet
+ * command.  We will transfer some of the data (as requested by the drive)
+ * and will re-point interrupt handler to us.
+ */
+static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
+{
+	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
-	unsigned int temp;
+	ide_expiry_t *expiry;
+	unsigned int timeout, temp;
 	u16 bcount;
-	u8 stat, ireason, scsi = drive->scsi;
+	u8 stat, ireason, scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI), dsc = 0;
 
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
+	if (scsi) {
+		timeout = ide_scsi_get_timeout(pc);
+		expiry = ide_scsi_expiry;
+	} else {
+		timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
+						       : WAIT_TAPE_CMD;
+		expiry = NULL;
+	}
+
 	if (pc->flags & PC_FLAG_TIMEDOUT) {
-		drive->pc_callback(drive);
+		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
 
@@ -238,8 +292,8 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->xferred = pc->req_xfer;
-			if (update_buffers)
-				update_buffers(drive, pc);
+			if (drive->pc_update_buffers)
+				drive->pc_update_buffers(drive, pc);
 		}
 		debug_log("%s: DMA finished\n", drive->name);
 	}
@@ -276,21 +330,19 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			debug_log("[cmd %x]: check condition\n", rq->cmd[0]);
 
 			/* Retry operation */
-			retry_pc(drive);
+			ide_retry_pc(drive, rq->rq_disk);
 
 			/* queued, but not started */
 			return ide_stopped;
 		}
 cmd_finished:
 		pc->error = 0;
-		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
-		    (stat & ATA_DSC) == 0) {
-			dsc_handle(drive);
-			return ide_stopped;
-		}
+
+		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) && (stat & ATA_DSC) == 0)
+			dsc = 1;
 
 		/* Command finished - Call the callback function */
-		drive->pc_callback(drive);
+		drive->pc_callback(drive, dsc);
 
 		return ide_stopped;
 	}
@@ -336,7 +388,8 @@ cmd_finished:
 					temp = 0;
 				if (temp) {
 					if (pc->sg)
-						io_buffers(drive, pc, temp, 0);
+						drive->pc_io_buffers(drive, pc,
+								     temp, 0);
 					else
 						tp_ops->input_data(drive, NULL,
 							pc->cur_pos, temp);
@@ -348,9 +401,7 @@ cmd_finished:
 				pc->xferred += temp;
 				pc->cur_pos += temp;
 				ide_pad_transfer(drive, 0, bcount - temp);
-				ide_set_handler(drive, handler, timeout,
-						expiry);
-				return ide_started;
+				goto next_irq;
 			}
 			debug_log("The device wants to send us more data than "
 				  "expected - allowing transfer\n");
@@ -362,7 +413,7 @@ cmd_finished:
 	if ((drive->media == ide_floppy && !scsi && !pc->buf) ||
 	    (drive->media == ide_tape && !scsi && pc->bh) ||
 	    (scsi && pc->sg)) {
-		int done = io_buffers(drive, pc, bcount,
+		int done = drive->pc_io_buffers(drive, pc, bcount,
 				  !!(pc->flags & PC_FLAG_WRITING));
 
 		/* FIXME: don't do partial completions */
@@ -377,12 +428,11 @@ cmd_finished:
 
 	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
 		  rq->cmd[0], bcount);
-
+next_irq:
 	/* And set the interrupt handler again */
-	ide_set_handler(drive, handler, timeout, expiry);
+	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
 	return ide_started;
 }
-EXPORT_SYMBOL_GPL(ide_pc_intr);
 
 static u8 ide_read_ireason(ide_drive_t *drive)
 {
@@ -418,12 +468,22 @@ static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 	return ireason;
 }
 
-ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				ide_handler_t *handler, unsigned int timeout,
-				ide_expiry_t *expiry)
+static int ide_delayed_transfer_pc(ide_drive_t *drive)
 {
+	/* Send the actual packet */
+	drive->hwif->tp_ops->output_data(drive, NULL, drive->pc->c, 12);
+
+	/* Timeout for the packet command */
+	return WAIT_FLOPPY_CMD;
+}
+
+static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
+{
+	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
+	ide_expiry_t *expiry;
+	unsigned int timeout;
 	ide_startstop_t startstop;
 	u8 ireason;
 
@@ -434,7 +494,8 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	}
 
 	ireason = ide_read_ireason(drive);
-	if (drive->media == ide_tape && !drive->scsi)
+	if (drive->media == ide_tape &&
+	    (drive->dev_flags & IDE_DFLAG_SCSI) == 0)
 		ireason = ide_wait_ireason(drive, ireason);
 
 	if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
@@ -443,8 +504,27 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		return ide_do_reset(drive);
 	}
 
+	/*
+	 * If necessary schedule the packet transfer to occur 'timeout'
+	 * miliseconds later in ide_delayed_transfer_pc() after the device
+	 * says it's ready for a packet.
+	 */
+	if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
+		timeout = drive->pc_delay;
+		expiry = &ide_delayed_transfer_pc;
+	} else {
+		if (drive->dev_flags & IDE_DFLAG_SCSI) {
+			timeout = ide_scsi_get_timeout(pc);
+			expiry = ide_scsi_expiry;
+		} else {
+			timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
+							       : WAIT_TAPE_CMD;
+			expiry = NULL;
+		}
+	}
+
 	/* Set the interrupt routine */
-	ide_set_handler(drive, handler, timeout, expiry);
+	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
 
 	/* Begin DMA, if necessary */
 	if (pc->flags & PC_FLAG_DMA_OK) {
@@ -458,22 +538,22 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 
 	return ide_started;
 }
-EXPORT_SYMBOL_GPL(ide_transfer_pc);
 
-ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
-			     ide_handler_t *handler, unsigned int timeout,
+ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 			     ide_expiry_t *expiry)
 {
+	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
+	u32 tf_flags;
 	u16 bcount;
-	u8 dma = 0;
+	u8 scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI);
 
 	/* We haven't transferred any data yet */
 	pc->xferred = 0;
 	pc->cur_pos = pc->buf;
 
 	/* Request to transfer the entire buffer at once */
-	if (drive->media == ide_tape && !drive->scsi)
+	if (drive->media == ide_tape && scsi == 0)
 		bcount = pc->req_xfer;
 	else
 		bcount = min(pc->req_xfer, 63 * 1024);
@@ -483,28 +563,35 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		ide_dma_off(drive);
 	}
 
-	if ((pc->flags & PC_FLAG_DMA_OK) && drive->using_dma) {
-		if (drive->scsi)
+	if ((pc->flags & PC_FLAG_DMA_OK) &&
+	    (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
+		if (scsi)
 			hwif->sg_mapped = 1;
-		dma = !hwif->dma_ops->dma_setup(drive);
-		if (drive->scsi)
+		drive->dma = !hwif->dma_ops->dma_setup(drive);
+		if (scsi)
 			hwif->sg_mapped = 0;
 	}
 
-	if (!dma)
+	if (!drive->dma)
 		pc->flags &= ~PC_FLAG_DMA_OK;
 
-	ide_pktcmd_tf_load(drive, drive->scsi ? 0 : IDE_TFLAG_OUT_DEVICE,
-			   bcount, dma);
+	if (scsi)
+		tf_flags = 0;
+	else if (drive->media == ide_cdrom || drive->media == ide_optical)
+		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
+	else
+		tf_flags = IDE_TFLAG_OUT_DEVICE;
+
+	ide_pktcmd_tf_load(drive, tf_flags, bcount, drive->dma);
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		ide_execute_command(drive, ATA_CMD_PACKET, handler,
+		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
 				    timeout, NULL);
 		return ide_started;
 	} else {
 		ide_execute_pkt_cmd(drive);
-		return (*handler)(drive);
+		return ide_transfer_pc(drive);
 	}
 }
 EXPORT_SYMBOL_GPL(ide_issue_pc);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 465a92c..3308b1c 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -23,6 +23,9 @@
  *	Documentation/ide/ChangeLog.ide-cd.1994-2004
  */
 
+#define DRV_NAME "ide-cd"
+#define PFX DRV_NAME ": "
+
 #define IDECD_VERSION "5.00"
 
 #include <linux/module.h>
@@ -50,12 +53,15 @@
 
 #include "ide-cd.h"
 
-static DEFINE_MUTEX(idecd_ref_mutex);
+#define IDECD_DEBUG_LOG		1
 
-#define to_ide_cd(obj) container_of(obj, struct cdrom_info, kref)
+#if IDECD_DEBUG_LOG
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
+#else
+#define ide_debug_log(lvl, fmt, args...) do {} while (0)
+#endif
 
-#define ide_cd_g(disk) \
-	container_of((disk)->private_data, struct cdrom_info, driver)
+static DEFINE_MUTEX(idecd_ref_mutex);
 
 static void ide_cd_release(struct kref *);
 
@@ -64,7 +70,7 @@ static struct cdrom_info *ide_cd_get(struct gendisk *disk)
 	struct cdrom_info *cd = NULL;
 
 	mutex_lock(&idecd_ref_mutex);
-	cd = ide_cd_g(disk);
+	cd = ide_drv_g(disk, cdrom_info);
 	if (cd) {
 		if (ide_device_get(cd->drive))
 			cd = NULL;
@@ -102,6 +108,9 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 {
 	int log = 0;
 
+	ide_debug_log(IDE_DBG_SENSE, "Call %s, sense_key: 0x%x\n", __func__,
+		      sense->sense_key);
+
 	if (!sense || !rq || (rq->cmd_flags & REQ_QUIET))
 		return 0;
 
@@ -150,6 +159,14 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 	unsigned long bio_sectors;
 	struct cdrom_info *info = drive->driver_data;
 
+	ide_debug_log(IDE_DBG_SENSE, "Call %s, error_code: 0x%x, "
+			"sense_key: 0x%x\n", __func__, sense->error_code,
+			sense->sense_key);
+
+	if (failed_command)
+		ide_debug_log(IDE_DBG_SENSE, "%s: failed cmd: 0x%x\n",
+				__func__, failed_command->cmd[0]);
+
 	if (!cdrom_log_sense(drive, failed_command, sense))
 		return;
 
@@ -200,6 +217,8 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	struct cdrom_info *info		= drive->driver_data;
 	struct request *rq		= &info->request_sense_request;
 
+	ide_debug_log(IDE_DBG_SENSE, "Call %s\n", __func__);
+
 	if (sense == NULL)
 		sense = &info->sense_data;
 
@@ -219,6 +238,10 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	/* NOTE! Save the failed command in "rq->buffer" */
 	rq->buffer = (void *) failed_command;
 
+	if (failed_command)
+		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x\n",
+			      failed_command->cmd[0]);
+
 	ide_do_drive_cmd(drive, rq);
 }
 
@@ -227,6 +250,10 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 	struct request *rq = HWGROUP(drive)->rq;
 	int nsectors = rq->hard_cur_sectors;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s, cmd: 0x%x, uptodate: 0x%x, "
+		      "nsectors: %d\n", __func__, rq->cmd[0], uptodate,
+		      nsectors);
+
 	if (blk_sense_request(rq) && uptodate) {
 		/*
 		 * For REQ_TYPE_SENSE, "rq->buffer" points to the original
@@ -269,6 +296,9 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 	if (!nsectors)
 		nsectors = 1;
 
+	ide_debug_log(IDE_DBG_FUNC, "Exit %s, uptodate: 0x%x, nsectors: %d\n",
+		      __func__, uptodate, nsectors);
+
 	ide_end_request(drive, uptodate, nsectors);
 }
 
@@ -304,11 +334,15 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	sense_key = err >> 4;
 
 	if (rq == NULL) {
-		printk(KERN_ERR "%s: missing rq in %s\n",
+		printk(KERN_ERR PFX "%s: missing rq in %s\n",
 				drive->name, __func__);
 		return 1;
 	}
 
+	ide_debug_log(IDE_DBG_RQ, "%s: stat: 0x%x, good_stat: 0x%x, "
+		      "rq->cmd_type: 0x%x, err: 0x%x\n", __func__, stat,
+		      good_stat, rq->cmd_type, err);
+
 	if (blk_sense_request(rq)) {
 		/*
 		 * We got an error trying to get sense info from the drive
@@ -374,7 +408,8 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 				cdrom_saw_media_change(drive);
 
 				/* fail the request */
-				printk(KERN_ERR "%s: tray open\n", drive->name);
+				printk(KERN_ERR PFX "%s: tray open\n",
+						drive->name);
 				do_end_request = 1;
 			} else {
 				struct cdrom_info *info = drive->driver_data;
@@ -460,7 +495,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		if (stat & ATA_ERR)
 			cdrom_queue_request_sense(drive, NULL, NULL);
 	} else {
-		blk_dump_rq_flags(rq, "ide-cd: bad rq");
+		blk_dump_rq_flags(rq, PFX "bad rq");
 		cdrom_end_request(drive, 0);
 	}
 
@@ -488,6 +523,9 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 	struct request *rq = HWGROUP(drive)->rq;
 	unsigned long wait = 0;
 
+	ide_debug_log(IDE_DBG_RQ, "Call %s: rq->cmd[0]: 0x%x\n", __func__,
+		      rq->cmd[0]);
+
 	/*
 	 * Some commands are *slow* and normally take a long time to complete.
 	 * Usually we can use the ATAPI "disconnect" to bypass this, but not all
@@ -504,7 +542,7 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 		break;
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n",
+			printk(KERN_INFO PFX "cmd 0x%x timed out\n",
 					 rq->cmd[0]);
 		wait = 0;
 		break;
@@ -524,20 +562,21 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 						  int xferlen,
 						  ide_handler_t *handler)
 {
-	struct cdrom_info *info = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 
+	ide_debug_log(IDE_DBG_PC, "Call %s, xferlen: %d\n", __func__, xferlen);
+
 	/* FIXME: for Virtual DMA we must check harder */
-	if (info->dma)
-		info->dma = !hwif->dma_ops->dma_setup(drive);
+	if (drive->dma)
+		drive->dma = !hwif->dma_ops->dma_setup(drive);
 
 	/* set up the controller registers */
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL,
-			   xferlen, info->dma);
+			   xferlen, drive->dma);
 
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		/* waiting for CDB interrupt, not DMA yet. */
-		if (info->dma)
+		if (drive->dma)
 			drive->waiting_for_dma = 0;
 
 		/* packet command */
@@ -564,9 +603,10 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 {
 	ide_hwif_t *hwif = drive->hwif;
 	int cmd_len;
-	struct cdrom_info *info = drive->driver_data;
 	ide_startstop_t startstop;
 
+	ide_debug_log(IDE_DBG_PC, "Call %s\n", __func__);
+
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		/*
 		 * Here we should have been called after receiving an interrupt
@@ -578,7 +618,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 			return ide_stopped;
 
 		/* ok, next interrupt will be DMA interrupt */
-		if (info->dma)
+		if (drive->dma)
 			drive->waiting_for_dma = 1;
 	} else {
 		/* otherwise, we must wait for DRQ to get set */
@@ -599,7 +639,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 	hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
 
 	/* start the DMA if need be */
-	if (info->dma)
+	if (drive->dma)
 		hwif->dma_ops->dma_start(drive);
 
 	return ide_started;
@@ -615,6 +655,9 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 {
 	ide_hwif_t *hwif = drive->hwif;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s, ireason: 0x%x, rw: 0x%x\n",
+		      __func__, ireason, rw);
+
 	/*
 	 * ireason == 0: the drive wants to receive data from us
 	 * ireason == 2: the drive is expecting to transfer data to us
@@ -624,7 +667,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 	else if (ireason == (rw << 1)) {
 
 		/* whoops... */
-		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
+		printk(KERN_ERR PFX "%s: %s: wrong transfer direction!\n",
 				drive->name, __func__);
 
 		ide_pad_transfer(drive, rw, len);
@@ -637,7 +680,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 		return 0;
 	} else {
 		/* drive wants a command packet, or invalid ireason... */
-		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
+		printk(KERN_ERR PFX "%s: %s: bad interrupt reason 0x%02x\n",
 				drive->name, __func__, ireason);
 	}
 
@@ -654,17 +697,19 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
  */
 static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 {
+	ide_debug_log(IDE_DBG_FUNC, "Call %s, len: %d\n", __func__, len);
+
 	if ((len % SECTOR_SIZE) == 0)
 		return 0;
 
-	printk(KERN_ERR "%s: %s: Bad transfer size %d\n",
-			drive->name, __func__, len);
+	printk(KERN_ERR PFX "%s: %s: Bad transfer size %d\n", drive->name,
+			__func__, len);
 
 	if (drive->atapi_flags & IDE_AFLAG_LIMIT_NFRAMES)
-		printk(KERN_ERR "  This drive is not supported by "
-				"this version of the driver\n");
+		printk(KERN_ERR PFX "This drive is not supported by this "
+				"version of the driver\n");
 	else {
-		printk(KERN_ERR "  Trying to limit transfer sizes\n");
+		printk(KERN_ERR PFX "Trying to limit transfer sizes\n");
 		drive->atapi_flags |= IDE_AFLAG_LIMIT_NFRAMES;
 	}
 
@@ -676,6 +721,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
 static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
 						 struct request *rq)
 {
+	ide_debug_log(IDE_DBG_RQ, "Call %s: rq->cmd_flags: 0x%x\n", __func__,
+		      rq->cmd_flags);
+
 	if (rq_data_dir(rq) == READ) {
 		unsigned short sectors_per_frame =
 			queue_hardsect_size(drive->queue) >> SECTOR_BITS;
@@ -695,7 +743,7 @@ static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
 			/* sanity check... */
 			if (rq->current_nr_sectors !=
 			    bio_cur_sectors(rq->bio)) {
-				printk(KERN_ERR "%s: %s: buffer botch (%u)\n",
+				printk(KERN_ERR PFX "%s: %s: buffer botch (%u)\n",
 						drive->name, __func__,
 						rq->current_nr_sectors);
 				cdrom_end_request(drive, 0);
@@ -704,11 +752,7 @@ static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
 			rq->current_nr_sectors += nskip;
 		}
 	}
-#if 0
-	else
-		/* the immediate bit */
-		rq->cmd[1] = 1 << 3;
-#endif
+
 	/* set up the command */
 	rq->timeout = ATAPI_WAIT_PC;
 
@@ -739,6 +783,8 @@ static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 	int stat;
 	static int retry = 10;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if (cdrom_decode_status(drive, 0, &stat))
 		return ide_stopped;
 
@@ -746,7 +792,7 @@ static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 
 	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
 		if (--retry == 0)
-			drive->dsc_overlap = 0;
+			drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	}
 	return ide_stopped;
 }
@@ -755,6 +801,8 @@ static void ide_cd_prepare_seek_request(ide_drive_t *drive, struct request *rq)
 {
 	sector_t frame = rq->sector;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	sector_div(frame, queue_hardsect_size(drive->queue) >> SECTOR_BITS);
 
 	memset(rq->cmd, 0, BLK_MAX_CDB);
@@ -775,8 +823,11 @@ static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
  * Fix up a possibly partially-processed request so that we can start it over
  * entirely, or even put it back on the request queue.
  */
-static void restore_request(struct request *rq)
+static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
 {
+
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if (rq->buffer != bio_data(rq->bio)) {
 		sector_t n =
 			(rq->buffer - (char *)bio_data(rq->bio)) / SECTOR_SIZE;
@@ -795,8 +846,11 @@ static void restore_request(struct request *rq)
 /*
  * All other packet commands.
  */
-static void ide_cd_request_sense_fixup(struct request *rq)
+static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
 {
+
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	/*
 	 * Some of the trailing request sense fields are optional,
 	 * and some drives don't send them.  Sigh.
@@ -822,6 +876,10 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 	if (!sense)
 		sense = &local_sense;
 
+	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd[0]: 0x%x, write: 0x%x, "
+		      "timeout: %d, cmd_flags: 0x%x\n", __func__, cmd[0], write,
+		      timeout, cmd_flags);
+
 	/* start of retry loop */
 	do {
 		struct request *rq;
@@ -895,7 +953,6 @@ static int cdrom_newpc_intr_dummy_cb(struct request *rq)
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct cdrom_info *info = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
 	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
@@ -905,13 +962,16 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	u16 len;
 	u8 ireason;
 
+	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd[0]: 0x%x, write: 0x%x\n",
+		      __func__, rq->cmd[0], write);
+
 	/* check for errors */
-	dma = info->dma;
+	dma = drive->dma;
 	if (dma) {
-		info->dma = 0;
+		drive->dma = 0;
 		dma_error = hwif->dma_ops->dma_end(drive);
 		if (dma_error) {
-			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
+			printk(KERN_ERR PFX "%s: DMA %s error\n", drive->name,
 					write ? "write" : "read");
 			ide_dma_off(drive);
 		}
@@ -937,6 +997,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	if (thislen > len)
 		thislen = len;
 
+	ide_debug_log(IDE_DBG_PC, "%s: DRQ: stat: 0x%x, thislen: %d\n",
+		      __func__, stat, thislen);
+
 	/* If DRQ is clear, the command has completed. */
 	if ((stat & ATA_DRQ) == 0) {
 		if (blk_fs_request(rq)) {
@@ -946,7 +1009,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			 */
 			uptodate = 1;
 			if (rq->current_nr_sectors > 0) {
-				printk(KERN_ERR "%s: %s: data underrun "
+				printk(KERN_ERR PFX "%s: %s: data underrun "
 						"(%d blocks)\n",
 						drive->name, __func__,
 						rq->current_nr_sectors);
@@ -957,7 +1020,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			cdrom_end_request(drive, uptodate);
 			return ide_stopped;
 		} else if (!blk_pc_request(rq)) {
-			ide_cd_request_sense_fixup(rq);
+			ide_cd_request_sense_fixup(drive, rq);
 			/* complain if we still have data left to transfer */
 			uptodate = rq->data_len ? 0 : 1;
 		}
@@ -1000,6 +1063,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		xferfunc = hwif->tp_ops->input_data;
 	}
 
+	ide_debug_log(IDE_DBG_PC, "%s: data transfer, rq->cmd_type: 0x%x, "
+		      "ireason: 0x%x\n", __func__, rq->cmd_type, ireason);
+
 	/* transfer data */
 	while (thislen > 0) {
 		u8 *ptr = blk_fs_request(rq) ? NULL : rq->data;
@@ -1024,7 +1090,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 				 */
 				ide_pad_transfer(drive, 0, thislen);
 			else {
-				printk(KERN_ERR "%s: confused, missing data\n",
+				printk(KERN_ERR PFX "%s: confused, missing data\n",
 						drive->name);
 				blk_dump_rq_flags(rq, rq_data_dir(rq)
 						  ? "cdrom_newpc_intr, write"
@@ -1111,6 +1177,9 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	unsigned short sectors_per_frame =
 		queue_hardsect_size(drive->queue) >> SECTOR_BITS;
 
+	ide_debug_log(IDE_DBG_RQ, "Call %s, write: 0x%x, secs_per_frame: %u\n",
+		      __func__, write, sectors_per_frame);
+
 	if (write) {
 		/* disk has become write protected */
 		if (get_disk_ro(cd->disk)) {
@@ -1122,7 +1191,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 		 * We may be retrying this request after an error.  Fix up any
 		 * weirdness which might be present in the request packet.
 		 */
-		restore_request(rq);
+		ide_cd_restore_request(drive, rq);
 	}
 
 	/* use DMA, if possible / writes *must* be hardware frame aligned */
@@ -1132,9 +1201,9 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 			cdrom_end_request(drive, 0);
 			return ide_stopped;
 		}
-		cd->dma = 0;
+		drive->dma = 0;
 	} else
-		cd->dma = drive->using_dma;
+		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
 	if (write)
 		cd->devinfo.media_written = 1;
@@ -1151,14 +1220,16 @@ static ide_startstop_t cdrom_do_newpc_cont(ide_drive_t *drive)
 
 static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 {
-	struct cdrom_info *info = drive->driver_data;
+
+	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd_type: 0x%x\n", __func__,
+		      rq->cmd_type);
 
 	if (blk_pc_request(rq))
 		rq->cmd_flags |= REQ_QUIET;
 	else
 		rq->cmd_flags &= ~REQ_FAILED;
 
-	info->dma = 0;
+	drive->dma = 0;
 
 	/* sg request */
 	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
@@ -1171,7 +1242,7 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		else
 			buf = rq->data;
 
-		info->dma = drive->using_dma;
+		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
 		/*
 		 * check if dma is safe
@@ -1182,7 +1253,7 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 		if ((unsigned long)buf & alignment || rq->data_len & alignment
 		    || object_is_on_stack(buf))
-			info->dma = 0;
+			drive->dma = 0;
 	}
 }
 
@@ -1196,6 +1267,9 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 	ide_handler_t *fn;
 	int xferlen;
 
+	ide_debug_log(IDE_DBG_RQ, "Call %s, rq->cmd_type: 0x%x, block: %llu\n",
+		      __func__, rq->cmd_type, (unsigned long long)block);
+
 	if (blk_fs_request(rq)) {
 		if (drive->atapi_flags & IDE_AFLAG_SEEKING) {
 			ide_hwif_t *hwif = drive->hwif;
@@ -1208,7 +1282,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 							IDECD_SEEK_TIMER);
 					return ide_stopped;
 				}
-				printk(KERN_ERR "%s: DSC timeout\n",
+				printk(KERN_ERR PFX "%s: DSC timeout\n",
 						drive->name);
 			}
 			drive->atapi_flags &= ~IDE_AFLAG_SEEKING;
@@ -1216,11 +1290,11 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		if (rq_data_dir(rq) == READ &&
 		    IDE_LARGE_SEEK(info->last_block, block,
 			    IDECD_SEEK_THRESHOLD) &&
-		    drive->dsc_overlap) {
+		    (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP)) {
 			xferlen = 0;
 			fn = cdrom_start_seek_continuation;
 
-			info->dma = 0;
+			drive->dma = 0;
 			info->start_seek = jiffies;
 
 			ide_cd_prepare_seek_request(drive, rq);
@@ -1249,7 +1323,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		cdrom_end_request(drive, 1);
 		return ide_stopped;
 	} else {
-		blk_dump_rq_flags(rq, "ide-cd bad flags");
+		blk_dump_rq_flags(rq, DRV_NAME " bad flags");
 		cdrom_end_request(drive, 0);
 		return ide_stopped;
 	}
@@ -1279,6 +1353,8 @@ int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
 	struct cdrom_device_info *cdi = &info->devinfo;
 	unsigned char cmd[BLK_MAX_CDB];
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	memset(cmd, 0, BLK_MAX_CDB);
 	cmd[0] = GPCMD_TEST_UNIT_READY;
 
@@ -1305,6 +1381,8 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	unsigned len = sizeof(capbuf);
 	u32 blocklen;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	memset(cmd, 0, BLK_MAX_CDB);
 	cmd[0] = GPCMD_READ_CDVD_CAPACITY;
 
@@ -1324,10 +1402,10 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	case 4096:
 		break;
 	default:
-		printk(KERN_ERR "%s: weird block size %u\n",
-			drive->name, blocklen);
-		printk(KERN_ERR "%s: default to 2kb block size\n",
-			drive->name);
+		printk(KERN_ERR PFX "%s: weird block size %u\n",
+				drive->name, blocklen);
+		printk(KERN_ERR PFX "%s: default to 2kb block size\n",
+				drive->name);
 		blocklen = 2048;
 		break;
 	}
@@ -1343,6 +1421,8 @@ static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
 {
 	unsigned char cmd[BLK_MAX_CDB];
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	memset(cmd, 0, BLK_MAX_CDB);
 
 	cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
@@ -1371,11 +1451,13 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	long last_written;
 	unsigned long sectors_per_frame = SECTORS_PER_FRAME;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if (toc == NULL) {
 		/* try to allocate space */
 		toc = kmalloc(sizeof(struct atapi_toc), GFP_KERNEL);
 		if (toc == NULL) {
-			printk(KERN_ERR "%s: No cdrom TOC buffer!\n",
+			printk(KERN_ERR PFX "%s: No cdrom TOC buffer!\n",
 					drive->name);
 			return -ENOMEM;
 		}
@@ -1531,6 +1613,8 @@ int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 	struct packet_command cgc;
 	int stat, attempts = 3, size = ATAPI_CAPABILITIES_PAGE_SIZE;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if ((drive->atapi_flags & IDE_AFLAG_FULL_CAPS_PAGE) == 0)
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
 
@@ -1549,6 +1633,8 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 	struct cdrom_info *cd = drive->driver_data;
 	u16 curspeed, maxspeed;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if (drive->atapi_flags & IDE_AFLAG_LE_SPEED_FIELDS) {
 		curspeed = le16_to_cpup((__le16 *)&buf[8 + 14]);
 		maxspeed = le16_to_cpup((__le16 *)&buf[8 + 8]);
@@ -1589,6 +1675,8 @@ static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *devinfo = &info->devinfo;
 
+	ide_debug_log(IDE_DBG_PROBE, "Call %s, nslots: %d\n", __func__, nslots);
+
 	devinfo->ops = &ide_cdrom_dops;
 	devinfo->speed = info->current_speed;
 	devinfo->capacity = nslots;
@@ -1610,13 +1698,17 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	mechtype_t mechtype;
 	int nslots = 1;
 
+	ide_debug_log(IDE_DBG_PROBE, "Call %s, drive->media: 0x%x, "
+		      "drive->atapi_flags: 0x%lx\n", __func__, drive->media,
+		      drive->atapi_flags);
+
 	cdi->mask = (CDC_CD_R | CDC_CD_RW | CDC_DVD | CDC_DVD_R |
 		     CDC_DVD_RAM | CDC_SELECT_DISC | CDC_PLAY_AUDIO |
 		     CDC_MO_DRIVE | CDC_RAM);
 
 	if (drive->media == ide_optical) {
 		cdi->mask &= ~(CDC_MO_DRIVE | CDC_RAM);
-		printk(KERN_ERR "%s: ATAPI magneto-optical drive\n",
+		printk(KERN_ERR PFX "%s: ATAPI magneto-optical drive\n",
 				drive->name);
 		return nslots;
 	}
@@ -1674,7 +1766,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 
 	ide_cdrom_update_speed(drive, buf);
 
-	printk(KERN_INFO "%s: ATAPI", drive->name);
+	printk(KERN_INFO PFX "%s: ATAPI", drive->name);
 
 	/* don't print speed if the drive reported 0 */
 	if (cd->max_speed)
@@ -1697,7 +1789,8 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	else
 		printk(KERN_CONT " drive");
 
-	printk(KERN_CONT ", %dkB Cache\n", be16_to_cpup((__be16 *)&buf[8 + 12]));
+	printk(KERN_CONT ", %dkB Cache\n",
+			 be16_to_cpup((__be16 *)&buf[8 + 12]));
 
 	return nslots;
 }
@@ -1809,7 +1902,7 @@ static ide_proc_entry_t idecd_proc[] = {
 	{ NULL, 0, NULL, NULL }
 };
 
-ide_devset_rw_field(dsc_overlap, dsc_overlap);
+ide_devset_rw_flag(dsc_overlap, IDE_DFLAG_DSC_OVERLAP);
 
 static const struct ide_proc_devset idecd_settings[] = {
 	IDE_PROC_DEVSET(dsc_overlap, 0, 1),
@@ -1884,6 +1977,8 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	char *fw_rev = (char *)&id[ATA_ID_FW_REV];
 	int nslots;
 
+	ide_debug_log(IDE_DBG_PROBE, "Call %s\n", __func__);
+
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
 	blk_queue_dma_alignment(drive->queue, 31);
 	blk_queue_update_dma_pad(drive->queue, 15);
@@ -1891,14 +1986,9 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	if (!drive->queue->unplug_delay)
 		drive->queue->unplug_delay = 1;
 
-	drive->special.all	= 0;
-
 	drive->atapi_flags = IDE_AFLAG_MEDIA_CHANGED | IDE_AFLAG_NO_EJECT |
 		       ide_cd_flags(id);
 
-	if ((id[ATA_ID_CONFIG] & 0x0060) == 0x20)
-		drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
-
 	if ((drive->atapi_flags & IDE_AFLAG_VERTOS_300_SSD) &&
 	    fw_rev[4] == '1' && fw_rev[6] <= '2')
 		drive->atapi_flags |= (IDE_AFLAG_TOCTRACKS_AS_BCD |
@@ -1915,10 +2005,13 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	/* set correct block size */
 	blk_queue_hardsect_size(drive->queue, CD_FRAMESIZE);
 
-	drive->dsc_overlap = (drive->next != drive);
+	if (drive->next != drive)
+		drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 
 	if (ide_cdrom_register(drive, nslots)) {
-		printk(KERN_ERR "%s: %s failed to register device with the"
+		printk(KERN_ERR PFX "%s: %s failed to register device with the"
 				" cdrom driver.\n", drive->name, __func__);
 		cd->devinfo.handle = NULL;
 		return 1;
@@ -1932,6 +2025,8 @@ static void ide_cd_remove(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	ide_proc_unregister_driver(drive, info->driver);
 
 	del_gendisk(info->disk);
@@ -1941,15 +2036,17 @@ static void ide_cd_remove(ide_drive_t *drive)
 
 static void ide_cd_release(struct kref *kref)
 {
-	struct cdrom_info *info = to_ide_cd(kref);
+	struct cdrom_info *info = to_ide_drv(kref, cdrom_info);
 	struct cdrom_device_info *devinfo = &info->devinfo;
 	ide_drive_t *drive = info->drive;
 	struct gendisk *g = info->disk;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	kfree(info->toc);
 	if (devinfo->handle == drive)
 		unregister_cdrom(devinfo);
-	drive->dsc_overlap = 0;
+	drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	drive->driver_data = NULL;
 	blk_queue_prep_rq(drive->queue, NULL);
 	g->private_data = NULL;
@@ -1968,7 +2065,6 @@ static ide_driver_t ide_cdrom_driver = {
 	.probe			= ide_cd_probe,
 	.remove			= ide_cd_remove,
 	.version		= IDECD_VERSION,
-	.media			= ide_cdrom,
 	.do_request		= ide_cd_do_request,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
@@ -1999,7 +2095,7 @@ static int idecd_open(struct inode *inode, struct file *file)
 static int idecd_release(struct inode *inode, struct file *file)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct cdrom_info *info = ide_cd_g(disk);
+	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
 
 	cdrom_release(&info->devinfo, file);
 
@@ -2051,7 +2147,7 @@ static int idecd_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
-	struct cdrom_info *info = ide_cd_g(bdev->bd_disk);
+	struct cdrom_info *info = ide_drv_g(bdev->bd_disk, cdrom_info);
 	int err;
 
 	switch (cmd) {
@@ -2072,13 +2168,13 @@ static int idecd_ioctl(struct inode *inode, struct file *file,
 
 static int idecd_media_changed(struct gendisk *disk)
 {
-	struct cdrom_info *info = ide_cd_g(disk);
+	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
 	return cdrom_media_changed(&info->devinfo);
 }
 
 static int idecd_revalidate_disk(struct gendisk *disk)
 {
-	struct cdrom_info *info = ide_cd_g(disk);
+	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
 	struct request_sense sense;
 
 	ide_cd_read_toc(info->drive, &sense);
@@ -2097,8 +2193,11 @@ static struct block_device_operations idecd_ops = {
 
 /* module options */
 static char *ignore;
-
 module_param(ignore, charp, 0400);
+
+static unsigned long debug_mask;
+module_param(debug_mask, ulong, 0644);
+
 MODULE_DESCRIPTION("ATAPI CD-ROM Driver");
 
 static int ide_cd_probe(ide_drive_t *drive)
@@ -2107,6 +2206,10 @@ static int ide_cd_probe(ide_drive_t *drive)
 	struct gendisk *g;
 	struct request_sense sense;
 
+	ide_debug_log(IDE_DBG_PROBE, "Call %s, drive->driver_req: %s, "
+		      "drive->media: 0x%x\n", __func__, drive->driver_req,
+		      drive->media);
+
 	if (!strstr("ide-cdrom", drive->driver_req))
 		goto failed;
 
@@ -2116,14 +2219,17 @@ static int ide_cd_probe(ide_drive_t *drive)
 	/* skip drives that we were told to ignore */
 	if (ignore != NULL) {
 		if (strstr(ignore, drive->name)) {
-			printk(KERN_INFO "ide-cd: ignoring drive %s\n",
+			printk(KERN_INFO PFX "ignoring drive %s\n",
 					 drive->name);
 			goto failed;
 		}
 	}
+
+	drive->debug_mask = debug_mask;
+
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
 	if (info == NULL) {
-		printk(KERN_ERR "%s: Can't allocate a cdrom structure\n",
+		printk(KERN_ERR PFX "%s: Can't allocate a cdrom structure\n",
 				drive->name);
 		goto failed;
 	}
@@ -2171,6 +2277,7 @@ static void __exit ide_cdrom_exit(void)
 
 static int __init ide_cdrom_init(void)
 {
+	printk(KERN_INFO DRV_NAME " driver " IDECD_VERSION "\n");
 	return driver_register(&ide_cdrom_driver.gen_driver);
 }
 
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 61a4599..5882b9a 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -88,7 +88,6 @@ struct cdrom_info {
 	struct request_sense sense_data;
 
 	struct request request_sense_request;
-	int dma;
 	unsigned long last_block;
 	unsigned long start_seek;
 
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 01846f2..3853bde 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -45,21 +45,12 @@
 #define IDE_DISK_MINORS		0
 #endif
 
-struct ide_disk_obj {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
-	unsigned int	openers;	/* protected by BKL for now */
-};
+#include "ide-disk.h"
 
 static DEFINE_MUTEX(idedisk_ref_mutex);
 
 #define to_ide_disk(obj) container_of(obj, struct ide_disk_obj, kref)
 
-#define ide_disk_g(disk) \
-	container_of((disk)->private_data, struct ide_disk_obj, driver)
-
 static void ide_disk_release(struct kref *);
 
 static struct ide_disk_obj *ide_disk_get(struct gendisk *disk)
@@ -140,9 +131,9 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	unsigned int dma	= drive->using_dma;
 	u16 nsectors		= (u16)rq->nr_sectors;
-	u8 lba48		= (drive->addressing == 1) ? 1 : 0;
+	u8 lba48		= !!(drive->dev_flags & IDE_DFLAG_LBA48);
+	u8 dma			= !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 	ide_task_t		task;
 	struct ide_taskfile	*tf = &task.tf;
 	ide_startstop_t		rc;
@@ -162,7 +153,7 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	memset(&task, 0, sizeof(task));
 	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	if (drive->select.b.lba) {
+	if (drive->dev_flags & IDE_DFLAG_LBA) {
 		if (lba48) {
 			pr_debug("%s: LBA=0x%012llx\n", drive->name,
 					(unsigned long long)block);
@@ -187,6 +178,8 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 			tf->lbah   = block >>= 8;
 			tf->device = (block >> 8) & 0xf;
 		}
+
+		tf->device |= ATA_LBA;
 	} else {
 		unsigned int sect, head, cyl, track;
 
@@ -237,7 +230,7 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 {
 	ide_hwif_t *hwif = HWIF(drive);
 
-	BUG_ON(drive->blocked);
+	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
 
 	if (!blk_fs_request(rq)) {
 		blk_dump_rq_flags(rq, "ide_do_rw_disk - bad command");
@@ -384,139 +377,39 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 static void init_idedisk_capacity(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
-	/*
-	 * If this drive supports the Host Protected Area feature set,
-	 * then we may need to change our opinion about the drive's capacity.
-	 */
-	int hpa = ata_id_hpa_enabled(id);
+	int lba;
 
 	if (ata_id_lba48_enabled(id)) {
 		/* drive speaks 48-bit LBA */
-		drive->select.b.lba = 1;
+		lba = 1;
 		drive->capacity64 = ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
-		if (hpa)
-			idedisk_check_hpa(drive);
 	} else if (ata_id_has_lba(id) && ata_id_is_lba_capacity_ok(id)) {
 		/* drive speaks 28-bit LBA */
-		drive->select.b.lba = 1;
+		lba = 1;
 		drive->capacity64 = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
-		if (hpa)
-			idedisk_check_hpa(drive);
 	} else {
 		/* drive speaks boring old 28-bit CHS */
+		lba = 0;
 		drive->capacity64 = drive->cyl * drive->head * drive->sect;
 	}
-}
 
-static sector_t idedisk_capacity(ide_drive_t *drive)
-{
-	return drive->capacity64;
-}
+	if (lba) {
+		drive->dev_flags |= IDE_DFLAG_LBA;
 
-#ifdef CONFIG_IDE_PROC_FS
-static int smart_enable(ide_drive_t *drive)
-{
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
-
-	memset(&args, 0, sizeof(ide_task_t));
-	tf->feature = ATA_SMART_ENABLE;
-	tf->lbam    = ATA_SMART_LBAM_PASS;
-	tf->lbah    = ATA_SMART_LBAH_PASS;
-	tf->command = ATA_CMD_SMART;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	return ide_no_data_taskfile(drive, &args);
-}
-
-static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
-{
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
-
-	memset(&args, 0, sizeof(ide_task_t));
-	tf->feature = sub_cmd;
-	tf->nsect   = 0x01;
-	tf->lbam    = ATA_SMART_LBAM_PASS;
-	tf->lbah    = ATA_SMART_LBAH_PASS;
-	tf->command = ATA_CMD_SMART;
-	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	args.data_phase	= TASKFILE_IN;
-	(void) smart_enable(drive);
-	return ide_raw_taskfile(drive, &args, buf, 1);
-}
-
-static int proc_idedisk_read_cache
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
-{
-	ide_drive_t	*drive = (ide_drive_t *) data;
-	char		*out = page;
-	int		len;
-
-	if (drive->id_read)
-		len = sprintf(out, "%i\n", drive->id[ATA_ID_BUF_SIZE] / 2);
-	else
-		len = sprintf(out, "(none)\n");
-
-	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
-}
-
-static int proc_idedisk_read_capacity
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
-{
-	ide_drive_t*drive = (ide_drive_t *)data;
-	int len;
-
-	len = sprintf(page, "%llu\n", (long long)idedisk_capacity(drive));
-
-	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
-}
-
-static int proc_idedisk_read_smart(char *page, char **start, off_t off,
-				   int count, int *eof, void *data, u8 sub_cmd)
-{
-	ide_drive_t	*drive = (ide_drive_t *)data;
-	int		len = 0, i = 0;
-
-	if (get_smart_data(drive, page, sub_cmd) == 0) {
-		unsigned short *val = (unsigned short *) page;
-		char *out = (char *)val + SECTOR_SIZE;
-
-		page = out;
-		do {
-			out += sprintf(out, "%04x%c", le16_to_cpu(*val),
-				       (++i & 7) ? ' ' : '\n');
-			val += 1;
-		} while (i < SECTOR_SIZE / 2);
-		len = out - page;
+		/*
+		* If this device supports the Host Protected Area feature set,
+		* then we may need to change our opinion about its capacity.
+		*/
+		if (ata_id_hpa_enabled(id))
+			idedisk_check_hpa(drive);
 	}
-
-	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
-static int proc_idedisk_read_sv
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
+sector_t ide_disk_capacity(ide_drive_t *drive)
 {
-	return proc_idedisk_read_smart(page, start, off, count, eof, data,
-				       ATA_SMART_READ_VALUES);
-}
-
-static int proc_idedisk_read_st
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
-{
-	return proc_idedisk_read_smart(page, start, off, count, eof, data,
-				       ATA_SMART_READ_THRESHOLDS);
+	return drive->capacity64;
 }
 
-static ide_proc_entry_t idedisk_proc[] = {
-	{ "cache",	  S_IFREG|S_IRUGO, proc_idedisk_read_cache,    NULL },
-	{ "capacity",	  S_IFREG|S_IRUGO, proc_idedisk_read_capacity, NULL },
-	{ "geometry",	  S_IFREG|S_IRUGO, proc_ide_read_geometry,     NULL },
-	{ "smart_values", S_IFREG|S_IRUSR, proc_idedisk_read_sv,       NULL },
-	{ "smart_thresholds", S_IFREG|S_IRUSR, proc_idedisk_read_st,   NULL },
-	{ NULL, 0, NULL, NULL }
-};
-#endif	/* CONFIG_IDE_PROC_FS */
-
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
@@ -568,25 +461,43 @@ static int set_multcount(ide_drive_t *drive, int arg)
 	return (drive->mult_count == arg) ? 0 : -EIO;
 }
 
-ide_devset_get(nowerr, nowerr);
+ide_devset_get_flag(nowerr, IDE_DFLAG_NOWERR);
 
 static int set_nowerr(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	drive->nowerr = arg;
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_NOWERR;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_NOWERR;
+
 	drive->bad_wstat = arg ? BAD_R_STAT : BAD_W_STAT;
+
 	return 0;
 }
 
+static int ide_do_setfeature(ide_drive_t *drive, u8 feature, u8 nsect)
+{
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf.feature = feature;
+	task.tf.nsect   = nsect;
+	task.tf.command = ATA_CMD_SET_FEATURES;
+	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	return ide_no_data_taskfile(drive, &task);
+}
+
 static void update_ordered(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
 	unsigned ordered = QUEUE_ORDERED_NONE;
 	prepare_flush_fn *prep_fn = NULL;
 
-	if (drive->wcache) {
+	if (drive->dev_flags & IDE_DFLAG_WCACHE) {
 		unsigned long long capacity;
 		int barrier;
 		/*
@@ -597,9 +508,11 @@ static void update_ordered(ide_drive_t *drive)
 		 * time we have trimmed the drive capacity if LBA48 is
 		 * not available so we don't need to recheck that.
 		 */
-		capacity = idedisk_capacity(drive);
-		barrier = ata_id_flush_enabled(id) && !drive->noflush &&
-			(drive->addressing == 0 || capacity <= (1ULL << 28) ||
+		capacity = ide_disk_capacity(drive);
+		barrier = ata_id_flush_enabled(id) &&
+			(drive->dev_flags & IDE_DFLAG_NOFLUSH) == 0 &&
+			((drive->dev_flags & IDE_DFLAG_LBA48) == 0 ||
+			 capacity <= (1ULL << 28) ||
 			 ata_id_flush_ext_enabled(id));
 
 		printk(KERN_INFO "%s: cache flushes %ssupported\n",
@@ -615,25 +528,24 @@ static void update_ordered(ide_drive_t *drive)
 	blk_queue_ordered(drive->queue, ordered, prep_fn);
 }
 
-ide_devset_get(wcache, wcache);
+ide_devset_get_flag(wcache, IDE_DFLAG_WCACHE);
 
 static int set_wcache(ide_drive_t *drive, int arg)
 {
-	ide_task_t args;
 	int err = 1;
 
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
 	if (ata_id_flush_enabled(drive->id)) {
-		memset(&args, 0, sizeof(ide_task_t));
-		args.tf.feature = arg ?
-			SETFEATURES_WC_ON : SETFEATURES_WC_OFF;
-		args.tf.command = ATA_CMD_SET_FEATURES;
-		args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-		err = ide_no_data_taskfile(drive, &args);
-		if (err == 0)
-			drive->wcache = arg;
+		err = ide_do_setfeature(drive,
+			arg ? SETFEATURES_WC_ON : SETFEATURES_WC_OFF, 0);
+		if (err == 0) {
+			if (arg)
+				drive->dev_flags |= IDE_DFLAG_WCACHE;
+			else
+				drive->dev_flags &= ~IDE_DFLAG_WCACHE;
+		}
 	}
 
 	update_ordered(drive);
@@ -658,22 +570,18 @@ ide_devset_get(acoustic, acoustic);
 
 static int set_acoustic(ide_drive_t *drive, int arg)
 {
-	ide_task_t args;
-
 	if (arg < 0 || arg > 254)
 		return -EINVAL;
 
-	memset(&args, 0, sizeof(ide_task_t));
-	args.tf.feature = arg ? SETFEATURES_AAM_ON : SETFEATURES_AAM_OFF;
-	args.tf.nsect   = arg;
-	args.tf.command = ATA_CMD_SET_FEATURES;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	ide_no_data_taskfile(drive, &args);
+	ide_do_setfeature(drive,
+		arg ? SETFEATURES_AAM_ON : SETFEATURES_AAM_OFF, arg);
+
 	drive->acoustic = arg;
+
 	return 0;
 }
 
-ide_devset_get(addressing, addressing);
+ide_devset_get_flag(addressing, IDE_DFLAG_LBA48);
 
 /*
  * drive->addressing:
@@ -686,49 +594,27 @@ static int set_addressing(ide_drive_t *drive, int arg)
 	if (arg < 0 || arg > 2)
 		return -EINVAL;
 
-	drive->addressing =  0;
-
-	if (drive->hwif->host_flags & IDE_HFLAG_NO_LBA48)
-		return 0;
-
-	if (ata_id_lba48_enabled(drive->id) == 0)
+	if (arg && ((drive->hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
+	    ata_id_lba48_enabled(drive->id) == 0))
 		return -EIO;
 
-	drive->addressing = arg;
+	if (arg == 2)
+		arg = 0;
+
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_LBA48;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_LBA48;
 
 	return 0;
 }
 
-ide_devset_rw(acoustic, acoustic);
-ide_devset_rw(address, addressing);
-ide_devset_rw(multcount, multcount);
-ide_devset_rw(wcache, wcache);
-
-ide_devset_rw_sync(nowerr, nowerr);
+ide_ext_devset_rw(acoustic, acoustic);
+ide_ext_devset_rw(address, addressing);
+ide_ext_devset_rw(multcount, multcount);
+ide_ext_devset_rw(wcache, wcache);
 
-#ifdef CONFIG_IDE_PROC_FS
-ide_devset_rw_field(bios_cyl, bios_cyl);
-ide_devset_rw_field(bios_head, bios_head);
-ide_devset_rw_field(bios_sect, bios_sect);
-ide_devset_rw_field(failures, failures);
-ide_devset_rw_field(lun, lun);
-ide_devset_rw_field(max_failures, max_failures);
-
-static const struct ide_proc_devset idedisk_settings[] = {
-	IDE_PROC_DEVSET(acoustic,	0,   254),
-	IDE_PROC_DEVSET(address,	0,     2),
-	IDE_PROC_DEVSET(bios_cyl,	0, 65535),
-	IDE_PROC_DEVSET(bios_head,	0,   255),
-	IDE_PROC_DEVSET(bios_sect,	0,    63),
-	IDE_PROC_DEVSET(failures,	0, 65535),
-	IDE_PROC_DEVSET(lun,		0,     7),
-	IDE_PROC_DEVSET(max_failures,	0, 65535),
-	IDE_PROC_DEVSET(multcount,	0,    16),
-	IDE_PROC_DEVSET(nowerr,		0,     1),
-	IDE_PROC_DEVSET(wcache,		0,     1),
-	{ 0 },
-};
-#endif
+ide_ext_devset_rw_sync(nowerr, nowerr);
 
 static void idedisk_setup(ide_drive_t *drive)
 {
@@ -740,20 +626,20 @@ static void idedisk_setup(ide_drive_t *drive)
 
 	ide_proc_register_driver(drive, idkp->driver);
 
-	if (drive->id_read == 0)
+	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0)
 		return;
 
-	if (drive->removable) {
+	if (drive->dev_flags & IDE_DFLAG_REMOVABLE) {
 		/*
 		 * Removable disks (eg. SYQUEST); ignore 'WD' drives
 		 */
 		if (m[0] != 'W' || m[1] != 'D')
-			drive->doorlocking = 1;
+			drive->dev_flags |= IDE_DFLAG_DOORLOCKING;
 	}
 
 	(void)set_addressing(drive, 1);
 
-	if (drive->addressing == 1) {
+	if (drive->dev_flags & IDE_DFLAG_LBA48) {
 		int max_s = 2048;
 
 		if (max_s > hwif->rqsize)
@@ -769,7 +655,8 @@ static void idedisk_setup(ide_drive_t *drive)
 	init_idedisk_capacity(drive);
 
 	/* limit drive capacity to 137GB if LBA48 cannot be used */
-	if (drive->addressing == 0 && drive->capacity64 > 1ULL << 28) {
+	if ((drive->dev_flags & IDE_DFLAG_LBA48) == 0 &&
+	    drive->capacity64 > 1ULL << 28) {
 		printk(KERN_WARNING "%s: cannot use LBA48 - full capacity "
 		       "%llu sectors (%llu MB)\n",
 		       drive->name, (unsigned long long)drive->capacity64,
@@ -777,22 +664,23 @@ static void idedisk_setup(ide_drive_t *drive)
 		drive->capacity64 = 1ULL << 28;
 	}
 
-	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && drive->addressing) {
+	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) &&
+	    (drive->dev_flags & IDE_DFLAG_LBA48)) {
 		if (drive->capacity64 > 1ULL << 28) {
 			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode"
 					 " will be used for accessing sectors "
 					 "> %u\n", drive->name, 1 << 28);
 		} else
-			drive->addressing = 0;
+			drive->dev_flags &= ~IDE_DFLAG_LBA48;
 	}
 
 	/*
 	 * if possible, give fdisk access to more of the drive,
 	 * by correcting bios_cyls:
 	 */
-	capacity = idedisk_capacity(drive);
+	capacity = ide_disk_capacity(drive);
 
-	if (!drive->forced_geom) {
+	if ((drive->dev_flags & IDE_DFLAG_FORCED_GEOM) == 0) {
 		if (ata_id_lba48_enabled(drive->id)) {
 			/* compatibility */
 			drive->bios_sect = 63;
@@ -827,14 +715,15 @@ static void idedisk_setup(ide_drive_t *drive)
 
 	/* write cache enabled? */
 	if ((id[ATA_ID_CSFO] & 1) || ata_id_wcache_enabled(id))
-		drive->wcache = 1;
+		drive->dev_flags |= IDE_DFLAG_WCACHE;
 
 	set_wcache(drive, 1);
 }
 
 static void ide_cacheflush_p(ide_drive_t *drive)
 {
-	if (!drive->wcache || ata_id_flush_enabled(drive->id) == 0)
+	if (ata_id_flush_enabled(drive->id) == 0 ||
+	    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0)
 		return;
 
 	if (do_idedisk_flushcache(drive))
@@ -918,13 +807,12 @@ static ide_driver_t idedisk_driver = {
 	.resume			= ide_disk_resume,
 	.shutdown		= ide_device_shutdown,
 	.version		= IDEDISK_VERSION,
-	.media			= ide_disk,
 	.do_request		= ide_do_rw_disk,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
-	.proc			= idedisk_proc,
-	.settings		= idedisk_settings,
+	.proc			= ide_disk_proc,
+	.settings		= ide_disk_settings,
 #endif
 };
 
@@ -953,15 +841,16 @@ static int idedisk_open(struct inode *inode, struct file *filp)
 
 	idkp->openers++;
 
-	if (drive->removable && idkp->openers == 1) {
+	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
 		check_disk_change(inode->i_bdev);
 		/*
 		 * Ignore the return code from door_lock,
 		 * since the open() has already succeeded,
 		 * and the door_lock is irrelevant at this point.
 		 */
-		if (drive->doorlocking && idedisk_set_doorlock(drive, 1))
-			drive->doorlocking = 0;
+		if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) &&
+		    idedisk_set_doorlock(drive, 1))
+			drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
 	}
 	return 0;
 }
@@ -975,9 +864,10 @@ static int idedisk_release(struct inode *inode, struct file *filp)
 	if (idkp->openers == 1)
 		ide_cacheflush_p(drive);
 
-	if (drive->removable && idkp->openers == 1) {
-		if (drive->doorlocking && idedisk_set_doorlock(drive, 0))
-			drive->doorlocking = 0;
+	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
+		if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) &&
+		    idedisk_set_doorlock(drive, 0))
+			drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
 	}
 
 	idkp->openers--;
@@ -998,48 +888,25 @@ static int idedisk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static const struct ide_ioctl_devset ide_disk_ioctl_settings[] = {
-{ HDIO_GET_ADDRESS,	HDIO_SET_ADDRESS,   &ide_devset_address   },
-{ HDIO_GET_MULTCOUNT,	HDIO_SET_MULTCOUNT, &ide_devset_multcount },
-{ HDIO_GET_NOWERR,	HDIO_SET_NOWERR,    &ide_devset_nowerr	  },
-{ HDIO_GET_WCACHE,	HDIO_SET_WCACHE,    &ide_devset_wcache	  },
-{ HDIO_GET_ACOUSTIC,	HDIO_SET_ACOUSTIC,  &ide_devset_acoustic  },
-{ 0 }
-};
-
-static int idedisk_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
-{
-	struct block_device *bdev = inode->i_bdev;
-	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
-	ide_drive_t *drive = idkp->drive;
-	int err;
-
-	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_disk_ioctl_settings);
-	if (err != -EOPNOTSUPP)
-		return err;
-
-	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
-}
-
 static int idedisk_media_changed(struct gendisk *disk)
 {
 	struct ide_disk_obj *idkp = ide_disk_g(disk);
 	ide_drive_t *drive = idkp->drive;
 
 	/* do not scan partitions twice if this is a removable device */
-	if (drive->attach) {
-		drive->attach = 0;
+	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
+		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
 		return 0;
 	}
+
 	/* if removable, always assume it was changed */
-	return drive->removable;
+	return !!(drive->dev_flags & IDE_DFLAG_REMOVABLE);
 }
 
 static int idedisk_revalidate_disk(struct gendisk *disk)
 {
 	struct ide_disk_obj *idkp = ide_disk_g(disk);
-	set_capacity(disk, idedisk_capacity(idkp->drive));
+	set_capacity(disk, ide_disk_capacity(idkp->drive));
 	return 0;
 }
 
@@ -1047,7 +914,7 @@ static struct block_device_operations idedisk_ops = {
 	.owner			= THIS_MODULE,
 	.open			= idedisk_open,
 	.release		= idedisk_release,
-	.ioctl			= idedisk_ioctl,
+	.ioctl			= ide_disk_ioctl,
 	.getgeo			= idedisk_getgeo,
 	.media_changed		= idedisk_media_changed,
 	.revalidate_disk	= idedisk_revalidate_disk
@@ -1088,19 +955,20 @@ static int ide_disk_probe(ide_drive_t *drive)
 	drive->driver_data = idkp;
 
 	idedisk_setup(drive);
-	if ((!drive->head || drive->head > 16) && !drive->select.b.lba) {
+	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 &&
+	    (drive->head == 0 || drive->head > 16)) {
 		printk(KERN_ERR "%s: INVALID GEOMETRY: %d PHYSICAL HEADS?\n",
 			drive->name, drive->head);
-		drive->attach = 0;
+		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
 	} else
-		drive->attach = 1;
+		drive->dev_flags |= IDE_DFLAG_ATTACH;
 
 	g->minors = IDE_DISK_MINORS;
 	g->driverfs_dev = &drive->gendev;
 	g->flags |= GENHD_FL_EXT_DEVT;
-	if (drive->removable)
-		g->flags |= GENHD_FL_REMOVABLE;
-	set_capacity(g, idedisk_capacity(drive));
+	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
+		g->flags = GENHD_FL_REMOVABLE;
+	set_capacity(g, ide_disk_capacity(drive));
 	g->fops = &idedisk_ops;
 	add_disk(g);
 	return 0;
@@ -1122,6 +990,7 @@ static int __init idedisk_init(void)
 }
 
 MODULE_ALIAS("ide:*m-disk*");
+MODULE_ALIAS("ide-disk");
 module_init(idedisk_init);
 module_exit(idedisk_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/ide/ide-disk.h b/drivers/ide/ide-disk.h
new file mode 100644
index 0000000..a82fa43
--- /dev/null
+++ b/drivers/ide/ide-disk.h
@@ -0,0 +1,32 @@
+#ifndef __IDE_DISK_H
+#define __IDE_DISK_H
+
+struct ide_disk_obj {
+	ide_drive_t	*drive;
+	ide_driver_t	*driver;
+	struct gendisk	*disk;
+	struct kref	kref;
+	unsigned int	openers;	/* protected by BKL for now */
+};
+
+#define ide_disk_g(disk) \
+	container_of((disk)->private_data, struct ide_disk_obj, driver)
+
+/* ide-disk.c */
+sector_t ide_disk_capacity(ide_drive_t *);
+ide_decl_devset(address);
+ide_decl_devset(multcount);
+ide_decl_devset(nowerr);
+ide_decl_devset(wcache);
+ide_decl_devset(acoustic);
+
+/* ide-disk_ioctl.c */
+int ide_disk_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+
+#ifdef CONFIG_IDE_PROC_FS
+/* ide-disk_proc.c */
+extern ide_proc_entry_t ide_disk_proc[];
+extern const struct ide_proc_devset ide_disk_settings[];
+#endif
+
+#endif /* __IDE_DISK_H */
diff --git a/drivers/ide/ide-disk_ioctl.c b/drivers/ide/ide-disk_ioctl.c
new file mode 100644
index 0000000..a6cf1a0
--- /dev/null
+++ b/drivers/ide/ide-disk_ioctl.c
@@ -0,0 +1,29 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/hdreg.h>
+
+#include "ide-disk.h"
+
+static const struct ide_ioctl_devset ide_disk_ioctl_settings[] = {
+{ HDIO_GET_ADDRESS,	HDIO_SET_ADDRESS,   &ide_devset_address   },
+{ HDIO_GET_MULTCOUNT,	HDIO_SET_MULTCOUNT, &ide_devset_multcount },
+{ HDIO_GET_NOWERR,	HDIO_SET_NOWERR,    &ide_devset_nowerr	  },
+{ HDIO_GET_WCACHE,	HDIO_SET_WCACHE,    &ide_devset_wcache	  },
+{ HDIO_GET_ACOUSTIC,	HDIO_SET_ACOUSTIC,  &ide_devset_acoustic  },
+{ 0 }
+};
+
+int ide_disk_ioctl(struct inode *inode, struct file *file,
+		   unsigned int cmd, unsigned long arg)
+{
+	struct block_device *bdev = inode->i_bdev;
+	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
+	ide_drive_t *drive = idkp->drive;
+	int err;
+
+	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_disk_ioctl_settings);
+	if (err != -EOPNOTSUPP)
+		return err;
+
+	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
+}
diff --git a/drivers/ide/ide-disk_proc.c b/drivers/ide/ide-disk_proc.c
new file mode 100644
index 0000000..4724976
--- /dev/null
+++ b/drivers/ide/ide-disk_proc.c
@@ -0,0 +1,129 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/hdreg.h>
+
+#include "ide-disk.h"
+
+static int smart_enable(ide_drive_t *drive)
+{
+	ide_task_t args;
+	struct ide_taskfile *tf = &args.tf;
+
+	memset(&args, 0, sizeof(ide_task_t));
+	tf->feature = ATA_SMART_ENABLE;
+	tf->lbam    = ATA_SMART_LBAM_PASS;
+	tf->lbah    = ATA_SMART_LBAH_PASS;
+	tf->command = ATA_CMD_SMART;
+	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	return ide_no_data_taskfile(drive, &args);
+}
+
+static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
+{
+	ide_task_t args;
+	struct ide_taskfile *tf = &args.tf;
+
+	memset(&args, 0, sizeof(ide_task_t));
+	tf->feature = sub_cmd;
+	tf->nsect   = 0x01;
+	tf->lbam    = ATA_SMART_LBAM_PASS;
+	tf->lbah    = ATA_SMART_LBAH_PASS;
+	tf->command = ATA_CMD_SMART;
+	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	args.data_phase	= TASKFILE_IN;
+	(void) smart_enable(drive);
+	return ide_raw_taskfile(drive, &args, buf, 1);
+}
+
+static int proc_idedisk_read_cache
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	ide_drive_t	*drive = (ide_drive_t *) data;
+	char		*out = page;
+	int		len;
+
+	if (drive->dev_flags & IDE_DFLAG_ID_READ)
+		len = sprintf(out, "%i\n", drive->id[ATA_ID_BUF_SIZE] / 2);
+	else
+		len = sprintf(out, "(none)\n");
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
+}
+
+static int proc_idedisk_read_capacity
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	ide_drive_t*drive = (ide_drive_t *)data;
+	int len;
+
+	len = sprintf(page, "%llu\n", (long long)ide_disk_capacity(drive));
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
+}
+
+static int proc_idedisk_read_smart(char *page, char **start, off_t off,
+				   int count, int *eof, void *data, u8 sub_cmd)
+{
+	ide_drive_t	*drive = (ide_drive_t *)data;
+	int		len = 0, i = 0;
+
+	if (get_smart_data(drive, page, sub_cmd) == 0) {
+		unsigned short *val = (unsigned short *) page;
+		char *out = (char *)val + SECTOR_SIZE;
+
+		page = out;
+		do {
+			out += sprintf(out, "%04x%c", le16_to_cpu(*val),
+				       (++i & 7) ? ' ' : '\n');
+			val += 1;
+		} while (i < SECTOR_SIZE / 2);
+		len = out - page;
+	}
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
+}
+
+static int proc_idedisk_read_sv
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	return proc_idedisk_read_smart(page, start, off, count, eof, data,
+				       ATA_SMART_READ_VALUES);
+}
+
+static int proc_idedisk_read_st
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	return proc_idedisk_read_smart(page, start, off, count, eof, data,
+				       ATA_SMART_READ_THRESHOLDS);
+}
+
+ide_proc_entry_t ide_disk_proc[] = {
+	{ "cache",	  S_IFREG|S_IRUGO, proc_idedisk_read_cache,    NULL },
+	{ "capacity",	  S_IFREG|S_IRUGO, proc_idedisk_read_capacity, NULL },
+	{ "geometry",	  S_IFREG|S_IRUGO, proc_ide_read_geometry,     NULL },
+	{ "smart_values", S_IFREG|S_IRUSR, proc_idedisk_read_sv,       NULL },
+	{ "smart_thresholds", S_IFREG|S_IRUSR, proc_idedisk_read_st,   NULL },
+	{ NULL, 0, NULL, NULL }
+};
+
+ide_devset_rw_field(bios_cyl, bios_cyl);
+ide_devset_rw_field(bios_head, bios_head);
+ide_devset_rw_field(bios_sect, bios_sect);
+ide_devset_rw_field(failures, failures);
+ide_devset_rw_field(lun, lun);
+ide_devset_rw_field(max_failures, max_failures);
+
+const struct ide_proc_devset ide_disk_settings[] = {
+	IDE_PROC_DEVSET(acoustic,	0,   254),
+	IDE_PROC_DEVSET(address,	0,     2),
+	IDE_PROC_DEVSET(bios_cyl,	0, 65535),
+	IDE_PROC_DEVSET(bios_head,	0,   255),
+	IDE_PROC_DEVSET(bios_sect,	0,    63),
+	IDE_PROC_DEVSET(failures,	0, 65535),
+	IDE_PROC_DEVSET(lun,		0,     7),
+	IDE_PROC_DEVSET(max_failures,	0, 65535),
+	IDE_PROC_DEVSET(multcount,	0,    16),
+	IDE_PROC_DEVSET(nowerr,		0,     1),
+	IDE_PROC_DEVSET(wcache,		0,     1),
+	{ 0 },
+};
diff --git a/drivers/ide/ide-dma-sff.c b/drivers/ide/ide-dma-sff.c
new file mode 100644
index 0000000..0903782
--- /dev/null
+++ b/drivers/ide/ide-dma-sff.c
@@ -0,0 +1,356 @@
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+
+/**
+ *	config_drive_for_dma	-	attempt to activate IDE DMA
+ *	@drive: the drive to place in DMA mode
+ *
+ *	If the drive supports at least mode 2 DMA or UDMA of any kind
+ *	then attempt to place it into DMA mode. Drives that are known to
+ *	support DMA but predate the DMA properties or that are known
+ *	to have DMA handling bugs are also set up appropriately based
+ *	on the good/bad drive lists.
+ */
+
+int config_drive_for_dma(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u16 *id = drive->id;
+
+	if (drive->media != ide_disk) {
+		if (hwif->host_flags & IDE_HFLAG_NO_ATAPI_DMA)
+			return 0;
+	}
+
+	/*
+	 * Enable DMA on any drive that has
+	 * UltraDMA (mode 0/1/2/3/4/5/6) enabled
+	 */
+	if ((id[ATA_ID_FIELD_VALID] & 4) &&
+	    ((id[ATA_ID_UDMA_MODES] >> 8) & 0x7f))
+		return 1;
+
+	/*
+	 * Enable DMA on any drive that has mode2 DMA
+	 * (multi or single) enabled
+	 */
+	if (id[ATA_ID_FIELD_VALID] & 2)	/* regular DMA */
+		if ((id[ATA_ID_MWDMA_MODES] & 0x404) == 0x404 ||
+		    (id[ATA_ID_SWDMA_MODES] & 0x404) == 0x404)
+			return 1;
+
+	/* Consult the list of known "good" drives */
+	if (ide_dma_good_drive(drive))
+		return 1;
+
+	return 0;
+}
+
+/**
+ *	ide_dma_host_set	-	Enable/disable DMA on a host
+ *	@drive: drive to control
+ *
+ *	Enable/disable DMA on an IDE controller following generic
+ *	bus-mastering IDE controller behaviour.
+ */
+
+void ide_dma_host_set(ide_drive_t *drive, int on)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 unit = drive->dn & 1;
+	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	if (on)
+		dma_stat |= (1 << (5 + unit));
+	else
+		dma_stat &= ~(1 << (5 + unit));
+
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(dma_stat,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
+	else
+		outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
+}
+EXPORT_SYMBOL_GPL(ide_dma_host_set);
+
+/**
+ *	ide_build_dmatable	-	build IDE DMA table
+ *
+ *	ide_build_dmatable() prepares a dma request. We map the command
+ *	to get the pci bus addresses of the buffers and then build up
+ *	the PRD table that the IDE layer wants to be fed.
+ *
+ *	Most chipsets correctly interpret a length of 0x0000 as 64KB,
+ *	but at least one (e.g. CS5530) misinterprets it as zero (!).
+ *	So we break the 64KB entry into two 32KB entries instead.
+ *
+ *	Returns the number of built PRD entries if all went okay,
+ *	returns 0 otherwise.
+ *
+ *	May also be invoked from trm290.c
+ */
+
+int ide_build_dmatable(ide_drive_t *drive, struct request *rq)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	__le32 *table = (__le32 *)hwif->dmatable_cpu;
+	unsigned int is_trm290	= (hwif->chipset == ide_trm290) ? 1 : 0;
+	unsigned int count = 0;
+	int i;
+	struct scatterlist *sg;
+
+	hwif->sg_nents = ide_build_sglist(drive, rq);
+	if (hwif->sg_nents == 0)
+		return 0;
+
+	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
+		u32 cur_addr, cur_len, xcount, bcount;
+
+		cur_addr = sg_dma_address(sg);
+		cur_len = sg_dma_len(sg);
+
+		/*
+		 * Fill in the dma table, without crossing any 64kB boundaries.
+		 * Most hardware requires 16-bit alignment of all blocks,
+		 * but the trm290 requires 32-bit alignment.
+		 */
+
+		while (cur_len) {
+			if (count++ >= PRD_ENTRIES)
+				goto use_pio_instead;
+
+			bcount = 0x10000 - (cur_addr & 0xffff);
+			if (bcount > cur_len)
+				bcount = cur_len;
+			*table++ = cpu_to_le32(cur_addr);
+			xcount = bcount & 0xffff;
+			if (is_trm290)
+				xcount = ((xcount >> 2) - 1) << 16;
+			if (xcount == 0x0000) {
+				if (count++ >= PRD_ENTRIES)
+					goto use_pio_instead;
+				*table++ = cpu_to_le32(0x8000);
+				*table++ = cpu_to_le32(cur_addr + 0x8000);
+				xcount = 0x8000;
+			}
+			*table++ = cpu_to_le32(xcount);
+			cur_addr += bcount;
+			cur_len -= bcount;
+		}
+	}
+
+	if (count) {
+		if (!is_trm290)
+			*--table |= cpu_to_le32(0x80000000);
+		return count;
+	}
+
+use_pio_instead:
+	printk(KERN_ERR "%s: %s\n", drive->name,
+		count ? "DMA table too small" : "empty DMA table?");
+
+	ide_destroy_dmatable(drive);
+
+	return 0; /* revert to PIO for this request */
+}
+EXPORT_SYMBOL_GPL(ide_build_dmatable);
+
+/**
+ *	ide_dma_setup	-	begin a DMA phase
+ *	@drive: target device
+ *
+ *	Build an IDE DMA PRD (IDE speak for scatter gather table)
+ *	and then set up the DMA transfer registers for a device
+ *	that follows generic IDE PCI DMA behaviour. Controllers can
+ *	override this function if they need to
+ *
+ *	Returns 0 on success. If a PIO fallback is required then 1
+ *	is returned.
+ */
+
+int ide_dma_setup(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = hwif->hwgroup->rq;
+	unsigned int reading;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 dma_stat;
+
+	if (rq_data_dir(rq))
+		reading = 0;
+	else
+		reading = 1 << 3;
+
+	/* fall back to pio! */
+	if (!ide_build_dmatable(drive, rq)) {
+		ide_map_sg(drive, rq);
+		return 1;
+	}
+
+	/* PRD table */
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writel(hwif->dmatable_dma,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_TABLE_OFS));
+	else
+		outl(hwif->dmatable_dma, hwif->dma_base + ATA_DMA_TABLE_OFS);
+
+	/* specify r/w */
+	if (mmio)
+		writeb(reading, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+	else
+		outb(reading, hwif->dma_base + ATA_DMA_CMD);
+
+	/* read DMA status for INTR & ERROR flags */
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	/* clear INTR & ERROR flags */
+	if (mmio)
+		writeb(dma_stat | 6,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
+	else
+		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
+
+	drive->waiting_for_dma = 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_dma_setup);
+
+/**
+ *	dma_timer_expiry	-	handle a DMA timeout
+ *	@drive: Drive that timed out
+ *
+ *	An IDE DMA transfer timed out. In the event of an error we ask
+ *	the driver to resolve the problem, if a DMA transfer is still
+ *	in progress we continue to wait (arguably we need to add a
+ *	secondary 'I don't care what the drive thinks' timeout here)
+ *	Finally if we have an interrupt we let it complete the I/O.
+ *	But only one time - we clear expiry and if it's still not
+ *	completed after WAIT_CMD, we error and retry in PIO.
+ *	This can occur if an interrupt is lost or due to hang or bugs.
+ */
+
+static int dma_timer_expiry(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	printk(KERN_WARNING "%s: %s: DMA status (0x%02x)\n",
+		drive->name, __func__, dma_stat);
+
+	if ((dma_stat & 0x18) == 0x18)	/* BUSY Stupid Early Timer !! */
+		return WAIT_CMD;
+
+	hwif->hwgroup->expiry = NULL;	/* one free ride for now */
+
+	/* 1 dmaing, 2 error, 4 intr */
+	if (dma_stat & 2)	/* ERROR */
+		return -1;
+
+	if (dma_stat & 1)	/* DMAing */
+		return WAIT_CMD;
+
+	if (dma_stat & 4)	/* Got an Interrupt */
+		return WAIT_CMD;
+
+	return 0;	/* Status is unknown -- reset the bus */
+}
+
+void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
+{
+	/* issue cmd to drive */
+	ide_execute_command(drive, command, &ide_dma_intr, 2 * WAIT_CMD,
+			    dma_timer_expiry);
+}
+EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
+
+void ide_dma_start(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_cmd;
+
+	/* Note that this is done *after* the cmd has
+	 * been issued to the drive, as per the BM-IDE spec.
+	 * The Promise Ultra33 doesn't work correctly when
+	 * we do this part before issuing the drive cmd.
+	 */
+	if (hwif->host_flags & IDE_HFLAG_MMIO) {
+		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+		/* start DMA */
+		writeb(dma_cmd | 1,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+	} else {
+		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
+		outb(dma_cmd | 1, hwif->dma_base + ATA_DMA_CMD);
+	}
+
+	wmb();
+}
+EXPORT_SYMBOL_GPL(ide_dma_start);
+
+/* returns 1 on error, 0 otherwise */
+int ide_dma_end(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 dma_stat = 0, dma_cmd = 0;
+
+	drive->waiting_for_dma = 0;
+
+	if (mmio) {
+		/* get DMA command mode */
+		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+		/* stop DMA */
+		writeb(dma_cmd & ~1,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+	} else {
+		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
+		outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
+	}
+
+	/* get DMA status */
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	if (mmio)
+		/* clear the INTR & ERROR bits */
+		writeb(dma_stat | 6,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
+	else
+		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
+
+	/* purge DMA mappings */
+	ide_destroy_dmatable(drive);
+	/* verify good DMA status */
+	wmb();
+	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
+}
+EXPORT_SYMBOL_GPL(ide_dma_end);
+
+/* returns 1 if dma irq issued, 0 otherwise */
+int ide_dma_test_irq(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	/* return 1 if INTR asserted */
+	if ((dma_stat & 4) == 4)
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_dma_test_irq);
+
+const struct ide_dma_ops sff_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_timeout		= ide_dma_timeout,
+	.dma_lost_irq		= ide_dma_lost_irq,
+};
+EXPORT_SYMBOL_GPL(sff_dma_ops);
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index ef2f150..fffd117 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -28,24 +28,13 @@
  * for supplying a Promise UDMA board & WD UDMA drive for this work!
  */
 
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/ide.h>
-#include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/io.h>
-#include <asm/irq.h>
-
-static const struct drive_list_entry drive_whitelist [] = {
-
+static const struct drive_list_entry drive_whitelist[] = {
 	{ "Micropolis 2112A"	,       NULL		},
 	{ "CONNER CTMA 4000"	,       NULL		},
 	{ "CONNER CTT8000-A"	,       NULL		},
@@ -53,8 +42,7 @@ static const struct drive_list_entry drive_whitelist [] = {
 	{ NULL			,	NULL		}
 };
 
-static const struct drive_list_entry drive_blacklist [] = {
-
+static const struct drive_list_entry drive_blacklist[] = {
 	{ "WDC AC11000H"	,	NULL 		},
 	{ "WDC AC22100H"	,	NULL 		},
 	{ "WDC AC32500H"	,	NULL 		},
@@ -94,11 +82,11 @@ static const struct drive_list_entry drive_blacklist [] = {
  *	ide_dma_intr	-	IDE DMA interrupt handler
  *	@drive: the drive the interrupt is for
  *
- *	Handle an interrupt completing a read/write DMA transfer on an 
+ *	Handle an interrupt completing a read/write DMA transfer on an
  *	IDE device
  */
- 
-ide_startstop_t ide_dma_intr (ide_drive_t *drive)
+
+ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 stat = 0, dma_stat = 0;
@@ -108,20 +96,19 @@ ide_startstop_t ide_dma_intr (ide_drive_t *drive)
 
 	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
 		if (!dma_stat) {
-			struct request *rq = HWGROUP(drive)->rq;
+			struct request *rq = hwif->hwgroup->rq;
 
 			task_end_request(drive, rq, stat);
 			return ide_stopped;
 		}
-		printk(KERN_ERR "%s: dma_intr: bad DMA status (dma_stat=%x)\n", 
-		       drive->name, dma_stat);
+		printk(KERN_ERR "%s: %s: bad DMA status (0x%02x)\n",
+			drive->name, __func__, dma_stat);
 	}
 	return ide_error(drive, "dma_intr", stat);
 }
-
 EXPORT_SYMBOL_GPL(ide_dma_intr);
 
-static int ide_dma_good_drive(ide_drive_t *drive)
+int ide_dma_good_drive(ide_drive_t *drive)
 {
 	return ide_in_drive_list(drive->id, drive_whitelist);
 }
@@ -139,7 +126,7 @@ static int ide_dma_good_drive(ide_drive_t *drive)
 
 int ide_build_sglist(ide_drive_t *drive, struct request *rq)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
 
 	ide_map_sg(drive, rq);
@@ -152,106 +139,8 @@ int ide_build_sglist(ide_drive_t *drive, struct request *rq)
 	return dma_map_sg(hwif->dev, sg, hwif->sg_nents,
 			  hwif->sg_dma_direction);
 }
-
 EXPORT_SYMBOL_GPL(ide_build_sglist);
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
-/**
- *	ide_build_dmatable	-	build IDE DMA table
- *
- *	ide_build_dmatable() prepares a dma request. We map the command
- *	to get the pci bus addresses of the buffers and then build up
- *	the PRD table that the IDE layer wants to be fed. The code
- *	knows about the 64K wrap bug in the CS5530.
- *
- *	Returns the number of built PRD entries if all went okay,
- *	returns 0 otherwise.
- *
- *	May also be invoked from trm290.c
- */
- 
-int ide_build_dmatable (ide_drive_t *drive, struct request *rq)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	__le32 *table = (__le32 *)hwif->dmatable_cpu;
-	unsigned int is_trm290	= (hwif->chipset == ide_trm290) ? 1 : 0;
-	unsigned int count = 0;
-	int i;
-	struct scatterlist *sg;
-
-	hwif->sg_nents = i = ide_build_sglist(drive, rq);
-
-	if (!i)
-		return 0;
-
-	sg = hwif->sg_table;
-	while (i) {
-		u32 cur_addr;
-		u32 cur_len;
-
-		cur_addr = sg_dma_address(sg);
-		cur_len = sg_dma_len(sg);
-
-		/*
-		 * Fill in the dma table, without crossing any 64kB boundaries.
-		 * Most hardware requires 16-bit alignment of all blocks,
-		 * but the trm290 requires 32-bit alignment.
-		 */
-
-		while (cur_len) {
-			if (count++ >= PRD_ENTRIES) {
-				printk(KERN_ERR "%s: DMA table too small\n", drive->name);
-				goto use_pio_instead;
-			} else {
-				u32 xcount, bcount = 0x10000 - (cur_addr & 0xffff);
-
-				if (bcount > cur_len)
-					bcount = cur_len;
-				*table++ = cpu_to_le32(cur_addr);
-				xcount = bcount & 0xffff;
-				if (is_trm290)
-					xcount = ((xcount >> 2) - 1) << 16;
-				else if (xcount == 0x0000) {
-	/* 
-	 * Most chipsets correctly interpret a length of 0x0000 as 64KB,
-	 * but at least one (e.g. CS5530) misinterprets it as zero (!).
-	 * So here we break the 64KB entry into two 32KB entries instead.
-	 */
-					if (count++ >= PRD_ENTRIES) {
-						printk(KERN_ERR "%s: DMA table too small\n", drive->name);
-						goto use_pio_instead;
-					}
-					*table++ = cpu_to_le32(0x8000);
-					*table++ = cpu_to_le32(cur_addr + 0x8000);
-					xcount = 0x8000;
-				}
-				*table++ = cpu_to_le32(xcount);
-				cur_addr += bcount;
-				cur_len -= bcount;
-			}
-		}
-
-		sg = sg_next(sg);
-		i--;
-	}
-
-	if (count) {
-		if (!is_trm290)
-			*--table |= cpu_to_le32(0x80000000);
-		return count;
-	}
-
-	printk(KERN_ERR "%s: empty DMA table?\n", drive->name);
-
-use_pio_instead:
-	ide_destroy_dmatable(drive);
-
-	return 0; /* revert to PIO for this request */
-}
-
-EXPORT_SYMBOL_GPL(ide_build_dmatable);
-#endif
-
 /**
  *	ide_destroy_dmatable	-	clean up DMA mapping
  *	@drive: The drive to unmap
@@ -262,147 +151,30 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
  *	an oops as only one mapping can be live for each target at a given
  *	time.
  */
- 
-void ide_destroy_dmatable (ide_drive_t *drive)
+
+void ide_destroy_dmatable(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
 	dma_unmap_sg(hwif->dev, hwif->sg_table, hwif->sg_nents,
 		     hwif->sg_dma_direction);
 }
-
 EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
-/**
- *	config_drive_for_dma	-	attempt to activate IDE DMA
- *	@drive: the drive to place in DMA mode
- *
- *	If the drive supports at least mode 2 DMA or UDMA of any kind
- *	then attempt to place it into DMA mode. Drives that are known to
- *	support DMA but predate the DMA properties or that are known
- *	to have DMA handling bugs are also set up appropriately based
- *	on the good/bad drive lists.
- */
- 
-static int config_drive_for_dma (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u16 *id = drive->id;
-
-	if (drive->media != ide_disk) {
-		if (hwif->host_flags & IDE_HFLAG_NO_ATAPI_DMA)
-			return 0;
-	}
-
-	/*
-	 * Enable DMA on any drive that has
-	 * UltraDMA (mode 0/1/2/3/4/5/6) enabled
-	 */
-	if ((id[ATA_ID_FIELD_VALID] & 4) &&
-	    ((id[ATA_ID_UDMA_MODES] >> 8) & 0x7f))
-		return 1;
-
-	/*
-	 * Enable DMA on any drive that has mode2 DMA
-	 * (multi or single) enabled
-	 */
-	if (id[ATA_ID_FIELD_VALID] & 2)	/* regular DMA */
-		if ((id[ATA_ID_MWDMA_MODES] & 0x404) == 0x404 ||
-		    (id[ATA_ID_SWDMA_MODES] & 0x404) == 0x404)
-			return 1;
-
-	/* Consult the list of known "good" drives */
-	if (ide_dma_good_drive(drive))
-		return 1;
-
-	return 0;
-}
-
-/**
- *	dma_timer_expiry	-	handle a DMA timeout
- *	@drive: Drive that timed out
- *
- *	An IDE DMA transfer timed out. In the event of an error we ask
- *	the driver to resolve the problem, if a DMA transfer is still
- *	in progress we continue to wait (arguably we need to add a 
- *	secondary 'I don't care what the drive thinks' timeout here)
- *	Finally if we have an interrupt we let it complete the I/O.
- *	But only one time - we clear expiry and if it's still not
- *	completed after WAIT_CMD, we error and retry in PIO.
- *	This can occur if an interrupt is lost or due to hang or bugs.
- */
- 
-static int dma_timer_expiry (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
-
-	printk(KERN_WARNING "%s: dma_timer_expiry: dma status == 0x%02x\n",
-		drive->name, dma_stat);
-
-	if ((dma_stat & 0x18) == 0x18)	/* BUSY Stupid Early Timer !! */
-		return WAIT_CMD;
-
-	HWGROUP(drive)->expiry = NULL;	/* one free ride for now */
-
-	/* 1 dmaing, 2 error, 4 intr */
-	if (dma_stat & 2)	/* ERROR */
-		return -1;
-
-	if (dma_stat & 1)	/* DMAing */
-		return WAIT_CMD;
-
-	if (dma_stat & 4)	/* Got an Interrupt */
-		return WAIT_CMD;
-
-	return 0;	/* Status is unknown -- reset the bus */
-}
-
-/**
- *	ide_dma_host_set	-	Enable/disable DMA on a host
- *	@drive: drive to control
- *
- *	Enable/disable DMA on an IDE controller following generic
- *	bus-mastering IDE controller behaviour.
- */
-
-void ide_dma_host_set(ide_drive_t *drive, int on)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 unit			= (drive->select.b.unit & 0x01);
-	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
-
-	if (on)
-		dma_stat |= (1 << (5 + unit));
-	else
-		dma_stat &= ~(1 << (5 + unit));
-
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writeb(dma_stat,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
-	else
-		outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
-}
-
-EXPORT_SYMBOL_GPL(ide_dma_host_set);
-#endif /* CONFIG_BLK_DEV_IDEDMA_SFF  */
-
 /**
  *	ide_dma_off_quietly	-	Generic DMA kill
  *	@drive: drive to control
  *
- *	Turn off the current DMA on this IDE controller. 
+ *	Turn off the current DMA on this IDE controller.
  */
 
 void ide_dma_off_quietly(ide_drive_t *drive)
 {
-	drive->using_dma = 0;
+	drive->dev_flags &= ~IDE_DFLAG_USING_DMA;
 	ide_toggle_bounce(drive, 0);
 
 	drive->hwif->dma_ops->dma_host_set(drive, 0);
 }
-
 EXPORT_SYMBOL(ide_dma_off_quietly);
 
 /**
@@ -418,7 +190,6 @@ void ide_dma_off(ide_drive_t *drive)
 	printk(KERN_INFO "%s: DMA disabled\n", drive->name);
 	ide_dma_off_quietly(drive);
 }
-
 EXPORT_SYMBOL(ide_dma_off);
 
 /**
@@ -430,167 +201,13 @@ EXPORT_SYMBOL(ide_dma_off);
 
 void ide_dma_on(ide_drive_t *drive)
 {
-	drive->using_dma = 1;
+	drive->dev_flags |= IDE_DFLAG_USING_DMA;
 	ide_toggle_bounce(drive, 1);
 
 	drive->hwif->dma_ops->dma_host_set(drive, 1);
 }
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
-/**
- *	ide_dma_setup	-	begin a DMA phase
- *	@drive: target device
- *
- *	Build an IDE DMA PRD (IDE speak for scatter gather table)
- *	and then set up the DMA transfer registers for a device
- *	that follows generic IDE PCI DMA behaviour. Controllers can
- *	override this function if they need to
- *
- *	Returns 0 on success. If a PIO fallback is required then 1
- *	is returned. 
- */
-
-int ide_dma_setup(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = HWGROUP(drive)->rq;
-	unsigned int reading;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 dma_stat;
-
-	if (rq_data_dir(rq))
-		reading = 0;
-	else
-		reading = 1 << 3;
-
-	/* fall back to pio! */
-	if (!ide_build_dmatable(drive, rq)) {
-		ide_map_sg(drive, rq);
-		return 1;
-	}
-
-	/* PRD table */
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writel(hwif->dmatable_dma,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_TABLE_OFS));
-	else
-		outl(hwif->dmatable_dma, hwif->dma_base + ATA_DMA_TABLE_OFS);
-
-	/* specify r/w */
-	if (mmio)
-		writeb(reading, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-	else
-		outb(reading, hwif->dma_base + ATA_DMA_CMD);
-
-	/* read DMA status for INTR & ERROR flags */
-	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
-
-	/* clear INTR & ERROR flags */
-	if (mmio)
-		writeb(dma_stat | 6,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
-	else
-		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
-
-	drive->waiting_for_dma = 1;
-	return 0;
-}
-
-EXPORT_SYMBOL_GPL(ide_dma_setup);
-
-void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
-{
-	/* issue cmd to drive */
-	ide_execute_command(drive, command, &ide_dma_intr, 2*WAIT_CMD, dma_timer_expiry);
-}
-EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
-
-void ide_dma_start(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 dma_cmd;
-
-	/* Note that this is done *after* the cmd has
-	 * been issued to the drive, as per the BM-IDE spec.
-	 * The Promise Ultra33 doesn't work correctly when
-	 * we do this part before issuing the drive cmd.
-	 */
-	if (hwif->host_flags & IDE_HFLAG_MMIO) {
-		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-		/* start DMA */
-		writeb(dma_cmd | 1,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-	} else {
-		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
-		outb(dma_cmd | 1, hwif->dma_base + ATA_DMA_CMD);
-	}
-
-	hwif->dma = 1;
-	wmb();
-}
-
-EXPORT_SYMBOL_GPL(ide_dma_start);
-
-/* returns 1 on error, 0 otherwise */
-int __ide_dma_end (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 dma_stat = 0, dma_cmd = 0;
-
-	drive->waiting_for_dma = 0;
-
-	if (mmio) {
-		/* get DMA command mode */
-		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-		/* stop DMA */
-		writeb(dma_cmd & ~1,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-	} else {
-		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
-		outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
-	}
-
-	/* get DMA status */
-	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
-
-	if (mmio)
-		/* clear the INTR & ERROR bits */
-		writeb(dma_stat | 6,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
-	else
-		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
-
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
-	/* verify good DMA status */
-	hwif->dma = 0;
-	wmb();
-	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
-}
-
-EXPORT_SYMBOL(__ide_dma_end);
-
-/* returns 1 if dma irq issued, 0 otherwise */
-int ide_dma_test_irq(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
-
-	/* return 1 if INTR asserted */
-	if ((dma_stat & 4) == 4)
-		return 1;
-	if (!drive->waiting_for_dma)
-		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-			drive->name, __func__);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ide_dma_test_irq);
-#else
-static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
-#endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
-
-int __ide_dma_bad_drive (ide_drive_t *drive)
+int __ide_dma_bad_drive(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
 
@@ -602,7 +219,6 @@ int __ide_dma_bad_drive (ide_drive_t *drive)
 	}
 	return 0;
 }
-
 EXPORT_SYMBOL(__ide_dma_bad_drive);
 
 static const u8 xfer_mode_bases[] = {
@@ -618,7 +234,7 @@ static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base, u8 req_mode)
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 	unsigned int mask = 0;
 
-	switch(base) {
+	switch (base) {
 	case XFER_UDMA_0:
 		if ((id[ATA_ID_FIELD_VALID] & 4) == 0)
 			break;
@@ -719,7 +335,6 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 
 	return mode;
 }
-
 EXPORT_SYMBOL_GPL(ide_find_dma_mode);
 
 static int ide_tune_dma(ide_drive_t *drive)
@@ -727,7 +342,8 @@ static int ide_tune_dma(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 speed;
 
-	if (drive->nodma || ata_id_has_dma(drive->id) == 0)
+	if (ata_id_has_dma(drive->id) == 0 ||
+	    (drive->dev_flags & IDE_DFLAG_NODMA))
 		return 0;
 
 	/* consult the list of known "bad" drives */
@@ -827,66 +443,59 @@ void ide_check_dma_crc(ide_drive_t *drive)
 		ide_dma_on(drive);
 }
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
-void ide_dma_lost_irq (ide_drive_t *drive)
+void ide_dma_lost_irq(ide_drive_t *drive)
 {
-	printk("%s: DMA interrupt recovery\n", drive->name);
+	printk(KERN_ERR "%s: DMA interrupt recovery\n", drive->name);
 }
+EXPORT_SYMBOL_GPL(ide_dma_lost_irq);
 
-EXPORT_SYMBOL(ide_dma_lost_irq);
-
-void ide_dma_timeout (ide_drive_t *drive)
+void ide_dma_timeout(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 
 	printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
 
 	if (hwif->dma_ops->dma_test_irq(drive))
 		return;
 
+	ide_dump_status(drive, "DMA timeout", hwif->tp_ops->read_status(hwif));
+
 	hwif->dma_ops->dma_end(drive);
 }
-
-EXPORT_SYMBOL(ide_dma_timeout);
+EXPORT_SYMBOL_GPL(ide_dma_timeout);
 
 void ide_release_dma_engine(ide_hwif_t *hwif)
 {
 	if (hwif->dmatable_cpu) {
-		struct pci_dev *pdev = to_pci_dev(hwif->dev);
+		int prd_size = hwif->prd_max_nents * hwif->prd_ent_size;
 
-		pci_free_consistent(pdev, PRD_ENTRIES * PRD_BYTES,
-				    hwif->dmatable_cpu, hwif->dmatable_dma);
+		dma_free_coherent(hwif->dev, prd_size,
+				  hwif->dmatable_cpu, hwif->dmatable_dma);
 		hwif->dmatable_cpu = NULL;
 	}
 }
+EXPORT_SYMBOL_GPL(ide_release_dma_engine);
 
 int ide_allocate_dma_engine(ide_hwif_t *hwif)
 {
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
+	int prd_size;
 
-	hwif->dmatable_cpu = pci_alloc_consistent(pdev,
-						  PRD_ENTRIES * PRD_BYTES,
-						  &hwif->dmatable_dma);
+	if (hwif->prd_max_nents == 0)
+		hwif->prd_max_nents = PRD_ENTRIES;
+	if (hwif->prd_ent_size == 0)
+		hwif->prd_ent_size = PRD_BYTES;
 
-	if (hwif->dmatable_cpu)
-		return 0;
+	prd_size = hwif->prd_max_nents * hwif->prd_ent_size;
 
-	printk(KERN_ERR "%s: -- Error, unable to allocate DMA table.\n",
+	hwif->dmatable_cpu = dma_alloc_coherent(hwif->dev, prd_size,
+						&hwif->dmatable_dma,
+						GFP_ATOMIC);
+	if (hwif->dmatable_cpu == NULL) {
+		printk(KERN_ERR "%s: unable to allocate PRD table\n",
 			hwif->name);
+		return -ENOMEM;
+	}
 
-	return 1;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
-
-const struct ide_dma_ops sff_dma_ops = {
-	.dma_host_set		= ide_dma_host_set,
-	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
-	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
-	.dma_test_irq		= ide_dma_test_irq,
-	.dma_timeout		= ide_dma_timeout,
-	.dma_lost_irq		= ide_dma_lost_irq,
-};
-EXPORT_SYMBOL_GPL(sff_dma_ops);
-#endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index d36f155..cf0aa25 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -16,6 +16,7 @@
  */
 
 #define DRV_NAME "ide-floppy"
+#define PFX DRV_NAME ": "
 
 #define IDEFLOPPY_VERSION "1.00"
 
@@ -48,17 +49,17 @@
 
 #include "ide-floppy.h"
 
-/* define to see debug info */
-#define IDEFLOPPY_DEBUG_LOG		0
+/* module parameters */
+static unsigned long debug_mask;
+module_param(debug_mask, ulong, 0644);
 
-/* #define IDEFLOPPY_DEBUG(fmt, args...) printk(KERN_INFO fmt, ## args) */
-#define IDEFLOPPY_DEBUG(fmt, args...)
+/* define to see debug info */
+#define IDEFLOPPY_DEBUG_LOG	0
 
 #if IDEFLOPPY_DEBUG_LOG
-#define debug_log(fmt, args...) \
-	printk(KERN_INFO "ide-floppy: " fmt, ## args)
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
 #else
-#define debug_log(fmt, args...) do {} while (0)
+#define ide_debug_log(lvl, fmt, args...) do {} while (0)
 #endif
 
 /*
@@ -73,18 +74,17 @@
 #define CAPACITY_CURRENT	0x02
 #define CAPACITY_NO_CARTRIDGE	0x03
 
-#define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
+/*
+ * The following delay solves a problem with ATAPI Zip 100 drive where BSY bit
+ * was apparently being deasserted before the unit was ready to receive data.
+ */
+#define IDEFLOPPY_PC_DELAY	(HZ/20)	/* default delay for ZIP 100 (50ms) */
 
 /* Error code returned in rq->errors to the higher part of the driver. */
 #define	IDEFLOPPY_ERROR_GENERAL		101
 
 static DEFINE_MUTEX(idefloppy_ref_mutex);
 
-#define to_ide_floppy(obj) container_of(obj, struct ide_floppy_obj, kref)
-
-#define ide_floppy_g(disk) \
-	container_of((disk)->private_data, struct ide_floppy_obj, driver)
-
 static void idefloppy_cleanup_obj(struct kref *);
 
 static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
@@ -92,7 +92,7 @@ static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
 	struct ide_floppy_obj *floppy = NULL;
 
 	mutex_lock(&idefloppy_ref_mutex);
-	floppy = ide_floppy_g(disk);
+	floppy = ide_drv_g(disk, ide_floppy_obj);
 	if (floppy) {
 		if (ide_device_get(floppy->drive))
 			floppy = NULL;
@@ -123,13 +123,21 @@ static int idefloppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	struct request *rq = HWGROUP(drive)->rq;
 	int error;
 
-	debug_log("Reached %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
 	switch (uptodate) {
-	case 0: error = IDEFLOPPY_ERROR_GENERAL; break;
-	case 1: error = 0; break;
-	default: error = uptodate;
+	case 0:
+		error = IDEFLOPPY_ERROR_GENERAL;
+		break;
+
+	case 1:
+		error = 0;
+		break;
+
+	default:
+		error = uptodate;
 	}
+
 	if (error)
 		floppy->failed_pc = NULL;
 	/* Why does this happen? */
@@ -156,13 +164,13 @@ static void idefloppy_update_buffers(ide_drive_t *drive,
 		idefloppy_end_request(drive, 1, 0);
 }
 
-static void ide_floppy_callback(ide_drive_t *drive)
+static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct ide_atapi_pc *pc = floppy->pc;
+	struct ide_atapi_pc *pc = drive->pc;
 	int uptodate = pc->error ? 0 : 1;
 
-	debug_log("Reached %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
 	if (floppy->failed_pc == pc)
 		floppy->failed_pc = NULL;
@@ -171,7 +179,7 @@ static void ide_floppy_callback(ide_drive_t *drive)
 	    (pc->rq && blk_pc_request(pc->rq)))
 		uptodate = 1; /* FIXME */
 	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
-		u8 *buf = floppy->pc->buf;
+		u8 *buf = pc->buf;
 
 		if (!pc->error) {
 			floppy->sense_key = buf[2] & 0x0F;
@@ -181,99 +189,20 @@ static void ide_floppy_callback(ide_drive_t *drive)
 				(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
 
 			if (floppy->failed_pc)
-				debug_log("pc = %x, ", floppy->failed_pc->c[0]);
+				ide_debug_log(IDE_DBG_PC, "pc = %x, ",
+					      floppy->failed_pc->c[0]);
 
-			debug_log("sense key = %x, asc = %x, ascq = %x\n",
-				  floppy->sense_key, floppy->asc, floppy->ascq);
+			ide_debug_log(IDE_DBG_SENSE, "sense key = %x, asc = %x,"
+				      "ascq = %x\n", floppy->sense_key,
+				      floppy->asc, floppy->ascq);
 		} else
-			printk(KERN_ERR "Error in REQUEST SENSE itself - "
-					"Aborting request!\n");
+			printk(KERN_ERR PFX "Error in REQUEST SENSE itself - "
+			       "Aborting request!\n");
 	}
 
 	idefloppy_end_request(drive, uptodate, 0);
 }
 
-void ide_floppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
-{
-	ide_init_pc(pc);
-	pc->c[0] = GPCMD_REQUEST_SENSE;
-	pc->c[4] = 255;
-	pc->req_xfer = 18;
-}
-
-/*
- * Called when an error was detected during the last packet command. We queue a
- * request sense packet command in the head of the request list.
- */
-static void idefloppy_retry_pc(ide_drive_t *drive)
-{
-	struct ide_floppy_obj *floppy = drive->driver_data;
-	struct request *rq = &floppy->request_sense_rq;
-	struct ide_atapi_pc *pc = &floppy->request_sense_pc;
-
-	(void)ide_read_error(drive);
-	ide_floppy_create_request_sense_cmd(pc);
-	ide_queue_pc_head(drive, floppy->disk, pc, rq);
-}
-
-/* The usual interrupt handler called during a packet command. */
-static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-
-	return ide_pc_intr(drive, floppy->pc, idefloppy_pc_intr,
-			   WAIT_FLOPPY_CMD, NULL, idefloppy_update_buffers,
-			   idefloppy_retry_pc, NULL, ide_io_buffers);
-}
-
-/*
- * What we have here is a classic case of a top half / bottom half interrupt
- * service routine. In interrupt mode, the device sends an interrupt to signal
- * that it is ready to receive a packet. However, we need to delay about 2-3
- * ticks before issuing the packet or we gets in trouble.
- */
-static int idefloppy_transfer_pc(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-
-	/* Send the actual packet */
-	drive->hwif->tp_ops->output_data(drive, NULL, floppy->pc->c, 12);
-
-	/* Timeout for the packet command */
-	return WAIT_FLOPPY_CMD;
-}
-
-/*
- * Called as an interrupt (or directly). When the device says it's ready for a
- * packet, we schedule the packet transfer to occur about 2-3 ticks later in
- * transfer_pc.
- */
-static ide_startstop_t idefloppy_start_pc_transfer(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct ide_atapi_pc *pc = floppy->pc;
-	ide_expiry_t *expiry;
-	unsigned int timeout;
-
-	/*
-	 * The following delay solves a problem with ATAPI Zip 100 drives
-	 * where the Busy flag was apparently being deasserted before the
-	 * unit was ready to receive data. This was happening on a
-	 * 1200 MHz Athlon system. 10/26/01 25msec is too short,
-	 * 40 and 50msec work well. idefloppy_pc_intr will not be actually
-	 * used until after the packet is moved in about 50 msec.
-	 */
-	if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
-		timeout = floppy->ticks;
-		expiry = &idefloppy_transfer_pc;
-	} else {
-		timeout = WAIT_FLOPPY_CMD;
-		expiry = NULL;
-	}
-
-	return ide_transfer_pc(drive, pc, idefloppy_pc_intr, timeout, expiry);
-}
-
 static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
 				    struct ide_atapi_pc *pc)
 {
@@ -283,7 +212,7 @@ static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
 	    floppy->ascq      == 0x00)
 		return;
 
-	printk(KERN_ERR "ide-floppy: %s: I/O error, pc = %2x, key = %2x, "
+	printk(KERN_ERR PFX "%s: I/O error, pc = %2x, key = %2x, "
 			"asc = %2x, ascq = %2x\n",
 			floppy->drive->name, pc->c[0], floppy->sense_key,
 			floppy->asc, floppy->ascq);
@@ -298,8 +227,9 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 	if (floppy->failed_pc == NULL &&
 	    pc->c[0] != GPCMD_REQUEST_SENSE)
 		floppy->failed_pc = pc;
+
 	/* Set the current packet command */
-	floppy->pc = pc;
+	drive->pc = pc;
 
 	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES) {
 		if (!(pc->flags & PC_FLAG_SUPPRESS_ERROR))
@@ -308,16 +238,15 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
 
 		floppy->failed_pc = NULL;
-		drive->pc_callback(drive);
+		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
 
-	debug_log("Retry number - %d\n", pc->retries);
+	ide_debug_log(IDE_DBG_FUNC, "%s: Retry #%d\n", __func__, pc->retries);
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, pc, idefloppy_start_pc_transfer,
-			    WAIT_FLOPPY_CMD, NULL);
+	return ide_issue_pc(drive, WAIT_FLOPPY_CMD, NULL);
 }
 
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
@@ -347,23 +276,23 @@ void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 		length += 32;
 		break;
 	default:
-		printk(KERN_ERR "ide-floppy: unsupported page code "
-				"in create_mode_sense_cmd\n");
+		printk(KERN_ERR PFX "unsupported page code in %s\n", __func__);
 	}
 	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
 	pc->req_xfer = length;
 }
 
-static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
+static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 				    struct ide_atapi_pc *pc, struct request *rq,
 				    unsigned long sector)
 {
+	idefloppy_floppy_t *floppy = drive->driver_data;
 	int block = sector / floppy->bs_factor;
 	int blocks = rq->nr_sectors / floppy->bs_factor;
 	int cmd = rq_data_dir(rq);
 
-	debug_log("create_rw10_cmd: block == %d, blocks == %d\n",
-		block, blocks);
+	ide_debug_log(IDE_DBG_FUNC, "%s: block: %d, blocks: %d\n", __func__,
+		      block, blocks);
 
 	ide_init_pc(pc);
 	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
@@ -408,41 +337,42 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 	struct ide_atapi_pc *pc;
 	unsigned long block = (unsigned long)block_s;
 
-	debug_log("%s: dev: %s, cmd: 0x%x, cmd_type: %x, errors: %d\n",
-		  __func__, rq->rq_disk ? rq->rq_disk->disk_name : "?",
-		  rq->cmd[0], rq->cmd_type, rq->errors);
+	ide_debug_log(IDE_DBG_FUNC, "%s: dev: %s, cmd: 0x%x, cmd_type: %x, "
+		      "errors: %d\n",
+		      __func__, rq->rq_disk ? rq->rq_disk->disk_name : "?",
+		      rq->cmd[0], rq->cmd_type, rq->errors);
 
-	debug_log("%s: sector: %ld, nr_sectors: %ld, current_nr_sectors: %d\n",
-		  __func__, (long)rq->sector, rq->nr_sectors,
-		  rq->current_nr_sectors);
+	ide_debug_log(IDE_DBG_FUNC, "%s: sector: %ld, nr_sectors: %ld, "
+		      "current_nr_sectors: %d\n",
+		      __func__, (long)rq->sector, rq->nr_sectors,
+		      rq->current_nr_sectors);
 
 	if (rq->errors >= ERROR_MAX) {
 		if (floppy->failed_pc)
 			ide_floppy_report_error(floppy, floppy->failed_pc);
 		else
-			printk(KERN_ERR "ide-floppy: %s: I/O error\n",
-				drive->name);
+			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
+
 		idefloppy_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
 	if (blk_fs_request(rq)) {
 		if (((long)rq->sector % floppy->bs_factor) ||
 		    (rq->nr_sectors % floppy->bs_factor)) {
-			printk(KERN_ERR "%s: unsupported r/w request size\n",
-					drive->name);
+			printk(KERN_ERR PFX "%s: unsupported r/w rq size\n",
+				drive->name);
 			idefloppy_end_request(drive, 0, 0);
 			return ide_stopped;
 		}
 		pc = &floppy->queued_pc;
-		idefloppy_create_rw_cmd(floppy, pc, rq, block);
+		idefloppy_create_rw_cmd(drive, pc, rq, block);
 	} else if (blk_special_request(rq)) {
 		pc = (struct ide_atapi_pc *) rq->buffer;
 	} else if (blk_pc_request(rq)) {
 		pc = &floppy->queued_pc;
 		idefloppy_blockpc_cmd(floppy, pc, rq);
 	} else {
-		blk_dump_rq_flags(rq,
-			"ide-floppy: unsupported command in queue");
+		blk_dump_rq_flags(rq, PFX "unsupported command in queue");
 		idefloppy_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
@@ -475,8 +405,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 	ide_floppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
-		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
-				" parameters\n");
+		printk(KERN_ERR PFX "Can't get flexible disk page params\n");
 		return 1;
 	}
 
@@ -499,7 +428,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 	capacity = cyls * heads * sectors * sector_size;
 
 	if (memcmp(page, &floppy->flexible_disk_page, 32))
-		printk(KERN_INFO "%s: %dkB, %d/%d/%d CHS, %d kBps, "
+		printk(KERN_INFO PFX "%s: %dkB, %d/%d/%d CHS, %d kBps, "
 				"%d sector size, %d rpm\n",
 				drive->name, capacity / 1024, cyls, heads,
 				sectors, transfer_rate / 8, sector_size, rpm);
@@ -511,7 +440,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 	lba_capacity = floppy->blocks * floppy->block_size;
 
 	if (capacity < lba_capacity) {
-		printk(KERN_NOTICE "%s: The disk reports a capacity of %d "
+		printk(KERN_NOTICE PFX "%s: The disk reports a capacity of %d "
 			"bytes, but the drive only handles %d\n",
 			drive->name, lba_capacity, capacity);
 		floppy->blocks = floppy->block_size ?
@@ -541,7 +470,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 
 	ide_floppy_create_read_capacity_cmd(&pc);
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
-		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
+		printk(KERN_ERR PFX "Can't get floppy parameters\n");
 		return 1;
 	}
 	header_len = pc.buf[3];
@@ -554,8 +483,9 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
 		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
 
-		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
-				i, blocks * length / 1024, blocks, length);
+		ide_debug_log(IDE_DBG_PROBE, "Descriptor %d: %dkB, %d blocks, "
+			      "%d sector size\n",
+			      i, blocks * length / 1024, blocks, length);
 
 		if (i)
 			continue;
@@ -575,23 +505,24 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		case CAPACITY_CURRENT:
 			/* Normal Zip/LS-120 disks */
 			if (memcmp(cap_desc, &floppy->cap_desc, 8))
-				printk(KERN_INFO "%s: %dkB, %d blocks, %d "
-					"sector size\n", drive->name,
-					blocks * length / 1024, blocks, length);
+				printk(KERN_INFO PFX "%s: %dkB, %d blocks, %d "
+				       "sector size\n",
+				       drive->name, blocks * length / 1024,
+				       blocks, length);
 			memcpy(&floppy->cap_desc, cap_desc, 8);
 
 			if (!length || length % 512) {
-				printk(KERN_NOTICE "%s: %d bytes block size "
-					"not supported\n", drive->name, length);
+				printk(KERN_NOTICE PFX "%s: %d bytes block size"
+				       " not supported\n", drive->name, length);
 			} else {
 				floppy->blocks = blocks;
 				floppy->block_size = length;
 				floppy->bs_factor = length / 512;
 				if (floppy->bs_factor != 1)
-					printk(KERN_NOTICE "%s: warning: non "
-						"512 bytes block size not "
-						"fully supported\n",
-						drive->name);
+					printk(KERN_NOTICE PFX "%s: Warning: "
+					       "non 512 bytes block size not "
+					       "fully supported\n",
+					       drive->name);
 				rc = 0;
 			}
 			break;
@@ -600,15 +531,16 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 			 * This is a KERN_ERR so it appears on screen
 			 * for the user to see
 			 */
-			printk(KERN_ERR "%s: No disk in drive\n", drive->name);
+			printk(KERN_ERR PFX "%s: No disk in drive\n",
+			       drive->name);
 			break;
 		case CAPACITY_INVALID:
-			printk(KERN_ERR "%s: Invalid capacity for disk "
+			printk(KERN_ERR PFX "%s: Invalid capacity for disk "
 				"in drive\n", drive->name);
 			break;
 		}
-		debug_log("Descriptor 0 Code: %d\n",
-			  pc.buf[desc_start + 4] & 0x03);
+		ide_debug_log(IDE_DBG_PROBE, "Descriptor 0 Code: %d\n",
+			      pc.buf[desc_start + 4] & 0x03);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
@@ -620,7 +552,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	return rc;
 }
 
-static sector_t idefloppy_capacity(ide_drive_t *drive)
+sector_t ide_floppy_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	unsigned long capacity = floppy->blocks * floppy->bs_factor;
@@ -628,46 +560,14 @@ static sector_t idefloppy_capacity(ide_drive_t *drive)
 	return capacity;
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-ide_devset_rw_field(bios_cyl, bios_cyl);
-ide_devset_rw_field(bios_head, bios_head);
-ide_devset_rw_field(bios_sect, bios_sect);
-
-static int get_ticks(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	return floppy->ticks;
-}
-
-static int set_ticks(ide_drive_t *drive, int arg)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	floppy->ticks = arg;
-	return 0;
-}
-
-IDE_DEVSET(ticks, DS_SYNC, get_ticks, set_ticks);
-
-static const struct ide_proc_devset idefloppy_settings[] = {
-	IDE_PROC_DEVSET(bios_cyl,  0, 1023),
-	IDE_PROC_DEVSET(bios_head, 0,  255),
-	IDE_PROC_DEVSET(bios_sect, 0,   63),
-	IDE_PROC_DEVSET(ticks,	   0,  255),
-	{ 0 },
-};
-#endif
-
 static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 {
 	u16 *id = drive->id;
-	u8 gcw[2];
-
-	*((u16 *)&gcw) = id[ATA_ID_CONFIG];
 
-	drive->pc_callback = ide_floppy_callback;
+	drive->pc_callback	 = ide_floppy_callback;
+	drive->pc_update_buffers = idefloppy_update_buffers;
+	drive->pc_io_buffers	 = ide_io_buffers;
 
-	if (((gcw[0] & 0x60) >> 5) == 1)
-		drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
 	/*
 	 * We used to check revisions here. At this point however I'm giving up.
 	 * Just assume they are all broken, its easier.
@@ -680,7 +580,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	if (!strncmp((char *)&id[ATA_ID_PROD], "IOMEGA ZIP 100 ATAPI", 20)) {
 		drive->atapi_flags |= IDE_AFLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
-		floppy->ticks = IDEFLOPPY_TICKS_DELAY;
+		drive->pc_delay = IDEFLOPPY_PC_DELAY;
 		blk_queue_max_sectors(drive->queue, 64);
 	}
 
@@ -714,7 +614,7 @@ static void ide_floppy_remove(ide_drive_t *drive)
 
 static void idefloppy_cleanup_obj(struct kref *kref)
 {
-	struct ide_floppy_obj *floppy = to_ide_floppy(kref);
+	struct ide_floppy_obj *floppy = to_ide_drv(kref, ide_floppy_obj);
 	ide_drive_t *drive = floppy->drive;
 	struct gendisk *g = floppy->disk;
 
@@ -724,24 +624,6 @@ static void idefloppy_cleanup_obj(struct kref *kref)
 	kfree(floppy);
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-static int proc_idefloppy_read_capacity(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
-{
-	ide_drive_t*drive = (ide_drive_t *)data;
-	int len;
-
-	len = sprintf(page, "%llu\n", (long long)idefloppy_capacity(drive));
-	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
-}
-
-static ide_proc_entry_t idefloppy_proc[] = {
-	{ "capacity",	S_IFREG|S_IRUGO, proc_idefloppy_read_capacity,	NULL },
-	{ "geometry",	S_IFREG|S_IRUGO, proc_ide_read_geometry,	NULL },
-	{ NULL, 0, NULL, NULL }
-};
-#endif	/* CONFIG_IDE_PROC_FS */
-
 static int ide_floppy_probe(ide_drive_t *);
 
 static ide_driver_t idefloppy_driver = {
@@ -753,13 +635,12 @@ static ide_driver_t idefloppy_driver = {
 	.probe			= ide_floppy_probe,
 	.remove			= ide_floppy_remove,
 	.version		= IDEFLOPPY_VERSION,
-	.media			= ide_floppy,
 	.do_request		= idefloppy_do_request,
 	.end_request		= idefloppy_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
-	.proc			= idefloppy_proc,
-	.settings		= idefloppy_settings,
+	.proc			= ide_floppy_proc,
+	.settings		= ide_floppy_settings,
 #endif
 };
 
@@ -770,14 +651,14 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	ide_drive_t *drive;
 	int ret = 0;
 
-	debug_log("Reached %s\n", __func__);
-
 	floppy = ide_floppy_get(disk);
 	if (!floppy)
 		return -ENXIO;
 
 	drive = floppy->drive;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	floppy->openers++;
 
 	if (floppy->openers == 1) {
@@ -822,10 +703,10 @@ out_put_floppy:
 static int idefloppy_release(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
+	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
 	ide_drive_t *drive = floppy->drive;
 
-	debug_log("Reached %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
 	if (floppy->openers == 1) {
 		ide_set_media_lock(drive, disk, 0);
@@ -841,7 +722,8 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 
 static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
-	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
+	struct ide_floppy_obj *floppy = ide_drv_g(bdev->bd_disk,
+						     ide_floppy_obj);
 	ide_drive_t *drive = floppy->drive;
 
 	geo->heads = drive->bios_head;
@@ -850,64 +732,15 @@ static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static int ide_floppy_lockdoor(ide_drive_t *drive, struct ide_atapi_pc *pc,
-			       unsigned long arg, unsigned int cmd)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct gendisk *disk = floppy->disk;
-	int prevent = (arg && cmd != CDROMEJECT) ? 1 : 0;
-
-	if (floppy->openers > 1)
-		return -EBUSY;
-
-	ide_set_media_lock(drive, disk, prevent);
-
-	if (cmd == CDROMEJECT)
-		ide_do_start_stop(drive, disk, 2);
-
-	return 0;
-}
-
-static int idefloppy_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
-{
-	struct block_device *bdev = inode->i_bdev;
-	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
-	ide_drive_t *drive = floppy->drive;
-	struct ide_atapi_pc pc;
-	void __user *argp = (void __user *)arg;
-	int err;
-
-	if (cmd == CDROMEJECT || cmd == CDROM_LOCKDOOR)
-		return ide_floppy_lockdoor(drive, &pc, arg, cmd);
-
-	err = ide_floppy_format_ioctl(drive, file, cmd, argp);
-	if (err != -ENOTTY)
-		return err;
-
-	/*
-	 * skip SCSI_IOCTL_SEND_COMMAND (deprecated)
-	 * and CDROM_SEND_PACKET (legacy) ioctls
-	 */
-	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
-		err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
-					bdev->bd_disk, cmd, argp);
-
-	if (err == -ENOTTY)
-		err = generic_ide_ioctl(drive, file, bdev, cmd, arg);
-
-	return err;
-}
-
 static int idefloppy_media_changed(struct gendisk *disk)
 {
-	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
+	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
 	ide_drive_t *drive = floppy->drive;
 	int ret;
 
 	/* do not scan partitions twice if this is a removable device */
-	if (drive->attach) {
-		drive->attach = 0;
+	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
+		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
 		return 0;
 	}
 	ret = !!(drive->atapi_flags & IDE_AFLAG_MEDIA_CHANGED);
@@ -917,8 +750,8 @@ static int idefloppy_media_changed(struct gendisk *disk)
 
 static int idefloppy_revalidate_disk(struct gendisk *disk)
 {
-	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
-	set_capacity(disk, idefloppy_capacity(floppy->drive));
+	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
+	set_capacity(disk, ide_floppy_capacity(floppy->drive));
 	return 0;
 }
 
@@ -926,7 +759,7 @@ static struct block_device_operations idefloppy_ops = {
 	.owner			= THIS_MODULE,
 	.open			= idefloppy_open,
 	.release		= idefloppy_release,
-	.ioctl			= idefloppy_ioctl,
+	.ioctl			= ide_floppy_ioctl,
 	.getgeo			= idefloppy_getgeo,
 	.media_changed		= idefloppy_media_changed,
 	.revalidate_disk	= idefloppy_revalidate_disk
@@ -944,14 +777,14 @@ static int ide_floppy_probe(ide_drive_t *drive)
 		goto failed;
 
 	if (!ide_check_atapi_device(drive, DRV_NAME)) {
-		printk(KERN_ERR "ide-floppy: %s: not supported by this version"
-				" of ide-floppy\n", drive->name);
+		printk(KERN_ERR PFX "%s: not supported by this version of "
+		       DRV_NAME "\n", drive->name);
 		goto failed;
 	}
 	floppy = kzalloc(sizeof(idefloppy_floppy_t), GFP_KERNEL);
 	if (!floppy) {
-		printk(KERN_ERR "ide-floppy: %s: Can't allocate a floppy"
-				" structure\n", drive->name);
+		printk(KERN_ERR PFX "%s: Can't allocate a floppy structure\n",
+		       drive->name);
 		goto failed;
 	}
 
@@ -971,13 +804,16 @@ static int ide_floppy_probe(ide_drive_t *drive)
 
 	drive->driver_data = floppy;
 
+	drive->debug_mask = debug_mask;
+
 	idefloppy_setup(drive, floppy);
+	drive->dev_flags |= IDE_DFLAG_ATTACH;
 
 	g->minors = 1 << PARTN_BITS;
 	g->driverfs_dev = &drive->gendev;
-	g->flags = drive->removable ? GENHD_FL_REMOVABLE : 0;
+	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
+		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &idefloppy_ops;
-	drive->attach = 1;
 	add_disk(g);
 	return 0;
 
@@ -994,7 +830,7 @@ static void __exit idefloppy_exit(void)
 
 static int __init idefloppy_init(void)
 {
-	printk("ide-floppy driver " IDEFLOPPY_VERSION "\n");
+	printk(KERN_INFO DRV_NAME " driver " IDEFLOPPY_VERSION "\n");
 	return driver_register(&idefloppy_driver.gen_driver);
 }
 
diff --git a/drivers/ide/ide-floppy.h b/drivers/ide/ide-floppy.h
index ecadc2b..17cf865 100644
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -13,20 +13,14 @@ typedef struct ide_floppy_obj {
 	struct kref	kref;
 	unsigned int	openers;	/* protected by BKL for now */
 
-	/* Current packet command */
-	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
 	struct ide_atapi_pc *failed_pc;
 	/* used for blk_{fs,pc}_request() requests */
 	struct ide_atapi_pc queued_pc;
 
-	struct ide_atapi_pc request_sense_pc;
-	struct request request_sense_rq;
-
 	/* Last error information */
 	u8 sense_key, asc, ascq;
-	/* delay this long before sending packet command */
-	u8 ticks;
+
 	int progress_indication;
 
 	/* Device information */
@@ -54,10 +48,15 @@ typedef struct ide_floppy_obj {
 /* ide-floppy.c */
 void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *, u8);
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *);
-void ide_floppy_create_request_sense_cmd(struct ide_atapi_pc *);
+sector_t ide_floppy_capacity(ide_drive_t *);
 
 /* ide-floppy_ioctl.c */
-int ide_floppy_format_ioctl(ide_drive_t *, struct file *, unsigned int,
-			    void __user *);
+int ide_floppy_ioctl(struct inode *, struct file *, unsigned, unsigned long);
+
+#ifdef CONFIG_IDE_PROC_FS
+/* ide-floppy_proc.c */
+extern ide_proc_entry_t ide_floppy_proc[];
+extern const struct ide_proc_devset ide_floppy_settings[];
+#endif
 
 #endif /*__IDE_FLOPPY_H */
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 5ffc451..a3a7a08 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -195,7 +195,7 @@ static int ide_floppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 	int progress_indication = 0x10000;
 
 	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
-		ide_floppy_create_request_sense_cmd(&pc);
+		ide_create_request_sense_cmd(drive, &pc);
 		if (ide_queue_pc_tail(drive, floppy->disk, &pc))
 			return -EIO;
 
@@ -223,8 +223,26 @@ static int ide_floppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 	return 0;
 }
 
-int ide_floppy_format_ioctl(ide_drive_t *drive, struct file *file,
-			    unsigned int cmd, void __user *argp)
+static int ide_floppy_lockdoor(ide_drive_t *drive, struct ide_atapi_pc *pc,
+			       unsigned long arg, unsigned int cmd)
+{
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct gendisk *disk = floppy->disk;
+	int prevent = (arg && cmd != CDROMEJECT) ? 1 : 0;
+
+	if (floppy->openers > 1)
+		return -EBUSY;
+
+	ide_set_media_lock(drive, disk, prevent);
+
+	if (cmd == CDROMEJECT)
+		ide_do_start_stop(drive, disk, 2);
+
+	return 0;
+}
+
+static int ide_floppy_format_ioctl(ide_drive_t *drive, struct file *file,
+				   unsigned int cmd, void __user *argp)
 {
 	switch (cmd) {
 	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
@@ -241,3 +259,35 @@ int ide_floppy_format_ioctl(ide_drive_t *drive, struct file *file,
 		return -ENOTTY;
 	}
 }
+
+int ide_floppy_ioctl(struct inode *inode, struct file *file,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct block_device *bdev = inode->i_bdev;
+	struct ide_floppy_obj *floppy = ide_drv_g(bdev->bd_disk,
+						     ide_floppy_obj);
+	ide_drive_t *drive = floppy->drive;
+	struct ide_atapi_pc pc;
+	void __user *argp = (void __user *)arg;
+	int err;
+
+	if (cmd == CDROMEJECT || cmd == CDROM_LOCKDOOR)
+		return ide_floppy_lockdoor(drive, &pc, arg, cmd);
+
+	err = ide_floppy_format_ioctl(drive, file, cmd, argp);
+	if (err != -ENOTTY)
+		return err;
+
+	/*
+	 * skip SCSI_IOCTL_SEND_COMMAND (deprecated)
+	 * and CDROM_SEND_PACKET (legacy) ioctls
+	 */
+	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
+		err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
+					bdev->bd_disk, cmd, argp);
+
+	if (err == -ENOTTY)
+		err = generic_ide_ioctl(drive, file, bdev, cmd, arg);
+
+	return err;
+}
diff --git a/drivers/ide/ide-floppy_proc.c b/drivers/ide/ide-floppy_proc.c
new file mode 100644
index 0000000..76f0c6c
--- /dev/null
+++ b/drivers/ide/ide-floppy_proc.c
@@ -0,0 +1,33 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+
+#include "ide-floppy.h"
+
+static int proc_idefloppy_read_capacity(char *page, char **start, off_t off,
+		int count, int *eof, void *data)
+{
+	ide_drive_t*drive = (ide_drive_t *)data;
+	int len;
+
+	len = sprintf(page, "%llu\n", (long long)ide_floppy_capacity(drive));
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
+}
+
+ide_proc_entry_t ide_floppy_proc[] = {
+	{ "capacity",	S_IFREG|S_IRUGO, proc_idefloppy_read_capacity,	NULL },
+	{ "geometry",	S_IFREG|S_IRUGO, proc_ide_read_geometry,	NULL },
+	{ NULL, 0, NULL, NULL }
+};
+
+ide_devset_rw_field(bios_cyl, bios_cyl);
+ide_devset_rw_field(bios_head, bios_head);
+ide_devset_rw_field(bios_sect, bios_sect);
+ide_devset_rw_field(ticks, pc_delay);
+
+const struct ide_proc_devset ide_floppy_settings[] = {
+	IDE_PROC_DEVSET(bios_cyl,  0, 1023),
+	IDE_PROC_DEVSET(bios_head, 0,  255),
+	IDE_PROC_DEVSET(bios_sect, 0,   63),
+	IDE_PROC_DEVSET(ticks,	   0,  255),
+	{ 0 },
+};
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 0a3cb0c..81a5282 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -137,15 +137,10 @@ static void ide_generic_check_pci_legacy_iobases(int *primary, int *secondary)
 
 static int __init ide_generic_init(void)
 {
-	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
-	struct ide_host *host;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	unsigned long io_addr;
-	int i, rc, primary = 0, secondary = 0;
+	int i, rc = 0, primary = 0, secondary = 0;
 
-#ifdef CONFIG_MIPS
-	if (!ide_probe_legacy())
-		return -ENODEV;
-#endif
 	ide_generic_check_pci_legacy_iobases(&primary, &secondary);
 
 	if (!probe_mask) {
@@ -161,13 +156,9 @@ static int __init ide_generic_init(void)
 		printk(KERN_INFO DRV_NAME ": enforcing probing of I/O ports "
 			"upon user request\n");
 
-	memset(hws, 0, sizeof(hw_regs_t *) * MAX_HWIFS);
-
 	for (i = 0; i < ARRAY_SIZE(legacy_bases); i++) {
 		io_addr = legacy_bases[i];
 
-		hws[i] = NULL;
-
 		if ((probe_mask & (1 << i)) && io_addr) {
 			if (!request_region(io_addr, 8, DRV_NAME)) {
 				printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX "
@@ -184,45 +175,27 @@ static int __init ide_generic_init(void)
 				continue;
 			}
 
-			memset(&hw[i], 0, sizeof(hw[i]));
-			ide_std_init_ports(&hw[i], io_addr, io_addr + 0x206);
+			memset(&hw, 0, sizeof(hw));
+			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
 #ifdef CONFIG_IA64
-			hw[i].irq = isa_irq_to_vector(legacy_irqs[i]);
+			hw.irq = isa_irq_to_vector(legacy_irqs[i]);
 #else
-			hw[i].irq = legacy_irqs[i];
+			hw.irq = legacy_irqs[i];
 #endif
-			hw[i].chipset = ide_generic;
+			hw.chipset = ide_generic;
 
-			hws[i] = &hw[i];
+			rc = ide_host_add(NULL, hws, NULL);
+			if (rc) {
+				release_region(io_addr + 0x206, 1);
+				release_region(io_addr, 8);
+			}
 		}
 	}
 
-	host = ide_host_alloc_all(NULL, hws);
-	if (host == NULL) {
-		rc = -ENOMEM;
-		goto err;
-	}
-
-	rc = ide_host_register(host, NULL, hws);
-	if (rc)
-		goto err_free;
-
 	if (ide_generic_sysfs_init())
 		printk(KERN_ERR DRV_NAME ": failed to create ide_generic "
 					 "class\n");
 
-	return 0;
-err_free:
-	ide_host_free(host);
-err:
-	for (i = 0; i < MAX_HWIFS; i++) {
-		if (hws[i] == NULL)
-			continue;
-
-		io_addr = hws[i]->io_ports.data_addr;
-		release_region(io_addr + 0x206, 1);
-		release_region(io_addr, 8);
-	}
 	return rc;
 }
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 1c51949..77c6eae 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -78,8 +78,9 @@ static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 	 * decide whether to reenable DMA -- 3 is a random magic for now,
 	 * if we DMA timeout more than 3 times, just stay in PIO
 	 */
-	if (drive->state == DMA_PIO_RETRY && drive->retry_pio <= 3) {
-		drive->state = 0;
+	if ((drive->dev_flags & IDE_DFLAG_DMA_PIO_RETRY) &&
+	    drive->retry_pio <= 3) {
+		drive->dev_flags &= ~IDE_DFLAG_DMA_PIO_RETRY;
 		ide_dma_on(drive);
 	}
 
@@ -131,21 +132,6 @@ int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors)
 }
 EXPORT_SYMBOL(ide_end_request);
 
-/*
- * Power Management state machine. This one is rather trivial for now,
- * we should probably add more, like switching back to PIO on suspend
- * to help some BIOSes, re-do the door locking on resume, etc...
- */
-
-enum {
-	ide_pm_flush_cache	= ide_pm_state_start_suspend,
-	idedisk_pm_standby,
-
-	idedisk_pm_restore_pio	= ide_pm_state_start_resume,
-	idedisk_pm_idle,
-	ide_pm_restore_dma,
-};
-
 static void ide_complete_power_step(ide_drive_t *drive, struct request *rq, u8 stat, u8 error)
 {
 	struct request_pm_state *pm = rq->data;
@@ -154,20 +140,20 @@ static void ide_complete_power_step(ide_drive_t *drive, struct request *rq, u8 s
 		return;
 
 	switch (pm->pm_step) {
-	case ide_pm_flush_cache:	/* Suspend step 1 (flush cache) complete */
+	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
 		if (pm->pm_state == PM_EVENT_FREEZE)
-			pm->pm_step = ide_pm_state_completed;
+			pm->pm_step = IDE_PM_COMPLETED;
 		else
-			pm->pm_step = idedisk_pm_standby;
+			pm->pm_step = IDE_PM_STANDBY;
 		break;
-	case idedisk_pm_standby:	/* Suspend step 2 (standby) complete */
-		pm->pm_step = ide_pm_state_completed;
+	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
+		pm->pm_step = IDE_PM_COMPLETED;
 		break;
-	case idedisk_pm_restore_pio:	/* Resume step 1 complete */
-		pm->pm_step = idedisk_pm_idle;
+	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
+		pm->pm_step = IDE_PM_IDLE;
 		break;
-	case idedisk_pm_idle:		/* Resume step 2 (idle) complete */
-		pm->pm_step = ide_pm_restore_dma;
+	case IDE_PM_IDLE:		/* Resume step 2 (idle)*/
+		pm->pm_step = IDE_PM_RESTORE_DMA;
 		break;
 	}
 }
@@ -180,11 +166,12 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 	memset(args, 0, sizeof(*args));
 
 	switch (pm->pm_step) {
-	case ide_pm_flush_cache:	/* Suspend step 1 (flush cache) */
+	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
 		if (drive->media != ide_disk)
 			break;
 		/* Not supported? Switch to next step now. */
-		if (!drive->wcache || ata_id_flush_enabled(drive->id) == 0) {
+		if (ata_id_flush_enabled(drive->id) == 0 ||
+		    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0) {
 			ide_complete_power_step(drive, rq, 0, 0);
 			return ide_stopped;
 		}
@@ -193,27 +180,23 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 		else
 			args->tf.command = ATA_CMD_FLUSH;
 		goto out_do_tf;
-
-	case idedisk_pm_standby:	/* Suspend step 2 (standby) */
+	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
 		args->tf.command = ATA_CMD_STANDBYNOW1;
 		goto out_do_tf;
-
-	case idedisk_pm_restore_pio:	/* Resume step 1 (restore PIO) */
+	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
 		ide_set_max_pio(drive);
 		/*
-		 * skip idedisk_pm_idle for ATAPI devices
+		 * skip IDE_PM_IDLE for ATAPI devices
 		 */
 		if (drive->media != ide_disk)
-			pm->pm_step = ide_pm_restore_dma;
+			pm->pm_step = IDE_PM_RESTORE_DMA;
 		else
 			ide_complete_power_step(drive, rq, 0, 0);
 		return ide_stopped;
-
-	case idedisk_pm_idle:		/* Resume step 2 (idle) */
+	case IDE_PM_IDLE:		/* Resume step 2 (idle) */
 		args->tf.command = ATA_CMD_IDLEIMMEDIATE;
 		goto out_do_tf;
-
-	case ide_pm_restore_dma:	/* Resume step 3 (restore DMA) */
+	case IDE_PM_RESTORE_DMA:	/* Resume step 3 (restore DMA) */
 		/*
 		 * Right now, all we do is call ide_set_dma(drive),
 		 * we could be smarter and check for current xfer_speed
@@ -222,12 +205,13 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 		if (drive->hwif->dma_ops == NULL)
 			break;
 		/*
-		 * TODO: respect ->using_dma setting
+		 * TODO: respect IDE_DFLAG_USING_DMA
 		 */
 		ide_set_dma(drive);
 		break;
 	}
-	pm->pm_step = ide_pm_state_completed;
+
+	pm->pm_step = IDE_PM_COMPLETED;
 	return ide_stopped;
 
 out_do_tf:
@@ -287,7 +271,7 @@ static void ide_complete_pm_request (ide_drive_t *drive, struct request *rq)
 	if (blk_pm_suspend_request(rq)) {
 		blk_stop_queue(drive->queue);
 	} else {
-		drive->blocked = 0;
+		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
 		blk_start_queue(drive->queue);
 	}
 	HWGROUP(drive)->rq = NULL;
@@ -343,7 +327,7 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 			drive->name, rq->pm->pm_step, stat, err);
 #endif
 		ide_complete_power_step(drive, rq, stat, err);
-		if (pm->pm_step == ide_pm_state_completed)
+		if (pm->pm_step == IDE_PM_COMPLETED)
 			ide_complete_pm_request(drive, rq);
 		return;
 	}
@@ -374,13 +358,14 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if ((stat & ATA_BUSY) || ((stat & ATA_DF) && !drive->nowerr)) {
+	if ((stat & ATA_BUSY) ||
+	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else if (stat & ATA_ERR) {
 		/* err has different meaning on cdrom and tape */
 		if (err == ATA_ABORTED) {
-			if (drive->select.b.lba &&
+			if ((drive->dev_flags & IDE_DFLAG_LBA) &&
 			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
 			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
 				return ide_stopped;
@@ -428,7 +413,8 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if ((stat & ATA_BUSY) || ((stat & ATA_DF) && !drive->nowerr)) {
+	if ((stat & ATA_BUSY) ||
+	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else {
@@ -509,7 +495,7 @@ static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 	tf->lbal    = drive->sect;
 	tf->lbam    = drive->cyl;
 	tf->lbah    = drive->cyl >> 8;
-	tf->device  = ((drive->head - 1) | drive->select.all) & ~ATA_LBA;
+	tf->device  = (drive->head - 1) | drive->select;
 	tf->command = ATA_CMD_INIT_DEV_PARAMS;
 }
 
@@ -557,30 +543,6 @@ static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 	return ide_started;
 }
 
-/*
- * handle HDIO_SET_PIO_MODE ioctl abusers here, eventually it will go away
- */
-static int set_pio_mode_abuse(ide_hwif_t *hwif, u8 req_pio)
-{
-	switch (req_pio) {
-	case 202:
-	case 201:
-	case 200:
-	case 102:
-	case 101:
-	case 100:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_DMA_MODES) ? 1 : 0;
-	case 9:
-	case 8:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_PREFETCH) ? 1 : 0;
-	case 7:
-	case 6:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_FAST_DEVSEL) ? 1 : 0;
-	default:
-		return 0;
-	}
-}
-
 /**
  *	do_special		-	issue some special commands
  *	@drive: drive the command is for
@@ -598,45 +560,12 @@ static ide_startstop_t do_special (ide_drive_t *drive)
 #ifdef DEBUG
 	printk("%s: do_special: 0x%02x\n", drive->name, s->all);
 #endif
-	if (s->b.set_tune) {
-		ide_hwif_t *hwif = drive->hwif;
-		const struct ide_port_ops *port_ops = hwif->port_ops;
-		u8 req_pio = drive->tune_req;
-
-		s->b.set_tune = 0;
-
-		if (set_pio_mode_abuse(drive->hwif, req_pio)) {
-			/*
-			 * take ide_lock for drive->[no_]unmask/[no_]io_32bit
-			 */
-			if (req_pio == 8 || req_pio == 9) {
-				unsigned long flags;
-
-				spin_lock_irqsave(&ide_lock, flags);
-				port_ops->set_pio_mode(drive, req_pio);
-				spin_unlock_irqrestore(&ide_lock, flags);
-			} else
-				port_ops->set_pio_mode(drive, req_pio);
-		} else {
-			int keep_dma = drive->using_dma;
-
-			ide_set_pio(drive, req_pio);
-
-			if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
-				if (keep_dma)
-					ide_dma_on(drive);
-			}
-		}
-
-		return ide_stopped;
-	} else {
-		if (drive->media == ide_disk)
-			return ide_disk_special(drive);
+	if (drive->media == ide_disk)
+		return ide_disk_special(drive);
 
-		s->all = 0;
-		drive->mult_req = 0;
-		return ide_stopped;
-	}
+	s->all = 0;
+	drive->mult_req = 0;
+	return ide_stopped;
 }
 
 void ide_map_sg(ide_drive_t *drive, struct request *rq)
@@ -726,10 +655,7 @@ int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
 	if (!(setting->flags & DS_SYNC))
 		return setting->set(drive, arg);
 
-	rq = blk_get_request(q, READ, GFP_KERNEL);
-	if (!rq)
-		return -ENOMEM;
-
+	rq = blk_get_request(q, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_len = 5;
 	rq->cmd[0] = REQ_DEVSET_EXEC;
@@ -746,7 +672,32 @@ EXPORT_SYMBOL_GPL(ide_devset_execute);
 
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
-	switch (rq->cmd[0]) {
+	u8 cmd = rq->cmd[0];
+
+	if (cmd == REQ_PARK_HEADS || cmd == REQ_UNPARK_HEADS) {
+		ide_task_t task;
+		struct ide_taskfile *tf = &task.tf;
+
+		memset(&task, 0, sizeof(task));
+		if (cmd == REQ_PARK_HEADS) {
+			drive->sleep = *(unsigned long *)rq->special;
+			drive->dev_flags |= IDE_DFLAG_SLEEPING;
+			tf->command = ATA_CMD_IDLEIMMEDIATE;
+			tf->feature = 0x44;
+			tf->lbal = 0x4c;
+			tf->lbam = 0x4e;
+			tf->lbah = 0x55;
+			task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
+		} else		/* cmd == REQ_UNPARK_HEADS */
+			tf->command = ATA_CMD_CHK_POWER;
+
+		task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+		task.rq = rq;
+		drive->hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
+		return do_rw_taskfile(drive, &task);
+	}
+
+	switch (cmd) {
 	case REQ_DEVSET_EXEC:
 	{
 		int err, (*setfunc)(ide_drive_t *, int) = rq->special;
@@ -773,11 +724,11 @@ static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 	struct request_pm_state *pm = rq->data;
 
 	if (blk_pm_suspend_request(rq) &&
-	    pm->pm_step == ide_pm_state_start_suspend)
+	    pm->pm_step == IDE_PM_START_SUSPEND)
 		/* Mark drive blocked when starting the suspend sequence. */
-		drive->blocked = 1;
+		drive->dev_flags |= IDE_DFLAG_BLOCKED;
 	else if (blk_pm_resume_request(rq) &&
-		 pm->pm_step == ide_pm_state_start_resume) {
+		 pm->pm_step == IDE_PM_START_RESUME) {
 		/* 
 		 * The first thing we do on wakeup is to wait for BSY bit to
 		 * go away (with a looong timeout) as a drive on this hwif may
@@ -857,7 +808,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 #endif
 			startstop = ide_start_power_step(drive, rq);
 			if (startstop == ide_stopped &&
-			    pm->pm_step == ide_pm_state_completed)
+			    pm->pm_step == IDE_PM_COMPLETED)
 				ide_complete_pm_request(drive, rq);
 			return startstop;
 		} else if (!rq->rq_disk && blk_special_request(rq))
@@ -895,7 +846,7 @@ void ide_stall_queue (ide_drive_t *drive, unsigned long timeout)
 	if (timeout > WAIT_WORSTCASE)
 		timeout = WAIT_WORSTCASE;
 	drive->sleep = timeout + jiffies;
-	drive->sleeping = 1;
+	drive->dev_flags |= IDE_DFLAG_SLEEPING;
 }
 
 EXPORT_SYMBOL(ide_stall_queue);
@@ -935,18 +886,23 @@ repeat:
 	}
 
 	do {
-		if ((!drive->sleeping || time_after_eq(jiffies, drive->sleep))
-		    && !elv_queue_empty(drive->queue)) {
-			if (!best
-			 || (drive->sleeping && (!best->sleeping || time_before(drive->sleep, best->sleep)))
-			 || (!best->sleeping && time_before(WAKEUP(drive), WAKEUP(best))))
-			{
+		u8 dev_s = !!(drive->dev_flags & IDE_DFLAG_SLEEPING);
+		u8 best_s = (best && !!(best->dev_flags & IDE_DFLAG_SLEEPING));
+
+		if ((dev_s == 0 || time_after_eq(jiffies, drive->sleep)) &&
+		    !elv_queue_empty(drive->queue)) {
+			if (best == NULL ||
+			    (dev_s && (best_s == 0 || time_before(drive->sleep, best->sleep))) ||
+			    (best_s == 0 && time_before(WAKEUP(drive), WAKEUP(best)))) {
 				if (!blk_queue_plugged(drive->queue))
 					best = drive;
 			}
 		}
 	} while ((drive = drive->next) != hwgroup->drive);
-	if (best && best->nice1 && !best->sleeping && best != hwgroup->drive && best->service_time > WAIT_MIN_SLEEP) {
+
+	if (best && (best->dev_flags & IDE_DFLAG_NICE1) &&
+	    (best->dev_flags & IDE_DFLAG_SLEEPING) == 0 &&
+	    best != hwgroup->drive && best->service_time > WAIT_MIN_SLEEP) {
 		long t = (signed long)(WAKEUP(best) - jiffies);
 		if (t >= WAIT_MIN_SLEEP) {
 		/*
@@ -955,7 +911,7 @@ repeat:
 		 */
 			drive = best->next;
 			do {
-				if (!drive->sleeping
+				if ((drive->dev_flags & IDE_DFLAG_SLEEPING) == 0
 				 && time_before(jiffies - best->service_time, WAKEUP(drive))
 				 && time_before(WAKEUP(drive), jiffies + t))
 				{
@@ -1026,7 +982,9 @@ static void ide_do_request (ide_hwgroup_t *hwgroup, int masked_irq)
 			hwgroup->rq = NULL;
 			drive = hwgroup->drive;
 			do {
-				if (drive->sleeping && (!sleeping || time_before(drive->sleep, sleep))) {
+				if ((drive->dev_flags & IDE_DFLAG_SLEEPING) &&
+				    (sleeping == 0 ||
+				     time_before(drive->sleep, sleep))) {
 					sleeping = 1;
 					sleep = drive->sleep;
 				}
@@ -1075,7 +1033,7 @@ static void ide_do_request (ide_hwgroup_t *hwgroup, int masked_irq)
 		}
 		hwgroup->hwif = hwif;
 		hwgroup->drive = drive;
-		drive->sleeping = 0;
+		drive->dev_flags &= ~(IDE_DFLAG_SLEEPING | IDE_DFLAG_PARKED);
 		drive->service_start = jiffies;
 
 		if (blk_queue_plugged(drive->queue)) {
@@ -1109,7 +1067,9 @@ static void ide_do_request (ide_hwgroup_t *hwgroup, int masked_irq)
 		 * We count how many times we loop here to make sure we service
 		 * all drives in the hwgroup without looping for ever
 		 */
-		if (drive->blocked && !blk_pm_request(rq) && !(rq->cmd_flags & REQ_PREEMPT)) {
+		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
+		    blk_pm_request(rq) == 0 &&
+		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
 			drive = drive->next ? drive->next : hwgroup->drive;
 			if (loops++ < 4 && !blk_queue_plugged(drive->queue))
 				goto again;
@@ -1182,8 +1142,8 @@ static ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 	 * a timeout -- we'll reenable after we finish this next request
 	 * (or rather the first chunk of it) in pio.
 	 */
+	drive->dev_flags |= IDE_DFLAG_DMA_PIO_RETRY;
 	drive->retry_pio++;
-	drive->state = DMA_PIO_RETRY;
 	ide_dma_off_quietly(drive);
 
 	/*
@@ -1480,23 +1440,16 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 	del_timer(&hwgroup->timer);
 	spin_unlock(&ide_lock);
 
-	/* Some controllers might set DMA INTR no matter DMA or PIO;
-	 * bmdma status might need to be cleared even for
-	 * PIO interrupts to prevent spurious/lost irq.
-	 */
-	if (hwif->ide_dma_clear_irq && !(drive->waiting_for_dma))
-		/* ide_dma_end() needs bmdma status for error checking.
-		 * So, skip clearing bmdma status here and leave it
-		 * to ide_dma_end() if this is dma interrupt.
-		 */
-		hwif->ide_dma_clear_irq(drive);
+	if (hwif->port_ops && hwif->port_ops->clear_irq)
+		hwif->port_ops->clear_irq(drive);
 
-	if (drive->unmask)
+	if (drive->dev_flags & IDE_DFLAG_UNMASK)
 		local_irq_enable_in_hardirq();
+
 	/* service this interrupt, may set handler for next interrupt */
 	startstop = handler(drive);
-	spin_lock_irq(&ide_lock);
 
+	spin_lock_irq(&ide_lock);
 	/*
 	 * Note that handler() may have set things up for another
 	 * interrupt to occur soon, but it cannot happen until
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index cf01564..a90945f 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -62,7 +62,7 @@ static int ide_get_identity_ioctl(ide_drive_t *drive, unsigned int cmd,
 	int size = (cmd == HDIO_GET_IDENTITY) ? (ATA_ID_WORDS * 2) : 142;
 	int rc = 0;
 
-	if (drive->id_read == 0) {
+	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 		rc = -ENOMSG;
 		goto out;
 	}
@@ -86,8 +86,10 @@ out:
 
 static int ide_get_nice_ioctl(ide_drive_t *drive, unsigned long arg)
 {
-	return put_user((drive->dsc_overlap << IDE_NICE_DSC_OVERLAP) |
-			(drive->nice1 << IDE_NICE_1), (long __user *)arg);
+	return put_user((!!(drive->dev_flags & IDE_DFLAG_DSC_OVERLAP)
+			 << IDE_NICE_DSC_OVERLAP) |
+			(!!(drive->dev_flags & IDE_DFLAG_NICE1)
+			 << IDE_NICE_1), (long __user *)arg);
 }
 
 static int ide_set_nice_ioctl(ide_drive_t *drive, unsigned long arg)
@@ -97,11 +99,18 @@ static int ide_set_nice_ioctl(ide_drive_t *drive, unsigned long arg)
 
 	if (((arg >> IDE_NICE_DSC_OVERLAP) & 1) &&
 	    (drive->media == ide_disk || drive->media == ide_floppy ||
-	     drive->scsi))
+	     (drive->dev_flags & IDE_DFLAG_SCSI)))
 		return -EPERM;
 
-	drive->dsc_overlap = (arg >> IDE_NICE_DSC_OVERLAP) & 1;
-	drive->nice1 = (arg >> IDE_NICE_1) & 1;
+	if ((arg >> IDE_NICE_DSC_OVERLAP) & 1)
+		drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
+
+	if ((arg >> IDE_NICE_1) & 1)
+		drive->dev_flags |= IDE_DFLAG_NICE1;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_NICE1;
 
 	return 0;
 }
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 0a2fd3b..b762deb 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -181,7 +181,7 @@ void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 		tf_outb(tf->lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tf_outb((tf->device & HIHI) | drive->select.all,
+		tf_outb((tf->device & HIHI) | drive->select,
 			 io_ports->device_addr);
 }
 EXPORT_SYMBOL_GPL(ide_tf_load);
@@ -647,7 +647,7 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 		return 1;
 
 no_80w:
-	if (drive->udma33_warned == 1)
+	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
 		return 0;
 
 	printk(KERN_WARNING "%s: %s side 80-wire cable detection failed, "
@@ -655,7 +655,7 @@ no_80w:
 			    drive->name,
 			    hwif->cbl == ATA_CBL_PATA80 ? "drive" : "host");
 
-	drive->udma33_warned = 1;
+	drive->dev_flags |= IDE_DFLAG_UDMA33_WARNED;
 
 	return 0;
 }
@@ -711,7 +711,7 @@ int ide_driveid_update(ide_drive_t *drive)
 
 	kfree(id);
 
-	if (drive->using_dma && ide_id_dma_bug(drive))
+	if ((drive->dev_flags & IDE_DFLAG_USING_DMA) && ide_id_dma_bug(drive))
 		ide_dma_off(drive);
 
 	return 1;
@@ -790,7 +790,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 
  skip:
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	if (speed >= XFER_SW_DMA_0 && drive->using_dma)
+	if (speed >= XFER_SW_DMA_0 && (drive->dev_flags & IDE_DFLAG_USING_DMA))
 		hwif->dma_ops->dma_host_set(drive, 1);
 	else if (hwif->dma_ops)	/* check if host supports DMA */
 		ide_dma_off_quietly(drive);
@@ -940,6 +940,25 @@ static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 	return ide_stopped;
 }
 
+static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
+{
+	static const char *err_master_vals[] =
+		{ NULL, "passed", "formatter device error",
+		  "sector buffer error", "ECC circuitry error",
+		  "controlling MPU error" };
+
+	u8 err_master = err & 0x7f;
+
+	printk(KERN_ERR "%s: reset: master: ", hwif->name);
+	if (err_master && err_master < 6)
+		printk(KERN_CONT "%s", err_master_vals[err_master]);
+	else
+		printk(KERN_CONT "error (0x%02x?)", err);
+	if (err & 0x80)
+		printk(KERN_CONT "; slave: failed");
+	printk(KERN_CONT "\n");
+}
+
 /*
  * reset_pollfunc() gets invoked to poll the interface for completion every 50ms
  * during an ide reset operation. If the drives have not yet responded,
@@ -975,31 +994,14 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 		drive->failures++;
 		err = -EIO;
 	} else  {
-		printk("%s: reset: ", hwif->name);
 		tmp = ide_read_error(drive);
 
 		if (tmp == 1) {
-			printk("success\n");
+			printk(KERN_INFO "%s: reset: success\n", hwif->name);
 			drive->failures = 0;
 		} else {
+			ide_reset_report_error(hwif, tmp);
 			drive->failures++;
-			printk("master: ");
-			switch (tmp & 0x7f) {
-				case 1: printk("passed");
-					break;
-				case 2: printk("formatter device error");
-					break;
-				case 3: printk("sector buffer error");
-					break;
-				case 4: printk("ECC circuitry error");
-					break;
-				case 5: printk("controlling MPU error");
-					break;
-				default:printk("error (0x%02x?)", tmp);
-			}
-			if (tmp & 0x80)
-				printk("; slave: failed");
-			printk("\n");
 			err = -EIO;
 		}
 	}
@@ -1016,9 +1018,14 @@ static void ide_disk_pre_reset(ide_drive_t *drive)
 	drive->special.all = 0;
 	drive->special.b.set_geometry = legacy;
 	drive->special.b.recalibrate  = legacy;
+
 	drive->mult_count = 0;
-	if (!drive->keep_settings && !drive->using_dma)
+	drive->dev_flags &= ~IDE_DFLAG_PARKED;
+
+	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0 &&
+	    (drive->dev_flags & IDE_DFLAG_USING_DMA) == 0)
 		drive->mult_req = 0;
+
 	if (drive->mult_req != drive->mult_count)
 		drive->special.b.set_multmode = 1;
 }
@@ -1030,18 +1037,18 @@ static void pre_reset(ide_drive_t *drive)
 	if (drive->media == ide_disk)
 		ide_disk_pre_reset(drive);
 	else
-		drive->post_reset = 1;
+		drive->dev_flags |= IDE_DFLAG_POST_RESET;
 
-	if (drive->using_dma) {
+	if (drive->dev_flags & IDE_DFLAG_USING_DMA) {
 		if (drive->crc_count)
 			ide_check_dma_crc(drive);
 		else
 			ide_dma_off(drive);
 	}
 
-	if (!drive->keep_settings) {
-		if (!drive->using_dma) {
-			drive->unmask = 0;
+	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0) {
+		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0) {
+			drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 			drive->io_32bit = 0;
 		}
 		return;
@@ -1073,12 +1080,13 @@ static void pre_reset(ide_drive_t *drive)
 static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 {
 	unsigned int unit;
-	unsigned long flags;
+	unsigned long flags, timeout;
 	ide_hwif_t *hwif;
 	ide_hwgroup_t *hwgroup;
 	struct ide_io_ports *io_ports;
 	const struct ide_tp_ops *tp_ops;
 	const struct ide_port_ops *port_ops;
+	DEFINE_WAIT(wait);
 
 	spin_lock_irqsave(&ide_lock, flags);
 	hwif = HWIF(drive);
@@ -1105,6 +1113,31 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 		return ide_started;
 	}
 
+	/* We must not disturb devices in the IDE_DFLAG_PARKED state. */
+	do {
+		unsigned long now;
+
+		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
+		timeout = jiffies;
+		for (unit = 0; unit < MAX_DRIVES; unit++) {
+			ide_drive_t *tdrive = &hwif->drives[unit];
+
+			if (tdrive->dev_flags & IDE_DFLAG_PRESENT &&
+			    tdrive->dev_flags & IDE_DFLAG_PARKED &&
+			    time_after(tdrive->sleep, timeout))
+				timeout = tdrive->sleep;
+		}
+
+		now = jiffies;
+		if (time_before_eq(timeout, now))
+			break;
+
+		spin_unlock_irqrestore(&ide_lock, flags);
+		timeout = schedule_timeout_uninterruptible(timeout - now);
+		spin_lock_irqsave(&ide_lock, flags);
+	} while (timeout);
+	finish_wait(&ide_park_wq, &wait);
+
 	/*
 	 * First, reset any device state data we were maintaining
 	 * for any of the drives on this interface.
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index ed426dd..9fc4cfb 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -317,7 +317,7 @@ static void ide_dump_sector(ide_drive_t *drive)
 {
 	ide_task_t task;
 	struct ide_taskfile *tf = &task.tf;
-	int lba48 = (drive->addressing == 1) ? 1 : 0;
+	u8 lba48 = !!(drive->dev_flags & IDE_DFLAG_LBA48);
 
 	memset(&task, 0, sizeof(task));
 	if (lba48)
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
new file mode 100644
index 0000000..03b00e5
--- /dev/null
+++ b/drivers/ide/ide-park.c
@@ -0,0 +1,121 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/jiffies.h>
+#include <linux/blkdev.h>
+
+DECLARE_WAIT_QUEUE_HEAD(ide_park_wq);
+
+static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
+{
+	struct request_queue *q = drive->queue;
+	struct request *rq;
+	int rc;
+
+	timeout += jiffies;
+	spin_lock_irq(&ide_lock);
+	if (drive->dev_flags & IDE_DFLAG_PARKED) {
+		ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+		int reset_timer;
+
+		reset_timer = time_before(timeout, drive->sleep);
+		drive->sleep = timeout;
+		wake_up_all(&ide_park_wq);
+		if (reset_timer && hwgroup->sleeping &&
+		    del_timer(&hwgroup->timer)) {
+			hwgroup->sleeping = 0;
+			hwgroup->busy = 0;
+			blk_start_queueing(q);
+		}
+		spin_unlock_irq(&ide_lock);
+		return;
+	}
+	spin_unlock_irq(&ide_lock);
+
+	rq = blk_get_request(q, READ, __GFP_WAIT);
+	rq->cmd[0] = REQ_PARK_HEADS;
+	rq->cmd_len = 1;
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->special = &timeout;
+	rc = blk_execute_rq(q, NULL, rq, 1);
+	blk_put_request(rq);
+	if (rc)
+		goto out;
+
+	/*
+	 * Make sure that *some* command is sent to the drive after the
+	 * timeout has expired, so power management will be reenabled.
+	 */
+	rq = blk_get_request(q, READ, GFP_NOWAIT);
+	if (unlikely(!rq))
+		goto out;
+
+	rq->cmd[0] = REQ_UNPARK_HEADS;
+	rq->cmd_len = 1;
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
+
+out:
+	return;
+}
+
+ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
+		      char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	unsigned long now;
+	unsigned int msecs;
+
+	if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
+		return -EOPNOTSUPP;
+
+	spin_lock_irq(&ide_lock);
+	now = jiffies;
+	if (drive->dev_flags & IDE_DFLAG_PARKED &&
+	    time_after(drive->sleep, now))
+		msecs = jiffies_to_msecs(drive->sleep - now);
+	else
+		msecs = 0;
+	spin_unlock_irq(&ide_lock);
+
+	return snprintf(buf, 20, "%u\n", msecs);
+}
+
+ssize_t ide_park_store(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t len)
+{
+#define MAX_PARK_TIMEOUT 30000
+	ide_drive_t *drive = to_ide_device(dev);
+	long int input;
+	int rc;
+
+	rc = strict_strtol(buf, 10, &input);
+	if (rc || input < -2)
+		return -EINVAL;
+	if (input > MAX_PARK_TIMEOUT) {
+		input = MAX_PARK_TIMEOUT;
+		rc = -EOVERFLOW;
+	}
+
+	mutex_lock(&ide_setting_mtx);
+	if (input >= 0) {
+		if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
+			rc = -EOPNOTSUPP;
+		else if (input || drive->dev_flags & IDE_DFLAG_PARKED)
+			issue_park_cmd(drive, msecs_to_jiffies(input));
+	} else {
+		if (drive->media == ide_disk)
+			switch (input) {
+			case -1:
+				drive->dev_flags &= ~IDE_DFLAG_NO_UNLOAD;
+				break;
+			case -2:
+				drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
+				break;
+			}
+		else
+			rc = -EOPNOTSUPP;
+	}
+	mutex_unlock(&ide_setting_mtx);
+
+	return rc ? rc : len;
+}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 06575a1..f27baa5 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -121,7 +121,8 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 	/* read 512 bytes of id info */
 	hwif->tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
 
-	drive->id_read = 1;
+	drive->dev_flags |= IDE_DFLAG_ID_READ;
+
 	local_irq_enable();
 #ifdef DEBUG
 	printk(KERN_INFO "%s: dumping identify data\n", drive->name);
@@ -153,8 +154,8 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 
 	printk(KERN_INFO "%s: %s, ", drive->name, m);
 
-	drive->present = 1;
-	drive->dead = 0;
+	drive->dev_flags |= IDE_DFLAG_PRESENT;
+	drive->dev_flags &= ~IDE_DFLAG_DEAD;
 
 	/*
 	 * Check for an ATAPI device
@@ -172,14 +173,14 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 						printk(KERN_CONT "cdrom or floppy?, assuming ");
 					if (drive->media != ide_cdrom) {
 						printk(KERN_CONT "FLOPPY");
-						drive->removable = 1;
+						drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 						break;
 					}
 				}
 				/* Early cdrom models used zero */
 				type = ide_cdrom;
 			case ide_cdrom:
-				drive->removable = 1;
+				drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 #ifdef CONFIG_PPC
 				/* kludge for Apple PowerBook internal zip */
 				if (!strstr(m, "CD-ROM") && strstr(m, "ZIP")) {
@@ -195,7 +196,7 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 				break;
 			case ide_optical:
 				printk(KERN_CONT "OPTICAL");
-				drive->removable = 1;
+				drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 				break;
 			default:
 				printk(KERN_CONT "UNKNOWN (type %d)", type);
@@ -205,6 +206,10 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 		drive->media = type;
 		/* an ATAPI device ignores DRDY */
 		drive->ready_stat = 0;
+		if (ata_id_cdb_intr(id))
+			drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
+		/* we don't do head unloading on ATAPI devices */
+		drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
 		return;
 	}
 
@@ -216,17 +221,20 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 
 	/* CF devices are *not* removable in Linux definition of the term */
 	if (is_cfa == 0 && (id[ATA_ID_CONFIG] & (1 << 7)))
-		drive->removable = 1;
+		drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 
 	drive->media = ide_disk;
 
+	if (!ata_id_has_unload(drive->id))
+		drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
+
 	printk(KERN_CONT "%s DISK drive\n", is_cfa ? "CFA" : "ATA");
 
 	return;
 
 err_misc:
 	kfree(id);
-	drive->present = 0;
+	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 	return;
 }
 
@@ -426,16 +434,15 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	ide_hwif_t *hwif = HWIF(drive);
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int rc;
-	u8 stat;
+	u8 present = !!(drive->dev_flags & IDE_DFLAG_PRESENT), stat;
+
+	/* avoid waiting for inappropriate probes */
+	if (present && drive->media != ide_disk && cmd == ATA_CMD_ID_ATA)
+		return 4;
 
-	if (drive->present) {
-		/* avoid waiting for inappropriate probes */
-		if (drive->media != ide_disk && cmd == ATA_CMD_ID_ATA)
-			return 4;
-	}
 #ifdef DEBUG
 	printk(KERN_INFO "probing for %s: present=%d, media=%d, probetype=%s\n",
-		drive->name, drive->present, drive->media,
+		drive->name, present, drive->media,
 		(cmd == ATA_CMD_ID_ATA) ? "ATA" : "ATAPI");
 #endif
 
@@ -446,8 +453,8 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	SELECT_DRIVE(drive);
 	msleep(50);
 
-	if (ide_read_device(drive) != drive->select.all && !drive->present) {
-		if (drive->select.b.unit != 0) {
+	if (ide_read_device(drive) != drive->select && present == 0) {
+		if (drive->dn & 1) {
 			/* exit with drive0 selected */
 			SELECT_DRIVE(&hwif->drives[0]);
 			/* allow ATA_BUSY to assert & clear */
@@ -460,7 +467,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	stat = tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY) ||
-	    drive->present || cmd == ATA_CMD_ID_ATAPI) {
+	    present || cmd == ATA_CMD_ID_ATAPI) {
 		/* send cmd and wait */
 		if ((rc = try_to_identify(drive, cmd))) {
 			/* failed: try again */
@@ -493,7 +500,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		/* not present or maybe ATAPI */
 		rc = 3;
 	}
-	if (drive->select.b.unit != 0) {
+	if (drive->dn & 1) {
 		/* exit with drive0 selected */
 		SELECT_DRIVE(&hwif->drives[0]);
 		msleep(50);
@@ -542,8 +549,8 @@ static void enable_nest (ide_drive_t *drive)
  *	and presents things to the user as needed.
  *
  *	Returns:	0  no device was found
- *			1  device was found (note: drive->present might
- *			   still be 0)
+ *			1  device was found
+ *			   (note: IDE_DFLAG_PRESENT might still be not set)
  */
  
 static inline u8 probe_for_drive (ide_drive_t *drive)
@@ -559,10 +566,10 @@ static inline u8 probe_for_drive (ide_drive_t *drive)
 	 *	Also note that 0 everywhere means "can't do X"
 	 */
  
+	drive->dev_flags &= ~IDE_DFLAG_ID_READ;
+
 	drive->id = kzalloc(SECTOR_SIZE, GFP_KERNEL);
-	drive->id_read = 0;
-	if(drive->id == NULL)
-	{
+	if (drive->id == NULL) {
 		printk(KERN_ERR "ide: out of memory for id data.\n");
 		return 0;
 	}
@@ -571,14 +578,14 @@ static inline u8 probe_for_drive (ide_drive_t *drive)
 	strcpy(m, "UNKNOWN");
 
 	/* skip probing? */
-	if (!drive->noprobe) {
+	if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0) {
 retry:
 		/* if !(success||timed-out) */
 		if (do_probe(drive, ATA_CMD_ID_ATA) >= 2)
 			/* look for ATAPI device */
 			(void)do_probe(drive, ATA_CMD_ID_ATAPI);
 
-		if (!drive->present)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			/* drive not found */
 			return 0;
 
@@ -588,7 +595,7 @@ retry:
 		}
 
 		/* identification failed? */
-		if (!drive->id_read) {
+		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 			if (drive->media == ide_disk) {
 				printk(KERN_INFO "%s: non-IDE drive, CHS=%d/%d/%d\n",
 					drive->name, drive->cyl,
@@ -598,15 +605,17 @@ retry:
 			} else {
 				/* nuke it */
 				printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n", drive->name);
-				drive->present = 0;
+				drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 			}
 		}
 		/* drive was found */
 	}
-	if(!drive->present)
+
+	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		return 0;
+
 	/* The drive wasn't being helpful. Add generic info only */
-	if (drive->id_read == 0) {
+	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 		generic_id(drive);
 		return 1;
 	}
@@ -616,7 +625,7 @@ retry:
 		ide_disk_init_mult_count(drive);
 	}
 
-	return drive->present;
+	return !!(drive->dev_flags & IDE_DFLAG_PRESENT);
 }
 
 static void hwif_release_dev(struct device *dev)
@@ -707,7 +716,8 @@ static int ide_port_wait_ready(ide_hwif_t *hwif)
 		ide_drive_t *drive = &hwif->drives[unit];
 
 		/* Ignore disks that we will not probe for later. */
-		if (!drive->noprobe || drive->present) {
+		if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0 ||
+		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
 			SELECT_DRIVE(drive);
 			hwif->tp_ops->set_irq(hwif, 1);
 			mdelay(2);
@@ -739,7 +749,7 @@ void ide_undecoded_slave(ide_drive_t *dev1)
 {
 	ide_drive_t *dev0 = &dev1->hwif->drives[0];
 
-	if ((dev1->dn & 1) == 0 || dev0->present == 0)
+	if ((dev1->dn & 1) == 0 || (dev0->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		return;
 
 	/* If the models don't match they are not the same product */
@@ -759,7 +769,7 @@ void ide_undecoded_slave(ide_drive_t *dev1)
 	/* Appears to be an IDE flash adapter with decode bugs */
 	printk(KERN_WARNING "ide-probe: ignoring undecoded slave\n");
 
-	dev1->present = 0;
+	dev1->dev_flags &= ~IDE_DFLAG_PRESENT;
 }
 
 EXPORT_SYMBOL_GPL(ide_undecoded_slave);
@@ -772,7 +782,8 @@ static int ide_probe_port(ide_hwif_t *hwif)
 
 	BUG_ON(hwif->present);
 
-	if (hwif->drives[0].noprobe && hwif->drives[1].noprobe)
+	if ((hwif->drives[0].dev_flags & IDE_DFLAG_NOPROBE) &&
+	    (hwif->drives[1].dev_flags & IDE_DFLAG_NOPROBE))
 		return -EACCES;
 
 	/*
@@ -794,9 +805,9 @@ static int ide_probe_port(ide_hwif_t *hwif)
 	 */
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
-		drive->dn = (hwif->channel ? 2 : 0) + unit;
+
 		(void) probe_for_drive(drive);
-		if (drive->present)
+		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			rc = 0;
 	}
 
@@ -820,17 +831,19 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 	for (unit = 0; unit < MAX_DRIVES; unit++) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
-		if (drive->present && port_ops && port_ops->quirkproc)
-			port_ops->quirkproc(drive);
+		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
+			if (port_ops && port_ops->quirkproc)
+				port_ops->quirkproc(drive);
+		}
 	}
 
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
-		if (drive->present) {
+		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			ide_set_max_pio(drive);
 
-			drive->nice1 = 1;
+			drive->dev_flags |= IDE_DFLAG_NICE1;
 
 			if (hwif->dma_ops)
 				ide_set_dma(drive);
@@ -840,14 +853,14 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
-		if (hwif->host_flags & IDE_HFLAG_NO_IO_32BIT)
-			drive->no_io_32bit = 1;
+		if ((hwif->host_flags & IDE_HFLAG_NO_IO_32BIT) ||
+		    drive->id[ATA_ID_DWORD_IO])
+			drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
 		else
-			drive->no_io_32bit = drive->id[ATA_ID_DWORD_IO] ? 1 : 0;
+			drive->dev_flags &= ~IDE_DFLAG_NO_IO_32BIT;
 	}
 }
 
-#if MAX_HWIFS > 1
 /*
  * save_match() is used to simplify logic in init_irq() below.
  *
@@ -872,7 +885,6 @@ static void save_match(ide_hwif_t *hwif, ide_hwif_t *new, ide_hwif_t **match)
 	if (!m || m->irq != hwif->irq) /* don't undo a prior perfect match */
 		*match = new;
 }
-#endif /* MAX_HWIFS > 1 */
 
 /*
  * init request queue
@@ -951,26 +963,33 @@ static void ide_add_drive_to_hwgroup(ide_drive_t *drive)
  * - allocate the block device queue
  * - link drive into the hwgroup
  */
-static void ide_port_setup_devices(ide_hwif_t *hwif)
+static int ide_port_setup_devices(ide_hwif_t *hwif)
 {
-	int i;
+	int i, j = 0;
 
 	mutex_lock(&ide_cfg_mtx);
 	for (i = 0; i < MAX_DRIVES; i++) {
 		ide_drive_t *drive = &hwif->drives[i];
 
-		if (!drive->present)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
 		if (ide_init_queue(drive)) {
 			printk(KERN_ERR "ide: failed to init %s\n",
 					drive->name);
+			kfree(drive->id);
+			drive->id = NULL;
+			drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 			continue;
 		}
 
+		j++;
+
 		ide_add_drive_to_hwgroup(drive);
 	}
 	mutex_unlock(&ide_cfg_mtx);
+
+	return j;
 }
 
 static ide_hwif_t *ide_ports[MAX_HWIFS];
@@ -1029,7 +1048,7 @@ static int init_irq (ide_hwif_t *hwif)
 
 	mutex_lock(&ide_cfg_mtx);
 	hwif->hwgroup = NULL;
-#if MAX_HWIFS > 1
+
 	/*
 	 * Group up with any other hwifs that share our irq(s).
 	 */
@@ -1054,7 +1073,7 @@ static int init_irq (ide_hwif_t *hwif)
 			}
 		}
 	}
-#endif /* MAX_HWIFS > 1 */
+
 	/*
 	 * If we are still without a hwgroup, then form a new one
 	 */
@@ -1153,12 +1172,13 @@ static struct kobject *ata_probe(dev_t dev, int *part, void *data)
 	ide_hwif_t *hwif = data;
 	int unit = *part >> PARTN_BITS;
 	ide_drive_t *drive = &hwif->drives[unit];
-	if (!drive->present)
+
+	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		return NULL;
 
 	if (drive->media == ide_disk)
 		request_module("ide-disk");
-	if (drive->scsi)
+	if (drive->dev_flags & IDE_DFLAG_SCSI)
 		request_module("ide-scsi");
 	if (drive->media == ide_cdrom || drive->media == ide_optical)
 		request_module("ide-cd");
@@ -1205,7 +1225,7 @@ EXPORT_SYMBOL_GPL(ide_unregister_region);
 void ide_init_disk(struct gendisk *disk, ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	unsigned int unit = (drive->select.all >> 4) & 1;
+	unsigned int unit = drive->dn & 1;
 
 	disk->major = hwif->major;
 	disk->first_minor = unit << PARTN_BITS;
@@ -1248,7 +1268,7 @@ static void drive_release_dev (struct device *dev)
 	ide_remove_drive_from_hwgroup(drive);
 	kfree(drive->id);
 	drive->id = NULL;
-	drive->present = 0;
+	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 	/* Messed up locking ... */
 	spin_unlock_irq(&ide_lock);
 	blk_cleanup_queue(drive->queue);
@@ -1327,7 +1347,7 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 		struct device *dev = &drive->gendev;
 		int ret;
 
-		if (!drive->present)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
 		snprintf(dev->bus_id, BUS_ID_SIZE, "%u.%u", hwif->index, i);
@@ -1351,12 +1371,14 @@ static void ide_port_init_devices(ide_hwif_t *hwif)
 	for (i = 0; i < MAX_DRIVES; i++) {
 		ide_drive_t *drive = &hwif->drives[i];
 
+		drive->dn = i + hwif->channel * 2;
+
 		if (hwif->host_flags & IDE_HFLAG_IO_32BIT)
 			drive->io_32bit = 1;
 		if (hwif->host_flags & IDE_HFLAG_UNMASK_IRQS)
-			drive->unmask = 1;
+			drive->dev_flags |= IDE_DFLAG_UNMASK;
 		if (hwif->host_flags & IDE_HFLAG_NO_UNMASK_IRQS)
-			drive->no_unmask = 1;
+			drive->dev_flags |= IDE_DFLAG_NO_UNMASK;
 
 		if (port_ops && port_ops->init_dev)
 			port_ops->init_dev(drive);
@@ -1513,19 +1535,14 @@ static int ide_find_port_slot(const struct ide_port_info *d)
 	 * ports 0x1f0/0x170 (the ide0/ide1 defaults).
 	 */
 	mutex_lock(&ide_cfg_mtx);
-	if (MAX_HWIFS == 1) {
-		if (ide_indexes == 0 && i == 0)
-			idx = 1;
+	if (bootable) {
+		if ((ide_indexes | i) != (1 << MAX_HWIFS) - 1)
+			idx = ffz(ide_indexes | i);
 	} else {
-		if (bootable) {
-			if ((ide_indexes | i) != (1 << MAX_HWIFS) - 1)
-				idx = ffz(ide_indexes | i);
-		} else {
-			if ((ide_indexes | 3) != (1 << MAX_HWIFS) - 1)
-				idx = ffz(ide_indexes | 3);
-			else if ((ide_indexes & 3) != 3)
-				idx = ffz(ide_indexes);
-		}
+		if ((ide_indexes | 3) != (1 << MAX_HWIFS) - 1)
+			idx = ffz(ide_indexes | 3);
+		else if ((ide_indexes & 3) != 3)
+			idx = ffz(ide_indexes);
 	}
 	if (idx >= 0)
 		ide_indexes |= (1 << idx);
@@ -1541,8 +1558,7 @@ static void ide_free_port_slot(int idx)
 	mutex_unlock(&ide_cfg_mtx);
 }
 
-struct ide_host *ide_host_alloc_all(const struct ide_port_info *d,
-				    hw_regs_t **hws)
+struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 {
 	struct ide_host *host;
 	int i;
@@ -1551,7 +1567,7 @@ struct ide_host *ide_host_alloc_all(const struct ide_port_info *d,
 	if (host == NULL)
 		return NULL;
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		ide_hwif_t *hwif;
 		int idx;
 
@@ -1593,18 +1609,6 @@ struct ide_host *ide_host_alloc_all(const struct ide_port_info *d,
 
 	return host;
 }
-EXPORT_SYMBOL_GPL(ide_host_alloc_all);
-
-struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
-{
-	hw_regs_t *hws_all[MAX_HWIFS];
-	int i;
-
-	for (i = 0; i < MAX_HWIFS; i++)
-		hws_all[i] = (i < 4) ? hws[i] : NULL;
-
-	return ide_host_alloc_all(d, hws_all);
-}
 EXPORT_SYMBOL_GPL(ide_host_alloc);
 
 int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
@@ -1613,7 +1617,7 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 	ide_hwif_t *hwif, *mate = NULL;
 	int i, j = 0;
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL) {
@@ -1626,22 +1630,22 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 
 		if (d == NULL) {
 			mate = NULL;
-			continue;
-		}
+		} else {
+			if ((i & 1) && mate) {
+				hwif->mate = mate;
+				mate->mate = hwif;
+			}
 
-		if ((i & 1) && mate) {
-			hwif->mate = mate;
-			mate->mate = hwif;
-		}
+			mate = (i & 1) ? NULL : hwif;
 
-		mate = (i & 1) ? NULL : hwif;
+			ide_init_port(hwif, i & 1, d);
+			ide_port_cable_detect(hwif);
+		}
 
-		ide_init_port(hwif, i & 1, d);
-		ide_port_cable_detect(hwif);
 		ide_port_init_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL)
@@ -1658,7 +1662,7 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			ide_port_tune_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL)
@@ -1671,10 +1675,13 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			continue;
 		}
 
-		j++;
-
 		if (hwif->present)
-			ide_port_setup_devices(hwif);
+			if (ide_port_setup_devices(hwif) == 0) {
+				hwif->present = 0;
+				continue;
+			}
+
+		j++;
 
 		ide_acpi_init(hwif);
 
@@ -1682,7 +1689,7 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			ide_acpi_port_init_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL)
@@ -1695,7 +1702,7 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			hwif_register_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL)
@@ -1740,7 +1747,7 @@ void ide_host_free(struct ide_host *host)
 	ide_hwif_t *hwif;
 	int i;
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL)
@@ -1758,7 +1765,7 @@ void ide_host_remove(struct ide_host *host)
 {
 	int i;
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		if (host->ports[i])
 			ide_unregister(host->ports[i]);
 	}
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index e7030a4..b269264 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -227,7 +227,7 @@ static int set_xfer_rate (ide_drive_t *drive, int arg)
 
 ide_devset_rw(current_speed, xfer_rate);
 ide_devset_rw_field(init_speed, init_speed);
-ide_devset_rw_field(nice1, nice1);
+ide_devset_rw_flag(nice1, IDE_DFLAG_NICE1);
 ide_devset_rw_field(number, dn);
 
 static const struct ide_proc_devset ide_generic_settings[] = {
@@ -622,9 +622,7 @@ void ide_proc_port_register_devices(ide_hwif_t *hwif)
 	for (d = 0; d < MAX_DRIVES; d++) {
 		ide_drive_t *drive = &hwif->drives[d];
 
-		if (!drive->present)
-			continue;
-		if (drive->proc)
+		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0 || drive->proc)
 			continue;
 
 		drive->proc = proc_mkdir(drive->name, parent);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index f8c84df..25ac60f 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -172,23 +172,16 @@ typedef struct ide_tape_obj {
 	struct kref	kref;
 
 	/*
-	 *	pc points to the current processed packet command.
-	 *
 	 *	failed_pc points to the last failed packet command, or contains
 	 *	NULL if we do not need to retry any packet command. This is
 	 *	required since an additional packet command is needed before the
 	 *	retry, to get detailed information on what went wrong.
 	 */
-	/* Current packet command */
-	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
 	struct ide_atapi_pc *failed_pc;
 	/* used by REQ_IDETAPE_{READ,WRITE} requests */
 	struct ide_atapi_pc queued_pc;
 
-	struct ide_atapi_pc request_sense_pc;
-	struct request request_sense_rq;
-
 	/*
 	 * DSC polling variables.
 	 *
@@ -274,11 +267,6 @@ static DEFINE_MUTEX(idetape_ref_mutex);
 
 static struct class *idetape_sysfs_class;
 
-#define to_ide_tape(obj) container_of(obj, struct ide_tape_obj, kref)
-
-#define ide_tape_g(disk) \
-	container_of((disk)->private_data, struct ide_tape_obj, driver)
-
 static void ide_tape_release(struct kref *);
 
 static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
@@ -286,7 +274,7 @@ static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
 	struct ide_tape_obj *tape = NULL;
 
 	mutex_lock(&idetape_ref_mutex);
-	tape = ide_tape_g(disk);
+	tape = ide_drv_g(disk, ide_tape_obj);
 	if (tape) {
 		if (ide_device_get(tape->drive))
 			tape = NULL;
@@ -313,8 +301,6 @@ static void ide_tape_put(struct ide_tape_obj *tape)
  */
 static struct ide_tape_obj *idetape_devs[MAX_HWIFS * MAX_DRIVES];
 
-#define ide_tape_f(file) ((file)->private_data)
-
 static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 {
 	struct ide_tape_obj *tape = NULL;
@@ -522,14 +508,19 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	return 0;
 }
 
-static void ide_tape_callback(ide_drive_t *drive)
+static void ide_tape_handle_dsc(ide_drive_t *);
+
+static void ide_tape_callback(ide_drive_t *drive, int dsc)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->pc;
+	struct ide_atapi_pc *pc = drive->pc;
 	int uptodate = pc->error ? 0 : 1;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
+	if (dsc)
+		ide_tape_handle_dsc(drive);
+
 	if (tape->failed_pc == pc)
 		tape->failed_pc = NULL;
 
@@ -558,7 +549,7 @@ static void ide_tape_callback(ide_drive_t *drive)
 		if (pc->error)
 			uptodate = pc->error;
 	} else if (pc->c[0] == READ_POSITION && uptodate) {
-		u8 *readpos = tape->pc->buf;
+		u8 *readpos = pc->buf;
 
 		debug_log(DBG_SENSE, "BOP - %s\n",
 				(readpos[0] & 0x80) ? "Yes" : "No");
@@ -583,31 +574,6 @@ static void ide_tape_callback(ide_drive_t *drive)
 	idetape_end_request(drive, uptodate, 0);
 }
 
-static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
-{
-	ide_init_pc(pc);
-	pc->c[0] = REQUEST_SENSE;
-	pc->c[4] = 20;
-	pc->req_xfer = 20;
-}
-
-/*
- *	idetape_retry_pc is called when an error was detected during the
- *	last packet command. We queue a request sense packet command in
- *	the head of the request list.
- */
-static void idetape_retry_pc(ide_drive_t *drive)
-{
-	struct ide_tape_obj *tape = drive->driver_data;
-	struct request *rq = &tape->request_sense_rq;
-	struct ide_atapi_pc *pc = &tape->request_sense_pc;
-
-	(void)ide_read_error(drive);
-	idetape_create_request_sense_cmd(pc);
-	set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
-	ide_queue_pc_head(drive, tape->disk, pc, rq);
-}
-
 /*
  * Postpone the current request so that ide.c will be able to service requests
  * from another device on the same hwgroup while we are polling for DSC.
@@ -646,34 +612,18 @@ static int ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 }
 
 /*
- * This is the usual interrupt handler which will be called during a packet
- * command. We will transfer some of the data (as requested by the drive) and
- * will re-point interrupt handler to us. When data transfer is finished, we
- * will act according to the algorithm described before
- * idetape_issue_pc.
- */
-static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	return ide_pc_intr(drive, tape->pc, idetape_pc_intr, WAIT_TAPE_CMD,
-			   NULL, idetape_update_buffers, idetape_retry_pc,
-			   ide_tape_handle_dsc, ide_tape_io_buffers);
-}
-
-/*
  * Packet Command Interface
  *
- * The current Packet Command is available in tape->pc, and will not change
+ * The current Packet Command is available in drive->pc, and will not change
  * until we finish handling it. Each packet command is associated with a
  * callback function that will be called when the command is finished.
  *
  * The handling will be done in three stages:
  *
  * 1. idetape_issue_pc will send the packet command to the drive, and will set
- * the interrupt handler to idetape_pc_intr.
+ * the interrupt handler to ide_pc_intr.
  *
- * 2. On each interrupt, idetape_pc_intr will be called. This step will be
+ * 2. On each interrupt, ide_pc_intr will be called. This step will be
  * repeated until the device signals us that no more interrupts will be issued.
  *
  * 3. ATAPI Tape media access commands have immediate status with a delayed
@@ -697,20 +647,13 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
  * again, the callback function will be called and then we will handle the next
  * request.
  */
-static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	return ide_transfer_pc(drive, tape->pc, idetape_pc_intr,
-			       WAIT_TAPE_CMD, NULL);
-}
 
 static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	if (tape->pc->c[0] == REQUEST_SENSE &&
+	if (drive->pc->c[0] == REQUEST_SENSE &&
 	    pc->c[0] == REQUEST_SENSE) {
 		printk(KERN_ERR "ide-tape: possible ide-tape.c bug - "
 			"Two request sense in serial were issued\n");
@@ -718,8 +661,9 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 
 	if (tape->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
 		tape->failed_pc = pc;
+
 	/* Set the current packet command */
-	tape->pc = pc;
+	drive->pc = pc;
 
 	if (pc->retries > IDETAPE_MAX_PC_RETRIES ||
 		(pc->flags & PC_FLAG_ABORT)) {
@@ -743,15 +687,14 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 			pc->error = IDETAPE_ERROR_GENERAL;
 		}
 		tape->failed_pc = NULL;
-		drive->pc_callback(drive);
+		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, pc, idetape_transfer_pc,
-			    WAIT_TAPE_CMD, NULL);
+	return ide_issue_pc(drive, WAIT_TAPE_CMD, NULL);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
@@ -785,7 +728,7 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->pc;
+	struct ide_atapi_pc *pc = drive->pc;
 	u8 stat;
 
 	stat = hwif->tp_ops->read_status(hwif);
@@ -797,7 +740,7 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 				printk(KERN_ERR "ide-tape: %s: I/O error, ",
 						tape->name);
 			/* Retry operation */
-			idetape_retry_pc(drive);
+			ide_retry_pc(drive, tape->disk);
 			return ide_stopped;
 		}
 		pc->error = 0;
@@ -805,7 +748,7 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 		pc->error = IDETAPE_ERROR_GENERAL;
 		tape->failed_pc = NULL;
 	}
-	drive->pc_callback(drive);
+	drive->pc_callback(drive, 0);
 	return ide_stopped;
 }
 
@@ -862,7 +805,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 
 	/* Retry a failed packet command */
-	if (tape->failed_pc && tape->pc->c[0] == REQUEST_SENSE) {
+	if (tape->failed_pc && drive->pc->c[0] == REQUEST_SENSE) {
 		pc = tape->failed_pc;
 		goto out;
 	}
@@ -883,12 +826,13 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 */
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if (!drive->dsc_overlap && !(rq->cmd[13] & REQ_IDETAPE_PC2))
+	if ((drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) == 0 &&
+	    (rq->cmd[13] & REQ_IDETAPE_PC2) == 0)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 
-	if (drive->post_reset == 1) {
+	if (drive->dev_flags & IDE_DFLAG_POST_RESET) {
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
-		drive->post_reset = 0;
+		drive->dev_flags &= ~IDE_DFLAG_POST_RESET;
 	}
 
 	if (!test_and_clear_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags) &&
@@ -1411,7 +1355,7 @@ static int idetape_init_read(ide_drive_t *drive)
 		 * No point in issuing this if DSC overlap isn't supported, some
 		 * drives (Seagate STT3401A) will return an error.
 		 */
-		if (drive->dsc_overlap) {
+		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
 			bytes_read = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_READ, 0,
 							tape->merge_bh);
@@ -1592,7 +1536,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 				   size_t count, loff_t *ppos)
 {
-	struct ide_tape_obj *tape = ide_tape_f(file);
+	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
 	ssize_t bytes_read, temp, actually_read = 0, rc;
 	ssize_t ret = 0;
@@ -1654,7 +1598,7 @@ finish:
 static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 				     size_t count, loff_t *ppos)
 {
-	struct ide_tape_obj *tape = ide_tape_f(file);
+	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
 	ssize_t actually_written = 0;
 	ssize_t ret = 0;
@@ -1687,7 +1631,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		 * point in issuing this if DSC overlap isn't supported, some
 		 * drives (Seagate STT3401A) will return an error.
 		 */
-		if (drive->dsc_overlap) {
+		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
 			ssize_t retval = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_WRITE, 0,
 							tape->merge_bh);
@@ -1886,7 +1830,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
-	struct ide_tape_obj *tape = ide_tape_f(file);
+	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
 	struct mtop mtop;
 	struct mtget mtget;
@@ -2063,7 +2007,7 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 
 static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 {
-	struct ide_tape_obj *tape = ide_tape_f(filp);
+	struct ide_tape_obj *tape = filp->private_data;
 	ide_drive_t *drive = tape->drive;
 	unsigned int minor = iminor(inode);
 
@@ -2202,7 +2146,7 @@ static int divf_tdsc(ide_drive_t *drive)	{ return   HZ; }
 static int divf_buffer(ide_drive_t *drive)	{ return    2; }
 static int divf_buffer_size(ide_drive_t *drive)	{ return 1024; }
 
-ide_devset_rw_field(dsc_overlap, dsc_overlap);
+ide_devset_rw_flag(dsc_overlap, IDE_DFLAG_DSC_OVERLAP);
 
 ide_tape_devset_rw_field(debug_mask, debug_mask);
 ide_tape_devset_rw_field(tdsc, best_dsc_rw_freq);
@@ -2241,33 +2185,32 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	unsigned long t;
 	int speed;
 	int buffer_size;
-	u8 gcw[2];
 	u16 *ctl = (u16 *)&tape->caps[12];
 
-	drive->pc_callback = ide_tape_callback;
+	drive->pc_callback	 = ide_tape_callback;
+	drive->pc_update_buffers = idetape_update_buffers;
+	drive->pc_io_buffers	 = ide_tape_io_buffers;
 
 	spin_lock_init(&tape->lock);
-	drive->dsc_overlap = 1;
+
+	drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
+
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_DSC) {
 		printk(KERN_INFO "ide-tape: %s: disabling DSC overlap\n",
 				 tape->name);
-		drive->dsc_overlap = 0;
+		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	}
+
 	/* Seagate Travan drives do not support DSC overlap. */
 	if (strstr((char *)&drive->id[ATA_ID_PROD], "Seagate STT3401"))
-		drive->dsc_overlap = 0;
+		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
+
 	tape->minor = minor;
 	tape->name[0] = 'h';
 	tape->name[1] = 't';
 	tape->name[2] = '0' + minor;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
-	*((u16 *)&gcw) = drive->id[ATA_ID_CONFIG];
-
-	/* Command packet DRQ type */
-	if (((gcw[0] & 0x60) >> 5) == 1)
-		set_bit(IDE_AFLAG_DRQ_INTERRUPT, &drive->atapi_flags);
-
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
@@ -2302,7 +2245,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		(*(u16 *)&tape->caps[16] * 512) / tape->buffer_size,
 		tape->buffer_size / 1024,
 		tape->best_dsc_rw_freq * 1000 / HZ,
-		drive->using_dma ? ", DMA":"");
+		(drive->dev_flags & IDE_DFLAG_USING_DMA) ? ", DMA" : "");
 
 	ide_proc_register_driver(drive, tape->driver);
 }
@@ -2320,13 +2263,13 @@ static void ide_tape_remove(ide_drive_t *drive)
 
 static void ide_tape_release(struct kref *kref)
 {
-	struct ide_tape_obj *tape = to_ide_tape(kref);
+	struct ide_tape_obj *tape = to_ide_drv(kref, ide_tape_obj);
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
 	BUG_ON(tape->merge_bh_size);
 
-	drive->dsc_overlap = 0;
+	drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	drive->driver_data = NULL;
 	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor));
 	device_destroy(idetape_sysfs_class,
@@ -2368,7 +2311,6 @@ static ide_driver_t idetape_driver = {
 	.probe			= ide_tape_probe,
 	.remove			= ide_tape_remove,
 	.version		= IDETAPE_VERSION,
-	.media			= ide_tape,
 	.do_request		= idetape_do_request,
 	.end_request		= idetape_end_request,
 	.error			= __ide_error,
@@ -2403,7 +2345,7 @@ static int idetape_open(struct inode *inode, struct file *filp)
 static int idetape_release(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_tape_obj *tape = ide_tape_g(disk);
+	struct ide_tape_obj *tape = ide_drv_g(disk, ide_tape_obj);
 
 	ide_tape_put(tape);
 
@@ -2414,7 +2356,7 @@ static int idetape_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
-	struct ide_tape_obj *tape = ide_tape_g(bdev->bd_disk);
+	struct ide_tape_obj *tape = ide_drv_g(bdev->bd_disk, ide_tape_obj);
 	ide_drive_t *drive = tape->drive;
 	int err = generic_ide_ioctl(drive, file, bdev, cmd, arg);
 	if (err == -EINVAL)
@@ -2441,7 +2383,8 @@ static int ide_tape_probe(ide_drive_t *drive)
 	if (drive->media != ide_tape)
 		goto failed;
 
-	if (drive->id_read == 1 && !ide_check_atapi_device(drive, DRV_NAME)) {
+	if ((drive->dev_flags & IDE_DFLAG_ID_READ) &&
+	    ide_check_atapi_device(drive, DRV_NAME) == 0) {
 		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
 				" the driver\n", drive->name);
 		goto failed;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 487b18b..bf4fb9d 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -53,9 +53,6 @@ int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
 }
 
 static ide_startstop_t task_no_data_intr(ide_drive_t *);
-static ide_startstop_t set_geometry_intr(ide_drive_t *);
-static ide_startstop_t recal_intr(ide_drive_t *);
-static ide_startstop_t set_multmode_intr(ide_drive_t *);
 static ide_startstop_t pre_task_out_intr(ide_drive_t *, struct request *);
 static ide_startstop_t task_in_intr(ide_drive_t *);
 
@@ -79,6 +76,8 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		task->tf_flags |= IDE_TFLAG_FLAGGED_SET_IN_FLAGS;
 
+	memcpy(&hwif->task, task, sizeof(*task));
+
 	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
 		tp_ops->set_irq(hwif, 1);
@@ -99,24 +98,12 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 	case TASKFILE_NO_DATA:
 		if (handler == NULL)
 			handler = task_no_data_intr;
-		if (task->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) {
-			switch (tf->command) {
-			case ATA_CMD_INIT_DEV_PARAMS:
-				handler = set_geometry_intr;
-				break;
-			case ATA_CMD_RESTORE:
-				handler = recal_intr;
-				break;
-			case ATA_CMD_SET_MULTI:
-				handler = set_multmode_intr;
-				break;
-			}
-		}
 		ide_execute_command(drive, tf->command, handler,
 				    WAIT_WORSTCASE, NULL);
 		return ide_started;
 	default:
-		if (drive->using_dma == 0 || dma_ops->dma_setup(drive))
+		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
+		    dma_ops->dma_setup(drive))
 			return ide_stopped;
 		dma_ops->dma_exec_cmd(drive, tf->command);
 		dma_ops->dma_start(drive);
@@ -126,33 +113,15 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 EXPORT_SYMBOL_GPL(do_rw_taskfile);
 
 /*
- * set_multmode_intr() is invoked on completion of a ATA_CMD_SET_MULTI cmd.
- */
-static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 stat;
-
-	local_irq_enable_in_hardirq();
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (OK_STAT(stat, ATA_DRDY, BAD_STAT))
-		drive->mult_count = drive->mult_req;
-	else {
-		drive->mult_req = drive->mult_count = 0;
-		drive->special.b.recalibrate = 1;
-		(void) ide_dump_status(drive, "set_multmode", stat);
-	}
-	return ide_stopped;
-}
-
-/*
- * set_geometry_intr() is invoked on completion of a ATA_CMD_INIT_DEV_PARAMS cmd.
+ * Handler for commands without a data phase
  */
-static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
+static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	int retries = 5;
+	ide_task_t *task = &hwif->task;
+	struct ide_taskfile *tf = &task->tf;
+	int custom = (task->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) ? 1 : 0;
+	int retries = (custom && tf->command == ATA_CMD_INIT_DEV_PARAMS) ? 5 : 1;
 	u8 stat;
 
 	local_irq_enable_in_hardirq();
@@ -164,50 +133,36 @@ static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 		udelay(10);
 	};
 
-	if (OK_STAT(stat, ATA_DRDY, BAD_STAT))
-		return ide_stopped;
-
-	if (stat & (ATA_ERR | ATA_DRQ))
-		return ide_error(drive, "set_geometry_intr", stat);
-
-	ide_set_handler(drive, &set_geometry_intr, WAIT_WORSTCASE, NULL);
-	return ide_started;
-}
-
-/*
- * recal_intr() is invoked on completion of a ATA_CMD_RESTORE (recalibrate) cmd.
- */
-static ide_startstop_t recal_intr(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 stat;
-
-	local_irq_enable_in_hardirq();
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT))
-		return ide_error(drive, "recal_intr", stat);
-	return ide_stopped;
-}
-
-/*
- * Handler for commands without a data phase
- */
-static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t *args = hwif->hwgroup->rq->special;
-	u8 stat;
-
-	local_irq_enable_in_hardirq();
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT))
+	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
+		if (custom && tf->command == ATA_CMD_SET_MULTI) {
+			drive->mult_req = drive->mult_count = 0;
+			drive->special.b.recalibrate = 1;
+			(void)ide_dump_status(drive, __func__, stat);
+			return ide_stopped;
+		} else if (custom && tf->command == ATA_CMD_INIT_DEV_PARAMS) {
+			if ((stat & (ATA_ERR | ATA_DRQ)) == 0) {
+				ide_set_handler(drive, &task_no_data_intr,
+						WAIT_WORSTCASE, NULL);
+				return ide_started;
+			}
+		}
 		return ide_error(drive, "task_no_data_intr", stat);
 		/* calls ide_end_drive_cmd */
+	}
 
-	if (args)
+	if (!custom)
+		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
+	else if (tf->command == ATA_CMD_IDLEIMMEDIATE) {
+		hwif->tp_ops->tf_read(drive, task);
+		if (tf->lbal != 0xc4) {
+			printk(KERN_ERR "%s: head unload failed!\n",
+			       drive->name);
+			ide_tf_dump(drive->name, tf);
+		} else
+			drive->dev_flags |= IDE_DFLAG_PARKED;
 		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
+	} else if (tf->command == ATA_CMD_SET_MULTI)
+		drive->mult_count = drive->mult_req;
 
 	return ide_stopped;
 }
@@ -469,13 +424,12 @@ static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
-				drive->name,
-				drive->hwif->data_phase ? "MULT" : "",
-				drive->addressing ? "_EXT" : "");
+			drive->name, drive->hwif->data_phase ? "MULT" : "",
+			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
 	}
 
-	if (!drive->unmask)
+	if ((drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
 		local_irq_disable();
 
 	ide_set_handler(drive, &task_out_intr, WAIT_WORSTCASE, NULL);
@@ -591,7 +545,7 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 
 	args.tf_flags = IDE_TFLAG_IO_16BIT | IDE_TFLAG_DEVICE |
 			IDE_TFLAG_IN_TF;
-	if (drive->addressing == 1)
+	if (drive->dev_flags & IDE_DFLAG_LBA48)
 		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_IN_HOB);
 
 	if (req_task->out_flags.all) {
@@ -694,7 +648,7 @@ int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 	if ((args.tf_flags & IDE_TFLAG_FLAGGED_SET_IN_FLAGS) &&
 	    req_task->in_flags.all == 0) {
 		req_task->in_flags.all = IDE_TASKFILE_STD_IN_FLAGS;
-		if (drive->addressing == 1)
+		if (drive->dev_flags & IDE_DFLAG_LBA48)
 			req_task->in_flags.all |= (IDE_HOB_STD_IN_FLAGS << 8);
 	}
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 9dcf5ae..04f8f13 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -114,7 +114,7 @@ static void ide_port_init_devices_data(ide_hwif_t *hwif)
 		memset(drive, 0, sizeof(*drive));
 
 		drive->media			= ide_disk;
-		drive->select.all		= (unit<<4)|0xa0;
+		drive->select			= (unit << 4) | ATA_DEVICE_OBS;
 		drive->hwif			= hwif;
 		drive->ready_stat		= ATA_DRDY;
 		drive->bad_wstat		= BAD_W_STAT;
@@ -138,7 +138,7 @@ static void __ide_port_unregister_devices(ide_hwif_t *hwif)
 	for (i = 0; i < MAX_DRIVES; i++) {
 		ide_drive_t *drive = &hwif->drives[i];
 
-		if (drive->present) {
+		if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 			spin_unlock_irq(&ide_lock);
 			device_unregister(&drive->gendev);
 			wait_for_completion(&drive->gendev_rel_comp);
@@ -227,8 +227,7 @@ void ide_unregister(ide_hwif_t *hwif)
 	kfree(hwif->sg_table);
 	unregister_blkdev(hwif->major, hwif->name);
 
-	if (hwif->dma_base)
-		ide_release_dma_engine(hwif);
+	ide_release_dma_engine(hwif);
 
 	mutex_unlock(&ide_cfg_mtx);
 }
@@ -254,7 +253,7 @@ ide_devset_get(io_32bit, io_32bit);
 
 static int set_io_32bit(ide_drive_t *drive, int arg)
 {
-	if (drive->no_io_32bit)
+	if (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT)
 		return -EPERM;
 
 	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
@@ -265,19 +264,22 @@ static int set_io_32bit(ide_drive_t *drive, int arg)
 	return 0;
 }
 
-ide_devset_get(ksettings, keep_settings);
+ide_devset_get_flag(ksettings, IDE_DFLAG_KEEP_SETTINGS);
 
 static int set_ksettings(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	drive->keep_settings = arg;
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_KEEP_SETTINGS;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_KEEP_SETTINGS;
 
 	return 0;
 }
 
-ide_devset_get(using_dma, using_dma);
+ide_devset_get_flag(using_dma, IDE_DFLAG_USING_DMA);
 
 static int set_using_dma(ide_drive_t *drive, int arg)
 {
@@ -311,9 +313,32 @@ out:
 #endif
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
 static int set_pio_mode(ide_drive_t *drive, int arg)
 {
-	struct request *rq;
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 
@@ -324,56 +349,65 @@ static int set_pio_mode(ide_drive_t *drive, int arg)
 	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return -ENOSYS;
 
-	if (drive->special.b.set_tune)
-		return -EBUSY;
+	if (set_pio_mode_abuse(drive->hwif, arg)) {
+		if (arg == 8 || arg == 9) {
+			unsigned long flags;
 
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+			/* take lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT */
+			spin_lock_irqsave(&ide_lock, flags);
+			port_ops->set_pio_mode(drive, arg);
+			spin_unlock_irqrestore(&ide_lock, flags);
+		} else
+			port_ops->set_pio_mode(drive, arg);
+	} else {
+		int keep_dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
-	drive->tune_req = (u8) arg;
-	drive->special.b.set_tune = 1;
+		ide_set_pio(drive, arg);
 
-	blk_execute_rq(drive->queue, NULL, rq, 0);
-	blk_put_request(rq);
+		if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
+			if (keep_dma)
+				ide_dma_on(drive);
+		}
+	}
 
 	return 0;
 }
 
-ide_devset_get(unmaskirq, unmask);
+ide_devset_get_flag(unmaskirq, IDE_DFLAG_UNMASK);
 
 static int set_unmaskirq(ide_drive_t *drive, int arg)
 {
-	if (drive->no_unmask)
+	if (drive->dev_flags & IDE_DFLAG_NO_UNMASK)
 		return -EPERM;
 
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
 
-	drive->unmask = arg;
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_UNMASK;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 
 	return 0;
 }
 
-#define ide_gen_devset_rw(_name, _func) \
-__IDE_DEVSET(_name, DS_SYNC, get_##_func, set_##_func)
-
-ide_gen_devset_rw(io_32bit, io_32bit);
-ide_gen_devset_rw(keepsettings, ksettings);
-ide_gen_devset_rw(unmaskirq, unmaskirq);
-ide_gen_devset_rw(using_dma, using_dma);
-__IDE_DEVSET(pio_mode, 0, NULL, set_pio_mode);
+ide_ext_devset_rw_sync(io_32bit, io_32bit);
+ide_ext_devset_rw_sync(keepsettings, ksettings);
+ide_ext_devset_rw_sync(unmaskirq, unmaskirq);
+ide_ext_devset_rw_sync(using_dma, using_dma);
+__IDE_DEVSET(pio_mode, DS_SYNC, NULL, set_pio_mode);
 
 static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
-	ide_drive_t *drive = dev->driver_data;
+	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = HWIF(drive);
 	struct request *rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
 	int ret;
 
-	/* Call ACPI _GTM only once */
-	if (!(drive->dn % 2))
+	/* call ACPI _GTM only once */
+	if ((drive->dn & 1) == 0 || pair == NULL)
 		ide_acpi_get_timing(hwif);
 
 	memset(&rqpm, 0, sizeof(rqpm));
@@ -382,33 +416,32 @@ static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
 	rq->special = &args;
 	rq->data = &rqpm;
-	rqpm.pm_step = ide_pm_state_start_suspend;
+	rqpm.pm_step = IDE_PM_START_SUSPEND;
 	if (mesg.event == PM_EVENT_PRETHAW)
 		mesg.event = PM_EVENT_FREEZE;
 	rqpm.pm_state = mesg.event;
 
 	ret = blk_execute_rq(drive->queue, NULL, rq, 0);
 	blk_put_request(rq);
-	/* only call ACPI _PS3 after both drivers are suspended */
-	if (!ret && (((drive->dn % 2) && hwif->drives[0].present
-		 && hwif->drives[1].present)
-		 || !hwif->drives[0].present
-		 || !hwif->drives[1].present))
+
+	/* call ACPI _PS3 only after both devices are suspended */
+	if (ret == 0 && ((drive->dn & 1) || pair == NULL))
 		ide_acpi_set_state(hwif, 0);
+
 	return ret;
 }
 
 static int generic_ide_resume(struct device *dev)
 {
-	ide_drive_t *drive = dev->driver_data;
+	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = HWIF(drive);
 	struct request *rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
 	int err;
 
-	/* Call ACPI _STM only once */
-	if (!(drive->dn % 2)) {
+	/* call ACPI _PS0 / _STM only once */
+	if ((drive->dn & 1) == 0 || pair == NULL) {
 		ide_acpi_set_state(hwif, 1);
 		ide_acpi_push_timing(hwif);
 	}
@@ -422,7 +455,7 @@ static int generic_ide_resume(struct device *dev)
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->special = &args;
 	rq->data = &rqpm;
-	rqpm.pm_step = ide_pm_state_start_resume;
+	rqpm.pm_step = IDE_PM_START_RESUME;
 	rqpm.pm_state = PM_EVENT_ON;
 
 	err = blk_execute_rq(drive->queue, NULL, rq, 1);
@@ -554,6 +587,7 @@ static struct device_attribute ide_dev_attrs[] = {
 	__ATTR_RO(model),
 	__ATTR_RO(firmware),
 	__ATTR(serial, 0400, serial_show, NULL),
+	__ATTR(unload_heads, 0644, ide_park_show, ide_park_store),
 	__ATTR_NULL
 };
 
@@ -708,22 +742,22 @@ static int ide_set_disk_chs(const char *str, struct kernel_param *kp)
 module_param_call(chs, ide_set_disk_chs, NULL, NULL, 0);
 MODULE_PARM_DESC(chs, "force device as a disk (using CHS)");
 
-static void ide_dev_apply_params(ide_drive_t *drive)
+static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
 {
-	int i = drive->hwif->index * MAX_DRIVES + drive->select.b.unit;
+	int i = drive->hwif->index * MAX_DRIVES + unit;
 
 	if (ide_nodma & (1 << i)) {
 		printk(KERN_INFO "ide: disallowing DMA for %s\n", drive->name);
-		drive->nodma = 1;
+		drive->dev_flags |= IDE_DFLAG_NODMA;
 	}
 	if (ide_noflush & (1 << i)) {
 		printk(KERN_INFO "ide: disabling flush requests for %s\n",
 				 drive->name);
-		drive->noflush = 1;
+		drive->dev_flags |= IDE_DFLAG_NOFLUSH;
 	}
 	if (ide_noprobe & (1 << i)) {
 		printk(KERN_INFO "ide: skipping probe for %s\n", drive->name);
-		drive->noprobe = 1;
+		drive->dev_flags |= IDE_DFLAG_NOPROBE;
 	}
 	if (ide_nowerr & (1 << i)) {
 		printk(KERN_INFO "ide: ignoring the ATA_DF bit for %s\n",
@@ -732,7 +766,7 @@ static void ide_dev_apply_params(ide_drive_t *drive)
 	}
 	if (ide_cdroms & (1 << i)) {
 		printk(KERN_INFO "ide: forcing %s as a CD-ROM\n", drive->name);
-		drive->present = 1;
+		drive->dev_flags |= IDE_DFLAG_PRESENT;
 		drive->media = ide_cdrom;
 		/* an ATAPI device ignores DRDY */
 		drive->ready_stat = 0;
@@ -741,11 +775,12 @@ static void ide_dev_apply_params(ide_drive_t *drive)
 		drive->cyl  = drive->bios_cyl  = ide_disks_chs[i].cyl;
 		drive->head = drive->bios_head = ide_disks_chs[i].head;
 		drive->sect = drive->bios_sect = ide_disks_chs[i].sect;
-		drive->forced_geom = 1;
+
 		printk(KERN_INFO "ide: forcing %s as a disk (%d/%d/%d)\n",
 				 drive->name,
 				 drive->cyl, drive->head, drive->sect);
-		drive->present = 1;
+
+		drive->dev_flags |= IDE_DFLAG_FORCED_GEOM | IDE_DFLAG_PRESENT;
 		drive->media = ide_disk;
 		drive->ready_stat = ATA_DRDY;
 	}
@@ -785,7 +820,7 @@ void ide_port_apply_params(ide_hwif_t *hwif)
 	}
 
 	for (i = 0; i < MAX_DRIVES; i++)
-		ide_dev_apply_params(&hwif->drives[i]);
+		ide_dev_apply_params(&hwif->drives[i], i);
 }
 
 /*
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 7276c96..90da1f9 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -131,7 +131,7 @@ static void ali14xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		drive->name, pio, time1, time2, param1, param2, param3, param4);
 
 	/* stuff timing parameters into controller registers */
-	driveNum = (HWIF(drive)->index << 1) + drive->select.b.unit;
+	driveNum = (drive->hwif->index << 1) + (drive->dn & 1);
 	spin_lock_irqsave(&ali14xx_lock, flags);
 	outb_p(regOn, basePort);
 	outReg(param1, regTab[driveNum].reg1);
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 5123ea2..c7e5c22 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -120,7 +120,8 @@ static void ht6560b_selectproc (ide_drive_t *drive)
 	 * Need to enforce prefetch sometimes because otherwise
 	 * it'll hang (hard).
 	 */
-	if (drive->media != ide_disk || !drive->present)
+	if (drive->media != ide_disk ||
+	    (drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 		select |= HT_PREFETCH_MODE;
 
 	if (select != current_select || timing != current_timing) {
@@ -249,11 +250,11 @@ static void ht_set_prefetch(ide_drive_t *drive, u8 state)
 	 */
 	if (state) {
 		drive->drive_data |= t;   /* enable prefetch mode */
-		drive->no_unmask = 1;
-		drive->unmask = 0;
+		drive->dev_flags |= IDE_DFLAG_NO_UNMASK;
+		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 	} else {
 		drive->drive_data &= ~t;  /* disable prefetch mode */
-		drive->no_unmask = 0;
+		drive->dev_flags &= ~IDE_DFLAG_NO_UNMASK;
 	}
 
 	spin_unlock_irqrestore(&ht6560b_lock, flags);
diff --git a/drivers/ide/legacy/ide-4drives.c b/drivers/ide/legacy/ide-4drives.c
index c76d55d..9e85b1e 100644
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -14,7 +14,7 @@ MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
 static void ide_4drives_init_dev(ide_drive_t *drive)
 {
 	if (drive->hwif->channel)
-		drive->select.all ^= 0x20;
+		drive->select ^= 0x20;
 }
 
 static const struct ide_port_ops ide_4drives_port_ops = {
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index ec408b3..bc27c7a 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -305,7 +305,7 @@ static void __init qd6580_init_dev(ide_drive_t *drive)
 	} else
 		t2 = t1 = hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA;
 
-	drive->drive_data = drive->select.b.unit ? t2 : t1;
+	drive->drive_data = (drive->dn & 1) ? t2 : t1;
 }
 
 static const struct ide_port_ops qd6500_port_ops = {
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 11b7f61..0ec8fd1 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -322,11 +322,7 @@ static int auide_dma_setup(ide_drive_t *drive)
 }
 
 static int auide_dma_test_irq(ide_drive_t *drive)
-{	
-	if (drive->waiting_for_dma == 0)
-		printk(KERN_WARNING "%s: ide_dma_test_irq \
-                                     called while not waiting\n", drive->name);
-
+{
 	/* If dbdma didn't execute the STOP command yet, the
 	 * active bit is still set
 	 */
@@ -344,11 +340,6 @@ static void auide_dma_host_set(ide_drive_t *drive, int on)
 {
 }
 
-static void auide_dma_lost_irq(ide_drive_t *drive)
-{
-	printk(KERN_ERR "%s: IRQ lost\n", drive->name);
-}
-
 static void auide_ddma_tx_callback(int irq, void *param)
 {
 	_auide_hwif *ahwif = (_auide_hwif*)param;
@@ -375,18 +366,6 @@ static void auide_init_dbdma_dev(dbdev_tab_t *dev, u32 dev_id, u32 tsize, u32 de
 }
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-static void auide_dma_timeout(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-
-	printk(KERN_ERR "%s: DMA timeout occurred: ", drive->name);
-
-	if (auide_dma_test_irq(drive))
-		return;
-
-	auide_dma_end(drive);
-}
-
 static const struct ide_dma_ops au1xxx_dma_ops = {
 	.dma_host_set		= auide_dma_host_set,
 	.dma_setup		= auide_dma_setup,
@@ -394,8 +373,8 @@ static const struct ide_dma_ops au1xxx_dma_ops = {
 	.dma_start		= auide_dma_start,
 	.dma_end		= auide_dma_end,
 	.dma_test_irq		= auide_dma_test_irq,
-	.dma_lost_irq		= auide_dma_lost_irq,
-	.dma_timeout		= auide_dma_timeout,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
@@ -448,10 +427,9 @@ static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 							     NUM_DESCRIPTORS);
 	auide->rx_desc_head = (void*)au1xxx_dbdma_ring_alloc(auide->rx_chan,
 							     NUM_DESCRIPTORS);
- 
-	hwif->dmatable_cpu = dma_alloc_coherent(hwif->dev,
-						PRD_ENTRIES * PRD_BYTES,        /* 1 Page */
-						&hwif->dmatable_dma, GFP_KERNEL);
+
+	/* FIXME: check return value */
+	(void)ide_allocate_dma_engine(hwif);
 	
 	au1xxx_dbdma_start( auide->tx_chan );
 	au1xxx_dbdma_start( auide->rx_chan );
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index e7475ba..4142c69 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -115,7 +115,7 @@ static void aec6260_set_mode(ide_drive_t *drive, const u8 speed)
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
 	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
-	u8 unit		= (drive->select.b.unit & 0x01);
+	u8 unit			= drive->dn & 1;
 	u8 tmp1 = 0, tmp2 = 0;
 	u8 ultra = 0, drive_conf = 0, ultra_conf = 0;
 	unsigned long flags;
@@ -302,7 +302,7 @@ static const struct pci_device_id aec62xx_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, aec62xx_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver aec62xx_pci_driver = {
 	.name		= "AEC62xx_IDE",
 	.id_table	= aec62xx_pci_tbl,
 	.probe		= aec62xx_init_one,
@@ -313,12 +313,12 @@ static struct pci_driver driver = {
 
 static int __init aec62xx_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&aec62xx_pci_driver);
 }
 
 static void __exit aec62xx_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&aec62xx_pci_driver);
 }
 
 module_init(aec62xx_ide_init);
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 053c752..daf9dce 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -77,8 +77,7 @@ static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	int port = hwif->channel ? 0x5c : 0x58;
 	int portFIFO = hwif->channel ? 0x55 : 0x54;
-	u8 cd_dma_fifo = 0;
-	int unit = drive->select.b.unit & 1;
+	u8 cd_dma_fifo = 0, unit = drive->dn & 1;
 
 	if ((s_clc = (s_time * bus_speed + 999) / 1000) >= 8)
 		s_clc = 0;
@@ -112,7 +111,7 @@ static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	}
 	
 	pci_write_config_byte(dev, port, s_clc);
-	pci_write_config_byte(dev, port+drive->select.b.unit+2, (a_clc << 4) | r_clc);
+	pci_write_config_byte(dev, port + unit + 2, (a_clc << 4) | r_clc);
 	local_irq_restore(flags);
 }
 
@@ -154,7 +153,7 @@ static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 speed1		= speed;
-	u8 unit			= (drive->select.b.unit & 0x01);
+	u8 unit			= drive->dn & 1;
 	u8 tmpbyte		= 0x00;
 	int m5229_udma		= (hwif->channel) ? 0x57 : 0x56;
 
@@ -508,7 +507,7 @@ static const struct ide_dma_ops ali_dma_ops = {
 	.dma_setup		= ali15x3_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
@@ -576,7 +575,7 @@ static const struct pci_device_id alim15x3_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, alim15x3_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver alim15x3_pci_driver = {
 	.name		= "ALI15x3_IDE",
 	.id_table	= alim15x3_pci_tbl,
 	.probe		= alim15x3_init_one,
@@ -587,12 +586,12 @@ static struct pci_driver driver = {
 
 static int __init ali15x3_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&alim15x3_pci_driver);
 }
 
 static void __exit ali15x3_ide_exit(void)
 {
-	return pci_unregister_driver(&driver);
+	return pci_unregister_driver(&alim15x3_pci_driver);
 }
 
 module_init(ali15x3_ide_init);
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 824471f..81ec731 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -92,7 +92,7 @@ static void amd_set_drive(ide_drive_t *drive, const u8 speed)
 
 	ide_timing_compute(drive, speed, &t, T, UT);
 
-	if (peer->present) {
+	if (peer->dev_flags & IDE_DFLAG_PRESENT) {
 		ide_timing_compute(peer, peer->current_speed, &p, T, UT);
 		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
 	}
@@ -319,7 +319,7 @@ static const struct pci_device_id amd74xx_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, amd74xx_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver amd74xx_pci_driver = {
 	.name		= "AMD_IDE",
 	.id_table	= amd74xx_pci_tbl,
 	.probe		= amd74xx_probe,
@@ -330,12 +330,12 @@ static struct pci_driver driver = {
 
 static int __init amd74xx_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&amd74xx_pci_driver);
 }
 
 static void __exit amd74xx_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&amd74xx_pci_driver);
 }
 
 module_init(amd74xx_ide_init);
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index e443703..b2735d2 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -182,7 +182,7 @@ static const struct pci_device_id atiixp_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver atiixp_pci_driver = {
 	.name		= "ATIIXP_IDE",
 	.id_table	= atiixp_pci_tbl,
 	.probe		= atiixp_init_one,
@@ -193,12 +193,12 @@ static struct pci_driver driver = {
 
 static int __init atiixp_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&atiixp_pci_driver);
 }
 
 static void __exit atiixp_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&atiixp_pci_driver);
 }
 
 module_init(atiixp_ide_init);
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index 7f39cdb..e430664 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -378,13 +378,13 @@ static void __set_prefetch_mode(ide_drive_t *drive, int mode)
 {
 	if (mode) {	/* want prefetch on? */
 #if CMD640_PREFETCH_MASKS
-		drive->no_unmask = 1;
-		drive->unmask = 0;
+		drive->dev_flags |= IDE_DFLAG_NO_UNMASK;
+		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 #endif
-		drive->no_io_32bit = 0;
+		drive->dev_flags &= ~IDE_DFLAG_NO_IO_32BIT;
 	} else {
-		drive->no_unmask = 0;
-		drive->no_io_32bit = 1;
+		drive->dev_flags &= ~IDE_DFLAG_NO_UNMASK;
+		drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
 		drive->io_32bit = 0;
 	}
 }
@@ -468,10 +468,10 @@ static void program_drive_counts(ide_drive_t *drive, unsigned int index)
 	 */
 	if (index > 1) {
 		ide_hwif_t *hwif = drive->hwif;
-		ide_drive_t *peer = &hwif->drives[!drive->select.b.unit];
+		ide_drive_t *peer = &hwif->drives[!(drive->dn & 1)];
 		unsigned int mate = index ^ 1;
 
-		if (peer->present) {
+		if (peer->dev_flags & IDE_DFLAG_PRESENT) {
 			if (setup_count < setup_counts[mate])
 				setup_count = setup_counts[mate];
 			if (active_count < active_counts[mate])
@@ -607,7 +607,7 @@ static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static void cmd640_init_dev(ide_drive_t *drive)
 {
-	unsigned int i = drive->hwif->channel * 2 + drive->select.b.unit;
+	unsigned int i = drive->hwif->channel * 2 + (drive->dn & 1);
 
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 	/*
@@ -626,7 +626,7 @@ static void cmd640_init_dev(ide_drive_t *drive)
 	 */
 	check_prefetch(drive, i);
 	printk(KERN_INFO DRV_NAME ": drive%d timings/prefetch(%s) preserved\n",
-				  i, drive->no_io_32bit ? "off" : "on");
+		i, (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT) ? "off" : "on");
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 }
 
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 456dee1..935385c 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -228,7 +228,7 @@ static int cmd648_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
-	int err			= __ide_dma_end(drive);
+	int err			= ide_dma_end(drive);
 	u8  irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
 						  MRDMODE_INTR_CH0;
 	u8  mrdmode		= inb(base + 1);
@@ -248,7 +248,7 @@ static int cmd64x_dma_end(ide_drive_t *drive)
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
 						  CFR_INTR_CH0;
 	u8  irq_stat		= 0;
-	int err			= __ide_dma_end(drive);
+	int err			= ide_dma_end(drive);
 
 	(void) pci_read_config_byte(dev, irq_reg, &irq_stat);
 	/* clear the interrupt bit */
@@ -505,7 +505,7 @@ static const struct pci_device_id cmd64x_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, cmd64x_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver cmd64x_pci_driver = {
 	.name		= "CMD64x_IDE",
 	.id_table	= cmd64x_pci_tbl,
 	.probe		= cmd64x_init_one,
@@ -516,12 +516,12 @@ static struct pci_driver driver = {
 
 static int __init cmd64x_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&cmd64x_pci_driver);
 }
 
 static void __exit cmd64x_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&cmd64x_pci_driver);
 }
 
 module_init(cmd64x_ide_init);
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index d6341f7..5efb467 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -145,7 +145,7 @@ static const struct pci_device_id cs5520_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, cs5520_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver cs5520_pci_driver = {
 	.name		= "Cyrix_IDE",
 	.id_table	= cs5520_pci_tbl,
 	.probe		= cs5520_init_one,
@@ -155,7 +155,7 @@ static struct pci_driver driver = {
 
 static int __init cs5520_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&cs5520_pci_driver);
 }
 
 module_init(cs5520_ide_init);
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index da42fa7..53f079c 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -267,7 +267,7 @@ static const struct pci_device_id cs5530_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, cs5530_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver cs5530_pci_driver = {
 	.name		= "CS5530 IDE",
 	.id_table	= cs5530_pci_tbl,
 	.probe		= cs5530_init_one,
@@ -278,12 +278,12 @@ static struct pci_driver driver = {
 
 static int __init cs5530_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&cs5530_pci_driver);
 }
 
 static void __exit cs5530_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&cs5530_pci_driver);
 }
 
 module_init(cs5530_ide_init);
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 1e5bc59..983d957 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -76,7 +76,7 @@ static unsigned int cs5535_udma_timings[5] =
 static void cs5535_set_speed(ide_drive_t *drive, const u8 speed)
 {
 	u32 reg = 0, dummy;
-	int unit = drive->select.b.unit;
+	u8 unit = drive->dn & 1;
 
 	/* Set the PIO timings */
 	if (speed < XFER_SW_DMA_0) {
@@ -192,7 +192,7 @@ static const struct pci_device_id cs5535_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, cs5535_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver cs5535_pci_driver = {
 	.name		= "CS5535_IDE",
 	.id_table	= cs5535_pci_tbl,
 	.probe		= cs5535_init_one,
@@ -203,12 +203,12 @@ static struct pci_driver driver = {
 
 static int __init cs5535_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&cs5535_pci_driver);
 }
 
 static void __exit cs5535_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&cs5535_pci_driver);
 }
 
 module_init(cs5535_ide_init);
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index 69820e9..5297f07 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -50,18 +50,11 @@
 
 #define DRV_NAME "cy82c693"
 
-/* the current version */
-#define CY82_VERSION	"CY82C693U driver v0.34 99-13-12 Andreas S. Krebs (akrebs@altavista.net)"
-
 /*
  *	The following are used to debug the driver.
  */
-#define CY82C693_DEBUG_LOGS	0
 #define CY82C693_DEBUG_INFO	0
 
-/* define CY82C693_SETDMA_CLOCK to set DMA Controller Clock Speed to ATCLK */
-#undef CY82C693_SETDMA_CLOCK
-
 /*
  *	NOTE: the value for busmaster timeout is tricky and I got it by
  *	trial and error!  By using a to low value will cause DMA timeouts
@@ -89,7 +82,6 @@
 #define CY82_INDEX_PORT		0x22
 #define CY82_DATA_PORT		0x23
 
-#define CY82_INDEX_CTRLREG1	0x01
 #define CY82_INDEX_CHANNEL0	0x30
 #define CY82_INDEX_CHANNEL1	0x31
 #define CY82_INDEX_TIMEOUT	0x32
@@ -179,17 +171,6 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 
 	index = hwif->channel ? CY82_INDEX_CHANNEL1 : CY82_INDEX_CHANNEL0;
 
-#if CY82C693_DEBUG_LOGS
-	/* for debug let's show the previous values */
-
-	outb(index, CY82_INDEX_PORT);
-	data = inb(CY82_DATA_PORT);
-
-	printk(KERN_INFO "%s (ch=%d, dev=%d): DMA mode is %d (single=%d)\n",
-		drive->name, HWIF(drive)->channel, drive->select.b.unit,
-		(data&0x3), ((data>>2)&1));
-#endif /* CY82C693_DEBUG_LOGS */
-
 	data = (mode & 3) | (single << 2);
 
 	outb(index, CY82_INDEX_PORT);
@@ -197,8 +178,7 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 
 #if CY82C693_DEBUG_INFO
 	printk(KERN_INFO "%s (ch=%d, dev=%d): set DMA mode to %d (single=%d)\n",
-		drive->name, HWIF(drive)->channel, drive->select.b.unit,
-		mode & 3, single);
+		drive->name, hwif->channel, drive->dn & 1, mode & 3, single);
 #endif /* CY82C693_DEBUG_INFO */
 
 	/*
@@ -239,50 +219,11 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		}
 	}
 
-#if CY82C693_DEBUG_LOGS
-	/* for debug let's show the register values */
-
-	if (drive->select.b.unit == 0) {
-		/*
-		 * get master drive registers
-		 * address setup control register
-		 * is 32 bit !!!
-		 */
-		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
-		addrCtrl &= 0x0F;
-
-		/* now let's get the remaining registers */
-		pci_read_config_byte(dev, CY82_IDE_MASTER_IOR, &pclk.time_16r);
-		pci_read_config_byte(dev, CY82_IDE_MASTER_IOW, &pclk.time_16w);
-		pci_read_config_byte(dev, CY82_IDE_MASTER_8BIT, &pclk.time_8);
-	} else {
-		/*
-		 * set slave drive registers
-		 * address setup control register
-		 * is 32 bit !!!
-		 */
-		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
-
-		addrCtrl &= 0xF0;
-		addrCtrl >>= 4;
-
-		/* now let's get the remaining registers */
-		pci_read_config_byte(dev, CY82_IDE_SLAVE_IOR, &pclk.time_16r);
-		pci_read_config_byte(dev, CY82_IDE_SLAVE_IOW, &pclk.time_16w);
-		pci_read_config_byte(dev, CY82_IDE_SLAVE_8BIT, &pclk.time_8);
-	}
-
-	printk(KERN_INFO "%s (ch=%d, dev=%d): PIO timing is "
-		"(addr=0x%X, ior=0x%X, iow=0x%X, 8bit=0x%X)\n",
-		drive->name, hwif->channel, drive->select.b.unit,
-		addrCtrl, pclk.time_16r, pclk.time_16w, pclk.time_8);
-#endif /* CY82C693_DEBUG_LOGS */
-
 	/* let's calc the values for this PIO mode */
 	compute_clocks(pio, &pclk);
 
 	/* now let's write  the clocks registers */
-	if (drive->select.b.unit == 0) {
+	if ((drive->dn & 1) == 0) {
 		/*
 		 * set master drive
 		 * address setup control register
@@ -324,63 +265,11 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 #if CY82C693_DEBUG_INFO
 	printk(KERN_INFO "%s (ch=%d, dev=%d): set PIO timing to "
 		"(addr=0x%X, ior=0x%X, iow=0x%X, 8bit=0x%X)\n",
-		drive->name, hwif->channel, drive->select.b.unit,
+		drive->name, hwif->channel, drive->dn & 1,
 		addrCtrl, pclk.time_16r, pclk.time_16w, pclk.time_8);
 #endif /* CY82C693_DEBUG_INFO */
 }
 
-/*
- * this function is called during init and is used to setup the cy82c693 chip
- */
-static unsigned int init_chipset_cy82c693(struct pci_dev *dev)
-{
-	if (PCI_FUNC(dev->devfn) != 1)
-		return 0;
-
-#ifdef CY82C693_SETDMA_CLOCK
-	u8 data = 0;
-#endif /* CY82C693_SETDMA_CLOCK */
-
-	/* write info about this verion of the driver */
-	printk(KERN_INFO CY82_VERSION "\n");
-
-#ifdef CY82C693_SETDMA_CLOCK
-       /* okay let's set the DMA clock speed */
-
-	outb(CY82_INDEX_CTRLREG1, CY82_INDEX_PORT);
-	data = inb(CY82_DATA_PORT);
-
-#if CY82C693_DEBUG_INFO
-	printk(KERN_INFO DRV_NAME ": Peripheral Configuration Register: 0x%X\n",
-		data);
-#endif /* CY82C693_DEBUG_INFO */
-
-	/*
-	 * for some reason sometimes the DMA controller
-	 * speed is set to ATCLK/2 ???? - we fix this here
-	 *
-	 * note: i don't know what causes this strange behaviour,
-	 *       but even changing the dma speed doesn't solve it :-(
-	 *       the ide performance is still only half the normal speed
-	 *
-	 *       if anybody knows what goes wrong with my machine, please
-	 *       let me know - ASK
-	 */
-
-	data |= 0x03;
-
-	outb(CY82_INDEX_CTRLREG1, CY82_INDEX_PORT);
-	outb(data, CY82_DATA_PORT);
-
-#if CY82C693_DEBUG_INFO
-	printk(KERN_INFO ": New Peripheral Configuration Register: 0x%X\n",
-		data);
-#endif /* CY82C693_DEBUG_INFO */
-
-#endif /* CY82C693_SETDMA_CLOCK */
-	return 0;
-}
-
 static void __devinit init_iops_cy82c693(ide_hwif_t *hwif)
 {
 	static ide_hwif_t *primary;
@@ -401,7 +290,6 @@ static const struct ide_port_ops cy82c693_port_ops = {
 
 static const struct ide_port_info cy82c693_chipset __devinitdata = {
 	.name		= DRV_NAME,
-	.init_chipset	= init_chipset_cy82c693,
 	.init_iops	= init_iops_cy82c693,
 	.port_ops	= &cy82c693_port_ops,
 	.chipset	= ide_cy82c693,
@@ -443,7 +331,7 @@ static const struct pci_device_id cy82c693_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, cy82c693_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver cy82c693_pci_driver = {
 	.name		= "Cypress_IDE",
 	.id_table	= cy82c693_pci_tbl,
 	.probe		= cy82c693_init_one,
@@ -454,12 +342,12 @@ static struct pci_driver driver = {
 
 static int __init cy82c693_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&cy82c693_pci_driver);
 }
 
 static void __exit cy82c693_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&cy82c693_pci_driver);
 }
 
 module_init(cy82c693_ide_init);
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index 83b63b3..8689a70 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -117,7 +117,7 @@ static struct pci_device_id delkin_cb_pci_tbl[] __devinitdata = {
 };
 MODULE_DEVICE_TABLE(pci, delkin_cb_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver delkin_cb_pci_driver = {
 	.name		= "Delkin-ASKA-Workbit Cardbus IDE",
 	.id_table	= delkin_cb_pci_tbl,
 	.probe		= delkin_cb_probe,
@@ -126,12 +126,12 @@ static struct pci_driver driver = {
 
 static int __init delkin_cb_init(void)
 {
-	return pci_register_driver(&driver);
+	return pci_register_driver(&delkin_cb_pci_driver);
 }
 
 static void __exit delkin_cb_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&delkin_cb_pci_driver);
 }
 
 module_init(delkin_cb_init);
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index 092b238..474f96a 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -166,7 +166,7 @@ static const struct pci_device_id generic_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, generic_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver generic_pci_driver = {
 	.name		= "PCI_IDE",
 	.id_table	= generic_pci_tbl,
 	.probe		= generic_init_one,
@@ -177,12 +177,12 @@ static struct pci_driver driver = {
 
 static int __init generic_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&generic_pci_driver);
 }
 
 static void __exit generic_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&generic_pci_driver);
 }
 
 module_init(generic_ide_init);
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 644de29..fb1a3aa 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -166,7 +166,7 @@ static const struct pci_device_id hpt34x_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, hpt34x_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver hpt34x_pci_driver = {
 	.name		= "HPT34x_IDE",
 	.id_table	= hpt34x_pci_tbl,
 	.probe		= hpt34x_init_one,
@@ -177,12 +177,12 @@ static struct pci_driver driver = {
 
 static int __init hpt34x_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&hpt34x_pci_driver);
 }
 
 static void __exit hpt34x_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&hpt34x_pci_driver);
 }
 
 module_init(hpt34x_ide_init);
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index a194022..9cf171c 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -835,7 +835,7 @@ static int hpt370_dma_end(ide_drive_t *drive)
 		if (dma_stat & 0x01)
 			hpt370_irq_timeout(drive);
 	}
-	return __ide_dma_end(drive);
+	return ide_dma_end(drive);
 }
 
 static void hpt370_dma_timeout(ide_drive_t *drive)
@@ -863,9 +863,6 @@ static int hpt374_dma_test_irq(ide_drive_t *drive)
 	if (dma_stat & 4)
 		return 1;
 
-	if (!drive->waiting_for_dma)
-		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-				drive->name, __func__);
 	return 0;
 }
 
@@ -880,7 +877,7 @@ static int hpt374_dma_end(ide_drive_t *drive)
 	pci_read_config_byte(dev, mcr_addr, &mcr);
 	if (bwsr & mask)
 		pci_write_config_byte(dev, mcr_addr, mcr | 0x30);
-	return __ide_dma_end(drive);
+	return ide_dma_end(drive);
 }
 
 /**
@@ -1456,7 +1453,7 @@ static const struct ide_dma_ops hpt36x_dma_ops = {
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= hpt366_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
@@ -1622,7 +1619,7 @@ static const struct pci_device_id hpt366_pci_tbl[] __devinitconst = {
 };
 MODULE_DEVICE_TABLE(pci, hpt366_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver hpt366_pci_driver = {
 	.name		= "HPT366_IDE",
 	.id_table	= hpt366_pci_tbl,
 	.probe		= hpt366_init_one,
@@ -1633,12 +1630,12 @@ static struct pci_driver driver = {
 
 static int __init hpt366_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&hpt366_pci_driver);
 }
 
 static void __exit hpt366_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&hpt366_pci_driver);
 }
 
 module_init(hpt366_ide_init);
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 0954ccd..7c2feeb 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -189,7 +189,7 @@ static const struct pci_device_id it8213_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, it8213_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver it8213_pci_driver = {
 	.name		= "ITE8213_IDE",
 	.id_table	= it8213_pci_tbl,
 	.probe		= it8213_init_one,
@@ -200,12 +200,12 @@ static struct pci_driver driver = {
 
 static int __init it8213_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&it8213_pci_driver);
 }
 
 static void __exit it8213_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&it8213_pci_driver);
 }
 
 module_init(it8213_ide_init);
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 46edd08..995e18b 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -138,8 +138,7 @@ static void it821x_program_udma(ide_drive_t *drive, u16 timing)
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 	int channel = hwif->channel;
-	int unit = drive->select.b.unit;
-	u8 conf;
+	u8 unit = drive->dn & 1, conf;
 
 	/* Program UDMA timing bits */
 	if(itdev->clock_mode == ATA_66)
@@ -168,13 +167,11 @@ static void it821x_clock_strategy(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
+	ide_drive_t *pair;
+	int clock, altclock, sel = 0;
+	u8 unit = drive->dn & 1, v;
 
-	u8 unit = drive->select.b.unit;
-	ide_drive_t *pair = &hwif->drives[1-unit];
-
-	int clock, altclock;
-	u8 v;
-	int sel = 0;
+	pair = &hwif->drives[1 - unit];
 
 	if(itdev->want[0][0] > itdev->want[1][0]) {
 		clock = itdev->want[0][1];
@@ -240,16 +237,17 @@ static void it821x_clock_strategy(ide_drive_t *drive)
 
 static void it821x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif	= drive->hwif;
+	ide_hwif_t *hwif = drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	int unit = drive->select.b.unit;
-	ide_drive_t *pair = &hwif->drives[1 - unit];
-	u8 set_pio = pio;
+	ide_drive_t *pair;
+	u8 unit = drive->dn & 1, set_pio = pio;
 
 	/* Spec says 89 ref driver uses 88 */
 	static u16 pio_timings[]= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
 	static u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
 
+	pair = &hwif->drives[1 - unit];
+
 	/*
 	 * Compute the best PIO mode we can for a given device. We must
 	 * pick a speed that does not cause problems with the other device
@@ -286,9 +284,7 @@ static void it821x_tune_mwdma (ide_drive_t *drive, byte mode_wanted)
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = (void *)ide_get_hwifdata(hwif);
-	int unit = drive->select.b.unit;
-	int channel = hwif->channel;
-	u8 conf;
+	u8 unit = drive->dn & 1, channel = hwif->channel, conf;
 
 	static u16 dma[]	= { 0x8866, 0x3222, 0x3121 };
 	static u8 mwdma_want[]	= { ATA_ANY, ATA_66, ATA_ANY };
@@ -325,9 +321,7 @@ static void it821x_tune_udma (ide_drive_t *drive, byte mode_wanted)
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	int unit = drive->select.b.unit;
-	int channel = hwif->channel;
-	u8 conf;
+	u8 unit = drive->dn & 1, channel = hwif->channel, conf;
 
 	static u16 udma[]	= { 0x4433, 0x4231, 0x3121, 0x2121, 0x1111, 0x2211, 0x1111 };
 	static u8 udma_want[]	= { ATA_ANY, ATA_50, ATA_ANY, ATA_66, ATA_66, ATA_50, ATA_66 };
@@ -369,7 +363,8 @@ static void it821x_dma_start(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	int unit = drive->select.b.unit;
+	u8 unit = drive->dn & 1;
+
 	if(itdev->mwdma[unit] != MWDMA_OFF)
 		it821x_program(drive, itdev->mwdma[unit]);
 	else if(itdev->udma[unit] != UDMA_OFF && itdev->timing10)
@@ -389,9 +384,10 @@ static void it821x_dma_start(ide_drive_t *drive)
 static int it821x_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	int unit = drive->select.b.unit;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	int ret = __ide_dma_end(drive);
+	int ret = ide_dma_end(drive);
+	u8 unit = drive->dn & 1;
+
 	if(itdev->mwdma[unit] != MWDMA_OFF)
 		it821x_program(drive, itdev->pio[unit]);
 	return ret;
@@ -454,7 +450,7 @@ static void it821x_quirkproc(ide_drive_t *drive)
 		 *	IRQ mask as we may well be in PIO (eg rev 0x10)
 		 *	for now and we know unmasking is safe on this chipset.
 		 */
-		drive->unmask = 1;
+		drive->dev_flags |= IDE_DFLAG_UNMASK;
 	} else {
 	/*
 	 *	Perform fixups on smart mode. We need to "lose" some
@@ -680,7 +676,7 @@ static const struct pci_device_id it821x_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, it821x_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver it821x_pci_driver = {
 	.name		= "ITE821x IDE",
 	.id_table	= it821x_pci_tbl,
 	.probe		= it821x_init_one,
@@ -691,12 +687,12 @@ static struct pci_driver driver = {
 
 static int __init it821x_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&it821x_pci_driver);
 }
 
 static void __exit it821x_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&it821x_pci_driver);
 }
 
 module_init(it821x_ide_init);
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index acd6471..9a68433 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -149,7 +149,7 @@ static struct pci_device_id jmicron_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, jmicron_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver jmicron_pci_driver = {
 	.name		= "JMicron IDE",
 	.id_table	= jmicron_pci_tbl,
 	.probe		= jmicron_init_one,
@@ -160,12 +160,12 @@ static struct pci_driver driver = {
 
 static int __init jmicron_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&jmicron_pci_driver);
 }
 
 static void __exit jmicron_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&jmicron_pci_driver);
 }
 
 module_init(jmicron_ide_init);
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index 53bd645..1378906 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -137,7 +137,7 @@ static void __devinit superio_init_iops(struct hwif_s *hwif)
 static unsigned int ns87415_count = 0, ns87415_control[MAX_HWIFS] = { 0 };
 
 /*
- * This routine either enables/disables (according to drive->present)
+ * This routine either enables/disables (according to IDE_DFLAG_PRESENT)
  * the IRQ associated with the port (HWIF(drive)),
  * and selects either PIO or DMA handshaking for the next I/O operation.
  */
@@ -153,11 +153,15 @@ static void ns87415_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 
 	/* Adjust IRQ enable bit */
 	bit = 1 << (8 + hwif->channel);
-	new = drive->present ? (new & ~bit) : (new | bit);
+
+	if (drive->dev_flags & IDE_DFLAG_PRESENT)
+		new &= ~bit;
+	else
+		new |= bit;
 
 	/* Select PIO or DMA, DMA may only be selected for one drive/channel. */
-	bit   = 1 << (20 + drive->select.b.unit       + (hwif->channel << 1));
-	other = 1 << (20 + (1 - drive->select.b.unit) + (hwif->channel << 1));
+	bit   = 1 << (20 + (drive->dn & 1) + (hwif->channel << 1));
+	other = 1 << (20 + (1 - (drive->dn & 1)) + (hwif->channel << 1));
 	new = use_dma ? ((new & ~other) | bit) : (new & ~bit);
 
 	if (new != *old) {
@@ -187,7 +191,8 @@ static void ns87415_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 
 static void ns87415_selectproc (ide_drive_t *drive)
 {
-	ns87415_prepare_drive (drive, drive->using_dma);
+	ns87415_prepare_drive(drive,
+			      !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
 }
 
 static int ns87415_dma_end(ide_drive_t *drive)
@@ -334,7 +339,7 @@ static const struct pci_device_id ns87415_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, ns87415_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver ns87415_pci_driver = {
 	.name		= "NS87415_IDE",
 	.id_table	= ns87415_pci_tbl,
 	.probe		= ns87415_init_one,
@@ -345,12 +350,12 @@ static struct pci_driver driver = {
 
 static int __init ns87415_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&ns87415_pci_driver);
 }
 
 static void __exit ns87415_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&ns87415_pci_driver);
 }
 
 module_init(ns87415_ide_init);
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 3de11dd..6048eda 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -179,7 +179,7 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	misc = addr_timings[clk][addr_pio];
 
 	/* select Index-0/1 for Register-A/B */
-	write_reg(drive->select.b.unit, MISC_REG);
+	write_reg(drive->dn & 1, MISC_REG);
 	/* set read cycle timings */
 	write_reg(tim, READ_REG);
 	/* set write cycle timings */
@@ -220,7 +220,7 @@ static const struct pci_device_id opti621_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, opti621_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver opti621_pci_driver = {
 	.name		= "Opti621_IDE",
 	.id_table	= opti621_pci_tbl,
 	.probe		= opti621_init_one,
@@ -231,12 +231,12 @@ static struct pci_driver driver = {
 
 static int __init opti621_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&opti621_pci_driver);
 }
 
 static void __exit opti621_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&opti621_pci_driver);
 }
 
 module_init(opti621_ide_init);
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 9fc5996..211ae46 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -561,7 +561,7 @@ static const struct pci_device_id pdc202new_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, pdc202new_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver pdc202new_pci_driver = {
 	.name		= "Promise_IDE",
 	.id_table	= pdc202new_pci_tbl,
 	.probe		= pdc202new_init_one,
@@ -572,12 +572,12 @@ static struct pci_driver driver = {
 
 static int __init pdc202new_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&pdc202new_pci_driver);
 }
 
 static void __exit pdc202new_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&pdc202new_pci_driver);
 }
 
 module_init(pdc202new_ide_init);
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index cb6d2a0..799557c 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -168,7 +168,7 @@ static void pdc202xx_dma_start(ide_drive_t *drive)
 {
 	if (drive->current_speed > XFER_UDMA_2)
 		pdc_old_enable_66MHz_clock(drive->hwif);
-	if (drive->media != ide_disk || drive->addressing == 1) {
+	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
 		struct request *rq	= HWGROUP(drive)->rq;
 		ide_hwif_t *hwif	= HWIF(drive);
 		unsigned long high_16	= hwif->extra_base - 16;
@@ -188,7 +188,7 @@ static void pdc202xx_dma_start(ide_drive_t *drive)
 
 static int pdc202xx_dma_end(ide_drive_t *drive)
 {
-	if (drive->media != ide_disk || drive->addressing == 1) {
+	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
 		ide_hwif_t *hwif	= HWIF(drive);
 		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
@@ -200,7 +200,7 @@ static int pdc202xx_dma_end(ide_drive_t *drive)
 	}
 	if (drive->current_speed > XFER_UDMA_2)
 		pdc_old_disable_66MHz_clock(drive->hwif);
-	return __ide_dma_end(drive);
+	return ide_dma_end(drive);
 }
 
 static int pdc202xx_dma_test_irq(ide_drive_t *drive)
@@ -333,7 +333,7 @@ static const struct ide_dma_ops pdc20246_dma_ops = {
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
 	.dma_timeout		= pdc202xx_dma_timeout,
@@ -426,7 +426,7 @@ static const struct pci_device_id pdc202xx_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, pdc202xx_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver pdc202xx_pci_driver = {
 	.name		= "Promise_Old_IDE",
 	.id_table	= pdc202xx_pci_tbl,
 	.probe		= pdc202xx_init_one,
@@ -437,12 +437,12 @@ static struct pci_driver driver = {
 
 static int __init pdc202xx_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&pdc202xx_pci_driver);
 }
 
 static void __exit pdc202xx_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&pdc202xx_pci_driver);
 }
 
 module_init(pdc202xx_ide_init);
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index a06c03f..d63f9fd 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -215,17 +215,26 @@ static unsigned int init_chipset_ich(struct pci_dev *dev)
 }
 
 /**
- *	piix_dma_clear_irq	-	clear BMDMA status
- *	@drive: IDE drive to clear
+ *	ich_clear_irq	-	clear BMDMA status
+ *	@drive: IDE drive
  *
- *	Called from ide_intr() for PIO interrupts
- *	to clear BMDMA status as needed by ICHx
+ *	ICHx contollers set DMA INTR no matter DMA or PIO.
+ *	BMDMA status might need to be cleared even for
+ *	PIO interrupts to prevent spurious/lost IRQ.
  */
-static void piix_dma_clear_irq(ide_drive_t *drive)
+static void ich_clear_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	u8 dma_stat;
 
+	/*
+	 * ide_dma_end() needs BMDMA status for error checking.
+	 * So, skip clearing BMDMA status here and leave it
+	 * to ide_dma_end() if this is DMA interrupt.
+	 */
+	if (drive->waiting_for_dma || hwif->dma_base == 0)
+		return;
+
 	/* clear the INTR & ERROR bits */
 	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* Should we force the bit as well ? */
@@ -249,6 +258,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
+	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on Acer Aspire 2023WLMi */
 	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
 	/* end marker */
@@ -293,21 +303,19 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 		hwif->ultra_mask = hwif->mwdma_mask = hwif->swdma_mask = 0;
 }
 
-static void __devinit init_hwif_ich(ide_hwif_t *hwif)
-{
-	init_hwif_piix(hwif);
-
-	/* ICHx need to clear the BMDMA status for all interrupts */
-	if (hwif->dma_base)
-		hwif->ide_dma_clear_irq = &piix_dma_clear_irq;
-}
-
 static const struct ide_port_ops piix_port_ops = {
 	.set_pio_mode		= piix_set_pio_mode,
 	.set_dma_mode		= piix_set_dma_mode,
 	.cable_detect		= piix_cable_detect,
 };
 
+static const struct ide_port_ops ich_port_ops = {
+	.set_pio_mode		= piix_set_pio_mode,
+	.set_dma_mode		= piix_set_dma_mode,
+	.clear_irq		= ich_clear_irq,
+	.cable_detect		= piix_cable_detect,
+};
+
 #ifndef CONFIG_IA64
  #define IDE_HFLAGS_PIIX IDE_HFLAG_LEGACY_IRQS
 #else
@@ -331,9 +339,9 @@ static const struct ide_port_ops piix_port_ops = {
 	{ \
 		.name		= DRV_NAME, \
 		.init_chipset	= init_chipset_ich, \
-		.init_hwif	= init_hwif_ich, \
+		.init_hwif	= init_hwif_piix, \
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
-		.port_ops	= &piix_port_ops, \
+		.port_ops	= &ich_port_ops, \
 		.host_flags	= IDE_HFLAGS_PIIX, \
 		.pio_mask	= ATA_PIO4, \
 		.swdma_mask	= ATA_SWDMA2_ONLY, \
@@ -444,7 +452,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver piix_pci_driver = {
 	.name		= "PIIX_IDE",
 	.id_table	= piix_pci_tbl,
 	.probe		= piix_init_one,
@@ -456,12 +464,12 @@ static struct pci_driver driver = {
 static int __init piix_ide_init(void)
 {
 	piix_check_450nx();
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&piix_pci_driver);
 }
 
 static void __exit piix_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&piix_pci_driver);
 }
 
 module_init(piix_ide_init);
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index c117a06..7daf013 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -59,7 +59,7 @@ static const struct pci_device_id rz1000_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, rz1000_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver rz1000_pci_driver = {
 	.name		= "RZ1000_IDE",
 	.id_table	= rz1000_pci_tbl,
 	.probe		= rz1000_init_one,
@@ -68,12 +68,12 @@ static struct pci_driver driver = {
 
 static int __init rz1000_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&rz1000_pci_driver);
 }
 
 static void __exit rz1000_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&rz1000_pci_driver);
 }
 
 module_init(rz1000_ide_init);
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index bdc1fed..f1a8758 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -126,7 +126,6 @@ static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
 {
 	ide_hwif_t		*hwif = HWIF(drive);
 	struct pci_dev		*dev = to_pci_dev(hwif->dev);
-	int			unit = drive->select.b.unit;
 	unsigned int		reg, timings;
 	unsigned short		pci_clock;
 	unsigned int		basereg = hwif->channel ? 0x50 : 0x40;
@@ -155,7 +154,7 @@ static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
 	else
 		timings = mwdma_timing[pci_clock][mode - XFER_MW_DMA_0];
 
-	if (unit == 0) {			/* are we configuring drive0? */
+	if ((drive->dn & 1) == 0) {
 		pci_read_config_dword(dev, basereg + 4, &reg);
 		timings |= reg & 0x80000000;	/* preserve PIO format bit */
 		pci_write_config_dword(dev, basereg + 4, timings);
@@ -216,7 +215,8 @@ static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	if (mode != -1) {
 		printk("SC1200: %s: changing (U)DMA mode\n", drive->name);
 		ide_dma_off_quietly(drive);
-		if (ide_set_dma_mode(drive, mode) == 0 && drive->using_dma)
+		if (ide_set_dma_mode(drive, mode) == 0 &&
+		    (drive->dev_flags & IDE_DFLAG_USING_DMA))
 			hwif->dma_ops->dma_host_set(drive, 1);
 		return;
 	}
@@ -328,7 +328,7 @@ static const struct pci_device_id sc1200_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, sc1200_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver sc1200_pci_driver = {
 	.name		= "SC1200_IDE",
 	.id_table	= sc1200_pci_tbl,
 	.probe		= sc1200_init_one,
@@ -341,12 +341,12 @@ static struct pci_driver driver = {
 
 static int __init sc1200_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&sc1200_pci_driver);
 }
 
 static void __exit sc1200_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&sc1200_pci_driver);
 }
 
 module_init(sc1200_ide_init);
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index e92a874..9ce1d80 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -291,7 +291,7 @@ static void scc_set_dma_mode(ide_drive_t *drive, const u8 speed)
 static void scc_dma_host_set(ide_drive_t *drive, int on)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 unit = (drive->select.b.unit & 0x01);
+	u8 unit = drive->dn & 1;
 	u8 dma_stat = scc_ide_inb(hwif->dma_base + 4);
 
 	if (on)
@@ -353,7 +353,6 @@ static void scc_dma_start(ide_drive_t *drive)
 
 	/* start DMA */
 	scc_ide_outb(dma_cmd | 1, hwif->dma_base);
-	hwif->dma = 1;
 	wmb();
 }
 
@@ -374,7 +373,6 @@ static int __scc_dma_end(ide_drive_t *drive)
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
-	hwif->dma = 0;
 	wmb();
 	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
 }
@@ -511,9 +509,6 @@ static int scc_dma_test_irq(ide_drive_t *drive)
 	if (int_stat & INTSTS_IOIRQS)
 		return 1;
 
-	if (!drive->waiting_for_dma)
-		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-			drive->name, __func__);
 	return 0;
 }
 
@@ -710,7 +705,7 @@ static void scc_tf_load(ide_drive_t *drive, ide_task_t *task)
 		scc_ide_outb(tf->lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		scc_ide_outb((tf->device & HIHI) | drive->select.all,
+		scc_ide_outb((tf->device & HIHI) | drive->select,
 			     io_ports->device_addr);
 }
 
@@ -826,6 +821,12 @@ static void __devinit init_iops_scc(ide_hwif_t *hwif)
 	init_mmio_iops_scc(hwif);
 }
 
+static int __devinit scc_init_dma(ide_hwif_t *hwif,
+				  const struct ide_port_info *d)
+{
+	return ide_allocate_dma_engine(hwif);
+}
+
 static u8 scc_cable_detect(ide_hwif_t *hwif)
 {
 	return ATA_CBL_PATA80;
@@ -890,6 +891,7 @@ static const struct ide_dma_ops scc_dma_ops = {
   {							\
       .name		= name_str,			\
       .init_iops	= init_iops_scc,		\
+      .init_dma		= scc_init_dma,			\
       .init_hwif	= init_hwif_scc,		\
       .tp_ops		= &scc_tp_ops,		\
       .port_ops		= &scc_port_ops,		\
@@ -927,13 +929,6 @@ static void __devexit scc_remove(struct pci_dev *dev)
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
 	struct ide_host *host = ports->host;
-	ide_hwif_t *hwif = host->ports[0];
-
-	if (hwif->dmatable_cpu) {
-		pci_free_consistent(dev, PRD_ENTRIES * PRD_BYTES,
-				    hwif->dmatable_cpu, hwif->dmatable_dma);
-		hwif->dmatable_cpu = NULL;
-	}
 
 	ide_host_remove(host);
 
@@ -949,7 +944,7 @@ static const struct pci_device_id scc_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, scc_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver scc_pci_driver = {
 	.name = "SCC IDE",
 	.id_table = scc_pci_tbl,
 	.probe = scc_init_one,
@@ -958,14 +953,14 @@ static struct pci_driver driver = {
 
 static int scc_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&scc_pci_driver);
 }
 
 module_init(scc_ide_init);
 /* -- No exit code?
 static void scc_ide_exit(void)
 {
-	ide_pci_unregister_driver(&driver);
+	ide_pci_unregister_driver(&scc_pci_driver);
 }
 module_exit(scc_ide_exit);
  */
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index 3dff2ae..437bc91 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -153,7 +153,7 @@ static void svwks_set_dma_mode(ide_drive_t *drive, const u8 speed)
 
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u8 unit			= (drive->select.b.unit & 0x01);
+	u8 unit			= drive->dn & 1;
 
 	u8 ultra_enable	 = 0, ultra_timing = 0, dma_timing = 0;
 
@@ -443,7 +443,7 @@ static const struct pci_device_id svwks_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, svwks_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver svwks_pci_driver = {
 	.name		= "Serverworks_IDE",
 	.id_table	= svwks_pci_tbl,
 	.probe		= svwks_init_one,
@@ -454,12 +454,12 @@ static struct pci_driver driver = {
 
 static int __init svwks_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&svwks_pci_driver);
 }
 
 static void __exit svwks_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&svwks_pci_driver);
 }
 
 module_init(svwks_ide_init);
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 1017fb4..dd63454 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2003-2006 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (C) 2008 MontaVista Software, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License
@@ -150,7 +151,7 @@ sgiioc4_clearirq(ide_drive_t * drive)
 		int count = 0;
 
 		stat = sgiioc4_read_status(hwif);
-		while ((stat & 0x80) && (count++ < 100)) {
+		while ((stat & ATA_BUSY) && (count++ < 100)) {
 			udelay(1);
 			stat = sgiioc4_read_status(hwif);
 		}
@@ -310,7 +311,7 @@ static u8 sgiioc4_read_status(ide_hwif_t *hwif)
 	u8 reg = (u8) readb((void __iomem *) port);
 
 	if ((port & 0xFFF) == 0x11C) {	/* Status register of IOC4 */
-		if (reg & 0x51) {	/* Not busy...check for interrupt */
+		if (!(reg & ATA_BUSY)) { /* Not busy... check for interrupt */
 			unsigned long other_ir = port - 0x110;
 			unsigned int intr_reg = (u32) readl((void __iomem *) other_ir);
 
@@ -338,35 +339,31 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
 	if (dma_base == 0)
 		return -1;
 
-	printk(KERN_INFO "%s: BM-DMA at 0x%04lx-0x%04lx\n", hwif->name,
-	       dma_base, dma_base + num_ports - 1);
+	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
 
-	if (!request_mem_region(dma_base, num_ports, hwif->name)) {
-		printk(KERN_ERR
-		       "%s(%s) -- ERROR, Addresses 0x%p to 0x%p "
-		       "ALREADY in use\n",
-		       __func__, hwif->name, (void *) dma_base,
-		       (void *) dma_base + num_ports - 1);
+	if (request_mem_region(dma_base, num_ports, hwif->name) == NULL) {
+		printk(KERN_ERR "%s(%s) -- ERROR: addresses 0x%08lx to 0x%08lx "
+		       "already in use\n", __func__, hwif->name,
+		       dma_base, dma_base + num_ports - 1);
 		return -1;
 	}
 
 	virt_dma_base = ioremap(dma_base, num_ports);
 	if (virt_dma_base == NULL) {
-		printk(KERN_ERR
-		       "%s(%s) -- ERROR, Unable to map addresses 0x%lx to 0x%lx\n",
-		       __func__, hwif->name, dma_base, dma_base + num_ports - 1);
+		printk(KERN_ERR "%s(%s) -- ERROR: unable to map addresses "
+		       "0x%lx to 0x%lx\n", __func__, hwif->name,
+		       dma_base, dma_base + num_ports - 1);
 		goto dma_remap_failure;
 	}
 	hwif->dma_base = (unsigned long) virt_dma_base;
 
-	hwif->dmatable_cpu = pci_alloc_consistent(dev,
-					  IOC4_PRD_ENTRIES * IOC4_PRD_BYTES,
-					  &hwif->dmatable_dma);
+	hwif->sg_max_nents = IOC4_PRD_ENTRIES;
 
-	if (!hwif->dmatable_cpu)
-		goto dma_pci_alloc_failure;
+	hwif->prd_max_nents = IOC4_PRD_ENTRIES;
+	hwif->prd_ent_size = IOC4_PRD_BYTES;
 
-	hwif->sg_max_nents = IOC4_PRD_ENTRIES;
+	if (ide_allocate_dma_engine(hwif))
+		goto dma_pci_alloc_failure;
 
 	pad = pci_alloc_consistent(dev, IOC4_IDE_CACHELINE_SIZE,
 				   (dma_addr_t *)&hwif->extra_base);
@@ -375,13 +372,11 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
 		return 0;
 	}
 
-	pci_free_consistent(dev, IOC4_PRD_ENTRIES * IOC4_PRD_BYTES,
-			    hwif->dmatable_cpu, hwif->dmatable_dma);
-	printk(KERN_INFO
-	       "%s() -- Error! Unable to allocate DMA Maps for drive %s\n",
+	ide_release_dma_engine(hwif);
+
+	printk(KERN_ERR "%s(%s) -- ERROR: Unable to allocate DMA maps\n",
 	       __func__, hwif->name);
-	printk(KERN_INFO
-	       "Changing from DMA to PIO mode for Drive %s\n", hwif->name);
+	printk(KERN_INFO "%s: changing from DMA to PIO mode", hwif->name);
 
 dma_pci_alloc_failure:
 	iounmap(virt_dma_base);
@@ -617,14 +612,12 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	irqport = (unsigned long) virt_base + IOC4_INTR_OFFSET;
 
 	cmd_phys_base = bar0 + IOC4_CMD_OFFSET;
-	if (!request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
-	    DRV_NAME)) {
-		printk(KERN_ERR
-			"%s %s: -- ERROR, Addresses "
-			"0x%p to 0x%p ALREADY in use\n",
-		       DRV_NAME, pci_name(dev), (void *)cmd_phys_base,
-		       (void *) cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
-		return -ENOMEM;
+	if (request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
+			       DRV_NAME) == NULL) {
+		printk(KERN_ERR "%s %s -- ERROR: addresses 0x%08lx to 0x%08lx "
+		       "already in use\n", DRV_NAME, pci_name(dev),
+		       cmd_phys_base, cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
+		return -EBUSY;
 	}
 
 	/* Initialize the IO registers */
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 174a873..eb4faf9 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -116,13 +116,14 @@ static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long base	= (unsigned long)hwif->hwif_data;
+	u8 unit			= drive->dn & 1;
 
 	base += 0xA0 + r;
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		base += hwif->channel << 6;
 	else
 		base += hwif->channel << 4;
-	base |= drive->select.b.unit << drive->select.b.unit;
+	base |= unit << unit;
 	return base;
 }
 
@@ -255,7 +256,7 @@ static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 	u8 addr_mask		= hwif->channel ? (mmio ? 0xF4 : 0x84)
 						: (mmio ? 0xB4 : 0x80);
 	u8 mode			= 0;
-	u8 unit			= drive->select.b.unit;
+	u8 unit			= drive->dn & 1;
 
 	/* trim *taskfile* PIO to the slowest of the master/slave */
 	if (pair) {
@@ -301,9 +302,9 @@ static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
 
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u16 ultra = 0, multi	= 0;
-	u8 mode = 0, unit	= drive->select.b.unit;
 	unsigned long base	= (unsigned long)hwif->hwif_data;
+	u16 ultra = 0, multi	= 0;
+	u8 mode = 0, unit	= drive->dn & 1;
 	u8 mmio			= (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 scsc = 0, addr_mask	= hwif->channel ? (mmio ? 0xF4 : 0x84)
 						: (mmio ? 0xB4 : 0x80);
@@ -712,7 +713,7 @@ static const struct ide_dma_ops sil_dma_ops = {
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= siimage_dma_test_irq,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
@@ -829,7 +830,7 @@ static const struct pci_device_id siimage_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, siimage_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver siimage_pci_driver = {
 	.name		= "SiI_IDE",
 	.id_table	= siimage_pci_tbl,
 	.probe		= siimage_init_one,
@@ -840,12 +841,12 @@ static struct pci_driver driver = {
 
 static int __init siimage_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&siimage_pci_driver);
 }
 
 static void __exit siimage_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&siimage_pci_driver);
 }
 
 module_init(siimage_ide_init);
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 734dd41..ad32e18 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -605,7 +605,7 @@ static const struct pci_device_id sis5513_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, sis5513_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver sis5513_pci_driver = {
 	.name		= "SIS_IDE",
 	.id_table	= sis5513_pci_tbl,
 	.probe		= sis5513_init_one,
@@ -616,12 +616,12 @@ static struct pci_driver driver = {
 
 static int __init sis5513_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&sis5513_pci_driver);
 }
 
 static void __exit sis5513_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&sis5513_pci_driver);
 }
 
 module_init(sis5513_ide_init);
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 37a6b7b..84dc336 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -207,7 +207,7 @@ static int sl82c105_dma_end(ide_drive_t *drive)
 
 	DBG(("%s(drive:%s)\n", __func__, drive->name));
 
-	ret = __ide_dma_end(drive);
+	ret = ide_dma_end(drive);
 
 	pci_write_config_word(dev, reg, drive->drive_data);
 
@@ -345,7 +345,7 @@ static const struct pci_device_id sl82c105_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, sl82c105_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver sl82c105_pci_driver = {
 	.name		= "W82C105_IDE",
 	.id_table	= sl82c105_pci_tbl,
 	.probe		= sl82c105_init_one,
@@ -356,12 +356,12 @@ static struct pci_driver driver = {
 
 static int __init sl82c105_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&sl82c105_pci_driver);
 }
 
 static void __exit sl82c105_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&sl82c105_pci_driver);
 }
 
 module_init(sl82c105_ide_init);
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index a9551a1..0f759e4 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -154,7 +154,7 @@ static const struct pci_device_id slc90e66_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, slc90e66_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver slc90e66_pci_driver = {
 	.name		= "SLC90e66_IDE",
 	.id_table	= slc90e66_pci_tbl,
 	.probe		= slc90e66_init_one,
@@ -165,12 +165,12 @@ static struct pci_driver driver = {
 
 static int __init slc90e66_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&slc90e66_pci_driver);
 }
 
 static void __exit slc90e66_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&slc90e66_pci_driver);
 }
 
 module_init(slc90e66_ide_init);
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 927277c..93e2cce 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -186,7 +186,7 @@ static const struct ide_dma_ops tc86c001_dma_ops = {
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= tc86c001_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
@@ -245,7 +245,7 @@ static const struct pci_device_id tc86c001_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, tc86c001_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver tc86c001_pci_driver = {
 	.name		= "TC86C001",
 	.id_table	= tc86c001_pci_tbl,
 	.probe		= tc86c001_init_one,
@@ -254,12 +254,12 @@ static struct pci_driver driver = {
 
 static int __init tc86c001_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&tc86c001_pci_driver);
 }
 
 static void __exit tc86c001_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&tc86c001_pci_driver);
 }
 
 module_init(tc86c001_ide_init);
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index be8715d..b6ff403 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -38,13 +38,12 @@ static void triflex_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 channel_offset = hwif->channel ? 0x74 : 0x70;
-	u16 timing = 0;
 	u32 triflex_timings = 0;
-	u8 unit = (drive->select.b.unit & 0x01);
-	
+	u16 timing = 0;
+	u8 channel_offset = hwif->channel ? 0x74 : 0x70, unit = drive->dn & 1;
+
 	pci_read_config_dword(dev, channel_offset, &triflex_timings);
-	
+
 	switch(speed) {
 		case XFER_MW_DMA_2:
 			timing = 0x0103; 
@@ -114,7 +113,7 @@ static const struct pci_device_id triflex_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, triflex_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver triflex_pci_driver = {
 	.name		= "TRIFLEX_IDE",
 	.id_table	= triflex_pci_tbl,
 	.probe		= triflex_init_one,
@@ -125,12 +124,12 @@ static struct pci_driver driver = {
 
 static int __init triflex_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&triflex_pci_driver);
 }
 
 static void __exit triflex_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&triflex_pci_driver);
 }
 
 module_init(triflex_ide_init);
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index 4dfbc6a..75ea615 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -161,7 +161,7 @@ static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 	}
 
 	/* enable IRQ if not probing */
-	if (drive->present) {
+	if (drive->dev_flags & IDE_DFLAG_PRESENT) {
 		reg = inw(hwif->config_data + 3);
 		reg &= 0x13;
 		reg &= ~(1 << hwif->channel);
@@ -173,7 +173,7 @@ static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 
 static void trm290_selectproc (ide_drive_t *drive)
 {
-	trm290_prepare_drive(drive, drive->using_dma);
+	trm290_prepare_drive(drive, !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
 }
 
 static void trm290_dma_exec_cmd(ide_drive_t *drive, u8 command)
@@ -350,7 +350,7 @@ static const struct pci_device_id trm290_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, trm290_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver trm290_pci_driver = {
 	.name		= "TRM290_IDE",
 	.id_table	= trm290_pci_tbl,
 	.probe		= trm290_init_one,
@@ -359,12 +359,12 @@ static struct pci_driver driver = {
 
 static int __init trm290_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&trm290_pci_driver);
 }
 
 static void __exit trm290_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&trm290_pci_driver);
 }
 
 module_init(trm290_ide_init);
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index acacdaa..2a812d3 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -487,7 +487,7 @@ static const struct pci_device_id via_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, via_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver via_pci_driver = {
 	.name 		= "VIA_IDE",
 	.id_table 	= via_pci_tbl,
 	.probe 		= via_init_one,
@@ -498,12 +498,12 @@ static struct pci_driver driver = {
 
 static int __init via_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&via_pci_driver);
 }
 
 static void __exit via_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&via_pci_driver);
 }
 
 module_init(via_ide_init);
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index c3432da..2e19d62 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -430,10 +430,7 @@ pmac_ide_selectproc(ide_drive_t *drive)
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
-	if (pmif == NULL)
-		return;
-
-	if (drive->select.b.unit & 0x01)
+	if (drive->dn & 1)
 		writel(pmif->timings[1], PMAC_IDE_REG(IDE_TIMING_CONFIG));
 	else
 		writel(pmif->timings[0], PMAC_IDE_REG(IDE_TIMING_CONFIG));
@@ -452,10 +449,7 @@ pmac_ide_kauai_selectproc(ide_drive_t *drive)
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
-	if (pmif == NULL)
-		return;
-
-	if (drive->select.b.unit & 0x01) {
+	if (drive->dn & 1) {
 		writel(pmif->timings[1], PMAC_IDE_REG(IDE_KAUAI_PIO_CONFIG));
 		writel(pmif->timings[3], PMAC_IDE_REG(IDE_KAUAI_ULTRA_CONFIG));
 	} else {
@@ -475,9 +469,6 @@ pmac_ide_do_update_timings(ide_drive_t *drive)
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
-	if (pmif == NULL)
-		return;
-
 	if (pmif->kind == controller_sh_ata6 ||
 	    pmif->kind == controller_un_ata6 ||
 	    pmif->kind == controller_k2_ata6)
@@ -524,11 +515,8 @@ pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	unsigned accessTime, recTime;
 	unsigned int cycle_time;
 
-	if (pmif == NULL)
-		return;
-		
 	/* which drive is it ? */
-	timings = &pmif->timings[drive->select.b.unit & 0x01];
+	timings = &pmif->timings[drive->dn & 1];
 	t = *timings;
 
 	cycle_time = ide_pio_cycle_time(drive, pio);
@@ -805,9 +793,9 @@ static void pmac_ide_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	int unit = (drive->select.b.unit & 0x01);
 	int ret = 0;
 	u32 *timings, *timings2, tl[2];
+	u8 unit = drive->dn & 1;
 
 	timings = &pmif->timings[unit];
 	timings2 = &pmif->timings[unit+2];
@@ -966,11 +954,11 @@ static void pmac_ide_init_dev(ide_drive_t *drive)
 	if (pmif->mediabay) {
 #ifdef CONFIG_PMAC_MEDIABAY
 		if (check_media_bay_by_base(pmif->regbase, MB_CD) == 0) {
-			drive->noprobe = 0;
+			drive->dev_flags &= ~IDE_DFLAG_NOPROBE;
 			return;
 		}
 #endif
-		drive->noprobe = 1;
+		drive->dev_flags |= IDE_DFLAG_NOPROBE;
 	}
 }
 
@@ -1535,18 +1523,6 @@ use_pio_instead:
 	return 0; /* revert to PIO for this request */
 }
 
-/* Teardown mappings after DMA has completed.  */
-static void
-pmac_ide_destroy_dmatable (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	if (hwif->sg_nents) {
-		ide_destroy_dmatable(drive);
-		hwif->sg_nents = 0;
-	}
-}
-
 /*
  * Prepare a DMA transfer. We build the DMA table, adjust the timings for
  * a read on KeyLargo ATA/66 and mark us as waiting for DMA completion
@@ -1558,12 +1534,7 @@ pmac_ide_dma_setup(ide_drive_t *drive)
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct request *rq = HWGROUP(drive)->rq;
-	u8 unit = (drive->select.b.unit & 0x01);
-	u8 ata4;
-
-	if (pmif == NULL)
-		return 1;
-	ata4 = (pmif->kind == controller_kl_ata4);	
+	u8 unit = drive->dn & 1, ata4 = (pmif->kind == controller_kl_ata4);
 
 	if (!pmac_ide_build_dmatable(drive, rq)) {
 		ide_map_sg(drive, rq);
@@ -1617,17 +1588,15 @@ pmac_ide_dma_end (ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	volatile struct dbdma_regs __iomem *dma;
+	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	u32 dstat;
-	
-	if (pmif == NULL)
-		return 0;
-	dma = pmif->dma_regs;
 
 	drive->waiting_for_dma = 0;
 	dstat = readl(&dma->status);
 	writel(((RUN|WAKE|DEAD) << 16), &dma->control);
-	pmac_ide_destroy_dmatable(drive);
+
+	ide_destroy_dmatable(drive);
+
 	/* verify good dma status. we don't check for ACTIVE beeing 0. We should...
 	 * in theory, but with ATAPI decices doing buffer underruns, that would
 	 * cause us to disable DMA, which isn't what we want
@@ -1647,13 +1616,9 @@ pmac_ide_dma_test_irq (ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	volatile struct dbdma_regs __iomem *dma;
+	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	unsigned long status, timeout;
 
-	if (pmif == NULL)
-		return 0;
-	dma = pmif->dma_regs;
-
 	/* We have to things to deal with here:
 	 * 
 	 * - The dbdma won't stop if the command was started
@@ -1672,9 +1637,6 @@ pmac_ide_dma_test_irq (ide_drive_t *drive)
 	status = readl(&dma->status);
 	if (!(status & ACTIVE))
 		return 1;
-	if (!drive->waiting_for_dma)
-		printk(KERN_WARNING "ide%d, ide_dma_test_irq \
-			called while not waiting\n", HWIF(drive)->index);
 
 	/* If dbdma didn't execute the STOP command yet, the
 	 * active bit is still set. We consider that we aren't
@@ -1709,14 +1671,9 @@ pmac_ide_dma_lost_irq (ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	volatile struct dbdma_regs __iomem *dma;
-	unsigned long status;
-
-	if (pmif == NULL)
-		return;
-	dma = pmif->dma_regs;
+	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
+	unsigned long status = readl(&dma->status);
 
-	status = readl(&dma->status);
 	printk(KERN_ERR "ide-pmac lost interrupt, dma status: %lx\n", status);
 }
 
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 90212ac..740bad4 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -82,7 +82,6 @@ typedef struct ide_scsi_obj {
 	struct gendisk		*disk;
 	struct Scsi_Host	*host;
 
-	struct ide_atapi_pc *pc;		/* Current packet command */
 	unsigned long transform;		/* SCSI cmd translation layer */
 	unsigned long log;			/* log flags */
 } idescsi_scsi_t;
@@ -137,10 +136,10 @@ static void ide_scsi_hex_dump(u8 *data, int len)
 
 static int idescsi_end_request(ide_drive_t *, int, int);
 
-static void ide_scsi_callback(ide_drive_t *drive)
+static void ide_scsi_callback(ide_drive_t *drive, int dsc)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	struct ide_atapi_pc *pc = scsi->pc;
+	struct ide_atapi_pc *pc = drive->pc;
 
 	if (pc->flags & PC_FLAG_TIMEDOUT)
 		debug_log("%s: got timed out packet %lu at %lu\n", __func__,
@@ -267,49 +266,10 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	spin_unlock_irqrestore(host->host_lock, flags);
 	kfree(pc);
 	blk_put_request(rq);
-	scsi->pc = NULL;
+	drive->pc = NULL;
 	return 0;
 }
 
-static inline unsigned long get_timeout(struct ide_atapi_pc *pc)
-{
-	return max_t(unsigned long, WAIT_CMD, pc->timeout - jiffies);
-}
-
-static int idescsi_expiry(ide_drive_t *drive)
-{
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	struct ide_atapi_pc   *pc   = scsi->pc;
-
-	debug_log("%s called for %lu at %lu\n", __func__,
-		  pc->scsi_cmd->serial_number, jiffies);
-
-	pc->flags |= PC_FLAG_TIMEDOUT;
-
-	return 0;					/* we do not want the ide subsystem to retry */
-}
-
-/*
- *	Our interrupt handler.
- */
-static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
-{
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	struct ide_atapi_pc *pc = scsi->pc;
-
-	return ide_pc_intr(drive, pc, idescsi_pc_intr, get_timeout(pc),
-			   idescsi_expiry, NULL, NULL, NULL,
-			   ide_io_buffers);
-}
-
-static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
-{
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-
-	return ide_transfer_pc(drive, scsi->pc, idescsi_pc_intr,
-			       get_timeout(scsi->pc), idescsi_expiry);
-}
-
 static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
 {
 	switch (pc->c[0]) {
@@ -352,13 +312,10 @@ static int idescsi_map_sg(ide_drive_t *drive, struct ide_atapi_pc *pc)
 static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
 {
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-
 	/* Set the current packet command */
-	scsi->pc = pc;
+	drive->pc = pc;
 
-	return ide_issue_pc(drive, pc, idescsi_transfer_pc,
-			    get_timeout(pc), idescsi_expiry);
+	return ide_issue_pc(drive, ide_scsi_get_timeout(pc), ide_scsi_expiry);
 }
 
 /*
@@ -374,7 +331,8 @@ static ide_startstop_t idescsi_do_request (ide_drive_t *drive, struct request *r
 	if (blk_sense_request(rq) || blk_special_request(rq)) {
 		struct ide_atapi_pc *pc = (struct ide_atapi_pc *)rq->special;
 
-		if (drive->using_dma && !idescsi_map_sg(drive, pc))
+		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) &&
+		    idescsi_map_sg(drive, pc) == 0)
 			pc->flags |= PC_FLAG_DMA_OK;
 
 		return idescsi_issue_pc(drive, pc);
@@ -427,14 +385,14 @@ static const struct ide_proc_devset idescsi_settings[] = {
  */
 static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi)
 {
-	if ((drive->id[ATA_ID_CONFIG] & 0x0060) == 0x20)
-		set_bit(IDE_AFLAG_DRQ_INTERRUPT, &drive->atapi_flags);
 	clear_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
 #if IDESCSI_DEBUG_LOG
 	set_bit(IDESCSI_LOG_CMD, &scsi->log);
 #endif /* IDESCSI_DEBUG_LOG */
 
-	drive->pc_callback = ide_scsi_callback;
+	drive->pc_callback	 = ide_scsi_callback;
+	drive->pc_update_buffers = NULL;
+	drive->pc_io_buffers	 = ide_io_buffers;
 
 	ide_proc_register_driver(drive, scsi->driver);
 }
@@ -456,7 +414,7 @@ static void ide_scsi_remove(ide_drive_t *drive)
 
 	ide_scsi_put(scsi);
 
-	drive->scsi = 0;
+	drive->dev_flags &= ~IDE_DFLAG_SCSI;
 }
 
 static int ide_scsi_probe(ide_drive_t *);
@@ -477,7 +435,6 @@ static ide_driver_t idescsi_driver = {
 	.probe			= ide_scsi_probe,
 	.remove			= ide_scsi_remove,
 	.version		= IDESCSI_VERSION,
-	.media			= ide_scsi,
 	.do_request		= idescsi_do_request,
 	.end_request		= idescsi_end_request,
 	.error                  = idescsi_atapi_error,
@@ -622,6 +579,8 @@ static int idescsi_eh_abort (struct scsi_cmnd *cmd)
 	int		busy;
 	int             ret   = FAILED;
 
+	struct ide_atapi_pc *pc;
+
 	/* In idescsi_eh_abort we try to gently pry our command from the ide subsystem */
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
@@ -642,26 +601,27 @@ static int idescsi_eh_abort (struct scsi_cmnd *cmd)
 	spin_lock_irq(&ide_lock);
 
 	/* If there is no pc running we're done (our interrupt took care of it) */
-	if (!scsi->pc) {
+	pc = drive->pc;
+	if (pc == NULL) {
 		ret = SUCCESS;
 		goto ide_unlock;
 	}
 
 	/* It's somewhere in flight. Does ide subsystem agree? */
-	if (scsi->pc->scsi_cmd->serial_number == cmd->serial_number && !busy &&
-	    elv_queue_empty(drive->queue) && HWGROUP(drive)->rq != scsi->pc->rq) {
+	if (pc->scsi_cmd->serial_number == cmd->serial_number && !busy &&
+	    elv_queue_empty(drive->queue) && HWGROUP(drive)->rq != pc->rq) {
 		/*
 		 * FIXME - not sure this condition can ever occur
 		 */
 		printk (KERN_ERR "ide-scsi: cmd aborted!\n");
 
-		if (blk_sense_request(scsi->pc->rq))
-			kfree(scsi->pc->buf);
+		if (blk_sense_request(pc->rq))
+			kfree(pc->buf);
 		/* we need to call blk_put_request twice. */
-		blk_put_request(scsi->pc->rq);
-		blk_put_request(scsi->pc->rq);
-		kfree(scsi->pc);
-		scsi->pc = NULL;
+		blk_put_request(pc->rq);
+		blk_put_request(pc->rq);
+		kfree(pc);
+		drive->pc = NULL;
 
 		ret = SUCCESS;
 	}
@@ -683,6 +643,8 @@ static int idescsi_eh_reset (struct scsi_cmnd *cmd)
 	int             ready = 0;
 	int             ret   = SUCCESS;
 
+	struct ide_atapi_pc *pc;
+
 	/* In idescsi_eh_reset we forcefully remove the command from the ide subsystem and reset the device. */
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
@@ -697,7 +659,9 @@ static int idescsi_eh_reset (struct scsi_cmnd *cmd)
 	spin_lock_irq(cmd->device->host->host_lock);
 	spin_lock(&ide_lock);
 
-	if (!scsi->pc || (req = scsi->pc->rq) != HWGROUP(drive)->rq || !HWGROUP(drive)->handler) {
+	pc = drive->pc;
+
+	if (pc == NULL || (req = pc->rq) != HWGROUP(drive)->rq || !HWGROUP(drive)->handler) {
 		printk (KERN_WARNING "ide-scsi: No active request in idescsi_eh_reset\n");
 		spin_unlock(&ide_lock);
 		spin_unlock_irq(cmd->device->host->host_lock);
@@ -708,9 +672,9 @@ static int idescsi_eh_reset (struct scsi_cmnd *cmd)
 	if (__blk_end_request(req, -EIO, 0))
 		BUG();
 	if (blk_sense_request(req))
-		kfree(scsi->pc->buf);
-	kfree(scsi->pc);
-	scsi->pc = NULL;
+		kfree(pc->buf);
+	kfree(pc);
+	drive->pc = NULL;
 	blk_put_request(req);
 
 	/* now nuke the drive queue */
@@ -801,7 +765,7 @@ static int ide_scsi_probe(ide_drive_t *drive)
 	    !(host = scsi_host_alloc(&idescsi_template,sizeof(idescsi_scsi_t))))
 		return -ENODEV;
 
-	drive->scsi = 1;
+	drive->dev_flags |= IDE_DFLAG_SCSI;
 
 	g = alloc_disk(1 << PARTN_BITS);
 	if (!g)
@@ -842,7 +806,7 @@ static int ide_scsi_probe(ide_drive_t *drive)
 
 	put_disk(g);
 out_host_put:
-	drive->scsi = 0;
+	drive->dev_flags &= ~IDE_DFLAG_SCSI;
 	scsi_host_put(host);
 	return err;
 }
diff --git a/include/linux/ide.h b/include/linux/ide.h
index a9d82d6..c47e371 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -48,12 +48,6 @@ typedef unsigned char	byte;	/* used everywhere */
 #define ERROR_RESET	3	/* Reset controller every 4th retry */
 #define ERROR_RECAL	1	/* Recalibrate every 2nd retry */
 
-/*
- * state flags
- */
-
-#define DMA_PIO_RETRY	1	/* retrying in PIO */
-
 #define HWIF(drive)		((ide_hwif_t *)((drive)->hwif))
 #define HWGROUP(drive)		((ide_hwgroup_t *)(HWIF(drive)->hwgroup))
 
@@ -162,6 +156,8 @@ enum {
  */
 #define REQ_DRIVE_RESET		0x20
 #define REQ_DEVSET_EXEC		0x21
+#define REQ_PARK_HEADS		0x22
+#define REQ_UNPARK_HEADS	0x23
 
 /*
  * Check for an interrupt and acknowledge the interrupt status
@@ -268,8 +264,6 @@ static inline int __ide_default_irq(unsigned long base)
  * set_geometry	: respecify drive geometry
  * recalibrate	: seek to cyl 0
  * set_multmode	: set multmode count
- * set_tune	: tune interface for drive
- * serviced	: service command
  * reserved	: unused
  */
 typedef union {
@@ -278,43 +272,11 @@ typedef union {
 		unsigned set_geometry	: 1;
 		unsigned recalibrate	: 1;
 		unsigned set_multmode	: 1;
-		unsigned set_tune	: 1;
-		unsigned serviced	: 1;
-		unsigned reserved	: 3;
+		unsigned reserved	: 5;
 	} b;
 } special_t;
 
 /*
- * ATA-IDE Select Register, aka Device-Head
- *
- * head		: always zeros here
- * unit		: drive select number: 0/1
- * bit5		: always 1
- * lba		: using LBA instead of CHS
- * bit7		: always 1
- */
-typedef union {
-	unsigned all			: 8;
-	struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-		unsigned head		: 4;
-		unsigned unit		: 1;
-		unsigned bit5		: 1;
-		unsigned lba		: 1;
-		unsigned bit7		: 1;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-		unsigned bit7		: 1;
-		unsigned lba		: 1;
-		unsigned bit5		: 1;
-		unsigned unit		: 1;
-		unsigned head		: 4;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-	} b;
-} select_t, ata_select_t;
-
-/*
  * Status returned from various ide_ functions
  */
 typedef enum {
@@ -322,6 +284,175 @@ typedef enum {
 	ide_started,	/* a drive operation was started, handler was set */
 } ide_startstop_t;
 
+enum {
+	IDE_TFLAG_LBA48			= (1 << 0),
+	IDE_TFLAG_FLAGGED		= (1 << 2),
+	IDE_TFLAG_OUT_DATA		= (1 << 3),
+	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 4),
+	IDE_TFLAG_OUT_HOB_NSECT		= (1 << 5),
+	IDE_TFLAG_OUT_HOB_LBAL		= (1 << 6),
+	IDE_TFLAG_OUT_HOB_LBAM		= (1 << 7),
+	IDE_TFLAG_OUT_HOB_LBAH		= (1 << 8),
+	IDE_TFLAG_OUT_HOB		= IDE_TFLAG_OUT_HOB_FEATURE |
+					  IDE_TFLAG_OUT_HOB_NSECT |
+					  IDE_TFLAG_OUT_HOB_LBAL |
+					  IDE_TFLAG_OUT_HOB_LBAM |
+					  IDE_TFLAG_OUT_HOB_LBAH,
+	IDE_TFLAG_OUT_FEATURE		= (1 << 9),
+	IDE_TFLAG_OUT_NSECT		= (1 << 10),
+	IDE_TFLAG_OUT_LBAL		= (1 << 11),
+	IDE_TFLAG_OUT_LBAM		= (1 << 12),
+	IDE_TFLAG_OUT_LBAH		= (1 << 13),
+	IDE_TFLAG_OUT_TF		= IDE_TFLAG_OUT_FEATURE |
+					  IDE_TFLAG_OUT_NSECT |
+					  IDE_TFLAG_OUT_LBAL |
+					  IDE_TFLAG_OUT_LBAM |
+					  IDE_TFLAG_OUT_LBAH,
+	IDE_TFLAG_OUT_DEVICE		= (1 << 14),
+	IDE_TFLAG_WRITE			= (1 << 15),
+	IDE_TFLAG_FLAGGED_SET_IN_FLAGS	= (1 << 16),
+	IDE_TFLAG_IN_DATA		= (1 << 17),
+	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 18),
+	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 19),
+	IDE_TFLAG_IN_HOB_FEATURE	= (1 << 20),
+	IDE_TFLAG_IN_HOB_NSECT		= (1 << 21),
+	IDE_TFLAG_IN_HOB_LBAL		= (1 << 22),
+	IDE_TFLAG_IN_HOB_LBAM		= (1 << 23),
+	IDE_TFLAG_IN_HOB_LBAH		= (1 << 24),
+	IDE_TFLAG_IN_HOB_LBA		= IDE_TFLAG_IN_HOB_LBAL |
+					  IDE_TFLAG_IN_HOB_LBAM |
+					  IDE_TFLAG_IN_HOB_LBAH,
+	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_FEATURE |
+					  IDE_TFLAG_IN_HOB_NSECT |
+					  IDE_TFLAG_IN_HOB_LBA,
+	IDE_TFLAG_IN_FEATURE		= (1 << 1),
+	IDE_TFLAG_IN_NSECT		= (1 << 25),
+	IDE_TFLAG_IN_LBAL		= (1 << 26),
+	IDE_TFLAG_IN_LBAM		= (1 << 27),
+	IDE_TFLAG_IN_LBAH		= (1 << 28),
+	IDE_TFLAG_IN_LBA		= IDE_TFLAG_IN_LBAL |
+					  IDE_TFLAG_IN_LBAM |
+					  IDE_TFLAG_IN_LBAH,
+	IDE_TFLAG_IN_TF			= IDE_TFLAG_IN_NSECT |
+					  IDE_TFLAG_IN_LBA,
+	IDE_TFLAG_IN_DEVICE		= (1 << 29),
+	IDE_TFLAG_HOB			= IDE_TFLAG_OUT_HOB |
+					  IDE_TFLAG_IN_HOB,
+	IDE_TFLAG_TF			= IDE_TFLAG_OUT_TF |
+					  IDE_TFLAG_IN_TF,
+	IDE_TFLAG_DEVICE		= IDE_TFLAG_OUT_DEVICE |
+					  IDE_TFLAG_IN_DEVICE,
+	/* force 16-bit I/O operations */
+	IDE_TFLAG_IO_16BIT		= (1 << 30),
+	/* ide_task_t was allocated using kmalloc() */
+	IDE_TFLAG_DYN			= (1 << 31),
+};
+
+struct ide_taskfile {
+	u8	hob_data;	/*  0: high data byte (for TASKFILE IOCTL) */
+
+	u8	hob_feature;	/*  1-5: additional data to support LBA48 */
+	u8	hob_nsect;
+	u8	hob_lbal;
+	u8	hob_lbam;
+	u8	hob_lbah;
+
+	u8	data;		/*  6: low data byte (for TASKFILE IOCTL) */
+
+	union {			/*  7: */
+		u8 error;	/*   read:  error */
+		u8 feature;	/*  write: feature */
+	};
+
+	u8	nsect;		/*  8: number of sectors */
+	u8	lbal;		/*  9: LBA low */
+	u8	lbam;		/* 10: LBA mid */
+	u8	lbah;		/* 11: LBA high */
+
+	u8	device;		/* 12: device select */
+
+	union {			/* 13: */
+		u8 status;	/*  read: status  */
+		u8 command;	/* write: command */
+	};
+};
+
+typedef struct ide_task_s {
+	union {
+		struct ide_taskfile	tf;
+		u8			tf_array[14];
+	};
+	u32			tf_flags;
+	int			data_phase;
+	struct request		*rq;		/* copy of request */
+	void			*special;	/* valid_t generally */
+} ide_task_t;
+
+/* ATAPI packet command flags */
+enum {
+	/* set when an error is considered normal - no retry (ide-tape) */
+	PC_FLAG_ABORT			= (1 << 0),
+	PC_FLAG_SUPPRESS_ERROR		= (1 << 1),
+	PC_FLAG_WAIT_FOR_DSC		= (1 << 2),
+	PC_FLAG_DMA_OK			= (1 << 3),
+	PC_FLAG_DMA_IN_PROGRESS		= (1 << 4),
+	PC_FLAG_DMA_ERROR		= (1 << 5),
+	PC_FLAG_WRITING			= (1 << 6),
+	/* command timed out */
+	PC_FLAG_TIMEDOUT		= (1 << 7),
+};
+
+/*
+ * With each packet command, we allocate a buffer of IDE_PC_BUFFER_SIZE bytes.
+ * This is used for several packet commands (not for READ/WRITE commands).
+ */
+#define IDE_PC_BUFFER_SIZE	256
+
+struct ide_atapi_pc {
+	/* actual packet bytes */
+	u8 c[12];
+	/* incremented on each retry */
+	int retries;
+	int error;
+
+	/* bytes to transfer */
+	int req_xfer;
+	/* bytes actually transferred */
+	int xferred;
+
+	/* data buffer */
+	u8 *buf;
+	/* current buffer position */
+	u8 *cur_pos;
+	int buf_size;
+	/* missing/available data on the current buffer */
+	int b_count;
+
+	/* the corresponding request */
+	struct request *rq;
+
+	unsigned long flags;
+
+	/*
+	 * those are more or less driver-specific and some of them are subject
+	 * to change/removal later.
+	 */
+	u8 pc_buf[IDE_PC_BUFFER_SIZE];
+
+	/* idetape only */
+	struct idetape_bh *bh;
+	char *b_data;
+
+	/* idescsi only for now */
+	struct scatterlist *sg;
+	unsigned int sg_cnt;
+
+	struct scsi_cmnd *scsi_cmd;
+	void (*done) (struct scsi_cmnd *);
+
+	unsigned long timeout;
+};
+
 struct ide_devset;
 struct ide_driver_s;
 
@@ -394,6 +525,62 @@ enum {
 	IDE_AFLAG_NO_AUTOCLOSE		= (1 << 29),
 };
 
+/* device flags */
+enum {
+	/* restore settings after device reset */
+	IDE_DFLAG_KEEP_SETTINGS		= (1 << 0),
+	/* device is using DMA for read/write */
+	IDE_DFLAG_USING_DMA		= (1 << 1),
+	/* okay to unmask other IRQs */
+	IDE_DFLAG_UNMASK		= (1 << 2),
+	/* don't attempt flushes */
+	IDE_DFLAG_NOFLUSH		= (1 << 3),
+	/* DSC overlap */
+	IDE_DFLAG_DSC_OVERLAP		= (1 << 4),
+	/* give potential excess bandwidth */
+	IDE_DFLAG_NICE1			= (1 << 5),
+	/* device is physically present */
+	IDE_DFLAG_PRESENT		= (1 << 6),
+	/* device ejected hint */
+	IDE_DFLAG_DEAD			= (1 << 7),
+	/* id read from device (synthetic if not set) */
+	IDE_DFLAG_ID_READ		= (1 << 8),
+	IDE_DFLAG_NOPROBE		= (1 << 9),
+	/* need to do check_media_change() */
+	IDE_DFLAG_REMOVABLE		= (1 << 10),
+	/* needed for removable devices */
+	IDE_DFLAG_ATTACH		= (1 << 11),
+	IDE_DFLAG_FORCED_GEOM		= (1 << 12),
+	/* disallow setting unmask bit */
+	IDE_DFLAG_NO_UNMASK		= (1 << 13),
+	/* disallow enabling 32-bit I/O */
+	IDE_DFLAG_NO_IO_32BIT		= (1 << 14),
+	/* for removable only: door lock/unlock works */
+	IDE_DFLAG_DOORLOCKING		= (1 << 15),
+	/* disallow DMA */
+	IDE_DFLAG_NODMA			= (1 << 16),
+	/* powermanagment told us not to do anything, so sleep nicely */
+	IDE_DFLAG_BLOCKED		= (1 << 17),
+	/* ide-scsi emulation */
+	IDE_DFLAG_SCSI			= (1 << 18),
+	/* sleeping & sleep field valid */
+	IDE_DFLAG_SLEEPING		= (1 << 19),
+	IDE_DFLAG_POST_RESET		= (1 << 20),
+	IDE_DFLAG_UDMA33_WARNED		= (1 << 21),
+	IDE_DFLAG_LBA48			= (1 << 22),
+	/* status of write cache */
+	IDE_DFLAG_WCACHE		= (1 << 23),
+	/* used for ignoring ATA_DF */
+	IDE_DFLAG_NOWERR		= (1 << 24),
+	/* retrying in PIO */
+	IDE_DFLAG_DMA_PIO_RETRY		= (1 << 25),
+	IDE_DFLAG_LBA			= (1 << 26),
+	/* don't unload heads */
+	IDE_DFLAG_NO_UNLOAD		= (1 << 27),
+	/* heads unloaded, please don't reset port */
+	IDE_DFLAG_PARKED		= (1 << 28)
+};
+
 struct ide_drive_s {
 	char		name[4];	/* drive name, such as "hda" */
         char            driver_req[10];	/* requests specific driver */
@@ -410,43 +597,19 @@ struct ide_drive_s {
 #endif
 	struct hwif_s		*hwif;	/* actually (ide_hwif_t *) */
 
+	unsigned long dev_flags;
+
 	unsigned long sleep;		/* sleep until this time */
 	unsigned long service_start;	/* time we started last request */
 	unsigned long service_time;	/* service time of last request */
 	unsigned long timeout;		/* max time to wait for irq */
 
 	special_t	special;	/* special action flags */
-	select_t	select;		/* basic drive/head select reg value */
 
+	u8	select;			/* basic drive/head select reg value */
 	u8	retry_pio;		/* retrying dma capable host in pio */
-	u8	state;			/* retry state */
 	u8	waiting_for_dma;	/* dma currently in progress */
-
-	unsigned keep_settings	: 1;	/* restore settings after drive reset */
-	unsigned using_dma	: 1;	/* disk is using dma for read/write */
-	unsigned unmask		: 1;	/* okay to unmask other irqs */
-	unsigned noflush	: 1;	/* don't attempt flushes */
-	unsigned dsc_overlap	: 1;	/* DSC overlap */
-	unsigned nice1		: 1;	/* give potential excess bandwidth */
-	unsigned present	: 1;	/* drive is physically present */
-	unsigned dead		: 1;	/* device ejected hint */
-	unsigned id_read	: 1;	/* 1=id read from disk 0 = synthetic */
-	unsigned noprobe 	: 1;	/* from:  hdx=noprobe */
-	unsigned removable	: 1;	/* 1 if need to do check_media_change */
-	unsigned attach		: 1;	/* needed for removable devices */
-	unsigned forced_geom	: 1;	/* 1 if hdx=c,h,s was given at boot */
-	unsigned no_unmask	: 1;	/* disallow setting unmask bit */
-	unsigned no_io_32bit	: 1;	/* disallow enabling 32bit I/O */
-	unsigned doorlocking	: 1;	/* for removable only: door lock/unlock works */
-	unsigned nodma		: 1;	/* disallow DMA */
-	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
-	unsigned scsi		: 1;	/* 0=default, 1=ide-scsi emulation */
-	unsigned sleeping	: 1;	/* 1=sleeping & sleep field valid */
-	unsigned post_reset	: 1;
-	unsigned udma33_warned	: 1;
-	unsigned addressing	: 2;	/* 0=28-bit, 1=48-bit, 2=48-bit doing 28-bit */
-	unsigned wcache		: 1;	/* status of write cache */
-	unsigned nowerr		: 1;	/* used for ignoring ATA_DF */
+	u8	dma;			/* atapi dma flag */
 
         u8	quirk_list;	/* considered quirky, set for a specific host */
         u8	init_speed;	/* transfer rate set at boot */
@@ -458,7 +621,6 @@ struct ide_drive_s {
 	u8	ready_stat;	/* min status value for drive ready */
 	u8	mult_count;	/* current multiple sector setting */
 	u8	mult_req;	/* requested multiple sector setting */
-	u8	tune_req;	/* requested drive tuning setting */
 	u8	io_32bit;	/* 0=16-bit, 1=32-bit, 2/3=32bit+sync */
 	u8	bad_wstat;	/* used for ignoring ATA_DF */
 	u8	head;		/* "real" number of heads */
@@ -466,6 +628,9 @@ struct ide_drive_s {
 	u8	bios_head;	/* BIOS/fdisk/LILO number of heads */
 	u8	bios_sect;	/* BIOS/fdisk/LILO sectors per track */
 
+	/* delay this long before sending packet command */
+	u8 pc_delay;
+
 	unsigned int	bios_cyl;	/* BIOS/fdisk/LILO number of cyls */
 	unsigned int	cyl;		/* "real" number of cyls */
 	unsigned int	drive_data;	/* used by set_pio_mode/selectproc */
@@ -477,6 +642,9 @@ struct ide_drive_s {
 
 	int		lun;		/* logical unit */
 	int		crc_count;	/* crc counter to reduce drive speed */
+
+	unsigned long	debug_mask;	/* debugging levels switch */
+
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	struct ide_acpi_drive_link *acpidata;
 #endif
@@ -484,17 +652,32 @@ struct ide_drive_s {
 	struct device	gendev;
 	struct completion gendev_rel_comp;	/* to deal with device release() */
 
+	/* current packet command */
+	struct ide_atapi_pc *pc;
+
 	/* callback for packet commands */
-	void (*pc_callback)(struct ide_drive_s *);
+	void (*pc_callback)(struct ide_drive_s *, int);
+
+	void (*pc_update_buffers)(struct ide_drive_s *, struct ide_atapi_pc *);
+	int  (*pc_io_buffers)(struct ide_drive_s *, struct ide_atapi_pc *,
+			      unsigned int, int);
 
 	unsigned long atapi_flags;
+
+	struct ide_atapi_pc request_sense_pc;
+	struct request request_sense_rq;
 };
 
 typedef struct ide_drive_s ide_drive_t;
 
-#define to_ide_device(dev)container_of(dev, ide_drive_t, gendev)
+#define to_ide_device(dev)		container_of(dev, ide_drive_t, gendev)
+
+#define to_ide_drv(obj, cont_type)	\
+	container_of(obj, struct cont_type, kref)
+
+#define ide_drv_g(disk, cont_type)	\
+	container_of((disk)->private_data, struct cont_type, driver)
 
-struct ide_task_s;
 struct ide_port_info;
 
 struct ide_tp_ops {
@@ -528,6 +711,7 @@ extern const struct ide_tp_ops default_tp_ops;
  * @resetproc:		routine to reset controller after a disk reset
  * @maskproc:		special host masking for drive selection
  * @quirkproc:		check host's drive quirk list
+ * @clear_irq:		clear IRQ
  *
  * @mdma_filter:	filter MDMA modes
  * @udma_filter:	filter UDMA modes
@@ -544,6 +728,7 @@ struct ide_port_ops {
 	void	(*resetproc)(ide_drive_t *);
 	void	(*maskproc)(ide_drive_t *, int);
 	void	(*quirkproc)(ide_drive_t *);
+	void	(*clear_irq)(ide_drive_t *);
 
 	u8	(*mdma_filter)(ide_drive_t *);
 	u8	(*udma_filter)(ide_drive_t *);
@@ -606,12 +791,16 @@ typedef struct hwif_s {
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
-	void (*ide_dma_clear_irq)(ide_drive_t *drive);
-
 	/* dma physical region descriptor table (cpu view) */
 	unsigned int	*dmatable_cpu;
 	/* dma physical region descriptor table (dma view) */
 	dma_addr_t	dmatable_dma;
+
+	/* maximum number of PRD table entries */
+	int prd_max_nents;
+	/* PRD entry size in bytes */
+	int prd_ent_size;
+
 	/* Scatter-gather list used to build the above */
 	struct scatterlist *sg_table;
 	int sg_max_nents;		/* Maximum number of entries in it */
@@ -621,6 +810,8 @@ typedef struct hwif_s {
 	/* data phase of the active command (currently only valid for PIO/DMA) */
 	int		data_phase;
 
+	struct ide_task_s task;		/* current command */
+
 	unsigned int nsect;
 	unsigned int nleft;
 	struct scatterlist *cursg;
@@ -649,15 +840,15 @@ typedef struct hwif_s {
 
 	void		*hwif_data;	/* extra hwif data */
 
-	unsigned dma;
-
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	struct ide_acpi_hwif_link *acpidata;
 #endif
 } ____cacheline_internodealigned_in_smp ide_hwif_t;
 
+#define MAX_HOST_PORTS 4
+
 struct ide_host {
-	ide_hwif_t	*ports[MAX_HWIFS];
+	ide_hwif_t	*ports[MAX_HOST_PORTS];
 	unsigned int	n_ports;
 	struct device	*dev[2];
 	unsigned int	(*init_chipset)(struct pci_dev *);
@@ -739,6 +930,22 @@ static int set_##name(ide_drive_t *drive, int arg) \
 	return 0; \
 }
 
+#define ide_devset_get_flag(name, flag) \
+static int get_##name(ide_drive_t *drive) \
+{ \
+	return !!(drive->dev_flags & flag); \
+}
+
+#define ide_devset_set_flag(name, flag) \
+static int set_##name(ide_drive_t *drive, int arg) \
+{ \
+	if (arg) \
+		drive->dev_flags |= flag; \
+	else \
+		drive->dev_flags &= ~flag; \
+	return 0; \
+}
+
 #define __IDE_DEVSET(_name, _flags, _get, _set) \
 const struct ide_devset ide_devset_##_name = \
 	__DEVSET(_flags, _get, _set)
@@ -752,8 +959,11 @@ IDE_DEVSET(_name, 0, get_##_func, set_##_func)
 #define ide_devset_w(_name, _func) \
 IDE_DEVSET(_name, 0, NULL, set_##_func)
 
-#define ide_devset_rw_sync(_name, _func) \
-IDE_DEVSET(_name, DS_SYNC, get_##_func, set_##_func)
+#define ide_ext_devset_rw(_name, _func) \
+__IDE_DEVSET(_name, 0, get_##_func, set_##_func)
+
+#define ide_ext_devset_rw_sync(_name, _func) \
+__IDE_DEVSET(_name, DS_SYNC, get_##_func, set_##_func)
 
 #define ide_decl_devset(_name) \
 extern const struct ide_devset ide_devset_##_name
@@ -764,71 +974,6 @@ ide_decl_devset(pio_mode);
 ide_decl_devset(unmaskirq);
 ide_decl_devset(using_dma);
 
-/* ATAPI packet command flags */
-enum {
-	/* set when an error is considered normal - no retry (ide-tape) */
-	PC_FLAG_ABORT			= (1 << 0),
-	PC_FLAG_SUPPRESS_ERROR		= (1 << 1),
-	PC_FLAG_WAIT_FOR_DSC		= (1 << 2),
-	PC_FLAG_DMA_OK			= (1 << 3),
-	PC_FLAG_DMA_IN_PROGRESS		= (1 << 4),
-	PC_FLAG_DMA_ERROR		= (1 << 5),
-	PC_FLAG_WRITING			= (1 << 6),
-	/* command timed out */
-	PC_FLAG_TIMEDOUT		= (1 << 7),
-};
-
-/*
- * With each packet command, we allocate a buffer of IDE_PC_BUFFER_SIZE bytes.
- * This is used for several packet commands (not for READ/WRITE commands).
- */
-#define IDE_PC_BUFFER_SIZE	256
-
-struct ide_atapi_pc {
-	/* actual packet bytes */
-	u8 c[12];
-	/* incremented on each retry */
-	int retries;
-	int error;
-
-	/* bytes to transfer */
-	int req_xfer;
-	/* bytes actually transferred */
-	int xferred;
-
-	/* data buffer */
-	u8 *buf;
-	/* current buffer position */
-	u8 *cur_pos;
-	int buf_size;
-	/* missing/available data on the current buffer */
-	int b_count;
-
-	/* the corresponding request */
-	struct request *rq;
-
-	unsigned long flags;
-
-	/*
-	 * those are more or less driver-specific and some of them are subject
-	 * to change/removal later.
-	 */
-	u8 pc_buf[IDE_PC_BUFFER_SIZE];
-
-	/* idetape only */
-	struct idetape_bh *bh;
-	char *b_data;
-
-	/* idescsi only for now */
-	struct scatterlist *sg;
-	unsigned int sg_cnt;
-
-	struct scsi_cmnd *scsi_cmd;
-	void (*done) (struct scsi_cmnd *);
-
-	unsigned long timeout;
-};
-
 #ifdef CONFIG_IDE_PROC_FS
 /*
  * /proc/ide interface
@@ -839,6 +984,11 @@ ide_devset_get(_name, _field); \
 ide_devset_set(_name, _field); \
 IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
 
+#define ide_devset_rw_flag(_name, _field) \
+ide_devset_get_flag(_name, _field); \
+ide_devset_set_flag(_name, _field); \
+IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
+
 struct ide_proc_devset {
 	const char		*name;
 	const struct ide_devset	*setting;
@@ -905,37 +1055,55 @@ static inline void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *
 #define PROC_IDE_READ_RETURN(page,start,off,count,eof,len) return 0;
 #endif
 
+enum {
+	/* enter/exit functions */
+	IDE_DBG_FUNC =			(1 << 0),
+	/* sense key/asc handling */
+	IDE_DBG_SENSE =			(1 << 1),
+	/* packet commands handling */
+	IDE_DBG_PC =			(1 << 2),
+	/* request handling */
+	IDE_DBG_RQ =			(1 << 3),
+	/* driver probing/setup */
+	IDE_DBG_PROBE =			(1 << 4),
+};
+
+/* DRV_NAME has to be defined in the driver before using the macro below */
+#define __ide_debug_log(lvl, fmt, args...)			\
+{								\
+	if (unlikely(drive->debug_mask & lvl))			\
+		printk(KERN_INFO DRV_NAME ": " fmt, ## args);	\
+}
+
 /*
- * Power Management step value (rq->pm->pm_step).
- *
- * The step value starts at 0 (ide_pm_state_start_suspend) for a
- * suspend operation or 1000 (ide_pm_state_start_resume) for a
- * resume operation.
+ * Power Management state machine (rq->pm->pm_step).
  *
- * For each step, the core calls the subdriver start_power_step() first.
+ * For each step, the core calls ide_start_power_step() first.
  * This can return:
  *	- ide_stopped :	In this case, the core calls us back again unless
  *			step have been set to ide_power_state_completed.
  *	- ide_started :	In this case, the channel is left busy until an
  *			async event (interrupt) occurs.
- * Typically, start_power_step() will issue a taskfile request with
+ * Typically, ide_start_power_step() will issue a taskfile request with
  * do_rw_taskfile().
  *
- * Upon reception of the interrupt, the core will call complete_power_step()
+ * Upon reception of the interrupt, the core will call ide_complete_power_step()
  * with the error code if any. This routine should update the step value
  * and return. It should not start a new request. The core will call
- * start_power_step for the new step value, unless step have been set to
- * ide_power_state_completed.
- *
- * Subdrivers are expected to define their own additional power
- * steps from 1..999 for suspend and from 1001..1999 for resume,
- * other values are reserved for future use.
+ * ide_start_power_step() for the new step value, unless step have been
+ * set to IDE_PM_COMPLETED.
  */
-
 enum {
-	ide_pm_state_completed		= -1,
-	ide_pm_state_start_suspend	= 0,
-	ide_pm_state_start_resume	= 1000,
+	IDE_PM_START_SUSPEND,
+	IDE_PM_FLUSH_CACHE	= IDE_PM_START_SUSPEND,
+	IDE_PM_STANDBY,
+
+	IDE_PM_START_RESUME,
+	IDE_PM_RESTORE_PIO	= IDE_PM_START_RESUME,
+	IDE_PM_IDLE,
+	IDE_PM_RESTORE_DMA,
+
+	IDE_PM_COMPLETED,
 };
 
 /*
@@ -946,7 +1114,6 @@ enum {
  */
 struct ide_driver_s {
 	const char			*version;
-	u8				media;
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
 	int		(*end_request)(ide_drive_t *, int, int);
 	ide_startstop_t	(*error)(ide_drive_t *, struct request *rq, u8, u8);
@@ -1015,110 +1182,6 @@ extern void ide_do_drive_cmd(ide_drive_t *, struct request *);
 
 extern void ide_end_drive_cmd(ide_drive_t *, u8, u8);
 
-enum {
-	IDE_TFLAG_LBA48			= (1 << 0),
-	IDE_TFLAG_FLAGGED		= (1 << 2),
-	IDE_TFLAG_OUT_DATA		= (1 << 3),
-	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 4),
-	IDE_TFLAG_OUT_HOB_NSECT		= (1 << 5),
-	IDE_TFLAG_OUT_HOB_LBAL		= (1 << 6),
-	IDE_TFLAG_OUT_HOB_LBAM		= (1 << 7),
-	IDE_TFLAG_OUT_HOB_LBAH		= (1 << 8),
-	IDE_TFLAG_OUT_HOB		= IDE_TFLAG_OUT_HOB_FEATURE |
-					  IDE_TFLAG_OUT_HOB_NSECT |
-					  IDE_TFLAG_OUT_HOB_LBAL |
-					  IDE_TFLAG_OUT_HOB_LBAM |
-					  IDE_TFLAG_OUT_HOB_LBAH,
-	IDE_TFLAG_OUT_FEATURE		= (1 << 9),
-	IDE_TFLAG_OUT_NSECT		= (1 << 10),
-	IDE_TFLAG_OUT_LBAL		= (1 << 11),
-	IDE_TFLAG_OUT_LBAM		= (1 << 12),
-	IDE_TFLAG_OUT_LBAH		= (1 << 13),
-	IDE_TFLAG_OUT_TF		= IDE_TFLAG_OUT_FEATURE |
-					  IDE_TFLAG_OUT_NSECT |
-					  IDE_TFLAG_OUT_LBAL |
-					  IDE_TFLAG_OUT_LBAM |
-					  IDE_TFLAG_OUT_LBAH,
-	IDE_TFLAG_OUT_DEVICE		= (1 << 14),
-	IDE_TFLAG_WRITE			= (1 << 15),
-	IDE_TFLAG_FLAGGED_SET_IN_FLAGS	= (1 << 16),
-	IDE_TFLAG_IN_DATA		= (1 << 17),
-	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 18),
-	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 19),
-	IDE_TFLAG_IN_HOB_FEATURE	= (1 << 20),
-	IDE_TFLAG_IN_HOB_NSECT		= (1 << 21),
-	IDE_TFLAG_IN_HOB_LBAL		= (1 << 22),
-	IDE_TFLAG_IN_HOB_LBAM		= (1 << 23),
-	IDE_TFLAG_IN_HOB_LBAH		= (1 << 24),
-	IDE_TFLAG_IN_HOB_LBA		= IDE_TFLAG_IN_HOB_LBAL |
-					  IDE_TFLAG_IN_HOB_LBAM |
-					  IDE_TFLAG_IN_HOB_LBAH,
-	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_FEATURE |
-					  IDE_TFLAG_IN_HOB_NSECT |
-					  IDE_TFLAG_IN_HOB_LBA,
-	IDE_TFLAG_IN_FEATURE		= (1 << 1),
-	IDE_TFLAG_IN_NSECT		= (1 << 25),
-	IDE_TFLAG_IN_LBAL		= (1 << 26),
-	IDE_TFLAG_IN_LBAM		= (1 << 27),
-	IDE_TFLAG_IN_LBAH		= (1 << 28),
-	IDE_TFLAG_IN_LBA		= IDE_TFLAG_IN_LBAL |
-					  IDE_TFLAG_IN_LBAM |
-					  IDE_TFLAG_IN_LBAH,
-	IDE_TFLAG_IN_TF			= IDE_TFLAG_IN_NSECT |
-					  IDE_TFLAG_IN_LBA,
-	IDE_TFLAG_IN_DEVICE		= (1 << 29),
-	IDE_TFLAG_HOB			= IDE_TFLAG_OUT_HOB |
-					  IDE_TFLAG_IN_HOB,
-	IDE_TFLAG_TF			= IDE_TFLAG_OUT_TF |
-					  IDE_TFLAG_IN_TF,
-	IDE_TFLAG_DEVICE		= IDE_TFLAG_OUT_DEVICE |
-					  IDE_TFLAG_IN_DEVICE,
-	/* force 16-bit I/O operations */
-	IDE_TFLAG_IO_16BIT		= (1 << 30),
-	/* ide_task_t was allocated using kmalloc() */
-	IDE_TFLAG_DYN			= (1 << 31),
-};
-
-struct ide_taskfile {
-	u8	hob_data;	/*  0: high data byte (for TASKFILE IOCTL) */
-
-	u8	hob_feature;	/*  1-5: additional data to support LBA48 */
-	u8	hob_nsect;
-	u8	hob_lbal;
-	u8	hob_lbam;
-	u8	hob_lbah;
-
-	u8	data;		/*  6: low data byte (for TASKFILE IOCTL) */
-
-	union {			/*  7: */
-		u8 error;	/*   read:  error */
-		u8 feature;	/*  write: feature */
-	};
-
-	u8	nsect;		/*  8: number of sectors */
-	u8	lbal;		/*  9: LBA low */
-	u8	lbam;		/* 10: LBA mid */
-	u8	lbah;		/* 11: LBA high */
-
-	u8	device;		/* 12: device select */
-
-	union {			/* 13: */
-		u8 status;	/*  read: status  */
-		u8 command;	/* write: command */
-	};
-};
-
-typedef struct ide_task_s {
-	union {
-		struct ide_taskfile	tf;
-		u8			tf_array[14];
-	};
-	u32			tf_flags;
-	int			data_phase;
-	struct request		*rq;		/* copy of request */
-	void			*special;	/* valid_t generally */
-} ide_task_t;
-
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
 void ide_exec_command(ide_hwif_t *, u8);
@@ -1150,6 +1213,13 @@ int ide_check_atapi_device(ide_drive_t *, const char *);
 
 void ide_init_pc(struct ide_atapi_pc *);
 
+/* Disk head parking */
+extern wait_queue_head_t ide_park_wq;
+ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
+		      char *buf);
+ssize_t ide_park_store(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t len);
+
 /*
  * Special requests for ide-tape block device strategy routine.
  *
@@ -1163,24 +1233,22 @@ enum {
 	REQ_IDETAPE_WRITE	= (1 << 3),
 };
 
-void ide_queue_pc_head(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *,
-		       struct request *);
 int ide_queue_pc_tail(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *);
 
 int ide_do_test_unit_ready(ide_drive_t *, struct gendisk *);
 int ide_do_start_stop(ide_drive_t *, struct gendisk *, int);
 int ide_set_media_lock(ide_drive_t *, struct gendisk *, int);
+void ide_create_request_sense_cmd(ide_drive_t *, struct ide_atapi_pc *);
+void ide_retry_pc(ide_drive_t *, struct gendisk *);
+
+static inline unsigned long ide_scsi_get_timeout(struct ide_atapi_pc *pc)
+{
+	return max_t(unsigned long, WAIT_CMD, pc->timeout - jiffies);
+}
+
+int ide_scsi_expiry(ide_drive_t *);
 
-ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
-	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
-	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
-	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
-	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
-			   int));
-ide_startstop_t ide_transfer_pc(ide_drive_t *, struct ide_atapi_pc *,
-				ide_handler_t *, unsigned int, ide_expiry_t *);
-ide_startstop_t ide_issue_pc(ide_drive_t *, struct ide_atapi_pc *,
-			     ide_handler_t *, unsigned int, ide_expiry_t *);
+ide_startstop_t ide_issue_pc(ide_drive_t *, unsigned int, ide_expiry_t *);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
@@ -1358,6 +1426,7 @@ struct drive_list_entry {
 int ide_in_drive_list(u16 *, const struct drive_list_entry *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
+int ide_dma_good_drive(ide_drive_t *);
 int __ide_dma_bad_drive(ide_drive_t *);
 int ide_id_dma_bug(ide_drive_t *);
 
@@ -1375,25 +1444,29 @@ int ide_set_dma(ide_drive_t *);
 void ide_check_dma_crc(ide_drive_t *);
 ide_startstop_t ide_dma_intr(ide_drive_t *);
 
+int ide_allocate_dma_engine(ide_hwif_t *);
+void ide_release_dma_engine(ide_hwif_t *);
+
 int ide_build_sglist(ide_drive_t *, struct request *);
 void ide_destroy_dmatable(ide_drive_t *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
+int config_drive_for_dma(ide_drive_t *);
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
-int ide_allocate_dma_engine(ide_hwif_t *);
-void ide_release_dma_engine(ide_hwif_t *);
-
 void ide_dma_host_set(ide_drive_t *, int);
 extern int ide_dma_setup(ide_drive_t *);
 void ide_dma_exec_cmd(ide_drive_t *, u8);
 extern void ide_dma_start(ide_drive_t *);
-extern int __ide_dma_end(ide_drive_t *);
+int ide_dma_end(ide_drive_t *);
 int ide_dma_test_irq(ide_drive_t *);
-extern void ide_dma_lost_irq(ide_drive_t *);
-extern void ide_dma_timeout(ide_drive_t *);
 extern const struct ide_dma_ops sff_dma_ops;
+#else
+static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
 
+void ide_dma_lost_irq(ide_drive_t *);
+void ide_dma_timeout(ide_drive_t *);
+
 #else
 static inline int ide_id_dma_bug(ide_drive_t *drive) { return 0; }
 static inline u8 ide_find_dma_mode(ide_drive_t *drive, u8 speed) { return 0; }
@@ -1404,11 +1477,8 @@ static inline void ide_dma_on(ide_drive_t *drive) { ; }
 static inline void ide_dma_verbose(ide_drive_t *drive) { ; }
 static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
 static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
-#endif /* CONFIG_BLK_DEV_IDEDMA */
-
-#ifndef CONFIG_BLK_DEV_IDEDMA_SFF
 static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
-#endif
+#endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
 extern int ide_acpi_exec_tfs(ide_drive_t *drive);
@@ -1436,7 +1506,6 @@ void ide_undecoded_slave(ide_drive_t *);
 
 void ide_port_apply_params(ide_hwif_t *);
 
-struct ide_host *ide_host_alloc_all(const struct ide_port_info *, hw_regs_t **);
 struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **);
 void ide_host_free(struct ide_host *);
 int ide_host_register(struct ide_host *, const struct ide_port_info *,
@@ -1547,6 +1616,6 @@ static inline ide_drive_t *ide_get_pair_dev(ide_drive_t *drive)
 {
 	ide_drive_t *peer = &drive->hwif->drives[(drive->dn ^ 1) & 1];
 
-	return peer->present ? peer : NULL;
+	return (peer->dev_flags & IDE_DFLAG_PRESENT) ? peer : NULL;
 }
 #endif /* _IDE_H */
