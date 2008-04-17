Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYDQXQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYDQXQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 19:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbYDQXQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 19:16:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:10251 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbYDQXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 19:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=d+/01DOOEX+k7qHHIGHLoChAriAOFw7olSfx5EaRhjDS+7bxquR2XeC1gnRqQE2i9lS32XJHM2ZPfuMDqH4E9boBix/Oa5RVqN3q5Sd2LgxGNKcprk4SYZe+bLN65EYqzpQgNTHzUshCgWuvgBR6qoCBuaD8r5U26hUDbuYf5ic=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates part 1
Date: Fri, 18 Apr 2008 01:28:29 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804180128.30370.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Since it's "Merging Spree" again here goes the first IDE update for 2.6.26:

- couple of fixes and preparatory patches for IDE warm-plug support

- rework of PowerMac media-bay support ([un]register IDE devices instead of
  [un]registering IDE interface)

- IDE warm-plug support, to warm-plug devices on a port 'idex':

  # echo -n "1" > /sys/class/ide_port/idex/delete_devices

  unplug old device(s) and plug new device(s)

  #echo -n "1" > /sys/class/ide_port/idex/scan

  done!

- ability to add new interfaces for ide-generic host driver through
  /sys/class/ide_generic/add, i.e.

  echo -n "0x168:0x36e:10" > /sys/class/ide_generic/add

- generic packet command representation for ATAPI  (Borislav Petkov)

- scc_pata update (Akira Iguchi)

- misc stuff...


Because of the above changes some obsoleted/broken code can be removed
(~250 LOC) together with PPC specific hacks (~500 LOC).

Almost all patches have been in IDE tree (which is propagated to both
-mm and -next trees) since middle of February so they should be pretty
polished by now (extra thanks to Sergei Shtylyov for the hard work on
reviewing IDE patches).


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/ide/ide.txt               |   47 +---
 Documentation/ide/warm-plug-howto.txt   |   13 +
 Documentation/kernel-parameters.txt     |    4 +-
 arch/powerpc/kernel/setup_32.c          |    8 -
 arch/powerpc/platforms/powermac/pci.c   |   22 --
 arch/powerpc/platforms/powermac/pmac.h  |    5 -
 arch/powerpc/platforms/powermac/setup.c |    8 -
 arch/ppc/configs/sandpoint_defconfig    |    2 +-
 arch/ppc/kernel/ppc_ksyms.c             |    5 -
 arch/ppc/kernel/setup.c                 |    2 -
 arch/ppc/platforms/4xx/bamboo.c         |    1 -
 arch/ppc/platforms/4xx/ebony.c          |    1 -
 arch/ppc/platforms/4xx/luan.c           |    1 -
 arch/ppc/platforms/4xx/ocotea.c         |    1 -
 arch/ppc/platforms/4xx/taishan.c        |    1 -
 arch/ppc/platforms/4xx/yucca.c          |    1 -
 arch/ppc/platforms/chestnut.c           |    1 -
 arch/ppc/platforms/cpci690.c            |    1 -
 arch/ppc/platforms/ev64260.c            |    1 -
 arch/ppc/platforms/hdpu.c               |   36 --
 arch/ppc/platforms/lopec.c              |   85 -----
 arch/ppc/platforms/mvme5100.c           |    1 -
 arch/ppc/platforms/powerpmc250.c        |    1 -
 arch/ppc/platforms/pplus.c              |   58 ----
 arch/ppc/platforms/prep_setup.c         |   38 ---
 arch/ppc/platforms/prpmc750.c           |    1 -
 arch/ppc/platforms/prpmc800.c           |    1 -
 arch/ppc/platforms/radstone_ppc7d.c     |    1 -
 arch/ppc/platforms/residual.c           |    1 -
 arch/ppc/platforms/sandpoint.c          |   94 ------
 arch/ppc/platforms/sandpoint.h          |    3 -
 arch/ppc/platforms/spruce.c             |    1 -
 arch/ppc/syslib/m8xx_setup.c            |    6 -
 arch/ppc/syslib/ppc4xx_setup.c          |   23 --
 block/compat_ioctl.c                    |    1 -
 drivers/ide/Kconfig                     |   44 +--
 drivers/ide/Makefile                    |    2 +-
 drivers/ide/arm/bast-ide.c              |    6 +-
 drivers/ide/arm/palm_bk3710.c           |    6 +-
 drivers/ide/arm/rapide.c                |    2 +-
 drivers/ide/cris/ide-cris.c             |   18 +-
 drivers/ide/ide-acpi.c                  |    2 +
 drivers/ide/ide-cd.c                    |   10 +-
 drivers/ide/ide-floppy.c                |  346 ++++++++------------
 drivers/ide/ide-generic.c               |   89 +++++-
 drivers/ide/ide-io.c                    |   38 ++-
 drivers/ide/ide-iops.c                  |   86 +++--
 drivers/ide/ide-pnp.c                   |    2 +-
 drivers/ide/ide-probe.c                 |  134 +++++++--
 drivers/ide/ide-proc.c                  |   19 +-
 drivers/ide/ide-scan-pci.c              |    9 +-
 drivers/ide/ide-tape.c                  |  536 ++++++++++++++----------------
 drivers/ide/ide-taskfile.c              |   29 +-
 drivers/ide/ide.c                       |  419 ++++++-------------------
 drivers/ide/legacy/Makefile             |    1 +
 drivers/ide/legacy/ali14xx.c            |   12 +
 drivers/ide/legacy/dtc2278.c            |   12 +
 drivers/ide/legacy/ht6560b.c            |   25 ++-
 drivers/ide/legacy/ide-4drives.c        |   50 +++
 drivers/ide/legacy/ide-cs.c             |    8 +-
 drivers/ide/legacy/ide_platform.c       |    2 +-
 drivers/ide/legacy/qd65xx.c             |   19 +-
 drivers/ide/legacy/umc8672.c            |   12 +
 drivers/ide/mips/au1xxx-ide.c           |    5 +-
 drivers/ide/pci/cmd640.c                |   34 +-
 drivers/ide/pci/delkin_cb.c             |    8 +-
 drivers/ide/pci/hpt366.c                |   61 +----
 drivers/ide/pci/ns87415.c               |    4 +
 drivers/ide/pci/scc_pata.c              |   70 +++-
 drivers/ide/pci/sgiioc4.c               |   20 +-
 drivers/ide/pci/siimage.c               |   43 ---
 drivers/ide/pci/sl82c105.c              |    4 +
 drivers/ide/pci/tc86c001.c              |   36 --
 drivers/ide/ppc/mpc8xx.c                |   86 ++----
 drivers/ide/ppc/pmac.c                  |  104 +-----
 drivers/ide/setup-pci.c                 |   20 +--
 drivers/macintosh/mediabay.c            |   17 +-
 drivers/scsi/ide-scsi.c                 |  203 +++++-------
 include/asm-alpha/ide.h                 |   11 -
 include/asm-arm/ide.h                   |    8 -
 include/asm-blackfin/ide.h              |    4 -
 include/asm-ia64/ide.h                  |   10 -
 include/asm-m32r/ide.h                  |   10 -
 include/asm-mips/mach-generic/ide.h     |   10 -
 include/asm-parisc/ide.h                |    2 -
 include/asm-powerpc/ide.h               |   57 ++--
 include/asm-powerpc/mediabay.h          |    6 +-
 include/asm-sh/ide.h                    |    3 -
 include/asm-sparc/ide.h                 |    2 -
 include/asm-sparc64/ide.h               |    2 -
 include/asm-x86/ide.h                   |   10 -
 include/linux/hdreg.h                   |    4 +-
 include/linux/ide.h                     |  174 ++++++----
 93 files changed, 1336 insertions(+), 2106 deletions(-)
 create mode 100644 Documentation/ide/warm-plug-howto.txt
 create mode 100644 drivers/ide/legacy/ide-4drives.c


Akira Iguchi (1):
      scc_pata.c: do setup itself instead of ide_setup_pci_device()

Bartlomiej Zolnierkiewicz (46):
      ide-generic: set hwif->chipset
      ide: fix ide_find_port()
      ide: use ide_find_port() instead of ide_deprecated_find_port()
      ide-acpi: add missing drive->acpidata zeroing
      ide: factor out cable detection from ide_init_port()
      ide: remove IDE devices from /proc/ide/ before unregistering them
      ide: factor out code unregistering devices from ide_unregister()
      ide: factor out devices init from ide_init_port_data()
      ide: move ide_port_setup_devices() call to ide_device_add_all()
      ide: rework PowerMac media-bay support (take 2)
      ide: remove dead/obsolete ->busproc method
      ide: add warm-plug support for IDE devices (take 2)
      ide-generic: add ide_generic class and attribute for adding new interfaces
      ide: remove needless CONFIG_BLK_DEV_HD hack from init_hwif()
      ide: remove CONFIG_BLK_DEV_HD_IDE config option (take 2)
      ide: remove obsoleted "idex=base[,ctl[,irq]]" kernel parameters (take 2)
      ide: remove broken/dangerous HDIO_[UNREGISTER,SCAN]_HWIF ioctls (take 3)
      ide: remove ->hold field from ide_hwif_t (take 2)
      ide: remove init_hwif_default()
      ide: remove ide_init_hwif_ports()
      ide: add ide_atapi_{discard_data,write_zeros} inline helpers
      ide: remove IDE_*_REG macros
      ide-pmac: remove dead code
      ppc/hdpu: remove dead IDE code
      ppc/ppc4xx: remove ppc_ide_md hooks
      ppc/pmac: remove ppc_ide_md hooks
      ppc/mpc8xx: remove ppc_ide_md hooks
      ppc/lopec: remove ppc_ide_md hooks
      ppc/sandpoint: remove ppc_ide_md hooks
      ppc/pplus: remove ppc_ide_md.ide_init_hwif hook
      ppc: remove ppc_ide_md
      ppc: don't include <linux/ide.h>
      ppc/pmac: remove no longer needed IDE quirk
      ide: add CONFIG_IDE_ARCH_OBSOLETE_DEFAULTS (take 2)
      ide: remove CONFIG_IDE_ARCH_OBSOLETE_INIT
      ide: remove ide_default_io_ctl() macro
      ide: remove ppc ifdef from init_ide_data()
      ide: add ide-4drives host driver (take 3)
      cmd640: cleanup setup_device_ptrs()
      cmd640: init hwif->{io_ports,irq} explicitly
      ide: limit legacy VLB host drivers to alpha, x86 and mips
      ide: init hwif->{io_ports,irq} explicitly in legacy VLB host drivers
      ide: remove needless hwif->irq check from ide_hwif_configure()
      ide: remove obsoleted "idex=noprobe" kernel parameter (take 2)
      ide: move default IDE ports setup to ide_generic host driver
      ide: remove ide_init_default_irq() macro

Borislav Petkov (10):
      ide-floppy: remove struct idefloppy_id_gcw
      ide-tape: move all struct and other defs at the top
      ide-tape: remove atomic test/set macros for packet commands
      ide: add generic packet command representation ide_atapi_pc
      ide-tape: convert driver to using generic ide_atapi_pc
      ide-floppy: convert driver to using generic ide_atapi_pc
      ide-scsi: convert driver to using generic ide_atapi_pc
      ide-floppy: rename end_request handler properly
      ide: use generic ATAPI packet command flags in ide-{floppy,tape}
      ide-scsi: do non-atomic pc->flags testing

Greg Kroah-Hartman (1):
      IDE: remove ide=reverse IDE core


diff --git a/Documentation/ide/ide.txt b/Documentation/ide/ide.txt
index 818676a..486c699 100644
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -71,29 +71,6 @@ This driver automatically probes for most IDE interfaces (including all PCI
 ones), for the drives/geometries attached to those interfaces, and for the IRQ
 lines being used by the interfaces (normally 14, 15 for ide0/ide1).
 
-For special cases, interfaces may be specified using kernel "command line"
-options.  For example,
-
-	ide3=0x168,0x36e,10	/* ioports 0x168-0x16f,0x36e, irq 10 */
-
-Normally the irq number need not be specified, as ide.c will probe for it:
-
-	ide3=0x168,0x36e	/* ioports 0x168-0x16f,0x36e */
-
-The standard port, and irq values are these:
-
-	ide0=0x1f0,0x3f6,14
-	ide1=0x170,0x376,15
-	ide2=0x1e8,0x3ee,11
-	ide3=0x168,0x36e,10
-
-Note that the first parameter reserves 8 contiguous ioports, whereas the
-second value denotes a single ioport. If in doubt, do a 'cat /proc/ioports'.
-
-In all probability the device uses these ports and IRQs if it is attached
-to the appropriate ide channel.  Pass the parameter for the correct ide
-channel to the kernel, as explained above.
-
 Any number of interfaces may share a single IRQ if necessary, at a slight
 performance penalty, whether on separate cards or a single VLB card.
 The IDE driver automatically detects and handles this.  However, this may
@@ -184,13 +161,6 @@ provided it is mounted with the default block size of 1024 (as above).
 Please pass on any feedback on any of this stuff to the maintainer,
 whose address can be found in linux/MAINTAINERS.
 
-Note that if BOTH hd.c and ide.c are configured into the kernel,
-hd.c will normally be allowed to control the primary IDE interface.
-This is useful for older hardware that may be incompatible with ide.c,
-and still allows newer hardware to run on the 2nd/3rd/4th IDE ports
-under control of ide.c.   To have ide.c also "take over" the primary
-IDE port in this situation, use the "command line" parameter:  ide0=0x1f0
-
 The IDE driver is modularized.  The high level disk/CD-ROM/tape/floppy
 drivers can always be compiled as loadable modules, the chipset drivers
 can only be compiled into the kernel, and the core code (ide.c) can be
@@ -206,7 +176,7 @@ When ide.c is used as a module, you can pass command line parameters to the
 driver using the "options=" keyword to insmod, while replacing any ',' with
 ';'.  For example:
 
-	insmod ide.o options="ide0=serialize ide1=serialize ide2=0x1e8;0x3ee;11"
+	insmod ide.o options="hda=nodma hdb=nodma"
 
 
 ================================================================================
@@ -247,21 +217,11 @@ Summary of ide driver parameters for kernel command line
 			  As for VLB, it is safest to not specify it.
 			  Bigger values are safer than smaller ones.
 
- "idex=base"		: probe for an interface at the addr specified,
-			  where "base" is usually 0x1f0 or 0x170
-			  and "ctl" is assumed to be "base"+0x206
-
- "idex=base,ctl"	: specify both base and ctl
-
- "idex=base,ctl,irq"	: specify base, ctl, and irq number
-
  "idex=serialize"	: do not overlap operations on idex. Please note
 			  that you will have to specify this option for
 			  both the respective primary and secondary channel
 			  to take effect.
 
- "idex=four"		: four drives on idex and ide(x^1) share same ports
-
  "idex=reset"		: reset interface after probe
 
  "idex=ata66"		: informs the interface that it has an 80c cable
@@ -269,8 +229,6 @@ Summary of ide driver parameters for kernel command line
 			  ability to bit test for detection is currently
 			  unknown.
 
- "ide=reverse"		: formerly called to pci sub-system, but now local.
-
  "ide=doubler"		: probe/support IDE doublers on Amiga
 
 There may be more options than shown -- use the source, Luke!
@@ -290,6 +248,9 @@ Also for legacy CMD640 host driver (cmd640) you need to use "probe_vlb"
 kernel paremeter to enable probing for VLB version of the chipset (PCI ones
 are detected automatically).
 
+You also need to use "probe" kernel parameter for ide-4drives driver
+(support for IDE generic chipset with four drives on one port).
+
 ================================================================================
 
 Some Terminology
diff --git a/Documentation/ide/warm-plug-howto.txt b/Documentation/ide/warm-plug-howto.txt
new file mode 100644
index 0000000..d588546
--- /dev/null
+++ b/Documentation/ide/warm-plug-howto.txt
@@ -0,0 +1,13 @@
+
+IDE warm-plug HOWTO
+===================
+
+To warm-plug devices on a port 'idex':
+
+# echo -n "1" > /sys/class/ide_port/idex/delete_devices
+
+unplug old device(s) and plug new device(s)
+
+# echo -n "1" > /sys/class/ide_port/idex/scan
+
+done
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index dafd001..239e78a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -763,11 +763,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
 
 	ide=		[HW] (E)IDE subsystem
-			Format: ide=nodma or ide=doubler or ide=reverse
+			Format: ide=nodma or ide=doubler
 			See Documentation/ide/ide.txt.
 
 	ide?=		[HW] (E)IDE subsystem
-			Format: ide?=noprobe or chipset specific parameters.
+			Format: ide?=ata66 or chipset specific parameters.
 			See Documentation/ide/ide.txt.
 
 	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index cd870a8..06d918d 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -10,9 +10,6 @@
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/initrd.h>
-#if defined(CONFIG_IDE) || defined(CONFIG_IDE_MODULE)
-#include <linux/ide.h>
-#endif
 #include <linux/tty.h>
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
@@ -51,11 +48,6 @@
 
 extern void bootx_init(unsigned long r4, unsigned long phys);
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-struct ide_machdep_calls ppc_ide_md;
-EXPORT_SYMBOL(ppc_ide_md);
-#endif
-
 int boot_cpuid;
 EXPORT_SYMBOL_GPL(boot_cpuid);
 int boot_cpuid_phys;
diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
index 1c58db9..bcf50d7 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -1144,28 +1144,6 @@ void __init pmac_pcibios_after_init(void)
 {
 	struct device_node* nd;
 
-#ifdef CONFIG_BLK_DEV_IDE
-	struct pci_dev *dev = NULL;
-
-	/* OF fails to initialize IDE controllers on macs
-	 * (and maybe other machines)
-	 *
-	 * Ideally, this should be moved to the IDE layer, but we need
-	 * to check specifically with Andre Hedrick how to do it cleanly
-	 * since the common IDE code seem to care about the fact that the
-	 * BIOS may have disabled a controller.
-	 *
-	 * -- BenH
-	 */
-	for_each_pci_dev(dev) {
-		if ((dev->class >> 16) != PCI_BASE_CLASS_STORAGE)
-			continue;
-		if (pci_enable_device(dev))
-			printk(KERN_WARNING
-			       "pci: Failed to enable %s\n", pci_name(dev));
-	}
-#endif /* CONFIG_BLK_DEV_IDE */
-
 	for_each_node_by_name(nd, "firewire") {
 		if (nd->parent && (of_device_is_compatible(nd, "pci106b,18") ||
 				   of_device_is_compatible(nd, "pci106b,30") ||
diff --git a/arch/powerpc/platforms/powermac/pmac.h b/arch/powerpc/platforms/powermac/pmac.h
index b3abaaf..3362e78 100644
--- a/arch/powerpc/platforms/powermac/pmac.h
+++ b/arch/powerpc/platforms/powermac/pmac.h
@@ -2,7 +2,6 @@
 #define __PMAC_H__
 
 #include <linux/pci.h>
-#include <linux/ide.h>
 #include <linux/irq.h>
 
 /*
@@ -35,10 +34,6 @@ extern void pmac_check_ht_link(void);
 
 extern void pmac_setup_smp(void);
 
-extern unsigned long pmac_ide_get_base(int index);
-extern void pmac_ide_init_hwif_ports(hw_regs_t *hw,
-	unsigned long data_port, unsigned long ctrl_port, int *irq);
-
 extern int pmac_nvram_init(void);
 extern void pmac_pic_init(void);
 
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 36ff1b6..2693fc3 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -574,14 +574,6 @@ static int __init pmac_probe(void)
 	ISA_DMA_THRESHOLD = ~0L;
 	DMA_MODE_READ = 1;
 	DMA_MODE_WRITE = 2;
-
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-#ifdef CONFIG_BLK_DEV_IDE_PMAC
-        ppc_ide_md.ide_init_hwif	= pmac_ide_init_hwif_ports;
-        ppc_ide_md.default_io_base	= pmac_ide_get_base;
-#endif /* CONFIG_BLK_DEV_IDE_PMAC */
-#endif /* defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE) */
-
 #endif /* CONFIG_PPC32 */
 
 #ifdef CONFIG_PMAC_SMU
diff --git a/arch/ppc/configs/sandpoint_defconfig b/arch/ppc/configs/sandpoint_defconfig
index fb493a6..9525e34 100644
--- a/arch/ppc/configs/sandpoint_defconfig
+++ b/arch/ppc/configs/sandpoint_defconfig
@@ -189,7 +189,7 @@ CONFIG_IDE_TASKFILE_IO=y
 #
 # IDE chipset support/bugfixes
 #
-CONFIG_IDE_GENERIC=y
+CONFIG_BLK_DEV_SL82C105=y
 # CONFIG_BLK_DEV_IDEPCI is not set
 # CONFIG_BLK_DEV_IDEDMA is not set
 # CONFIG_IDEDMA_AUTO is not set
diff --git a/arch/ppc/kernel/ppc_ksyms.c b/arch/ppc/kernel/ppc_ksyms.c
index c353502..2ba659f 100644
--- a/arch/ppc/kernel/ppc_ksyms.c
+++ b/arch/ppc/kernel/ppc_ksyms.c
@@ -12,7 +12,6 @@
 #include <linux/irq.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/pm.h>
 #include <linux/bitops.h>
 
@@ -124,10 +123,6 @@ EXPORT_SYMBOL(__ioremap);
 EXPORT_SYMBOL(iounmap);
 EXPORT_SYMBOL(ioremap_bot);	/* aka VMALLOC_END */
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-EXPORT_SYMBOL(ppc_ide_md);
-#endif
-
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL(isa_io_base);
 EXPORT_SYMBOL(isa_mem_base);
diff --git a/arch/ppc/kernel/setup.c b/arch/ppc/kernel/setup.c
index 2940559..bfddfde 100644
--- a/arch/ppc/kernel/setup.c
+++ b/arch/ppc/kernel/setup.c
@@ -10,7 +10,6 @@
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/initrd.h>
-#include <linux/ide.h>
 #include <linux/screen_info.h>
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
@@ -57,7 +56,6 @@ extern void ppc6xx_idle(void);
 extern void power4_idle(void);
 
 extern boot_infos_t *boot_infos;
-struct ide_machdep_calls ppc_ide_md;
 
 /* Used with the BI_MEMSIZE bootinfo parameter to store the memory
    size value reported by the boot loader. */
diff --git a/arch/ppc/platforms/4xx/bamboo.c b/arch/ppc/platforms/4xx/bamboo.c
index 017623c..01f20f4 100644
--- a/arch/ppc/platforms/4xx/bamboo.c
+++ b/arch/ppc/platforms/4xx/bamboo.c
@@ -22,7 +22,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
diff --git a/arch/ppc/platforms/4xx/ebony.c b/arch/ppc/platforms/4xx/ebony.c
index 453643a..8027a36 100644
--- a/arch/ppc/platforms/4xx/ebony.c
+++ b/arch/ppc/platforms/4xx/ebony.c
@@ -25,7 +25,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
diff --git a/arch/ppc/platforms/4xx/luan.c b/arch/ppc/platforms/4xx/luan.c
index b79ebb8..f6d8c2e 100644
--- a/arch/ppc/platforms/4xx/luan.c
+++ b/arch/ppc/platforms/4xx/luan.c
@@ -23,7 +23,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
diff --git a/arch/ppc/platforms/4xx/ocotea.c b/arch/ppc/platforms/4xx/ocotea.c
index 28a712c..308386e 100644
--- a/arch/ppc/platforms/4xx/ocotea.c
+++ b/arch/ppc/platforms/4xx/ocotea.c
@@ -23,7 +23,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
diff --git a/arch/ppc/platforms/4xx/taishan.c b/arch/ppc/platforms/4xx/taishan.c
index f6a0c66..1156942 100644
--- a/arch/ppc/platforms/4xx/taishan.c
+++ b/arch/ppc/platforms/4xx/taishan.c
@@ -23,7 +23,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
diff --git a/arch/ppc/platforms/4xx/yucca.c b/arch/ppc/platforms/4xx/yucca.c
index 66a44ff..f6cfd44 100644
--- a/arch/ppc/platforms/4xx/yucca.c
+++ b/arch/ppc/platforms/4xx/yucca.c
@@ -24,7 +24,6 @@
 #include <linux/blkdev.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
diff --git a/arch/ppc/platforms/chestnut.c b/arch/ppc/platforms/chestnut.c
index dcd6070..27c140f 100644
--- a/arch/ppc/platforms/chestnut.c
+++ b/arch/ppc/platforms/chestnut.c
@@ -22,7 +22,6 @@
 #include <linux/initrd.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
-#include <linux/ide.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
diff --git a/arch/ppc/platforms/cpci690.c b/arch/ppc/platforms/cpci690.c
index e78bccf..07f672d 100644
--- a/arch/ppc/platforms/cpci690.c
+++ b/arch/ppc/platforms/cpci690.c
@@ -10,7 +10,6 @@
  */
 #include <linux/delay.h>
 #include <linux/pci.h>
-#include <linux/ide.h>
 #include <linux/irq.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
diff --git a/arch/ppc/platforms/ev64260.c b/arch/ppc/platforms/ev64260.c
index c1f77e1..f522b31 100644
--- a/arch/ppc/platforms/ev64260.c
+++ b/arch/ppc/platforms/ev64260.c
@@ -23,7 +23,6 @@
 
 #include <linux/delay.h>
 #include <linux/pci.h>
-#include <linux/ide.h>
 #include <linux/irq.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
diff --git a/arch/ppc/platforms/hdpu.c b/arch/ppc/platforms/hdpu.c
index ca5de13..904b518 100644
--- a/arch/ppc/platforms/hdpu.c
+++ b/arch/ppc/platforms/hdpu.c
@@ -16,7 +16,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/platform_device.h>
 
@@ -604,41 +603,6 @@ static void parse_bootinfo(unsigned long r3,
 	}
 }
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-static void
-hdpu_ide_request_region(ide_ioreg_t from, unsigned int extent, const char *name)
-{
-	request_region(from, extent, name);
-	return;
-}
-
-static void hdpu_ide_release_region(ide_ioreg_t from, unsigned int extent)
-{
-	release_region(from, extent);
-	return;
-}
-
-static void __init
-hdpu_ide_pci_init_hwif_ports(hw_regs_t * hw, ide_ioreg_t data_port,
-			     ide_ioreg_t ctrl_port, int *irq)
-{
-	struct pci_dev *dev;
-
-	pci_for_each_dev(dev) {
-		if (((dev->class >> 8) == PCI_CLASS_STORAGE_IDE) ||
-		    ((dev->class >> 8) == PCI_CLASS_STORAGE_RAID)) {
-			hw->irq = dev->irq;
-
-			if (irq != NULL) {
-				*irq = dev->irq;
-			}
-		}
-	}
-
-	return;
-}
-#endif
-
 void hdpu_heartbeat(void)
 {
 	if (mv64x60_read(&bh, MV64x60_GPP_VALUE) & (1 << 5))
diff --git a/arch/ppc/platforms/lopec.c b/arch/ppc/platforms/lopec.c
index b947c77..1e3aa6e 100644
--- a/arch/ppc/platforms/lopec.c
+++ b/arch/ppc/platforms/lopec.c
@@ -15,7 +15,6 @@
 #include <linux/pci_ids.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/initrd.h>
 #include <linux/console.h>
@@ -168,85 +167,6 @@ lopec_power_off(void)
 	lopec_halt();
 }
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-int lopec_ide_ports_known = 0;
-static unsigned long lopec_ide_regbase[MAX_HWIFS];
-static unsigned long lopec_ide_ctl_regbase[MAX_HWIFS];
-static unsigned long lopec_idedma_regbase;
-
-static void
-lopec_ide_probe(void)
-{
-	struct pci_dev *dev = pci_get_device(PCI_VENDOR_ID_WINBOND,
-					      PCI_DEVICE_ID_WINBOND_82C105,
-					      NULL);
-	lopec_ide_ports_known = 1;
-
-	if (dev) {
-		lopec_ide_regbase[0] = dev->resource[0].start;
-		lopec_ide_regbase[1] = dev->resource[2].start;
-		lopec_ide_ctl_regbase[0] = dev->resource[1].start;
-		lopec_ide_ctl_regbase[1] = dev->resource[3].start;
-		lopec_idedma_regbase = dev->resource[4].start;
-		pci_dev_put(dev);
-	}
-}
-
-static int
-lopec_ide_default_irq(unsigned long base)
-{
-	if (lopec_ide_ports_known == 0)
-		lopec_ide_probe();
-
-	if (base == lopec_ide_regbase[0])
-		return 14;
-	else if (base == lopec_ide_regbase[1])
-		return 15;
-	else
-		return 0;
-}
-
-static unsigned long
-lopec_ide_default_io_base(int index)
-{
-	if (lopec_ide_ports_known == 0)
-		lopec_ide_probe();
-	return lopec_ide_regbase[index];
-}
-
-static void __init
-lopec_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data,
-			  unsigned long ctl, int *irq)
-{
-	unsigned long reg = data;
-	uint alt_status_base;
-	int i;
-
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		hw->io_ports[i] = reg++;
-
-	if (data == lopec_ide_regbase[0]) {
-		alt_status_base = lopec_ide_ctl_regbase[0] + 2;
-		hw->irq = 14;
-	} else if (data == lopec_ide_regbase[1]) {
-		alt_status_base = lopec_ide_ctl_regbase[1] + 2;
-		hw->irq = 15;
-	} else {
-		alt_status_base = 0;
-		hw->irq = 0;
-	}
-
-	if (ctl)
-		hw->io_ports[IDE_CONTROL_OFFSET] = ctl;
-	else
-		hw->io_ports[IDE_CONTROL_OFFSET] = alt_status_base;
-
-	if (irq != NULL)
-		*irq = hw->irq;
-
-}
-#endif /* BLK_DEV_IDE */
-
 static void __init
 lopec_init_IRQ(void)
 {
@@ -384,11 +304,6 @@ platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	ppc_md.nvram_read_val = todc_direct_read_val;
 	ppc_md.nvram_write_val = todc_direct_write_val;
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-	ppc_ide_md.default_irq = lopec_ide_default_irq;
-	ppc_ide_md.default_io_base = lopec_ide_default_io_base;
-	ppc_ide_md.ide_init_hwif = lopec_ide_init_hwif_ports;
-#endif
 #ifdef CONFIG_SERIAL_TEXT_DEBUG
 	ppc_md.progress = gen550_progress;
 #endif
diff --git a/arch/ppc/platforms/mvme5100.c b/arch/ppc/platforms/mvme5100.c
index bb8d4a4..053b54a 100644
--- a/arch/ppc/platforms/mvme5100.c
+++ b/arch/ppc/platforms/mvme5100.c
@@ -17,7 +17,6 @@
 #include <linux/initrd.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/kdev_t.h>
 #include <linux/root_dev.h>
diff --git a/arch/ppc/platforms/powerpmc250.c b/arch/ppc/platforms/powerpmc250.c
index 4d46650..162dc85 100644
--- a/arch/ppc/platforms/powerpmc250.c
+++ b/arch/ppc/platforms/powerpmc250.c
@@ -25,7 +25,6 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
-#include <linux/ide.h>
 #include <linux/root_dev.h>
 
 #include <asm/byteorder.h>
diff --git a/arch/ppc/platforms/pplus.c b/arch/ppc/platforms/pplus.c
index 8a1788c..cbcac85 100644
--- a/arch/ppc/platforms/pplus.c
+++ b/arch/ppc/platforms/pplus.c
@@ -19,7 +19,6 @@
 #include <linux/ioport.h>
 #include <linux/console.h>
 #include <linux/pci.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 
@@ -668,57 +667,6 @@ static void __init pplus_init_IRQ(void)
 		ppc_md.progress("init_irq: exit", 0);
 }
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-/*
- * IDE stuff.
- */
-static int pplus_ide_default_irq(unsigned long base)
-{
-	switch (base) {
-	case 0x1f0:
-		return 14;
-	case 0x170:
-		return 15;
-	default:
-		return 0;
-	}
-}
-
-static unsigned long pplus_ide_default_io_base(int index)
-{
-	switch (index) {
-	case 0:
-		return 0x1f0;
-	case 1:
-		return 0x170;
-	default:
-		return 0;
-	}
-}
-
-static void __init
-pplus_ide_init_hwif_ports(hw_regs_t * hw, unsigned long data_port,
-			  unsigned long ctrl_port, int *irq)
-{
-	unsigned long reg = data_port;
-	int i;
-
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw->io_ports[i] = reg;
-		reg += 1;
-	}
-
-	if (ctrl_port)
-		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
-	else
-		hw->io_ports[IDE_CONTROL_OFFSET] =
-		    hw->io_ports[IDE_DATA_OFFSET] + 0x206;
-
-	if (irq != NULL)
-		*irq = pplus_ide_default_irq(data_port);
-}
-#endif
-
 #ifdef CONFIG_SMP
 /* PowerPlus (MTX) support */
 static int __init smp_pplus_probe(void)
@@ -884,12 +832,6 @@ platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	ppc_md.find_end_of_memory = pplus_find_end_of_memory;
 	ppc_md.setup_io_mappings = pplus_map_io;
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-	ppc_ide_md.default_irq = pplus_ide_default_irq;
-	ppc_ide_md.default_io_base = pplus_ide_default_io_base;
-	ppc_ide_md.ide_init_hwif = pplus_ide_init_hwif_ports;
-#endif
-
 #ifdef CONFIG_SERIAL_TEXT_DEBUG
 	ppc_md.progress = gen550_progress;
 #endif				/* CONFIG_SERIAL_TEXT_DEBUG */
diff --git a/arch/ppc/platforms/prep_setup.c b/arch/ppc/platforms/prep_setup.c
index 3844985..465b658 100644
--- a/arch/ppc/platforms/prep_setup.c
+++ b/arch/ppc/platforms/prep_setup.c
@@ -33,7 +33,6 @@
 #include <linux/console.h>
 #include <linux/timex.h>
 #include <linux/pci.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 
@@ -894,38 +893,6 @@ prep_init_IRQ(void)
 		i8259_init(MPC10X_MAPA_PCI_INTACK_ADDR, 0);
 }
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-/*
- * IDE stuff.
- */
-static int
-prep_ide_default_irq(unsigned long base)
-{
-	switch (base) {
-		case 0x1f0: return 13;
-		case 0x170: return 13;
-		case 0x1e8: return 11;
-		case 0x168: return 10;
-		case 0xfff0: return 14;		/* MCP(N)750 ide0 */
-		case 0xffe0: return 15;		/* MCP(N)750 ide1 */
-		default: return 0;
-	}
-}
-
-static unsigned long
-prep_ide_default_io_base(int index)
-{
-	switch (index) {
-		case 0: return 0x1f0;
-		case 1: return 0x170;
-		case 2: return 0x1e8;
-		case 3: return 0x168;
-		default:
-			return 0;
-	}
-}
-#endif
-
 #ifdef CONFIG_SMP
 /* PReP (MTX) support */
 static int __init
