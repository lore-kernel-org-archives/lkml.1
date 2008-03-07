Return-Path: <linux-kernel-owner+w=401wt.eu-S932644AbYCGUuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbYCGUuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932246AbYCGUuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:50:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:31881 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbYCGUt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=xHbXVoK84qN/OMgiBt3ntZArGWhrDNmZdxenyHFIEpdsY8E9A1IobSQnuUYqoA6ep9f2bQHafurLcmy5ms64cnr5wPaI/mOATfNWEemy6qYskWCDMUttrvRPo21utEf3qFrp5vajrvRQyDiNRbPp9MKhYAdjnaBWEAdkDTE21qk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Fri, 7 Mar 2008 22:02:57 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803072202.57570.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

three regression bugfixes + documentation update


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/00-INDEX              |    2 --
 Documentation/cdrom/ide-cd          |   18 +++++++++---------
 Documentation/ide/00-INDEX          |   12 ++++++++++++
 Documentation/{ => ide}/ide.txt     |   20 ++++++++++----------
 Documentation/kernel-parameters.txt |    8 ++++----
 drivers/ide/Kconfig                 |   30 +++++++++++++++---------------
 drivers/ide/ide-cd_ioctl.c          |    4 ++++
 drivers/ide/ide-dma.c               |    2 +-
 drivers/ide/ide.c                   |    4 ++--
 9 files changed, 57 insertions(+), 43 deletions(-)
 create mode 100644 Documentation/ide/00-INDEX
 rename Documentation/{ => ide}/ide.txt (99%)


Bartlomiej Zolnierkiewicz (2):
      ide-cd: mark REQ_TYPE_ATA_PC write requests with REQ_RW flag
      ide: fix enabling DMA on it821x in "smart" mode

Peter Teoh (1):
      ide: fix buggy code in ide_register_hw()

Randy Dunlap (2):
      ide: move ide.txt to Documentation/ide/
      ide: update references to Documentation/ide/ide.txt (v2)


diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 30b327a..042073f 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -183,8 +183,6 @@ i386/
 	- directory with info about Linux on Intel 32 bit architecture.
 ia64/
 	- directory with info about Linux on Intel 64 bit architecture.
-ide.txt
-	- important info for users of ATA devices (IDE/EIDE disks and CD-ROMS).
 infiniband/
 	- directory with documents concerning Linux InfiniBand support.
 initrd.txt
diff --git a/Documentation/cdrom/ide-cd b/Documentation/cdrom/ide-cd
index 29721bf..91c0dcc 100644
--- a/Documentation/cdrom/ide-cd
+++ b/Documentation/cdrom/ide-cd
@@ -45,7 +45,7 @@ This driver provides the following features:
 ---------------
 
 0. The ide-cd relies on the ide disk driver.  See
-   Documentation/ide.txt for up-to-date information on the ide
+   Documentation/ide/ide.txt for up-to-date information on the ide
    driver.
 
 1. Make sure that the ide and ide-cd drivers are compiled into the
@@ -64,7 +64,7 @@ This driver provides the following features:
 
    Depending on what type of IDE interface you have, you may need to
    specify additional configuration options.  See
-   Documentation/ide.txt.
+   Documentation/ide/ide.txt.
 
 2. You should also ensure that the iso9660 filesystem is either
    compiled into the kernel or available as a loadable module.  You
@@ -84,7 +84,7 @@ This driver provides the following features:
    on the primary IDE interface are called `hda' and `hdb',
    respectively.  The drives on the secondary interface are called
    `hdc' and `hdd'.  (Interfaces at other locations get other letters
-   in the third position; see Documentation/ide.txt.)
+   in the third position; see Documentation/ide/ide.txt.)
 
    If you want your CDROM drive to be found automatically by the
    driver, you should make sure your IDE interface uses either the
@@ -93,7 +93,7 @@ This driver provides the following features:
    be jumpered as `master'.  (If for some reason you cannot configure
    your system in this manner, you can probably still use the driver.
    You may have to pass extra configuration information to the kernel
-   when you boot, however.  See Documentation/ide.txt for more
+   when you boot, however.  See Documentation/ide/ide.txt for more
    information.)
 
 4. Boot the system.  If the drive is recognized, you should see a
@@ -201,7 +201,7 @@ TEST
 This section discusses some common problems encountered when trying to
 use the driver, and some possible solutions.  Note that if you are
 experiencing problems, you should probably also review
-Documentation/ide.txt for current information about the underlying
+Documentation/ide/ide.txt for current information about the underlying
 IDE support code.  Some of these items apply only to earlier versions
 of the driver, but are mentioned here for completeness.
 
@@ -211,7 +211,7 @@ from the driver.
 a. Drive is not detected during booting.
 
    - Review the configuration instructions above and in
-     Documentation/ide.txt, and check how your hardware is
+     Documentation/ide/ide.txt, and check how your hardware is
      configured.
 
    - If your drive is the only device on an IDE interface, it should
@@ -219,7 +219,7 @@ a. Drive is not detected during booting.
 
    - If your IDE interface is not at the standard addresses of 0x170
      or 0x1f0, you'll need to explicitly inform the driver using a
-     lilo option.  See Documentation/ide.txt.  (This feature was
+     lilo option.  See Documentation/ide/ide.txt.  (This feature was
      added around kernel version 1.3.30.)
 
    - If the autoprobing is not finding your drive, you can tell the
@@ -245,7 +245,7 @@ a. Drive is not detected during booting.
      Support for some interfaces needing extra initialization is
      provided in later 1.3.x kernels.  You may need to turn on
      additional kernel configuration options to get them to work;
-     see Documentation/ide.txt.
+     see Documentation/ide/ide.txt.
 
      Even if support is not available for your interface, you may be
      able to get it to work with the following procedure.  First boot
@@ -299,7 +299,7 @@ c. System hangups.
     be worked around by specifying the `serialize' option when
     booting.  Recent kernels should be able to detect the need for
     this automatically in most cases, but the detection is not
-    foolproof.  See Documentation/ide.txt for more information
+    foolproof.  See Documentation/ide/ide.txt for more information
     about the `serialize' option and the CMD640B.
 
   - Note that many MS-DOS CDROM drivers will work with such buggy
diff --git a/Documentation/ide.txt b/Documentation/ide.txt
deleted file mode 100644
index bcd7cd1..0000000
--- a/Documentation/ide.txt
+++ /dev/null
@@ -1,335 +0,0 @@
-
-	Information regarding the Enhanced IDE drive in Linux 2.6
-
-==============================================================================
-
-   
-   The hdparm utility can be used to control various IDE features on a
-   running system. It is packaged separately.  Please Look for it on popular
-   linux FTP sites.
-   
-
-
-***  IMPORTANT NOTICES:  BUGGY IDE CHIPSETS CAN CORRUPT DATA!!
-***  =================
-***  PCI versions of the CMD640 and RZ1000 interfaces are now detected
-***  automatically at startup when PCI BIOS support is configured.
-***
-***  Linux disables the "prefetch" ("readahead") mode of the RZ1000
-***  to prevent data corruption possible due to hardware design flaws.
-***
-***  For the CMD640, linux disables "IRQ unmasking" (hdparm -u1) on any
-***  drive for which the "prefetch" mode of the CMD640 is turned on.
-***  If "prefetch" is disabled (hdparm -p8), then "IRQ unmasking" can be
-***  used again.
-***
-***  For the CMD640, linux disables "32bit I/O" (hdparm -c1) on any drive
-***  for which the "prefetch" mode of the CMD640 is turned off.
-***  If "prefetch" is enabled (hdparm -p9), then "32bit I/O" can be
-***  used again.
-***
-***  The CMD640 is also used on some Vesa Local Bus (VLB) cards, and is *NOT*
-***  automatically detected by Linux.  For safe, reliable operation with such
-***  interfaces, one *MUST* use the "cmd640.probe_vlb" kernel option.
-***
-***  Use of the "serialize" option is no longer necessary.
-
-================================================================================
-Common pitfalls:
-
-- 40-conductor IDE cables are capable of transferring data in DMA modes up to
-  udma2, but no faster.
-
-- If possible devices should be attached to separate channels if they are
-  available. Typically the disk on the first and CD-ROM on the second.
-
-- If you mix devices on the same cable, please consider using similar devices
-  in respect of the data transfer mode they support.
-
-- Even better try to stick to the same vendor and device type on the same
-  cable.
-
-================================================================================
-
-This is the multiple IDE interface driver, as evolved from hd.c.  
-
-It supports up to 9 IDE interfaces per default, on one or more IRQs (usually
-14 & 15).  There can be up to two drives per interface, as per the ATA-6 spec.
-
-Primary:    ide0, port 0x1f0; major=3;  hda is minor=0; hdb is minor=64
-Secondary:  ide1, port 0x170; major=22; hdc is minor=0; hdd is minor=64
-Tertiary:   ide2, port 0x1e8; major=33; hde is minor=0; hdf is minor=64
-Quaternary: ide3, port 0x168; major=34; hdg is minor=0; hdh is minor=64
-fifth..     ide4, usually PCI, probed
-sixth..     ide5, usually PCI, probed
-
-To access devices on interfaces > ide0, device entries please make sure that
-device files for them are present in /dev.  If not, please create such
-entries, by using /dev/MAKEDEV.
-
-This driver automatically probes for most IDE interfaces (including all PCI
-ones), for the drives/geometries attached to those interfaces, and for the IRQ
-lines being used by the interfaces (normally 14, 15 for ide0/ide1).
-
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
-Any number of interfaces may share a single IRQ if necessary, at a slight
-performance penalty, whether on separate cards or a single VLB card.
-The IDE driver automatically detects and handles this.  However, this may
-or may not be harmful to your hardware.. two or more cards driving the same IRQ
-can potentially burn each other's bus driver, though in practice this
-seldom occurs.  Be careful, and if in doubt, don't do it!
-
-Drives are normally found by auto-probing and/or examining the CMOS/BIOS data.
-For really weird situations, the apparent (fdisk) geometry can also be specified
-on the kernel "command line" using LILO.  The format of such lines is:
-
-	hdx=cyls,heads,sects,wpcom,irq
-or	hdx=cdrom
-
-where hdx can be any of hda through hdh, Three values are required
-(cyls,heads,sects).  For example:
-
-	hdc=1050,32,64  hdd=cdrom
-
-either {hda,hdb} or {hdc,hdd}.  The results of successful auto-probing may
-override the physical geometry/irq specified, though the "original" geometry
-may be retained as the "logical" geometry for partitioning purposes (fdisk).
-
-If the auto-probing during boot time confuses a drive (ie. the drive works
-with hd.c but not with ide.c), then an command line option may be specified
-for each drive for which you'd like the drive to skip the hardware
-probe/identification sequence.  For example:
-
-	hdb=noprobe
-or
-	hdc=768,16,32
-	hdc=noprobe
-
-Note that when only one IDE device is attached to an interface, it should be
-jumpered as "single" or "master", *not* "slave".  Many folks have had
-"trouble" with cdroms because of this requirement, so the driver now probes
-for both units, though success is more likely when the drive is jumpered
-correctly.
-
-Courtesy of Scott Snyder and others, the driver supports ATAPI cdrom drives
-such as the NEC-260 and the new MITSUMI triple/quad speed drives.
-Such drives will be identified at boot time, just like a hard disk.
-
-If for some reason your cdrom drive is *not* found at boot time, you can force
-the probe to look harder by supplying a kernel command line parameter
-via LILO, such as:
-
-	hdc=cdrom	/* hdc = "master" on second interface */
-or
-	hdd=cdrom	/* hdd = "slave" on second interface */
-
-For example, a GW2000 system might have a hard drive on the primary
-interface (/dev/hda) and an IDE cdrom drive on the secondary interface
-(/dev/hdc).  To mount a CD in the cdrom drive, one would use something like:
-
-	ln -sf /dev/hdc /dev/cdrom
-	mkdir /mnt/cdrom
-	mount /dev/cdrom /mnt/cdrom -t iso9660 -o ro
-
-If, after doing all of the above, mount doesn't work and you see
-errors from the driver (with dmesg) complaining about `status=0xff',
-this means that the hardware is not responding to the driver's attempts
-to read it.  One of the following is probably the problem:
-
-  - Your hardware is broken.
-
-  - You are using the wrong address for the device, or you have the
-    drive jumpered wrong.  Review the configuration instructions above.
-
-  - Your IDE controller requires some nonstandard initialization sequence
-    before it will work properly.  If this is the case, there will often
-    be a separate MS-DOS driver just for the controller.  IDE interfaces
-    on sound cards usually fall into this category.  Such configurations
-    can often be made to work by first booting MS-DOS, loading the
-    appropriate drivers, and then warm-booting linux (without powering
-    off).  This can be automated using loadlin in the MS-DOS autoexec.
-
-If you always get timeout errors, interrupts from the drive are probably
-not making it to the host.  Check how you have the hardware jumpered
-and make sure it matches what the driver expects (see the configuration
-instructions above).  If you have a PCI system, also check the BIOS
-setup; I've had one report of a system which was shipped with IRQ 15
-disabled by the BIOS.
-
-The kernel is able to execute binaries directly off of the cdrom,
-provided it is mounted with the default block size of 1024 (as above).
-
-Please pass on any feedback on any of this stuff to the maintainer,
-whose address can be found in linux/MAINTAINERS.
-
-Note that if BOTH hd.c and ide.c are configured into the kernel,
-hd.c will normally be allowed to control the primary IDE interface.
-This is useful for older hardware that may be incompatible with ide.c,
-and still allows newer hardware to run on the 2nd/3rd/4th IDE ports
-under control of ide.c.   To have ide.c also "take over" the primary
-IDE port in this situation, use the "command line" parameter:  ide0=0x1f0
-
-The IDE driver is modularized.  The high level disk/CD-ROM/tape/floppy
-drivers can always be compiled as loadable modules, the chipset drivers
-can only be compiled into the kernel, and the core code (ide.c) can be
-compiled as a loadable module provided no chipset support is needed.
-
-When using ide.c as a module in combination with kmod, add:
-
-	alias block-major-3 ide-probe
-
-to /etc/modprobe.conf.
-
-When ide.c is used as a module, you can pass command line parameters to the
-driver using the "options=" keyword to insmod, while replacing any ',' with
-';'.  For example:
-
-	insmod ide.o options="ide0=serialize ide1=serialize ide2=0x1e8;0x3ee;11"
-
-
-================================================================================
-
-Summary of ide driver parameters for kernel command line
---------------------------------------------------------
-
- "hdx="  is recognized for all "x" from "a" to "h", such as "hdc".
- 
- "idex=" is recognized for all "x" from "0" to "3", such as "ide1".
-
- "hdx=noprobe"		: drive may be present, but do not probe for it
- 
- "hdx=none"		: drive is NOT present, ignore cmos and do not probe
- 
- "hdx=nowerr"		: ignore the WRERR_STAT bit on this drive
- 
- "hdx=cdrom"		: drive is present, and is a cdrom drive
- 
- "hdx=cyl,head,sect"	: disk drive is present, with specified geometry
-
- "hdx=remap"		: remap access of sector 0 to sector 1 (for EZDrive)
-
- "hdx=remap63"		: remap the drive: add 63 to all sector numbers
-			  (for DM OnTrack)
-
- "idex=noautotune"	: driver will NOT attempt to tune interface speed
-
- "hdx=autotune"		: driver will attempt to tune interface speed
-			  to the fastest PIO mode supported,
-			  if possible for this drive only.
-			  Not fully supported by all chipset types,
-			  and quite likely to cause trouble with
-			  older/odd IDE drives.
-
- "hdx=nodma"		: disallow DMA
-
- "hdx=scsi"		: the return of the ide-scsi flag, this is useful for
- 			  allowing ide-floppy, ide-tape, and ide-cdrom|writers
- 			  to use ide-scsi emulation on a device specific option.
-
- "idebus=xx"		: inform IDE driver of VESA/PCI bus speed in MHz,
-			  where "xx" is between 20 and 66 inclusive,
-			  used when tuning chipset PIO modes.
-			  For PCI bus, 25 is correct for a P75 system,
-			  30 is correct for P90,P120,P180 systems,
-			  and 33 is used for P100,P133,P166 systems.
-			  If in doubt, use idebus=33 for PCI.
-			  As for VLB, it is safest to not specify it.
-			  Bigger values are safer than smaller ones.
-
- "idex=base"		: probe for an interface at the addr specified,
-			  where "base" is usually 0x1f0 or 0x170
-			  and "ctl" is assumed to be "base"+0x206
-			  
- "idex=base,ctl"	: specify both base and ctl
-
- "idex=base,ctl,irq"	: specify base, ctl, and irq number
-
- "idex=serialize"	: do not overlap operations on idex. Please note
-			  that you will have to specify this option for
-			  both the respective primary and secondary channel
-			  to take effect.
-
- "idex=four"		: four drives on idex and ide(x^1) share same ports
-			
- "idex=reset"		: reset interface after probe
-
- "idex=ata66"		: informs the interface that it has an 80c cable
-			  for chipsets that are ATA-66 capable, but the
-			  ability to bit test for detection is currently
-			  unknown.
-
- "ide=reverse"		: formerly called to pci sub-system, but now local.
-
-The following are valid ONLY on ide0, which usually corresponds
-to the first ATA interface found on the particular host, and the defaults for
-the base,ctl ports must not be altered.
-
- "ide=doubler"		: probe/support IDE doublers on Amiga
-
-There may be more options than shown -- use the source, Luke!
-
-Everything else is rejected with a "BAD OPTION" message.
-
-For legacy IDE VLB host drivers (ali14xx/dtc2278/ht6560b/qd65xx/umc8672)
-you need to explicitly enable probing by using "probe" kernel parameter,
-i.e. to enable probing for ALI M14xx chipsets (ali14xx host driver) use:
-
-* "ali14xx.probe" boot option when ali14xx driver is built-in the kernel
-
-* "probe" module parameter when ali14xx driver is compiled as module
-  ("modprobe ali14xx probe")
-
-Also for legacy CMD640 host driver (cmd640) you need to use "probe_vlb"
-kernel paremeter to enable probing for VLB version of the chipset (PCI ones
-are detected automatically).
-
-================================================================================
-
-Some Terminology
-----------------
-IDE = Integrated Drive Electronics, meaning that each drive has a built-in
-controller, which is why an "IDE interface card" is not a "controller card".
-
-ATA = AT (the old IBM 286 computer) Attachment Interface, a draft American
-National Standard for connecting hard drives to PCs.  This is the official
-name for "IDE".
-
-The latest standards define some enhancements, known as the ATA-6 spec,
-which grew out of vendor-specific "Enhanced IDE" (EIDE) implementations.
-
-ATAPI = ATA Packet Interface, a new protocol for controlling the drives,
-similar to SCSI protocols, created at the same time as the ATA2 standard.
-ATAPI is currently used for controlling CDROM, TAPE and FLOPPY (ZIP or
-LS120/240) devices, removable R/W cartridges, and for high capacity hard disk
-drives.
-
-mlord@pobox.com
---
-
-Wed Apr 17 22:52:44 CEST 2002 edited by Marcin Dalecki, the current
-maintainer.
-
-Wed Aug 20 22:31:29 CEST 2003 updated ide boot options to current ide.c
-comments at 2.6.0-test4 time. Maciej Soltysiak <solt@dns.toxicfilms.tv>
diff --git a/Documentation/ide/00-INDEX b/Documentation/ide/00-INDEX
new file mode 100644
index 0000000..d6b7788
--- /dev/null
+++ b/Documentation/ide/00-INDEX
@@ -0,0 +1,12 @@
+00-INDEX
+    	- this file
+ChangeLog.ide-cd.1994-2004
+	- ide-cd changelog
+ChangeLog.ide-floppy.1996-2002
+	- ide-floppy changelog
+ChangeLog.ide-tape.1995-2002
+	- ide-tape changelog
+ide-tape.txt
+	- info on the IDE ATAPI streaming tape driver
+ide.txt
+	- important info for users of ATA devices (IDE/EIDE disks and CD-ROMS).
diff --git a/Documentation/ide/ide.txt b/Documentation/ide/ide.txt
new file mode 100644
index 0000000..e3b3425
--- /dev/null
+++ b/Documentation/ide/ide.txt
@@ -0,0 +1,335 @@
+
+	Information regarding the Enhanced IDE drive in Linux 2.6
+
+==============================================================================
+
+
+   The hdparm utility can be used to control various IDE features on a
+   running system. It is packaged separately.  Please Look for it on popular
+   linux FTP sites.
+
+
+
+***  IMPORTANT NOTICES:  BUGGY IDE CHIPSETS CAN CORRUPT DATA!!
+***  =================
+***  PCI versions of the CMD640 and RZ1000 interfaces are now detected
+***  automatically at startup when PCI BIOS support is configured.
+***
+***  Linux disables the "prefetch" ("readahead") mode of the RZ1000
+***  to prevent data corruption possible due to hardware design flaws.
+***
+***  For the CMD640, linux disables "IRQ unmasking" (hdparm -u1) on any
+***  drive for which the "prefetch" mode of the CMD640 is turned on.
+***  If "prefetch" is disabled (hdparm -p8), then "IRQ unmasking" can be
+***  used again.
+***
+***  For the CMD640, linux disables "32bit I/O" (hdparm -c1) on any drive
+***  for which the "prefetch" mode of the CMD640 is turned off.
+***  If "prefetch" is enabled (hdparm -p9), then "32bit I/O" can be
+***  used again.
+***
+***  The CMD640 is also used on some Vesa Local Bus (VLB) cards, and is *NOT*
+***  automatically detected by Linux.  For safe, reliable operation with such
+***  interfaces, one *MUST* use the "cmd640.probe_vlb" kernel option.
+***
+***  Use of the "serialize" option is no longer necessary.
+
+================================================================================
+Common pitfalls:
+
+- 40-conductor IDE cables are capable of transferring data in DMA modes up to
+  udma2, but no faster.
+
+- If possible devices should be attached to separate channels if they are
+  available. Typically the disk on the first and CD-ROM on the second.
+
+- If you mix devices on the same cable, please consider using similar devices
+  in respect of the data transfer mode they support.
+
+- Even better try to stick to the same vendor and device type on the same
+  cable.
+
+================================================================================
+
+This is the multiple IDE interface driver, as evolved from hd.c.
+
+It supports up to 9 IDE interfaces per default, on one or more IRQs (usually
+14 & 15).  There can be up to two drives per interface, as per the ATA-6 spec.
+
+Primary:    ide0, port 0x1f0; major=3;  hda is minor=0; hdb is minor=64
+Secondary:  ide1, port 0x170; major=22; hdc is minor=0; hdd is minor=64
+Tertiary:   ide2, port 0x1e8; major=33; hde is minor=0; hdf is minor=64
+Quaternary: ide3, port 0x168; major=34; hdg is minor=0; hdh is minor=64
+fifth..     ide4, usually PCI, probed
+sixth..     ide5, usually PCI, probed
+
+To access devices on interfaces > ide0, device entries please make sure that
+device files for them are present in /dev.  If not, please create such
+entries, by using /dev/MAKEDEV.
+
+This driver automatically probes for most IDE interfaces (including all PCI
+ones), for the drives/geometries attached to those interfaces, and for the IRQ
+lines being used by the interfaces (normally 14, 15 for ide0/ide1).
+
+For special cases, interfaces may be specified using kernel "command line"
+options.  For example,
+
+	ide3=0x168,0x36e,10	/* ioports 0x168-0x16f,0x36e, irq 10 */
+
+Normally the irq number need not be specified, as ide.c will probe for it:
+
+	ide3=0x168,0x36e	/* ioports 0x168-0x16f,0x36e */
+
+The standard port, and irq values are these:
+
+	ide0=0x1f0,0x3f6,14
+	ide1=0x170,0x376,15
+	ide2=0x1e8,0x3ee,11
+	ide3=0x168,0x36e,10
+
+Note that the first parameter reserves 8 contiguous ioports, whereas the
+second value denotes a single ioport. If in doubt, do a 'cat /proc/ioports'.
+
+In all probability the device uses these ports and IRQs if it is attached
+to the appropriate ide channel.  Pass the parameter for the correct ide
+channel to the kernel, as explained above.
+
+Any number of interfaces may share a single IRQ if necessary, at a slight
+performance penalty, whether on separate cards or a single VLB card.
+The IDE driver automatically detects and handles this.  However, this may
+or may not be harmful to your hardware.. two or more cards driving the same IRQ
+can potentially burn each other's bus driver, though in practice this
+seldom occurs.  Be careful, and if in doubt, don't do it!
+
+Drives are normally found by auto-probing and/or examining the CMOS/BIOS data.
+For really weird situations, the apparent (fdisk) geometry can also be specified
+on the kernel "command line" using LILO.  The format of such lines is:
+
+	hdx=cyls,heads,sects,wpcom,irq
+or	hdx=cdrom
+
+where hdx can be any of hda through hdh, Three values are required
+(cyls,heads,sects).  For example:
+
+	hdc=1050,32,64  hdd=cdrom
+
+either {hda,hdb} or {hdc,hdd}.  The results of successful auto-probing may
+override the physical geometry/irq specified, though the "original" geometry
+may be retained as the "logical" geometry for partitioning purposes (fdisk).
+
+If the auto-probing during boot time confuses a drive (ie. the drive works
+with hd.c but not with ide.c), then an command line option may be specified
+for each drive for which you'd like the drive to skip the hardware
+probe/identification sequence.  For example:
+
+	hdb=noprobe
+or
+	hdc=768,16,32
+	hdc=noprobe
+
+Note that when only one IDE device is attached to an interface, it should be
+jumpered as "single" or "master", *not* "slave".  Many folks have had
+"trouble" with cdroms because of this requirement, so the driver now probes
+for both units, though success is more likely when the drive is jumpered
+correctly.
+
+Courtesy of Scott Snyder and others, the driver supports ATAPI cdrom drives
+such as the NEC-260 and the new MITSUMI triple/quad speed drives.
+Such drives will be identified at boot time, just like a hard disk.
+
+If for some reason your cdrom drive is *not* found at boot time, you can force
+the probe to look harder by supplying a kernel command line parameter
+via LILO, such as:
+
+	hdc=cdrom	/* hdc = "master" on second interface */
+or
+	hdd=cdrom	/* hdd = "slave" on second interface */
+
+For example, a GW2000 system might have a hard drive on the primary
+interface (/dev/hda) and an IDE cdrom drive on the secondary interface
+(/dev/hdc).  To mount a CD in the cdrom drive, one would use something like:
+
+	ln -sf /dev/hdc /dev/cdrom
+	mkdir /mnt/cdrom
+	mount /dev/cdrom /mnt/cdrom -t iso9660 -o ro
+
+If, after doing all of the above, mount doesn't work and you see
+errors from the driver (with dmesg) complaining about `status=0xff',
+this means that the hardware is not responding to the driver's attempts
+to read it.  One of the following is probably the problem:
+
+  - Your hardware is broken.
+
+  - You are using the wrong address for the device, or you have the
+    drive jumpered wrong.  Review the configuration instructions above.
+
+  - Your IDE controller requires some nonstandard initialization sequence
+    before it will work properly.  If this is the case, there will often
+    be a separate MS-DOS driver just for the controller.  IDE interfaces
+    on sound cards usually fall into this category.  Such configurations
+    can often be made to work by first booting MS-DOS, loading the
+    appropriate drivers, and then warm-booting linux (without powering
+    off).  This can be automated using loadlin in the MS-DOS autoexec.
+
+If you always get timeout errors, interrupts from the drive are probably
+not making it to the host.  Check how you have the hardware jumpered
+and make sure it matches what the driver expects (see the configuration
+instructions above).  If you have a PCI system, also check the BIOS
+setup; I've had one report of a system which was shipped with IRQ 15
+disabled by the BIOS.
+
+The kernel is able to execute binaries directly off of the cdrom,
+provided it is mounted with the default block size of 1024 (as above).
+
+Please pass on any feedback on any of this stuff to the maintainer,
+whose address can be found in linux/MAINTAINERS.
+
+Note that if BOTH hd.c and ide.c are configured into the kernel,
+hd.c will normally be allowed to control the primary IDE interface.
+This is useful for older hardware that may be incompatible with ide.c,
+and still allows newer hardware to run on the 2nd/3rd/4th IDE ports
+under control of ide.c.   To have ide.c also "take over" the primary
+IDE port in this situation, use the "command line" parameter:  ide0=0x1f0
+
+The IDE driver is modularized.  The high level disk/CD-ROM/tape/floppy
+drivers can always be compiled as loadable modules, the chipset drivers
+can only be compiled into the kernel, and the core code (ide.c) can be
+compiled as a loadable module provided no chipset support is needed.
+
+When using ide.c as a module in combination with kmod, add:
+
+	alias block-major-3 ide-probe
+
+to /etc/modprobe.conf.
+
+When ide.c is used as a module, you can pass command line parameters to the
+driver using the "options=" keyword to insmod, while replacing any ',' with
+';'.  For example:
+
+	insmod ide.o options="ide0=serialize ide1=serialize ide2=0x1e8;0x3ee;11"
+
+
+================================================================================
+
+Summary of ide driver parameters for kernel command line
+--------------------------------------------------------
+
+ "hdx="  is recognized for all "x" from "a" to "h", such as "hdc".
+
+ "idex=" is recognized for all "x" from "0" to "3", such as "ide1".
+
+ "hdx=noprobe"		: drive may be present, but do not probe for it
+
+ "hdx=none"		: drive is NOT present, ignore cmos and do not probe
+
+ "hdx=nowerr"		: ignore the WRERR_STAT bit on this drive
+
+ "hdx=cdrom"		: drive is present, and is a cdrom drive
+
+ "hdx=cyl,head,sect"	: disk drive is present, with specified geometry
+
+ "hdx=remap"		: remap access of sector 0 to sector 1 (for EZDrive)
+
+ "hdx=remap63"		: remap the drive: add 63 to all sector numbers
+			  (for DM OnTrack)
+
+ "idex=noautotune"	: driver will NOT attempt to tune interface speed
+
+ "hdx=autotune"		: driver will attempt to tune interface speed
+			  to the fastest PIO mode supported,
+			  if possible for this drive only.
+			  Not fully supported by all chipset types,
+			  and quite likely to cause trouble with
+			  older/odd IDE drives.
+
+ "hdx=nodma"		: disallow DMA
+
+ "hdx=scsi"		: the return of the ide-scsi flag, this is useful for
+ 			  allowing ide-floppy, ide-tape, and ide-cdrom|writers
+ 			  to use ide-scsi emulation on a device specific option.
+
+ "idebus=xx"		: inform IDE driver of VESA/PCI bus speed in MHz,
+			  where "xx" is between 20 and 66 inclusive,
+			  used when tuning chipset PIO modes.
+			  For PCI bus, 25 is correct for a P75 system,
+			  30 is correct for P90,P120,P180 systems,
+			  and 33 is used for P100,P133,P166 systems.
+			  If in doubt, use idebus=33 for PCI.
+			  As for VLB, it is safest to not specify it.
+			  Bigger values are safer than smaller ones.
+
+ "idex=base"		: probe for an interface at the addr specified,
+			  where "base" is usually 0x1f0 or 0x170
+			  and "ctl" is assumed to be "base"+0x206
+
+ "idex=base,ctl"	: specify both base and ctl
+
+ "idex=base,ctl,irq"	: specify base, ctl, and irq number
+
+ "idex=serialize"	: do not overlap operations on idex. Please note
+			  that you will have to specify this option for
+			  both the respective primary and secondary channel
+			  to take effect.
+
+ "idex=four"		: four drives on idex and ide(x^1) share same ports
+
+ "idex=reset"		: reset interface after probe
+
+ "idex=ata66"		: informs the interface that it has an 80c cable
+			  for chipsets that are ATA-66 capable, but the
+			  ability to bit test for detection is currently
+			  unknown.
+
+ "ide=reverse"		: formerly called to pci sub-system, but now local.
+
+The following are valid ONLY on ide0, which usually corresponds
+to the first ATA interface found on the particular host, and the defaults for
+the base,ctl ports must not be altered.
+
+ "ide=doubler"		: probe/support IDE doublers on Amiga
+
+There may be more options than shown -- use the source, Luke!
+
+Everything else is rejected with a "BAD OPTION" message.
+
+For legacy IDE VLB host drivers (ali14xx/dtc2278/ht6560b/qd65xx/umc8672)
+you need to explicitly enable probing by using "probe" kernel parameter,
+i.e. to enable probing for ALI M14xx chipsets (ali14xx host driver) use:
+
+* "ali14xx.probe" boot option when ali14xx driver is built-in the kernel
+
+* "probe" module parameter when ali14xx driver is compiled as module
+  ("modprobe ali14xx probe")
+
+Also for legacy CMD640 host driver (cmd640) you need to use "probe_vlb"
+kernel paremeter to enable probing for VLB version of the chipset (PCI ones
+are detected automatically).
+
+================================================================================
+
+Some Terminology
+----------------
+IDE = Integrated Drive Electronics, meaning that each drive has a built-in
+controller, which is why an "IDE interface card" is not a "controller card".
+
+ATA = AT (the old IBM 286 computer) Attachment Interface, a draft American
+National Standard for connecting hard drives to PCs.  This is the official
+name for "IDE".
+
+The latest standards define some enhancements, known as the ATA-6 spec,
+which grew out of vendor-specific "Enhanced IDE" (EIDE) implementations.
+
+ATAPI = ATA Packet Interface, a new protocol for controlling the drives,
+similar to SCSI protocols, created at the same time as the ATA2 standard.
+ATAPI is currently used for controlling CDROM, TAPE and FLOPPY (ZIP or
+LS120/240) devices, removable R/W cartridges, and for high capacity hard disk
+drives.
+
+mlord@pobox.com
+--
+
+Wed Apr 17 22:52:44 CEST 2002 edited by Marcin Dalecki, the current
+maintainer.
+
+Wed Aug 20 22:31:29 CEST 2003 updated ide boot options to current ide.c
+comments at 2.6.0-test4 time. Maciej Soltysiak <solt@dns.toxicfilms.tv>
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9a5b665..533e67f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -712,7 +712,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: <cyl>,<head>,<sect>
 
 	hd?=		[HW] (E)IDE subsystem
-	hd?lun=		See Documentation/ide.txt.
+	hd?lun=		See Documentation/ide/ide.txt.
 
 	highmem=nn[KMG]	[KNL,BOOT] forces the highmem zone to have an exact
 			size of <nn>. This works even on boxes that have no
@@ -766,14 +766,14 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	ide=		[HW] (E)IDE subsystem
 			Format: ide=nodma or ide=doubler or ide=reverse
-			See Documentation/ide.txt.
+			See Documentation/ide/ide.txt.
 
 	ide?=		[HW] (E)IDE subsystem
 			Format: ide?=noprobe or chipset specific parameters.
-			See Documentation/ide.txt.
+			See Documentation/ide/ide.txt.
 
 	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
-			See Documentation/ide.txt.
+			See Documentation/ide/ide.txt.
 
 	idle=		[X86]
 			Format: idle=poll or idle=mwait
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index df752e6..eed6d8e 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -50,7 +50,7 @@ menuconfig IDE
 	  To compile this driver as a module, choose M here: the
 	  module will be called ide.
 
-	  For further information, please read <file:Documentation/ide.txt>.
+	  For further information, please read <file:Documentation/ide/ide.txt>.
 
 	  If unsure, say Y.
 
@@ -77,7 +77,7 @@ config BLK_DEV_IDE
 	  Useful information about large (>540 MB) IDE disks, multiple
 	  interfaces, what to do if ATA/IDE devices are not automatically
 	  detected, sound card ATA/IDE ports, module support, and other
-	  topics, is contained in <file:Documentation/ide.txt>. For detailed
+	  topics, is contained in <file:Documentation/ide/ide.txt>. For detailed
 	  information about hard drives, consult the Disk-HOWTO and the
 	  Multi-Disk-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
@@ -87,7 +87,7 @@ config BLK_DEV_IDE
 	  <ftp://ibiblio.org/pub/Linux/system/hardware/>.
 
 	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/ide.txt>. The module will be called ide-mod.
+	  <file:Documentation/ide/ide.txt>. The module will be called ide-mod.
 	  Do not compile this driver as a module if your root file system (the
 	  one containing the directory /) is located on an IDE device.
 
@@ -98,7 +98,7 @@ config BLK_DEV_IDE
 
 if BLK_DEV_IDE
 
-comment "Please see Documentation/ide.txt for help/info on IDE drives"
+comment "Please see Documentation/ide/ide.txt for help/info on IDE drives"
 
 config BLK_DEV_IDE_SATA
 	bool "Support for SATA (deprecated; conflicts with libata SATA driver)"
@@ -235,8 +235,8 @@ config BLK_DEV_IDETAPE
 	  along with other IDE devices, as "hdb" or "hdc", or something
 	  similar, and will be mapped to a character device such as "ht0"
 	  (check the boot messages with dmesg).  Be sure to consult the
-	  <file:drivers/ide/ide-tape.c> and <file:Documentation/ide.txt> files
-	  for usage information.
+	  <file:drivers/ide/ide-tape.c> and <file:Documentation/ide/ide.txt>
+	  files for usage information.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ide-tape.
@@ -358,7 +358,7 @@ config BLK_DEV_CMD640
 
 	  The CMD640 chip is also used on add-in cards by Acculogic, and on
 	  the "CSA-6400E PCI to IDE controller" that some people have. For
-	  details, read <file:Documentation/ide.txt>.
+	  details, read <file:Documentation/ide/ide.txt>.
 
 config BLK_DEV_CMD640_ENHANCED
 	bool "CMD640 enhanced support"
@@ -366,7 +366,7 @@ config BLK_DEV_CMD640_ENHANCED
 	help
 	  This option includes support for setting/autotuning PIO modes and
 	  prefetch on CMD640 IDE interfaces.  For details, read
-	  <file:Documentation/ide.txt>. If you have a CMD640 IDE interface
+	  <file:Documentation/ide/ide.txt>. If you have a CMD640 IDE interface
 	  and your BIOS does not already do this for you, then say Y here.
 	  Otherwise say N.
 
@@ -1069,9 +1069,9 @@ config BLK_DEV_ALI14XX
 	  This driver is enabled at runtime using the "ali14xx.probe" kernel
 	  boot parameter.  It enables support for the secondary IDE interface
 	  of the ALI M1439/1443/1445/1487/1489 chipsets, and permits faster
-	  I/O speeds to be set as well.  See the files
-	  <file:Documentation/ide.txt> and <file:drivers/ide/legacy/ali14xx.c>
-	  for more info.
+	  I/O speeds to be set as well.
+	  See the files <file:Documentation/ide/ide.txt> and
+	  <file:drivers/ide/legacy/ali14xx.c> for more info.
 
 config BLK_DEV_DTC2278
 	tristate "DTC-2278 support"
@@ -1079,7 +1079,7 @@ config BLK_DEV_DTC2278
 	  This driver is enabled at runtime using the "dtc2278.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
 	  of the DTC-2278 card, and permits faster I/O speeds to be set as
-	  well. See the <file:Documentation/ide.txt> and
+	  well. See the <file:Documentation/ide/ide.txt> and
 	  <file:drivers/ide/legacy/dtc2278.c> files for more info.
 
 config BLK_DEV_HT6560B
@@ -1088,7 +1088,7 @@ config BLK_DEV_HT6560B
 	  This driver is enabled at runtime using the "ht6560b.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
 	  of the Holtek card, and permits faster I/O speeds to be set as well.
-	  See the <file:Documentation/ide.txt> and
+	  See the <file:Documentation/ide/ide.txt> and
 	  <file:drivers/ide/legacy/ht6560b.c> files for more info.
 
 config BLK_DEV_QD65XX
@@ -1096,7 +1096,7 @@ config BLK_DEV_QD65XX
 	help
 	  This driver is enabled at runtime using the "qd65xx.probe" kernel
 	  boot parameter.  It permits faster I/O speeds to be set.  See the
-	  <file:Documentation/ide.txt> and <file:drivers/ide/legacy/qd65xx.c>
+	  <file:Documentation/ide/ide.txt> and <file:drivers/ide/legacy/qd65xx.c>
 	  for more info.
 
 config BLK_DEV_UMC8672
@@ -1105,7 +1105,7 @@ config BLK_DEV_UMC8672
 	  This driver is enabled at runtime using the "umc8672.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
 	  of the UMC-8672, and permits faster I/O speeds to be set as well.
-	  See the files <file:Documentation/ide.txt> and
+	  See the files <file:Documentation/ide/ide.txt> and
 	  <file:drivers/ide/legacy/umc8672.c> for more info.
 
 endif
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index b68284d..6d147ce 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -457,6 +457,10 @@ int ide_cdrom_packet(struct cdrom_device_info *cdi,
 	   layer. the packet must be complete, as we do not
 	   touch it at all. */
 	ide_cd_init_rq(drive, &req);
+
+	if (cgc->data_direction == CGC_DATA_WRITE)
+		req.cmd_flags |= REQ_RW;
+
 	memcpy(req.cmd, cgc->cmd, CDROM_PACKET_SIZE);
 	if (cgc->sense)
 		memset(cgc->sense, 0, sizeof(struct request_sense));
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 2de99e4..d61e578 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -713,7 +713,7 @@ static int ide_tune_dma(ide_drive_t *drive)
 	}
 
 	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
-		return 0;
+		return 1;
 
 	if (ide_set_dma_mode(drive, speed))
 		return 0;
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index fa16bc3..9976f9d 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -667,7 +667,6 @@ int ide_register_hw(hw_regs_t *hw, void (*quirkproc)(ide_drive_t *),
 
 	do {
 		hwif = ide_deprecated_find_port(hw->io_ports[IDE_DATA_OFFSET]);
-		index = hwif->index;
 		if (hwif)
 			goto found;
 		for (index = 0; index < MAX_HWIFS; index++)
@@ -675,6 +674,7 @@ int ide_register_hw(hw_regs_t *hw, void (*quirkproc)(ide_drive_t *),
 	} while (retry--);
 	return -1;
 found:
+	index = hwif->index;
 	if (hwif->present)
 		ide_unregister(index, 0, 1);
 	else if (!hwif->hold)
@@ -1180,7 +1180,7 @@ static int __initdata is_chipset_set[MAX_HWIFS];
  * ide_setup() gets called VERY EARLY during initialization,
  * to handle kernel "command line" strings beginning with "hdx=" or "ide".
  *
- * Remember to update Documentation/ide.txt if you change something here.
+ * Remember to update Documentation/ide/ide.txt if you change something here.
  */
 static int __init ide_setup(char *s)
 {