@@ -1070,11 +1037,6 @@ prep_init(unsigned long r3, unsigned long r4, unsigned long r5,
 
 	ppc_md.setup_io_mappings = prep_map_io;
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-	ppc_ide_md.default_irq = prep_ide_default_irq;
-	ppc_ide_md.default_io_base = prep_ide_default_io_base;
-#endif
-
 #ifdef CONFIG_SMP
 	smp_ops			 = &prep_smp_ops;
 #endif /* CONFIG_SMP */
diff --git a/arch/ppc/platforms/prpmc750.c b/arch/ppc/platforms/prpmc750.c
index fcab513..93bd593 100644
--- a/arch/ppc/platforms/prpmc750.c
+++ b/arch/ppc/platforms/prpmc750.c
@@ -22,7 +22,6 @@
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
-#include <linux/ide.h>
 #include <linux/root_dev.h>
 #include <linux/slab.h>
 #include <linux/serial_reg.h>
diff --git a/arch/ppc/platforms/prpmc800.c b/arch/ppc/platforms/prpmc800.c
index f4ade5c..5bcda7f 100644
--- a/arch/ppc/platforms/prpmc800.c
+++ b/arch/ppc/platforms/prpmc800.c
@@ -20,7 +20,6 @@
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
-#include <linux/ide.h>
 #include <linux/root_dev.h>
 #include <linux/harrier_defs.h>
 
diff --git a/arch/ppc/platforms/radstone_ppc7d.c b/arch/ppc/platforms/radstone_ppc7d.c
index 44d4398..179b4a9 100644
--- a/arch/ppc/platforms/radstone_ppc7d.c
+++ b/arch/ppc/platforms/radstone_ppc7d.c
@@ -29,7 +29,6 @@
 #include <linux/initrd.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
diff --git a/arch/ppc/platforms/residual.c b/arch/ppc/platforms/residual.c
index c991160..18495e7 100644
--- a/arch/ppc/platforms/residual.c
+++ b/arch/ppc/platforms/residual.c
@@ -38,7 +38,6 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
-#include <linux/ide.h>
 
 #include <asm/sections.h>
 #include <asm/mmu.h>
diff --git a/arch/ppc/platforms/sandpoint.c b/arch/ppc/platforms/sandpoint.c
index 3352fae..b4897bd 100644
--- a/arch/ppc/platforms/sandpoint.c
+++ b/arch/ppc/platforms/sandpoint.c
@@ -71,7 +71,6 @@
 #include <linux/initrd.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
@@ -559,93 +558,6 @@ sandpoint_show_cpuinfo(struct seq_file *m)
 	return 0;
 }
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-/*
- * IDE support.
- */
-static int		sandpoint_ide_ports_known = 0;
-static unsigned long	sandpoint_ide_regbase[MAX_HWIFS];
-static unsigned long	sandpoint_ide_ctl_regbase[MAX_HWIFS];
-static unsigned long	sandpoint_idedma_regbase;
-
-static void
-sandpoint_ide_probe(void)
-{
-	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_WINBOND,
-			PCI_DEVICE_ID_WINBOND_82C105, NULL);
-
-	if (pdev) {
-		sandpoint_ide_regbase[0]=pdev->resource[0].start;
-		sandpoint_ide_regbase[1]=pdev->resource[2].start;
-		sandpoint_ide_ctl_regbase[0]=pdev->resource[1].start;
-		sandpoint_ide_ctl_regbase[1]=pdev->resource[3].start;
-		sandpoint_idedma_regbase=pdev->resource[4].start;
-		pci_dev_put(pdev);
-	}
-
-	sandpoint_ide_ports_known = 1;
-}
-
-static int
-sandpoint_ide_default_irq(unsigned long base)
-{
-	if (sandpoint_ide_ports_known == 0)
-		sandpoint_ide_probe();
-
-	if (base == sandpoint_ide_regbase[0])
-		return SANDPOINT_IDE_INT0;
-	else if (base == sandpoint_ide_regbase[1])
-		return SANDPOINT_IDE_INT1;
-	else
-		return 0;
-}
-
-static unsigned long
-sandpoint_ide_default_io_base(int index)
-{
-	if (sandpoint_ide_ports_known == 0)
-		sandpoint_ide_probe();
-
-	return sandpoint_ide_regbase[index];
-}
-
-static void __init
-sandpoint_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
-		unsigned long ctrl_port, int *irq)
-{
-	unsigned long reg = data_port;
-	uint	alt_status_base;
-	int	i;
-
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw->io_ports[i] = reg++;
-	}
-
-	if (data_port == sandpoint_ide_regbase[0]) {
-		alt_status_base = sandpoint_ide_ctl_regbase[0] + 2;
-		hw->irq = 14;
-	}
-	else if (data_port == sandpoint_ide_regbase[1]) {
-		alt_status_base = sandpoint_ide_ctl_regbase[1] + 2;
-		hw->irq = 15;
-	}
-	else {
-		alt_status_base = 0;
-		hw->irq = 0;
-	}
-
-	if (ctrl_port) {
-		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
-	} else {
-		hw->io_ports[IDE_CONTROL_OFFSET] = alt_status_base;
-	}
-
-	if (irq != NULL) {
-		*irq = hw->irq;
-	}
-}
-#endif
-
 /*
  * Set BAT 3 to map 0xf8000000 to end of physical memory space 1-to-1.
  */
@@ -736,10 +648,4 @@ platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 #ifdef CONFIG_SERIAL_TEXT_DEBUG
 	ppc_md.progress = gen550_progress;
 #endif
-
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-	ppc_ide_md.default_irq = sandpoint_ide_default_irq;
-	ppc_ide_md.default_io_base = sandpoint_ide_default_io_base;
-	ppc_ide_md.ide_init_hwif = sandpoint_ide_init_hwif_ports;
-#endif
 }
diff --git a/arch/ppc/platforms/sandpoint.h b/arch/ppc/platforms/sandpoint.h
index 3b64e64..ed83759 100644
--- a/arch/ppc/platforms/sandpoint.h
+++ b/arch/ppc/platforms/sandpoint.h
@@ -28,9 +28,6 @@
  */
 #define SANDPOINT_IDE_INT0		23	/* EPIC 7 */
 #define SANDPOINT_IDE_INT1		24	/* EPIC 8 */
-#else
-#define SANDPOINT_IDE_INT0		14	/* 8259 Test */
-#define SANDPOINT_IDE_INT1		15	/* 8259 Test */
 #endif
 
 /*
diff --git a/arch/ppc/platforms/spruce.c b/arch/ppc/platforms/spruce.c
index f4de50b..a344134 100644
--- a/arch/ppc/platforms/spruce.c
+++ b/arch/ppc/platforms/spruce.c
@@ -22,7 +22,6 @@
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
-#include <linux/ide.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
 #include <linux/tty.h>
diff --git a/arch/ppc/syslib/m8xx_setup.c b/arch/ppc/syslib/m8xx_setup.c
index 9caf850..19749e9 100644
--- a/arch/ppc/syslib/m8xx_setup.c
+++ b/arch/ppc/syslib/m8xx_setup.c
@@ -87,8 +87,6 @@ void m8xx_calibrate_decr(void);
 
 unsigned char __res[sizeof(bd_t)];
 
-extern void m8xx_ide_init(void);
-
 extern unsigned long find_available_memory(void);
 extern void m8xx_cpm_reset(void);
 extern void m8xx_wdt_handler_install(bd_t *bp);
@@ -474,8 +472,4 @@ platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 
 	ppc_md.find_end_of_memory	= m8xx_find_end_of_memory;
 	ppc_md.setup_io_mappings	= m8xx_map_io;
-
-#if defined(CONFIG_BLK_DEV_MPC8xx_IDE)
-	m8xx_ide_init();
-#endif
 }
diff --git a/arch/ppc/syslib/ppc4xx_setup.c b/arch/ppc/syslib/ppc4xx_setup.c
index debe14c..353d746 100644
--- a/arch/ppc/syslib/ppc4xx_setup.c
+++ b/arch/ppc/syslib/ppc4xx_setup.c
@@ -24,7 +24,6 @@
 #include <linux/pci.h>
 #include <linux/rtc.h>
 #include <linux/console.h>
-#include <linux/ide.h>
 #include <linux/serial_reg.h>
 #include <linux/seq_file.h>
 
@@ -189,24 +188,6 @@ ppc4xx_calibrate_decr(void)
 	mtspr(SPRN_PIT, tb_ticks_per_jiffy);
 }
 
-/*
- * IDE stuff.
- * should be generic for every IDE PCI chipset
- */
-#if defined(CONFIG_PCI) && defined(CONFIG_IDE)
-static void
-ppc4xx_ide_init_hwif_ports(hw_regs_t * hw, unsigned long data_port,
-			   unsigned long ctrl_port, int *irq)
-{
-	int i;
-
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
-		hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
-
-	hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
-}
-#endif /* defined(CONFIG_PCI) && defined(CONFIG_IDE) */
-
 TODC_ALLOC();
 
 /*
@@ -271,10 +252,6 @@ ppc4xx_init(unsigned long r3, unsigned long r4, unsigned long r5,
 #ifdef CONFIG_SERIAL_TEXT_DEBUG
 	ppc_md.progress = gen550_progress;
 #endif
-
-#if defined(CONFIG_PCI) && defined(CONFIG_IDE)
-	ppc_ide_md.ide_init_hwif = ppc4xx_ide_init_hwif_ports;
-#endif /* defined(CONFIG_PCI) && defined(CONFIG_IDE) */
 }
 
 /* Called from machine_check_exception */
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index b733732..c70d0b6 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -624,7 +624,6 @@ static int compat_blkdev_driver_ioctl(struct inode *inode, struct file *file,
 	case HDIO_GET_IDENTITY:
 	case HDIO_DRIVE_TASK:
 	case HDIO_DRIVE_CMD:
-	case HDIO_SCAN_HWIF:
 	/* 0x330 is reserved -- it used to be HDIO_GETGEO_BIG */
 	case 0x330:
 	/* 0x02 -- Floppy ioctls */
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index eed6d8e..8753203 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -122,24 +122,6 @@ config BLK_DEV_IDE_SATA
 
 	  If unsure, say N.
 
-config BLK_DEV_HD_IDE
-	bool "Use old disk-only driver on primary interface"
-	depends on (X86 || SH_MPC1211)
-	---help---
-	  There are two drivers for MFM/RLL/IDE disks.  Most people use just
-	  the new enhanced driver by itself.  This option however installs the
-	  old hard disk driver to control the primary IDE/disk interface in
-	  the system, leaving the new enhanced IDE driver to take care of only
-	  the 2nd/3rd/4th IDE interfaces.  Doing this will prevent you from
-	  having an IDE/ATAPI CD-ROM or tape drive connected to the primary
-	  IDE interface.  Choosing this option may be useful for older systems
-	  which have MFM/RLL/ESDI controller+drives at the primary port
-	  address (0x1f0), along with IDE drives at the secondary/3rd/4th port
-	  addresses.
-
-	  Normally, just say N here; you will then use the new driver for all
-	  4 interfaces.
-
 config BLK_DEV_IDEDISK
 	tristate "Include IDE/ATA-2 DISK support"
 	---help---
@@ -325,6 +307,7 @@ comment "IDE chipset support/bugfixes"
 
 config IDE_GENERIC
 	tristate "generic/default IDE chipset support"
+	depends on ALPHA || X86 || IA64 || M32R || MIPS || PPC32
 	help
 	  If unsure, say N.
 
@@ -416,12 +399,6 @@ config BLK_DEV_OFFBOARD
 	  This can improve the usability of some boot managers such as lilo
 	  when booting from a drive on an off-board controller.
 
-	  If you say Y here, and you actually want to reverse the device scan
-	  order as explained above, you also need to issue the kernel command
-	  line option "ide=reverse". (Try "man bootparam" or see the
-	  documentation of your boot loader (lilo or loadlin) about how to
-	  pass options to the kernel at boot time.)
-
 	  Note that, if you do this, the order of the hd* devices will be
 	  rearranged which may require modification of fstab and other files.
 
@@ -615,8 +592,7 @@ config BLK_DEV_HPT366
 	  reference to device 0x80. The other solution is to say Y to "Boot
 	  off-board chipsets first support" (CONFIG_BLK_DEV_OFFBOARD) unless
 	  your mother board has the chipset natively mounted. Regardless one
-	  should use the fore mentioned option and call at LILO or include
-	  "ide=reverse" in LILO's append-line.
+	  should use the fore mentioned option and call at LILO.
 
 	  This driver requires dynamic tuning of the chipset during the
 	  ide-probe at boot. It is reported to support DVD II drives, by the
@@ -1049,7 +1025,7 @@ config IDE_EXT_DIRECT
 endchoice
 
 # no isa -> no vlb
-if ISA
+if ISA && (ALPHA || X86 || MIPS)
 
 comment "Other IDE chipsets support"
 comment "Note: most of these also require special kernel boot parameters"
@@ -1060,8 +1036,8 @@ config BLK_DEV_4DRIVES
 	  Certain older chipsets, including the Tekram 690CD, use a single set
 	  of I/O ports at 0x1f0 to control up to four drives, instead of the
 	  customary two drives per port. Support for this can be enabled at
-	  runtime using the "ide0=four" kernel boot parameter if you say Y
-	  here.
+	  runtime using the "ide-4drives.probe" kernel boot parameter if you
+	  say Y here.
 
 config BLK_DEV_ALI14XX
 	tristate "ALI M14xx support"
@@ -1114,14 +1090,10 @@ config BLK_DEV_IDEDMA
 	def_bool BLK_DEV_IDEDMA_SFF || BLK_DEV_IDEDMA_PMAC || \
 		 BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 
-config IDE_ARCH_OBSOLETE_INIT
-	def_bool ALPHA || (ARM && !ARCH_L7200) || BLACKFIN || X86 || IA64 || M32R || MIPS || PARISC || PPC || (SUPERH64 && BLK_DEV_IDEPCI) || SPARC
-
 endif
 
 config BLK_DEV_HD_ONLY
 	bool "Old hard disk (MFM/RLL/IDE) driver"
-	depends on BLK_DEV_IDE=n
 	help
 	  There are two drivers for MFM/RLL/IDE hard disks. Most people use
 	  the newer enhanced driver, but this old one is still around for two
@@ -1133,12 +1105,16 @@ config BLK_DEV_HD_ONLY
 	  for systems with only older MFM/RLL/ESDI drives. Choosing the old
 	  driver can save 13 KB or so of kernel memory.
 
+	  If you want to use this driver together with the new one you have
+	  to use "hda=noprobe hdb=noprobe" kernel parameters to prevent the new
+	  driver from probing the primary interface.
+
 	  If you are unsure, then just choose the Enhanced IDE/MFM/RLL driver
 	  instead of this one. For more detailed information, read the
 	  Disk-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
 config BLK_DEV_HD
-	def_bool BLK_DEV_HD_IDE || BLK_DEV_HD_ONLY
+	def_bool BLK_DEV_HD_ONLY
 
 endif # IDE
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index a4a4323..571544c 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -36,9 +36,9 @@ ifeq ($(CONFIG_BLK_DEV_CMD640), y)
 endif
 
 obj-$(CONFIG_BLK_DEV_IDE)		+= cris/ ppc/
-obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
+obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
 
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
index 161d30c..ec46c44 100644
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -41,15 +41,15 @@ static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 	hw.io_ports[IDE_CONTROL_OFFSET] = aux + (6 * 0x20);
 	hw.irq = irq;
 
-	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 	if (hwif == NULL)
 		goto out;
 
 	i = hwif->index;
 
 	if (hwif->present)
-		ide_unregister(i, 0, 0);
-	else if (!hwif->hold)
+		ide_unregister(i);
+	else
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index 8e1f6bd..474162c 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -378,15 +378,15 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
 
-	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 	if (hwif == NULL)
 		goto out;
 
 	i = hwif->index;
 
 	if (hwif->present)
-		ide_unregister(i, 0, 0);
-	else if (!hwif->hold)
+		ide_unregister(i);
+	else
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index efba00d..b30adcf 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -76,7 +76,7 @@ static void __devexit rapide_remove(struct expansion_card *ec)
 
 	ecard_set_drvdata(ec, NULL);
 
-	ide_unregister(hwif->index, 0, 0);
+	ide_unregister(hwif->index);
 
 	ecard_release_resources(ec);
 }
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index c8ffbaf..31266d2 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -228,7 +228,10 @@ cris_ide_fill_descriptor(cris_dma_descr_type *d, void* buf, unsigned int len, in
 static void
 cris_ide_start_dma(ide_drive_t *drive, cris_dma_descr_type *d, int dir,int type,int len)
 {
-	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int, IDE_DATA_REG);
+	ide_hwif_t *hwif = drive->hwif;
+
+	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
+					       hwif->io_ports[IDE_DATA_OFFSET]);
 	reg_ata_rw_trf_cnt trf_cnt = {0};
 
 	mycontext.saved_data = (dma_descr_data*)virt_to_phys(d);
@@ -264,8 +267,12 @@ cris_ide_wait_dma(int dir)
 
 static int cris_dma_test_irq(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	int intr = REG_RD_INT(ata, regi_ata, r_intr);
-	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int, IDE_DATA_REG);
+
+	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
+					       hwif->io_ports[IDE_DATA_OFFSET]);
+
 	return intr & (1 << ctrl2.sel) ? 1 : 0;
 }
 
@@ -523,7 +530,8 @@ static void cris_ide_start_dma(ide_drive_t *drive, cris_dma_descr_type *d, int d
 	                          IO_STATE(R_ATA_CTRL_DATA, handsh, dma);
 	*R_ATA_CTRL_DATA =
 		cmd |
-		IO_FIELD(R_ATA_CTRL_DATA, data, IDE_DATA_REG) |
+		IO_FIELD(R_ATA_CTRL_DATA, data,
+			 drive->hwif->io_ports[IDE_DATA_OFFSET]) |
 		IO_STATE(R_ATA_CTRL_DATA, src_dst,  dma)  |
 		IO_STATE(R_ATA_CTRL_DATA, multi,    on)   |
 		IO_STATE(R_ATA_CTRL_DATA, dma_size, word);
@@ -541,7 +549,9 @@ cris_ide_wait_dma(int dir)
 static int cris_dma_test_irq(ide_drive_t *drive)
 {
 	int intr = *R_IRQ_MASK0_RD;
-	int bus = IO_EXTRACT(R_ATA_CTRL_DATA, sel, IDE_DATA_REG);
+	int bus = IO_EXTRACT(R_ATA_CTRL_DATA, sel,
+			     drive->hwif->io_ports[IDE_DATA_OFFSET]);
+
 	return intr & (1 << (bus + IO_BITNR(R_IRQ_MASK0_RD, ata_irq0))) ? 1 : 0;
 }
 
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index e07b189..0f6fb6b 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -710,6 +710,8 @@ void ide_acpi_port_init_devices(ide_hwif_t *hwif)
 	for (i = 0; i < MAX_DRIVES; i++) {
 		drive = &hwif->drives[i];
 
+		memset(drive->acpidata, 0, sizeof(*drive->acpidata));
+
 		if (!drive->present)
 			continue;
 
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index c8d0e87..3960002 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -542,7 +542,8 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 
 		/* packet command */
 		spin_lock_irqsave(&ide_lock, flags);
-		hwif->OUTBSYNC(drive, WIN_PACKETCMD, IDE_COMMAND_REG);
+		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
+			       hwif->io_ports[IDE_COMMAND_OFFSET]);
 		ndelay(400);
 		spin_unlock_irqrestore(&ide_lock, flags);
 
@@ -992,6 +993,7 @@ static int cdrom_newpc_intr_dummy_cb(struct request *rq)
 
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	struct cdrom_info *info = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
 	xfer_func_t *xferfunc;
@@ -1032,9 +1034,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	/*
 	 * ok we fall to pio :/
 	 */
-	ireason = HWIF(drive)->INB(IDE_IREASON_REG) & 0x3;
-	lowcyl  = HWIF(drive)->INB(IDE_BCOUNTL_REG);
-	highcyl = HWIF(drive)->INB(IDE_BCOUNTH_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]) & 0x3;
+	lowcyl  = hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
+	highcyl = hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]);
 
 	len = lowcyl + (256 * highcyl);
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index faf22d7..5f133df 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -78,40 +78,6 @@
  */
 #define IDEFLOPPY_PC_STACK		(10 + IDEFLOPPY_MAX_PC_RETRIES)
 
-typedef struct idefloppy_packet_command_s {
-	u8 c[12];				/* Actual packet bytes */
-	int retries;				/* On each retry, we increment
-						   retries */
-	int error;				/* Error code */
-	int request_transfer;			/* Bytes to transfer */
-	int actually_transferred;		/* Bytes actually transferred */
-	int buffer_size;			/* Size of our data buffer */
-	int b_count;				/* Missing/Available data on
-						   the current buffer */
-	struct request *rq;			/* The corresponding request */
-	u8 *buffer;				/* Data buffer */
-	u8 *current_position;			/* Pointer into above buffer */
-	void (*callback) (ide_drive_t *);	/* Called when this packet
-						   command is completed */
-	u8 pc_buffer[IDEFLOPPY_PC_BUFFER_SIZE];	/* Temporary buffer */
-	unsigned long flags;			/* Status/Action bit flags: long
-						   for set_bit */
-} idefloppy_pc_t;
-
-/* Packet command flag bits. */
-enum {
-	/* 1 when we prefer to use DMA if possible */
-	PC_FLAG_DMA_RECOMMENDED	= (1 << 0),
-	/* 1 while DMA in progress */
-	PC_FLAG_DMA_IN_PROGRESS	= (1 << 1),
-	/* 1 when encountered problem during DMA */
-	PC_FLAG_DMA_ERROR	= (1 << 2),
-	/* Data direction */
-	PC_FLAG_WRITING		= (1 << 3),
-	/* Suppress error reporting */
-	PC_FLAG_SUPPRESS_ERROR	= (1 << 4),
-};
-
 /* format capacities descriptor codes */
 #define CAPACITY_INVALID	0x00
 #define CAPACITY_UNFORMATTED	0x01
@@ -131,11 +97,11 @@ typedef struct ide_floppy_obj {
 	unsigned int	openers;	/* protected by BKL for now */
 
 	/* Current packet command */
-	idefloppy_pc_t *pc;
+	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
-	idefloppy_pc_t *failed_pc;
+	struct ide_atapi_pc *failed_pc;
 	/* Packet command stack */
-	idefloppy_pc_t pc_stack[IDEFLOPPY_PC_STACK];
+	struct ide_atapi_pc pc_stack[IDEFLOPPY_PC_STACK];
 	/* Next free packet command storage space */
 	int pc_stack_index;
 	struct request rq_stack[IDEFLOPPY_PC_STACK];
@@ -195,32 +161,6 @@ enum {
 #define	IDEFLOPPY_ERROR_GENERAL		101
 
 /*
- * The following is used to format the general configuration word of the
- * ATAPI IDENTIFY DEVICE command.
- */
-struct idefloppy_id_gcw {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned packet_size		:2;	/* Packet Size */
-	unsigned reserved234		:3;	/* Reserved */
-	unsigned drq_type		:2;	/* Command packet DRQ type */
-	unsigned removable		:1;	/* Removable media */
-	unsigned device_type		:5;	/* Device type */
-	unsigned reserved13		:1;	/* Reserved */
-	unsigned protocol		:2;	/* Protocol type */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned protocol		:2;	/* Protocol type */
-	unsigned reserved13		:1;	/* Reserved */
-	unsigned device_type		:5;	/* Device type */
-	unsigned removable		:1;	/* Removable media */
-	unsigned drq_type		:2;	/* Command packet DRQ type */
-	unsigned reserved234		:3;	/* Reserved */
-	unsigned packet_size		:2;	/* Packet Size */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-};
-
-/*
  * Pages of the SELECT SENSE / MODE SENSE packet commands.
  * See SFF-8070i spec.
  */
@@ -256,27 +196,10 @@ static void ide_floppy_put(struct ide_floppy_obj *floppy)
 }
 
 /*
- * Too bad. The drive wants to send us data which we are not ready to accept.
- * Just throw it away.
- */
-static void idefloppy_discard_data(ide_drive_t *drive, unsigned int bcount)
-{
-	while (bcount--)
-		(void) HWIF(drive)->INB(IDE_DATA_REG);
-}
-
-static void idefloppy_write_zeros(ide_drive_t *drive, unsigned int bcount)
-{
-	while (bcount--)
-		HWIF(drive)->OUTB(0, IDE_DATA_REG);
-}
-
-
-/*
  * Used to finish servicing a request. For read/write requests, we will call
  * ide_end_request to pass to the next buffer.
  */
-static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
+static int idefloppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
@@ -305,7 +228,7 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	return 0;
 }
 
-static void ide_floppy_io_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
+static void ide_floppy_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  unsigned int bcount, int direction)
 {
 	struct request *rq = pc->rq;
@@ -333,26 +256,26 @@ static void ide_floppy_io_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
 		done += count;
 	}
 
-	idefloppy_do_end_request(drive, 1, done >> 9);
+	idefloppy_end_request(drive, 1, done >> 9);
 
 	if (bcount) {
 		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
 				drive->name, __func__, bcount);
 		if (direction)
-			idefloppy_write_zeros(drive, bcount);
+			ide_atapi_write_zeros(drive, bcount);
 		else
-			idefloppy_discard_data(drive, bcount);
-
+			ide_atapi_discard_data(drive, bcount);
 	}
 }
 
-static void idefloppy_update_buffers(ide_drive_t *drive, idefloppy_pc_t *pc)
+static void idefloppy_update_buffers(ide_drive_t *drive,
+				struct ide_atapi_pc *pc)
 {
 	struct request *rq = pc->rq;
 	struct bio *bio = rq->bio;
 
 	while ((bio = rq->bio) != NULL)
-		idefloppy_do_end_request(drive, 1, 0);
+		idefloppy_end_request(drive, 1, 0);
 }
 
 /*
@@ -360,7 +283,7 @@ static void idefloppy_update_buffers(ide_drive_t *drive, idefloppy_pc_t *pc)
  * the current request so that it will be processed immediately, on the next
  * pass through the driver.
  */
-static void idefloppy_queue_pc_head(ide_drive_t *drive, idefloppy_pc_t *pc,
+static void idefloppy_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		struct request *rq)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
@@ -372,7 +295,7 @@ static void idefloppy_queue_pc_head(ide_drive_t *drive, idefloppy_pc_t *pc,
 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
 }
 
-static idefloppy_pc_t *idefloppy_next_pc_storage(ide_drive_t *drive)
+static struct ide_atapi_pc *idefloppy_next_pc_storage(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
@@ -393,7 +316,7 @@ static struct request *idefloppy_next_rq_storage(ide_drive_t *drive)
 static void idefloppy_request_sense_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	u8 *buf = floppy->pc->buffer;
+	u8 *buf = floppy->pc->buf;
 
 	debug_log("Reached %s\n", __func__);
 
@@ -418,11 +341,11 @@ static void idefloppy_request_sense_callback(ide_drive_t *drive)
 					floppy->ascq);
 
 
-		idefloppy_do_end_request(drive, 1, 0);
+		idefloppy_end_request(drive, 1, 0);
 	} else {
 		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting"
 				" request!\n");
-		idefloppy_do_end_request(drive, 0, 0);
+		idefloppy_end_request(drive, 0, 0);
 	}
 }
 
@@ -433,27 +356,27 @@ static void idefloppy_pc_callback(ide_drive_t *drive)
 
 	debug_log("Reached %s\n", __func__);
 
-	idefloppy_do_end_request(drive, floppy->pc->error ? 0 : 1, 0);
+	idefloppy_end_request(drive, floppy->pc->error ? 0 : 1, 0);
 }
 
-static void idefloppy_init_pc(idefloppy_pc_t *pc)
+static void idefloppy_init_pc(struct ide_atapi_pc *pc)
 {
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
 	pc->flags = 0;
-	pc->request_transfer = 0;
-	pc->buffer = pc->pc_buffer;
-	pc->buffer_size = IDEFLOPPY_PC_BUFFER_SIZE;
-	pc->callback = &idefloppy_pc_callback;
+	pc->req_xfer = 0;
+	pc->buf = pc->pc_buf;
+	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
+	pc->idefloppy_callback = &idefloppy_pc_callback;
 }
 
-static void idefloppy_create_request_sense_cmd(idefloppy_pc_t *pc)
+static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_REQUEST_SENSE;
 	pc->c[4] = 255;
-	pc->request_transfer = 18;
-	pc->callback = &idefloppy_request_sense_callback;
+	pc->req_xfer = 18;
+	pc->idefloppy_callback = &idefloppy_request_sense_callback;
 }
 
 /*
@@ -462,7 +385,7 @@ static void idefloppy_create_request_sense_cmd(idefloppy_pc_t *pc)
  */
 static void idefloppy_retry_pc(ide_drive_t *drive)
 {
-	idefloppy_pc_t *pc;
+	struct ide_atapi_pc *pc;
 	struct request *rq;
 
 	(void)ide_read_error(drive);
@@ -477,7 +400,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
-	idefloppy_pc_t *pc = floppy->pc;
+	struct ide_atapi_pc *pc = floppy->pc;
 	struct request *rq = pc->rq;
 	xfer_func_t *xferfunc;
 	unsigned int temp;
@@ -494,7 +417,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 					rq_data_dir(rq) ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
-			pc->actually_transferred = pc->request_transfer;
+			pc->xferred = pc->req_xfer;
 			idefloppy_update_buffers(drive, pc);
 		}
 		debug_log("DMA finished\n");
@@ -506,7 +429,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	/* No more interrupts */
 	if ((stat & DRQ_STAT) == 0) {
 		debug_log("Packet command completed, %d bytes transferred\n",
-				pc->actually_transferred);
+				pc->xferred);
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 
 		local_irq_enable_in_hardirq();
@@ -529,7 +452,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 		if (floppy->failed_pc == pc)
 			floppy->failed_pc = NULL;
 		/* Command finished - Call the callback function */
-		pc->callback(drive);
+		pc->idefloppy_callback(drive);
 		return ide_stopped;
 	}
 
@@ -542,10 +465,10 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	}
 
 	/* Get the number of bytes to transfer */
-	bcount = (hwif->INB(IDE_BCOUNTH_REG) << 8) |
-		  hwif->INB(IDE_BCOUNTL_REG);
+	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
+		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
 	/* on this interrupt */
-	ireason = hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __func__);
@@ -561,13 +484,13 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	}
 	if (!(pc->flags & PC_FLAG_WRITING)) {
 		/* Reading - Check that we have enough space */
-		temp = pc->actually_transferred + bcount;
-		if (temp > pc->request_transfer) {
-			if (temp > pc->buffer_size) {
+		temp = pc->xferred + bcount;
+		if (temp > pc->req_xfer) {
+			if (temp > pc->buf_size) {
 				printk(KERN_ERR "ide-floppy: The floppy wants "
 					"to send us more data than expected "
 					"- discarding data\n");
-				idefloppy_discard_data(drive, bcount);
+				ide_atapi_discard_data(drive, bcount);
 
 				ide_set_handler(drive,
 						&idefloppy_pc_intr,
@@ -584,15 +507,15 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	else
 		xferfunc = hwif->atapi_input_bytes;
 
-	if (pc->buffer)
-		xferfunc(drive, pc->current_position, bcount);
+	if (pc->buf)
+		xferfunc(drive, pc->cur_pos, bcount);
 	else
 		ide_floppy_io_buffers(drive, pc, bcount,
 				      !!(pc->flags & PC_FLAG_WRITING));
 
 	/* Update the current position */
-	pc->actually_transferred += bcount;
-	pc->current_position += bcount;
+	pc->xferred += bcount;
+	pc->cur_pos += bcount;
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
@@ -606,6 +529,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
  */
 static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	ide_startstop_t startstop;
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	u8 ireason;
@@ -615,7 +539,7 @@ static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
 				"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = drive->hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) while "
 				"issuing a packet command\n");
@@ -652,6 +576,7 @@ static int idefloppy_transfer_pc2(ide_drive_t *drive)
 
 static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_startstop_t startstop;
 	u8 ireason;
@@ -661,7 +586,7 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 				"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = drive->hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) "
 				"while issuing a packet command\n");
@@ -682,7 +607,7 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 }
 
 static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
-				    idefloppy_pc_t *pc)
+				    struct ide_atapi_pc *pc)
 {
 	/* supress error messages resulting from Medium not present */
 	if (floppy->sense_key == 0x02 &&
@@ -698,7 +623,7 @@ static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
 }
 
 static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
-		idefloppy_pc_t *pc)
+		struct ide_atapi_pc *pc)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
@@ -719,7 +644,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
 
 		floppy->failed_pc = NULL;
-		pc->callback(drive);
+		pc->idefloppy_callback(drive);
 		return ide_stopped;
 	}
 
@@ -727,9 +652,9 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 
 	pc->retries++;
 	/* We haven't transferred any data yet */
-	pc->actually_transferred = 0;
-	pc->current_position = pc->buffer;
-	bcount = min(pc->request_transfer, 63 * 1024);
+	pc->xferred = 0;
+	pc->cur_pos = pc->buf;
+	bcount = min(pc->req_xfer, 63 * 1024);
 
 	if (pc->flags & PC_FLAG_DMA_ERROR) {
 		pc->flags &= ~PC_FLAG_DMA_ERROR;
@@ -757,7 +682,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		/* immediate */
 		pkt_xfer_routine = &idefloppy_transfer_pc;
 	}
-	
+
 	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
@@ -767,7 +692,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		HWIF(drive)->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
 		return (*pkt_xfer_routine) (drive);
 	}
 }
@@ -776,11 +701,11 @@ static void idefloppy_rw_callback(ide_drive_t *drive)
 {
 	debug_log("Reached %s\n", __func__);
 
-	idefloppy_do_end_request(drive, 1, 0);
+	idefloppy_end_request(drive, 1, 0);
 	return;
 }
 
-static void idefloppy_create_prevent_cmd(idefloppy_pc_t *pc, int prevent)
+static void idefloppy_create_prevent_cmd(struct ide_atapi_pc *pc, int prevent)
 {
 	debug_log("creating prevent removal command, prevent = %d\n", prevent);
 
@@ -789,39 +714,39 @@ static void idefloppy_create_prevent_cmd(idefloppy_pc_t *pc, int prevent)
 	pc->c[4] = prevent;
 }
 
-static void idefloppy_create_read_capacity_cmd(idefloppy_pc_t *pc)
+static void idefloppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
 	pc->c[7] = 255;
 	pc->c[8] = 255;
-	pc->request_transfer = 255;
+	pc->req_xfer = 255;
 }
 
-static void idefloppy_create_format_unit_cmd(idefloppy_pc_t *pc, int b, int l,
-					      int flags)
+static void idefloppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
+		int l, int flags)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_FORMAT_UNIT;
 	pc->c[1] = 0x17;
 
-	memset(pc->buffer, 0, 12);
-	pc->buffer[1] = 0xA2;
+	memset(pc->buf, 0, 12);
+	pc->buf[1] = 0xA2;
 	/* Default format list header, u8 1: FOV/DCRT/IMM bits set */
 
 	if (flags & 1)				/* Verify bit on... */
-		pc->buffer[1] ^= 0x20;		/* ... turn off DCRT bit */
-	pc->buffer[3] = 8;
+		pc->buf[1] ^= 0x20;		/* ... turn off DCRT bit */
+	pc->buf[3] = 8;
 
-	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buffer[4]));
-	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buffer[8]));
-	pc->buffer_size = 12;
+	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buf[4]));
+	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buf[8]));
+	pc->buf_size = 12;
 	pc->flags |= PC_FLAG_WRITING;
 }
 
 /* A mode sense command is used to "sense" floppy parameters. */
-static void idefloppy_create_mode_sense_cmd(idefloppy_pc_t *pc, u8 page_code,
-		u8 type)
+static void idefloppy_create_mode_sense_cmd(struct ide_atapi_pc *pc,
+		u8 page_code, u8 type)
 {
 	u16 length = 8; /* sizeof(Mode Parameter Header) = 8 Bytes */
 
@@ -842,24 +767,24 @@ static void idefloppy_create_mode_sense_cmd(idefloppy_pc_t *pc, u8 page_code,
 				"in create_mode_sense_cmd\n");
 	}
 	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
-	pc->request_transfer = length;
+	pc->req_xfer = length;
 }
 
-static void idefloppy_create_start_stop_cmd(idefloppy_pc_t *pc, int start)
+static void idefloppy_create_start_stop_cmd(struct ide_atapi_pc *pc, int start)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_START_STOP_UNIT;
 	pc->c[4] = start;
 }
 
-static void idefloppy_create_test_unit_ready_cmd(idefloppy_pc_t *pc)
+static void idefloppy_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_TEST_UNIT_READY;
 }
 
 static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
-				    idefloppy_pc_t *pc, struct request *rq,
+				    struct ide_atapi_pc *pc, struct request *rq,
 				    unsigned long sector)
 {
 	int block = sector / floppy->bs_factor;
@@ -874,41 +799,41 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
 
-	pc->callback = &idefloppy_rw_callback;
+	pc->idefloppy_callback = &idefloppy_rw_callback;
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
-	pc->buffer = NULL;
-	pc->request_transfer = pc->buffer_size = blocks * floppy->block_size;
+	pc->buf = NULL;
+	pc->req_xfer = pc->buf_size = blocks * floppy->block_size;
 	pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
 static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
-		idefloppy_pc_t *pc, struct request *rq)
+		struct ide_atapi_pc *pc, struct request *rq)
 {
 	idefloppy_init_pc(pc);
-	pc->callback = &idefloppy_rw_callback;
+	pc->idefloppy_callback = &idefloppy_rw_callback;
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
 	pc->b_count = rq->data_len;
 	if (rq->data_len && rq_data_dir(rq) == WRITE)
 		pc->flags |= PC_FLAG_WRITING;
-	pc->buffer = rq->data;
+	pc->buf = rq->data;
 	if (rq->bio)
 		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 	/*
 	 * possibly problematic, doesn't look like ide-floppy correctly
 	 * handled scattered requests if dma fails...
 	 */
-	pc->request_transfer = pc->buffer_size = rq->data_len;
+	pc->req_xfer = pc->buf_size = rq->data_len;
 }
 
 static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		struct request *rq, sector_t block_s)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	idefloppy_pc_t *pc;
+	struct ide_atapi_pc *pc;
 	unsigned long block = (unsigned long)block_s;
 
 	debug_log("dev: %s, cmd_type: %x, errors: %d\n",
@@ -924,7 +849,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		else
 			printk(KERN_ERR "ide-floppy: %s: I/O error\n",
 				drive->name);
-		idefloppy_do_end_request(drive, 0, 0);
+		idefloppy_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
 	if (blk_fs_request(rq)) {
@@ -932,20 +857,20 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		    (rq->nr_sectors % floppy->bs_factor)) {
 			printk(KERN_ERR "%s: unsupported r/w request size\n",
 					drive->name);
-			idefloppy_do_end_request(drive, 0, 0);
+			idefloppy_end_request(drive, 0, 0);
 			return ide_stopped;
 		}
 		pc = idefloppy_next_pc_storage(drive);
 		idefloppy_create_rw_cmd(floppy, pc, rq, block);
 	} else if (blk_special_request(rq)) {
-		pc = (idefloppy_pc_t *) rq->buffer;
+		pc = (struct ide_atapi_pc *) rq->buffer;
 	} else if (blk_pc_request(rq)) {
 		pc = idefloppy_next_pc_storage(drive);
 		idefloppy_blockpc_cmd(floppy, pc, rq);
 	} else {
 		blk_dump_rq_flags(rq,
 			"ide-floppy: unsupported command in queue");
-		idefloppy_do_end_request(drive, 0, 0);
+		idefloppy_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
 
@@ -957,7 +882,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
  * Add a special packet command request to the tail of the request queue,
  * and wait for it to be serviced.
  */
-static int idefloppy_queue_pc_tail(ide_drive_t *drive, idefloppy_pc_t *pc)
+static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 	struct request rq;
@@ -977,7 +902,7 @@ static int idefloppy_queue_pc_tail(ide_drive_t *drive, idefloppy_pc_t *pc)
 static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	u8 *page;
 	int capacity, lba_capacity;
 	u16 transfer_rate, sector_size, cyls, rpm;
@@ -991,16 +916,16 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 				" parameters\n");
 		return 1;
 	}
-	floppy->wp = !!(pc.buffer[3] & 0x80);
+	floppy->wp = !!(pc.buf[3] & 0x80);
 	set_disk_ro(floppy->disk, floppy->wp);
-	page = &pc.buffer[8];
+	page = &pc.buf[8];
 
-	transfer_rate = be16_to_cpu(*(u16 *)&pc.buffer[8 + 2]);
-	sector_size   = be16_to_cpu(*(u16 *)&pc.buffer[8 + 6]);
-	cyls          = be16_to_cpu(*(u16 *)&pc.buffer[8 + 8]);
-	rpm           = be16_to_cpu(*(u16 *)&pc.buffer[8 + 28]);
-	heads         = pc.buffer[8 + 4];
-	sectors       = pc.buffer[8 + 5];
+	transfer_rate = be16_to_cpu(*(u16 *)&pc.buf[8 + 2]);
+	sector_size   = be16_to_cpu(*(u16 *)&pc.buf[8 + 6]);
+	cyls          = be16_to_cpu(*(u16 *)&pc.buf[8 + 8]);
+	rpm           = be16_to_cpu(*(u16 *)&pc.buf[8 + 28]);
+	heads         = pc.buf[8 + 4];
+	sectors       = pc.buf[8 + 5];
 
 	capacity = cyls * heads * sectors * sector_size;
 
@@ -1029,7 +954,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	floppy->srfp = 0;
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE,
@@ -1039,7 +964,7 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 	if (idefloppy_queue_pc_tail(drive, &pc))
 		return 1;
 
-	floppy->srfp = pc.buffer[8 + 2] & 0x40;
+	floppy->srfp = pc.buf[8 + 2] & 0x40;
 	return (0);
 }
 
@@ -1050,7 +975,7 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 static int ide_floppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	u8 *cap_desc;
 	u8 header_len, desc_cnt;
 	int i, rc = 1, blocks, length;
@@ -1066,15 +991,15 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return 1;
 	}
-	header_len = pc.buffer[3];
-	cap_desc = &pc.buffer[4];
+	header_len = pc.buf[3];
+	cap_desc = &pc.buf[4];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	for (i = 0; i < desc_cnt; i++) {
 		unsigned int desc_start = 4 + i*8;
 
-		blocks = be32_to_cpu(*(u32 *)&pc.buffer[desc_start]);
-		length = be16_to_cpu(*(u16 *)&pc.buffer[desc_start + 6]);
+		blocks = be32_to_cpu(*(u32 *)&pc.buf[desc_start]);
+		length = be16_to_cpu(*(u16 *)&pc.buf[desc_start + 6]);
 
 		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
 				i, blocks * length / 1024, blocks, length);
@@ -1085,7 +1010,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		 * the code below is valid only for the 1st descriptor, ie i=0
 		 */
 
-		switch (pc.buffer[desc_start + 4] & 0x03) {
+		switch (pc.buf[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
 			if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE))
@@ -1130,7 +1055,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 			break;
 		}
 		debug_log("Descriptor 0 Code: %d\n",
-			  pc.buffer[desc_start + 4] & 0x03);
+			  pc.buf[desc_start + 4] & 0x03);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
@@ -1162,7 +1087,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 
 static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 {
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	u8 header_len, desc_cnt;
 	int i, blocks, length, u_array_size, u_index;
 	int __user *argp;
@@ -1178,7 +1103,7 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return (-EIO);
 	}
-	header_len = pc.buffer[3];
+	header_len = pc.buf[3];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	u_index = 0;
@@ -1195,8 +1120,8 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 		if (u_index >= u_array_size)
 			break;	/* User-supplied buffer too small */
 
-		blocks = be32_to_cpu(*(u32 *)&pc.buffer[desc_start]);
-		length = be16_to_cpu(*(u16 *)&pc.buffer[desc_start + 6]);
+		blocks = be32_to_cpu(*(u32 *)&pc.buf[desc_start]);
+		length = be16_to_cpu(*(u16 *)&pc.buf[desc_start + 6]);
 
 		if (put_user(blocks, argp))
 			return(-EFAULT);
@@ -1227,7 +1152,7 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	int progress_indication = 0x10000;
 
 	if (floppy->srfp) {
@@ -1271,33 +1196,39 @@ static sector_t idefloppy_capacity(ide_drive_t *drive)
  */
 static int idefloppy_identify_device(ide_drive_t *drive, struct hd_driveid *id)
 {
-	struct idefloppy_id_gcw gcw;
+	u8 gcw[2];
+	u8 device_type, protocol, removable, drq_type, packet_size;
 
 	*((u16 *) &gcw) = id->config;
 
+	device_type =  gcw[1] & 0x1F;
+	removable   = (gcw[0] & 0x80) >> 7;
+	protocol    = (gcw[1] & 0xC0) >> 6;
+	drq_type    = (gcw[0] & 0x60) >> 5;
+	packet_size =  gcw[0] & 0x03;
+
 #ifdef CONFIG_PPC
 	/* kludge for Apple PowerBook internal zip */
-	if ((gcw.device_type == 5) &&
-	    !strstr(id->model, "CD-ROM") &&
-	    strstr(id->model, "ZIP"))
-		gcw.device_type = 0;
+	if (device_type == 5 &&
+	    !strstr(id->model, "CD-ROM") && strstr(id->model, "ZIP"))
+		device_type = 0;
 #endif
 
-	if (gcw.protocol != 2)
+	if (protocol != 2)
 		printk(KERN_ERR "ide-floppy: Protocol (0x%02x) is not ATAPI\n",
-				gcw.protocol);
-	else if (gcw.device_type != 0)
+			protocol);
+	else if (device_type != 0)
 		printk(KERN_ERR "ide-floppy: Device type (0x%02x) is not set "
-				"to floppy\n", gcw.device_type);
-	else if (!gcw.removable)
+				"to floppy\n", device_type);
+	else if (!removable)
 		printk(KERN_ERR "ide-floppy: The removable flag is not set\n");
-	else if (gcw.drq_type == 3) {
+	else if (drq_type == 3)
 		printk(KERN_ERR "ide-floppy: Sorry, DRQ type (0x%02x) not "
-				"supported\n", gcw.drq_type);
-	} else if (gcw.packet_size != 0) {
+				"supported\n", drq_type);
+	else if (packet_size != 0)
 		printk(KERN_ERR "ide-floppy: Packet size (0x%02x) is not 12 "
-				"bytes long\n", gcw.packet_size);
-	} else
+				"bytes\n", packet_size);
+	else
 		return 1;
 	return 0;
 }
@@ -1322,11 +1253,12 @@ static inline void idefloppy_add_settings(ide_drive_t *drive) { ; }
 
 static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 {
-	struct idefloppy_id_gcw gcw;
+	u8 gcw[2];
 
 	*((u16 *) &gcw) = drive->id->config;
 	floppy->pc = floppy->pc_stack;
-	if (gcw.drq_type == 1)
+
+	if (((gcw[0] & 0x60) >> 5) == 1)
 		floppy->flags |= IDEFLOPPY_FLAG_DRQ_INTERRUPT;
 	/*
 	 * We used to check revisions here. At this point however I'm giving up.
@@ -1413,7 +1345,7 @@ static ide_driver_t idefloppy_driver = {
 	.media			= ide_floppy,
 	.supports_dsc_overlap	= 0,
 	.do_request		= idefloppy_do_request,
-	.end_request		= idefloppy_do_end_request,
+	.end_request		= idefloppy_end_request,
 	.error			= __ide_error,
 	.abort			= __ide_abort,
 #ifdef CONFIG_IDE_PROC_FS
@@ -1426,7 +1358,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_floppy_obj *floppy;
 	ide_drive_t *drive;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	int ret = 0;
 
 	debug_log("Reached %s\n", __func__);
@@ -1489,7 +1421,7 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	debug_log("Reached %s\n", __func__);
 
@@ -1521,8 +1453,8 @@ static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc,
-			       unsigned long arg, unsigned int cmd)
+static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy,
+		struct ide_atapi_pc *pc, unsigned long arg, unsigned int cmd)
 {
 	if (floppy->openers > 1)
 		return -EBUSY;
@@ -1551,7 +1483,7 @@ static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
 				  int __user *arg)
 {
 	int blocks, length, flags, err = 0;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	if (floppy->openers > 1) {
 		/* Don't format if someone is using the disk */
@@ -1602,7 +1534,7 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 	struct block_device *bdev = inode->i_bdev;
 	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
 	ide_drive_t *drive = floppy->drive;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	void __user *argp = (void __user *)arg;
 	int err;
 
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 9ebec08..25fda0a 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -1,17 +1,89 @@
 /*
  * generic/default IDE host driver
  *
- * Copyright (C) 2004 Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2004, 2008 Bartlomiej Zolnierkiewicz
  * This code was split off from ide.c.  See it for original copyrights.
  *
  * May be copied or modified under the terms of the GNU General Public License.
  */
 
+/*
+ * For special cases new interfaces may be added using sysfs, i.e.
+ *
+ *	echo -n "0x168:0x36e:10" > /sys/class/ide_generic/add
+ *
+ * will add an interface using I/O ports 0x168-0x16f/0x36e and IRQ 10.
+ */
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/ide.h>
 
+#define DRV_NAME	"ide_generic"
+
+static ssize_t store_add(struct class *cls, const char *buf, size_t n)
+{
+	ide_hwif_t *hwif;
+	unsigned int base, ctl;
+	int irq;
+	hw_regs_t hw;
+	u8 idx[] = { 0xff, 0xff, 0xff, 0xff };
+
+	if (sscanf(buf, "%x:%x:%d", &base, &ctl, &irq) != 3)
+		return -EINVAL;
+
+	hwif = ide_find_port(base);
+	if (hwif == NULL)
+		return -ENOENT;
+
+	memset(&hw, 0, sizeof(hw));
+	ide_std_init_ports(&hw, base, ctl);
+	hw.irq = irq;
+	hw.chipset = ide_generic;
+
+	ide_init_port_hw(hwif, &hw);
+
+	idx[0] = hwif->index;
+
+	ide_device_add(idx, NULL);
+
+	return n;
+};
+
+static struct class_attribute ide_generic_class_attrs[] = {
+	__ATTR(add, S_IWUSR, NULL, store_add),
+	__ATTR_NULL
+};
+
+static void ide_generic_class_release(struct class *cls)
+{
+	kfree(cls);
+}
+
+static int __init ide_generic_sysfs_init(void)
+{
+	struct class *cls;
+	int rc;
+
+	cls = kzalloc(sizeof(*cls), GFP_KERNEL);
+	if (!cls)
+		return -ENOMEM;
+
+	cls->name = DRV_NAME;
+	cls->owner = THIS_MODULE;
+	cls->class_release = ide_generic_class_release;
+	cls->class_attrs = ide_generic_class_attrs;
+
+	rc = class_register(cls);
+	if (rc) {
+		kfree(cls);
+		return rc;
+	}
+
+	return 0;
+}
+
 static int __init ide_generic_init(void)
 {
 	u8 idx[MAX_HWIFS];
@@ -19,15 +91,26 @@ static int __init ide_generic_init(void)
 
 	for (i = 0; i < MAX_HWIFS; i++) {
 		ide_hwif_t *hwif = &ide_hwifs[i];
+		unsigned long io_addr = ide_default_io_base(i);
+		hw_regs_t hw;
+
+		if (hwif->chipset == ide_unknown && io_addr) {
+			memset(&hw, 0, sizeof(hw));
+			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
+			hw.irq = ide_default_irq(io_addr);
+			ide_init_port_hw(hwif, &hw);
 
-		if (hwif->io_ports[IDE_DATA_OFFSET] && !hwif->present)
 			idx[i] = i;
-		else
+		} else
 			idx[i] = 0xff;
 	}
 
 	ide_device_add_all(idx, NULL);
 
+	if (ide_generic_sysfs_init())
+		printk(KERN_ERR DRV_NAME ": failed to create ide_generic "
+					 "class\n");
+
 	return 0;
 }
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 7153796..31e5afa 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -301,39 +301,45 @@ void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 	struct ide_taskfile *tf = &task->tf;
 
 	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data = hwif->INW(IDE_DATA_REG);
+		u16 data = hwif->INW(hwif->io_ports[IDE_DATA_OFFSET]);
 
 		tf->data = data & 0xff;
 		tf->hob_data = (data >> 8) & 0xff;
 	}
 
 	/* be sure we're looking at the low order bits */
-	hwif->OUTB(drive->ctl & ~0x80, IDE_CONTROL_REG);
+	hwif->OUTB(drive->ctl & ~0x80, hwif->io_ports[IDE_CONTROL_OFFSET]);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = hwif->INB(IDE_NSECTOR_REG);
+		tf->nsect  = hwif->INB(hwif->io_ports[IDE_NSECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = hwif->INB(IDE_SECTOR_REG);
+		tf->lbal   = hwif->INB(hwif->io_ports[IDE_SECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = hwif->INB(IDE_LCYL_REG);
+		tf->lbam   = hwif->INB(hwif->io_ports[IDE_LCYL_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = hwif->INB(IDE_HCYL_REG);
+		tf->lbah   = hwif->INB(hwif->io_ports[IDE_HCYL_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = hwif->INB(IDE_SELECT_REG);
+		tf->device = hwif->INB(hwif->io_ports[IDE_SELECT_OFFSET]);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		hwif->OUTB(drive->ctl | 0x80, IDE_CONTROL_REG);
+		hwif->OUTB(drive->ctl | 0x80,
+			   hwif->io_ports[IDE_CONTROL_OFFSET]);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = hwif->INB(IDE_FEATURE_REG);
+			tf->hob_feature =
+				hwif->INB(hwif->io_ports[IDE_FEATURE_OFFSET]);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = hwif->INB(IDE_NSECTOR_REG);
+			tf->hob_nsect   =
+				hwif->INB(hwif->io_ports[IDE_NSECTOR_OFFSET]);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = hwif->INB(IDE_SECTOR_REG);
+			tf->hob_lbal    =
+				hwif->INB(hwif->io_ports[IDE_SECTOR_OFFSET]);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = hwif->INB(IDE_LCYL_REG);
+			tf->hob_lbam    =
+				hwif->INB(hwif->io_ports[IDE_LCYL_OFFSET]);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = hwif->INB(IDE_HCYL_REG);
+			tf->hob_lbah    =
+				hwif->INB(hwif->io_ports[IDE_HCYL_OFFSET]);
 	}
 }
 
@@ -448,7 +454,8 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 		if (err == ABRT_ERR) {
 			if (drive->select.b.lba &&
 			    /* some newer drives don't support WIN_SPECIFY */
-			    hwif->INB(IDE_COMMAND_REG) == WIN_SPECIFY)
+			    hwif->INB(hwif->io_ports[IDE_COMMAND_OFFSET]) ==
+				WIN_SPECIFY)
 				return ide_stopped;
 		} else if ((err & BAD_CRC) == BAD_CRC) {
 			/* UDMA crc error, just retry the operation */
@@ -500,7 +507,8 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE, IDE_COMMAND_REG);
+		hwif->OUTB(WIN_IDLEIMMEDIATE,
+			   hwif->io_ports[IDE_COMMAND_OFFSET]);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index e77cee0..4594421 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -158,9 +158,12 @@ EXPORT_SYMBOL(default_hwif_mmiops);
 
 void SELECT_DRIVE (ide_drive_t *drive)
 {
-	if (HWIF(drive)->selectproc)
-		HWIF(drive)->selectproc(drive);
-	HWIF(drive)->OUTB(drive->select.all, IDE_SELECT_REG);
+	ide_hwif_t *hwif = drive->hwif;
+
+	if (hwif->selectproc)
+		hwif->selectproc(drive);
+
+	hwif->OUTB(drive->select.all, hwif->io_ports[IDE_SELECT_OFFSET]);
 }
 
 void SELECT_MASK (ide_drive_t *drive, int mask)
@@ -194,15 +197,18 @@ static void ata_input_data(ide_drive_t *drive, void *buffer, u32 wcount)
 	if (io_32bit) {
 		if (io_32bit & 2) {
 			unsigned long flags;
+
 			local_irq_save(flags);
-			ata_vlb_sync(drive, IDE_NSECTOR_REG);
-			hwif->INSL(IDE_DATA_REG, buffer, wcount);
+			ata_vlb_sync(drive, hwif->io_ports[IDE_NSECTOR_OFFSET]);
+			hwif->INSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+				   wcount);
 			local_irq_restore(flags);
 		} else
-			hwif->INSL(IDE_DATA_REG, buffer, wcount);
-	} else {
-		hwif->INSW(IDE_DATA_REG, buffer, wcount<<1);
-	}
+			hwif->INSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+				   wcount);
+	} else
+		hwif->INSW(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+			   wcount << 1);
 }
 
 /*
@@ -216,15 +222,18 @@ static void ata_output_data(ide_drive_t *drive, void *buffer, u32 wcount)
 	if (io_32bit) {
 		if (io_32bit & 2) {
 			unsigned long flags;
+
 			local_irq_save(flags);
-			ata_vlb_sync(drive, IDE_NSECTOR_REG);
-			hwif->OUTSL(IDE_DATA_REG, buffer, wcount);
+			ata_vlb_sync(drive, hwif->io_ports[IDE_NSECTOR_OFFSET]);
+			hwif->OUTSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+				    wcount);
 			local_irq_restore(flags);
 		} else
-			hwif->OUTSL(IDE_DATA_REG, buffer, wcount);
-	} else {
-		hwif->OUTSW(IDE_DATA_REG, buffer, wcount<<1);
-	}
+			hwif->OUTSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+				    wcount);
+	} else
+		hwif->OUTSW(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+			    wcount << 1);
 }
 
 /*
@@ -243,13 +252,15 @@ static void atapi_input_bytes(ide_drive_t *drive, void *buffer, u32 bytecount)
 #if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
 	if (MACH_IS_ATARI || MACH_IS_Q40) {
 		/* Atari has a byte-swapped IDE interface */
-		insw_swapw(IDE_DATA_REG, buffer, bytecount / 2);
+		insw_swapw(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+			   bytecount / 2);
 		return;
 	}
 #endif /* CONFIG_ATARI || CONFIG_Q40 */
 	hwif->ata_input_data(drive, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
-		hwif->INSW(IDE_DATA_REG, ((u8 *)buffer)+(bytecount & ~0x03), 1);
+		hwif->INSW(hwif->io_ports[IDE_DATA_OFFSET],
+			   (u8 *)buffer + (bytecount & ~0x03), 1);
 }
 
 static void atapi_output_bytes(ide_drive_t *drive, void *buffer, u32 bytecount)
@@ -260,13 +271,15 @@ static void atapi_output_bytes(ide_drive_t *drive, void *buffer, u32 bytecount)
 #if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
 	if (MACH_IS_ATARI || MACH_IS_Q40) {
 		/* Atari has a byte-swapped IDE interface */
-		outsw_swapw(IDE_DATA_REG, buffer, bytecount / 2);
+		outsw_swapw(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+			    bytecount / 2);
 		return;
 	}
 #endif /* CONFIG_ATARI || CONFIG_Q40 */
 	hwif->ata_output_data(drive, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
-		hwif->OUTSW(IDE_DATA_REG, ((u8*)buffer)+(bytecount & ~0x03), 1);
+		hwif->OUTSW(hwif->io_ports[IDE_DATA_OFFSET],
+			    (u8 *)buffer + (bytecount & ~0x03), 1);
 }
 
 void default_hwif_transport(ide_hwif_t *hwif)
@@ -429,7 +442,7 @@ int drive_is_ready (ide_drive_t *drive)
 	 * an interrupt with another pci card/device.  We make no assumptions
 	 * about possible isa-pnp and pci-pnp issues yet.
 	 */
-	if (IDE_CONTROL_REG)
+	if (hwif->io_ports[IDE_CONTROL_OFFSET])
 		stat = ide_read_altstatus(drive);
 	else
 		/* Note: this may clear a pending IRQ!! */
@@ -631,7 +644,7 @@ int ide_driveid_update(ide_drive_t *drive)
 	SELECT_MASK(drive, 1);
 	ide_set_irq(drive, 1);
 	msleep(50);
-	hwif->OUTB(WIN_IDENTIFY, IDE_COMMAND_REG);
+	hwif->OUTB(WIN_IDENTIFY, hwif->io_ports[IDE_COMMAND_OFFSET]);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -718,9 +731,10 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	SELECT_MASK(drive, 0);
 	udelay(1);
 	ide_set_irq(drive, 0);
-	hwif->OUTB(speed, IDE_NSECTOR_REG);
-	hwif->OUTB(SETFEATURES_XFER, IDE_FEATURE_REG);
-	hwif->OUTBSYNC(drive, WIN_SETFEATURES, IDE_COMMAND_REG);
+	hwif->OUTB(speed, hwif->io_ports[IDE_NSECTOR_OFFSET]);
+	hwif->OUTB(SETFEATURES_XFER, hwif->io_ports[IDE_FEATURE_OFFSET]);
+	hwif->OUTBSYNC(drive, WIN_SETFEATURES,
+		       hwif->io_ports[IDE_COMMAND_OFFSET]);
 	if (drive->quirk_list == 2)
 		ide_set_irq(drive, 1);
 
@@ -828,7 +842,7 @@ void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 
 	spin_lock_irqsave(&ide_lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	hwif->OUTBSYNC(drive, cmd, IDE_COMMAND_REG);
+	hwif->OUTBSYNC(drive, cmd, hwif->io_ports[IDE_COMMAND_OFFSET]);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -1009,7 +1023,8 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	unsigned long flags;
 	ide_hwif_t *hwif;
 	ide_hwgroup_t *hwgroup;
-	
+	u8 ctl;
+
 	spin_lock_irqsave(&ide_lock, flags);
 	hwif = HWIF(drive);
 	hwgroup = HWGROUP(drive);
@@ -1023,7 +1038,8 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		hwif->OUTBSYNC(drive, WIN_SRST, IDE_COMMAND_REG);
+		hwif->OUTBSYNC(drive, WIN_SRST,
+			       hwif->io_ports[IDE_COMMAND_OFFSET]);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
@@ -1039,7 +1055,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	for (unit = 0; unit < MAX_DRIVES; ++unit)
 		pre_reset(&hwif->drives[unit]);
 
-	if (!IDE_CONTROL_REG) {
+	if (hwif->io_ports[IDE_CONTROL_OFFSET] == 0) {
 		spin_unlock_irqrestore(&ide_lock, flags);
 		return ide_stopped;
 	}
@@ -1054,16 +1070,14 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	 * recover from reset very quickly, saving us the first 50ms wait time.
 	 */
 	/* set SRST and nIEN */
-	hwif->OUTBSYNC(drive, drive->ctl|6,IDE_CONTROL_REG);
+	hwif->OUTBSYNC(drive, drive->ctl|6, hwif->io_ports[IDE_CONTROL_OFFSET]);
 	/* more than enough time */
 	udelay(10);
-	if (drive->quirk_list == 2) {
-		/* clear SRST and nIEN */
-		hwif->OUTBSYNC(drive, drive->ctl, IDE_CONTROL_REG);
-	} else {
-		/* clear SRST, leave nIEN */
-		hwif->OUTBSYNC(drive, drive->ctl|2, IDE_CONTROL_REG);
-	}
+	if (drive->quirk_list == 2)
+		ctl = drive->ctl;	/* clear SRST and nIEN */
+	else
+		ctl = drive->ctl | 2;	/* clear SRST, leave nIEN */
+	hwif->OUTBSYNC(drive, ctl, hwif->io_ports[IDE_CONTROL_OFFSET]);
 	/* more than enough time */
 	udelay(10);
 	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index c14bb53..34c2ad3 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -62,7 +62,7 @@ static void idepnp_remove(struct pnp_dev * dev)
 	ide_hwif_t *hwif = pnp_get_drvdata(dev);
 
 	if (hwif)
-		ide_unregister(hwif->index, 0, 0);
+		ide_unregister(hwif->index);
 	else
 		printk(KERN_ERR "idepnp: Unable to remove device, please report.\n");
 }
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 47a1149..6a196c2 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -271,7 +271,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	/* take a deep breath */
 	msleep(50);
 
-	if (IDE_CONTROL_REG) {
+	if (hwif->io_ports[IDE_CONTROL_OFFSET]) {
 		a = ide_read_altstatus(drive);
 		s = ide_read_status(drive);
 		if ((a ^ s) & ~INDEX_STAT)
@@ -289,10 +289,10 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	 */
 	if ((cmd == WIN_PIDENTIFY))
 		/* disable dma & overlap */
-		hwif->OUTB(0, IDE_FEATURE_REG);
+		hwif->OUTB(0, hwif->io_ports[IDE_FEATURE_OFFSET]);
 
 	/* ask drive for ID */
-	hwif->OUTB(cmd, IDE_COMMAND_REG);
+	hwif->OUTB(cmd, hwif->io_ports[IDE_COMMAND_OFFSET]);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -353,7 +353,7 @@ static int try_to_identify (ide_drive_t *drive, u8 cmd)
 	 * interrupts during the identify-phase that
 	 * the irq handler isn't expecting.
 	 */
-	if (IDE_CONTROL_REG) {
+	if (hwif->io_ports[IDE_CONTROL_OFFSET]) {
 		if (!hwif->irq) {
 			autoprobe = 1;
 			cookie = probe_irq_on();
@@ -445,7 +445,8 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	msleep(50);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	if (hwif->INB(IDE_SELECT_REG) != drive->select.all && !drive->present) {
+	if (hwif->INB(hwif->io_ports[IDE_SELECT_OFFSET]) != drive->select.all &&
+	    !drive->present) {
 		if (drive->select.b.unit != 0) {
 			/* exit with drive0 selected */
 			SELECT_DRIVE(&hwif->drives[0]);
@@ -477,9 +478,11 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			printk(KERN_ERR "%s: no response (status = 0x%02x), "
 					"resetting drive\n", drive->name, stat);
 			msleep(50);
-			hwif->OUTB(drive->select.all, IDE_SELECT_REG);
+			hwif->OUTB(drive->select.all,
+				   hwif->io_ports[IDE_SELECT_OFFSET]);
 			msleep(50);
-			hwif->OUTB(WIN_SRST, IDE_COMMAND_REG);
+			hwif->OUTB(WIN_SRST,
+				   hwif->io_ports[IDE_COMMAND_OFFSET]);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
@@ -515,7 +518,7 @@ static void enable_nest (ide_drive_t *drive)
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->OUTB(EXABYTE_ENABLE_NEST, IDE_COMMAND_REG);
+	hwif->OUTB(EXABYTE_ENABLE_NEST, hwif->io_ports[IDE_COMMAND_OFFSET]);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
@@ -623,7 +626,7 @@ static void hwif_release_dev (struct device *dev)
 	complete(&hwif->gendev_rel_comp);
 }
 
-static void ide_register_port(ide_hwif_t *hwif)
+static int ide_register_port(ide_hwif_t *hwif)
 {
 	int ret;
 
@@ -639,9 +642,23 @@ static void ide_register_port(ide_hwif_t *hwif)
 	}
 	hwif->gendev.release = hwif_release_dev;
 	ret = device_register(&hwif->gendev);
-	if (ret < 0)
+	if (ret < 0) {
 		printk(KERN_WARNING "IDE: %s: device_register error: %d\n",
 			__FUNCTION__, ret);
+		goto out;
+	}
+
+	get_device(&hwif->gendev);
+
+	hwif->portdev = device_create(ide_port_class, &hwif->gendev,
+				      MKDEV(0, 0), hwif->name);
+	if (IS_ERR(hwif->portdev)) {
+		ret = PTR_ERR(hwif->portdev);
+		device_unregister(&hwif->gendev);
+	}
+	dev_set_drvdata(hwif->portdev, hwif);
+out:
+	return ret;
 }
 
 /**
@@ -949,6 +966,7 @@ static void ide_port_setup_devices(ide_hwif_t *hwif)
 {
 	int i;
 
+	mutex_lock(&ide_cfg_mtx);
 	for (i = 0; i < MAX_DRIVES; i++) {
 		ide_drive_t *drive = &hwif->drives[i];
 
@@ -963,6 +981,7 @@ static void ide_port_setup_devices(ide_hwif_t *hwif)
 
 		ide_add_drive_to_hwgroup(drive);
 	}
+	mutex_unlock(&ide_cfg_mtx);
 }
 
 /*
@@ -1088,8 +1107,6 @@ static int init_irq (ide_hwif_t *hwif)
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
 	printk("\n");
 
-	ide_port_setup_devices(hwif);
-
 	mutex_unlock(&ide_cfg_mtx);
 	return 0;
 out_unlink:
@@ -1199,6 +1216,8 @@ static void drive_release_dev (struct device *dev)
 {
 	ide_drive_t *drive = container_of(dev, ide_drive_t, gendev);
 
+	ide_proc_unregister_device(drive);
+
 	spin_lock_irq(&ide_lock);
 	ide_remove_drive_from_hwgroup(drive);
 	kfree(drive->id);
@@ -1214,6 +1233,10 @@ static void drive_release_dev (struct device *dev)
 	complete(&drive->gendev_rel_comp);
 }
 
+#ifndef ide_default_irq
+#define ide_default_irq(irq) 0
+#endif
+
 static int hwif_init(ide_hwif_t *hwif)
 {
 	int old_irq;
@@ -1225,13 +1248,6 @@ static int hwif_init(ide_hwif_t *hwif)
 			return 0;
 		}
 	}
-#ifdef CONFIG_BLK_DEV_HD
-	if (hwif->irq == HD_IRQ && hwif->io_ports[IDE_DATA_OFFSET] != HD_DATA) {
-		printk("%s: CANNOT SHARE IRQ WITH OLD "
-			"HARDDISK DRIVER (hd.c)\n", hwif->name);
-		return 0;
-	}
-#endif /* CONFIG_BLK_DEV_HD */
 
 	if (register_blkdev(hwif->major, hwif->name))
 		return 0;
@@ -1366,13 +1382,68 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 	/* call chipset specific routine for each enabled port */
 	if (d->init_hwif)
 		d->init_hwif(hwif);
+}
 
+static void ide_port_cable_detect(ide_hwif_t *hwif)
+{
 	if (hwif->cable_detect && (hwif->ultra_mask & 0x78)) {
 		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 			hwif->cbl = hwif->cable_detect(hwif);
 	}
 }
 
+static ssize_t store_delete_devices(struct device *portdev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t n)
+{
+	ide_hwif_t *hwif = dev_get_drvdata(portdev);
+
+	if (strncmp(buf, "1", n))
+		return -EINVAL;
+
+	ide_port_unregister_devices(hwif);
+
+	return n;
+};
+
+static DEVICE_ATTR(delete_devices, S_IWUSR, NULL, store_delete_devices);
+
+static ssize_t store_scan(struct device *portdev,
+			  struct device_attribute *attr,
+			  const char *buf, size_t n)
+{
+	ide_hwif_t *hwif = dev_get_drvdata(portdev);
+
+	if (strncmp(buf, "1", n))
+		return -EINVAL;
+
+	ide_port_unregister_devices(hwif);
+	ide_port_scan(hwif);
+
+	return n;
+};
+
+static DEVICE_ATTR(scan, S_IWUSR, NULL, store_scan);
+
+static struct device_attribute *ide_port_attrs[] = {
+	&dev_attr_delete_devices,
+	&dev_attr_scan,
+	NULL
+};
+
+static int ide_sysfs_register_port(ide_hwif_t *hwif)
+{
+	int i, rc;
+
+	for (i = 0; ide_port_attrs[i]; i++) {
+		rc = device_create_file(hwif->portdev, ide_port_attrs[i]);
+		if (rc)
+			break;
+	}
+
+	return rc;
+}
+
 int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 {
 	ide_hwif_t *hwif, *mate = NULL;
@@ -1394,6 +1465,7 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 		mate = (i & 1) ? NULL : hwif;
 
 		ide_init_port(hwif, i & 1, d);
+		ide_port_cable_detect(hwif);
 		ide_port_init_devices(hwif);
 	}
 
@@ -1441,6 +1513,8 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 			continue;
 		}
 
+		ide_port_setup_devices(hwif);
+
 		ide_acpi_init(hwif);
 		ide_acpi_port_init_devices(hwif);
 	}
@@ -1452,8 +1526,7 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 		hwif = &ide_hwifs[idx[i]];
 
 		if (hwif->present) {
-			if (hwif->chipset == ide_unknown ||
-			    hwif->chipset == ide_forced)
+			if (hwif->chipset == ide_unknown)
 				hwif->chipset = ide_generic;
 			hwif_register_devices(hwif);
 		}
@@ -1466,6 +1539,7 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 		hwif = &ide_hwifs[idx[i]];
 
 		if (hwif->present) {
+			ide_sysfs_register_port(hwif);
 			ide_proc_register_port(hwif);
 			ide_proc_port_register_devices(hwif);
 		}
@@ -1486,3 +1560,21 @@ int ide_device_add(u8 idx[4], const struct ide_port_info *d)
 	return ide_device_add_all(idx_all, d);
 }
 EXPORT_SYMBOL_GPL(ide_device_add);
+
+void ide_port_scan(ide_hwif_t *hwif)
+{
+	ide_port_cable_detect(hwif);
+	ide_port_init_devices(hwif);
+
+	if (ide_probe_port(hwif) < 0)
+		return;
+
+	hwif->present = 1;
+
+	ide_port_tune_devices(hwif);
+	ide_acpi_port_init_devices(hwif);
+	ide_port_setup_devices(hwif);
+	hwif_register_devices(hwif);
+	ide_proc_port_register_devices(hwif);
+}
+EXPORT_SYMBOL_GPL(ide_port_scan);
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index bab88ca..edd7f18 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -46,9 +46,6 @@ static int proc_ide_read_imodel
 	int		len;
 	const char	*name;
 
-	/*
-	 * Neither ide_unknown nor ide_forced should be set at this point.
-	 */
 	switch (hwif->chipset) {
 		case ide_generic:	name = "generic";	break;
 		case ide_pci:		name = "pci";		break;
@@ -764,27 +761,16 @@ void ide_proc_port_register_devices(ide_hwif_t *hwif)
 	}
 }
 
-static void destroy_proc_ide_device(ide_hwif_t *hwif, ide_drive_t *drive)
+void ide_proc_unregister_device(ide_drive_t *drive)
 {
 	if (drive->proc) {
 		ide_remove_proc_entries(drive->proc, generic_drive_entries);
 		remove_proc_entry(drive->name, proc_ide_root);
-		remove_proc_entry(drive->name, hwif->proc);
+		remove_proc_entry(drive->name, drive->hwif->proc);
 		drive->proc = NULL;
 	}
 }
 
-static void destroy_proc_ide_drives(ide_hwif_t *hwif)
-{
-	int	d;
-
-	for (d = 0; d < MAX_DRIVES; d++) {
-		ide_drive_t *drive = &hwif->drives[d];
-		if (drive->proc)
-			destroy_proc_ide_device(hwif, drive);
-	}
-}
-
 static ide_proc_entry_t hwif_entries[] = {
 	{ "channel",	S_IFREG|S_IRUGO,	proc_ide_read_channel,	NULL },
 	{ "mate",	S_IFREG|S_IRUGO,	proc_ide_read_mate,	NULL },
@@ -816,7 +802,6 @@ EXPORT_SYMBOL_GPL(ide_pci_create_host_proc);
 void ide_proc_unregister_port(ide_hwif_t *hwif)
 {
 	if (hwif->proc) {
-		destroy_proc_ide_drives(hwif);
 		ide_remove_proc_entries(hwif->proc, hwif_entries);
 		remove_proc_entry(hwif->name, proc_ide_root);
 		hwif->proc = NULL;
diff --git a/drivers/ide/ide-scan-pci.c b/drivers/ide/ide-scan-pci.c
index 93d2e41..98888da 100644
--- a/drivers/ide/ide-scan-pci.c
+++ b/drivers/ide/ide-scan-pci.c
@@ -88,13 +88,8 @@ static int __init ide_scan_pcibus(void)
 	struct list_head *l, *n;
 
 	pre_init = 0;
-	if (!ide_scan_direction)
-		while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)))
-			ide_scan_pcidev(dev);
-	else
-		while ((dev = pci_get_device_reverse(PCI_ANY_ID, PCI_ANY_ID,
-						     dev)))
-			ide_scan_pcidev(dev);
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)))
+		ide_scan_pcidev(dev);
 
 	/*
 	 *	Hand the drivers over to the PCI layer now we
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 0598ecf..f43fd07 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -181,49 +181,63 @@ struct idetape_bh {
 	char *b_data;
 };
 
-typedef struct idetape_packet_command_s {
-	/* Actual packet bytes */
-	u8 c[12];
-	/* On each retry, we increment retries */
-	int retries;
-	/* Error code */
-	int error;
-	/* Bytes to transfer */
-	int request_transfer;
-	/* Bytes actually transferred */
-	int actually_transferred;
-	/* Size of our data buffer */
-	int buffer_size;
-	struct idetape_bh *bh;
-	char *b_data;
-	int b_count;
-	/* Data buffer */
-	u8 *buffer;
-	/* Pointer into the above buffer */
-	u8 *current_position;
-	/* Called when this packet command is completed */
-	ide_startstop_t (*callback) (ide_drive_t *);
-	/* Temporary buffer */
-	u8 pc_buffer[IDETAPE_PC_BUFFER_SIZE];
-	/* Status/Action bit flags: long for set_bit */
-	unsigned long flags;
-} idetape_pc_t;
+/* Tape door status */
+#define DOOR_UNLOCKED			0
+#define DOOR_LOCKED			1
+#define DOOR_EXPLICITLY_LOCKED		2
+
+/* Some defines for the SPACE command */
+#define IDETAPE_SPACE_OVER_FILEMARK	1
+#define IDETAPE_SPACE_TO_EOD		3
+
+/* Some defines for the LOAD UNLOAD command */
+#define IDETAPE_LU_LOAD_MASK		1
+#define IDETAPE_LU_RETENSION_MASK	2
+#define IDETAPE_LU_EOT_MASK		4
 
 /*
- *	Packet command flag bits.
+ * Special requests for our block device strategy routine.
+ *
+ * In order to service a character device command, we add special requests to
+ * the tail of our block device request queue and wait for their completion.
  */
-/* Set when an error is considered normal - We won't retry */
-#define	PC_ABORT			0
-/* 1 When polling for DSC on a media access command */
-#define PC_WAIT_FOR_DSC			1
-/* 1 when we prefer to use DMA if possible */
-#define PC_DMA_RECOMMENDED		2
-/* 1 while DMA in progress */
-#define	PC_DMA_IN_PROGRESS		3
-/* 1 when encountered problem during DMA */
-#define	PC_DMA_ERROR			4
-/* Data direction */
-#define	PC_WRITING			5
+
+enum {
+	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
+	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
+	REQ_IDETAPE_READ	= (1 << 2),
+	REQ_IDETAPE_WRITE	= (1 << 3),
+};
+
+/* Error codes returned in rq->errors to the higher part of the driver. */
+#define IDETAPE_ERROR_GENERAL		101
+#define IDETAPE_ERROR_FILEMARK		102
+#define IDETAPE_ERROR_EOD		103
+
+/* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
+#define IDETAPE_BLOCK_DESCRIPTOR	0
+#define IDETAPE_CAPABILITIES_PAGE	0x2a
+
+/* Tape flag bits values. */
+enum {
+	IDETAPE_FLAG_IGNORE_DSC		= (1 << 0),
+	/* 0 When the tape position is unknown */
+	IDETAPE_FLAG_ADDRESS_VALID	= (1 <<	1),
+	/* Device already opened */
+	IDETAPE_FLAG_BUSY			= (1 << 2),
+	/* Error detected in a pipeline stage */
+	IDETAPE_FLAG_PIPELINE_ERR	= (1 <<	3),
+	/* Attempt to auto-detect the current user block size */
+	IDETAPE_FLAG_DETECT_BS		= (1 << 4),
+	/* Currently on a filemark */
+	IDETAPE_FLAG_FILEMARK		= (1 << 5),
+	/* DRQ interrupt device */
+	IDETAPE_FLAG_DRQ_INTERRUPT	= (1 << 6),
+	/* pipeline active */
+	IDETAPE_FLAG_PIPELINE_ACTIVE	= (1 << 7),
+	/* 0 = no tape is loaded, so we don't rewind after ejecting */
+	IDETAPE_FLAG_MEDIUM_PRESENT	= (1 << 8),
+};
 
 /* A pipeline stage. */
 typedef struct idetape_stage_s {
@@ -258,11 +272,11 @@ typedef struct ide_tape_obj {
 	 *	retry, to get detailed information on what went wrong.
 	 */
 	/* Current packet command */
-	idetape_pc_t *pc;
+	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
-	idetape_pc_t *failed_pc;
+	struct ide_atapi_pc *failed_pc;
 	/* Packet command stack */
-	idetape_pc_t pc_stack[IDETAPE_PC_STACK];
+	struct ide_atapi_pc pc_stack[IDETAPE_PC_STACK];
 	/* Next free packet command storage space */
 	int pc_stack_index;
 	struct request rq_stack[IDETAPE_PC_STACK];
@@ -446,58 +460,6 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 	mutex_unlock(&idetape_ref_mutex);
 }
 
-/* Tape door status */
-#define DOOR_UNLOCKED			0
-#define DOOR_LOCKED			1
-#define DOOR_EXPLICITLY_LOCKED		2
-
-/*
- *	Tape flag bits values.
- */
-#define IDETAPE_IGNORE_DSC		0
-#define IDETAPE_ADDRESS_VALID		1	/* 0 When the tape position is unknown */
-#define IDETAPE_BUSY			2	/* Device already opened */
-#define IDETAPE_PIPELINE_ERROR		3	/* Error detected in a pipeline stage */
-#define IDETAPE_DETECT_BS		4	/* Attempt to auto-detect the current user block size */
-#define IDETAPE_FILEMARK		5	/* Currently on a filemark */
-#define IDETAPE_DRQ_INTERRUPT		6	/* DRQ interrupt device */
-#define IDETAPE_READ_ERROR		7
-#define IDETAPE_PIPELINE_ACTIVE		8	/* pipeline active */
-/* 0 = no tape is loaded, so we don't rewind after ejecting */
-#define IDETAPE_MEDIUM_PRESENT		9
-
-/* Some defines for the SPACE command */
-#define IDETAPE_SPACE_OVER_FILEMARK	1
-#define IDETAPE_SPACE_TO_EOD		3
-
-/* Some defines for the LOAD UNLOAD command */
-#define IDETAPE_LU_LOAD_MASK		1
-#define IDETAPE_LU_RETENSION_MASK	2
-#define IDETAPE_LU_EOT_MASK		4
-
-/*
- * Special requests for our block device strategy routine.
- *
- * In order to service a character device command, we add special requests to
- * the tail of our block device request queue and wait for their completion.
- */
-
-enum {
-	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
-	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
-	REQ_IDETAPE_READ	= (1 << 2),
-	REQ_IDETAPE_WRITE	= (1 << 3),
-};
-
-/* Error codes returned in rq->errors to the higher part of the driver. */
-#define	IDETAPE_ERROR_GENERAL		101
-#define	IDETAPE_ERROR_FILEMARK		102
-#define	IDETAPE_ERROR_EOD		103
-
-/* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
-#define IDETAPE_BLOCK_DESCRIPTOR	0
-#define	IDETAPE_CAPABILITIES_PAGE	0x2a
-
 /*
  * The variables below are used for the character device interface. Additional
  * state variables are defined in our ide_drive_t structure.
@@ -518,17 +480,7 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 	return tape;
 }
 
-/*
- * Too bad. The drive wants to send us data which we are not ready to accept.
- * Just throw it away.
- */
-static void idetape_discard_data(ide_drive_t *drive, unsigned int bcount)
-{
-	while (bcount--)
-		(void) HWIF(drive)->INB(IDE_DATA_REG);
-}
-
-static void idetape_input_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+static void idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
@@ -538,7 +490,7 @@ static void idetape_input_buffers(ide_drive_t *drive, idetape_pc_t *pc,
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_input_buffers\n");
-			idetape_discard_data(drive, bcount);
+			ide_atapi_discard_data(drive, bcount);
 			return;
 		}
 		count = min(
@@ -557,7 +509,7 @@ static void idetape_input_buffers(ide_drive_t *drive, idetape_pc_t *pc,
 	pc->bh = bh;
 }
 
-static void idetape_output_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+static void idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				   unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
@@ -585,13 +537,13 @@ static void idetape_output_buffers(ide_drive_t *drive, idetape_pc_t *pc,
 	}
 }
 
-static void idetape_update_buffers(idetape_pc_t *pc)
+static void idetape_update_buffers(struct ide_atapi_pc *pc)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
-	unsigned int bcount = pc->actually_transferred;
+	unsigned int bcount = pc->xferred;
 
-	if (test_bit(PC_WRITING, &pc->flags))
+	if (pc->flags & PC_FLAG_WRITING)
 		return;
 	while (bcount) {
 		if (bh == NULL) {
@@ -614,7 +566,7 @@ static void idetape_update_buffers(idetape_pc_t *pc)
  *	driver. A storage space for a maximum of IDETAPE_PC_STACK packet
  *	commands is allocated at initialization time.
  */
-static idetape_pc_t *idetape_next_pc_storage(ide_drive_t *drive)
+static struct ide_atapi_pc *idetape_next_pc_storage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -649,14 +601,14 @@ static struct request *idetape_next_rq_storage(ide_drive_t *drive)
 	return (&tape->rq_stack[tape->rq_stack_index++]);
 }
 
-static void idetape_init_pc(idetape_pc_t *pc)
+static void idetape_init_pc(struct ide_atapi_pc *pc)
 {
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
 	pc->flags = 0;
-	pc->request_transfer = 0;
-	pc->buffer = pc->pc_buffer;
-	pc->buffer_size = IDETAPE_PC_BUFFER_SIZE;
+	pc->req_xfer = 0;
+	pc->buf = pc->pc_buf;
+	pc->buf_size = IDETAPE_PC_BUFFER_SIZE;
 	pc->bh = NULL;
 	pc->b_data = NULL;
 }
@@ -668,7 +620,7 @@ static void idetape_init_pc(idetape_pc_t *pc)
 static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc = tape->failed_pc;
+	struct ide_atapi_pc *pc = tape->failed_pc;
 
 	tape->sense_key = sense[2] & 0xF;
 	tape->asc       = sense[12];
@@ -677,9 +629,9 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	debug_log(DBG_ERR, "pc = %x, sense key = %x, asc = %x, ascq = %x\n",
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
-	/* Correct pc->actually_transferred by asking the tape.	 */
-	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
-		pc->actually_transferred = pc->request_transfer -
+	/* Correct pc->xferred by asking the tape.	 */
+	if (pc->flags & PC_FLAG_DMA_ERROR) {
+		pc->xferred = pc->req_xfer -
 			tape->blk_size *
 			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
 		idetape_update_buffers(pc);
@@ -697,27 +649,27 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			/* don't report an error, everything's ok */
 			pc->error = 0;
 			/* don't retry read/write */
-			set_bit(PC_ABORT, &pc->flags);
+			pc->flags |= PC_FLAG_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 && (sense[2] & 0x80)) {
 		pc->error = IDETAPE_ERROR_FILEMARK;
-		set_bit(PC_ABORT, &pc->flags);
+		pc->flags |= PC_FLAG_ABORT;
 	}
 	if (pc->c[0] == WRITE_6) {
 		if ((sense[2] & 0x40) || (tape->sense_key == 0xd
 		     && tape->asc == 0x0 && tape->ascq == 0x2)) {
 			pc->error = IDETAPE_ERROR_EOD;
-			set_bit(PC_ABORT, &pc->flags);
+			pc->flags |= PC_FLAG_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		if (tape->sense_key == 8) {
 			pc->error = IDETAPE_ERROR_EOD;
-			set_bit(PC_ABORT, &pc->flags);
+			pc->flags |= PC_FLAG_ABORT;
 		}
-		if (!test_bit(PC_ABORT, &pc->flags) &&
-		    pc->actually_transferred)
+		if (!(pc->flags & PC_FLAG_ABORT) &&
+		    pc->xferred)
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
 }
@@ -872,14 +824,16 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 			remove_stage = 1;
 			if (error) {
-				set_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+				set_bit(IDETAPE_FLAG_PIPELINE_ERR,
+					&tape->flags);
 				if (error == IDETAPE_ERROR_EOD)
 					idetape_abort_pipeline(drive,
 								active_stage);
 			}
 		} else if (rq->cmd[0] & REQ_IDETAPE_READ) {
 			if (error == IDETAPE_ERROR_EOD) {
-				set_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+				set_bit(IDETAPE_FLAG_PIPELINE_ERR,
+					&tape->flags);
 				idetape_abort_pipeline(drive, active_stage);
 			}
 		}
@@ -912,7 +866,7 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	if (remove_stage)
 		idetape_remove_stage_head(drive);
 	if (tape->active_data_rq == NULL)
-		clear_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+		clear_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
 	spin_unlock_irqrestore(&tape->lock, flags);
 	return 0;
 }
@@ -924,7 +878,7 @@ static ide_startstop_t idetape_request_sense_callback(ide_drive_t *drive)
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	if (!tape->pc->error) {
-		idetape_analyze_error(drive, tape->pc->buffer);
+		idetape_analyze_error(drive, tape->pc->buf);
 		idetape_end_request(drive, 1, 0);
 	} else {
 		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself - "
@@ -934,13 +888,13 @@ static ide_startstop_t idetape_request_sense_callback(ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void idetape_create_request_sense_cmd(idetape_pc_t *pc)
+static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
-	pc->request_transfer = 20;
-	pc->callback = &idetape_request_sense_callback;
+	pc->req_xfer = 20;
+	pc->idetape_callback = &idetape_request_sense_callback;
 }
 
 static void idetape_init_rq(struct request *rq, u8 cmd)
@@ -965,7 +919,7 @@ static void idetape_init_rq(struct request *rq, u8 cmd)
  * handling functions should queue request to the lower level part and wait for
  * their completion using idetape_queue_pc_tail or idetape_queue_rw_tail.
  */
-static void idetape_queue_pc_head(ide_drive_t *drive, idetape_pc_t *pc,
+static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  struct request *rq)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
@@ -984,14 +938,14 @@ static void idetape_queue_pc_head(ide_drive_t *drive, idetape_pc_t *pc,
 static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc;
+	struct ide_atapi_pc *pc;
 	struct request *rq;
 
 	(void)ide_read_error(drive);
 	pc = idetape_next_pc_storage(drive);
 	rq = idetape_next_rq_storage(drive);
 	idetape_create_request_sense_cmd(pc);
-	set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+	set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
 	idetape_queue_pc_head(drive, pc, rq);
 	return ide_stopped;
 }
@@ -1010,7 +964,7 @@ static void idetape_postpone_request(ide_drive_t *drive)
 	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
 
-typedef void idetape_io_buf(ide_drive_t *, idetape_pc_t *, unsigned int);
+typedef void idetape_io_buf(ide_drive_t *, struct ide_atapi_pc *, unsigned int);
 
 /*
  * This is the usual interrupt handler which will be called during a packet
@@ -1023,7 +977,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc = tape->pc;
+	struct ide_atapi_pc *pc = tape->pc;
 	xfer_func_t *xferfunc;
 	idetape_io_buf *iobuf;
 	unsigned int temp;
@@ -1038,7 +992,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	/* Clear the interrupt */
 	stat = ide_read_status(drive);
 
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
 			/*
 			 * A DMA error is sometimes expected. For example,
@@ -1061,9 +1015,9 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 			 * data transfer will occur, but no DMA error.
 			 * (AS, 19 Apr 2001)
 			 */
-			set_bit(PC_DMA_ERROR, &pc->flags);
+			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
-			pc->actually_transferred = pc->request_transfer;
+			pc->xferred = pc->req_xfer;
 			idetape_update_buffers(pc);
 		}
 		debug_log(DBG_PROCS, "DMA finished\n");
@@ -1073,9 +1027,9 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	/* No more interrupts */
 	if ((stat & DRQ_STAT) == 0) {
 		debug_log(DBG_SENSE, "Packet command completed, %d bytes"
-				" transferred\n", pc->actually_transferred);
+				" transferred\n", pc->xferred);
 
-		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		local_irq_enable();
 
 #if SIMULATE_ERRORS
@@ -1088,7 +1042,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 #endif
 		if ((stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
 			stat &= ~ERR_STAT;
-		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
+		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
 			/* Error detected */
 			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
 
@@ -1104,7 +1058,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 			return idetape_retry_pc(drive);
 		}
 		pc->error = 0;
-		if (test_bit(PC_WAIT_FOR_DSC, &pc->flags) &&
+		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
 		    (stat & SEEK_STAT) == 0) {
 			/* Media access command */
 			tape->dsc_polling_start = jiffies;
@@ -1117,9 +1071,11 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		if (tape->failed_pc == pc)
 			tape->failed_pc = NULL;
 		/* Command finished - Call the callback function */
-		return pc->callback(drive);
+		return pc->idetape_callback(drive);
 	}
-	if (test_and_clear_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		printk(KERN_ERR "ide-tape: The tape wants to issue more "
 				"interrupts in DMA mode\n");
 		printk(KERN_ERR "ide-tape: DMA disabled, reverting to PIO\n");
@@ -1127,16 +1083,16 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 	/* Get the number of bytes to transfer on this interrupt. */
-	bcount = (hwif->INB(IDE_BCOUNTH_REG) << 8) |
-		  hwif->INB(IDE_BCOUNTL_REG);
+	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
+		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
 
-	ireason = hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
 		return ide_do_reset(drive);
 	}
-	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
+	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "ide-tape: We wanted to %s, ",
 				(ireason & IO) ? "Write" : "Read");
@@ -1144,15 +1100,15 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
-	if (!test_bit(PC_WRITING, &pc->flags)) {
+	if (!(pc->flags & PC_FLAG_WRITING)) {
 		/* Reading - Check that we have enough space */
-		temp = pc->actually_transferred + bcount;
-		if (temp > pc->request_transfer) {
-			if (temp > pc->buffer_size) {
+		temp = pc->xferred + bcount;
+		if (temp > pc->req_xfer) {
+			if (temp > pc->buf_size) {
 				printk(KERN_ERR "ide-tape: The tape wants to "
 					"send us more data than expected "
 					"- discarding data\n");
-				idetape_discard_data(drive, bcount);
+				ide_atapi_discard_data(drive, bcount);
 				ide_set_handler(drive, &idetape_pc_intr,
 						IDETAPE_WAIT_CMD, NULL);
 				return ide_started;
@@ -1170,11 +1126,11 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	if (pc->bh)
 		iobuf(drive, pc, bcount);
 	else
-		xferfunc(drive, pc->current_position, bcount);
+		xferfunc(drive, pc->cur_pos, bcount);
 
 	/* Update the current position */
-	pc->actually_transferred += bcount;
-	pc->current_position += bcount;
+	pc->xferred += bcount;
+	pc->cur_pos += bcount;
 
 	debug_log(DBG_SENSE, "[cmd %x] transferred %d bytes on that intr.\n",
 			pc->c[0], bcount);
@@ -1224,7 +1180,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc = tape->pc;
+	struct ide_atapi_pc *pc = tape->pc;
 	int retries = 100;
 	ide_startstop_t startstop;
 	u8 ireason;
@@ -1234,12 +1190,12 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 				"yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
 		printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n");
 		udelay(100);
-		ireason = hwif->INB(IDE_IREASON_REG);
+		ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 		if (retries == 0) {
 			printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while "
 					"issuing a packet command, ignoring\n");
@@ -1256,7 +1212,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	/* Begin DMA, if necessary */
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags))
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS)
 		hwif->dma_start(drive);
 #endif
 	/* Send the actual packet */
@@ -1264,7 +1220,8 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	return ide_started;
 }
 
-static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
+static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
+		struct ide_atapi_pc *pc)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
@@ -1283,13 +1240,13 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	tape->pc = pc;
 
 	if (pc->retries > IDETAPE_MAX_PC_RETRIES ||
-	    test_bit(PC_ABORT, &pc->flags)) {
+		(pc->flags & PC_FLAG_ABORT)) {
 		/*
 		 * We will "abort" retrying a packet command in case legitimate
 		 * error code was received (crossing a filemark, or end of the
 		 * media, for example).
 		 */
-		if (!test_bit(PC_ABORT, &pc->flags)) {
+		if (!(pc->flags & PC_FLAG_ABORT)) {
 			if (!(pc->c[0] == TEST_UNIT_READY &&
 			      tape->sense_key == 2 && tape->asc == 4 &&
 			     (tape->ascq == 1 || tape->ascq == 8))) {
@@ -1304,36 +1261,38 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 			pc->error = IDETAPE_ERROR_GENERAL;
 		}
 		tape->failed_pc = NULL;
-		return pc->callback(drive);
+		return pc->idetape_callback(drive);
 	}
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
 
 	pc->retries++;
 	/* We haven't transferred any data yet */
-	pc->actually_transferred = 0;
-	pc->current_position = pc->buffer;
+	pc->xferred = 0;
+	pc->cur_pos = pc->buf;
 	/* Request to transfer the entire buffer at once */
-	bcount = pc->request_transfer;
+	bcount = pc->req_xfer;
 
-	if (test_and_clear_bit(PC_DMA_ERROR, &pc->flags)) {
+	if (pc->flags & PC_FLAG_DMA_ERROR) {
+		pc->flags &= ~PC_FLAG_DMA_ERROR;
 		printk(KERN_WARNING "ide-tape: DMA disabled, "
 				"reverting to PIO\n");
 		ide_dma_off(drive);
 	}
-	if (test_bit(PC_DMA_RECOMMENDED, &pc->flags) && drive->using_dma)
+	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
 		dma_ok = !hwif->dma_setup(drive);
 
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
 			   IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
 
-	if (dma_ok)			/* Will begin DMA later */
-		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
-	if (test_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags)) {
+	if (dma_ok)
+		/* Will begin DMA later */
+		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
+	if (test_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags)) {
 		ide_execute_command(drive, WIN_PACKETCMD, &idetape_transfer_pc,
 				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
 	} else {
-		hwif->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
 		return idetape_transfer_pc(drive);
 	}
 }
@@ -1349,7 +1308,7 @@ static ide_startstop_t idetape_pc_callback(ide_drive_t *drive)
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
-static void idetape_create_mode_sense_cmd(idetape_pc_t *pc, u8 page_code)
+static void idetape_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = MODE_SENSE;
@@ -1368,12 +1327,12 @@ static void idetape_create_mode_sense_cmd(idetape_pc_t *pc, u8 page_code)
 	/* We will just discard data in that case */
 	pc->c[4] = 255;
 	if (page_code == IDETAPE_BLOCK_DESCRIPTOR)
-		pc->request_transfer = 12;
+		pc->req_xfer = 12;
 	else if (page_code == IDETAPE_CAPABILITIES_PAGE)
-		pc->request_transfer = 24;
+		pc->req_xfer = 24;
 	else
-		pc->request_transfer = 50;
-	pc->callback = &idetape_pc_callback;
+		pc->req_xfer = 50;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static void idetape_calculate_speeds(ide_drive_t *drive)
@@ -1442,7 +1401,7 @@ static void idetape_calculate_speeds(ide_drive_t *drive)
 static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc = tape->pc;
+	struct ide_atapi_pc *pc = tape->pc;
 	u8 stat;
 
 	stat = ide_read_status(drive);
@@ -1463,14 +1422,14 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 		pc->error = IDETAPE_ERROR_GENERAL;
 		tape->failed_pc = NULL;
 	}
-	return pc->callback(drive);
+	return pc->idetape_callback(drive);
 }
 
 static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
-	int blocks = tape->pc->actually_transferred / tape->blk_size;
+	int blocks = tape->pc->xferred / tape->blk_size;
 
 	tape->avg_size += blocks * tape->blk_size;
 	tape->insert_size += blocks * tape->blk_size;
@@ -1502,47 +1461,49 @@ static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+static void idetape_create_read_cmd(idetape_tape_t *tape,
+		struct ide_atapi_pc *pc,
 		unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_6;
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
-	pc->callback = &idetape_rw_callback;
+	pc->idetape_callback = &idetape_rw_callback;
 	pc->bh = bh;
 	atomic_set(&bh->b_count, 0);
-	pc->buffer = NULL;
-	pc->buffer_size = length * tape->blk_size;
-	pc->request_transfer = pc->buffer_size;
-	if (pc->request_transfer == tape->stage_size)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+	pc->buf = NULL;
+	pc->buf_size = length * tape->blk_size;
+	pc->req_xfer = pc->buf_size;
+	if (pc->req_xfer == tape->stage_size)
+		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
-static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+static void idetape_create_write_cmd(idetape_tape_t *tape,
+		struct ide_atapi_pc *pc,
 		unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_6;
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
-	pc->callback = &idetape_rw_callback;
-	set_bit(PC_WRITING, &pc->flags);
+	pc->idetape_callback = &idetape_rw_callback;
+	pc->flags |= PC_FLAG_WRITING;
 	pc->bh = bh;
 	pc->b_data = bh->b_data;
 	pc->b_count = atomic_read(&bh->b_count);
-	pc->buffer = NULL;
-	pc->buffer_size = length * tape->blk_size;
-	pc->request_transfer = pc->buffer_size;
-	if (pc->request_transfer == tape->stage_size)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+	pc->buf = NULL;
+	pc->buf_size = length * tape->blk_size;
+	pc->req_xfer = pc->buf_size;
+	if (pc->req_xfer == tape->stage_size)
+		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 					  struct request *rq, sector_t block)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc = NULL;
+	struct ide_atapi_pc *pc = NULL;
 	struct request *postponed_rq = tape->postponed_rq;
 	u8 stat;
 
@@ -1579,10 +1540,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	stat = ide_read_status(drive);
 
 	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
-		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
 
 	if (drive->post_reset == 1) {
-		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
 		drive->post_reset = 0;
 	}
 
@@ -1590,7 +1551,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		tape->insert_speed = tape->insert_size / 1024 * HZ /
 					(jiffies - tape->insert_time);
 	idetape_calculate_speeds(drive);
-	if (!test_and_clear_bit(IDETAPE_IGNORE_DSC, &tape->flags) &&
+	if (!test_and_clear_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
@@ -1629,7 +1590,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
-		pc = (idetape_pc_t *) rq->buffer;
+		pc = (struct ide_atapi_pc *) rq->buffer;
 		rq->cmd[0] &= ~(REQ_IDETAPE_PC1);
 		rq->cmd[0] |= REQ_IDETAPE_PC2;
 		goto out;
@@ -1648,7 +1609,7 @@ static inline int idetape_pipeline_active(idetape_tape_t *tape)
 {
 	int rc1, rc2;
 
-	rc1 = test_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+	rc1 = test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
 	rc2 = (tape->active_data_rq != NULL);
 	return rc1;
 }
@@ -1881,7 +1842,7 @@ static void idetape_wait_for_request(ide_drive_t *drive, struct request *rq)
 static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	u8 *readpos = tape->pc->buffer;
+	u8 *readpos = tape->pc->buf;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
@@ -1894,7 +1855,7 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 		if (readpos[0] & 0x4) {
 			printk(KERN_INFO "ide-tape: Block location is unknown"
 					 "to the tape\n");
-			clear_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
+			clear_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 0, 0);
 		} else {
 			debug_log(DBG_SENSE, "Block Location - %u\n",
@@ -1903,7 +1864,7 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 			tape->partition = readpos[1];
 			tape->first_frame =
 				be32_to_cpu(*(u32 *)&readpos[4]);
-			set_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
+			set_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 1, 0);
 		}
 	} else {
@@ -1917,20 +1878,20 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
  * writing a filemark otherwise.
  */
 static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
-		idetape_pc_t *pc, int write_filemark)
+		struct ide_atapi_pc *pc, int write_filemark)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
-	pc->callback = &idetape_pc_callback;
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
+static void idetape_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = TEST_UNIT_READY;
-	pc->callback = &idetape_pc_callback;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
 /*
@@ -1946,7 +1907,7 @@ static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
  * to the request list without waiting for it to be serviced! In that case, we
  * usually use idetape_queue_pc_head().
  */
-static int __idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
+static int __idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 	struct request rq;
@@ -1957,24 +1918,24 @@ static int __idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
 }
 
-static void idetape_create_load_unload_cmd(ide_drive_t *drive, idetape_pc_t *pc,
-		int cmd)
+static void idetape_create_load_unload_cmd(ide_drive_t *drive,
+		struct ide_atapi_pc *pc, int cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = START_STOP;
 	pc->c[4] = cmd;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
-	pc->callback = &idetape_pc_callback;
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	int load_attempted = 0;
 
 	/* Wait for the tape to become ready */
-	set_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+	set_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
 		idetape_create_test_unit_ready_cmd(&pc);
@@ -1998,14 +1959,14 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	return -EIO;
 }
 
-static int idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
+static int idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	return __idetape_queue_pc_tail(drive, pc);
 }
 
 static int idetape_flush_tape_buffers(ide_drive_t *drive)
 {
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	int rc;
 
 	idetape_create_write_filemark_cmd(drive, &pc, 0);
@@ -2016,18 +1977,18 @@ static int idetape_flush_tape_buffers(ide_drive_t *drive)
 	return 0;
 }
 
-static void idetape_create_read_position_cmd(idetape_pc_t *pc)
+static void idetape_create_read_position_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_POSITION;
-	pc->request_transfer = 20;
-	pc->callback = &idetape_read_position_callback;
+	pc->req_xfer = 20;
+	pc->idetape_callback = &idetape_read_position_callback;
 }
 
 static int idetape_read_position(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	int position;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
@@ -2039,7 +2000,8 @@ static int idetape_read_position(ide_drive_t *drive)
 	return position;
 }
 
-static void idetape_create_locate_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+static void idetape_create_locate_cmd(ide_drive_t *drive,
+		struct ide_atapi_pc *pc,
 		unsigned int block, u8 partition, int skip)
 {
 	idetape_init_pc(pc);
@@ -2047,12 +2009,12 @@ static void idetape_create_locate_cmd(ide_drive_t *drive, idetape_pc_t *pc,
 	pc->c[1] = 2;
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
 	pc->c[8] = partition;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
-	pc->callback = &idetape_pc_callback;
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static int idetape_create_prevent_cmd(ide_drive_t *drive, idetape_pc_t *pc,
-				      int prevent)
+static int idetape_create_prevent_cmd(ide_drive_t *drive,
+		struct ide_atapi_pc *pc, int prevent)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -2063,7 +2025,7 @@ static int idetape_create_prevent_cmd(ide_drive_t *drive, idetape_pc_t *pc,
 	idetape_init_pc(pc);
 	pc->c[0] = ALLOW_MEDIUM_REMOVAL;
 	pc->c[4] = prevent;
-	pc->callback = &idetape_pc_callback;
+	pc->idetape_callback = &idetape_pc_callback;
 	return 1;
 }
 
@@ -2078,7 +2040,7 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 
 	/* Remove merge stage. */
 	cnt = tape->merge_stage_size / tape->blk_size;
-	if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
+	if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 		++cnt;		/* Filemarks count as 1 sector */
 	tape->merge_stage_size = 0;
 	if (tape->merge_stage != NULL) {
@@ -2087,7 +2049,7 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 	}
 
 	/* Clear pipeline flags. */
-	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+	clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/* Remove pipeline stages. */
@@ -2124,7 +2086,7 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int retval;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ)
 		__idetape_discard_read_pipeline(drive);
@@ -2201,46 +2163,47 @@ static void idetape_plug_pipeline(ide_drive_t *drive)
 	if (tape->next_stage == NULL)
 		return;
 	if (!idetape_pipeline_active(tape)) {
-		set_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+		set_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
 		idetape_activate_next_stage(drive);
 		(void) ide_do_drive_cmd(drive, tape->active_data_rq, ide_end);
 	}
 }
 
-static void idetape_create_inquiry_cmd(idetape_pc_t *pc)
+static void idetape_create_inquiry_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = INQUIRY;
 	pc->c[4] = 254;
-	pc->request_transfer = 254;
-	pc->callback = &idetape_pc_callback;
+	pc->req_xfer = 254;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_create_rewind_cmd(ide_drive_t *drive, idetape_pc_t *pc)
+static void idetape_create_rewind_cmd(ide_drive_t *drive,
+		struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
-	pc->callback = &idetape_pc_callback;
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_create_erase_cmd(idetape_pc_t *pc)
+static void idetape_create_erase_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = ERASE;
 	pc->c[1] = 1;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
-	pc->callback = &idetape_pc_callback;
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_create_space_cmd(idetape_pc_t *pc, int count, u8 cmd)
+static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = SPACE;
 	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
-	pc->callback = &idetape_pc_callback;
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static void idetape_wait_first_stage(ide_drive_t *drive)
@@ -2326,7 +2289,7 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 			idetape_plug_pipeline(drive);
 		}
 	}
-	if (test_and_clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
+	if (test_and_clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
 		/* Return a deferred error */
 		return -EIO;
 	return blocks;
@@ -2402,7 +2365,7 @@ static void idetape_empty_write_pipeline(ide_drive_t *drive)
 		__idetape_kfree_stage(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
-	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+	clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/*
@@ -2490,7 +2453,7 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 	rq.sector = tape->first_frame;
 	rq.nr_sectors = blocks;
 	rq.current_nr_sectors = blocks;
-	if (!test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags) &&
+	if (!test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags) &&
 	    tape->nr_stages < max_stages) {
 		new_stage = idetape_kmalloc_stage(tape);
 		while (new_stage != NULL) {
@@ -2527,13 +2490,13 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
 	/* If we are at a filemark, return a read length of 0 */
-	if (test_bit(IDETAPE_FILEMARK, &tape->flags))
+	if (test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 		return 0;
 
 	/* Wait for the next block to reach the head of the pipeline. */
 	idetape_init_read(drive, tape->max_stages);
 	if (tape->first_stage == NULL) {
-		if (test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
+		if (test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
 			return 0;
 		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
 					tape->merge_stage->bh);
@@ -2550,7 +2513,7 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	else {
 		idetape_switch_buffers(tape, tape->first_stage);
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
-			set_bit(IDETAPE_FILEMARK, &tape->flags);
+			set_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
 		spin_lock_irqsave(&tape->lock, flags);
 		idetape_remove_stage_head(drive);
 		spin_unlock_irqrestore(&tape->lock, flags);
@@ -2618,7 +2581,7 @@ static int idetape_pipeline_size(ide_drive_t *drive)
 static int idetape_rewind_tape(ide_drive_t *drive)
 {
 	int retval;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	idetape_tape_t *tape;
 	tape = drive->driver_data;
 
@@ -2681,7 +2644,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 					int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	unsigned long flags;
 	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
@@ -2697,12 +2660,13 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		/* its a read-ahead buffer, scan it for crossed filemarks. */
 		tape->merge_stage_size = 0;
-		if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
+		if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 			++count;
 		while (tape->first_stage != NULL) {
 			if (count == mt_count) {
 				if (mt_op == MTFSFM)
-					set_bit(IDETAPE_FILEMARK, &tape->flags);
+					set_bit(IDETAPE_FLAG_FILEMARK,
+						&tape->flags);
 				return 0;
 			}
 			spin_lock_irqsave(&tape->lock, flags);
@@ -2786,7 +2750,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
+		if (test_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags))
 			if (count > tape->blk_size &&
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
@@ -2829,7 +2793,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		tape->merge_stage_size = bytes_read-temp;
 	}
 finish:
-	if (!actually_read && test_bit(IDETAPE_FILEMARK, &tape->flags)) {
+	if (!actually_read && test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags)) {
 		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
 
 		idetape_space_over_filemarks(drive, MTFSF, 1);
@@ -2938,7 +2902,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 
 static int idetape_write_filemark(ide_drive_t *drive)
 {
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	/* Write a filemark */
 	idetape_create_write_filemark_cmd(drive, &pc, 1);
@@ -2966,7 +2930,7 @@ static int idetape_write_filemark(ide_drive_t *drive)
 static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	int i, retval;
 
 	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
@@ -3022,7 +2986,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 					      !IDETAPE_LU_LOAD_MASK);
 		retval = idetape_queue_pc_tail(drive, &pc);
 		if (!retval)
-			clear_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+			clear_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
 		return retval;
 	case MTNOP:
 		idetape_discard_read_pipeline(drive, 0);
@@ -3045,9 +3009,9 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			    mt_count % tape->blk_size)
 				return -EIO;
 			tape->user_bs_factor = mt_count / tape->blk_size;
-			clear_bit(IDETAPE_DETECT_BS, &tape->flags);
+			clear_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
 		} else
-			set_bit(IDETAPE_DETECT_BS, &tape->flags);
+			set_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
 		return 0;
 	case MTSEEK:
 		idetape_discard_read_pipeline(drive, 0);
@@ -3149,7 +3113,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
 	if (idetape_queue_pc_tail(drive, &pc)) {
@@ -3161,10 +3125,10 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 		}
 		return;
 	}
-	tape->blk_size = (pc.buffer[4 + 5] << 16) +
-				(pc.buffer[4 + 6] << 8)  +
-				 pc.buffer[4 + 7];
-	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
+	tape->blk_size = (pc.buf[4 + 5] << 16) +
+				(pc.buf[4 + 6] << 8)  +
+				 pc.buf[4 + 7];
+	tape->drv_write_prot = (pc.buf[2] & 0x80) >> 7;
 }
 
 static int idetape_chrdev_open(struct inode *inode, struct file *filp)
@@ -3172,7 +3136,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	unsigned int minor = iminor(inode), i = minor & ~0xc0;
 	ide_drive_t *drive;
 	idetape_tape_t *tape;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	int retval;
 
 	if (i >= MAX_HWIFS * MAX_DRIVES)
@@ -3195,24 +3159,24 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = tape;
 
-	if (test_and_set_bit(IDETAPE_BUSY, &tape->flags)) {
+	if (test_and_set_bit(IDETAPE_FLAG_BUSY, &tape->flags)) {
 		retval = -EBUSY;
 		goto out_put_tape;
 	}
 
 	retval = idetape_wait_ready(drive, 60 * HZ);
 	if (retval) {
-		clear_bit(IDETAPE_BUSY, &tape->flags);
+		clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
 		printk(KERN_ERR "ide-tape: %s: drive not ready\n", tape->name);
 		goto out_put_tape;
 	}
 
 	idetape_read_position(drive);
-	if (!test_bit(IDETAPE_ADDRESS_VALID, &tape->flags))
+	if (!test_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags))
 		(void)idetape_rewind_tape(drive);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ)
-		clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+		clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
 
 	/* Read block size and write protect status from drive. */
 	ide_tape_get_bsize_from_bdesc(drive);
@@ -3227,7 +3191,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	if (tape->write_prot) {
 		if ((filp->f_flags & O_ACCMODE) == O_WRONLY ||
 		    (filp->f_flags & O_ACCMODE) == O_RDWR) {
-			clear_bit(IDETAPE_BUSY, &tape->flags);
+			clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
 			retval = -EROFS;
 			goto out_put_tape;
 		}
@@ -3272,7 +3236,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 {
 	struct ide_tape_obj *tape = ide_tape_f(filp);
 	ide_drive_t *drive = tape->drive;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	unsigned int minor = iminor(inode);
 
 	lock_kernel();
@@ -3292,7 +3256,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 		__idetape_kfree_stage(tape->cache_stage);
 		tape->cache_stage = NULL;
 	}
-	if (minor < 128 && test_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags))
+	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
@@ -3302,7 +3266,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 			}
 		}
 	}
-	clear_bit(IDETAPE_BUSY, &tape->flags);
+	clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
 	ide_tape_put(tape);
 	unlock_kernel();
 	return 0;
@@ -3350,7 +3314,7 @@ static int idetape_identify_device(ide_drive_t *drive)
 static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	char fw_rev[6], vendor_id[10], product_id[18];
 
 	idetape_create_inquiry_cmd(&pc);
@@ -3359,9 +3323,9 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 				tape->name);
 		return;
 	}
-	memcpy(vendor_id, &pc.buffer[8], 8);
-	memcpy(product_id, &pc.buffer[16], 16);
-	memcpy(fw_rev, &pc.buffer[32], 4);
+	memcpy(vendor_id, &pc.buf[8], 8);
+	memcpy(product_id, &pc.buf[16], 16);
+	memcpy(fw_rev, &pc.buf[32], 4);
 
 	ide_fixstring(vendor_id, 10, 0);
 	ide_fixstring(product_id, 18, 0);
@@ -3378,7 +3342,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 static void idetape_get_mode_sense_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	u8 *caps;
 	u8 speed, max_speed;
 
@@ -3392,7 +3356,7 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 		put_unaligned(6*52, (u16 *)&tape->caps[16]);
 		return;
 	}
-	caps = pc.buffer + 4 + pc.buffer[3];
+	caps = pc.buf + 4 + pc.buf[3];
 
 	/* convert to host order and save for later use */
 	speed = be16_to_cpu(*(u16 *)&caps[14]);
@@ -3506,7 +3470,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 
 	/* Command packet DRQ type */
 	if (((gcw[0] & 0x60) >> 5) == 1)
-		set_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags);
+		set_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags);
 
 	tape->min_pipeline = 10;
 	tape->max_pipeline = 10;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 4c86a8d..155cc90 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -59,32 +59,34 @@ void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 		SELECT_MASK(drive, 0);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
-		hwif->OUTW((tf->hob_data << 8) | tf->data, IDE_DATA_REG);
+		hwif->OUTW((tf->hob_data << 8) | tf->data,
+			   hwif->io_ports[IDE_DATA_OFFSET]);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		hwif->OUTB(tf->hob_feature, IDE_FEATURE_REG);
+		hwif->OUTB(tf->hob_feature, hwif->io_ports[IDE_FEATURE_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		hwif->OUTB(tf->hob_nsect, IDE_NSECTOR_REG);
+		hwif->OUTB(tf->hob_nsect, hwif->io_ports[IDE_NSECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		hwif->OUTB(tf->hob_lbal, IDE_SECTOR_REG);
+		hwif->OUTB(tf->hob_lbal, hwif->io_ports[IDE_SECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		hwif->OUTB(tf->hob_lbam, IDE_LCYL_REG);
+		hwif->OUTB(tf->hob_lbam, hwif->io_ports[IDE_LCYL_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		hwif->OUTB(tf->hob_lbah, IDE_HCYL_REG);
+		hwif->OUTB(tf->hob_lbah, hwif->io_ports[IDE_HCYL_OFFSET]);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		hwif->OUTB(tf->feature, IDE_FEATURE_REG);
+		hwif->OUTB(tf->feature, hwif->io_ports[IDE_FEATURE_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		hwif->OUTB(tf->nsect, IDE_NSECTOR_REG);
+		hwif->OUTB(tf->nsect, hwif->io_ports[IDE_NSECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		hwif->OUTB(tf->lbal, IDE_SECTOR_REG);
+		hwif->OUTB(tf->lbal, hwif->io_ports[IDE_SECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		hwif->OUTB(tf->lbam, IDE_LCYL_REG);
+		hwif->OUTB(tf->lbam, hwif->io_ports[IDE_LCYL_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		hwif->OUTB(tf->lbah, IDE_HCYL_REG);
+		hwif->OUTB(tf->lbah, hwif->io_ports[IDE_HCYL_OFFSET]);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		hwif->OUTB((tf->device & HIHI) | drive->select.all, IDE_SELECT_REG);
+		hwif->OUTB((tf->device & HIHI) | drive->select.all,
+			   hwif->io_ports[IDE_SELECT_OFFSET]);
 }
 
 int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
@@ -152,7 +154,8 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
 	case TASKFILE_OUT:
-		hwif->OUTBSYNC(drive, tf->command, IDE_COMMAND_REG);
+		hwif->OUTBSYNC(drive, tf->command,
+			       hwif->io_ports[IDE_COMMAND_OFFSET]);
 		ndelay(400);	/* FIXME */
 		return pre_task_out_intr(drive, task->rq);
 	case TASKFILE_MULTI_IN:
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index fc69fe2..917c72d 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -78,6 +78,8 @@
 /* default maximum number of failures */
 #define IDE_DEFAULT_MAX_FAILURES 	1
 
+struct class *ide_port_class;
+
 static const u8 ide_hwif_to_major[] = { IDE0_MAJOR, IDE1_MAJOR,
 					IDE2_MAJOR, IDE3_MAJOR,
 					IDE4_MAJOR, IDE5_MAJOR,
@@ -90,10 +92,6 @@ static int system_bus_speed;	/* holds what we think is VESA/PCI bus speed */
 DEFINE_MUTEX(ide_cfg_mtx);
  __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 
-#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
-int ide_scan_direction; /* THIS was formerly 2.2.x pci=reverse */
-#endif
-
 int noautodma = 0;
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
@@ -109,13 +107,13 @@ ide_hwif_t ide_hwifs[MAX_HWIFS];	/* master data repository */
 
 EXPORT_SYMBOL(ide_hwifs);
 
+static void ide_port_init_devices_data(ide_hwif_t *);
+
 /*
  * Do not even *think* about calling this!
  */
 void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 {
-	unsigned int unit;
-
 	/* bulk initialize hwif & drive info with zeros */
 	memset(hwif, 0, sizeof(ide_hwif_t));
 
@@ -134,8 +132,20 @@ void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 
 	default_hwif_iops(hwif);
 	default_hwif_transport(hwif);
+
+	ide_port_init_devices_data(hwif);
+}
+EXPORT_SYMBOL_GPL(ide_init_port_data);
+
+static void ide_port_init_devices_data(ide_hwif_t *hwif)
+{
+	int unit;
+
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
+		u8 j = (hwif->index * MAX_DRIVES) + unit;
+
+		memset(drive, 0, sizeof(*drive));
 
 		drive->media			= ide_disk;
 		drive->select.all		= (unit<<4)|0xa0;
@@ -147,32 +157,13 @@ void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 		drive->special.b.set_geometry	= 1;
 		drive->name[0]			= 'h';
 		drive->name[1]			= 'd';
-		drive->name[2]			= 'a' + (index * MAX_DRIVES) + unit;
+		drive->name[2]			= 'a' + j;
 		drive->max_failures		= IDE_DEFAULT_MAX_FAILURES;
-		drive->using_dma		= 0;
-		drive->vdma			= 0;
+
 		INIT_LIST_HEAD(&drive->list);
 		init_completion(&drive->gendev_rel_comp);
 	}
 }
-EXPORT_SYMBOL_GPL(ide_init_port_data);
-
-static void init_hwif_default(ide_hwif_t *hwif, unsigned int index)
-{
-	hw_regs_t hw;
-
-	memset(&hw, 0, sizeof(hw_regs_t));
-
-	ide_init_hwif_ports(&hw, ide_default_io_base(index), 0, &hwif->irq);
-
-	memcpy(hwif->io_ports, hw.io_ports, sizeof(hw.io_ports));
-
-	hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET];
-#ifdef CONFIG_BLK_DEV_HD
-	if (hwif->io_ports[IDE_DATA_OFFSET] == HD_DATA)
-		hwif->noprobe = 1;	/* may be overridden by ide_setup() */
-#endif
-}
 
 /*
  * init_ide_data() sets reasonable default values into all fields
@@ -194,7 +185,6 @@ static void init_hwif_default(ide_hwif_t *hwif, unsigned int index)
 #define MAGIC_COOKIE 0x12345678
 static void __init init_ide_data (void)
 {
-	ide_hwif_t *hwif;
 	unsigned int index;
 	static unsigned long magic_cookie = MAGIC_COOKIE;
 
@@ -204,13 +194,9 @@ static void __init init_ide_data (void)
 
 	/* Initialise all interface structures */
 	for (index = 0; index < MAX_HWIFS; ++index) {
-		hwif = &ide_hwifs[index];
+		ide_hwif_t *hwif = &ide_hwifs[index];
+
 		ide_init_port_data(hwif, index);
-		init_hwif_default(hwif, index);
-#if !defined(CONFIG_PPC32) || !defined(CONFIG_PCI)
-		hwif->irq =
-			ide_init_default_irq(hwif->io_ports[IDE_DATA_OFFSET]);
-#endif
 	}
 }
 
@@ -259,7 +245,7 @@ ide_hwif_t * ide_find_port(unsigned long base)
 
 	for (i = 0; i < MAX_HWIFS; i++) {
 		hwif = &ide_hwifs[i];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == 0)
+		if (hwif->chipset == ide_unknown)
 			goto found;
 	}
 
@@ -357,108 +343,6 @@ void ide_hwif_release_regions(ide_hwif_t *hwif)
 			release_region(hwif->io_ports[i], 1);
 }
 
-/**
- *	ide_hwif_restore	-	restore hwif to template
- *	@hwif: hwif to update
- *	@tmp_hwif: template
- *
- *	Restore hwif to a previous state by copying most settings
- *	from the template.
- */
-
-static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
-{
-	hwif->hwgroup			= tmp_hwif->hwgroup;
-
-	hwif->gendev.parent		= tmp_hwif->gendev.parent;
-
-	hwif->proc			= tmp_hwif->proc;
-
-	hwif->major			= tmp_hwif->major;
-	hwif->straight8			= tmp_hwif->straight8;
-	hwif->bus_state			= tmp_hwif->bus_state;
-
-	hwif->host_flags		= tmp_hwif->host_flags;
-
-	hwif->pio_mask			= tmp_hwif->pio_mask;
-
-	hwif->ultra_mask		= tmp_hwif->ultra_mask;
-	hwif->mwdma_mask		= tmp_hwif->mwdma_mask;
-	hwif->swdma_mask		= tmp_hwif->swdma_mask;
-
-	hwif->cbl			= tmp_hwif->cbl;
-
-	hwif->chipset			= tmp_hwif->chipset;
-	hwif->hold			= tmp_hwif->hold;
-
-	hwif->dev			= tmp_hwif->dev;
-
-#ifdef CONFIG_BLK_DEV_IDEPCI
-	hwif->cds			= tmp_hwif->cds;
-#endif
-
-	hwif->set_pio_mode		= tmp_hwif->set_pio_mode;
-	hwif->set_dma_mode		= tmp_hwif->set_dma_mode;
-	hwif->mdma_filter		= tmp_hwif->mdma_filter;
-	hwif->udma_filter		= tmp_hwif->udma_filter;
-	hwif->selectproc		= tmp_hwif->selectproc;
-	hwif->reset_poll		= tmp_hwif->reset_poll;
-	hwif->pre_reset			= tmp_hwif->pre_reset;
-	hwif->resetproc			= tmp_hwif->resetproc;
-	hwif->maskproc			= tmp_hwif->maskproc;
-	hwif->quirkproc			= tmp_hwif->quirkproc;
-	hwif->busproc			= tmp_hwif->busproc;
-
-	hwif->ata_input_data		= tmp_hwif->ata_input_data;
-	hwif->ata_output_data		= tmp_hwif->ata_output_data;
-	hwif->atapi_input_bytes		= tmp_hwif->atapi_input_bytes;
-	hwif->atapi_output_bytes	= tmp_hwif->atapi_output_bytes;
-
-	hwif->dma_host_set		= tmp_hwif->dma_host_set;
-	hwif->dma_setup			= tmp_hwif->dma_setup;
-	hwif->dma_exec_cmd		= tmp_hwif->dma_exec_cmd;
-	hwif->dma_start			= tmp_hwif->dma_start;
-	hwif->ide_dma_end		= tmp_hwif->ide_dma_end;
-	hwif->ide_dma_test_irq		= tmp_hwif->ide_dma_test_irq;
-	hwif->ide_dma_clear_irq		= tmp_hwif->ide_dma_clear_irq;
-	hwif->dma_lost_irq		= tmp_hwif->dma_lost_irq;
-	hwif->dma_timeout		= tmp_hwif->dma_timeout;
-
-	hwif->OUTB			= tmp_hwif->OUTB;
-	hwif->OUTBSYNC			= tmp_hwif->OUTBSYNC;
-	hwif->OUTW			= tmp_hwif->OUTW;
-	hwif->OUTSW			= tmp_hwif->OUTSW;
-	hwif->OUTSL			= tmp_hwif->OUTSL;
-
-	hwif->INB			= tmp_hwif->INB;
-	hwif->INW			= tmp_hwif->INW;
-	hwif->INSW			= tmp_hwif->INSW;
-	hwif->INSL			= tmp_hwif->INSL;
-
-	hwif->sg_max_nents		= tmp_hwif->sg_max_nents;
-
-	hwif->mmio			= tmp_hwif->mmio;
-	hwif->rqsize			= tmp_hwif->rqsize;
-
-#ifndef CONFIG_BLK_DEV_IDECS
-	hwif->irq			= tmp_hwif->irq;
-#endif
-
-	hwif->dma_base			= tmp_hwif->dma_base;
-	hwif->dma_command		= tmp_hwif->dma_command;
-	hwif->dma_vendor1		= tmp_hwif->dma_vendor1;
-	hwif->dma_status		= tmp_hwif->dma_status;
-	hwif->dma_vendor3		= tmp_hwif->dma_vendor3;
-	hwif->dma_prdtable		= tmp_hwif->dma_prdtable;
-
-	hwif->config_data		= tmp_hwif->config_data;
-	hwif->select_data		= tmp_hwif->select_data;
-	hwif->extra_base		= tmp_hwif->extra_base;
-	hwif->extra_ports		= tmp_hwif->extra_ports;
-
-	hwif->hwif_data			= tmp_hwif->hwif_data;
-}
-
 void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 {
 	ide_hwgroup_t *hwgroup = hwif->hwgroup;
@@ -494,11 +378,38 @@ void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 	spin_unlock_irq(&ide_lock);
 }
 
+/* Called with ide_lock held. */
+static void __ide_port_unregister_devices(ide_hwif_t *hwif)
+{
+	int i;
+
+	for (i = 0; i < MAX_DRIVES; i++) {
+		ide_drive_t *drive = &hwif->drives[i];
+
+		if (drive->present) {
+			spin_unlock_irq(&ide_lock);
+			device_unregister(&drive->gendev);
+			wait_for_completion(&drive->gendev_rel_comp);
+			spin_lock_irq(&ide_lock);
+		}
+	}
+}
+
+void ide_port_unregister_devices(ide_hwif_t *hwif)
+{
+	mutex_lock(&ide_cfg_mtx);
+	spin_lock_irq(&ide_lock);
+	__ide_port_unregister_devices(hwif);
+	hwif->present = 0;
+	ide_port_init_devices_data(hwif);
+	spin_unlock_irq(&ide_lock);
+	mutex_unlock(&ide_cfg_mtx);
+}
+EXPORT_SYMBOL_GPL(ide_port_unregister_devices);
+
 /**
  *	ide_unregister		-	free an IDE interface
  *	@index: index of interface (will change soon to a pointer)
- *	@init_default: init default hwif flag
- *	@restore: restore hwif flag
  *
  *	Perform the final unregister of an IDE interface. At the moment
  *	we don't refcount interfaces so this will also get split up.
@@ -518,13 +429,11 @@ void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
  *	This is raving bonkers.
  */
 
-void ide_unregister(unsigned int index, int init_default, int restore)
+void ide_unregister(unsigned int index)
 {
-	ide_drive_t *drive;
 	ide_hwif_t *hwif, *g;
-	static ide_hwif_t tmp_hwif; /* protected by ide_cfg_mtx */
 	ide_hwgroup_t *hwgroup;
-	int irq_count = 0, unit;
+	int irq_count = 0;
 
 	BUG_ON(index >= MAX_HWIFS);
 
@@ -535,15 +444,7 @@ void ide_unregister(unsigned int index, int init_default, int restore)
 	hwif = &ide_hwifs[index];
 	if (!hwif->present)
 		goto abort;
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		drive = &hwif->drives[unit];
-		if (!drive->present)
-			continue;
-		spin_unlock_irq(&ide_lock);
-		device_unregister(&drive->gendev);
-		wait_for_completion(&drive->gendev_rel_comp);
-		spin_lock_irq(&ide_lock);
-	}
+	__ide_port_unregister_devices(hwif);
 	hwif->present = 0;
 
 	spin_unlock_irq(&ide_lock);
@@ -565,6 +466,7 @@ void ide_unregister(unsigned int index, int init_default, int restore)
 
 	ide_remove_port_from_hwgroup(hwif);
 
+	device_unregister(hwif->portdev);
 	device_unregister(&hwif->gendev);
 	wait_for_completion(&hwif->gendev_rel_comp);
 
@@ -576,34 +478,14 @@ void ide_unregister(unsigned int index, int init_default, int restore)
 	unregister_blkdev(hwif->major, hwif->name);
 	spin_lock_irq(&ide_lock);
 
-	if (hwif->dma_base) {
-		(void) ide_release_dma(hwif);
-
-		hwif->dma_base = 0;
-		hwif->dma_command = 0;
-		hwif->dma_vendor1 = 0;
-		hwif->dma_status = 0;
-		hwif->dma_vendor3 = 0;
-		hwif->dma_prdtable = 0;
-
-		hwif->extra_base  = 0;
-		hwif->extra_ports = 0;
-	}
+	if (hwif->dma_base)
+		(void)ide_release_dma(hwif);
 
 	ide_hwif_release_regions(hwif);
 
-	/* copy original settings */
-	tmp_hwif = *hwif;
-
 	/* restore hwif data to pristine status */
 	ide_init_port_data(hwif, index);
 
-	if (init_default)
-		init_hwif_default(hwif, index);
-
-	if (restore)
-		ide_hwif_restore(hwif, &tmp_hwif);
-
 abort:
 	spin_unlock_irq(&ide_lock);
 	mutex_unlock(&ide_cfg_mtx);
@@ -622,79 +504,6 @@ void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 }
 EXPORT_SYMBOL_GPL(ide_init_port_hw);
 
-ide_hwif_t *ide_deprecated_find_port(unsigned long base)
-{
-	ide_hwif_t *hwif;
-	int i;
-
-	for (i = 0; i < MAX_HWIFS; i++) {
-		hwif = &ide_hwifs[i];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == base)
-			goto found;
-	}
-
-	for (i = 0; i < MAX_HWIFS; i++) {
-		hwif = &ide_hwifs[i];
-		if (hwif->hold)
-			continue;
-		if (!hwif->present && hwif->mate == NULL)
-			goto found;
-	}
-
-	hwif = NULL;
-found:
-	return hwif;
-}
-EXPORT_SYMBOL_GPL(ide_deprecated_find_port);
-
-/**
- *	ide_register_hw		-	register IDE interface
- *	@hw: hardware registers
- *	@quirkproc: quirkproc function
- *	@hwifp: pointer to returned hwif
- *
- *	Register an IDE interface, specifying exactly the registers etc.
- *
- *	Returns -1 on error.
- */
-
-int ide_register_hw(hw_regs_t *hw, void (*quirkproc)(ide_drive_t *),
-		    ide_hwif_t **hwifp)
-{
-	int index, retry = 1;
-	ide_hwif_t *hwif;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-
-	do {
-		hwif = ide_deprecated_find_port(hw->io_ports[IDE_DATA_OFFSET]);
-		if (hwif)
-			goto found;
-		for (index = 0; index < MAX_HWIFS; index++)
-			ide_unregister(index, 1, 1);
-	} while (retry--);
-	return -1;
-found:
-	index = hwif->index;
-	if (hwif->present)
-		ide_unregister(index, 0, 1);
-	else if (!hwif->hold)
-		ide_init_port_data(hwif, index);
-
-	ide_init_port_hw(hwif, hw);
-	hwif->quirkproc = quirkproc;
-
-	idx[0] = index;
-
-	ide_device_add(idx, NULL);
-
-	if (hwifp)
-		*hwifp = hwif;
-
-	return hwif->present ? index : -1;
-}
-
-EXPORT_SYMBOL(ide_register_hw);
-
 /*
  *	Locks for IDE setting functionality
  */
@@ -997,27 +806,6 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 			if (!capable(CAP_SYS_RAWIO))
 				return -EACCES;
 			return ide_task_ioctl(drive, cmd, arg);
-
-		case HDIO_SCAN_HWIF:
-		{
-			hw_regs_t hw;
-			int args[3];
-			if (!capable(CAP_SYS_RAWIO)) return -EACCES;
-			if (copy_from_user(args, p, 3 * sizeof(int)))
-				return -EFAULT;
-			memset(&hw, 0, sizeof(hw));
-			ide_init_hwif_ports(&hw, (unsigned long) args[0],
-					    (unsigned long) args[1], NULL);
-			hw.irq = args[2];
-			if (ide_register_hw(&hw, NULL, NULL) == -1)
-				return -EIO;
-			return 0;
-		}
-	        case HDIO_UNREGISTER_HWIF:
-			if (!capable(CAP_SYS_RAWIO)) return -EACCES;
-			/* (arg > MAX_HWIFS) checked in function */
-			ide_unregister(arg, 1, 1);
-			return 0;
 		case HDIO_SET_NICE:
 			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
 			if (arg != (arg & ((1 << IDE_NICE_DSC_OVERLAP) | (1 << IDE_NICE_1))))
@@ -1071,8 +859,6 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 		case HDIO_SET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
-			if (HWIF(drive)->busproc)
-				return HWIF(drive)->busproc(drive, (int)arg);
 			return -EOPNOTSUPP;
 		default:
 			return -EINVAL;
@@ -1173,8 +959,9 @@ extern int probe_dtc2278;
 extern int probe_ht6560b;
 extern int probe_qd65xx;
 extern int cmd640_vlb;
+extern int probe_4drives;
 
-static int __initdata is_chipset_set[MAX_HWIFS];
+static int __initdata is_chipset_set;
 
 /*
  * ide_setup() gets called VERY EARLY during initialization,
@@ -1217,14 +1004,6 @@ static int __init ide_setup(char *s)
 		goto obsolete_option;
 	}
 
-#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
-	if (!strcmp(s, "ide=reverse")) {
-		ide_scan_direction = 1;
-		printk(" : Enabled support for IDE inverse scan order.\n");
-		goto obsolete_option;
-	}
-#endif
-
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	if (!strcmp(s, "ide=noacpi")) {
 		//printk(" : Disable IDE ACPI support.\n");
@@ -1335,13 +1114,11 @@ static int __init ide_setup(char *s)
 		 * (-8, -9, -10) are reserved to ease the hardcoding.
 		 */
 		static const char *ide_words[] = {
-			"noprobe", "serialize", "minus3", "minus4",
+			"minus1", "serialize", "minus3", "minus4",
 			"reset", "minus6", "ata66", "minus8", "minus9",
 			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
 			"dtc2278", "umc8672", "ali14xx", NULL };
 
-		hw_regs_t hwregs;
-
 		hw = s[3] - '0';
 		hwif = &ide_hwifs[hw];
 		i = match_parm(&s[4], ide_words, vals, 3);
@@ -1350,19 +1127,14 @@ static int __init ide_setup(char *s)
 		 * Cryptic check to ensure chipset not already set for hwif.
 		 * Note: we can't depend on hwif->chipset here.
 		 */
-		if ((i >= -18 && i <= -11) || (i > 0 && i <= 3)) {
+		if (i >= -18 && i <= -11) {
 			/* chipset already specified */
-			if (is_chipset_set[hw])
+			if (is_chipset_set)
 				goto bad_option;
-			if (i > -18 && i <= -11) {
-				/* these drivers are for "ide0=" only */
-				if (hw != 0)
-					goto bad_hwif;
-				/* chipset already specified for 2nd port */
-				if (is_chipset_set[hw+1])
-					goto bad_option;
-			}
-			is_chipset_set[hw] = 1;
+			/* these drivers are for "ide0=" only */
+			if (hw != 0)
+				goto bad_hwif;
+			is_chipset_set = 1;
 			printk("\n");
 		}
 
@@ -1399,19 +1171,9 @@ static int __init ide_setup(char *s)
 #endif
 #ifdef CONFIG_BLK_DEV_4DRIVES
 			case -11: /* "four" drives on one set of ports */
-			{
-				ide_hwif_t *mate = &ide_hwifs[hw^1];
-				mate->drives[0].select.all ^= 0x20;
-				mate->drives[1].select.all ^= 0x20;
-				hwif->chipset = mate->chipset = ide_4drives;
-				mate->irq = hwif->irq;
-				memcpy(mate->io_ports, hwif->io_ports, sizeof(hwif->io_ports));
-				hwif->mate = mate;
-				mate->mate = hwif;
-				hwif->serialized = mate->serialized = 1;
+				probe_4drives = 1;
 				goto obsolete_option;
-			}
-#endif /* CONFIG_BLK_DEV_4DRIVES */
+#endif
 			case -10: /* minus10 */
 			case -9: /* minus9 */
 			case -8: /* minus8 */
@@ -1439,24 +1201,12 @@ static int __init ide_setup(char *s)
 				hwif->serialized = hwif->mate->serialized = 1;
 				goto obsolete_option;
 
-			case -1: /* "noprobe" */
-				hwif->noprobe = 1;
-				goto obsolete_option;
-
-			case 1:	/* base */
-				vals[1] = vals[0] + 0x206; /* default ctl */
-			case 2: /* base,ctl */
-				vals[2] = 0;	/* default irq = probe for it */
-			case 3: /* base,ctl,irq */
-				memset(&hwregs, 0, sizeof(hwregs));
-				ide_init_hwif_ports(&hwregs, vals[0], vals[1], &hwif->irq);
-				memcpy(hwif->io_ports, hwregs.io_ports, sizeof(hwif->io_ports));
-				hwif->irq      = vals[2];
-				hwif->noprobe  = 0;
-				hwif->chipset  = ide_forced;
-				goto obsolete_option;
-
-			case 0: goto bad_option;
+			case -1:
+			case 0:
+			case 1:
+			case 2:
+			case 3:
+				goto bad_option;
 			default:
 				printk(" -- SUPPORT NOT CONFIGURED IN THIS KERNEL\n");
 				return 1;
@@ -1601,6 +1351,13 @@ struct bus_type ide_bus_type = {
 
 EXPORT_SYMBOL_GPL(ide_bus_type);
 
+static void ide_port_class_release(struct device *portdev)
+{
+	ide_hwif_t *hwif = dev_get_drvdata(portdev);
+
+	put_device(&hwif->gendev);
+}
+
 /*
  * This is gets invoked once during initialization, to set *everything* up
  */
@@ -1621,11 +1378,23 @@ static int __init ide_init(void)
 		return ret;
 	}
 
+	ide_port_class = class_create(THIS_MODULE, "ide_port");
+	if (IS_ERR(ide_port_class)) {
+		ret = PTR_ERR(ide_port_class);
+		goto out_port_class;
+	}
+	ide_port_class->dev_release = ide_port_class_release;
+
 	init_ide_data();
 
 	proc_ide_create();
 
 	return 0;
+
+out_port_class:
+	bus_unregister(&ide_bus_type);
+
+	return ret;
 }
 
 #ifdef MODULE
@@ -1658,10 +1427,12 @@ void __exit cleanup_module (void)
 	int index;
 
 	for (index = 0; index < MAX_HWIFS; ++index)
-		ide_unregister(index, 0, 0);
+		ide_unregister(index);
 
 	proc_ide_destroy();
 
+	class_destroy(ide_port_class);
+
 	bus_unregister(&ide_bus_type);
 }
 
diff --git a/drivers/ide/legacy/Makefile b/drivers/ide/legacy/Makefile
index 7043ec7..6939329 100644
--- a/drivers/ide/legacy/Makefile
+++ b/drivers/ide/legacy/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_BLK_DEV_UMC8672)		+= umc8672.o
 obj-$(CONFIG_BLK_DEV_DTC2278)		+= dtc2278.o
 obj-$(CONFIG_BLK_DEV_HT6560B)		+= ht6560b.o
 obj-$(CONFIG_BLK_DEV_QD65XX)		+= qd65xx.o
+obj-$(CONFIG_BLK_DEV_4DRIVES)		+= ide-4drives.o
 
 obj-$(CONFIG_BLK_DEV_GAYLE)		+= gayle.o
 obj-$(CONFIG_BLK_DEV_FALCON_IDE)	+= falconide.o
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index d4d1a6b..bc8b1f8 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -200,6 +200,7 @@ static const struct ide_port_info ali14xx_port_info = {
 static int __init ali14xx_probe(void)
 {
 	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	hw_regs_t hw[2];
 
 	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
 			  basePort, regOn);
@@ -210,6 +211,17 @@ static int __init ali14xx_probe(void)
 		return 1;
 	}
 
+	memset(&hw, 0, sizeof(hw));
+
+	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
+	hw[0].irq = 14;
+
+	ide_std_init_ports(&hw[1], 0x170, 0x376);
+	hw[1].irq = 15;
+
+	ide_init_port_hw(&ide_hwifs[0], &hw[0]);
+	ide_init_port_hw(&ide_hwifs[1], &hw[1]);
+
 	ide_hwifs[0].set_pio_mode = &ali14xx_set_pio_mode;
 	ide_hwifs[1].set_pio_mode = &ali14xx_set_pio_mode;
 
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index 73396f7..5f69cd2 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -103,6 +103,7 @@ static int __init dtc2278_probe(void)
 	unsigned long flags;
 	ide_hwif_t *hwif, *mate;
 	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	hw_regs_t hw[2];
 
 	hwif = &ide_hwifs[0];
 	mate = &ide_hwifs[1];
@@ -128,6 +129,17 @@ static int __init dtc2278_probe(void)
 #endif
 	local_irq_restore(flags);
 
+	memset(&hw, 0, sizeof(hw));
+
+	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
+	hw[0].irq = 14;
+
+	ide_std_init_ports(&hw[1], 0x170, 0x376);
+	hw[1].irq = 15;
+
+	ide_init_port_hw(hwif, &hw[0]);
+	ide_init_port_hw(mate, &hw[1]);
+
 	hwif->set_pio_mode = &dtc2278_set_pio_mode;
 
 	ide_device_add(idx, &dtc2278_port_info);
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 78ca68e..88fe907 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -82,7 +82,7 @@
  * out how they setup those cycle time interfacing values, as they at Holtek
  * call them. IDESETUP.COM that is supplied with the drivers figures out
  * optimal values and fetches those values to drivers. I found out that
- * they use IDE_SELECT_REG to fetch timings to the ide board right after
+ * they use Select register to fetch timings to the ide board right after
  * interface switching. After that it was quite easy to add code to
  * ht6560b.c.
  *
@@ -127,6 +127,7 @@
  */
 static void ht6560b_selectproc (ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 	static u8 current_select = 0;
 	static u8 current_timing = 0;
@@ -155,8 +156,8 @@ static void ht6560b_selectproc (ide_drive_t *drive)
 		/*
 		 * Set timing for this drive:
 		 */
-		outb(timing, IDE_SELECT_REG);
-		(void)inb(IDE_STATUS_REG);
+		outb(timing, hwif->io_ports[IDE_SELECT_OFFSET]);
+		(void)inb(hwif->io_ports[IDE_STATUS_OFFSET]);
 #ifdef DEBUG
 		printk("ht6560b: %s: select=%#x timing=%#x\n",
 			drive->name, select, timing);
@@ -193,9 +194,9 @@ static int __init try_to_init_ht6560b(void)
 	 * Ht6560b autodetected
 	 */
 	outb(HT_CONFIG_DEFAULT, HT_CONFIG_PORT);
-	outb(HT_TIMING_DEFAULT, 0x1f6);  /* IDE_SELECT_REG */
-	(void) inb(0x1f7);               /* IDE_STATUS_REG */
-	
+	outb(HT_TIMING_DEFAULT, 0x1f6);	/* Select register */
+	(void)inb(0x1f7);		/* Status register */
+
 	printk("ht6560b " HT6560B_VERSION
 	       ": chipset detected and initialized"
 #ifdef DEBUG
@@ -339,6 +340,7 @@ static int __init ht6560b_init(void)
 {
 	ide_hwif_t *hwif, *mate;
 	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	hw_regs_t hw[2];
 
 	if (probe_ht6560b == 0)
 		return -ENODEV;
@@ -357,6 +359,17 @@ static int __init ht6560b_init(void)
 		goto release_region;
 	}
 
+	memset(&hw, 0, sizeof(hw));
+
+	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
+	hw[0].irq = 14;
+
+	ide_std_init_ports(&hw[1], 0x170, 0x376);
+	hw[1].irq = 15;
+
+	ide_init_port_hw(hwif, &hw[0]);
+	ide_init_port_hw(mate, &hw[1]);
+
 	hwif->selectproc = &ht6560b_selectproc;
 	hwif->set_pio_mode = &ht6560b_set_pio_mode;
 
diff --git a/drivers/ide/legacy/ide-4drives.c b/drivers/ide/legacy/ide-4drives.c
new file mode 100644
index 0000000..ecd7f35
--- /dev/null
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -0,0 +1,50 @@
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/ide.h>
+
+int probe_4drives = 0;
+
+module_param_named(probe, probe_4drives, bool, 0);
+MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
+
+static int __init ide_4drives_init(void)
+{
+	ide_hwif_t *hwif, *mate;
+	u8 idx[4] = { 0, 1, 0xff, 0xff };
+	hw_regs_t hw;
+
+	if (probe_4drives == 0)
+		return -ENODEV;
+
+	hwif = &ide_hwifs[0];
+	mate = &ide_hwifs[1];
+
+	memset(&hw, 0, sizeof(hw));
+
+	ide_std_init_ports(&hw, 0x1f0, 0x3f6);
+	hw.irq = 14;
+	hw.chipset = ide_4drives;
+
+	ide_init_port_hw(hwif, &hw);
+	ide_init_port_hw(mate, &hw);
+
+	mate->drives[0].select.all ^= 0x20;
+	mate->drives[1].select.all ^= 0x20;
+
+	hwif->mate = mate;
+	mate->mate = hwif;
+
+	hwif->serialized = mate->serialized = 1;
+
+	ide_device_add(idx, NULL);
+
+	return 0;
+}
+
+module_init(ide_4drives_init);
+
+MODULE_AUTHOR("Bartlomiej Zolnierkiewicz");
+MODULE_DESCRIPTION("generic IDE chipset with 4 drives/port support");
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index 15ccf69..9a23b94 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -156,15 +156,15 @@ static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
 
-    hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+    hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
     if (hwif == NULL)
 	return -1;
 
     i = hwif->index;
 
     if (hwif->present)
-	ide_unregister(i, 0, 0);
-    else if (!hwif->hold)
+	ide_unregister(i);
+    else
 	ide_init_port_data(hwif, i);
 
     ide_init_port_hw(hwif, &hw);
@@ -360,7 +360,7 @@ void ide_release(struct pcmcia_device *link)
     if (info->ndev) {
 	/* FIXME: if this fails we need to queue the cleanup somehow
 	   -- need to investigate the required PCMCIA magic */
-	ide_unregister(info->hd, 0, 0);
+	ide_unregister(info->hd);
     }
     info->ndev = 0;
 
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index 688fcae..249651e 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -122,7 +122,7 @@ static int __devexit plat_ide_remove(struct platform_device *pdev)
 {
 	ide_hwif_t *hwif = pdev->dev.driver_data;
 
-	ide_unregister(hwif->index, 0, 0);
+	ide_unregister(hwif->index);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 2f4f47a..7016bdf 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -352,9 +352,9 @@ static const struct ide_port_info qd65xx_port_info __initdata = {
 static int __init qd_probe(int base)
 {
 	ide_hwif_t *hwif;
+	u8 config, unit;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	u8 config;
-	u8 unit;
+	hw_regs_t hw[2];
 
 	config = inb(QD_CONFIG_PORT);
 
@@ -363,6 +363,14 @@ static int __init qd_probe(int base)
 
 	unit = ! (config & QD_CONFIG_IDE_BASEPORT);
 
+	memset(&hw, 0, sizeof(hw));
+
+	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
+	hw[0].irq = 14;
+
+	ide_std_init_ports(&hw[1], 0x170, 0x376);
+	hw[1].irq = 15;
+
 	if ((config & 0xf0) == QD_CONFIG_QD6500) {
 
 		if (qd_testreg(base)) return 1;		/* bad register */
@@ -379,6 +387,8 @@ static int __init qd_probe(int base)
 			return 1;
 		}
 
+		ide_init_port_hw(hwif, &hw[unit]);
+
 		qd_setup(hwif, base, config);
 
 		hwif->port_init_devs = qd6500_port_init_devs;
@@ -416,6 +426,8 @@ static int __init qd_probe(int base)
 			printk(KERN_INFO "%s: qd6580: single IDE board\n",
 					 hwif->name);
 
+			ide_init_port_hw(hwif, &hw[unit]);
+
 			qd_setup(hwif, base, config | (control << 8));
 
 			hwif->port_init_devs = qd6580_port_init_devs;
@@ -435,6 +447,9 @@ static int __init qd_probe(int base)
 			printk(KERN_INFO "%s&%s: qd6580: dual IDE board\n",
 					hwif->name, mate->name);
 
+			ide_init_port_hw(hwif, &hw[0]);
+			ide_init_port_hw(mate, &hw[1]);
+
 			qd_setup(hwif, base, config | (control << 8));
 
 			hwif->port_init_devs = qd6580_port_init_devs;
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index 5696ba0..bc19448 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -130,6 +130,7 @@ static int __init umc8672_probe(void)
 {
 	unsigned long flags;
 	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	hw_regs_t hw[2];
 
 	if (!request_region(0x108, 2, "umc8672")) {
 		printk(KERN_ERR "umc8672: ports 0x108-0x109 already in use.\n");
@@ -148,6 +149,17 @@ static int __init umc8672_probe(void)
 	umc_set_speeds (current_speeds);
 	local_irq_restore(flags);
 
+	memset(&hw, 0, sizeof(hw));
+
+	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
+	hw[0].irq = 14;
+
+	ide_std_init_ports(&hw[1], 0x170, 0x376);
+	hw[1].irq = 15;
+
+	ide_init_port_hw(&ide_hwifs[0], &hw[0]);
+	ide_init_port_hw(&ide_hwifs[1], &hw[1]);
+
 	ide_hwifs[0].set_pio_mode = &umc_set_pio_mode;
 	ide_hwifs[1].set_pio_mode = &umc_set_pio_mode;
 
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 85c016b..9b62824 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -613,9 +613,6 @@ static int au_ide_probe(struct device *dev)
 
 	hwif->dev = dev;
 
-	/* hold should be on in all cases */
-	hwif->hold                      = 1;
-
 	hwif->mmio  = 1;
 
 	/* If the user has selected DDMA assisted copies,
@@ -673,7 +670,7 @@ static int au_ide_remove(struct device *dev)
 	ide_hwif_t *hwif = dev_get_drvdata(dev);
 	_auide_hwif *ahwif = &auide_hwif;
 
-	ide_unregister(hwif->index, 0, 0);
+	ide_unregister(hwif->index);
 
 	iounmap((void *)ahwif->regbase);
 
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index 29fbc5e..a1cfe03 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -409,19 +409,9 @@ static void __init check_prefetch (unsigned int index)
  */
 static void __init setup_device_ptrs (void)
 {
-	unsigned int i;
+	cmd_hwif0 = &ide_hwifs[0];
+	cmd_hwif1 = &ide_hwifs[1];
 
-	cmd_hwif0 = &ide_hwifs[0]; /* default, if not found below */
-	cmd_hwif1 = &ide_hwifs[1]; /* default, if not found below */
-	for (i = 0; i < MAX_HWIFS; i++) {
-		ide_hwif_t *hwif = &ide_hwifs[i];
-		if (hwif->chipset == ide_unknown || hwif->chipset == ide_forced) {
-			if (hwif->io_ports[IDE_DATA_OFFSET] == 0x1f0)
-				cmd_hwif0 = hwif;
-			else if (hwif->io_ports[IDE_DATA_OFFSET] == 0x170)
-				cmd_hwif1 = hwif;
-		}
-	}
 	cmd_drives[0] = &cmd_hwif0->drives[0];
 	cmd_drives[1] = &cmd_hwif0->drives[1];
 	cmd_drives[2] = &cmd_hwif1->drives[0];
@@ -724,6 +714,7 @@ static int __init cmd640x_init(void)
 	unsigned int index;
 	u8 b, cfr;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw[2];
 
 	if (cmd640_vlb && probe_for_cmd640_vlb()) {
 		bus_type = "VLB";
@@ -762,12 +753,23 @@ static int __init cmd640x_init(void)
 		return 0;
 	}
 
+	memset(&hw, 0, sizeof(hw));
+
+	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
+	hw[0].irq = 14;
+
+	ide_std_init_ports(&hw[1], 0x170, 0x376);
+	hw[1].irq = 15;
+
+	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
+			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
+
 	/*
 	 * Initialize data for primary port
 	 */
 	setup_device_ptrs ();
-	printk("%s: buggy cmd640%c interface on %s, config=0x%02x\n",
-	       cmd_hwif0->name, 'a' + cmd640_chip_version - 1, bus_type, cfr);
+
+	ide_init_port_hw(cmd_hwif0, &hw[0]);
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 	cmd_hwif0->set_pio_mode = &cmd640_set_pio_mode;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
@@ -787,8 +789,7 @@ static int __init cmd640x_init(void)
 	/*
 	 * Try to enable the secondary interface, if not already enabled
 	 */
-	if (cmd_hwif1->noprobe ||
-	    (cmd_hwif1->drives[0].noprobe && cmd_hwif1->drives[1].noprobe)) {
+	if (cmd_hwif1->drives[0].noprobe && cmd_hwif1->drives[1].noprobe) {
 		port2 = "not probed";
 	} else {
 		b = get_cmd640_reg(CNTRL);
@@ -820,6 +821,7 @@ static int __init cmd640x_init(void)
 	 * Initialize data for secondary cmd640 port, if enabled
 	 */
 	if (second_port_cmd640) {
+		ide_init_port_hw(cmd_hwif1, &hw[1]);
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 		cmd_hwif1->set_pio_mode = &cmd640_set_pio_mode;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index 3f9cd64..961698d 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -78,15 +78,15 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 	hw.irq = dev->irq;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 	if (hwif == NULL)
 		goto out_disable;
 
 	i = hwif->index;
 
 	if (hwif->present)
-		ide_unregister(i, 0, 0);
-	else if (!hwif->hold)
+		ide_unregister(i);
+	else
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
@@ -120,7 +120,7 @@ delkin_cb_remove (struct pci_dev *dev)
 	ide_hwif_t *hwif = pci_get_drvdata(dev);
 
 	if (hwif)
-		ide_unregister(hwif->index, 0, 0);
+		ide_unregister(hwif->index);
 
 	pci_disable_device(dev);
 }
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 6357bb6..82d0e31 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -760,7 +760,7 @@ static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 		}
 	} else
 		outb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-		     IDE_CONTROL_REG);
+		     hwif->io_ports[IDE_CONTROL_OFFSET]);
 }
 
 /*
@@ -929,64 +929,6 @@ static void hpt3xxn_rw_disk(ide_drive_t *drive, struct request *rq)
 	hpt3xxn_set_clock(HWIF(drive), rq_data_dir(rq) ? 0x23 : 0x21);
 }
 
-/* 
- * Set/get power state for a drive.
- * NOTE: affects both drives on each channel.
- *
- * When we turn the power back on, we need to re-initialize things.
- */
-#define TRISTATE_BIT  0x8000
-
-static int hpt3xx_busproc(ide_drive_t *drive, int state)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u8  mcr_addr		= hwif->select_data + 2;
-	u8  resetmask		= hwif->channel ? 0x80 : 0x40;
-	u8  bsr2		= 0;
-	u16 mcr			= 0;
-
-	hwif->bus_state = state;
-
-	/* Grab the status. */
-	pci_read_config_word(dev, mcr_addr, &mcr);
-	pci_read_config_byte(dev, 0x59, &bsr2);
-
-	/*
-	 * Set the state. We don't set it if we don't need to do so.
-	 * Make sure that the drive knows that it has failed if it's off.
-	 */
-	switch (state) {
-	case BUSSTATE_ON:
-		if (!(bsr2 & resetmask))
-			return 0;
-		hwif->drives[0].failures = hwif->drives[1].failures = 0;
-
-		pci_write_config_byte(dev, 0x59, bsr2 & ~resetmask);
-		pci_write_config_word(dev, mcr_addr, mcr & ~TRISTATE_BIT);
-		return 0;
-	case BUSSTATE_OFF:
-		if ((bsr2 & resetmask) && !(mcr & TRISTATE_BIT))
-			return 0;
-		mcr &= ~TRISTATE_BIT;
-		break;
-	case BUSSTATE_TRISTATE:
-		if ((bsr2 & resetmask) &&  (mcr & TRISTATE_BIT))
-			return 0;
-		mcr |= TRISTATE_BIT;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
-	hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
-
-	pci_write_config_word(dev, mcr_addr, mcr);
-	pci_write_config_byte(dev, 0x59, bsr2 | resetmask);
-	return 0;
-}
-
 /**
  *	hpt37x_calibrate_dpll	-	calibrate the DPLL
  *	@dev: PCI device
@@ -1334,7 +1276,6 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 
 	hwif->quirkproc		= &hpt3xx_quirkproc;
 	hwif->maskproc		= &hpt3xx_maskproc;
-	hwif->busproc		= &hpt3xx_busproc;
 
 	hwif->udma_filter	= &hpt3xx_udma_filter;
 	hwif->mdma_filter	= &hpt3xx_mdma_filter;
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index bf0d3b2..7551332 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -181,6 +181,10 @@ static int ns87415_ide_dma_setup(ide_drive_t *drive)
 	return 1;
 }
 
+#ifndef ide_default_irq
+#define ide_default_irq(irq) 0
+#endif
+
 static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 238e3e1..ef07c7a 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -334,7 +334,8 @@ static int scc_ide_dma_end(ide_drive_t * drive)
 
 	/* errata A308 workaround: Step5 (check data loss) */
 	/* We don't check non ide_disk because it is limited to UDMA4 */
-	if (!(in_be32((void __iomem *)IDE_ALTSTATUS_REG) & ERR_STAT) &&
+	if (!(in_be32((void __iomem *)hwif->io_ports[IDE_ALTSTATUS_OFFSET])
+	      & ERR_STAT) &&
 	    drive->media == ide_disk && drive->current_speed > XFER_UDMA_4) {
 		reg = in_be32((void __iomem *)intsts_port);
 		if (!(reg & INTSTS_ACTEINT)) {
@@ -437,7 +438,8 @@ static int scc_dma_test_irq(ide_drive_t *drive)
 	u32 int_stat = in_be32((void __iomem *)hwif->dma_base + 0x014);
 
 	/* SCC errata A252,A308 workaround: Step4 */
-	if ((in_be32((void __iomem *)IDE_ALTSTATUS_REG) & ERR_STAT) &&
+	if ((in_be32((void __iomem *)hwif->io_ports[IDE_ALTSTATUS_OFFSET])
+	     & ERR_STAT) &&
 	    (int_stat & INTSTS_INTRQ))
 		return 1;
 
@@ -523,6 +525,43 @@ static int setup_mmio_scc (struct pci_dev *dev, const char *name)
 	return -ENOMEM;
 }
 
+static int scc_ide_setup_pci_device(struct pci_dev *dev,
+				    const struct ide_port_info *d)
+{
+	struct scc_ports *ports = pci_get_drvdata(dev);
+	ide_hwif_t *hwif = NULL;
+	hw_regs_t hw;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	int i;
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		hwif = &ide_hwifs[i];
+		if (hwif->chipset == ide_unknown)
+			break; /* pick an unused entry */
+	}
+	if (i == MAX_HWIFS) {
+		printk(KERN_ERR "%s: too many IDE interfaces, "
+				"no room in table\n", SCC_PATA_NAME);
+		return -ENOMEM;
+	}
+
+	memset(&hw, 0, sizeof(hw));
+	for (i = IDE_DATA_OFFSET; i <= IDE_CONTROL_OFFSET; i++)
+		hw.io_ports[i] = ports->dma + 0x20 + i * 4;
+	hw.irq = dev->irq;
+	hw.dev = &dev->dev;
+	hw.chipset = ide_pci;
+	ide_init_port_hw(hwif, &hw);
+	hwif->dev = &dev->dev;
+	hwif->cds = d;
+
+	idx[0] = hwif->index;
+
+	ide_device_add(idx, d);
+
+	return 0;
+}
+
 /**
  *	init_setup_scc	-	set up an SCC PATA Controller
  *	@dev: PCI device
@@ -545,10 +584,13 @@ static int __devinit init_setup_scc(struct pci_dev *dev,
 	struct scc_ports *ports;
 	int rc;
 
+	rc = pci_enable_device(dev);
+	if (rc)
+		goto end;
+
 	rc = setup_mmio_scc(dev, d->name);
-	if (rc < 0) {
-		return rc;
-	}
+	if (rc < 0)
+		goto end;
 
 	ports = pci_get_drvdata(dev);
 	ctl_base = ports->ctl;
@@ -583,7 +625,10 @@ static int __devinit init_setup_scc(struct pci_dev *dev,
 	out_be32((void*)mode_port, MODE_JCUSFEN);
 	out_be32((void*)intmask_port, INTMASK_MSK);
 
-	return ide_setup_pci_device(dev, d);
+	rc = scc_ide_setup_pci_device(dev, d);
+
+ end:
+	return rc;
 }
 
 /**
@@ -610,17 +655,6 @@ static void __devinit init_mmio_iops_scc(ide_hwif_t *hwif)
 	hwif->OUTSW = scc_ide_outsw;
 	hwif->OUTSL = scc_ide_outsl;
 
-	hwif->io_ports[IDE_DATA_OFFSET] = dma_base + 0x20;
-	hwif->io_ports[IDE_ERROR_OFFSET] = dma_base + 0x24;
-	hwif->io_ports[IDE_NSECTOR_OFFSET] = dma_base + 0x28;
-	hwif->io_ports[IDE_SECTOR_OFFSET] = dma_base + 0x2c;
-	hwif->io_ports[IDE_LCYL_OFFSET] = dma_base + 0x30;
-	hwif->io_ports[IDE_HCYL_OFFSET] = dma_base + 0x34;
-	hwif->io_ports[IDE_SELECT_OFFSET] = dma_base + 0x38;
-	hwif->io_ports[IDE_STATUS_OFFSET] = dma_base + 0x3c;
-	hwif->io_ports[IDE_CONTROL_OFFSET] = dma_base + 0x40;
-
-	hwif->irq = dev->irq;
 	hwif->dma_base = dma_base;
 	hwif->config_data = ports->ctl;
 	hwif->mmio = 1;
@@ -736,7 +770,7 @@ static void __devexit scc_remove(struct pci_dev *dev)
 		hwif->dmatable_cpu = NULL;
 	}
 
-	ide_unregister(hwif->index, 0, 0);
+	ide_unregister(hwif->index);
 
 	hwif->chipset = ide_unknown;
 	iounmap((void*)ports->dma);
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 0546264..9d1a303 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -112,10 +112,9 @@ static void
 sgiioc4_maskproc(ide_drive_t * drive, int mask)
 {
 	writeb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-	       (void __iomem *)IDE_CONTROL_REG);
+	       (void __iomem *)drive->hwif->io_ports[IDE_CONTROL_OFFSET]);
 }
 
-
 static int
 sgiioc4_checkirq(ide_hwif_t * hwif)
 {
@@ -142,18 +141,18 @@ sgiioc4_clearirq(ide_drive_t * drive)
 	intr_reg = readl((void __iomem *)other_ir);
 	if (intr_reg & 0x03) { /* Valid IOC4-IDE interrupt */
 		/*
-		 * Using sgiioc4_INB to read the IDE_STATUS_REG has a side effect
-		 * of clearing the interrupt.  The first read should clear it
-		 * if it is set.  The second read should return a "clear" status
-		 * if it got cleared.  If not, then spin for a bit trying to
-		 * clear it.
+		 * Using sgiioc4_INB to read the Status register has a side
+		 * effect of clearing the interrupt.  The first read should
+		 * clear it if it is set.  The second read should return
+		 * a "clear" status if it got cleared.  If not, then spin
+		 * for a bit trying to clear it.
 		 */
-		u8 stat = sgiioc4_INB(IDE_STATUS_REG);
+		u8 stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
 		int count = 0;
-		stat = sgiioc4_INB(IDE_STATUS_REG);
+		stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
 		while ((stat & 0x80) && (count++ < 100)) {
 			udelay(1);
-			stat = sgiioc4_INB(IDE_STATUS_REG);
+			stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
 		}
 
 		if (intr_reg & 0x02) {
@@ -562,7 +561,6 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 						clear interrupts */
 	hwif->maskproc = &sgiioc4_maskproc;	/* Mask on/off NIEN register */
 	hwif->quirkproc = NULL;
-	hwif->busproc = NULL;
 
 	hwif->INB = &sgiioc4_INB;
 
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 8d624af..b6be1b4 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -370,48 +370,6 @@ static int siimage_mmio_ide_dma_test_irq (ide_drive_t *drive)
 }
 
 /**
- *	sil_sata_busproc	-	bus isolation IOCTL
- *	@drive: drive to isolate/restore
- *	@state: bus state to set
- *
- *	Used by the SII3112 to handle bus isolation. As this is a 
- *	SATA controller the work required is quite limited, we 
- *	just have to clean up the statistics
- */
-
-static int sil_sata_busproc(ide_drive_t * drive, int state)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u32 stat_config		= 0;
-	unsigned long addr	= siimage_selreg(hwif, 0);
-
-	if (hwif->mmio)
-		stat_config = readl((void __iomem *)addr);
-	else
-		pci_read_config_dword(dev, addr, &stat_config);
-
-	switch (state) {
-		case BUSSTATE_ON:
-			hwif->drives[0].failures = 0;
-			hwif->drives[1].failures = 0;
-			break;
-		case BUSSTATE_OFF:
-			hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
-			hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
-			break;
-		case BUSSTATE_TRISTATE:
-			hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
-			hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
-			break;
-		default:
-			return -EINVAL;
-	}
-	hwif->bus_state = state;
-	return 0;
-}
-
-/**
  *	sil_sata_reset_poll	-	wait for SATA reset
  *	@drive: drive we are resetting
  *
@@ -818,7 +776,6 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 	if (sata) {
 		static int first = 1;
 
-		hwif->busproc = &sil_sata_busproc;
 		hwif->reset_poll = &sil_sata_reset_poll;
 		hwif->pre_reset = &sil_sata_pre_reset;
 		hwif->udma_filter = &sil_sata_udma_filter;
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index ee261ae..1f00251 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -328,6 +328,10 @@ static const struct ide_port_info sl82c105_chipset __devinitdata = {
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
 	.host_flags	= IDE_HFLAG_IO_32BIT |
 			  IDE_HFLAG_UNMASK_IRQS |
+/* FIXME: check for Compatibility mode in generic IDE PCI code */
+#if defined(CONFIG_LOPEC) || defined(CONFIG_SANDPOINT)
+			  IDE_HFLAG_FORCE_LEGACY_IRQS |
+#endif
 			  IDE_HFLAG_NO_AUTODMA |
 			  IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO5,
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 2ef2ed2..1e4a626 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -126,40 +126,6 @@ static void tc86c001_dma_start(ide_drive_t *drive)
 	ide_dma_start(drive);
 }
 
-static int tc86c001_busproc(ide_drive_t *drive, int state)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	unsigned long sc_base	= hwif->config_data;
-	u16 scr1;
-
-	/* System Control 1 Register bit 11 (ATA Hard Reset) read */
-	scr1 = inw(sc_base + 0x00);
-
-	switch (state) {
-		case BUSSTATE_ON:
-			if (!(scr1 & 0x0800))
-				return 0;
-			scr1 &= ~0x0800;
-
-			hwif->drives[0].failures = hwif->drives[1].failures = 0;
-			break;
-		case BUSSTATE_OFF:
-			if (scr1 & 0x0800)
-				return 0;
-			scr1 |= 0x0800;
-
-			hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
-			hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
-			break;
-		default:
-			return -EINVAL;
-	}
-
-	/* System Control 1 Register bit 11 (ATA Hard Reset) write */
-	outw(scr1, sc_base + 0x00);
-	return 0;
-}
-
 static u8 __devinit tc86c001_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -194,8 +160,6 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 	hwif->set_pio_mode = &tc86c001_set_pio_mode;
 	hwif->set_dma_mode = &tc86c001_set_mode;
 
-	hwif->busproc	= &tc86c001_busproc;
-
 	hwif->cable_detect = tc86c001_cable_detect;
 
 	if (!hwif->dma_base)
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index ebaba01..a784a97 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -99,32 +99,6 @@ static int _slot_ = -1;			/* will be read from PCMCIA registers   */
 /* Make clock cycles and always round up */
 #define PCMCIA_MK_CLKS( t, T ) (( (t) * ((T)/1000000) + 999U ) / 1000U )
 
-
-
-/*
- * IDE stuff.
- */
-static int
-m8xx_ide_default_irq(unsigned long base)
-{
-#ifdef CONFIG_BLK_DEV_MPC8xx_IDE
-	if (base >= MAX_HWIFS)
-		return 0;
-
-	printk("[%d] m8xx_ide_default_irq %d\n",__LINE__,ioport_dsc[base].irq);
-	
-	return (ioport_dsc[base].irq);
-#else
-        return 9;
-#endif
-}
-
-static unsigned long
-m8xx_ide_default_io_base(int index)
-{
-        return index;
-}
-
 #define M8XX_PCMCIA_CD2(slot)      (0x10000000 >> (slot << 4))
 #define M8XX_PCMCIA_CD1(slot)      (0x08000000 >> (slot << 4))
 
@@ -149,12 +123,11 @@ static int pcmcia_schlvl = PCMCIA_SCHLVL;
  */
 
 /*
- * m8xx_ide_init_hwif_ports for a direct IDE interface _using_
+ * m8xx_ide_init_ports() for a direct IDE interface _using_
+ * MPC8xx's internal PCMCIA interface
  */
 #if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
-static void
-m8xx_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port, 
-		unsigned long ctrl_port, int *irq)
+static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
 	unsigned long *p = hw->io_ports;
 	int i;
@@ -173,8 +146,6 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
 	unsigned long base;
 
 	*p = 0;
-	if (irq)
-		*irq = 0;
 
 	pcmp = (pcmconf8xx_t *)(&(((immap_t *)IMAP_ADDR)->im_pcmcia));
 
@@ -248,9 +219,6 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
 		}
 	}
 
-	if (data_port >= MAX_HWIFS)
-		return;
-
 	if (_slot_ == -1) {
 		printk ("PCMCIA slot has not been defined! Using A as default\n");
 		_slot_ = 0;
@@ -292,11 +260,13 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
 	 	*p++ = base + ioport_dsc[data_port].reg_off[i];
 	}
 
-	if (irq) {
+	hw->irq = ioport_dsc[data_port].irq;
+	hw->ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
+
 #ifdef CONFIG_IDE_8xx_PCCARD
+	{
 		unsigned int reg;
 
-		*irq = ioport_dsc[data_port].irq;
 		if (_slot_)
 			pgcrx = &((immap_t *) IMAP_ADDR)->im_pcmcia.pcmc_pgcrb;
 		else
@@ -306,14 +276,11 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
 		reg |= mk_int_int_mask (pcmcia_schlvl) << 24;
 		reg |= mk_int_int_mask (pcmcia_schlvl) << 16;
 		*pgcrx = reg;
-#else	/* direct connected IDE drive, i.e. external IRQ, not the PCMCIA irq */
-		*irq = ioport_dsc[data_port].irq;
-#endif	/* CONFIG_IDE_8xx_PCCARD */
 	}
+#endif	/* CONFIG_IDE_8xx_PCCARD */
 
 	ide_hwifs[data_port].pio_mask = ATA_PIO4;
 	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
-	ide_hwifs[data_port].ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
 
 	/* Enable Harddisk Interrupt,
 	 * and make it edge sensitive
@@ -329,16 +296,15 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
 	/* Enable falling edge irq */
 	pcmp->pcmc_per = 0x100000 >> (16 * _slot_);
 #endif	/* CONFIG_IDE_8xx_PCCARD */
-}	/* m8xx_ide_init_hwif_ports() using 8xx internal PCMCIA interface */
+}
 #endif /* CONFIG_IDE_8xx_PCCARD || CONFIG_IDE_8xx_DIRECT */
 
 /*
- * m8xx_ide_init_hwif_ports for a direct IDE interface _not_ using
+ * m8xx_ide_init_ports() for a direct IDE interface _not_ using
  * MPC8xx's internal PCMCIA interface
  */
 #if defined(CONFIG_IDE_EXT_DIRECT)
-void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
-	unsigned long data_port, unsigned long ctrl_port, int *irq)
+static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
 	unsigned long *p = hw->io_ports;
 	int i;
@@ -349,8 +315,6 @@ void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
 	unsigned long base;
 
 	*p = 0;
-	if (irq)
-		*irq = 0;
 
 	if (!ide_base) {
 
@@ -372,9 +336,6 @@ void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
 #endif
 	}
 
-	if (data_port >= MAX_HWIFS)
-		return;
-
 	base = ide_base + ioport_dsc[data_port].base_off;
 #ifdef DEBUG
 	printk ("base: %08x + %08x = %08x\n",
@@ -392,14 +353,12 @@ void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
 	 	*p++ = base + ioport_dsc[data_port].reg_off[i];
 	}
 
-	if (irq) {
-		/* direct connected IDE drive, i.e. external IRQ */
-		*irq = ioport_dsc[data_port].irq;
-	}
+	/* direct connected IDE drive, i.e. external IRQ */
+	hw->irq = ioport_dsc[data_port].irq;
+	hw->ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
 
 	ide_hwifs[data_port].pio_mask = ATA_PIO4;
 	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
-	ide_hwifs[data_port].ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
 
 	/* Enable Harddisk Interrupt,
 	 * and make it edge sensitive
@@ -407,8 +366,7 @@ void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
 	/* (11-18) Set edge detect for irq, no wakeup from low power mode */
 	((immap_t *) IMAP_ADDR)->im_siu_conf.sc_siel |=
 			(0x80000000 >> ioport_dsc[data_port].irq);
-}	/* m8xx_ide_init_hwif_ports() for CONFIG_IDE_8xx_DIRECT */ 
-
+}
 #endif	/* CONFIG_IDE_8xx_DIRECT */
 
 
@@ -829,20 +787,20 @@ static int identify  (volatile u8 *p)
 	return (0);	/* don't know */
 }
 
-void m8xx_ide_init(void)
-{
-	ppc_ide_md.default_irq          = m8xx_ide_default_irq;
-	ppc_ide_md.default_io_base      = m8xx_ide_default_io_base;
-	ppc_ide_md.ide_init_hwif        = m8xx_ide_init_hwif_ports;
-}
-
 static int __init mpc8xx_ide_probe(void)
 {
+	hw_regs_t hw;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 #ifdef IDE0_BASE_OFFSET
+	memset(&hw, 0, sizeof(hw));
+	m8xx_ide_init_ports(&hw, 0);
+	ide_init_port_hw(&ide_hwifs[0], &hw);
 	idx[0] = 0;
 #ifdef IDE1_BASE_OFFSET
+	memset(&hw, 0, sizeof(hw));
+	m8xx_ide_init_ports(&hw, 1);
+	ide_init_port_hw(&ide_hwifs[1], &hw);
 	idx[1] = 1;
 #endif
 #endif
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index d9ca52e..88619b5 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -80,7 +80,6 @@ typedef struct pmac_ide_hwif {
 } pmac_ide_hwif_t;
 
 static pmac_ide_hwif_t pmac_ide[MAX_HWIFS];
-static int pmac_ide_count;
 
 enum {
 	controller_ohare,	/* OHare based */
@@ -419,38 +418,8 @@ static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
 
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
 
-/*
- * N.B. this can't be an initfunc, because the media-bay task can
- * call ide_[un]register at any time.
- */
-void
-pmac_ide_init_hwif_ports(hw_regs_t *hw,
-			      unsigned long data_port, unsigned long ctrl_port,
-			      int *irq)
-{
-	int i, ix;
-
-	if (data_port == 0)
-		return;
-
-	for (ix = 0; ix < MAX_HWIFS; ++ix)
-		if (data_port == pmac_ide[ix].regbase)
-			break;
-
-	if (ix >= MAX_HWIFS)
-		return;		/* not an IDE PMAC interface */
-
-	for (i = 0; i < 8; ++i)
-		hw->io_ports[i] = data_port + i * 0x10;
-	hw->io_ports[8] = data_port + 0x160;
-
-	if (irq != NULL)
-		*irq = pmac_ide[ix].irq;
-
-	hw->dev = &pmac_ide[ix].mdev->ofdev.dev;
-}
-
-#define PMAC_IDE_REG(x) ((void __iomem *)(IDE_DATA_REG+(x)))
+#define PMAC_IDE_REG(x) \
+	((void __iomem *)((drive)->hwif->io_ports[IDE_DATA_OFFSET] + (x)))
 
 /*
  * Apply the timings of the proper unit (master/slave) to the shared
@@ -886,58 +855,6 @@ sanitize_timings(pmac_ide_hwif_t *pmif)
 	pmif->timings[2] = pmif->timings[3] = value2;
 }
 
-unsigned long
-pmac_ide_get_base(int index)
-{
-	return pmac_ide[index].regbase;
-}
-
-int
-pmac_ide_check_base(unsigned long base)
-{
-	int ix;
-	
- 	for (ix = 0; ix < MAX_HWIFS; ++ix)
-		if (base == pmac_ide[ix].regbase)
-			return ix;
-	return -1;
-}
-
-int
-pmac_ide_get_irq(unsigned long base)
-{
-	int ix;
-
-	for (ix = 0; ix < MAX_HWIFS; ++ix)
-		if (base == pmac_ide[ix].regbase)
-			return pmac_ide[ix].irq;
-	return 0;
-}
-
-static int ide_majors[] = { 3, 22, 33, 34, 56, 57 };
-
-dev_t __init
-pmac_find_ide_boot(char *bootdevice, int n)
-{
-	int i;
-	
-	/*
-	 * Look through the list of IDE interfaces for this one.
-	 */
-	for (i = 0; i < pmac_ide_count; ++i) {
-		char *name;
-		if (!pmac_ide[i].node || !pmac_ide[i].node->full_name)
-			continue;
-		name = pmac_ide[i].node->full_name;
-		if (memcmp(name, bootdevice, n) == 0 && name[n] == 0) {
-			/* XXX should cope with the 2nd drive as well... */
-			return MKDEV(ide_majors[i], 0);
-		}
-	}
-
-	return 0;
-}
-
 /* Suspend call back, should be called after the child devices
  * have actually been suspended
  */
@@ -1088,7 +1005,8 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 	if (np->parent && np->parent->name
 	    && strcasecmp(np->parent->name, "media-bay") == 0) {
 #ifdef CONFIG_PMAC_MEDIABAY
-		media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq, hwif->index);
+		media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq,
+					hwif);
 #endif /* CONFIG_PMAC_MEDIABAY */
 		pmif->mediabay = 1;
 		if (!bidp)
@@ -1119,7 +1037,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 	hwif->hwif_data = pmif;
 	ide_init_port_hw(hwif, hw);
 	hwif->noprobe = pmif->mediabay;
-	hwif->hold = pmif->mediabay;
 	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 	hwif->set_pio_mode = pmac_ide_set_pio_mode;
 	if (pmif->kind == controller_un_ata6
@@ -1154,6 +1071,15 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 	return 0;
 }
 
+static void __devinit pmac_ide_init_ports(hw_regs_t *hw, unsigned long base)
+{
+	int i;
+
+	for (i = 0; i < 8; ++i)
+		hw->io_ports[i] = base + i * 0x10;
+	hw->io_ports[8] = base + 0x160;
+}
+
 /*
  * Attach to a macio probed interface
  */
@@ -1227,7 +1153,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	dev_set_drvdata(&mdev->ofdev.dev, hwif);
 
 	memset(&hw, 0, sizeof(hw));
-	pmac_ide_init_hwif_ports(&hw, pmif->regbase, 0, NULL);
+	pmac_ide_init_ports(&hw, pmif->regbase);
 	hw.irq = irq;
 	hw.dev = &mdev->ofdev.dev;
 
@@ -1341,7 +1267,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, hwif);
 
 	memset(&hw, 0, sizeof(hw));
-	pmac_ide_init_hwif_ports(&hw, pmif->regbase, 0, NULL);
+	pmac_ide_init_ports(&hw, pmif->regbase);
 	hw.irq = pdev->irq;
 	hw.dev = &pdev->dev;
 
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 634e3f6..f7ede0e 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -41,17 +41,6 @@ static ide_hwif_t *ide_match_hwif(unsigned long io_base, u8 bootable, const char
 	ide_hwif_t *hwif;
 
 	/*
-	 * Look for a hwif with matching io_base specified using
-	 * parameters to ide_setup().
-	 */
-	for (h = 0; h < MAX_HWIFS; ++h) {
-		hwif = &ide_hwifs[h];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == io_base) {
-			if (hwif->chipset == ide_forced)
-				return hwif; /* a perfect match */
-		}
-	}
-	/*
 	 * Look for a hwif with matching io_base default value.
 	 * If chipset is "ide_unknown", then claim that hwif slot.
 	 * Otherwise, some other chipset has already claimed it..  :(
@@ -356,7 +345,6 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
 	u8 bootable = (d->host_flags & IDE_HFLAG_BOOTABLE) ? 1 : 0;
-	u8 oldnoprobe = 0;
 	struct hw_regs_s hw;
 
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
@@ -382,19 +370,13 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 		return NULL;	/* no room in ide_hwifs[] */
 
 	memset(&hw, 0, sizeof(hw));
-	hw.irq = hwif->irq ? hwif->irq : irq;
+	hw.irq = irq;
 	hw.dev = &dev->dev;
 	hw.chipset = d->chipset ? d->chipset : ide_pci;
 	ide_std_init_ports(&hw, base, ctl | 2);
 
-	if (hwif->io_ports[IDE_DATA_OFFSET] == base &&
-	    hwif->io_ports[IDE_CONTROL_OFFSET] == (ctl | 2))
-		oldnoprobe = hwif->noprobe;
-
 	ide_init_port_hw(hwif, &hw);
 
-	hwif->noprobe = oldnoprobe;
-
 	hwif->dev = &dev->dev;
 	hwif->cds = d;
 
diff --git a/drivers/macintosh/mediabay.c b/drivers/macintosh/mediabay.c
index bd8a1d1..82add26 100644
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -79,6 +79,7 @@ struct media_bay_info {
 	int				sleeping;
 	struct semaphore		lock;
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
+	ide_hwif_t			*cd_port;
 	void __iomem			*cd_base;
 	int				cd_irq;
 	int				cd_retry;
@@ -448,7 +449,7 @@ int check_media_bay_by_base(unsigned long base, int what)
 }
 
 int media_bay_set_ide_infos(struct device_node* which_bay, unsigned long base,
-			    int irq, int index)
+			    int irq, ide_hwif_t *hwif)
 {
 	int	i;
 
@@ -456,10 +457,11 @@ int media_bay_set_ide_infos(struct device_node* which_bay, unsigned long base,
 		struct media_bay_info* bay = &media_bays[i];
 
 		if (bay->mdev && which_bay == bay->mdev->ofdev.node) {
-			int timeout = 5000;
+			int timeout = 5000, index = hwif->index;
 			
 			down(&bay->lock);
 
+			bay->cd_port	= hwif;
  			bay->cd_base	= (void __iomem *) base;
 			bay->cd_irq	= irq;
 
@@ -551,15 +553,10 @@ static void media_bay_step(int i)
 			bay->timer = 0;
 			bay->state = mb_up;
 			if (bay->cd_index < 0) {
-				hw_regs_t hw;
-
 				printk("mediabay %d, registering IDE...\n", i);
 				pmu_suspend();
-				ide_init_hwif_ports(&hw, (unsigned long) bay->cd_base, (unsigned long) 0, NULL);
-				hw.irq = bay->cd_irq;
-				hw.chipset = ide_pmac;
-				bay->cd_index =
-					ide_register_hw(&hw, NULL, NULL);
+				ide_port_scan(bay->cd_port);
+				bay->cd_index = bay->cd_port->index;
 				pmu_resume();
 			}
 			if (bay->cd_index == -1) {
@@ -589,7 +586,7 @@ static void media_bay_step(int i)
     	        if (bay->cd_index >= 0) {
 			printk(KERN_DEBUG "Unregistering mb %d ide, index:%d\n", i,
 			       bay->cd_index);
-			ide_unregister(bay->cd_index, 1, 1);
+			ide_port_unregister_devices(bay->cd_port);
 			bay->cd_index = -1;
 		}
 	    	if (bay->cd_retry) {
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 68e5c63..93c3fc2 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -60,31 +60,6 @@
 
 #define IDESCSI_DEBUG_LOG		0
 
-typedef struct idescsi_pc_s {
-	u8 c[12];				/* Actual packet bytes */
-	int request_transfer;			/* Bytes to transfer */
-	int actually_transferred;		/* Bytes actually transferred */
-	int buffer_size;			/* Size of our data buffer */
-	struct request *rq;			/* The corresponding request */
-	u8 *buffer;				/* Data buffer */
-	u8 *current_position;			/* Pointer into the above buffer */
-	struct scatterlist *sg;			/* Scatter gather table */
-	unsigned int sg_cnt;			/* Number of entries in sg */
-	int b_count;				/* Bytes transferred from current entry */
-	struct scsi_cmnd *scsi_cmd;		/* SCSI command */
-	void (*done)(struct scsi_cmnd *);	/* Scsi completion routine */
-	unsigned long flags;			/* Status/Action flags */
-	unsigned long timeout;			/* Command timeout */
-} idescsi_pc_t;
-
-/*
- *	Packet command status bits.
- */
-#define PC_DMA_IN_PROGRESS		0	/* 1 while DMA in progress */
-#define PC_WRITING			1	/* Data direction */
-#define PC_TIMEDOUT			3	/* command timed out */
-#define PC_DMA_OK			4	/* Use DMA */
-
 /*
  *	SCSI command transformation layer
  */
@@ -101,14 +76,15 @@ typedef struct ide_scsi_obj {
 	struct gendisk		*disk;
 	struct Scsi_Host	*host;
 
-	idescsi_pc_t *pc;			/* Current packet command */
+	struct ide_atapi_pc *pc;		/* Current packet command */
 	unsigned long flags;			/* Status/Action flags */
 	unsigned long transform;		/* SCSI cmd translation layer */
 	unsigned long log;			/* log flags */
 } idescsi_scsi_t;
 
 static DEFINE_MUTEX(idescsi_ref_mutex);
-static int idescsi_nocd;			/* Set by module param to skip cd */
+/* Set by module param to skip cd */
+static int idescsi_nocd;
 
 #define ide_scsi_g(disk) \
 	container_of((disk)->private_data, struct ide_scsi_obj, driver)
@@ -152,22 +128,11 @@ static inline idescsi_scsi_t *drive_to_idescsi(ide_drive_t *ide_drive)
  */
 #define IDESCSI_PC_RQ			90
 
-static void idescsi_discard_data (ide_drive_t *drive, unsigned int bcount)
-{
-	while (bcount--)
-		(void) HWIF(drive)->INB(IDE_DATA_REG);
-}
-
-static void idescsi_output_zeros (ide_drive_t *drive, unsigned int bcount)
-{
-	while (bcount--)
-		HWIF(drive)->OUTB(0, IDE_DATA_REG);
-}
-
 /*
  *	PIO data transfer routines using the scatter gather table.
  */
-static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigned int bcount)
+static void idescsi_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+		unsigned int bcount)
 {
 	int count;
 	char *buf;
@@ -200,11 +165,12 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 
 	if (bcount) {
 		printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
-		idescsi_discard_data (drive, bcount);
+		ide_atapi_discard_data(drive, bcount);
 	}
 }
 
-static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigned int bcount)
+static void idescsi_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+		unsigned int bcount)
 {
 	int count;
 	char *buf;
@@ -237,7 +203,7 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 
 	if (bcount) {
 		printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
-		idescsi_output_zeros (drive, bcount);
+		ide_atapi_write_zeros(drive, bcount);
 	}
 }
 
@@ -246,15 +212,16 @@ static void ide_scsi_hex_dump(u8 *data, int len)
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, data, len, 0);
 }
 
-static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
+static int idescsi_check_condition(ide_drive_t *drive,
+		struct request *failed_cmd)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	idescsi_pc_t   *pc;
+	struct ide_atapi_pc   *pc;
 	struct request *rq;
 	u8             *buf;
 
 	/* stuff a sense request in front of our current request */
-	pc = kzalloc(sizeof(idescsi_pc_t), GFP_ATOMIC);
+	pc = kzalloc(sizeof(struct ide_atapi_pc), GFP_ATOMIC);
 	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
 	buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
 	if (!pc || !rq || !buf) {
@@ -266,14 +233,14 @@ static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_co
 	ide_init_drive_cmd(rq);
 	rq->special = (char *) pc;
 	pc->rq = rq;
-	pc->buffer = buf;
+	pc->buf = buf;
 	pc->c[0] = REQUEST_SENSE;
-	pc->c[4] = pc->request_transfer = pc->buffer_size = SCSI_SENSE_BUFFERSIZE;
+	pc->c[4] = pc->req_xfer = pc->buf_size = SCSI_SENSE_BUFFERSIZE;
 	rq->cmd_type = REQ_TYPE_SENSE;
 	pc->timeout = jiffies + WAIT_READY;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
-	rq->buffer = (void *) failed_command->special;
-	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
+	rq->buffer = (void *) failed_cmd->special;
+	pc->scsi_cmd = ((struct ide_atapi_pc *) failed_cmd->special)->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
 		ide_scsi_hex_dump(pc->c, 6);
@@ -287,9 +254,12 @@ static int idescsi_end_request(ide_drive_t *, int, int);
 static ide_startstop_t
 idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 {
+	ide_hwif_t *hwif = drive->hwif;
+
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		HWIF(drive)->OUTB(WIN_IDLEIMMEDIATE,IDE_COMMAND_REG);
+		hwif->OUTB(WIN_IDLEIMMEDIATE,
+			   hwif->io_ports[IDE_COMMAND_OFFSET]);
 
 	rq->errors++;
 
@@ -303,7 +273,7 @@ idescsi_atapi_abort(ide_drive_t *drive, struct request *rq)
 {
 #if IDESCSI_DEBUG_LOG
 	printk(KERN_WARNING "idescsi_atapi_abort called for %lu\n",
-			((idescsi_pc_t *) rq->special)->scsi_cmd->serial_number);
+		((struct ide_atapi_pc *) rq->special)->scsi_cmd->serial_number);
 #endif
 	rq->errors |= ERROR_MAX;
 
@@ -316,7 +286,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	struct request *rq = HWGROUP(drive)->rq;
-	idescsi_pc_t *pc = (idescsi_pc_t *) rq->special;
+	struct ide_atapi_pc *pc = (struct ide_atapi_pc *) rq->special;
 	int log = test_bit(IDESCSI_LOG_CMD, &scsi->log);
 	struct Scsi_Host *host;
 	int errors = rq->errors;
@@ -328,20 +298,23 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	}
 	ide_end_drive_cmd (drive, 0, 0);
 	if (blk_sense_request(rq)) {
-		idescsi_pc_t *opc = (idescsi_pc_t *) rq->buffer;
+		struct ide_atapi_pc *opc = (struct ide_atapi_pc *) rq->buffer;
 		if (log) {
 			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, opc->scsi_cmd->serial_number);
-			ide_scsi_hex_dump(pc->buffer, 16);
+			ide_scsi_hex_dump(pc->buf, 16);
 		}
-		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buffer, SCSI_SENSE_BUFFERSIZE);
-		kfree(pc->buffer);
+		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buf,
+			SCSI_SENSE_BUFFERSIZE);
+		kfree(pc->buf);
 		kfree(pc);
 		kfree(rq);
 		pc = opc;
 		rq = pc->rq;
 		pc->scsi_cmd->result = (CHECK_CONDITION << 1) |
-					((test_bit(PC_TIMEDOUT, &pc->flags)?DID_TIME_OUT:DID_OK) << 16);
-	} else if (test_bit(PC_TIMEDOUT, &pc->flags)) {
+				(((pc->flags & PC_FLAG_TIMEDOUT) ?
+				  DID_TIME_OUT :
+				  DID_OK) << 16);
+	} else if (pc->flags & PC_FLAG_TIMEDOUT) {
 		if (log)
 			printk (KERN_WARNING "ide-scsi: %s: timed out for %lu\n",
 					drive->name, pc->scsi_cmd->serial_number);
@@ -370,7 +343,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	return 0;
 }
 
-static inline unsigned long get_timeout(idescsi_pc_t *pc)
+static inline unsigned long get_timeout(struct ide_atapi_pc *pc)
 {
 	return max_t(unsigned long, WAIT_CMD, pc->timeout - jiffies);
 }
@@ -378,12 +351,12 @@ static inline unsigned long get_timeout(idescsi_pc_t *pc)
 static int idescsi_expiry(ide_drive_t *drive)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	idescsi_pc_t   *pc   = scsi->pc;
+	struct ide_atapi_pc   *pc   = scsi->pc;
 
 #if IDESCSI_DEBUG_LOG
 	printk(KERN_WARNING "idescsi_expiry called for %lu at %lu\n", pc->scsi_cmd->serial_number, jiffies);
 #endif
-	set_bit(PC_TIMEDOUT, &pc->flags);
+	pc->flags |= PC_FLAG_TIMEDOUT;
 
 	return 0;					/* we do not want the ide subsystem to retry */
 }
@@ -395,7 +368,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	ide_hwif_t *hwif = drive->hwif;
-	idescsi_pc_t *pc = scsi->pc;
+	struct ide_atapi_pc *pc = scsi->pc;
 	struct request *rq = pc->rq;
 	unsigned int temp;
 	u16 bcount;
@@ -405,7 +378,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 	printk (KERN_INFO "ide-scsi: Reached idescsi_pc_intr interrupt handler\n");
 #endif /* IDESCSI_DEBUG_LOG */
 
-	if (test_bit(PC_TIMEDOUT, &pc->flags)){
+	if (pc->flags & PC_FLAG_TIMEDOUT) {
 #if IDESCSI_DEBUG_LOG
 		printk(KERN_WARNING "idescsi_pc_intr: got timed out packet  %lu at %lu\n",
 				pc->scsi_cmd->serial_number, jiffies);
@@ -414,11 +387,12 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
 	}
-	if (test_and_clear_bit (PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 #if IDESCSI_DEBUG_LOG
 		printk ("ide-scsi: %s: DMA complete\n", drive->name);
 #endif /* IDESCSI_DEBUG_LOG */
-		pc->actually_transferred=pc->request_transfer;
+		pc->xferred = pc->req_xfer;
 		(void) HWIF(drive)->ide_dma_end(drive);
 	}
 
@@ -428,42 +402,44 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 	if ((stat & DRQ_STAT) == 0) {
 		/* No more interrupts */
 		if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
-			printk (KERN_INFO "Packet command completed, %d bytes transferred\n", pc->actually_transferred);
+			printk(KERN_INFO "Packet command completed, %d bytes"
+					" transferred\n", pc->xferred);
 		local_irq_enable_in_hardirq();
 		if (stat & ERR_STAT)
 			rq->errors++;
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
 	}
-	bcount = (hwif->INB(IDE_BCOUNTH_REG) << 8) |
-		  hwif->INB(IDE_BCOUNTL_REG);
-	ireason = hwif->INB(IDE_IREASON_REG);
+	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
+		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
 		return ide_do_reset (drive);
 	}
 	if (ireason & IO) {
-		temp = pc->actually_transferred + bcount;
-		if (temp > pc->request_transfer) {
-			if (temp > pc->buffer_size) {
+		temp = pc->xferred + bcount;
+		if (temp > pc->req_xfer) {
+			if (temp > pc->buf_size) {
 				printk(KERN_ERR "ide-scsi: The scsi wants to "
 					"send us more data than expected "
 					"- discarding data\n");
-				temp = pc->buffer_size - pc->actually_transferred;
+				temp = pc->buf_size - pc->xferred;
 				if (temp) {
-					clear_bit(PC_WRITING, &pc->flags);
+					pc->flags &= ~PC_FLAG_WRITING;
 					if (pc->sg)
-						idescsi_input_buffers(drive, pc, temp);
+						idescsi_input_buffers(drive, pc,
+									temp);
 					else
-						drive->hwif->atapi_input_bytes(drive, pc->current_position, temp);
+						drive->hwif->atapi_input_bytes(drive, pc->cur_pos, temp);
 					printk(KERN_ERR "ide-scsi: transferred"
 							" %d of %d bytes\n",
 							temp, bcount);
 				}
-				pc->actually_transferred += temp;
-				pc->current_position += temp;
-				idescsi_discard_data(drive, bcount - temp);
+				pc->xferred += temp;
+				pc->cur_pos += temp;
+				ide_atapi_discard_data(drive, bcount - temp);
 				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 				return ide_started;
 			}
@@ -473,23 +449,23 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		}
 	}
 	if (ireason & IO) {
-		clear_bit(PC_WRITING, &pc->flags);
+		pc->flags &= ~PC_FLAG_WRITING;
 		if (pc->sg)
 			idescsi_input_buffers(drive, pc, bcount);
 		else
-			hwif->atapi_input_bytes(drive, pc->current_position,
+			hwif->atapi_input_bytes(drive, pc->cur_pos,
 						bcount);
 	} else {
-		set_bit(PC_WRITING, &pc->flags);
+		pc->flags |= PC_FLAG_WRITING;
 		if (pc->sg)
 			idescsi_output_buffers(drive, pc, bcount);
 		else
-			hwif->atapi_output_bytes(drive, pc->current_position,
+			hwif->atapi_output_bytes(drive, pc->cur_pos,
 						 bcount);
 	}
 	/* Update the current position */
-	pc->actually_transferred += bcount;
-	pc->current_position += bcount;
+	pc->xferred += bcount;
+	pc->cur_pos += bcount;
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
@@ -500,7 +476,7 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	idescsi_pc_t *pc = scsi->pc;
+	struct ide_atapi_pc *pc = scsi->pc;
 	ide_startstop_t startstop;
 	u8 ireason;
 
@@ -509,7 +485,7 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 			"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-scsi: (IO,CoD) != (0,1) while "
 				"issuing a packet command\n");
@@ -520,34 +496,34 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 	/* Send the actual packet */
 	drive->hwif->atapi_output_bytes(drive, scsi->pc->c, 12);
-	if (test_bit (PC_DMA_OK, &pc->flags)) {
-		set_bit (PC_DMA_IN_PROGRESS, &pc->flags);
+	if (pc->flags & PC_FLAG_DMA_OK) {
+		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
 		hwif->dma_start(drive);
 	}
 	return ide_started;
 }
 
-static inline int idescsi_set_direction(idescsi_pc_t *pc)
+static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
 {
 	switch (pc->c[0]) {
 		case READ_6: case READ_10: case READ_12:
-			clear_bit(PC_WRITING, &pc->flags);
+			pc->flags &= ~PC_FLAG_WRITING;
 			return 0;
 		case WRITE_6: case WRITE_10: case WRITE_12:
-			set_bit(PC_WRITING, &pc->flags);
+			pc->flags |= PC_FLAG_WRITING;
 			return 0;
 		default:
 			return 1;
 	}
 }
 
-static int idescsi_map_sg(ide_drive_t *drive, idescsi_pc_t *pc)
+static int idescsi_map_sg(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg, *scsi_sg;
 	int segments;
 
-	if (!pc->request_transfer || pc->request_transfer % 1024)
+	if (!pc->req_xfer || pc->req_xfer % 1024)
 		return 1;
 
 	if (idescsi_set_direction(pc))
@@ -566,21 +542,21 @@ static int idescsi_map_sg(ide_drive_t *drive, idescsi_pc_t *pc)
 	return 0;
 }
 
-/*
- *	Issue a packet command
- */
-static ide_startstop_t idescsi_issue_pc (ide_drive_t *drive, idescsi_pc_t *pc)
+static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
+		struct ide_atapi_pc *pc)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	ide_hwif_t *hwif = drive->hwif;
 	u16 bcount;
 	u8 dma = 0;
 
-	scsi->pc=pc;							/* Set the current packet command */
-	pc->actually_transferred=0;					/* We haven't transferred any data yet */
-	pc->current_position=pc->buffer;
+	/* Set the current packet command */
+	scsi->pc = pc;
+	/* We haven't transferred any data yet */
+	pc->xferred = 0;
+	pc->cur_pos = pc->buf;
 	/* Request to transfer the entire buffer at once */
-	bcount = min(pc->request_transfer, 63 * 1024);
+	bcount = min(pc->req_xfer, 63 * 1024);
 
 	if (drive->using_dma && !idescsi_map_sg(drive, pc)) {
 		hwif->sg_mapped = 1;
@@ -591,7 +567,7 @@ static ide_startstop_t idescsi_issue_pc (ide_drive_t *drive, idescsi_pc_t *pc)
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK, bcount, dma);
 
 	if (dma)
-		set_bit(PC_DMA_OK, &pc->flags);
+		pc->flags |= PC_FLAG_DMA_OK;
 
 	if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
 		ide_execute_command(drive, WIN_PACKETCMD, &idescsi_transfer_pc,
@@ -599,7 +575,7 @@ static ide_startstop_t idescsi_issue_pc (ide_drive_t *drive, idescsi_pc_t *pc)
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		HWIF(drive)->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
 		return idescsi_transfer_pc(drive);
 	}
 }
@@ -615,7 +591,8 @@ static ide_startstop_t idescsi_do_request (ide_drive_t *drive, struct request *r
 #endif /* IDESCSI_DEBUG_LOG */
 
 	if (blk_sense_request(rq) || blk_special_request(rq)) {
-		return idescsi_issue_pc (drive, (idescsi_pc_t *) rq->special);
+		return idescsi_issue_pc(drive,
+				(struct ide_atapi_pc *) rq->special);
 	}
 	blk_dump_rq_flags(rq, "ide-scsi: unsup command");
 	idescsi_end_request (drive, 0, 0);
@@ -773,15 +750,15 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	idescsi_scsi_t *scsi = scsihost_to_idescsi(host);
 	ide_drive_t *drive = scsi->drive;
 	struct request *rq = NULL;
-	idescsi_pc_t *pc = NULL;
+	struct ide_atapi_pc *pc = NULL;
 
 	if (!drive) {
 		scmd_printk (KERN_ERR, cmd, "drive not present\n");
 		goto abort;
 	}
 	scsi = drive_to_idescsi(drive);
-	pc = kmalloc (sizeof (idescsi_pc_t), GFP_ATOMIC);
-	rq = kmalloc (sizeof (struct request), GFP_ATOMIC);
+	pc = kmalloc(sizeof(struct ide_atapi_pc), GFP_ATOMIC);
+	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
 	if (rq == NULL || pc == NULL) {
 		printk (KERN_ERR "ide-scsi: %s: out of memory\n", drive->name);
 		goto abort;
@@ -791,11 +768,11 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	pc->flags = 0;
 	pc->rq = rq;
 	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
-	pc->buffer = NULL;
+	pc->buf = NULL;
 	pc->sg = scsi_sglist(cmd);
 	pc->sg_cnt = scsi_sg_count(cmd);
 	pc->b_count = 0;
-	pc->request_transfer = pc->buffer_size = scsi_bufflen(cmd);
+	pc->req_xfer = pc->buf_size = scsi_bufflen(cmd);
 	pc->scsi_cmd = cmd;
 	pc->done = done;
 	pc->timeout = jiffies + cmd->timeout_per_command;
@@ -866,7 +843,7 @@ static int idescsi_eh_abort (struct scsi_cmnd *cmd)
 		printk (KERN_ERR "ide-scsi: cmd aborted!\n");
 
 		if (blk_sense_request(scsi->pc->rq))
-			kfree(scsi->pc->buffer);
+			kfree(scsi->pc->buf);
 		kfree(scsi->pc->rq);
 		kfree(scsi->pc);
 		scsi->pc = NULL;
@@ -916,7 +893,7 @@ static int idescsi_eh_reset (struct scsi_cmnd *cmd)
 	if (__blk_end_request(req, -EIO, 0))
 		BUG();
 	if (blk_sense_request(req))
-		kfree(scsi->pc->buffer);
+		kfree(scsi->pc->buf);
 	kfree(scsi->pc);
 	scsi->pc = NULL;
 	kfree(req);
diff --git a/include/asm-alpha/ide.h b/include/asm-alpha/ide.h
index b7bf68d..f44129a 100644
--- a/include/asm-alpha/ide.h
+++ b/include/asm-alpha/ide.h
@@ -13,9 +13,6 @@
 
 #ifdef __KERNEL__
 
-
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 static inline int ide_default_irq(unsigned long base)
 {
 	switch (base) {
@@ -40,14 +37,6 @@ static inline unsigned long ide_default_io_base(int index)
 	}
 }
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
-#ifdef CONFIG_PCI
-#define ide_init_default_irq(base)	(0)
-#else
-#define ide_init_default_irq(base)	ide_default_irq(base)
-#endif
-
 #include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-arm/ide.h b/include/asm-arm/ide.h
index f348fcf..88f4d23 100644
--- a/include/asm-arm/ide.h
+++ b/include/asm-arm/ide.h
@@ -17,14 +17,6 @@
 #define MAX_HWIFS	4
 #endif
 
-#if !defined(CONFIG_ARCH_L7200)
-# ifdef CONFIG_ARCH_CLPS7500
-#  define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-# else
-#  define ide_default_io_ctl(base)	(0)
-# endif
-#endif /* !ARCH_L7200 */
-
 #define __ide_mm_insw(port,addr,len)	readsw(port,addr,len)
 #define __ide_mm_insl(port,addr,len)	readsl(port,addr,len)
 #define __ide_mm_outsw(port,addr,len)	writesw(port,addr,len)
diff --git a/include/asm-blackfin/ide.h b/include/asm-blackfin/ide.h
index 121e272..5b88de1 100644
--- a/include/asm-blackfin/ide.h
+++ b/include/asm-blackfin/ide.h
@@ -19,10 +19,6 @@
 
 #define MAX_HWIFS	1
 
-/* Legacy ... BLK_DEV_IDECS */
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
-
 #include <asm-generic/ide_iops.h>
 
 /****************************************************************************/
diff --git a/include/asm-ia64/ide.h b/include/asm-ia64/ide.h
index 1ccf238..8fa3f8c 100644
--- a/include/asm-ia64/ide.h
+++ b/include/asm-ia64/ide.h
@@ -16,8 +16,6 @@
 
 #include <linux/irq.h>
 
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 static inline int ide_default_irq(unsigned long base)
 {
 	switch (base) {
@@ -46,14 +44,6 @@ static inline unsigned long ide_default_io_base(int index)
 	}
 }
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
-#ifdef CONFIG_PCI
-#define ide_init_default_irq(base)	(0)
-#else
-#define ide_init_default_irq(base)	ide_default_irq(base)
-#endif
-
 #include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-m32r/ide.h b/include/asm-m32r/ide.h
index 5d2044e..1e7f647 100644
--- a/include/asm-m32r/ide.h
+++ b/include/asm-m32r/ide.h
@@ -23,8 +23,6 @@
 # endif
 #endif
 
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 static __inline__ int ide_default_irq(unsigned long base)
 {
 	switch (base) {
@@ -65,14 +63,6 @@ static __inline__ unsigned long ide_default_io_base(int index)
 	}
 }
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
-#ifdef CONFIG_BLK_DEV_IDEPCI
-#define ide_init_default_irq(base)     (0)
-#else
-#define ide_init_default_irq(base)     ide_default_irq(base)
-#endif
-
 #include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-mips/mach-generic/ide.h b/include/asm-mips/mach-generic/ide.h
index 4ec2b93..0f6c251 100644
--- a/include/asm-mips/mach-generic/ide.h
+++ b/include/asm-mips/mach-generic/ide.h
@@ -27,8 +27,6 @@
 # endif
 #endif
 
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 static __inline__ int ide_probe_legacy(void)
 {
 #ifdef CONFIG_PCI
@@ -98,14 +96,6 @@ static __inline__ unsigned long ide_default_io_base(int index)
 	}
 }
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
-#ifdef CONFIG_BLK_DEV_IDEPCI
-#define ide_init_default_irq(base)	(0)
-#else
-#define ide_init_default_irq(base)	ide_default_irq(base)
-#endif
-
 /* MIPS port and memory-mapped I/O string operations.  */
 static inline void __ide_flush_prologue(void)
 {
diff --git a/include/asm-parisc/ide.h b/include/asm-parisc/ide.h
index be8760f..db0c944 100644
--- a/include/asm-parisc/ide.h
+++ b/include/asm-parisc/ide.h
@@ -17,8 +17,6 @@
 #define MAX_HWIFS	2
 #endif
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #define ide_request_irq(irq,hand,flg,dev,id)	request_irq((irq),(hand),(flg),(dev),(id))
 #define ide_free_irq(irq,dev_id)		free_irq((irq), (dev_id))
 #define ide_request_region(from,extent,name)	request_region((from), (extent), (name))
diff --git a/include/asm-powerpc/ide.h b/include/asm-powerpc/ide.h
index 6d50310..3d90bf7 100644
--- a/include/asm-powerpc/ide.h
+++ b/include/asm-powerpc/ide.h
@@ -31,39 +31,48 @@
 #include <linux/hdreg.h>
 #include <linux/ioport.h>
 
-struct ide_machdep_calls {
-        int         (*default_irq)(unsigned long base);
-        unsigned long (*default_io_base)(int index);
-        void        (*ide_init_hwif)(hw_regs_t *hw,
-                                     unsigned long data_port,
-                                     unsigned long ctrl_port,
-                                     int *irq);
-};
-
-extern struct ide_machdep_calls ppc_ide_md;
-
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
+/* FIXME: use ide_platform host driver */
 static __inline__ int ide_default_irq(unsigned long base)
 {
-	if (ppc_ide_md.default_irq)
-		return ppc_ide_md.default_irq(base);
+#ifdef CONFIG_PPLUS
+	switch (base) {
+	case 0x1f0:	return 14;
+	case 0x170:	return 15;
+	}
+#endif
+#ifdef CONFIG_PPC_PREP
+	switch (base) {
+	case 0x1f0:	return 13;
+	case 0x170:	return 13;
+	case 0x1e8:	return 11;
+	case 0x168:	return 10;
+	case 0xfff0:	return 14;	/* MCP(N)750 ide0 */
+	case 0xffe0:	return 15;	/* MCP(N)750 ide1 */
+	}
+#endif
 	return 0;
 }
 
+/* FIXME: use ide_platform host driver */
 static __inline__ unsigned long ide_default_io_base(int index)
 {
-	if (ppc_ide_md.default_io_base)
-		return ppc_ide_md.default_io_base(index);
+#ifdef CONFIG_PPLUS
+	switch (index) {
+	case 0:		return 0x1f0;
+	case 1:		return 0x170;
+	}
+#endif
+#ifdef CONFIG_PPC_PREP
+	switch (index) {
+	case 0:		return 0x1f0;
+	case 1:		return 0x170;
+	case 2:		return 0x1e8;
+	case 3:		return 0x168;
+	}
+#endif
 	return 0;
 }
 
-#ifdef CONFIG_PCI
-#define ide_init_default_irq(base)	(0)
-#else
-#define ide_init_default_irq(base)	ide_default_irq(base)
-#endif
-
 #ifdef CONFIG_BLK_DEV_MPC8xx_IDE
 #define IDE_ARCH_ACK_INTR  1
 #define ide_ack_intr(hwif) ((hwif)->ack_intr ? (hwif)->ack_intr(hwif) : 1)
@@ -71,8 +80,6 @@ static __inline__ unsigned long ide_default_io_base(int index)
 
 #endif /* __powerpc64__ */
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_POWERPC_IDE_H */
diff --git a/include/asm-powerpc/mediabay.h b/include/asm-powerpc/mediabay.h
index de83fe1..df111c3 100644
--- a/include/asm-powerpc/mediabay.h
+++ b/include/asm-powerpc/mediabay.h
@@ -22,10 +22,14 @@ int check_media_bay(struct device_node *which_bay, int what);
 /* Number of bays in the machine or 0 */
 extern int media_bay_count;
 
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
+#include <linux/ide.h>
+
 int check_media_bay_by_base(unsigned long base, int what);
 /* called by IDE PMAC host driver to register IDE controller for media bay */
 int media_bay_set_ide_infos(struct device_node *which_bay, unsigned long base,
-			    int irq, int index);
+			    int irq, ide_hwif_t *hwif);
+#endif
 
 #endif /* __KERNEL__ */
 #endif /* _PPC_MEDIABAY_H */
diff --git a/include/asm-sh/ide.h b/include/asm-sh/ide.h
index 9f8e914..58e0bdd 100644
--- a/include/asm-sh/ide.h
+++ b/include/asm-sh/ide.h
@@ -14,9 +14,6 @@
 
 #ifdef __KERNEL__
 
-
-#define ide_default_io_ctl(base)	(0)
-
 #include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-sparc/ide.h b/include/asm-sparc/ide.h
index 4076cb5..afd1736 100644
--- a/include/asm-sparc/ide.h
+++ b/include/asm-sparc/ide.h
@@ -17,8 +17,6 @@
 #undef  MAX_HWIFS
 #define MAX_HWIFS	2
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #define __ide_insl(data_reg, buffer, wcount) \
 	__ide_insw(data_reg, buffer, (wcount)<<1)
 #define __ide_outsl(data_reg, buffer, wcount) \
diff --git a/include/asm-sparc64/ide.h b/include/asm-sparc64/ide.h
index ac7eb21..c5fdabe 100644
--- a/include/asm-sparc64/ide.h
+++ b/include/asm-sparc64/ide.h
@@ -24,8 +24,6 @@
 # endif
 #endif
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #define __ide_insl(data_reg, buffer, wcount) \
 	__ide_insw(data_reg, buffer, (wcount)<<1)
 #define __ide_outsl(data_reg, buffer, wcount) \
diff --git a/include/asm-x86/ide.h b/include/asm-x86/ide.h
index c2552d8..cf9c98e 100644
--- a/include/asm-x86/ide.h
+++ b/include/asm-x86/ide.h
@@ -20,8 +20,6 @@
 # endif
 #endif
 
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 static __inline__ int ide_default_irq(unsigned long base)
 {
 	switch (base) {
@@ -60,14 +58,6 @@ static __inline__ unsigned long ide_default_io_base(int index)
 	}
 }
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
-#ifdef CONFIG_BLK_DEV_IDEPCI
-#define ide_init_default_irq(base)	(0)
-#else
-#define ide_init_default_irq(base)	ide_default_irq(base)
-#endif
-
 #include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/linux/hdreg.h b/include/linux/hdreg.h
index e38e759..c37e924 100644
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -422,9 +422,11 @@ struct hd_geometry {
 #define HDIO_SET_NOWERR		0x0325	/* change ignore-write-error flag */
 #define HDIO_SET_DMA		0x0326	/* change use-dma flag */
 #define HDIO_SET_PIO_MODE	0x0327	/* reconfig interface to new speed */
+#ifndef __KERNEL__
 #define HDIO_SCAN_HWIF		0x0328	/* register and (re)scan interface */
-#define HDIO_SET_NICE		0x0329	/* set nice flags */
 #define HDIO_UNREGISTER_HWIF	0x032a  /* unregister interface */
+#endif
+#define HDIO_SET_NICE		0x0329	/* set nice flags */
 #define HDIO_SET_WCACHE		0x032b	/* change write cache enable-disable */
 #define HDIO_SET_ACOUSTIC	0x032c	/* change acoustic behavior */
 #define HDIO_SET_BUSSTATE	0x032d	/* set the bus state of the hwif */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index bc26b2f..6c39482 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -82,24 +82,10 @@ typedef unsigned char	byte;	/* used everywhere */
 
 #define IDE_FEATURE_OFFSET	IDE_ERROR_OFFSET
 #define IDE_COMMAND_OFFSET	IDE_STATUS_OFFSET
-
-#define IDE_DATA_REG		(HWIF(drive)->io_ports[IDE_DATA_OFFSET])
-#define IDE_ERROR_REG		(HWIF(drive)->io_ports[IDE_ERROR_OFFSET])
-#define IDE_NSECTOR_REG		(HWIF(drive)->io_ports[IDE_NSECTOR_OFFSET])
-#define IDE_SECTOR_REG		(HWIF(drive)->io_ports[IDE_SECTOR_OFFSET])
-#define IDE_LCYL_REG		(HWIF(drive)->io_ports[IDE_LCYL_OFFSET])
-#define IDE_HCYL_REG		(HWIF(drive)->io_ports[IDE_HCYL_OFFSET])
-#define IDE_SELECT_REG		(HWIF(drive)->io_ports[IDE_SELECT_OFFSET])
-#define IDE_STATUS_REG		(HWIF(drive)->io_ports[IDE_STATUS_OFFSET])
-#define IDE_CONTROL_REG		(HWIF(drive)->io_ports[IDE_CONTROL_OFFSET])
-#define IDE_IRQ_REG		(HWIF(drive)->io_ports[IDE_IRQ_OFFSET])
-
-#define IDE_FEATURE_REG		IDE_ERROR_REG
-#define IDE_COMMAND_REG		IDE_STATUS_REG
-#define IDE_ALTSTATUS_REG	IDE_CONTROL_REG
-#define IDE_IREASON_REG		IDE_NSECTOR_REG
-#define IDE_BCOUNTL_REG		IDE_LCYL_REG
-#define IDE_BCOUNTH_REG		IDE_HCYL_REG
+#define IDE_ALTSTATUS_OFFSET	IDE_CONTROL_OFFSET
+#define IDE_IREASON_OFFSET	IDE_NSECTOR_OFFSET
+#define IDE_BCOUNTL_OFFSET	IDE_LCYL_OFFSET
+#define IDE_BCOUNTH_OFFSET	IDE_HCYL_OFFSET
 
 #define OK_STAT(stat,good,bad)	(((stat)&((good)|(bad)))==(good))
 #define BAD_R_STAT		(BUSY_STAT   | ERR_STAT)
@@ -169,7 +155,7 @@ enum {		ide_unknown,	ide_generic,	ide_pci,
 		ide_rz1000,	ide_trm290,
 		ide_cmd646,	ide_cy82c693,	ide_4drives,
 		ide_pmac,	ide_etrax100,	ide_acorn,
-		ide_au1xxx,	ide_palm3710,	ide_forced
+		ide_au1xxx,	ide_palm3710
 };
 
 typedef u8 hwif_chipset_t;
@@ -186,14 +172,9 @@ typedef struct hw_regs_s {
 } hw_regs_t;
 
 struct hwif_s * ide_find_port(unsigned long);
-struct hwif_s *ide_deprecated_find_port(unsigned long);
 void ide_init_port_data(struct hwif_s *, unsigned int);
 void ide_init_port_hw(struct hwif_s *, hw_regs_t *);
 
-struct ide_drive_s;
-int ide_register_hw(hw_regs_t *, void (*)(struct ide_drive_s *),
-		    struct hwif_s **);
-
 static inline void ide_std_init_ports(hw_regs_t *hw,
 				      unsigned long io_addr,
 				      unsigned long ctl_addr)
@@ -213,45 +194,6 @@ static inline void ide_std_init_ports(hw_regs_t *hw,
 #define MAX_HWIFS	CONFIG_IDE_MAX_HWIFS
 #endif
 
-/* needed on alpha, x86/x86_64, ia64, mips, ppc32 and sh */
-#ifndef IDE_ARCH_OBSOLETE_DEFAULTS
-# define ide_default_io_base(index)	(0)
-# define ide_default_irq(base)		(0)
-# define ide_init_default_irq(base)	(0)
-#endif
-
-#ifdef CONFIG_IDE_ARCH_OBSOLETE_INIT
-static inline void ide_init_hwif_ports(hw_regs_t *hw,
-				       unsigned long io_addr,
-				       unsigned long ctl_addr,
-				       int *irq)
-{
-	if (!ctl_addr)
-		ide_std_init_ports(hw, io_addr, ide_default_io_ctl(io_addr));
-	else
-		ide_std_init_ports(hw, io_addr, ctl_addr);
-
-	if (irq)
-		*irq = 0;
-
-	hw->io_ports[IDE_IRQ_OFFSET] = 0;
-
-#ifdef CONFIG_PPC32
-	if (ppc_ide_md.ide_init_hwif)
-		ppc_ide_md.ide_init_hwif(hw, io_addr, ctl_addr, irq);
-#endif
-}
-#else
-static inline void ide_init_hwif_ports(hw_regs_t *hw,
-				       unsigned long io_addr,
-				       unsigned long ctl_addr,
-				       int *irq)
-{
-	if (io_addr || ctl_addr)
-		printk(KERN_WARNING "%s: must not be called\n", __FUNCTION__);
-}
-#endif /* CONFIG_IDE_ARCH_OBSOLETE_INIT */
-
 /* Currently only m68k, apus and m8xx need it */
 #ifndef IDE_ARCH_ACK_INTR
 # define ide_ack_intr(hwif) (1)
@@ -406,7 +348,7 @@ typedef struct ide_drive_s {
         u8	wcache;		/* status of write cache */
 	u8	acoustic;	/* acoustic management */
 	u8	media;		/* disk, cdrom, tape, floppy, ... */
-	u8	ctl;		/* "normal" value for IDE_CONTROL_REG */
+	u8	ctl;		/* "normal" value for Control register */
 	u8	ready_stat;	/* min status value for drive ready */
 	u8	mult_count;	/* current multiple sector setting */
 	u8	mult_req;	/* requested multiple sector setting */
@@ -507,8 +449,6 @@ typedef struct hwif_s {
 	void	(*maskproc)(ide_drive_t *, int);
 	/* check host's drive quirk list */
 	void	(*quirkproc)(ide_drive_t *);
-	/* driver soft-power interface */
-	int	(*busproc)(ide_drive_t *, int);
 #endif
 	u8 (*mdma_filter)(ide_drive_t *);
 	u8 (*udma_filter)(ide_drive_t *);
@@ -578,7 +518,6 @@ typedef struct hwif_s {
 
 	unsigned	noprobe    : 1;	/* don't probe for this interface */
 	unsigned	present    : 1;	/* this interface exists */
-	unsigned	hold       : 1; /* this interface is always present */
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
 	unsigned	reset      : 1;	/* reset after probe */
@@ -586,7 +525,9 @@ typedef struct hwif_s {
 	unsigned	mmio       : 1; /* host uses MMIO */
 	unsigned	straight8  : 1;	/* Alan's straight 8 check */
 
-	struct device	gendev;
+	struct device		gendev;
+	struct device		*portdev;
+
 	struct completion gendev_rel_comp; /* To deal with device release() */
 
 	void		*hwif_data;	/* extra hwif data */
@@ -647,6 +588,68 @@ int set_io_32bit(ide_drive_t *, int);
 int set_pio_mode(ide_drive_t *, int);
 int set_using_dma(ide_drive_t *, int);
 
+/* ATAPI packet command flags */
+enum {
+	/* set when an error is considered normal - no retry (ide-tape) */
+	PC_FLAG_ABORT			= (1 << 0),
+	PC_FLAG_SUPPRESS_ERROR		= (1 << 1),
+	PC_FLAG_WAIT_FOR_DSC		= (1 << 2),
+	PC_FLAG_DMA_OK			= (1 << 3),
+	PC_FLAG_DMA_RECOMMENDED		= (1 << 4),
+	PC_FLAG_DMA_IN_PROGRESS		= (1 << 5),
+	PC_FLAG_DMA_ERROR		= (1 << 6),
+	PC_FLAG_WRITING			= (1 << 7),
+	/* command timed out */
+	PC_FLAG_TIMEDOUT		= (1 << 8),
+};
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
+	u8 pc_buf[256];
+	void (*idefloppy_callback) (ide_drive_t *);
+	ide_startstop_t (*idetape_callback) (ide_drive_t *);
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
 #ifdef CONFIG_IDE_PROC_FS
 /*
  * configurable drive settings
@@ -691,6 +694,7 @@ void proc_ide_create(void);
 void proc_ide_destroy(void);
 void ide_proc_register_port(ide_hwif_t *);
 void ide_proc_port_register_devices(ide_hwif_t *);
+void ide_proc_unregister_device(ide_drive_t *);
 void ide_proc_unregister_port(ide_hwif_t *);
 void ide_proc_register_driver(ide_drive_t *, ide_driver_t *);
 void ide_proc_unregister_driver(ide_drive_t *, ide_driver_t *);
@@ -724,6 +728,7 @@ static inline void proc_ide_create(void) { ; }
 static inline void proc_ide_destroy(void) { ; }
 static inline void ide_proc_register_port(ide_hwif_t *hwif) { ; }
 static inline void ide_proc_port_register_devices(ide_hwif_t *hwif) { ; }
+static inline void ide_proc_unregister_device(ide_drive_t *drive) { ; }
 static inline void ide_proc_unregister_port(ide_hwif_t *hwif) { ; }
 static inline void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
 static inline void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
@@ -990,7 +995,6 @@ extern void do_ide_request(struct request_queue *);
 void ide_init_disk(struct gendisk *, ide_drive_t *);
 
 #ifdef CONFIG_IDEPCI_PCIBUS_ORDER
-extern int ide_scan_direction;
 extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *owner, const char *mod_name);
 #define ide_pci_register_driver(d) __ide_pci_register_driver(d, THIS_MODULE, KBUILD_MODNAME)
 #else
@@ -1195,7 +1199,7 @@ static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 void ide_remove_port_from_hwgroup(ide_hwif_t *);
 extern int ide_hwif_request_regions(ide_hwif_t *hwif);
 extern void ide_hwif_release_regions(ide_hwif_t* hwif);
-void ide_unregister(unsigned int, int, int);
+void ide_unregister(unsigned int);
 
 void ide_register_region(struct gendisk *);
 void ide_unregister_region(struct gendisk *);
@@ -1204,6 +1208,8 @@ void ide_undecoded_slave(ide_drive_t *);
 
 int ide_device_add_all(u8 *idx, const struct ide_port_info *);
 int ide_device_add(u8 idx[4], const struct ide_port_info *);
+void ide_port_unregister_devices(ide_hwif_t *);
+void ide_port_scan(ide_hwif_t *);
 
 static inline void *ide_get_hwifdata (ide_hwif_t * hwif)
 {
@@ -1279,6 +1285,7 @@ extern struct mutex ide_cfg_mtx;
 #define local_irq_set(flags)	do { local_save_flags((flags)); local_irq_enable_in_hardirq(); } while (0)
 
 extern struct bus_type ide_bus_type;
+extern struct class *ide_port_class;
 
 /* check if CACHE FLUSH (EXT) command is supported (bits defined in ATA-6) */
 #define ide_id_has_flush_cache(id)	((id)->cfs_enable_2 & 0x3000)
@@ -1307,7 +1314,10 @@ static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
 
 static inline void ide_set_irq(ide_drive_t *drive, int on)
 {
-	drive->hwif->OUTB(drive->ctl | (on ? 0 : 2), IDE_CONTROL_REG);
+	ide_hwif_t *hwif = drive->hwif;
+
+	hwif->OUTB(drive->ctl | (on ? 0 : 2),
+		   hwif->io_ports[IDE_CONTROL_OFFSET]);
 }
 
 static inline u8 ide_read_status(ide_drive_t *drive)
@@ -1331,4 +1341,26 @@ static inline u8 ide_read_error(ide_drive_t *drive)
 	return hwif->INB(hwif->io_ports[IDE_ERROR_OFFSET]);
 }
 
+/*
+ * Too bad. The drive wants to send us data which we are not ready to accept.
+ * Just throw it away.
+ */
+static inline void ide_atapi_discard_data(ide_drive_t *drive, unsigned bcount)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	/* FIXME: use ->atapi_input_bytes */
+	while (bcount--)
+		(void)hwif->INB(hwif->io_ports[IDE_DATA_OFFSET]);
+}
+
+static inline void ide_atapi_write_zeros(ide_drive_t *drive, unsigned bcount)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	/* FIXME: use ->atapi_output_bytes */
+	while (bcount--)
+		hwif->OUTB(0, hwif->io_ports[IDE_DATA_OFFSET]);
+}
+
 #endif /* _IDE_H */
