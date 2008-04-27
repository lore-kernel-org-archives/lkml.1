Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYD0OOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYD0OOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 10:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYD0ONq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 10:13:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:49219 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbYD0ON1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 10:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZJ0M6NRVYXfpdwEdo4wDnuy2koOLkzM9LJPevbRS/8TMagJ+VTWUB4t3JXMo/+PzmB4gU/qwuoSofYLGb29MLCtM+Y1M0gkD2C+BNJxgbAG4Xo37xruaSDnYok0fwKOEpMvjDhRGyoizw1t2Yw0nG2MP9aNw05TvE2Kfu3J0/i0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates part 4
Date: Sun, 27 Apr 2008 16:26:09 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804271626.10493.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


New day, new IDE updates...

- fix icside breakage caused by yesterday's updates (Al Viro)

- remove "pipelined" mode from ide-tape:
  - ~850 LOC gone with no loss of the functionality
  - performance impact should be negligable
  - makes the driver parseable for the mere mortals again
  - allows future driver enhancements
  (Borislav Petkov)

- remove the last user of /proc/ide/<chipset> interface (~250 LOC gone)
  (Alexey Dobriyan)

- add new interface for IDE kernel parameters
  - warm-plug / sysfs friendly (sysfs access to be enabled in the future)
  - simple (no internal parsing, -200 LOC when compared to the old one)
  - future proof (not dependent on the legacy naming of devices)

- misc changes


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/ide/ide-tape.txt      |  211 ++-----
 Documentation/ide/ide.txt           |  107 ++--
 Documentation/kernel-parameters.txt |    4 -
 drivers/ide/arm/bast-ide.c          |   12 +-
 drivers/ide/arm/icside.c            |   13 +-
 drivers/ide/arm/palm_bk3710.c       |   12 +-
 drivers/ide/arm/rapide.c            |    8 +-
 drivers/ide/cris/ide-cris.c         |   18 +-
 drivers/ide/h8300/ide-h8300.c       |    6 +-
 drivers/ide/ide-acpi.c              |   18 +-
 drivers/ide/ide-cd.c                |   12 +-
 drivers/ide/ide-floppy.c            |   12 +-
 drivers/ide/ide-io.c                |   42 +-
 drivers/ide/ide-iops.c              |   72 +--
 drivers/ide/ide-pnp.c               |    5 +-
 drivers/ide/ide-probe.c             |   73 +--
 drivers/ide/ide-proc.c              |    8 -
 drivers/ide/ide-tape.c              | 1191 ++++++-----------------------------
 drivers/ide/ide-taskfile.c          |   29 +-
 drivers/ide/ide.c                   |  360 ++++++-----
 drivers/ide/legacy/ali14xx.c        |    6 +-
 drivers/ide/legacy/buddha.c         |   14 +-
 drivers/ide/legacy/dtc2278.c        |    5 +-
 drivers/ide/legacy/falconide.c      |    6 +-
 drivers/ide/legacy/gayle.c          |   18 +-
 drivers/ide/legacy/ht6560b.c        |   11 +-
 drivers/ide/legacy/ide-4drives.c    |    2 +-
 drivers/ide/legacy/ide-cs.c         |   12 +-
 drivers/ide/legacy/ide_platform.c   |   10 +-
 drivers/ide/legacy/macide.c         |    4 +-
 drivers/ide/legacy/q40ide.c         |    6 +-
 drivers/ide/legacy/qd65xx.c         |   33 +-
 drivers/ide/legacy/umc8672.c        |    4 +-
 drivers/ide/mips/au1xxx-ide.c       |    7 +-
 drivers/ide/mips/swarm.c            |    6 +-
 drivers/ide/pci/aec62xx.c           |    2 +-
 drivers/ide/pci/alim15x3.c          |  242 +-------
 drivers/ide/pci/amd74xx.c           |    2 +-
 drivers/ide/pci/cmd640.c            |   89 +--
 drivers/ide/pci/cmd64x.c            |    6 +-
 drivers/ide/pci/cy82c693.c          |    4 +-
 drivers/ide/pci/delkin_cb.c         |    9 +-
 drivers/ide/pci/hpt366.c            |    2 +-
 drivers/ide/pci/ns87415.c           |   12 +-
 drivers/ide/pci/opti621.c           |    7 +-
 drivers/ide/pci/scc_pata.c          |   11 +-
 drivers/ide/pci/sgiioc4.c           |   27 +-
 drivers/ide/pci/siimage.c           |   27 +-
 drivers/ide/pci/trm290.c            |    2 +-
 drivers/ide/pci/via82cxxx.c         |    2 +-
 drivers/ide/ppc/mpc8xx.c            |   28 +-
 drivers/ide/ppc/pmac.c              |    7 +-
 drivers/scsi/ide-scsi.c             |   13 +-
 include/asm-arm/arch-sa1100/ide.h   |    6 +-
 include/asm-cris/arch-v10/ide.h     |   11 +-
 include/linux/ide.h                 |   95 ++--
 56 files changed, 892 insertions(+), 2069 deletions(-)


Al Viro (1):
      ide: fix icside breakage

Alexey Dobriyan (2):
      ide: remove /proc/ide/ali
      ide: remove now unused ide_pci_create_host_proc()

Bartlomiej Zolnierkiewicz (19):
      ide: add "ignore_cable" parameter (take 2)
      ide: remove obsoleted "idex=serialize" kernel parameter
      ide: remove obsoleted "idex=reset" kernel parameter
      ide: remove obsoleted "idex=" kernel parameters
      ide: remove obsoleted "hdx=noautotune" kernel parameter
      ide: add "vlb|pci_clock=" parameter
      ide: mark "idebus=" kernel parameter as obsoleted (take 2)
      ide: always auto-tune PIO in legacy VLB host drivers
      cmd640: always auto-tune PIO
      ide: remove IDE_HFLAG_NO_AUTOTUNE host flag
      ide: remove obsoleted "hdx=autotune" kernel parameter
      ide: add "nodma|noflush|noprobe|nowerr=" parameters
      ide: add "cdrom=" and "chs=" parameters
      gayle: add "doubler" parameter
      ide: add "noacpi" / "acpigtf" / "acpionboot" parameters
      mpc8xx-ide: use ide_find_port()
      ide: sanitize ide_unregister() usage
      ide: make ide_unregister() take 'ide_hwif_t *' as an argument (take 2)
      ide: add struct ide_io_ports (take 3)

Borislav Petkov (27):
      ide-tape: remove tape->cache_stage
      ide-tape: remove pipeline-specific code from idetape_add_chrdev_write_request
      ide-tape remove pipeline speed/control calculations
      ide-tape: remove pipeline-specific code from idetape_add_chrdev_read_request()
      ide-tape: remove unused parameter from idetape_copy_stage_to_user
      ide-tape: remove unused parameter from idetape_copy_stage_from_user
      ide-tape: remove pipeline-specific code in idetape_space_over_filemarks()
      ide-tape: remove idetape_pipeline_size()
      ide-tape: remove idetape_remove_stage_head()
      ide-tape: remove pipeline-specific code from idetape_end_request()
      ide-tape: unwrap idetape_queue_pc_tail()
      ide-tape: remove remaining pipeline functionality
      ide-tape: remove pipelined mode tape control flags
      ide-tape: remove pipeline-specific members from struct ide_tape_obj
      ide-tape: remove pipelined mode parameters
      ide-tape: remove misc references to pipelined operation in the comments
      ide-tape: remove pipelined mode description from Documentation/ide/ide-tape.txt
      ide-tape: remove comments markup from Documentation/ide/ide-tape.txt
      ide-tape: improve buffer allocation strategy
      ide-tape: mv tape->stage_size tape->buffer_size
      ide-tape: mv tape->pages_per_stage tape->pages_per_buffer
      ide-tape: improve buffer pages freeing strategy
      ide-tape: make __idetape_discard_read_pipeline() of type void
      ide-tape: mv idetape_discard_read_pipeline ide_tape_discard_merge_buffer
      ide-tape: mv idetape_empty_write_pipeline ide_tape_flush_merge_buffer
      ide-tape: mv tape->merge_stage_size tape->merge_bh_size
      ide-tape: remove tape->merge_stage


diff --git a/Documentation/ide/ide-tape.txt b/Documentation/ide/ide-tape.txt
index 658f271..3f348a0 100644
--- a/Documentation/ide/ide-tape.txt
+++ b/Documentation/ide/ide-tape.txt
@@ -1,146 +1,65 @@
-/*
- * IDE ATAPI streaming tape driver.
- *
- * This driver is a part of the Linux ide driver.
- *
- * The driver, in co-operation with ide.c, basically traverses the
- * request-list for the block device interface. The character device
- * interface, on the other hand, creates new requests, adds them
- * to the request-list of the block device, and waits for their completion.
- *
- * Pipelined operation mode is now supported on both reads and writes.
- *
- * The block device major and minor numbers are determined from the
- * tape's relative position in the ide interfaces, as explained in ide.c.
- *
- * The character device interface consists of the following devices:
- *
- * ht0		major 37, minor 0	first  IDE tape, rewind on close.
- * ht1		major 37, minor 1	second IDE tape, rewind on close.
- * ...
- * nht0		major 37, minor 128	first  IDE tape, no rewind on close.
- * nht1		major 37, minor 129	second IDE tape, no rewind on close.
- * ...
- *
- * The general magnetic tape commands compatible interface, as defined by
- * include/linux/mtio.h, is accessible through the character device.
- *
- * General ide driver configuration options, such as the interrupt-unmask
- * flag, can be configured by issuing an ioctl to the block device interface,
- * as any other ide device.
- *
- * Our own ide-tape ioctl's can be issued to either the block device or
- * the character device interface.
- *
- * Maximal throughput with minimal bus load will usually be achieved in the
- * following scenario:
- *
- *	1.	ide-tape is operating in the pipelined operation mode.
- *	2.	No buffering is performed by the user backup program.
- *
- * Testing was done with a 2 GB CONNER CTMA 4000 IDE ATAPI Streaming Tape Drive.
- *
- * Here are some words from the first releases of hd.c, which are quoted
- * in ide.c and apply here as well:
- *
- * | Special care is recommended.  Have Fun!
- *
- *
- * An overview of the pipelined operation mode.
- *
- * In the pipelined write mode, we will usually just add requests to our
- * pipeline and return immediately, before we even start to service them. The
- * user program will then have enough time to prepare the next request while
- * we are still busy servicing previous requests. In the pipelined read mode,
- * the situation is similar - we add read-ahead requests into the pipeline,
- * before the user even requested them.
- *
- * The pipeline can be viewed as a "safety net" which will be activated when
- * the system load is high and prevents the user backup program from keeping up
- * with the current tape speed. At this point, the pipeline will get
- * shorter and shorter but the tape will still be streaming at the same speed.
- * Assuming we have enough pipeline stages, the system load will hopefully
- * decrease before the pipeline is completely empty, and the backup program
- * will be able to "catch up" and refill the pipeline again.
- *
- * When using the pipelined mode, it would be best to disable any type of
- * buffering done by the user program, as ide-tape already provides all the
- * benefits in the kernel, where it can be done in a more efficient way.
- * As we will usually not block the user program on a request, the most
- * efficient user code will then be a simple read-write-read-... cycle.
- * Any additional logic will usually just slow down the backup process.
- *
- * Using the pipelined mode, I get a constant over 400 KBps throughput,
- * which seems to be the maximum throughput supported by my tape.
- *
- * However, there are some downfalls:
- *
- *	1.	We use memory (for data buffers) in proportional to the number
- *		of pipeline stages (each stage is about 26 KB with my tape).
- *	2.	In the pipelined write mode, we cheat and postpone error codes
- *		to the user task. In read mode, the actual tape position
- *		will be a bit further than the last requested block.
- *
- * Concerning (1):
- *
- *	1.	We allocate stages dynamically only when we need them. When
- *		we don't need them, we don't consume additional memory. In
- *		case we can't allocate stages, we just manage without them
- *		(at the expense of decreased throughput) so when Linux is
- *		tight in memory, we will not pose additional difficulties.
- *
- *	2.	The maximum number of stages (which is, in fact, the maximum
- *		amount of memory) which we allocate is limited by the compile
- *		time parameter IDETAPE_MAX_PIPELINE_STAGES.
- *
- *	3.	The maximum number of stages is a controlled parameter - We
- *		don't start from the user defined maximum number of stages
- *		but from the lower IDETAPE_MIN_PIPELINE_STAGES (again, we
- *		will not even allocate this amount of stages if the user
- *		program can't handle the speed). We then implement a feedback
- *		loop which checks if the pipeline is empty, and if it is, we
- *		increase the maximum number of stages as necessary until we
- *		reach the optimum value which just manages to keep the tape
- *		busy with minimum allocated memory or until we reach
- *		IDETAPE_MAX_PIPELINE_STAGES.
- *
- * Concerning (2):
- *
- *	In pipelined write mode, ide-tape can not return accurate error codes
- *	to the user program since we usually just add the request to the
- *      pipeline without waiting for it to be serviced. In case an error
- *      occurs, I will report it on the next user request.
- *
- *	In the pipelined read mode, subsequent read requests or forward
- *	filemark spacing will perform correctly, as we preserve all blocks
- *	and filemarks which we encountered during our excess read-ahead.
- *
- *	For accurate tape positioning and error reporting, disabling
- *	pipelined mode might be the best option.
- *
- * You can enable/disable/tune the pipelined operation mode by adjusting
- * the compile time parameters below.
- *
- *
- *	Possible improvements.
- *
- *	1.	Support for the ATAPI overlap protocol.
- *
- *		In order to maximize bus throughput, we currently use the DSC
- *		overlap method which enables ide.c to service requests from the
- *		other device while the tape is busy executing a command. The
- *		DSC overlap method involves polling the tape's status register
- *		for the DSC bit, and servicing the other device while the tape
- *		isn't ready.
- *
- *		In the current QIC development standard (December 1995),
- *		it is recommended that new tape drives will *in addition*
- *		implement the ATAPI overlap protocol, which is used for the
- *		same purpose - efficient use of the IDE bus, but is interrupt
- *		driven and thus has much less CPU overhead.
- *
- *		ATAPI overlap is likely to be supported in most new ATAPI
- *		devices, including new ATAPI cdroms, and thus provides us
- *		a method by which we can achieve higher throughput when
- *		sharing a (fast) ATA-2 disk with any (slow) new ATAPI device.
- */
+IDE ATAPI streaming tape driver.
+
+This driver is a part of the Linux ide driver.
+
+The driver, in co-operation with ide.c, basically traverses the
+request-list for the block device interface. The character device
+interface, on the other hand, creates new requests, adds them
+to the request-list of the block device, and waits for their completion.
+
+The block device major and minor numbers are determined from the
+tape's relative position in the ide interfaces, as explained in ide.c.
+
+The character device interface consists of the following devices:
+
+ht0		major 37, minor 0	first  IDE tape, rewind on close.
+ht1		major 37, minor 1	second IDE tape, rewind on close.
+...
+nht0		major 37, minor 128	first  IDE tape, no rewind on close.
+nht1		major 37, minor 129	second IDE tape, no rewind on close.
+...
+
+The general magnetic tape commands compatible interface, as defined by
+include/linux/mtio.h, is accessible through the character device.
+
+General ide driver configuration options, such as the interrupt-unmask
+flag, can be configured by issuing an ioctl to the block device interface,
+as any other ide device.
+
+Our own ide-tape ioctl's can be issued to either the block device or
+the character device interface.
+
+Maximal throughput with minimal bus load will usually be achieved in the
+following scenario:
+
+     1.	ide-tape is operating in the pipelined operation mode.
+     2.	No buffering is performed by the user backup program.
+
+Testing was done with a 2 GB CONNER CTMA 4000 IDE ATAPI Streaming Tape Drive.
+
+Here are some words from the first releases of hd.c, which are quoted
+in ide.c and apply here as well:
+
+| Special care is recommended.  Have Fun!
+
+Possible improvements:
+
+1. Support for the ATAPI overlap protocol.
+
+In order to maximize bus throughput, we currently use the DSC
+overlap method which enables ide.c to service requests from the
+other device while the tape is busy executing a command. The
+DSC overlap method involves polling the tape's status register
+for the DSC bit, and servicing the other device while the tape
+isn't ready.
+
+In the current QIC development standard (December 1995),
+it is recommended that new tape drives will *in addition*
+implement the ATAPI overlap protocol, which is used for the
+same purpose - efficient use of the IDE bus, but is interrupt
+driven and thus has much less CPU overhead.
+
+ATAPI overlap is likely to be supported in most new ATAPI
+devices, including new ATAPI cdroms, and thus provides us
+a method by which we can achieve higher throughput when
+sharing a (fast) ATA-2 disk with any (slow) new ATAPI device.
diff --git a/Documentation/ide/ide.txt b/Documentation/ide/ide.txt
index 486c699..0c78f4b 100644
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -82,27 +82,26 @@ Drives are normally found by auto-probing and/or examining the CMOS/BIOS data.
 For really weird situations, the apparent (fdisk) geometry can also be specified
 on the kernel "command line" using LILO.  The format of such lines is:
 
-	hdx=cyls,heads,sects
-or	hdx=cdrom
+	ide_core.chs=[interface_number.device_number]:cyls,heads,sects
+or	ide_core.cdrom=[interface_number.device_number]
 
-where hdx can be any of hda through hdh, Three values are required
-(cyls,heads,sects).  For example:
+For example:
 
-	hdc=1050,32,64  hdd=cdrom
+	ide_core.chs=1.0:1050,32,64  ide_core.cdrom=1.1
 
-either {hda,hdb} or {hdc,hdd}.  The results of successful auto-probing may
-override the physical geometry/irq specified, though the "original" geometry
-may be retained as the "logical" geometry for partitioning purposes (fdisk).
+The results of successful auto-probing may override the physical geometry/irq
+specified, though the "original" geometry may be retained as the "logical"
+geometry for partitioning purposes (fdisk).
 
 If the auto-probing during boot time confuses a drive (ie. the drive works
 with hd.c but not with ide.c), then an command line option may be specified
 for each drive for which you'd like the drive to skip the hardware
 probe/identification sequence.  For example:
 
-	hdb=noprobe
+	ide_core.noprobe=0.1
 or
-	hdc=768,16,32
-	hdc=noprobe
+	ide_core.chs=1.0:768,16,32
+	ide_core.noprobe=1.0
 
 Note that when only one IDE device is attached to an interface, it should be
 jumpered as "single" or "master", *not* "slave".  Many folks have had
@@ -118,9 +117,9 @@ If for some reason your cdrom drive is *not* found at boot time, you can force
 the probe to look harder by supplying a kernel command line parameter
 via LILO, such as:
 
-	hdc=cdrom	/* hdc = "master" on second interface */
+	ide_core.cdrom=1.0	/* "master" on second interface (hdc) */
 or
-	hdd=cdrom	/* hdd = "slave" on second interface */
+	ide_core.cdrom=1.1	/* "slave" on second interface (hdd) */
 
 For example, a GW2000 system might have a hard drive on the primary
 interface (/dev/hda) and an IDE cdrom drive on the secondary interface
@@ -174,9 +173,7 @@ to /etc/modprobe.conf.
 
 When ide.c is used as a module, you can pass command line parameters to the
 driver using the "options=" keyword to insmod, while replacing any ',' with
-';'.  For example:
-
-	insmod ide.o options="hda=nodma hdb=nodma"
+';'.
 
 
 ================================================================================
@@ -184,57 +181,6 @@ driver using the "options=" keyword to insmod, while replacing any ',' with
 Summary of ide driver parameters for kernel command line
 --------------------------------------------------------
 
- "hdx="  is recognized for all "x" from "a" to "u", such as "hdc".
-
- "idex=" is recognized for all "x" from "0" to "9", such as "ide1".
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
- "hdx=autotune"		: driver will attempt to tune interface speed
-			  to the fastest PIO mode supported,
-			  if possible for this drive only.
-			  Not fully supported by all chipset types,
-			  and quite likely to cause trouble with
-			  older/odd IDE drives.
-
- "hdx=nodma"		: disallow DMA
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
- "idex=serialize"	: do not overlap operations on idex. Please note
-			  that you will have to specify this option for
-			  both the respective primary and secondary channel
-			  to take effect.
-
- "idex=reset"		: reset interface after probe
-
- "idex=ata66"		: informs the interface that it has an 80c cable
-			  for chipsets that are ATA-66 capable, but the
-			  ability to bit test for detection is currently
-			  unknown.
-
- "ide=doubler"		: probe/support IDE doublers on Amiga
-
-There may be more options than shown -- use the source, Luke!
-
-Everything else is rejected with a "BAD OPTION" message.
-
 For legacy IDE VLB host drivers (ali14xx/dtc2278/ht6560b/qd65xx/umc8672)
 you need to explicitly enable probing by using "probe" kernel parameter,
 i.e. to enable probing for ALI M14xx chipsets (ali14xx host driver) use:
@@ -251,6 +197,33 @@ are detected automatically).
 You also need to use "probe" kernel parameter for ide-4drives driver
 (support for IDE generic chipset with four drives on one port).
 
+To enable support for IDE doublers on Amiga use "doubler" kernel parameter
+for gayle host driver (i.e. "gayle.doubler" if the driver is built-in).
+
+To force ignoring cable detection (this should be needed only if you're using
+short 40-wires cable which cannot be automatically detected - if this is not
+a case please report it as a bug instead) use "ignore_cable" kernel parameter:
+
+* "ide_core.ignore_cable=[interface_number]" boot option if IDE is built-in
+  (i.e. "ide_core.ignore_cable=1" to force ignoring cable for "ide1")
+
+* "ignore_cable=[interface_number]" module parameter (for ide_core module)
+  if IDE is compiled as module
+
+Other kernel parameters for ide_core are:
+
+* "nodma=[interface_number.device_number]" to disallow DMA for a device
+
+* "noflush=[interface_number.device_number]" to disable flush requests
+
+* "noprobe=[interface_number.device_number]" to skip probing
+
+* "nowerr=[interface_number.device_number]" to ignore the WRERR_STAT bit
+
+* "cdrom=[interface_number.device_number]" to force device as a CD-ROM
+
+* "chs=[interface_number.device_number]" to force device as a disk (using CHS)
+
 ================================================================================
 
 Some Terminology
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index bf6303e..e5f3d91 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -772,10 +772,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: ide=nodma or ide=doubler
 			See Documentation/ide/ide.txt.
 
-	ide?=		[HW] (E)IDE subsystem
-			Format: ide?=ata66 or chipset specific parameters.
-			See Documentation/ide/ide.txt.
-
 	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
 			See Documentation/ide/ide.txt.
 
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
index d158f57..713cef2 100644
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -35,12 +35,12 @@ static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 	base += BAST_IDE_CS;
 	aux  += BAST_IDE_CS;
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw.io_ports[i] = (unsigned long)base;
+	for (i = 0; i <= 7; i++) {
+		hw.io_ports_array[i] = (unsigned long)base;
 		base += 0x20;
 	}
 
-	hw.io_ports[IDE_CONTROL_OFFSET] = aux + (6 * 0x20);
+	hw.io_ports.ctl_addr = aux + (6 * 0x20);
 	hw.irq = irq;
 
 	hwif = ide_find_port();
@@ -49,11 +49,7 @@ static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 
 	i = hwif->index;
 
-	if (hwif->present)
-		ide_unregister(i);
-	else
-		ide_init_port_data(hwif, i);
-
+	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 	hwif->port_ops = NULL;
 
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 7d642f4..124445c 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -426,11 +426,12 @@ icside_setup(void __iomem *base, struct cardinfo *info, struct expansion_card *e
 		 */
 		default_hwif_mmiops(hwif);
 
-		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-			hwif->io_ports[i] = port;
+		for (i = 0; i <= 7; i++) {
+			hwif->io_ports_array[i] = port;
 			port += 1 << info->stepping;
 		}
-		hwif->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)base + info->ctrloffset;
+		hwif->io_ports.ctl_addr =
+			(unsigned long)base + info->ctrloffset;
 		hwif->irq     = ec->irq;
 		hwif->chipset = ide_acorn;
 		hwif->gendev.parent = &ec->dev;
@@ -480,8 +481,7 @@ static const struct ide_port_info icside_v6_port_info __initdata = {
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
 	.dma_ops		= &icside_v6_dma_ops,
-	.host_flags		= IDE_HFLAG_SERIALIZE |
-				  IDE_HFLAG_NO_AUTOTUNE,
+	.host_flags		= IDE_HFLAG_SERIALIZE,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
 };
@@ -547,14 +547,13 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	hwif->config_data = (unsigned long)ioc_base;
 	hwif->select_data = sel;
 
-	mate->maskproc    = icside_maskproc;
 	mate->hwif_data   = state;
 	mate->config_data = (unsigned long)ioc_base;
 	mate->select_data = sel | 1;
 
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
 		d.init_dma = icside_dma_init;
-		d.port_ops = &icside_v6_dma_port_ops;
+		d.port_ops = &icside_v6_port_ops;
 		d.dma_ops = NULL;
 	}
 
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index 8fa34e2..aaf3254 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -321,7 +321,7 @@ static int __devinit palm_bk3710_init_dma(ide_hwif_t *hwif,
 					  const struct ide_port_info *d)
 {
 	unsigned long base =
-		hwif->io_ports[IDE_DATA_OFFSET] - IDE_PALM_ATA_PRI_REG_OFFSET;
+		hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
 
 	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
 
@@ -386,8 +386,8 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 
 	pribase = mem->start + IDE_PALM_ATA_PRI_REG_OFFSET;
 	for (i = 0; i < IDE_NR_PORTS - 2; i++)
-		hw.io_ports[i] = pribase + i;
-	hw.io_ports[IDE_CONTROL_OFFSET] = mem->start +
+		hw.io_ports_array[i] = pribase + i;
+	hw.io_ports.ctl_addr = mem->start +
 			IDE_PALM_ATA_PRI_CTL_OFFSET;
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
@@ -398,11 +398,7 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 
 	i = hwif->index;
 
-	if (hwif->present)
-		ide_unregister(i);
-	else
-		ide_init_port_data(hwif, i);
-
+	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 
 	hwif->mmio = 1;
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index c0581bd..babc1a5 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -17,11 +17,11 @@ static void rapide_setup_ports(hw_regs_t *hw, void __iomem *base,
 	unsigned long port = (unsigned long)base;
 	int i;
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw->io_ports[i] = port;
+	for (i = 0; i <= 7; i++) {
+		hw->io_ports_array[i] = port;
 		port += sz;
 	}
-	hw->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
+	hw->io_ports.ctl_addr = (unsigned long)ctrl;
 	hw->irq = irq;
 }
 
@@ -75,7 +75,7 @@ static void __devexit rapide_remove(struct expansion_card *ec)
 
 	ecard_set_drvdata(ec, NULL);
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif);
 
 	ecard_release_resources(ec);
 }
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index a62ca75..9df2685 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -88,8 +88,8 @@ enum /* Transfer types */
 int
 cris_ide_ack_intr(ide_hwif_t* hwif)
 {
-	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2,
-	                         int, hwif->io_ports[0]);
+	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
+					       hwif->io_ports.data_addr);
 	REG_WR_INT(ata, regi_ata, rw_ack_intr, 1 << ctrl2.sel);
 	return 1;
 }
@@ -231,7 +231,7 @@ cris_ide_start_dma(ide_drive_t *drive, cris_dma_descr_type *d, int dir,int type,
 	ide_hwif_t *hwif = drive->hwif;
 
 	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
-					       hwif->io_ports[IDE_DATA_OFFSET]);
+					       hwif->io_ports.data_addr);
 	reg_ata_rw_trf_cnt trf_cnt = {0};
 
 	mycontext.saved_data = (dma_descr_data*)virt_to_phys(d);
@@ -271,7 +271,7 @@ static int cris_dma_test_irq(ide_drive_t *drive)
 	int intr = REG_RD_INT(ata, regi_ata, r_intr);
 
 	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
-					       hwif->io_ports[IDE_DATA_OFFSET]);
+					       hwif->io_ports.data_addr);
 
 	return intr & (1 << ctrl2.sel) ? 1 : 0;
 }
@@ -531,7 +531,7 @@ static void cris_ide_start_dma(ide_drive_t *drive, cris_dma_descr_type *d, int d
 	*R_ATA_CTRL_DATA =
 		cmd |
 		IO_FIELD(R_ATA_CTRL_DATA, data,
-			 drive->hwif->io_ports[IDE_DATA_OFFSET]) |
+			 drive->hwif->io_ports.data_addr) |
 		IO_STATE(R_ATA_CTRL_DATA, src_dst,  dma)  |
 		IO_STATE(R_ATA_CTRL_DATA, multi,    on)   |
 		IO_STATE(R_ATA_CTRL_DATA, dma_size, word);
@@ -550,7 +550,7 @@ static int cris_dma_test_irq(ide_drive_t *drive)
 {
 	int intr = *R_IRQ_MASK0_RD;
 	int bus = IO_EXTRACT(R_ATA_CTRL_DATA, sel,
-			     drive->hwif->io_ports[IDE_DATA_OFFSET]);
+			     drive->hwif->io_ports.data_addr);
 
 	return intr & (1 << (bus + IO_BITNR(R_IRQ_MASK0_RD, ata_irq0))) ? 1 : 0;
 }
@@ -644,7 +644,7 @@ cris_ide_inw(unsigned long reg) {
 		 * call will also timeout on busy, but as long as the
 		 * write is still performed, everything will be fine.
 		 */
-		if (cris_ide_get_reg(reg) == IDE_STATUS_OFFSET)
+		if (cris_ide_get_reg(reg) == 7)
 			return BUSY_STAT;
 		else
 			/* For other rare cases we assume 0 is good enough.  */
@@ -765,13 +765,13 @@ static void __init cris_setup_ports(hw_regs_t *hw, unsigned long base)
 	memset(hw, 0, sizeof(*hw));
 
 	for (i = 0; i <= 7; i++)
-		hw->io_ports[i] = base + cris_ide_reg_addr(i, 0, 1);
+		hw->io_ports_array[i] = base + cris_ide_reg_addr(i, 0, 1);
 
 	/*
 	 * the IDE control register is at ATA address 6,
 	 * with CS1 active instead of CS0
 	 */
-	hw->io_ports[IDE_CONTROL_OFFSET] = base + cris_ide_reg_addr(6, 1, 0);
+	hw->io_ports.ctl_addr = base + cris_ide_reg_addr(6, 1, 0);
 
 	hw->irq = ide_default_irq(0);
 	hw->ack_intr = cris_ide_ack_intr;
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index 0708b29..fd23f12 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -63,9 +63,9 @@ static inline void hw_setup(hw_regs_t *hw)
 	int i;
 
 	memset(hw, 0, sizeof(hw_regs_t));
-	for (i = 0; i <= IDE_STATUS_OFFSET; i++)
-		hw->io_ports[i] = CONFIG_H8300_IDE_BASE + H8300_IDE_GAP*i;
-	hw->io_ports[IDE_CONTROL_OFFSET] = CONFIG_H8300_IDE_ALT;
+	for (i = 0; i <= 7; i++)
+		hw->io_ports_array[i] = CONFIG_H8300_IDE_BASE + H8300_IDE_GAP*i;
+	hw->io_ports.ctl_addr = CONFIG_H8300_IDE_ALT;
 	hw->irq = EXT_IRQ0 + CONFIG_H8300_IDE_IRQ;
 	hw->chipset = ide_generic;
 }
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index e4ad26e..9d3601f 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -60,9 +60,17 @@ struct ide_acpi_hwif_link {
 #define DEBPRINT(fmt, args...)	do {} while (0)
 #endif	/* DEBUGGING */
 
-extern int ide_noacpi;
-extern int ide_noacpitfs;
-extern int ide_noacpionboot;
+int ide_noacpi;
+module_param_named(noacpi, ide_noacpi, bool, 0);
+MODULE_PARM_DESC(noacpi, "disable IDE ACPI support");
+
+int ide_acpigtf;
+module_param_named(acpigtf, ide_acpigtf, bool, 0);
+MODULE_PARM_DESC(acpigtf, "enable IDE ACPI _GTF support");
+
+int ide_acpionboot;
+module_param_named(acpionboot, ide_acpionboot, bool, 0);
+MODULE_PARM_DESC(acpionboot, "call IDE ACPI methods on boot");
 
 static bool ide_noacpi_psx;
 static int no_acpi_psx(const struct dmi_system_id *id)
@@ -376,7 +384,7 @@ static int taskfile_load_raw(ide_drive_t *drive,
 	memcpy(&args.tf_array[7], &gtf->tfa, 7);
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	if (ide_noacpitfs) {
+	if (!ide_acpigtf) {
 		DEBPRINT("_GTF execution disabled\n");
 		return err;
 	}
@@ -721,7 +729,7 @@ void ide_acpi_port_init_devices(ide_hwif_t *hwif)
 				 drive->name, err);
 	}
 
-	if (ide_noacpionboot) {
+	if (!ide_acpionboot) {
 		DEBPRINT("ACPI methods disabled on boot\n");
 		return;
 	}
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index ad98432..b34fd2b 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -560,7 +560,7 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 		/* packet command */
 		spin_lock_irqsave(&ide_lock, flags);
 		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
-			       hwif->io_ports[IDE_COMMAND_OFFSET]);
+			       hwif->io_ports.command_addr);
 		ndelay(400);
 		spin_unlock_irqrestore(&ide_lock, flags);
 
@@ -952,9 +952,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	}
 
 	/* ok we fall to pio :/ */
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]) & 0x3;
-	lowcyl  = hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
-	highcyl = hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr) & 0x3;
+	lowcyl  = hwif->INB(hwif->io_ports.lbam_addr);
+	highcyl = hwif->INB(hwif->io_ports.lbah_addr);
 
 	len = lowcyl + (256 * highcyl);
 
@@ -1909,9 +1909,7 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	/* set correct block size */
 	blk_queue_hardsect_size(drive->queue, CD_FRAMESIZE);
 
-	if (drive->autotune == IDE_TUNE_DEFAULT ||
-	    drive->autotune == IDE_TUNE_AUTO)
-		drive->dsc_overlap = (drive->next != drive);
+	drive->dsc_overlap = (drive->next != drive);
 
 	if (ide_cdrom_register(drive, nslots)) {
 		printk(KERN_ERR "%s: %s failed to register device with the"
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 6e891bc..489079b 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -465,10 +465,10 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 	}
 
 	/* Get the number of bytes to transfer */
-	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
-		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
+	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
+		  hwif->INB(hwif->io_ports.lbam_addr);
 	/* on this interrupt */
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __func__);
@@ -539,7 +539,7 @@ static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
 				"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) while "
 				"issuing a packet command\n");
@@ -586,7 +586,7 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 				"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) "
 				"while issuing a packet command\n");
@@ -692,7 +692,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
 		return (*pkt_xfer_routine) (drive);
 	}
 }
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 0fe89a5..3a2d893 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -298,48 +298,43 @@ static void ide_complete_pm_request (ide_drive_t *drive, struct request *rq)
 void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
 
 	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data = hwif->INW(hwif->io_ports[IDE_DATA_OFFSET]);
+		u16 data = hwif->INW(io_ports->data_addr);
 
 		tf->data = data & 0xff;
 		tf->hob_data = (data >> 8) & 0xff;
 	}
 
 	/* be sure we're looking at the low order bits */
-	hwif->OUTB(drive->ctl & ~0x80, hwif->io_ports[IDE_CONTROL_OFFSET]);
+	hwif->OUTB(drive->ctl & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = hwif->INB(hwif->io_ports[IDE_NSECTOR_OFFSET]);
+		tf->nsect  = hwif->INB(io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = hwif->INB(hwif->io_ports[IDE_SECTOR_OFFSET]);
+		tf->lbal   = hwif->INB(io_ports->lbal_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = hwif->INB(hwif->io_ports[IDE_LCYL_OFFSET]);
+		tf->lbam   = hwif->INB(io_ports->lbam_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = hwif->INB(hwif->io_ports[IDE_HCYL_OFFSET]);
+		tf->lbah   = hwif->INB(io_ports->lbah_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = hwif->INB(hwif->io_ports[IDE_SELECT_OFFSET]);
+		tf->device = hwif->INB(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		hwif->OUTB(drive->ctl | 0x80,
-			   hwif->io_ports[IDE_CONTROL_OFFSET]);
+		hwif->OUTB(drive->ctl | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature =
-				hwif->INB(hwif->io_ports[IDE_FEATURE_OFFSET]);
+			tf->hob_feature = hwif->INB(io_ports->feature_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   =
-				hwif->INB(hwif->io_ports[IDE_NSECTOR_OFFSET]);
+			tf->hob_nsect   = hwif->INB(io_ports->nsect_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    =
-				hwif->INB(hwif->io_ports[IDE_SECTOR_OFFSET]);
+			tf->hob_lbal    = hwif->INB(io_ports->lbal_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    =
-				hwif->INB(hwif->io_ports[IDE_LCYL_OFFSET]);
+			tf->hob_lbam    = hwif->INB(io_ports->lbam_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    =
-				hwif->INB(hwif->io_ports[IDE_HCYL_OFFSET]);
+			tf->hob_lbah    = hwif->INB(io_ports->lbah_addr);
 	}
 }
 
@@ -454,7 +449,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 		if (err == ABRT_ERR) {
 			if (drive->select.b.lba &&
 			    /* some newer drives don't support WIN_SPECIFY */
-			    hwif->INB(hwif->io_ports[IDE_COMMAND_OFFSET]) ==
+			    hwif->INB(hwif->io_ports.command_addr) ==
 				WIN_SPECIFY)
 				return ide_stopped;
 		} else if ((err & BAD_CRC) == BAD_CRC) {
@@ -507,8 +502,7 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE,
-			   hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTB(WIN_IDLEIMMEDIATE, hwif->io_ports.command_addr);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
@@ -1421,7 +1415,7 @@ static void unexpected_intr (int irq, ide_hwgroup_t *hwgroup)
 	 */
 	do {
 		if (hwif->irq == irq) {
-			stat = hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+			stat = hwif->INB(hwif->io_ports.status_addr);
 			if (!OK_STAT(stat, READY_STAT, BAD_STAT)) {
 				/* Try to not flood the console with msgs */
 				static unsigned long last_msgtime, count;
@@ -1511,7 +1505,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 			 * Whack the status register, just in case
 			 * we have a leftover pending IRQ.
 			 */
-			(void) hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+			(void) hwif->INB(hwif->io_ports.status_addr);
 #endif /* CONFIG_BLK_DEV_IDEPCI */
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 9c646bd..5425d30 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -164,7 +164,7 @@ void SELECT_DRIVE (ide_drive_t *drive)
 	if (port_ops && port_ops->selectproc)
 		port_ops->selectproc(drive);
 
-	hwif->OUTB(drive->select.all, hwif->io_ports[IDE_SELECT_OFFSET]);
+	hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
 }
 
 void SELECT_MASK (ide_drive_t *drive, int mask)
@@ -194,24 +194,22 @@ static void ata_vlb_sync(ide_drive_t *drive, unsigned long port)
  */
 static void ata_input_data(ide_drive_t *drive, void *buffer, u32 wcount)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 io_32bit		= drive->io_32bit;
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	u8 io_32bit = drive->io_32bit;
 
 	if (io_32bit) {
 		if (io_32bit & 2) {
 			unsigned long flags;
 
 			local_irq_save(flags);
-			ata_vlb_sync(drive, hwif->io_ports[IDE_NSECTOR_OFFSET]);
-			hwif->INSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-				   wcount);
+			ata_vlb_sync(drive, io_ports->nsect_addr);
+			hwif->INSL(io_ports->data_addr, buffer, wcount);
 			local_irq_restore(flags);
 		} else
-			hwif->INSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-				   wcount);
+			hwif->INSL(io_ports->data_addr, buffer, wcount);
 	} else
-		hwif->INSW(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-			   wcount << 1);
+		hwif->INSW(io_ports->data_addr, buffer, wcount << 1);
 }
 
 /*
@@ -219,24 +217,22 @@ static void ata_input_data(ide_drive_t *drive, void *buffer, u32 wcount)
  */
 static void ata_output_data(ide_drive_t *drive, void *buffer, u32 wcount)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 io_32bit		= drive->io_32bit;
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	u8 io_32bit = drive->io_32bit;
 
 	if (io_32bit) {
 		if (io_32bit & 2) {
 			unsigned long flags;
 
 			local_irq_save(flags);
-			ata_vlb_sync(drive, hwif->io_ports[IDE_NSECTOR_OFFSET]);
-			hwif->OUTSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-				    wcount);
+			ata_vlb_sync(drive, io_ports->nsect_addr);
+			hwif->OUTSL(io_ports->data_addr, buffer, wcount);
 			local_irq_restore(flags);
 		} else
-			hwif->OUTSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-				    wcount);
+			hwif->OUTSL(io_ports->data_addr, buffer, wcount);
 	} else
-		hwif->OUTSW(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-			    wcount << 1);
+		hwif->OUTSW(io_ports->data_addr, buffer, wcount << 1);
 }
 
 /*
@@ -255,14 +251,13 @@ static void atapi_input_bytes(ide_drive_t *drive, void *buffer, u32 bytecount)
 #if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
 	if (MACH_IS_ATARI || MACH_IS_Q40) {
 		/* Atari has a byte-swapped IDE interface */
-		insw_swapw(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-			   bytecount / 2);
+		insw_swapw(hwif->io_ports.data_addr, buffer, bytecount / 2);
 		return;
 	}
 #endif /* CONFIG_ATARI || CONFIG_Q40 */
 	hwif->ata_input_data(drive, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
-		hwif->INSW(hwif->io_ports[IDE_DATA_OFFSET],
+		hwif->INSW(hwif->io_ports.data_addr,
 			   (u8 *)buffer + (bytecount & ~0x03), 1);
 }
 
@@ -274,14 +269,13 @@ static void atapi_output_bytes(ide_drive_t *drive, void *buffer, u32 bytecount)
 #if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
 	if (MACH_IS_ATARI || MACH_IS_Q40) {
 		/* Atari has a byte-swapped IDE interface */
-		outsw_swapw(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-			    bytecount / 2);
+		outsw_swapw(hwif->io_ports.data_addr, buffer, bytecount / 2);
 		return;
 	}
 #endif /* CONFIG_ATARI || CONFIG_Q40 */
 	hwif->ata_output_data(drive, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
-		hwif->OUTSW(hwif->io_ports[IDE_DATA_OFFSET],
+		hwif->OUTSW(hwif->io_ports.data_addr,
 			    (u8 *)buffer + (bytecount & ~0x03), 1);
 }
 
@@ -445,7 +439,7 @@ int drive_is_ready (ide_drive_t *drive)
 	 * an interrupt with another pci card/device.  We make no assumptions
 	 * about possible isa-pnp and pci-pnp issues yet.
 	 */
-	if (hwif->io_ports[IDE_CONTROL_OFFSET])
+	if (hwif->io_ports.ctl_addr)
 		stat = ide_read_altstatus(drive);
 	else
 		/* Note: this may clear a pending IRQ!! */
@@ -647,7 +641,7 @@ int ide_driveid_update(ide_drive_t *drive)
 	SELECT_MASK(drive, 1);
 	ide_set_irq(drive, 1);
 	msleep(50);
-	hwif->OUTB(WIN_IDENTIFY, hwif->io_ports[IDE_COMMAND_OFFSET]);
+	hwif->OUTB(WIN_IDENTIFY, hwif->io_ports.command_addr);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -696,6 +690,7 @@ int ide_driveid_update(ide_drive_t *drive)
 int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	int error = 0;
 	u8 stat;
 
@@ -734,10 +729,9 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 	SELECT_MASK(drive, 0);
 	udelay(1);
 	ide_set_irq(drive, 0);
-	hwif->OUTB(speed, hwif->io_ports[IDE_NSECTOR_OFFSET]);
-	hwif->OUTB(SETFEATURES_XFER, hwif->io_ports[IDE_FEATURE_OFFSET]);
-	hwif->OUTBSYNC(drive, WIN_SETFEATURES,
-		       hwif->io_ports[IDE_COMMAND_OFFSET]);
+	hwif->OUTB(speed, io_ports->nsect_addr);
+	hwif->OUTB(SETFEATURES_XFER, io_ports->feature_addr);
+	hwif->OUTBSYNC(drive, WIN_SETFEATURES, io_ports->command_addr);
 	if (drive->quirk_list == 2)
 		ide_set_irq(drive, 1);
 
@@ -845,7 +839,7 @@ void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 
 	spin_lock_irqsave(&ide_lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	hwif->OUTBSYNC(drive, cmd, hwif->io_ports[IDE_COMMAND_OFFSET]);
+	hwif->OUTBSYNC(drive, cmd, hwif->io_ports.command_addr);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -1029,6 +1023,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	unsigned long flags;
 	ide_hwif_t *hwif;
 	ide_hwgroup_t *hwgroup;
+	struct ide_io_ports *io_ports;
 	const struct ide_port_ops *port_ops;
 	u8 ctl;
 
@@ -1036,6 +1031,8 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	hwif = HWIF(drive);
 	hwgroup = HWGROUP(drive);
 
+	io_ports = &hwif->io_ports;
+
 	/* We must not reset with running handlers */
 	BUG_ON(hwgroup->handler != NULL);
 
@@ -1045,8 +1042,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		hwif->OUTBSYNC(drive, WIN_SRST,
-			       hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTBSYNC(drive, WIN_SRST, io_ports->command_addr);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
@@ -1062,7 +1058,7 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	for (unit = 0; unit < MAX_DRIVES; ++unit)
 		pre_reset(&hwif->drives[unit]);
 
-	if (hwif->io_ports[IDE_CONTROL_OFFSET] == 0) {
+	if (io_ports->ctl_addr == 0) {
 		spin_unlock_irqrestore(&ide_lock, flags);
 		return ide_stopped;
 	}
@@ -1077,14 +1073,14 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 	 * recover from reset very quickly, saving us the first 50ms wait time.
 	 */
 	/* set SRST and nIEN */
-	hwif->OUTBSYNC(drive, drive->ctl|6, hwif->io_ports[IDE_CONTROL_OFFSET]);
+	hwif->OUTBSYNC(drive, drive->ctl|6, io_ports->ctl_addr);
 	/* more than enough time */
 	udelay(10);
 	if (drive->quirk_list == 2)
 		ctl = drive->ctl;	/* clear SRST and nIEN */
 	else
 		ctl = drive->ctl | 2;	/* clear SRST, leave nIEN */
-	hwif->OUTBSYNC(drive, ctl, hwif->io_ports[IDE_CONTROL_OFFSET]);
+	hwif->OUTBSYNC(drive, ctl, io_ports->ctl_addr);
 	/* more than enough time */
 	udelay(10);
 	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
@@ -1129,7 +1125,7 @@ int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout)
 		 * about locking issues (2.5 work ?).
 		 */
 		mdelay(1);
-		stat = hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+		stat = hwif->INB(hwif->io_ports.status_addr);
 		if ((stat & BUSY_STAT) == 0)
 			return 0;
 		/*
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 10c20e9..6a8953f 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -82,10 +82,7 @@ static void idepnp_remove(struct pnp_dev *dev)
 {
 	ide_hwif_t *hwif = pnp_get_drvdata(dev);
 
-	if (hwif)
-		ide_unregister(hwif->index);
-	else
-		printk(KERN_ERR "idepnp: Unable to remove device, please report.\n");
+	ide_unregister(hwif);
 
 	release_region(pnp_port_start(dev, 1), 1);
 	release_region(pnp_port_start(dev, 0), 8);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index a4b65b3..862f026 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -264,6 +264,7 @@ err_misc:
 static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	int use_altstatus = 0, rc;
 	unsigned long timeout;
 	u8 s = 0, a = 0;
@@ -271,7 +272,7 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	/* take a deep breath */
 	msleep(50);
 
-	if (hwif->io_ports[IDE_CONTROL_OFFSET]) {
+	if (io_ports->ctl_addr) {
 		a = ide_read_altstatus(drive);
 		s = ide_read_status(drive);
 		if ((a ^ s) & ~INDEX_STAT)
@@ -289,10 +290,10 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 	 */
 	if ((cmd == WIN_PIDENTIFY))
 		/* disable dma & overlap */
-		hwif->OUTB(0, hwif->io_ports[IDE_FEATURE_OFFSET]);
+		hwif->OUTB(0, io_ports->feature_addr);
 
 	/* ask drive for ID */
-	hwif->OUTB(cmd, hwif->io_ports[IDE_COMMAND_OFFSET]);
+	hwif->OUTB(cmd, io_ports->command_addr);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -353,7 +354,7 @@ static int try_to_identify (ide_drive_t *drive, u8 cmd)
 	 * interrupts during the identify-phase that
 	 * the irq handler isn't expecting.
 	 */
-	if (hwif->io_ports[IDE_CONTROL_OFFSET]) {
+	if (hwif->io_ports.ctl_addr) {
 		if (!hwif->irq) {
 			autoprobe = 1;
 			cookie = probe_irq_on();
@@ -393,7 +394,7 @@ static int ide_busy_sleep(ide_hwif_t *hwif)
 
 	do {
 		msleep(50);
-		stat = hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+		stat = hwif->INB(hwif->io_ports.status_addr);
 		if ((stat & BUSY_STAT) == 0)
 			return 0;
 	} while (time_before(jiffies, timeout));
@@ -425,6 +426,7 @@ static int ide_busy_sleep(ide_hwif_t *hwif)
 static int do_probe (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	int rc;
 	u8 stat;
 
@@ -445,7 +447,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	msleep(50);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	if (hwif->INB(hwif->io_ports[IDE_SELECT_OFFSET]) != drive->select.all &&
+	if (hwif->INB(io_ports->device_addr) != drive->select.all &&
 	    !drive->present) {
 		if (drive->select.b.unit != 0) {
 			/* exit with drive0 selected */
@@ -472,17 +474,13 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 		if (stat == (BUSY_STAT | READY_STAT))
 			return 4;
 
-		if ((rc == 1 && cmd == WIN_PIDENTIFY) &&
-			((drive->autotune == IDE_TUNE_DEFAULT) ||
-			(drive->autotune == IDE_TUNE_AUTO))) {
+		if (rc == 1 && cmd == WIN_PIDENTIFY) {
 			printk(KERN_ERR "%s: no response (status = 0x%02x), "
 					"resetting drive\n", drive->name, stat);
 			msleep(50);
-			hwif->OUTB(drive->select.all,
-				   hwif->io_ports[IDE_SELECT_OFFSET]);
+			hwif->OUTB(drive->select.all, io_ports->device_addr);
 			msleep(50);
-			hwif->OUTB(WIN_SRST,
-				   hwif->io_ports[IDE_COMMAND_OFFSET]);
+			hwif->OUTB(WIN_SRST, io_ports->command_addr);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
@@ -518,7 +516,7 @@ static void enable_nest (ide_drive_t *drive)
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->OUTB(EXABYTE_ENABLE_NEST, hwif->io_ports[IDE_COMMAND_OFFSET]);
+	hwif->OUTB(EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
@@ -800,14 +798,9 @@ static int ide_probe_port(ide_hwif_t *hwif)
 		if (drive->present)
 			rc = 0;
 	}
-	if (hwif->io_ports[IDE_CONTROL_OFFSET] && hwif->reset) {
-		printk(KERN_WARNING "%s: reset\n", hwif->name);
-		hwif->OUTB(12, hwif->io_ports[IDE_CONTROL_OFFSET]);
-		udelay(10);
-		hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
-		(void)ide_busy_sleep(hwif);
-	}
+
 	local_irq_restore(flags);
+
 	/*
 	 * Use cached IRQ number. It might be (and is...) changed by probe
 	 * code above
@@ -834,12 +827,7 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 		ide_drive_t *drive = &hwif->drives[unit];
 
 		if (drive->present) {
-			if (drive->autotune == IDE_TUNE_AUTO)
-				ide_set_max_pio(drive);
-
-			if (drive->autotune != IDE_TUNE_DEFAULT &&
-			    drive->autotune != IDE_TUNE_AUTO)
-				continue;
+			ide_set_max_pio(drive);
 
 			drive->nice1 = 1;
 
@@ -994,6 +982,7 @@ static void ide_port_setup_devices(ide_hwif_t *hwif)
  */
 static int init_irq (ide_hwif_t *hwif)
 {
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned int index;
 	ide_hwgroup_t *hwgroup;
 	ide_hwif_t *match = NULL;
@@ -1077,9 +1066,9 @@ static int init_irq (ide_hwif_t *hwif)
 		if (IDE_CHIPSET_IS_PCI(hwif->chipset))
 			sa = IRQF_SHARED;
 
-		if (hwif->io_ports[IDE_CONTROL_OFFSET])
+		if (io_ports->ctl_addr)
 			/* clear nIEN */
-			hwif->OUTB(0x08, hwif->io_ports[IDE_CONTROL_OFFSET]);
+			hwif->OUTB(0x08, io_ports->ctl_addr);
 
 		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
 	       		goto out_unlink;
@@ -1095,12 +1084,11 @@ static int init_irq (ide_hwif_t *hwif)
 
 #if !defined(__mc68000__)
 	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
-		hwif->io_ports[IDE_DATA_OFFSET],
-		hwif->io_ports[IDE_DATA_OFFSET]+7,
-		hwif->io_ports[IDE_CONTROL_OFFSET], hwif->irq);
+		io_ports->data_addr, io_ports->status_addr,
+		io_ports->ctl_addr, hwif->irq);
 #else
 	printk("%s at 0x%08lx on irq %d", hwif->name,
-		hwif->io_ports[IDE_DATA_OFFSET], hwif->irq);
+		io_ports->data_addr, hwif->irq);
 #endif /* __mc68000__ */
 	if (match)
 		printk(" (%sed with %s)",
@@ -1242,8 +1230,8 @@ static int hwif_init(ide_hwif_t *hwif)
 	int old_irq;
 
 	if (!hwif->irq) {
-		if (!(hwif->irq = ide_default_irq(hwif->io_ports[IDE_DATA_OFFSET])))
-		{
+		hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
+		if (!hwif->irq) {
 			printk("%s: DISABLED, NO IRQ\n", hwif->name);
 			return 0;
 		}
@@ -1272,7 +1260,8 @@ static int hwif_init(ide_hwif_t *hwif)
 	 *	It failed to initialise. Find the default IRQ for 
 	 *	this port and try that.
 	 */
-	if (!(hwif->irq = ide_default_irq(hwif->io_ports[IDE_DATA_OFFSET]))) {
+	hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
+	if (!hwif->irq) {
 		printk("%s: Disabled unable to get IRQ %d.\n",
 			hwif->name, old_irq);
 		goto out;
@@ -1336,8 +1325,6 @@ static void ide_port_init_devices(ide_hwif_t *hwif)
 			drive->unmask = 1;
 		if (hwif->host_flags & IDE_HFLAG_NO_UNMASK_IRQS)
 			drive->no_unmask = 1;
-		if ((hwif->host_flags & IDE_HFLAG_NO_AUTOTUNE) == 0)
-			drive->autotune = 1;
 	}
 
 	if (port_ops && port_ops->port_init_devs)
@@ -1518,13 +1505,20 @@ int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 	int i, rc = 0;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		if (d == NULL || idx[i] == 0xff) {
+		if (idx[i] == 0xff) {
 			mate = NULL;
 			continue;
 		}
 
 		hwif = &ide_hwifs[idx[i]];
 
+		ide_port_apply_params(hwif);
+
+		if (d == NULL) {
+			mate = NULL;
+			continue;
+		}
+
 		if (d->chipset != ide_etrax100 && (i & 1) && mate) {
 			hwif->mate = mate;
 			mate->mate = hwif;
@@ -1621,6 +1615,7 @@ EXPORT_SYMBOL_GPL(ide_device_add);
 
 void ide_port_scan(ide_hwif_t *hwif)
 {
+	ide_port_apply_params(hwif);
 	ide_port_cable_detect(hwif);
 	ide_port_init_devices(hwif);
 
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index d9d98ac..7b2f381 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -786,14 +786,6 @@ void ide_proc_register_port(ide_hwif_t *hwif)
 	}
 }
 
-#ifdef CONFIG_BLK_DEV_IDEPCI
-void ide_pci_create_host_proc(const char *name, get_info_t *get_info)
-{
-	create_proc_info_entry(name, 0, proc_ide_root, get_info);
-}
-EXPORT_SYMBOL_GPL(ide_pci_create_host_proc);
-#endif
-
 void ide_proc_unregister_port(ide_hwif_t *hwif)
 {
 	if (hwif->proc) {
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index d3d8b8d..29870c4 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -72,26 +72,6 @@ enum {
 #endif
 
 /**************************** Tunable parameters *****************************/
-
-
-/*
- * Pipelined mode parameters.
- *
- * We try to use the minimum number of stages which is enough to keep the tape
- * constantly streaming. To accomplish that, we implement a feedback loop around
- * the maximum number of stages:
- *
- * We start from MIN maximum stages (we will not even use MIN stages if we don't
- * need them), increment it by RATE*(MAX-MIN) whenever we sense that the
- * pipeline is empty, until we reach the optimum value or until we reach MAX.
- *
- * Setting the following parameter to 0 is illegal: the pipelined mode cannot be
- * disabled (idetape_calculate_speeds() divides by tape->max_stages.)
- */
-#define IDETAPE_MIN_PIPELINE_STAGES	  1
-#define IDETAPE_MAX_PIPELINE_STAGES	400
-#define IDETAPE_INCREASE_STAGES_RATE	 20
-
 /*
  * After each failed packet command we issue a request sense command and retry
  * the packet command IDETAPE_MAX_PC_RETRIES times.
@@ -224,28 +204,17 @@ enum {
 	/* 0 When the tape position is unknown */
 	IDETAPE_FLAG_ADDRESS_VALID	= (1 <<	1),
 	/* Device already opened */
-	IDETAPE_FLAG_BUSY			= (1 << 2),
-	/* Error detected in a pipeline stage */
-	IDETAPE_FLAG_PIPELINE_ERR	= (1 <<	3),
+	IDETAPE_FLAG_BUSY		= (1 << 2),
 	/* Attempt to auto-detect the current user block size */
-	IDETAPE_FLAG_DETECT_BS		= (1 << 4),
+	IDETAPE_FLAG_DETECT_BS		= (1 << 3),
 	/* Currently on a filemark */
-	IDETAPE_FLAG_FILEMARK		= (1 << 5),
+	IDETAPE_FLAG_FILEMARK		= (1 << 4),
 	/* DRQ interrupt device */
-	IDETAPE_FLAG_DRQ_INTERRUPT	= (1 << 6),
-	/* pipeline active */
-	IDETAPE_FLAG_PIPELINE_ACTIVE	= (1 << 7),
+	IDETAPE_FLAG_DRQ_INTERRUPT	= (1 << 5),
 	/* 0 = no tape is loaded, so we don't rewind after ejecting */
-	IDETAPE_FLAG_MEDIUM_PRESENT	= (1 << 8),
+	IDETAPE_FLAG_MEDIUM_PRESENT	= (1 << 6),
 };
 
-/* A pipeline stage. */
-typedef struct idetape_stage_s {
-	struct request rq;			/* The corresponding request */
-	struct idetape_bh *bh;			/* The data buffers */
-	struct idetape_stage_s *next;		/* Pointer to the next stage */
-} idetape_stage_t;
-
 /*
  * Most of our global data which we need to save even as we leave the driver due
  * to an interrupt or a timer event is stored in the struct defined below.
@@ -289,9 +258,7 @@ typedef struct ide_tape_obj {
 	 * While polling for DSC we use postponed_rq to postpone the current
 	 * request so that ide.c will be able to service pending requests on the
 	 * other device. Note that at most we will have only one DSC (usually
-	 * data transfer) request in the device request queue. Additional
-	 * requests can be queued in our internal pipeline, but they will be
-	 * visible to ide.c only one at a time.
+	 * data transfer) request in the device request queue.
 	 */
 	struct request *postponed_rq;
 	/* The time in which we started polling for DSC */
@@ -331,43 +298,20 @@ typedef struct ide_tape_obj {
 	 * At most, there is only one ide-tape originated data transfer request
 	 * in the device request queue. This allows ide.c to easily service
 	 * requests from the other device when we postpone our active request.
-	 * In the pipelined operation mode, we use our internal pipeline
-	 * structure to hold more data requests. The data buffer size is chosen
-	 * based on the tape's recommendation.
 	 */
-	/* ptr to the request which is waiting in the device request queue */
-	struct request *active_data_rq;
+
 	/* Data buffer size chosen based on the tape's recommendation */
-	int stage_size;
-	idetape_stage_t *merge_stage;
-	int merge_stage_size;
+	int buffer_size;
+	/* merge buffer */
+	struct idetape_bh *merge_bh;
+	/* size of the merge buffer */
+	int merge_bh_size;
+	/* pointer to current buffer head within the merge buffer */
 	struct idetape_bh *bh;
 	char *b_data;
 	int b_count;
 
-	/*
-	 * Pipeline parameters.
-	 *
-	 * To accomplish non-pipelined mode, we simply set the following
-	 * variables to zero (or NULL, where appropriate).
-	 */
-	/* Number of currently used stages */
-	int nr_stages;
-	/* Number of pending stages */
-	int nr_pending_stages;
-	/* We will not allocate more than this number of stages */
-	int max_stages, min_pipeline, max_pipeline;
-	/* The first stage which will be removed from the pipeline */
-	idetape_stage_t *first_stage;
-	/* The currently active stage */
-	idetape_stage_t *active_stage;
-	/* Will be serviced after the currently active request */
-	idetape_stage_t *next_stage;
-	/* New requests will be added to the pipeline here */
-	idetape_stage_t *last_stage;
-	/* Optional free stage which we can use */
-	idetape_stage_t *cache_stage;
-	int pages_per_stage;
+	int pages_per_buffer;
 	/* Wasted space in each stage */
 	int excess_bh_size;
 
@@ -388,45 +332,6 @@ typedef struct ide_tape_obj {
 	/* the tape is write protected (hardware or opened as read-only) */
 	char write_prot;
 
-	/*
-	 * Limit the number of times a request can be postponed, to avoid an
-	 * infinite postpone deadlock.
-	 */
-	int postpone_cnt;
-
-	/*
-	 * Measures number of frames:
-	 *
-	 * 1. written/read to/from the driver pipeline (pipeline_head).
-	 * 2. written/read to/from the tape buffers (idetape_bh).
-	 * 3. written/read by the tape to/from the media (tape_head).
-	 */
-	int pipeline_head;
-	int buffer_head;
-	int tape_head;
-	int last_tape_head;
-
-	/* Speed control at the tape buffers input/output */
-	unsigned long insert_time;
-	int insert_size;
-	int insert_speed;
-	int max_insert_speed;
-	int measure_insert_time;
-
-	/* Speed regulation negative feedback loop */
-	int speed_control;
-	int pipeline_head_speed;
-	int controlled_pipeline_head_speed;
-	int uncontrolled_pipeline_head_speed;
-	int controlled_last_pipeline_head;
-	unsigned long uncontrolled_pipeline_head_time;
-	unsigned long controlled_pipeline_head_time;
-	int controlled_previous_pipeline_head;
-	int uncontrolled_previous_pipeline_head;
-	unsigned long controlled_previous_head_time;
-	unsigned long uncontrolled_previous_head_time;
-	int restart_speed_control_req;
-
 	u32 debug_mask;
 } idetape_tape_t;
 
@@ -674,128 +579,36 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	}
 }
 
-static void idetape_activate_next_stage(ide_drive_t *drive)
+/* Free data buffers completely. */
+static void ide_tape_kfree_buffer(idetape_tape_t *tape)
 {
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage = tape->next_stage;
-	struct request *rq = &stage->rq;
+	struct idetape_bh *prev_bh, *bh = tape->merge_bh;
 
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+	while (bh) {
+		u32 size = bh->b_size;
 
-	if (stage == NULL) {
-		printk(KERN_ERR "ide-tape: bug: Trying to activate a non"
-				" existing stage\n");
-		return;
-	}
+		while (size) {
+			unsigned int order = fls(size >> PAGE_SHIFT)-1;
 
-	rq->rq_disk = tape->disk;
-	rq->buffer = NULL;
-	rq->special = (void *)stage->bh;
-	tape->active_data_rq = rq;
-	tape->active_stage = stage;
-	tape->next_stage = stage->next;
-}
-
-/* Free a stage along with its related buffers completely. */
-static void __idetape_kfree_stage(idetape_stage_t *stage)
-{
-	struct idetape_bh *prev_bh, *bh = stage->bh;
-	int size;
-
-	while (bh != NULL) {
-		if (bh->b_data != NULL) {
-			size = (int) bh->b_size;
-			while (size > 0) {
-				free_page((unsigned long) bh->b_data);
-				size -= PAGE_SIZE;
-				bh->b_data += PAGE_SIZE;
-			}
+			if (bh->b_data)
+				free_pages((unsigned long)bh->b_data, order);
+
+			size &= (order-1);
+			bh->b_data += (1 << order) * PAGE_SIZE;
 		}
 		prev_bh = bh;
 		bh = bh->b_reqnext;
 		kfree(prev_bh);
 	}
-	kfree(stage);
-}
-
-static void idetape_kfree_stage(idetape_tape_t *tape, idetape_stage_t *stage)
-{
-	__idetape_kfree_stage(stage);
-}
-
-/*
- * Remove tape->first_stage from the pipeline. The caller should avoid race
- * conditions.
- */
-static void idetape_remove_stage_head(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	if (tape->first_stage == NULL) {
-		printk(KERN_ERR "ide-tape: bug: tape->first_stage is NULL\n");
-		return;
-	}
-	if (tape->active_stage == tape->first_stage) {
-		printk(KERN_ERR "ide-tape: bug: Trying to free our active "
-				"pipeline stage\n");
-		return;
-	}
-	stage = tape->first_stage;
-	tape->first_stage = stage->next;
-	idetape_kfree_stage(tape, stage);
-	tape->nr_stages--;
-	if (tape->first_stage == NULL) {
-		tape->last_stage = NULL;
-		if (tape->next_stage != NULL)
-			printk(KERN_ERR "ide-tape: bug: tape->next_stage !="
-					" NULL\n");
-		if (tape->nr_stages)
-			printk(KERN_ERR "ide-tape: bug: nr_stages should be 0 "
-					"now\n");
-	}
+	kfree(tape->merge_bh);
 }
 
-/*
- * This will free all the pipeline stages starting from new_last_stage->next
- * to the end of the list, and point tape->last_stage to new_last_stage.
- */
-static void idetape_abort_pipeline(ide_drive_t *drive,
-				   idetape_stage_t *new_last_stage)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage = new_last_stage->next;
-	idetape_stage_t *nstage;
-
-	debug_log(DBG_PROCS, "%s: Enter %s\n", tape->name, __func__);
-
-	while (stage) {
-		nstage = stage->next;
-		idetape_kfree_stage(tape, stage);
-		--tape->nr_stages;
-		--tape->nr_pending_stages;
-		stage = nstage;
-	}
-	if (new_last_stage)
-		new_last_stage->next = NULL;
-	tape->last_stage = new_last_stage;
-	tape->next_stage = NULL;
-}
-
-/*
- * Finish servicing a request and insert a pending pipeline request into the
- * main device queue.
- */
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
 	int error;
-	int remove_stage = 0;
-	idetape_stage_t *active_stage;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
@@ -815,58 +628,8 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 
 	spin_lock_irqsave(&tape->lock, flags);
 
-	/* The request was a pipelined data transfer request */
-	if (tape->active_data_rq == rq) {
-		active_stage = tape->active_stage;
-		tape->active_stage = NULL;
-		tape->active_data_rq = NULL;
-		tape->nr_pending_stages--;
-		if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
-			remove_stage = 1;
-			if (error) {
-				set_bit(IDETAPE_FLAG_PIPELINE_ERR,
-					&tape->flags);
-				if (error == IDETAPE_ERROR_EOD)
-					idetape_abort_pipeline(drive,
-								active_stage);
-			}
-		} else if (rq->cmd[0] & REQ_IDETAPE_READ) {
-			if (error == IDETAPE_ERROR_EOD) {
-				set_bit(IDETAPE_FLAG_PIPELINE_ERR,
-					&tape->flags);
-				idetape_abort_pipeline(drive, active_stage);
-			}
-		}
-		if (tape->next_stage != NULL) {
-			idetape_activate_next_stage(drive);
-
-			/* Insert the next request into the request queue. */
-			(void)ide_do_drive_cmd(drive, tape->active_data_rq,
-						ide_end);
-		} else if (!error) {
-			/*
-			 * This is a part of the feedback loop which tries to
-			 * find the optimum number of stages. We are starting
-			 * from a minimum maximum number of stages, and if we
-			 * sense that the pipeline is empty, we try to increase
-			 * it, until we reach the user compile time memory
-			 * limit.
-			 */
-			int i = (tape->max_pipeline - tape->min_pipeline) / 10;
-
-			tape->max_stages += max(i, 1);
-			tape->max_stages = max(tape->max_stages,
-						tape->min_pipeline);
-			tape->max_stages = min(tape->max_stages,
-						tape->max_pipeline);
-		}
-	}
 	ide_end_drive_cmd(drive, 0, 0);
 
-	if (remove_stage)
-		idetape_remove_stage_head(drive);
-	if (tape->active_data_rq == NULL)
-		clear_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
 	spin_unlock_irqrestore(&tape->lock, flags);
 	return 0;
 }
@@ -1083,10 +846,10 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 	/* Get the number of bytes to transfer on this interrupt. */
-	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
-		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
+	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
+		  hwif->INB(hwif->io_ports.lbam_addr);
 
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
@@ -1190,12 +953,12 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 				"yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
 		printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n");
 		udelay(100);
-		ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+		ireason = hwif->INB(hwif->io_ports.nsect_addr);
 		if (retries == 0) {
 			printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while "
 					"issuing a packet command, ignoring\n");
@@ -1292,7 +1055,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
 	} else {
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
 		return idetape_transfer_pc(drive);
 	}
 }
@@ -1335,69 +1098,6 @@ static void idetape_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_calculate_speeds(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	if (time_after(jiffies,
-			tape->controlled_pipeline_head_time + 120 * HZ)) {
-		tape->controlled_previous_pipeline_head =
-			tape->controlled_last_pipeline_head;
-		tape->controlled_previous_head_time =
-			tape->controlled_pipeline_head_time;
-		tape->controlled_last_pipeline_head = tape->pipeline_head;
-		tape->controlled_pipeline_head_time = jiffies;
-	}
-	if (time_after(jiffies, tape->controlled_pipeline_head_time + 60 * HZ))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head -
-				tape->controlled_last_pipeline_head) * 32 * HZ /
-				(jiffies - tape->controlled_pipeline_head_time);
-	else if (time_after(jiffies, tape->controlled_previous_head_time))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head -
-				tape->controlled_previous_pipeline_head) * 32 *
-			HZ / (jiffies - tape->controlled_previous_head_time);
-
-	if (tape->nr_pending_stages < tape->max_stages/*- 1 */) {
-		/* -1 for read mode error recovery */
-		if (time_after(jiffies, tape->uncontrolled_previous_head_time +
-					10 * HZ)) {
-			tape->uncontrolled_pipeline_head_time = jiffies;
-			tape->uncontrolled_pipeline_head_speed =
-				(tape->pipeline_head -
-				 tape->uncontrolled_previous_pipeline_head) *
-				32 * HZ / (jiffies -
-					tape->uncontrolled_previous_head_time);
-		}
-	} else {
-		tape->uncontrolled_previous_head_time = jiffies;
-		tape->uncontrolled_previous_pipeline_head = tape->pipeline_head;
-		if (time_after(jiffies, tape->uncontrolled_pipeline_head_time +
-					30 * HZ))
-			tape->uncontrolled_pipeline_head_time = jiffies;
-
-	}
-	tape->pipeline_head_speed = max(tape->uncontrolled_pipeline_head_speed,
-					tape->controlled_pipeline_head_speed);
-
-	if (tape->speed_control == 1) {
-		if (tape->nr_pending_stages >= tape->max_stages / 2)
-			tape->max_insert_speed = tape->pipeline_head_speed +
-				(1100 - tape->pipeline_head_speed) * 2 *
-				(tape->nr_pending_stages - tape->max_stages / 2)
-				/ tape->max_stages;
-		else
-			tape->max_insert_speed = 500 +
-				(tape->pipeline_head_speed - 500) * 2 *
-				tape->nr_pending_stages / tape->max_stages;
-
-		if (tape->nr_pending_stages >= tape->max_stages * 99 / 100)
-			tape->max_insert_speed = 5000;
-	} else
-		tape->max_insert_speed = tape->speed_control;
-
-	tape->max_insert_speed = max(tape->max_insert_speed, 500);
-}
-
 static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1432,17 +1132,7 @@ static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 	int blocks = tape->pc->xferred / tape->blk_size;
 
 	tape->avg_size += blocks * tape->blk_size;
-	tape->insert_size += blocks * tape->blk_size;
-	if (tape->insert_size > 1024 * 1024)
-		tape->measure_insert_time = 1;
-	if (tape->measure_insert_time) {
-		tape->measure_insert_time = 0;
-		tape->insert_time = jiffies;
-		tape->insert_size = 0;
-	}
-	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ /
-					(jiffies - tape->insert_time);
+
 	if (time_after_eq(jiffies, tape->avg_time + HZ)) {
 		tape->avg_speed = tape->avg_size * HZ /
 				(jiffies - tape->avg_time) / 1024;
@@ -1475,7 +1165,7 @@ static void idetape_create_read_cmd(idetape_tape_t *tape,
 	pc->buf = NULL;
 	pc->buf_size = length * tape->blk_size;
 	pc->req_xfer = pc->buf_size;
-	if (pc->req_xfer == tape->stage_size)
+	if (pc->req_xfer == tape->buffer_size)
 		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
@@ -1495,7 +1185,7 @@ static void idetape_create_write_cmd(idetape_tape_t *tape,
 	pc->buf = NULL;
 	pc->buf_size = length * tape->blk_size;
 	pc->req_xfer = pc->buf_size;
-	if (pc->req_xfer == tape->stage_size)
+	if (pc->req_xfer == tape->buffer_size)
 		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
@@ -1547,10 +1237,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		drive->post_reset = 0;
 	}
 
-	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ /
-					(jiffies - tape->insert_time);
-	idetape_calculate_speeds(drive);
 	if (!test_and_clear_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
@@ -1574,16 +1260,12 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_READ) {
-		tape->buffer_head++;
-		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
 		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors,
 					(struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
-		tape->buffer_head++;
-		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
 		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors,
 					 (struct idetape_bh *)rq->special);
@@ -1604,103 +1286,91 @@ out:
 	return idetape_issue_pc(drive, pc);
 }
 
-/* Pipeline related functions */
-
 /*
- * The function below uses __get_free_page to allocate a pipeline stage, along
- * with all the necessary small buffers which together make a buffer of size
- * tape->stage_size (or a bit more). We attempt to combine sequential pages as
+ * The function below uses __get_free_pages to allocate a data buffer of size
+ * tape->buffer_size (or a bit more). We attempt to combine sequential pages as
  * much as possible.
  *
- * It returns a pointer to the new allocated stage, or NULL if we can't (or
- * don't want to) allocate a stage.
- *
- * Pipeline stages are optional and are used to increase performance. If we
- * can't allocate them, we'll manage without them.
+ * It returns a pointer to the newly allocated buffer, or NULL in case of
+ * failure.
  */
-static idetape_stage_t *__idetape_kmalloc_stage(idetape_tape_t *tape, int full,
-						int clear)
+static struct idetape_bh *ide_tape_kmalloc_buffer(idetape_tape_t *tape,
+						  int full, int clear)
 {
-	idetape_stage_t *stage;
-	struct idetape_bh *prev_bh, *bh;
-	int pages = tape->pages_per_stage;
+	struct idetape_bh *prev_bh, *bh, *merge_bh;
+	int pages = tape->pages_per_buffer;
+	unsigned int order, b_allocd;
 	char *b_data = NULL;
 
-	stage = kmalloc(sizeof(idetape_stage_t), GFP_KERNEL);
-	if (!stage)
-		return NULL;
-	stage->next = NULL;
-
-	stage->bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
-	bh = stage->bh;
+	merge_bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+	bh = merge_bh;
 	if (bh == NULL)
 		goto abort;
-	bh->b_reqnext = NULL;
-	bh->b_data = (char *) __get_free_page(GFP_KERNEL);
+
+	order = fls(pages) - 1;
+	bh->b_data = (char *) __get_free_pages(GFP_KERNEL, order);
 	if (!bh->b_data)
 		goto abort;
+	b_allocd = (1 << order) * PAGE_SIZE;
+	pages &= (order-1);
+
 	if (clear)
-		memset(bh->b_data, 0, PAGE_SIZE);
-	bh->b_size = PAGE_SIZE;
+		memset(bh->b_data, 0, b_allocd);
+	bh->b_reqnext = NULL;
+	bh->b_size = b_allocd;
 	atomic_set(&bh->b_count, full ? bh->b_size : 0);
 
-	while (--pages) {
-		b_data = (char *) __get_free_page(GFP_KERNEL);
+	while (pages) {
+		order = fls(pages) - 1;
+		b_data = (char *) __get_free_pages(GFP_KERNEL, order);
 		if (!b_data)
 			goto abort;
+		b_allocd = (1 << order) * PAGE_SIZE;
+
 		if (clear)
-			memset(b_data, 0, PAGE_SIZE);
-		if (bh->b_data == b_data + PAGE_SIZE) {
-			bh->b_size += PAGE_SIZE;
-			bh->b_data -= PAGE_SIZE;
+			memset(b_data, 0, b_allocd);
+
+		/* newly allocated page frames below buffer header or ...*/
+		if (bh->b_data == b_data + b_allocd) {
+			bh->b_size += b_allocd;
+			bh->b_data -= b_allocd;
 			if (full)
-				atomic_add(PAGE_SIZE, &bh->b_count);
+				atomic_add(b_allocd, &bh->b_count);
 			continue;
 		}
+		/* they are above the header */
 		if (b_data == bh->b_data + bh->b_size) {
-			bh->b_size += PAGE_SIZE;
+			bh->b_size += b_allocd;
 			if (full)
-				atomic_add(PAGE_SIZE, &bh->b_count);
+				atomic_add(b_allocd, &bh->b_count);
 			continue;
 		}
 		prev_bh = bh;
 		bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
 		if (!bh) {
-			free_page((unsigned long) b_data);
+			free_pages((unsigned long) b_data, order);
 			goto abort;
 		}
 		bh->b_reqnext = NULL;
 		bh->b_data = b_data;
-		bh->b_size = PAGE_SIZE;
+		bh->b_size = b_allocd;
 		atomic_set(&bh->b_count, full ? bh->b_size : 0);
 		prev_bh->b_reqnext = bh;
+
+		pages &= (order-1);
 	}
+
 	bh->b_size -= tape->excess_bh_size;
 	if (full)
 		atomic_sub(tape->excess_bh_size, &bh->b_count);
-	return stage;
+	return merge_bh;
 abort:
-	__idetape_kfree_stage(stage);
+	ide_tape_kfree_buffer(tape);
 	return NULL;
 }
 
-static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
-{
-	idetape_stage_t *cache_stage = tape->cache_stage;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	if (tape->nr_stages >= tape->max_stages)
-		return NULL;
-	if (cache_stage != NULL) {
-		tape->cache_stage = NULL;
-		return cache_stage;
-	}
-	return __idetape_kmalloc_stage(tape, 0, 0);
-}
-
 static int idetape_copy_stage_from_user(idetape_tape_t *tape,
-		idetape_stage_t *stage, const char __user *buf, int n)
+					const char __user *buf, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -1732,7 +1402,7 @@ static int idetape_copy_stage_from_user(idetape_tape_t *tape,
 }
 
 static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
-		idetape_stage_t *stage, int n)
+				      int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -1763,11 +1433,11 @@ static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
 	return ret;
 }
 
-static void idetape_init_merge_stage(idetape_tape_t *tape)
+static void idetape_init_merge_buffer(idetape_tape_t *tape)
 {
-	struct idetape_bh *bh = tape->merge_stage->bh;
+	struct idetape_bh *bh = tape->merge_bh;
+	tape->bh = tape->merge_bh;
 
-	tape->bh = bh;
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		atomic_set(&bh->b_count, 0);
 	else {
@@ -1776,61 +1446,6 @@ static void idetape_init_merge_stage(idetape_tape_t *tape)
 	}
 }
 
-static void idetape_switch_buffers(idetape_tape_t *tape, idetape_stage_t *stage)
-{
-	struct idetape_bh *tmp;
-
-	tmp = stage->bh;
-	stage->bh = tape->merge_stage->bh;
-	tape->merge_stage->bh = tmp;
-	idetape_init_merge_stage(tape);
-}
-
-/* Add a new stage at the end of the pipeline. */
-static void idetape_add_stage_tail(ide_drive_t *drive, idetape_stage_t *stage)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	spin_lock_irqsave(&tape->lock, flags);
-	stage->next = NULL;
-	if (tape->last_stage != NULL)
-		tape->last_stage->next = stage;
-	else
-		tape->first_stage = stage;
-		tape->next_stage  = stage;
-	tape->last_stage = stage;
-	if (tape->next_stage == NULL)
-		tape->next_stage = tape->last_stage;
-	tape->nr_stages++;
-	tape->nr_pending_stages++;
-	spin_unlock_irqrestore(&tape->lock, flags);
-}
-
-/* Install a completion in a pending request and sleep until it is serviced. The
- * caller should ensure that the request will not be serviced before we install
- * the completion (usually by disabling interrupts).
- */
-static void idetape_wait_for_request(ide_drive_t *drive, struct request *rq)
-{
-	DECLARE_COMPLETION_ONSTACK(wait);
-	idetape_tape_t *tape = drive->driver_data;
-
-	if (rq == NULL || !blk_special_request(rq)) {
-		printk(KERN_ERR "ide-tape: bug: Trying to sleep on non-valid"
-				 " request\n");
-		return;
-	}
-	rq->end_io_data = &wait;
-	rq->end_io = blk_end_sync_rq;
-	spin_unlock_irq(&tape->lock);
-	wait_for_completion(&wait);
-	/* The stage and its struct request have been deallocated */
-	spin_lock_irq(&tape->lock);
-}
-
 static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1899,7 +1514,7 @@ static void idetape_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
  * to the request list without waiting for it to be serviced! In that case, we
  * usually use idetape_queue_pc_head().
  */
-static int __idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
+static int idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 	struct request rq;
@@ -1931,7 +1546,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
 		idetape_create_test_unit_ready_cmd(&pc);
-		if (!__idetape_queue_pc_tail(drive, &pc))
+		if (!idetape_queue_pc_tail(drive, &pc))
 			return 0;
 		if ((tape->sense_key == 2 && tape->asc == 4 && tape->ascq == 2)
 		    || (tape->asc == 0x3A)) {
@@ -1940,7 +1555,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 				return -ENOMEDIUM;
 			idetape_create_load_unload_cmd(drive, &pc,
 							IDETAPE_LU_LOAD_MASK);
-			__idetape_queue_pc_tail(drive, &pc);
+			idetape_queue_pc_tail(drive, &pc);
 			load_attempted = 1;
 		/* not about to be ready */
 		} else if (!(tape->sense_key == 2 && tape->asc == 4 &&
@@ -1951,11 +1566,6 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	return -EIO;
 }
 
-static int idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
-{
-	return __idetape_queue_pc_tail(drive, pc);
-}
-
 static int idetape_flush_tape_buffers(ide_drive_t *drive)
 {
 	struct ide_atapi_pc pc;
@@ -2021,50 +1631,21 @@ static int idetape_create_prevent_cmd(ide_drive_t *drive,
 	return 1;
 }
 
-static int __idetape_discard_read_pipeline(ide_drive_t *drive)
+static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-	int cnt;
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ)
-		return 0;
+		return;
 
-	/* Remove merge stage. */
-	cnt = tape->merge_stage_size / tape->blk_size;
-	if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
-		++cnt;		/* Filemarks count as 1 sector */
-	tape->merge_stage_size = 0;
-	if (tape->merge_stage != NULL) {
-		__idetape_kfree_stage(tape->merge_stage);
-		tape->merge_stage = NULL;
+	clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
+	tape->merge_bh_size = 0;
+	if (tape->merge_bh != NULL) {
+		ide_tape_kfree_buffer(tape);
+		tape->merge_bh = NULL;
 	}
 
-	/* Clear pipeline flags. */
-	clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
-
-	/* Remove pipeline stages. */
-	if (tape->first_stage == NULL)
-		return 0;
-
-	spin_lock_irqsave(&tape->lock, flags);
-	tape->next_stage = NULL;
-	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags))
-		idetape_wait_for_request(drive, tape->active_data_rq);
-	spin_unlock_irqrestore(&tape->lock, flags);
-
-	while (tape->first_stage != NULL) {
-		struct request *rq_ptr = &tape->first_stage->rq;
-
-		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors;
-		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
-			++cnt;
-		idetape_remove_stage_head(drive);
-	}
-	tape->nr_pending_stages = 0;
-	tape->max_stages = tape->min_pipeline;
-	return cnt;
 }
 
 /*
@@ -2081,7 +1662,7 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 	struct ide_atapi_pc pc;
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ)
-		__idetape_discard_read_pipeline(drive);
+		__ide_tape_discard_merge_buffer(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
 	retval = idetape_queue_pc_tail(drive, &pc);
@@ -2092,20 +1673,19 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 	return (idetape_queue_pc_tail(drive, &pc));
 }
 
-static void idetape_discard_read_pipeline(ide_drive_t *drive,
+static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
 					  int restore_position)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	int cnt;
 	int seek, position;
 
-	cnt = __idetape_discard_read_pipeline(drive);
+	__ide_tape_discard_merge_buffer(drive);
 	if (restore_position) {
 		position = idetape_read_position(drive);
-		seek = position > cnt ? position - cnt : 0;
+		seek = position > 0 ? position : 0;
 		if (idetape_position_tape(drive, seek, 0, 0)) {
 			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
-					 " discard_pipeline()\n", tape->name);
+					 " %s\n", tape->name, __func__);
 			return;
 		}
 	}
@@ -2123,12 +1703,6 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 
 	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
 
-	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-		printk(KERN_ERR "ide-tape: bug: the pipeline is active in %s\n",
-				__func__);
-		return (0);
-	}
-
 	idetape_init_rq(&rq, cmd);
 	rq.rq_disk = tape->disk;
 	rq.special = (void *)bh;
@@ -2140,26 +1714,13 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
 		return 0;
 
-	if (tape->merge_stage)
-		idetape_init_merge_stage(tape);
+	if (tape->merge_bh)
+		idetape_init_merge_buffer(tape);
 	if (rq.errors == IDETAPE_ERROR_GENERAL)
 		return -EIO;
 	return (tape->blk_size * (blocks-rq.current_nr_sectors));
 }
 
-/* start servicing the pipeline stages, starting from tape->next_stage. */
-static void idetape_plug_pipeline(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	if (tape->next_stage == NULL)
-		return;
-	if (!test_and_set_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-		idetape_activate_next_stage(drive);
-		(void) ide_do_drive_cmd(drive, tape->active_data_rq, ide_end);
-	}
-}
-
 static void idetape_create_inquiry_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
@@ -2197,137 +1758,39 @@ static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_wait_first_stage(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-
-	if (tape->first_stage == NULL)
-		return;
-	spin_lock_irqsave(&tape->lock, flags);
-	if (tape->active_stage == tape->first_stage)
-		idetape_wait_for_request(drive, tape->active_data_rq);
-	spin_unlock_irqrestore(&tape->lock, flags);
-}
-
-/*
- * Try to add a character device originated write request to our pipeline. In
- * case we don't succeed, we revert to non-pipelined operation mode for this
- * request. In order to accomplish that, we
- *
- * 1. Try to allocate a new pipeline stage.
- * 2. If we can't, wait for more and more requests to be serviced and try again
- * each time.
- * 3. If we still can't allocate a stage, fallback to non-pipelined operation
- * mode for this request.
- */
+/* Queue up a character device originated write request. */
 static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *new_stage;
-	unsigned long flags;
-	struct request *rq;
 
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
-	/* Attempt to allocate a new stage. Beware possible race conditions. */
-	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
-		spin_lock_irqsave(&tape->lock, flags);
-		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-			idetape_wait_for_request(drive, tape->active_data_rq);
-			spin_unlock_irqrestore(&tape->lock, flags);
-		} else {
-			spin_unlock_irqrestore(&tape->lock, flags);
-			idetape_plug_pipeline(drive);
-			if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
-					&tape->flags))
-				continue;
-			/*
-			 * The machine is short on memory. Fallback to non-
-			 * pipelined operation mode for this request.
-			 */
-			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
-						blocks, tape->merge_stage->bh);
-		}
-	}
-	rq = &new_stage->rq;
-	idetape_init_rq(rq, REQ_IDETAPE_WRITE);
-	/* Doesn't actually matter - We always assume sequential access */
-	rq->sector = tape->first_frame;
-	rq->current_nr_sectors = blocks;
-	rq->nr_sectors = blocks;
-
-	idetape_switch_buffers(tape, new_stage);
-	idetape_add_stage_tail(drive, new_stage);
-	tape->pipeline_head++;
-	idetape_calculate_speeds(drive);
-
-	/*
-	 * Estimate whether the tape has stopped writing by checking if our
-	 * write pipeline is currently empty. If we are not writing anymore,
-	 * wait for the pipeline to be almost completely full (90%) before
-	 * starting to service requests, so that we will be able to keep up with
-	 * the higher speeds of the tape.
-	 */
-	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-		if (tape->nr_stages >= tape->max_stages * 9 / 10 ||
-			tape->nr_stages >= tape->max_stages -
-			tape->uncontrolled_pipeline_head_speed * 3 * 1024 /
-			tape->blk_size) {
-			tape->measure_insert_time = 1;
-			tape->insert_time = jiffies;
-			tape->insert_size = 0;
-			tape->insert_speed = 0;
-			idetape_plug_pipeline(drive);
-		}
-	}
-	if (test_and_clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
-		/* Return a deferred error */
-		return -EIO;
-	return blocks;
+	return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
+				     blocks, tape->merge_bh);
 }
 
-/*
- * Wait until all pending pipeline requests are serviced. Typically called on
- * device close.
- */
-static void idetape_wait_for_pipeline(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-
-	while (tape->next_stage || test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
-						&tape->flags)) {
-		idetape_plug_pipeline(drive);
-		spin_lock_irqsave(&tape->lock, flags);
-		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags))
-			idetape_wait_for_request(drive, tape->active_data_rq);
-		spin_unlock_irqrestore(&tape->lock, flags);
-	}
-}
-
-static void idetape_empty_write_pipeline(ide_drive_t *drive)
+static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int blocks, min;
 	struct idetape_bh *bh;
 
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
-		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline,"
+		printk(KERN_ERR "ide-tape: bug: Trying to empty merge buffer"
 				" but we are not writing.\n");
 		return;
 	}
-	if (tape->merge_stage_size > tape->stage_size) {
+	if (tape->merge_bh_size > tape->buffer_size) {
 		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
-		tape->merge_stage_size = tape->stage_size;
+		tape->merge_bh_size = tape->buffer_size;
 	}
-	if (tape->merge_stage_size) {
-		blocks = tape->merge_stage_size / tape->blk_size;
-		if (tape->merge_stage_size % tape->blk_size) {
+	if (tape->merge_bh_size) {
+		blocks = tape->merge_bh_size / tape->blk_size;
+		if (tape->merge_bh_size % tape->blk_size) {
 			unsigned int i;
 
 			blocks++;
-			i = tape->blk_size - tape->merge_stage_size %
+			i = tape->blk_size - tape->merge_bh_size %
 				tape->blk_size;
 			bh = tape->bh->b_reqnext;
 			while (bh) {
@@ -2351,74 +1814,33 @@ static void idetape_empty_write_pipeline(ide_drive_t *drive)
 			}
 		}
 		(void) idetape_add_chrdev_write_request(drive, blocks);
-		tape->merge_stage_size = 0;
+		tape->merge_bh_size = 0;
 	}
-	idetape_wait_for_pipeline(drive);
-	if (tape->merge_stage != NULL) {
-		__idetape_kfree_stage(tape->merge_stage);
-		tape->merge_stage = NULL;
+	if (tape->merge_bh != NULL) {
+		ide_tape_kfree_buffer(tape);
+		tape->merge_bh = NULL;
 	}
-	clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
-
-	/*
-	 * On the next backup, perform the feedback loop again. (I don't want to
-	 * keep sense information between backups, as some systems are
-	 * constantly on, and the system load can be totally different on the
-	 * next backup).
-	 */
-	tape->max_stages = tape->min_pipeline;
-	if (tape->first_stage != NULL ||
-	    tape->next_stage != NULL ||
-	    tape->last_stage != NULL ||
-	    tape->nr_stages != 0) {
-		printk(KERN_ERR "ide-tape: ide-tape pipeline bug, "
-			"first_stage %p, next_stage %p, "
-			"last_stage %p, nr_stages %d\n",
-			tape->first_stage, tape->next_stage,
-			tape->last_stage, tape->nr_stages);
-	}
 }
 
-static void idetape_restart_speed_control(ide_drive_t *drive)
+static int idetape_init_read(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-
-	tape->restart_speed_control_req = 0;
-	tape->pipeline_head = 0;
-	tape->controlled_last_pipeline_head = 0;
-	tape->controlled_previous_pipeline_head = 0;
-	tape->uncontrolled_previous_pipeline_head = 0;
-	tape->controlled_pipeline_head_speed = 5000;
-	tape->pipeline_head_speed = 5000;
-	tape->uncontrolled_pipeline_head_speed = 0;
-	tape->controlled_pipeline_head_time =
-		tape->uncontrolled_pipeline_head_time = jiffies;
-	tape->controlled_previous_head_time =
-		tape->uncontrolled_previous_head_time = jiffies;
-}
-
-static int idetape_init_read(ide_drive_t *drive, int max_stages)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *new_stage;
-	struct request rq;
 	int bytes_read;
-	u16 blocks = *(u16 *)&tape->caps[12];
 
 	/* Initialize read operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
 		if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-			idetape_empty_write_pipeline(drive);
+			ide_tape_flush_merge_buffer(drive);
 			idetape_flush_tape_buffers(drive);
 		}
-		if (tape->merge_stage || tape->merge_stage_size) {
-			printk(KERN_ERR "ide-tape: merge_stage_size should be"
+		if (tape->merge_bh || tape->merge_bh_size) {
+			printk(KERN_ERR "ide-tape: merge_bh_size should be"
 					 " 0 now\n");
-			tape->merge_stage_size = 0;
+			tape->merge_bh_size = 0;
 		}
-		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
-		if (!tape->merge_stage)
+		tape->merge_bh = ide_tape_kmalloc_buffer(tape, 0, 0);
+		if (!tape->merge_bh)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_READ;
 
@@ -2431,54 +1853,23 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 		if (drive->dsc_overlap) {
 			bytes_read = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_READ, 0,
-							tape->merge_stage->bh);
+							tape->merge_bh);
 			if (bytes_read < 0) {
-				__idetape_kfree_stage(tape->merge_stage);
-				tape->merge_stage = NULL;
+				ide_tape_kfree_buffer(tape);
+				tape->merge_bh = NULL;
 				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return bytes_read;
 			}
 		}
 	}
-	if (tape->restart_speed_control_req)
-		idetape_restart_speed_control(drive);
-	idetape_init_rq(&rq, REQ_IDETAPE_READ);
-	rq.sector = tape->first_frame;
-	rq.nr_sectors = blocks;
-	rq.current_nr_sectors = blocks;
-	if (!test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags) &&
-	    tape->nr_stages < max_stages) {
-		new_stage = idetape_kmalloc_stage(tape);
-		while (new_stage != NULL) {
-			new_stage->rq = rq;
-			idetape_add_stage_tail(drive, new_stage);
-			if (tape->nr_stages >= max_stages)
-				break;
-			new_stage = idetape_kmalloc_stage(tape);
-		}
-	}
-	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-		if (tape->nr_pending_stages >= 3 * max_stages / 4) {
-			tape->measure_insert_time = 1;
-			tape->insert_time = jiffies;
-			tape->insert_size = 0;
-			tape->insert_speed = 0;
-			idetape_plug_pipeline(drive);
-		}
-	}
+
 	return 0;
 }
 
-/*
- * Called from idetape_chrdev_read() to service a character device read request
- * and add read-ahead requests to our pipeline.
- */
+/* called from idetape_chrdev_read() to service a chrdev read request. */
 static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-	struct request *rq_ptr;
-	int bytes_read;
 
 	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
@@ -2486,39 +1877,10 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	if (test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 		return 0;
 
-	/* Wait for the next block to reach the head of the pipeline. */
-	idetape_init_read(drive, tape->max_stages);
-	if (tape->first_stage == NULL) {
-		if (test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
-			return 0;
-		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
-					tape->merge_stage->bh);
-	}
-	idetape_wait_first_stage(drive);
-	rq_ptr = &tape->first_stage->rq;
-	bytes_read = tape->blk_size * (rq_ptr->nr_sectors -
-					rq_ptr->current_nr_sectors);
-	rq_ptr->nr_sectors = 0;
-	rq_ptr->current_nr_sectors = 0;
+	idetape_init_read(drive);
 
-	if (rq_ptr->errors == IDETAPE_ERROR_EOD)
-		return 0;
-	else {
-		idetape_switch_buffers(tape, tape->first_stage);
-		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
-			set_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
-		spin_lock_irqsave(&tape->lock, flags);
-		idetape_remove_stage_head(drive);
-		spin_unlock_irqrestore(&tape->lock, flags);
-		tape->pipeline_head++;
-		idetape_calculate_speeds(drive);
-	}
-	if (bytes_read > blocks * tape->blk_size) {
-		printk(KERN_ERR "ide-tape: bug: trying to return more bytes"
-				" than requested\n");
-		bytes_read = blocks * tape->blk_size;
-	}
-	return (bytes_read);
+	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
+				     tape->merge_bh);
 }
 
 static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
@@ -2530,8 +1892,8 @@ static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 	while (bcount) {
 		unsigned int count;
 
-		bh = tape->merge_stage->bh;
-		count = min(tape->stage_size, bcount);
+		bh = tape->merge_bh;
+		count = min(tape->buffer_size, bcount);
 		bcount -= count;
 		blocks = count / tape->blk_size;
 		while (count) {
@@ -2542,29 +1904,8 @@ static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 			bh = bh->b_reqnext;
 		}
 		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks,
-				      tape->merge_stage->bh);
-	}
-}
-
-static int idetape_pipeline_size(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage;
-	struct request *rq;
-	int size = 0;
-
-	idetape_wait_for_pipeline(drive);
-	stage = tape->first_stage;
-	while (stage != NULL) {
-		rq = &stage->rq;
-		size += tape->blk_size * (rq->nr_sectors -
-				rq->current_nr_sectors);
-		if (rq->errors == IDETAPE_ERROR_FILEMARK)
-			size += tape->blk_size;
-		stage = stage->next;
+				      tape->merge_bh);
 	}
-	size += tape->merge_stage_size;
-	return size;
 }
 
 /*
@@ -2612,11 +1953,10 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
 		if (copy_from_user(&config, argp, sizeof(config)))
 			return -EFAULT;
 		tape->best_dsc_rw_freq = config.dsc_rw_frequency;
-		tape->max_stages = config.nr_stages;
 		break;
 	case 0x0350:
 		config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
-		config.nr_stages = tape->max_stages;
+		config.nr_stages = 1;
 		if (copy_to_user(argp, &config, sizeof(config)))
 			return -EFAULT;
 		break;
@@ -2626,19 +1966,11 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
 	return 0;
 }
 
-/*
- * The function below is now a bit more complicated than just passing the
- * command to the tape since we may have crossed some filemarks during our
- * pipelined read-ahead mode. As a minor side effect, the pipeline enables us to
- * support MTFSFM when the filemark is in our internal pipeline even if the tape
- * doesn't support spacing over filemarks in the reverse direction.
- */
 static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 					int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
-	unsigned long flags;
 	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
 
@@ -2651,48 +1983,12 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	}
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		/* its a read-ahead buffer, scan it for crossed filemarks. */
-		tape->merge_stage_size = 0;
+		tape->merge_bh_size = 0;
 		if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 			++count;
-		while (tape->first_stage != NULL) {
-			if (count == mt_count) {
-				if (mt_op == MTFSFM)
-					set_bit(IDETAPE_FLAG_FILEMARK,
-						&tape->flags);
-				return 0;
-			}
-			spin_lock_irqsave(&tape->lock, flags);
-			if (tape->first_stage == tape->active_stage) {
-				/*
-				 * We have reached the active stage in the read
-				 * pipeline. There is no point in allowing the
-				 * drive to continue reading any farther, so we
-				 * stop the pipeline.
-				 *
-				 * This section should be moved to a separate
-				 * subroutine because similar operations are
-				 * done in __idetape_discard_read_pipeline(),
-				 * for example.
-				 */
-				tape->next_stage = NULL;
-				spin_unlock_irqrestore(&tape->lock, flags);
-				idetape_wait_first_stage(drive);
-				tape->next_stage = tape->first_stage->next;
-			} else
-				spin_unlock_irqrestore(&tape->lock, flags);
-			if (tape->first_stage->rq.errors ==
-					IDETAPE_ERROR_FILEMARK)
-				++count;
-			idetape_remove_stage_head(drive);
-		}
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 	}
 
-	/*
-	 * The filemark was not found in our internal pipeline;	now we can issue
-	 * the space command.
-	 */
 	switch (mt_op) {
 	case MTFSF:
 	case MTBSF:
@@ -2748,27 +2044,25 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
 	}
-	rc = idetape_init_read(drive, tape->max_stages);
+	rc = idetape_init_read(drive);
 	if (rc < 0)
 		return rc;
 	if (count == 0)
 		return (0);
-	if (tape->merge_stage_size) {
-		actually_read = min((unsigned int)(tape->merge_stage_size),
+	if (tape->merge_bh_size) {
+		actually_read = min((unsigned int)(tape->merge_bh_size),
 				    (unsigned int)count);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
-					       actually_read))
+		if (idetape_copy_stage_to_user(tape, buf, actually_read))
 			ret = -EFAULT;
 		buf += actually_read;
-		tape->merge_stage_size -= actually_read;
+		tape->merge_bh_size -= actually_read;
 		count -= actually_read;
 	}
-	while (count >= tape->stage_size) {
+	while (count >= tape->buffer_size) {
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
-					       bytes_read))
+		if (idetape_copy_stage_to_user(tape, buf, bytes_read))
 			ret = -EFAULT;
 		buf += bytes_read;
 		count -= bytes_read;
@@ -2779,11 +2073,10 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		if (bytes_read <= 0)
 			goto finish;
 		temp = min((unsigned long)count, (unsigned long)bytes_read);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
-					       temp))
+		if (idetape_copy_stage_to_user(tape, buf, temp))
 			ret = -EFAULT;
 		actually_read += temp;
-		tape->merge_stage_size = bytes_read-temp;
+		tape->merge_bh_size = bytes_read-temp;
 	}
 finish:
 	if (!actually_read && test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags)) {
@@ -2814,17 +2107,17 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	/* Initialize write operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
 		if (tape->chrdev_dir == IDETAPE_DIR_READ)
-			idetape_discard_read_pipeline(drive, 1);
-		if (tape->merge_stage || tape->merge_stage_size) {
-			printk(KERN_ERR "ide-tape: merge_stage_size "
+			ide_tape_discard_merge_buffer(drive, 1);
+		if (tape->merge_bh || tape->merge_bh_size) {
+			printk(KERN_ERR "ide-tape: merge_bh_size "
 				"should be 0 now\n");
-			tape->merge_stage_size = 0;
+			tape->merge_bh_size = 0;
 		}
-		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
-		if (!tape->merge_stage)
+		tape->merge_bh = ide_tape_kmalloc_buffer(tape, 0, 0);
+		if (!tape->merge_bh)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_WRITE;
-		idetape_init_merge_stage(tape);
+		idetape_init_merge_buffer(tape);
 
 		/*
 		 * Issue a write 0 command to ensure that DSC handshake is
@@ -2835,10 +2128,10 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		if (drive->dsc_overlap) {
 			ssize_t retval = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_WRITE, 0,
-							tape->merge_stage->bh);
+							tape->merge_bh);
 			if (retval < 0) {
-				__idetape_kfree_stage(tape->merge_stage);
-				tape->merge_stage = NULL;
+				ide_tape_kfree_buffer(tape);
+				tape->merge_bh = NULL;
 				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return retval;
 			}
@@ -2846,49 +2139,44 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	if (count == 0)
 		return (0);
-	if (tape->restart_speed_control_req)
-		idetape_restart_speed_control(drive);
-	if (tape->merge_stage_size) {
-		if (tape->merge_stage_size >= tape->stage_size) {
+	if (tape->merge_bh_size) {
+		if (tape->merge_bh_size >= tape->buffer_size) {
 			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
-			tape->merge_stage_size = 0;
+			tape->merge_bh_size = 0;
 		}
 		actually_written = min((unsigned int)
-				(tape->stage_size - tape->merge_stage_size),
+				(tape->buffer_size - tape->merge_bh_size),
 				(unsigned int)count);
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
-						 actually_written))
+		if (idetape_copy_stage_from_user(tape, buf, actually_written))
 				ret = -EFAULT;
 		buf += actually_written;
-		tape->merge_stage_size += actually_written;
+		tape->merge_bh_size += actually_written;
 		count -= actually_written;
 
-		if (tape->merge_stage_size == tape->stage_size) {
+		if (tape->merge_bh_size == tape->buffer_size) {
 			ssize_t retval;
-			tape->merge_stage_size = 0;
+			tape->merge_bh_size = 0;
 			retval = idetape_add_chrdev_write_request(drive, ctl);
 			if (retval <= 0)
 				return (retval);
 		}
 	}
-	while (count >= tape->stage_size) {
+	while (count >= tape->buffer_size) {
 		ssize_t retval;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
-						 tape->stage_size))
+		if (idetape_copy_stage_from_user(tape, buf, tape->buffer_size))
 			ret = -EFAULT;
-		buf += tape->stage_size;
-		count -= tape->stage_size;
+		buf += tape->buffer_size;
+		count -= tape->buffer_size;
 		retval = idetape_add_chrdev_write_request(drive, ctl);
-		actually_written += tape->stage_size;
+		actually_written += tape->buffer_size;
 		if (retval <= 0)
 			return (retval);
 	}
 	if (count) {
 		actually_written += count;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
-						 count))
+		if (idetape_copy_stage_from_user(tape, buf, count))
 			ret = -EFAULT;
-		tape->merge_stage_size += count;
+		tape->merge_bh_size += count;
 	}
 	return ret ? ret : actually_written;
 }
@@ -2912,8 +2200,7 @@ static int idetape_write_filemark(ide_drive_t *drive)
  *
  * Note: MTBSF and MTBSFM are not supported when the tape doesn't support
  * spacing over filemarks in the reverse direction. In this case, MTFSFM is also
- * usually not supported (it is supported in the rare case in which we crossed
- * the filemark during our read-ahead pipelined operation mode).
+ * usually not supported.
  *
  * The following commands are currently not supported:
  *
@@ -2929,7 +2216,6 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
 			mt_op, mt_count);
 
-	/* Commands which need our pipelined read-ahead stages. */
 	switch (mt_op) {
 	case MTFSF:
 	case MTFSFM:
@@ -2946,7 +2232,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 	case MTWEOF:
 		if (tape->write_prot)
 			return -EACCES;
-		idetape_discard_read_pipeline(drive, 1);
+		ide_tape_discard_merge_buffer(drive, 1);
 		for (i = 0; i < mt_count; i++) {
 			retval = idetape_write_filemark(drive);
 			if (retval)
@@ -2954,12 +2240,12 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		}
 		return 0;
 	case MTREW:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		if (idetape_rewind_tape(drive))
 			return -EIO;
 		return 0;
 	case MTLOAD:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 					       IDETAPE_LU_LOAD_MASK);
 		return idetape_queue_pc_tail(drive, &pc);
@@ -2974,7 +2260,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 				if (!idetape_queue_pc_tail(drive, &pc))
 					tape->door_locked = DOOR_UNLOCKED;
 		}
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 					      !IDETAPE_LU_LOAD_MASK);
 		retval = idetape_queue_pc_tail(drive, &pc);
@@ -2982,10 +2268,10 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			clear_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
 		return retval;
 	case MTNOP:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		return idetape_flush_tape_buffers(drive);
 	case MTRETEN:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
 		return idetape_queue_pc_tail(drive, &pc);
@@ -3007,11 +2293,11 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			set_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
 		return 0;
 	case MTSEEK:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		return idetape_position_tape(drive,
 			mt_count * tape->user_bs_factor, tape->partition, 0);
 	case MTSETPART:
-		idetape_discard_read_pipeline(drive, 0);
+		ide_tape_discard_merge_buffer(drive, 0);
 		return idetape_position_tape(drive, 0, mt_count, 0);
 	case MTFSR:
 	case MTBSR:
@@ -3056,13 +2342,12 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 
 	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
-	tape->restart_speed_control_req = 1;
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-		idetape_empty_write_pipeline(drive);
+		ide_tape_flush_merge_buffer(drive);
 		idetape_flush_tape_buffers(drive);
 	}
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
-		block_offset = idetape_pipeline_size(drive) /
+		block_offset = tape->merge_bh_size /
 			(tape->blk_size * tape->user_bs_factor);
 		position = idetape_read_position(drive);
 		if (position < 0)
@@ -3094,7 +2379,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 		return 0;
 	default:
 		if (tape->chrdev_dir == IDETAPE_DIR_READ)
-			idetape_discard_read_pipeline(drive, 1);
+			ide_tape_discard_merge_buffer(drive, 1);
 		return idetape_blkdev_ioctl(drive, cmd, arg);
 	}
 }
@@ -3168,9 +2453,6 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	if (!test_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags))
 		(void)idetape_rewind_tape(drive);
 
-	if (tape->chrdev_dir != IDETAPE_DIR_READ)
-		clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
-
 	/* Read block size and write protect status from drive. */
 	ide_tape_get_bsize_from_bdesc(drive);
 
@@ -3199,8 +2481,6 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 			}
 		}
 	}
-	idetape_restart_speed_control(drive);
-	tape->restart_speed_control_req = 0;
 	return 0;
 
 out_put_tape:
@@ -3212,13 +2492,13 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	idetape_empty_write_pipeline(drive);
-	tape->merge_stage = __idetape_kmalloc_stage(tape, 1, 0);
-	if (tape->merge_stage != NULL) {
+	ide_tape_flush_merge_buffer(drive);
+	tape->merge_bh = ide_tape_kmalloc_buffer(tape, 1, 0);
+	if (tape->merge_bh != NULL) {
 		idetape_pad_zeros(drive, tape->blk_size *
 				(tape->user_bs_factor - 1));
-		__idetape_kfree_stage(tape->merge_stage);
-		tape->merge_stage = NULL;
+		ide_tape_kfree_buffer(tape);
+		tape->merge_bh = NULL;
 	}
 	idetape_write_filemark(drive);
 	idetape_flush_tape_buffers(drive);
@@ -3241,14 +2521,9 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 		idetape_write_release(drive, minor);
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		if (minor < 128)
-			idetape_discard_read_pipeline(drive, 1);
-		else
-			idetape_wait_for_pipeline(drive);
-	}
-	if (tape->cache_stage != NULL) {
-		__idetape_kfree_stage(tape->cache_stage);
-		tape->cache_stage = NULL;
+			ide_tape_discard_merge_buffer(drive, 1);
 	}
+
 	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
@@ -3385,33 +2660,15 @@ static void idetape_add_settings(ide_drive_t *drive)
 
 	ide_add_setting(drive, "buffer", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 2, (u16 *)&tape->caps[16], NULL);
-	ide_add_setting(drive, "pipeline_min", SETTING_RW, TYPE_INT, 1, 0xffff,
-			tape->stage_size / 1024, 1, &tape->min_pipeline, NULL);
-	ide_add_setting(drive, "pipeline", SETTING_RW, TYPE_INT, 1, 0xffff,
-			tape->stage_size / 1024, 1, &tape->max_stages, NULL);
-	ide_add_setting(drive, "pipeline_max", SETTING_RW, TYPE_INT, 1,	0xffff,
-			tape->stage_size / 1024, 1, &tape->max_pipeline, NULL);
-	ide_add_setting(drive, "pipeline_used",	SETTING_READ, TYPE_INT, 0,
-			0xffff,	tape->stage_size / 1024, 1, &tape->nr_stages,
-			NULL);
-	ide_add_setting(drive, "pipeline_pending", SETTING_READ, TYPE_INT, 0,
-			0xffff, tape->stage_size / 1024, 1,
-			&tape->nr_pending_stages, NULL);
 	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 1, (u16 *)&tape->caps[14], NULL);
-	ide_add_setting(drive, "stage", SETTING_READ, TYPE_INT,	0, 0xffff, 1,
-			1024, &tape->stage_size, NULL);
+	ide_add_setting(drive, "buffer_size", SETTING_READ, TYPE_INT, 0, 0xffff,
+			1, 1024, &tape->buffer_size, NULL);
 	ide_add_setting(drive, "tdsc", SETTING_RW, TYPE_INT, IDETAPE_DSC_RW_MIN,
 			IDETAPE_DSC_RW_MAX, 1000, HZ, &tape->best_dsc_rw_freq,
 			NULL);
 	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1,
 			1, &drive->dsc_overlap, NULL);
-	ide_add_setting(drive, "pipeline_head_speed_c", SETTING_READ, TYPE_INT,
-			0, 0xffff, 1, 1, &tape->controlled_pipeline_head_speed,
-			NULL);
-	ide_add_setting(drive, "pipeline_head_speed_u", SETTING_READ, TYPE_INT,
-			0, 0xffff, 1, 1,
-			&tape->uncontrolled_pipeline_head_speed, NULL);
 	ide_add_setting(drive, "avg_speed", SETTING_READ, TYPE_INT, 0, 0xffff,
 			1, 1, &tape->avg_speed, NULL);
 	ide_add_setting(drive, "debug_mask", SETTING_RW, TYPE_INT, 0, 0xffff, 1,
@@ -3434,11 +2691,10 @@ static inline void idetape_add_settings(ide_drive_t *drive) { ; }
  */
 static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 {
-	unsigned long t1, tmid, tn, t;
+	unsigned long t;
 	int speed;
-	int stage_size;
+	int buffer_size;
 	u8 gcw[2];
-	struct sysinfo si;
 	u16 *ctl = (u16 *)&tape->caps[12];
 
 	spin_lock_init(&tape->lock);
@@ -3457,65 +2713,33 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->name[2] = '0' + minor;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 	tape->pc = tape->pc_stack;
-	tape->max_insert_speed = 10000;
-	tape->speed_control = 1;
 	*((unsigned short *) &gcw) = drive->id->config;
 
 	/* Command packet DRQ type */
 	if (((gcw[0] & 0x60) >> 5) == 1)
 		set_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags);
 
-	tape->min_pipeline = 10;
-	tape->max_pipeline = 10;
-	tape->max_stages   = 10;
-
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
 	tape->user_bs_factor = 1;
-	tape->stage_size = *ctl * tape->blk_size;
-	while (tape->stage_size > 0xffff) {
+	tape->buffer_size = *ctl * tape->blk_size;
+	while (tape->buffer_size > 0xffff) {
 		printk(KERN_NOTICE "ide-tape: decreasing stage size\n");
 		*ctl /= 2;
-		tape->stage_size = *ctl * tape->blk_size;
+		tape->buffer_size = *ctl * tape->blk_size;
 	}
-	stage_size = tape->stage_size;
-	tape->pages_per_stage = stage_size / PAGE_SIZE;
-	if (stage_size % PAGE_SIZE) {
-		tape->pages_per_stage++;
-		tape->excess_bh_size = PAGE_SIZE - stage_size % PAGE_SIZE;
+	buffer_size = tape->buffer_size;
+	tape->pages_per_buffer = buffer_size / PAGE_SIZE;
+	if (buffer_size % PAGE_SIZE) {
+		tape->pages_per_buffer++;
+		tape->excess_bh_size = PAGE_SIZE - buffer_size % PAGE_SIZE;
 	}
 
-	/* Select the "best" DSC read/write polling freq and pipeline size. */
+	/* select the "best" DSC read/write polling freq */
 	speed = max(*(u16 *)&tape->caps[14], *(u16 *)&tape->caps[8]);
 
-	tape->max_stages = speed * 1000 * 10 / tape->stage_size;
-
-	/* Limit memory use for pipeline to 10% of physical memory */
-	si_meminfo(&si);
-	if (tape->max_stages * tape->stage_size >
-			si.totalram * si.mem_unit / 10)
-		tape->max_stages =
-			si.totalram * si.mem_unit / (10 * tape->stage_size);
-
-	tape->max_stages   = min(tape->max_stages, IDETAPE_MAX_PIPELINE_STAGES);
-	tape->min_pipeline = min(tape->max_stages, IDETAPE_MIN_PIPELINE_STAGES);
-	tape->max_pipeline =
-		min(tape->max_stages * 2, IDETAPE_MAX_PIPELINE_STAGES);
-	if (tape->max_stages == 0) {
-		tape->max_stages   = 1;
-		tape->min_pipeline = 1;
-		tape->max_pipeline = 1;
-	}
-
-	t1 = (tape->stage_size * HZ) / (speed * 1000);
-	tmid = (*(u16 *)&tape->caps[16] * 32 * HZ) / (speed * 125);
-	tn = (IDETAPE_FIFO_THRESHOLD * tape->stage_size * HZ) / (speed * 1000);
-
-	if (tape->max_stages)
-		t = tn;
-	else
-		t = t1;
+	t = (IDETAPE_FIFO_THRESHOLD * tape->buffer_size * HZ) / (speed * 1000);
 
 	/*
 	 * Ensure that the number we got makes sense; limit it within
@@ -3525,11 +2749,10 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 				min_t(unsigned long, t, IDETAPE_DSC_RW_MAX),
 				IDETAPE_DSC_RW_MIN);
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
-		"%dkB pipeline, %lums tDSC%s\n",
+		"%lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
-		(*(u16 *)&tape->caps[16] * 512) / tape->stage_size,
-		tape->stage_size / 1024,
-		tape->max_stages * tape->stage_size / 1024,
+		(*(u16 *)&tape->caps[16] * 512) / tape->buffer_size,
+		tape->buffer_size / 1024,
 		tape->best_dsc_rw_freq * 1000 / HZ,
 		drive->using_dma ? ", DMA":"");
 
@@ -3553,7 +2776,7 @@ static void ide_tape_release(struct kref *kref)
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
-	BUG_ON(tape->first_stage != NULL || tape->merge_stage_size);
+	BUG_ON(tape->merge_bh_size);
 
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index a317ca9..9f9ad9f 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -36,6 +36,7 @@
 void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
 	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
@@ -59,34 +60,33 @@ void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 		SELECT_MASK(drive, 0);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
-		hwif->OUTW((tf->hob_data << 8) | tf->data,
-			   hwif->io_ports[IDE_DATA_OFFSET]);
+		hwif->OUTW((tf->hob_data << 8) | tf->data, io_ports->data_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		hwif->OUTB(tf->hob_feature, hwif->io_ports[IDE_FEATURE_OFFSET]);
+		hwif->OUTB(tf->hob_feature, io_ports->feature_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		hwif->OUTB(tf->hob_nsect, hwif->io_ports[IDE_NSECTOR_OFFSET]);
+		hwif->OUTB(tf->hob_nsect, io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		hwif->OUTB(tf->hob_lbal, hwif->io_ports[IDE_SECTOR_OFFSET]);
+		hwif->OUTB(tf->hob_lbal, io_ports->lbal_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		hwif->OUTB(tf->hob_lbam, hwif->io_ports[IDE_LCYL_OFFSET]);
+		hwif->OUTB(tf->hob_lbam, io_ports->lbam_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		hwif->OUTB(tf->hob_lbah, hwif->io_ports[IDE_HCYL_OFFSET]);
+		hwif->OUTB(tf->hob_lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		hwif->OUTB(tf->feature, hwif->io_ports[IDE_FEATURE_OFFSET]);
+		hwif->OUTB(tf->feature, io_ports->feature_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		hwif->OUTB(tf->nsect, hwif->io_ports[IDE_NSECTOR_OFFSET]);
+		hwif->OUTB(tf->nsect, io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		hwif->OUTB(tf->lbal, hwif->io_ports[IDE_SECTOR_OFFSET]);
+		hwif->OUTB(tf->lbal, io_ports->lbal_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		hwif->OUTB(tf->lbam, hwif->io_ports[IDE_LCYL_OFFSET]);
+		hwif->OUTB(tf->lbam, io_ports->lbam_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		hwif->OUTB(tf->lbah, hwif->io_ports[IDE_HCYL_OFFSET]);
+		hwif->OUTB(tf->lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		hwif->OUTB((tf->device & HIHI) | drive->select.all,
-			   hwif->io_ports[IDE_SELECT_OFFSET]);
+			   io_ports->device_addr);
 }
 
 int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
@@ -155,8 +155,7 @@ ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
 	case TASKFILE_OUT:
-		hwif->OUTBSYNC(drive, tf->command,
-			       hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTBSYNC(drive, tf->command, hwif->io_ports.command_addr);
 		ndelay(400);	/* FIXME */
 		return pre_task_out_intr(drive, task->rq);
 	case TASKFILE_MULTI_IN:
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index bced02f..999584c 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -94,12 +94,6 @@ DEFINE_MUTEX(ide_cfg_mtx);
 
 int noautodma = 0;
 
-#ifdef CONFIG_BLK_DEV_IDEACPI
-int ide_noacpi = 0;
-int ide_noacpitfs = 1;
-int ide_noacpionboot = 1;
-#endif
-
 ide_hwif_t ide_hwifs[MAX_HWIFS];	/* master data repository */
 
 static void ide_port_init_devices_data(ide_hwif_t *);
@@ -293,7 +287,7 @@ EXPORT_SYMBOL_GPL(ide_port_unregister_devices);
 
 /**
  *	ide_unregister		-	free an IDE interface
- *	@index: index of interface (will change soon to a pointer)
+ *	@hwif: IDE interface
  *
  *	Perform the final unregister of an IDE interface. At the moment
  *	we don't refcount interfaces so this will also get split up.
@@ -313,19 +307,16 @@ EXPORT_SYMBOL_GPL(ide_port_unregister_devices);
  *	This is raving bonkers.
  */
 
-void ide_unregister(unsigned int index)
+void ide_unregister(ide_hwif_t *hwif)
 {
-	ide_hwif_t *hwif, *g;
+	ide_hwif_t *g;
 	ide_hwgroup_t *hwgroup;
 	int irq_count = 0;
 
-	BUG_ON(index >= MAX_HWIFS);
-
 	BUG_ON(in_interrupt());
 	BUG_ON(irqs_disabled());
 	mutex_lock(&ide_cfg_mtx);
 	spin_lock_irq(&ide_lock);
-	hwif = &ide_hwifs[index];
 	if (!hwif->present)
 		goto abort;
 	__ide_port_unregister_devices(hwif);
@@ -366,7 +357,7 @@ void ide_unregister(unsigned int index)
 		ide_release_dma_engine(hwif);
 
 	/* restore hwif data to pristine status */
-	ide_init_port_data(hwif, index);
+	ide_init_port_data(hwif, hwif->index);
 
 abort:
 	spin_unlock_irq(&ide_lock);
@@ -377,7 +368,7 @@ EXPORT_SYMBOL(ide_unregister);
 
 void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 {
-	memcpy(hwif->io_ports, hw->io_ports, sizeof(hwif->io_ports));
+	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
 	hwif->irq = hw->irq;
 	hwif->chipset = hw->chipset;
 	hwif->gendev.parent = hw->dev;
@@ -837,16 +828,6 @@ static int __init match_parm (char *s, const char *keywords[], int vals[], int m
 	return 0;	/* zero = nothing matched */
 }
 
-extern int probe_ali14xx;
-extern int probe_umc8672;
-extern int probe_dtc2278;
-extern int probe_ht6560b;
-extern int probe_qd65xx;
-extern int cmd640_vlb;
-extern int probe_4drives;
-
-static int __initdata is_chipset_set;
-
 /*
  * ide_setup() gets called VERY EARLY during initialization,
  * to handle kernel "command line" strings beginning with "hdx=" or "ide".
@@ -855,14 +836,12 @@ static int __initdata is_chipset_set;
  */
 static int __init ide_setup(char *s)
 {
-	int i, vals[3];
 	ide_hwif_t *hwif;
 	ide_drive_t *drive;
 	unsigned int hw, unit;
+	int vals[3];
 	const char max_drive = 'a' + ((MAX_HWIFS * MAX_DRIVES) - 1);
-	const char max_hwif  = '0' + (MAX_HWIFS - 1);
 
-	
 	if (strncmp(s,"hd",2) == 0 && s[2] == '=')	/* hd= is for hd.c   */
 		return 0;				/* driver and not us */
 
@@ -878,7 +857,7 @@ static int __init ide_setup(char *s)
 
 		printk(" : Enabled support for IDE doublers\n");
 		ide_doubler = 1;
-		return 1;
+		goto obsolete_option;
 	}
 #endif /* CONFIG_BLK_DEV_IDEDOUBLER */
 
@@ -892,17 +871,17 @@ static int __init ide_setup(char *s)
 	if (!strcmp(s, "ide=noacpi")) {
 		//printk(" : Disable IDE ACPI support.\n");
 		ide_noacpi = 1;
-		return 1;
+		goto obsolete_option;
 	}
 	if (!strcmp(s, "ide=acpigtf")) {
 		//printk(" : Enable IDE ACPI _GTF support.\n");
-		ide_noacpitfs = 0;
-		return 1;
+		ide_acpigtf = 1;
+		goto obsolete_option;
 	}
 	if (!strcmp(s, "ide=acpionboot")) {
 		//printk(" : Call IDE ACPI methods on boot.\n");
-		ide_noacpionboot = 0;
-		return 1;
+		ide_acpionboot = 1;
+		goto obsolete_option;
 	}
 #endif /* CONFIG_BLK_DEV_IDEACPI */
 
@@ -912,7 +891,7 @@ static int __init ide_setup(char *s)
 	if (s[0] == 'h' && s[1] == 'd' && s[2] >= 'a' && s[2] <= max_drive) {
 		const char *hd_words[] = {
 			"none", "noprobe", "nowerr", "cdrom", "nodma",
-			"autotune", "noautotune", "-8", "-9", "-10",
+			"-6", "-7", "-8", "-9", "-10",
 			"noflush", "remap", "remap63", "scsi", NULL };
 		unit = s[2] - 'a';
 		hw   = unit / MAX_DRIVES;
@@ -927,28 +906,22 @@ static int __init ide_setup(char *s)
 			case -1: /* "none" */
 			case -2: /* "noprobe" */
 				drive->noprobe = 1;
-				goto done;
+				goto obsolete_option;
 			case -3: /* "nowerr" */
 				drive->bad_wstat = BAD_R_STAT;
-				goto done;
+				goto obsolete_option;
 			case -4: /* "cdrom" */
 				drive->present = 1;
 				drive->media = ide_cdrom;
 				/* an ATAPI device ignores DRDY */
 				drive->ready_stat = 0;
-				goto done;
+				goto obsolete_option;
 			case -5: /* nodma */
 				drive->nodma = 1;
-				goto done;
-			case -6: /* "autotune" */
-				drive->autotune = IDE_TUNE_AUTO;
-				goto obsolete_option;
-			case -7: /* "noautotune" */
-				drive->autotune = IDE_TUNE_NOAUTO;
 				goto obsolete_option;
 			case -11: /* noflush */
 				drive->noflush = 1;
-				goto done;
+				goto obsolete_option;
 			case -12: /* "remap" */
 				drive->remap_0_to_1 = 1;
 				goto obsolete_option;
@@ -966,7 +939,7 @@ static int __init ide_setup(char *s)
 				drive->sect	= drive->bios_sect = vals[2];
 				drive->present	= 1;
 				drive->forced_geom = 1;
-				goto done;
+				goto obsolete_option;
 			default:
 				goto bad_option;
 		}
@@ -984,126 +957,15 @@ static int __init ide_setup(char *s)
 			idebus_parameter = vals[0];
 		} else
 			printk(" -- BAD BUS SPEED! Expected value from 20 to 66");
-		goto done;
+		goto obsolete_option;
 	}
-	/*
-	 * Look for interface options:  "idex="
-	 */
-	if (s[3] >= '0' && s[3] <= max_hwif) {
-		/*
-		 * Be VERY CAREFUL changing this: note hardcoded indexes below
-		 * (-8, -9, -10) are reserved to ease the hardcoding.
-		 */
-		static const char *ide_words[] = {
-			"minus1", "serialize", "minus3", "minus4",
-			"reset", "minus6", "ata66", "minus8", "minus9",
-			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
-			"dtc2278", "umc8672", "ali14xx", NULL };
-
-		hw = s[3] - '0';
-		hwif = &ide_hwifs[hw];
-		i = match_parm(&s[4], ide_words, vals, 3);
-
-		/*
-		 * Cryptic check to ensure chipset not already set for hwif.
-		 * Note: we can't depend on hwif->chipset here.
-		 */
-		if (i >= -18 && i <= -11) {
-			/* chipset already specified */
-			if (is_chipset_set)
-				goto bad_option;
-			/* these drivers are for "ide0=" only */
-			if (hw != 0)
-				goto bad_hwif;
-			is_chipset_set = 1;
-			printk("\n");
-		}
-
-		switch (i) {
-#ifdef CONFIG_BLK_DEV_ALI14XX
-			case -17: /* "ali14xx" */
-				probe_ali14xx = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_UMC8672
-			case -16: /* "umc8672" */
-				probe_umc8672 = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_DTC2278
-			case -15: /* "dtc2278" */
-				probe_dtc2278 = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_CMD640
-			case -14: /* "cmd640_vlb" */
-				cmd640_vlb = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_HT6560B
-			case -13: /* "ht6560b" */
-				probe_ht6560b = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_QD65XX
-			case -12: /* "qd65xx" */
-				probe_qd65xx = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_4DRIVES
-			case -11: /* "four" drives on one set of ports */
-				probe_4drives = 1;
-				goto obsolete_option;
-#endif
-			case -10: /* minus10 */
-			case -9: /* minus9 */
-			case -8: /* minus8 */
-			case -6:
-			case -4:
-			case -3:
-				goto bad_option;
-			case -7: /* ata66 */
-#ifdef CONFIG_BLK_DEV_IDEPCI
-				/*
-				 * Use ATA_CBL_PATA40_SHORT so drive side
-				 * cable detection is also overriden.
-				 */
-				hwif->cbl = ATA_CBL_PATA40_SHORT;
-				goto obsolete_option;
-#else
-				goto bad_hwif;
-#endif
-			case -5: /* "reset" */
-				hwif->reset = 1;
-				goto obsolete_option;
-			case -2: /* "serialize" */
-				hwif->mate = &ide_hwifs[hw^1];
-				hwif->mate->mate = hwif;
-				hwif->serialized = hwif->mate->serialized = 1;
-				goto obsolete_option;
 
-			case -1:
-			case 0:
-			case 1:
-			case 2:
-			case 3:
-				goto bad_option;
-			default:
-				printk(" -- SUPPORT NOT CONFIGURED IN THIS KERNEL\n");
-				return 1;
-		}
-	}
 bad_option:
 	printk(" -- BAD OPTION\n");
 	return 1;
 obsolete_option:
 	printk(" -- OBSOLETE OPTION, WILL BE REMOVED SOON!\n");
 	return 1;
-bad_hwif:
-	printk("-- NOT SUPPORTED ON ide%d", hw);
-done:
-	printk("\n");
-	return 1;
 }
 
 EXPORT_SYMBOL(ide_lock);
@@ -1239,6 +1101,185 @@ static void ide_port_class_release(struct device *portdev)
 	put_device(&hwif->gendev);
 }
 
+int ide_vlb_clk;
+EXPORT_SYMBOL_GPL(ide_vlb_clk);
+
+module_param_named(vlb_clock, ide_vlb_clk, int, 0);
+MODULE_PARM_DESC(vlb_clock, "VLB clock frequency (in MHz)");
+
+int ide_pci_clk;
+EXPORT_SYMBOL_GPL(ide_pci_clk);
+
+module_param_named(pci_clock, ide_pci_clk, int, 0);
+MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
+
+static int ide_set_dev_param_mask(const char *s, struct kernel_param *kp)
+{
+	int a, b, i, j = 1;
+	unsigned int *dev_param_mask = (unsigned int *)kp->arg;
+
+	if (sscanf(s, "%d.%d:%d", &a, &b, &j) != 3 &&
+	    sscanf(s, "%d.%d", &a, &b) != 2)
+		return -EINVAL;
+
+	i = a * MAX_DRIVES + b;
+
+	if (i >= MAX_HWIFS * MAX_DRIVES || j < 0 || j > 1)
+		return -EINVAL;
+
+	if (j)
+		*dev_param_mask |= (1 << i);
+	else
+		*dev_param_mask &= (1 << i);
+
+	return 0;
+}
+
+static unsigned int ide_nodma;
+
+module_param_call(nodma, ide_set_dev_param_mask, NULL, &ide_nodma, 0);
+MODULE_PARM_DESC(nodma, "disallow DMA for a device");
+
+static unsigned int ide_noflush;
+
+module_param_call(noflush, ide_set_dev_param_mask, NULL, &ide_noflush, 0);
+MODULE_PARM_DESC(noflush, "disable flush requests for a device");
+
+static unsigned int ide_noprobe;
+
+module_param_call(noprobe, ide_set_dev_param_mask, NULL, &ide_noprobe, 0);
+MODULE_PARM_DESC(noprobe, "skip probing for a device");
+
+static unsigned int ide_nowerr;
+
+module_param_call(nowerr, ide_set_dev_param_mask, NULL, &ide_nowerr, 0);
+MODULE_PARM_DESC(nowerr, "ignore the WRERR_STAT bit for a device");
+
+static unsigned int ide_cdroms;
+
+module_param_call(cdrom, ide_set_dev_param_mask, NULL, &ide_cdroms, 0);
+MODULE_PARM_DESC(cdrom, "force device as a CD-ROM");
+
+struct chs_geom {
+	unsigned int	cyl;
+	u8		head;
+	u8		sect;
+};
+
+static unsigned int ide_disks;
+static struct chs_geom ide_disks_chs[MAX_HWIFS * MAX_DRIVES];
+
+static int ide_set_disk_chs(const char *str, struct kernel_param *kp)
+{
+	int a, b, c = 0, h = 0, s = 0, i, j = 1;
+
+	if (sscanf(str, "%d.%d:%d,%d,%d", &a, &b, &c, &h, &s) != 5 &&
+	    sscanf(str, "%d.%d:%d", &a, &b, &j) != 3)
+		return -EINVAL;
+
+	i = a * MAX_DRIVES + b;
+
+	if (i >= MAX_HWIFS * MAX_DRIVES || j < 0 || j > 1)
+		return -EINVAL;
+
+	if (c > INT_MAX || h > 255 || s > 255)
+		return -EINVAL;
+
+	if (j)
+		ide_disks |= (1 << i);
+	else
+		ide_disks &= (1 << i);
+
+	ide_disks_chs[i].cyl  = c;
+	ide_disks_chs[i].head = h;
+	ide_disks_chs[i].sect = s;
+
+	return 0;
+}
+
+module_param_call(chs, ide_set_disk_chs, NULL, NULL, 0);
+MODULE_PARM_DESC(chs, "force device as a disk (using CHS)");
+
+static void ide_dev_apply_params(ide_drive_t *drive)
+{
+	int i = drive->hwif->index * MAX_DRIVES + drive->select.b.unit;
+
+	if (ide_nodma & (1 << i)) {
+		printk(KERN_INFO "ide: disallowing DMA for %s\n", drive->name);
+		drive->nodma = 1;
+	}
+	if (ide_noflush & (1 << i)) {
+		printk(KERN_INFO "ide: disabling flush requests for %s\n",
+				 drive->name);
+		drive->noflush = 1;
+	}
+	if (ide_noprobe & (1 << i)) {
+		printk(KERN_INFO "ide: skipping probe for %s\n", drive->name);
+		drive->noprobe = 1;
+	}
+	if (ide_nowerr & (1 << i)) {
+		printk(KERN_INFO "ide: ignoring the WRERR_STAT bit for %s\n",
+				 drive->name);
+		drive->bad_wstat = BAD_R_STAT;
+	}
+	if (ide_cdroms & (1 << i)) {
+		printk(KERN_INFO "ide: forcing %s as a CD-ROM\n", drive->name);
+		drive->present = 1;
+		drive->media = ide_cdrom;
+		/* an ATAPI device ignores DRDY */
+		drive->ready_stat = 0;
+	}
+	if (ide_disks & (1 << i)) {
+		drive->cyl  = drive->bios_cyl  = ide_disks_chs[i].cyl;
+		drive->head = drive->bios_head = ide_disks_chs[i].head;
+		drive->sect = drive->bios_sect = ide_disks_chs[i].sect;
+		drive->forced_geom = 1;
+		printk(KERN_INFO "ide: forcing %s as a disk (%d/%d/%d)\n",
+				 drive->name,
+				 drive->cyl, drive->head, drive->sect);
+		drive->present = 1;
+		drive->media = ide_disk;
+		drive->ready_stat = READY_STAT;
+	}
+}
+
+static unsigned int ide_ignore_cable;
+
+static int ide_set_ignore_cable(const char *s, struct kernel_param *kp)
+{
+	int i, j = 1;
+
+	if (sscanf(s, "%d:%d", &i, &j) != 2 && sscanf(s, "%d", &i) != 1)
+		return -EINVAL;
+
+	if (i >= MAX_HWIFS || j < 0 || j > 1)
+		return -EINVAL;
+
+	if (j)
+		ide_ignore_cable |= (1 << i);
+	else
+		ide_ignore_cable &= (1 << i);
+
+	return 0;
+}
+
+module_param_call(ignore_cable, ide_set_ignore_cable, NULL, NULL, 0);
+MODULE_PARM_DESC(ignore_cable, "ignore cable detection");
+
+void ide_port_apply_params(ide_hwif_t *hwif)
+{
+	int i;
+
+	if (ide_ignore_cable & (1 << hwif->index)) {
+		printk(KERN_INFO "ide: ignoring cable detection for %s\n",
+				 hwif->name);
+		hwif->cbl = ATA_CBL_PATA40_SHORT;
+	}
+
+	for (i = 0; i < MAX_DRIVES; i++)
+		ide_dev_apply_params(&hwif->drives[i]);
+}
+
 /*
  * This is gets invoked once during initialization, to set *everything* up
  */
@@ -1305,11 +1346,6 @@ int __init init_module (void)
 
 void __exit cleanup_module (void)
 {
-	int index;
-
-	for (index = 0; index < MAX_HWIFS; ++index)
-		ide_unregister(index);
-
 	proc_ide_destroy();
 
 	class_destroy(ide_port_class);
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 6efbf94..90c65cf 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -116,7 +116,7 @@ static void ali14xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	int time1, time2;
 	u8 param1, param2, param3, param4;
 	unsigned long flags;
-	int bus_speed = system_bus_clock();
+	int bus_speed = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
 
 	/* calculate timing, according to PIO mode */
 	time1 = ide_pio_cycle_time(drive, pio);
@@ -202,7 +202,7 @@ static const struct ide_port_info ali14xx_port_info = {
 	.name			= DRV_NAME,
 	.chipset		= ide_ali14xx,
 	.port_ops		= &ali14xx_port_ops,
-	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
+	.host_flags		= IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
 };
 
@@ -220,7 +220,7 @@ static int __init ali14xx_probe(void)
 	return ide_legacy_device_add(&ali14xx_port_info, 0);
 }
 
-int probe_ali14xx;
+static int probe_ali14xx;
 
 module_param_named(probe, probe_ali14xx, bool, 0);
 MODULE_PARM_DESC(probe, "probe for ALI M14xx chipsets");
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index f51433b..5c730e4 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -102,7 +102,7 @@ static int buddha_ack_intr(ide_hwif_t *hwif)
 {
     unsigned char ch;
 
-    ch = z_readb(hwif->io_ports[IDE_IRQ_OFFSET]);
+    ch = z_readb(hwif->io_ports.irq_addr);
     if (!(ch & 0x80))
 	    return 0;
     return 1;
@@ -112,9 +112,9 @@ static int xsurf_ack_intr(ide_hwif_t *hwif)
 {
     unsigned char ch;
 
-    ch = z_readb(hwif->io_ports[IDE_IRQ_OFFSET]);
+    ch = z_readb(hwif->io_ports.irq_addr);
     /* X-Surf needs a 0 written to IRQ register to ensure ISA bit A11 stays at 0 */
-    z_writeb(0, hwif->io_ports[IDE_IRQ_OFFSET]); 
+    z_writeb(0, hwif->io_ports.irq_addr);
     if (!(ch & 0x80))
 	    return 0;
     return 1;
@@ -128,13 +128,13 @@ static void __init buddha_setup_ports(hw_regs_t *hw, unsigned long base,
 
 	memset(hw, 0, sizeof(*hw));
 
-	hw->io_ports[IDE_DATA_OFFSET] = base;
+	hw->io_ports.data_addr = base;
 
 	for (i = 1; i < 8; i++)
-		hw->io_ports[i] = base + 2 + i * 4;
+		hw->io_ports_array[i] = base + 2 + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ctl;
-	hw->io_ports[IDE_IRQ_OFFSET] = irq_port;
+	hw->io_ports.ctl_addr = ctl;
+	hw->io_ports.irq_addr = irq_port;
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index f7c4ad1..af791a0 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -101,8 +101,7 @@ static const struct ide_port_info dtc2278_port_info __initdata = {
 				  IDE_HFLAG_IO_32BIT |
 				  /* disallow ->io_32bit changes */
 				  IDE_HFLAG_NO_IO_32BIT |
-				  IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_NO_AUTOTUNE,
+				  IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
 };
 
@@ -131,7 +130,7 @@ static int __init dtc2278_probe(void)
 	return ide_legacy_device_add(&dtc2278_port_info, 0);
 }
 
-int probe_dtc2278 = 0;
+static int probe_dtc2278;
 
 module_param_named(probe, probe_dtc2278, bool, 0);
 MODULE_PARM_DESC(probe, "probe for DTC2278xx chipsets");
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index 5c19c42..56cdaa0 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -50,12 +50,12 @@ static void __init falconide_setup_ports(hw_regs_t *hw)
 
 	memset(hw, 0, sizeof(*hw));
 
-	hw->io_ports[IDE_DATA_OFFSET] = ATA_HD_BASE;
+	hw->io_ports.data_addr = ATA_HD_BASE;
 
 	for (i = 1; i < 8; i++)
-		hw->io_ports[i] = ATA_HD_BASE + 1 + i * 4;
+		hw->io_ports_array[i] = ATA_HD_BASE + 1 + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ATA_HD_BASE + ATA_HD_CONTROL;
+	hw->io_ports.ctl_addr = ATA_HD_BASE + ATA_HD_CONTROL;
 
 	hw->irq = IRQ_MFP_IDE;
 	hw->ack_intr = NULL;
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index a0c9601..a9c2593 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -63,6 +63,8 @@
 #define GAYLE_HAS_CONTROL_REG	(!ide_doubler)
 #define GAYLE_IDEREG_SIZE	(ide_doubler ? 0x1000 : 0x2000)
 int ide_doubler = 0;	/* support IDE doublers? */
+module_param_named(doubler, ide_doubler, bool, 0);
+MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
 #endif /* CONFIG_BLK_DEV_IDEDOUBLER */
 
 
@@ -74,7 +76,7 @@ static int gayle_ack_intr_a4000(ide_hwif_t *hwif)
 {
     unsigned char ch;
 
-    ch = z_readb(hwif->io_ports[IDE_IRQ_OFFSET]);
+    ch = z_readb(hwif->io_ports.irq_addr);
     if (!(ch & GAYLE_IRQ_IDE))
 	return 0;
     return 1;
@@ -84,11 +86,11 @@ static int gayle_ack_intr_a1200(ide_hwif_t *hwif)
 {
     unsigned char ch;
 
-    ch = z_readb(hwif->io_ports[IDE_IRQ_OFFSET]);
+    ch = z_readb(hwif->io_ports.irq_addr);
     if (!(ch & GAYLE_IRQ_IDE))
 	return 0;
-    (void)z_readb(hwif->io_ports[IDE_STATUS_OFFSET]);
-    z_writeb(0x7c, hwif->io_ports[IDE_IRQ_OFFSET]);
+    (void)z_readb(hwif->io_ports.status_addr);
+    z_writeb(0x7c, hwif->io_ports.irq_addr);
     return 1;
 }
 
@@ -100,13 +102,13 @@ static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
 
 	memset(hw, 0, sizeof(*hw));
 
-	hw->io_ports[IDE_DATA_OFFSET] = base;
+	hw->io_ports.data_addr = base;
 
 	for (i = 1; i < 8; i++)
-		hw->io_ports[i] = base + 2 + i * 4;
+		hw->io_ports_array[i] = base + 2 + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ctl;
-	hw->io_ports[IDE_IRQ_OFFSET] = irq_port;
+	hw->io_ports.ctl_addr = ctl;
+	hw->io_ports.irq_addr = irq_port;
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 702d8de..4fe516d 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -157,8 +157,8 @@ static void ht6560b_selectproc (ide_drive_t *drive)
 		/*
 		 * Set timing for this drive:
 		 */
-		outb(timing, hwif->io_ports[IDE_SELECT_OFFSET]);
-		(void)inb(hwif->io_ports[IDE_STATUS_OFFSET]);
+		outb(timing, hwif->io_ports.device_addr);
+		(void)inb(hwif->io_ports.status_addr);
 #ifdef DEBUG
 		printk("ht6560b: %s: select=%#x timing=%#x\n",
 			drive->name, select, timing);
@@ -212,8 +212,8 @@ static u8 ht_pio2timings(ide_drive_t *drive, const u8 pio)
 {
 	int active_time, recovery_time;
 	int active_cycles, recovery_cycles;
-	int bus_speed = system_bus_clock();
-	
+	int bus_speed = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+
         if (pio) {
 		unsigned int cycle_time;
 
@@ -323,7 +323,7 @@ static void __init ht6560b_port_init_devs(ide_hwif_t *hwif)
 	hwif->drives[1].drive_data = t;
 }
 
-int probe_ht6560b = 0;
+static int probe_ht6560b;
 
 module_param_named(probe, probe_ht6560b, bool, 0);
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
@@ -340,7 +340,6 @@ static const struct ide_port_info ht6560b_port_info __initdata = {
 	.port_ops		= &ht6560b_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
 				  IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_NO_AUTOTUNE |
 				  IDE_HFLAG_ABUSE_PREFETCH,
 	.pio_mask		= ATA_PIO4,
 };
diff --git a/drivers/ide/legacy/ide-4drives.c b/drivers/ide/legacy/ide-4drives.c
index 17f94d0..ecae916 100644
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -6,7 +6,7 @@
 
 #define DRV_NAME "ide-4drives"
 
-int probe_4drives;
+static int probe_4drives;
 
 module_param_named(probe, probe_4drives, bool, 0);
 MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index 855e157..aa2ea3d 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -140,8 +140,8 @@ static void ide_detach(struct pcmcia_device *link)
 
     ide_release(link);
 
-    release_region(hwif->io_ports[IDE_CONTROL_OFFSET], 1);
-    release_region(hwif->io_ports[IDE_DATA_OFFSET], 8);
+    release_region(hwif->io_ports.ctl_addr, 1);
+    release_region(hwif->io_ports.data_addr, 8);
 
     kfree(info);
 } /* ide_detach */
@@ -183,11 +183,7 @@ static ide_hwif_t *idecs_register(unsigned long io, unsigned long ctl,
 
     i = hwif->index;
 
-    if (hwif->present)
-	ide_unregister(i);
-    else
-	ide_init_port_data(hwif, i);
-
+    ide_init_port_data(hwif, i);
     ide_init_port_hw(hwif, &hw);
     hwif->port_ops = &idecs_port_ops;
 
@@ -390,7 +386,7 @@ void ide_release(struct pcmcia_device *link)
     if (info->ndev) {
 	/* FIXME: if this fails we need to queue the cleanup somehow
 	   -- need to investigate the required PCMCIA magic */
-	ide_unregister(hwif->index);
+	ide_unregister(hwif);
     }
     info->ndev = 0;
 
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index 822f48b..8279dc7 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -30,14 +30,14 @@ static void __devinit plat_ide_setup_ports(hw_regs_t *hw,
 	unsigned long port = (unsigned long)base;
 	int i;
 
-	hw->io_ports[IDE_DATA_OFFSET] = port;
+	hw->io_ports.data_addr = port;
 
 	port += (1 << pdata->ioport_shift);
-	for (i = IDE_ERROR_OFFSET; i <= IDE_STATUS_OFFSET;
+	for (i = 1; i <= 7;
 	     i++, port += (1 << pdata->ioport_shift))
-		hw->io_ports[i] = port;
+		hw->io_ports_array[i] = port;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
+	hw->io_ports.ctl_addr = (unsigned long)ctrl;
 
 	hw->irq = irq;
 
@@ -120,7 +120,7 @@ static int __devexit plat_ide_remove(struct platform_device *pdev)
 {
 	ide_hwif_t *hwif = pdev->dev.driver_data;
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index 26546d0..1f527bb 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -72,9 +72,9 @@ static void __init macide_setup_ports(hw_regs_t *hw, unsigned long base,
 	memset(hw, 0, sizeof(*hw));
 
 	for (i = 0; i < 8; i++)
-		hw->io_ports[i] = base + i * 4;
+		hw->io_ports_array[i] = base + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = base + IDE_CONTROL;
+	hw->io_ports.ctl_addr = base + IDE_CONTROL;
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index f23999d..a3573d4 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -80,10 +80,10 @@ void q40_ide_setup_ports ( hw_regs_t *hw,
 	for (i = 0; i < IDE_NR_PORTS; i++) {
 		/* BIG FAT WARNING: 
 		   assumption: only DATA port is ever used in 16 bit mode */
-		if ( i==0 )
-			hw->io_ports[i] = Q40_ISA_IO_W(base + offsets[i]);
+		if (i == 0)
+			hw->io_ports_array[i] = Q40_ISA_IO_W(base + offsets[i]);
 		else
-			hw->io_ports[i] = Q40_ISA_IO_B(base + offsets[i]);
+			hw->io_ports_array[i] = Q40_ISA_IO_B(base + offsets[i]);
 	}
 
 	hw->irq = irq;
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 15a99aa..6424af1 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -11,11 +11,7 @@
  *
  * QDI QD6500/QD6580 EIDE controller fast support
  *
- * Please set local bus speed using kernel parameter idebus
- * 	for example, "idebus=33" stands for 33Mhz VLbus
  * To activate controller support, use "ide0=qd65xx"
- * To enable tuning, use "hda=autotune hdb=autotune"
- * To enable 2nd channel tuning (qd6580 only), use "hdc=autotune hdd=autotune"
  */
 
 /*
@@ -114,17 +110,18 @@ static void qd65xx_select(ide_drive_t *drive)
 
 static u8 qd6500_compute_timing (ide_hwif_t *hwif, int active_time, int recovery_time)
 {
-	u8 active_cycle,recovery_cycle;
+	int clk = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	u8 act_cyc, rec_cyc;
 
-	if (system_bus_clock()<=33) {
-		active_cycle =   9  - IDE_IN(active_time   * system_bus_clock() / 1000 + 1, 2, 9);
-		recovery_cycle = 15 - IDE_IN(recovery_time * system_bus_clock() / 1000 + 1, 0, 15);
+	if (clk <= 33) {
+		act_cyc =  9 - IDE_IN(active_time   * clk / 1000 + 1, 2,  9);
+		rec_cyc = 15 - IDE_IN(recovery_time * clk / 1000 + 1, 0, 15);
 	} else {
-		active_cycle =   8  - IDE_IN(active_time   * system_bus_clock() / 1000 + 1, 1, 8);
-		recovery_cycle = 18 - IDE_IN(recovery_time * system_bus_clock() / 1000 + 1, 3, 18);
+		act_cyc =  8 - IDE_IN(active_time   * clk / 1000 + 1, 1,  8);
+		rec_cyc = 18 - IDE_IN(recovery_time * clk / 1000 + 1, 3, 18);
 	}
 
-	return((recovery_cycle<<4) | 0x08 | active_cycle);
+	return (rec_cyc << 4) | 0x08 | act_cyc;
 }
 
 /*
@@ -135,10 +132,13 @@ static u8 qd6500_compute_timing (ide_hwif_t *hwif, int active_time, int recovery
 
 static u8 qd6580_compute_timing (int active_time, int recovery_time)
 {
-	u8 active_cycle   = 17 - IDE_IN(active_time   * system_bus_clock() / 1000 + 1, 2, 17);
-	u8 recovery_cycle = 15 - IDE_IN(recovery_time * system_bus_clock() / 1000 + 1, 2, 15);
+	int clk = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	u8 act_cyc, rec_cyc;
 
-	return((recovery_cycle<<4) | active_cycle);
+	act_cyc = 17 - IDE_IN(active_time   * clk / 1000 + 1, 2, 17);
+	rec_cyc = 15 - IDE_IN(recovery_time * clk / 1000 + 1, 2, 15);
+
+	return (rec_cyc << 4) | act_cyc;
 }
 
 /*
@@ -322,8 +322,7 @@ static const struct ide_port_info qd65xx_port_info __initdata = {
 	.name			= DRV_NAME,
 	.chipset		= ide_qd65xx,
 	.host_flags		= IDE_HFLAG_IO_32BIT |
-				  IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_NO_AUTOTUNE,
+				  IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
 };
 
@@ -399,7 +398,7 @@ static int __init qd_probe(int base)
 	return rc;
 }
 
-int probe_qd65xx = 0;
+static int probe_qd65xx;
 
 module_param_named(probe, probe_qd65xx, bool, 0);
 MODULE_PARM_DESC(probe, "probe for QD65xx chipsets");
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index 17d5153..b54a14a 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -130,7 +130,7 @@ static const struct ide_port_info umc8672_port_info __initdata = {
 	.name			= DRV_NAME,
 	.chipset		= ide_umc8672,
 	.port_ops		= &umc8672_port_ops,
-	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
+	.host_flags		= IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
 };
 
@@ -158,7 +158,7 @@ static int __init umc8672_probe(void)
 	return ide_legacy_device_add(&umc8672_port_info, 0);
 }
 
-int probe_umc8672;
+static int probe_umc8672;
 
 module_param_named(probe, probe_umc8672, bool, 0);
 MODULE_PARM_DESC(probe, "probe for UMC8672 chipset");
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 3485a31..296b9c6 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -502,12 +502,11 @@ static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 static void auide_setup_ports(hw_regs_t *hw, _auide_hwif *ahwif)
 {
 	int i;
-	unsigned long *ata_regs = hw->io_ports;
+	unsigned long *ata_regs = hw->io_ports_array;
 
 	/* FIXME? */
-	for (i = 0; i < IDE_CONTROL_OFFSET; i++) {
+	for (i = 0; i < 8; i++)
 		*ata_regs++ = ahwif->regbase + (i << AU1XXX_ATA_REG_OFFSET);
-	}
 
 	/* set the Alternative Status register */
 	*ata_regs = ahwif->regbase + (14 << AU1XXX_ATA_REG_OFFSET);
@@ -627,7 +626,7 @@ static int au_ide_remove(struct device *dev)
 	ide_hwif_t *hwif = dev_get_drvdata(dev);
 	_auide_hwif *ahwif = &auide_hwif;
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif);
 
 	iounmap((void *)ahwif->regbase);
 
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
index 112fe56..6894762 100644
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -113,10 +113,10 @@ static int __devinit swarm_ide_probe(struct device *dev)
 
 	hwif->chipset = ide_generic;
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		hwif->io_ports[i] =
+	for (i = 0; i <= 7; i++)
+		hwif->io_ports_array[i] =
 				(unsigned long)(base + ((0x1f0 + i) << 5));
-	hwif->io_ports[IDE_CONTROL_OFFSET] =
+	hwif->io_ports.ctl_addr =
 				(unsigned long)(base + (0x3f6 << 5));
 	hwif->irq = K_INT_GB_IDE;
 
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index ca16f37..7f46c22 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -140,7 +140,7 @@ static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
 {
-	int bus_speed = system_bus_clock();
+	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
 
 	if (bus_speed <= 33)
 		pci_set_drvdata(dev, (void *) aec6xxx_33_base);
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index b5a3bc3..b36a22b 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -38,8 +38,6 @@
 
 #include <asm/io.h>
 
-#define DISPLAY_ALI_TIMINGS
-
 /*
  *	ALi devices are not plug in. Otherwise these static values would
  *	need to go. They ought to go away anyway
@@ -49,236 +47,6 @@ static u8 m5229_revision;
 static u8 chip_is_1543c_e;
 static struct pci_dev *isa_dev;
 
-#if defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
-#include <linux/stat.h>
-#include <linux/proc_fs.h>
-
-static u8 ali_proc = 0;
-
-static struct pci_dev *bmide_dev;
-
-static char *fifo[4] = {
-	"FIFO Off",
-	"FIFO On ",
-	"DMA mode",
-	"PIO mode" };
-
-static char *udmaT[8] = {
-	"1.5T",
-	"  2T",
-	"2.5T",
-	"  3T",
-	"3.5T",
-	"  4T",
-	"  6T",
-	"  8T"
-};
-
-static char *channel_status[8] = {
-	"OK            ",
-	"busy          ",
-	"DRQ           ",
-	"DRQ busy      ",
-	"error         ",
-	"error busy    ",
-	"error DRQ     ",
-	"error DRQ busy"
-};
-
-/**
- *	ali_get_info		-	generate proc file for ALi IDE
- *	@buffer: buffer to fill
- *	@addr: address of user start in buffer
- *	@offset: offset into 'file'
- *	@count: buffer count
- *
- *	Walks the Ali devices and outputs summary data on the tuning and
- *	anything else that will help with debugging
- */
- 
-static int ali_get_info (char *buffer, char **addr, off_t offset, int count)
-{
-	unsigned long bibma;
-	u8 reg53h, reg5xh, reg5yh, reg5xh1, reg5yh1, c0, c1, rev, tmp;
-	char *q, *p = buffer;
-
-	/* fetch rev. */
-	pci_read_config_byte(bmide_dev, 0x08, &rev);
-	if (rev >= 0xc1)	/* M1543C or newer */
-		udmaT[7] = " ???";
-	else
-		fifo[3]  = "   ???  ";
-
-	/* first fetch bibma: */
-	
-	bibma = pci_resource_start(bmide_dev, 4);
-
-	/*
-	 * at that point bibma+0x2 et bibma+0xa are byte
-	 * registers to investigate:
-	 */
-	c0 = inb(bibma + 0x02);
-	c1 = inb(bibma + 0x0a);
-
-	p += sprintf(p,
-		"\n                                Ali M15x3 Chipset.\n");
-	p += sprintf(p,
-		"                                ------------------\n");
-	pci_read_config_byte(bmide_dev, 0x78, &reg53h);
-	p += sprintf(p, "PCI Clock: %d.\n", reg53h);
-
-	pci_read_config_byte(bmide_dev, 0x53, &reg53h);
-	p += sprintf(p,
-		"CD_ROM FIFO:%s, CD_ROM DMA:%s\n",
-		(reg53h & 0x02) ? "Yes" : "No ",
-		(reg53h & 0x01) ? "Yes" : "No " );
-	pci_read_config_byte(bmide_dev, 0x74, &reg53h);
-	p += sprintf(p,
-		"FIFO Status: contains %d Words, runs%s%s\n\n",
-		(reg53h & 0x3f),
-		(reg53h & 0x40) ? " OVERWR" : "",
-		(reg53h & 0x80) ? " OVERRD." : "." );
-
-	p += sprintf(p,
-		"-------------------primary channel"
-		"-------------------secondary channel"
-		"---------\n\n");
-
-	pci_read_config_byte(bmide_dev, 0x09, &reg53h);
-	p += sprintf(p,
-		"channel status:       %s"
-		"                               %s\n",
-		(reg53h & 0x20) ? "On " : "Off",
-		(reg53h & 0x10) ? "On " : "Off" );
-
-	p += sprintf(p,
-		"both channels togth:  %s"
-		"                               %s\n",
-		(c0&0x80) ? "No " : "Yes",
-		(c1&0x80) ? "No " : "Yes" );
-
-	pci_read_config_byte(bmide_dev, 0x76, &reg53h);
-	p += sprintf(p,
-		"Channel state:        %s                    %s\n",
-		channel_status[reg53h & 0x07],
-		channel_status[(reg53h & 0x70) >> 4] );
-
-	pci_read_config_byte(bmide_dev, 0x58, &reg5xh);
-	pci_read_config_byte(bmide_dev, 0x5c, &reg5yh);
-	p += sprintf(p,
-		"Add. Setup Timing:    %dT"
-		"                                %dT\n",
-		(reg5xh & 0x07) ? (reg5xh & 0x07) : 8,
-		(reg5yh & 0x07) ? (reg5yh & 0x07) : 8 );
-
-	pci_read_config_byte(bmide_dev, 0x59, &reg5xh);
-	pci_read_config_byte(bmide_dev, 0x5d, &reg5yh);
-	p += sprintf(p,
-		"Command Act. Count:   %dT"
-		"                                %dT\n"
-		"Command Rec. Count:   %dT"
-		"                               %dT\n\n",
-		(reg5xh & 0x70) ? ((reg5xh & 0x70) >> 4) : 8,
-		(reg5yh & 0x70) ? ((reg5yh & 0x70) >> 4) : 8, 
-		(reg5xh & 0x0f) ? (reg5xh & 0x0f) : 16,
-		(reg5yh & 0x0f) ? (reg5yh & 0x0f) : 16 );
-
-	p += sprintf(p,
-		"----------------drive0-----------drive1"
-		"------------drive0-----------drive1------\n\n");
-	p += sprintf(p,
-		"DMA enabled:      %s              %s"
-		"               %s              %s\n",
-		(c0&0x20) ? "Yes" : "No ",
-		(c0&0x40) ? "Yes" : "No ",
-		(c1&0x20) ? "Yes" : "No ",
-		(c1&0x40) ? "Yes" : "No " );
-
-	pci_read_config_byte(bmide_dev, 0x54, &reg5xh);
-	pci_read_config_byte(bmide_dev, 0x55, &reg5yh);
-	q = "FIFO threshold:   %2d Words         %2d Words"
-		"          %2d Words         %2d Words\n";
-	if (rev < 0xc1) {
-		if ((rev == 0x20) &&
-		    (pci_read_config_byte(bmide_dev, 0x4f, &tmp), (tmp &= 0x20))) {
-			p += sprintf(p, q, 8, 8, 8, 8);
-		} else {
-			p += sprintf(p, q,
-				(reg5xh & 0x03) + 12,
-				((reg5xh & 0x30)>>4) + 12,
-				(reg5yh & 0x03) + 12,
-				((reg5yh & 0x30)>>4) + 12 );
-		}
-	} else {
-		int t1 = (tmp = (reg5xh & 0x03)) ? (tmp << 3) : 4;
-		int t2 = (tmp = ((reg5xh & 0x30)>>4)) ? (tmp << 3) : 4;
-		int t3 = (tmp = (reg5yh & 0x03)) ? (tmp << 3) : 4;
-		int t4 = (tmp = ((reg5yh & 0x30)>>4)) ? (tmp << 3) : 4;
-		p += sprintf(p, q, t1, t2, t3, t4);
-	}
-
-#if 0
-	p += sprintf(p, 
-		"FIFO threshold:   %2d Words         %2d Words"
-		"          %2d Words         %2d Words\n",
-		(reg5xh & 0x03) + 12,
-		((reg5xh & 0x30)>>4) + 12,
-		(reg5yh & 0x03) + 12,
-		((reg5yh & 0x30)>>4) + 12 );
-#endif
-
-	p += sprintf(p,
-		"FIFO mode:        %s         %s          %s         %s\n",
-		fifo[((reg5xh & 0x0c) >> 2)],
-		fifo[((reg5xh & 0xc0) >> 6)],
-		fifo[((reg5yh & 0x0c) >> 2)],
-		fifo[((reg5yh & 0xc0) >> 6)] );
-
-	pci_read_config_byte(bmide_dev, 0x5a, &reg5xh);
-	pci_read_config_byte(bmide_dev, 0x5b, &reg5xh1);
-	pci_read_config_byte(bmide_dev, 0x5e, &reg5yh);
-	pci_read_config_byte(bmide_dev, 0x5f, &reg5yh1);
-
-	p += sprintf(p,/*
-		"------------------drive0-----------drive1"
-		"------------drive0-----------drive1------\n")*/
-		"Dt RW act. Cnt    %2dT              %2dT"
-		"               %2dT              %2dT\n"
-		"Dt RW rec. Cnt    %2dT              %2dT"
-		"               %2dT              %2dT\n\n",
-		(reg5xh & 0x70) ? ((reg5xh & 0x70) >> 4) : 8,
-		(reg5xh1 & 0x70) ? ((reg5xh1 & 0x70) >> 4) : 8,
-		(reg5yh & 0x70) ? ((reg5yh & 0x70) >> 4) : 8,
-		(reg5yh1 & 0x70) ? ((reg5yh1 & 0x70) >> 4) : 8,
-		(reg5xh & 0x0f) ? (reg5xh & 0x0f) : 16,
-		(reg5xh1 & 0x0f) ? (reg5xh1 & 0x0f) : 16,
-		(reg5yh & 0x0f) ? (reg5yh & 0x0f) : 16,
-		(reg5yh1 & 0x0f) ? (reg5yh1 & 0x0f) : 16 );
-
-	p += sprintf(p,
-		"-----------------------------------UDMA Timings"
-		"--------------------------------\n\n");
-
-	pci_read_config_byte(bmide_dev, 0x56, &reg5xh);
-	pci_read_config_byte(bmide_dev, 0x57, &reg5yh);
-	p += sprintf(p,
-		"UDMA:             %s               %s"
-		"                %s               %s\n"
-		"UDMA timings:     %s             %s"
-		"              %s             %s\n\n",
-		(reg5xh & 0x08) ? "OK" : "No",
-		(reg5xh & 0x80) ? "OK" : "No",
-		(reg5yh & 0x08) ? "OK" : "No",
-		(reg5yh & 0x80) ? "OK" : "No",
-		udmaT[(reg5xh & 0x07)],
-		udmaT[(reg5xh & 0x70) >> 4],
-		udmaT[reg5yh & 0x07],
-		udmaT[(reg5yh & 0x70) >> 4] );
-
-	return p-buffer; /* => must be less than 4k! */
-}
-#endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
-
 /**
  *	ali_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
@@ -294,7 +62,7 @@ static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	int s_time, a_time, c_time;
 	u8 s_clc, a_clc, r_clc;
 	unsigned long flags;
-	int bus_speed = system_bus_clock();
+	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
 	int port = hwif->channel ? 0x5c : 0x58;
 	int portFIFO = hwif->channel ? 0x55 : 0x54;
 	u8 cd_dma_fifo = 0;
@@ -465,14 +233,6 @@ static unsigned int __devinit init_chipset_ali15x3 (struct pci_dev *dev, const c
 
 	isa_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 
-#if defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
-	if (!ali_proc) {
-		ali_proc = 1;
-		bmide_dev = dev;
-		ide_pci_create_host_proc("ali", ali_get_info);
-	}
-#endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
-
 	local_irq_save(flags);
 
 	if (m5229_revision < 0xC2) {
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index f7c8838..efcf543 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -179,7 +179,7 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev,
  * Determine the system bus clock.
  */
 
-	amd_clock = system_bus_clock() * 1000;
+	amd_clock = (ide_pci_clk ? ide_pci_clk : system_bus_clock()) * 1000;
 
 	switch (amd_clock) {
 		case 33000: amd_clock = 33333; break;
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index 25c2f1b..aaf3810 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -111,10 +111,7 @@
 
 #define DRV_NAME "cmd640"
 
-/*
- * This flag is set in ide.c by the parameter:  ide0=cmd640_vlb
- */
-int cmd640_vlb;
+static int cmd640_vlb;
 
 /*
  * CMD640 specific registers definition.
@@ -350,12 +347,12 @@ static int __init secondary_port_responding(void)
 
 	spin_lock_irqsave(&cmd640_lock, flags);
 
-	outb_p(0x0a, 0x170 + IDE_SELECT_OFFSET);	/* select drive0 */
+	outb_p(0x0a, 0x176);	/* select drive0 */
 	udelay(100);
-	if ((inb_p(0x170 + IDE_SELECT_OFFSET) & 0x1f) != 0x0a) {
-		outb_p(0x1a, 0x170 + IDE_SELECT_OFFSET); /* select drive1 */
+	if ((inb_p(0x176) & 0x1f) != 0x0a) {
+		outb_p(0x1a, 0x176); /* select drive1 */
 		udelay(100);
-		if ((inb_p(0x170 + IDE_SELECT_OFFSET) & 0x1f) != 0x1a) {
+		if ((inb_p(0x176) & 0x1f) != 0x1a) {
 			spin_unlock_irqrestore(&cmd640_lock, flags);
 			return 0; /* nothing responded */
 		}
@@ -383,6 +380,7 @@ static void cmd640_dump_regs(void)
 }
 #endif
 
+#ifndef CONFIG_BLK_DEV_CMD640_ENHANCED
 /*
  * Check whether prefetch is on for a drive,
  * and initialize the unmask flags for safe operation.
@@ -403,9 +401,7 @@ static void __init check_prefetch(ide_drive_t *drive, unsigned int index)
 		drive->no_io_32bit = 0;
 	}
 }
-
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-
+#else
 /*
  * Sets prefetch mode for a drive.
  */
@@ -462,34 +458,6 @@ static inline u8 pack_nibbles(u8 upper, u8 lower)
 }
 
 /*
- * This routine retrieves the initial drive timings from the chipset.
- */
-static void __init retrieve_drive_counts(unsigned int index)
-{
-	u8 b;
-
-	/*
-	 * Get the internal setup timing, and convert to clock count
-	 */
-	b = get_cmd640_reg(arttim_regs[index]) & ~0x3f;
-	switch (b) {
-	case 0x00: b = 4; break;
-	case 0x80: b = 3; break;
-	case 0x40: b = 2; break;
-	default:   b = 5; break;
-	}
-	setup_counts[index] = b;
-
-	/*
-	 * Get the active/recovery counts
-	 */
-	b = get_cmd640_reg(drwtim_regs[index]);
-	active_counts[index]   = (b >> 4)   ? (b >> 4)   : 0x10;
-	recovery_counts[index] = (b & 0x0f) ? (b & 0x0f) : 0x10;
-}
-
-
-/*
  * This routine writes the prepared setup/active/recovery counts
  * for a drive into the cmd640 chipset registers to active them.
  */
@@ -555,7 +523,14 @@ static void cmd640_set_mode(ide_drive_t *drive, unsigned int index,
 {
 	int setup_time, active_time, recovery_time, clock_time;
 	u8 setup_count, active_count, recovery_count, recovery_count2, cycle_count;
-	int bus_speed = system_bus_clock();
+	int bus_speed;
+
+	if (cmd640_vlb && ide_vlb_clk)
+		bus_speed = ide_vlb_clk;
+	else if (!cmd640_vlb && ide_pci_clk)
+		bus_speed = ide_pci_clk;
+	else
+		bus_speed = system_bus_clock();
 
 	if (pio_mode > 5)
 		pio_mode = 5;
@@ -679,7 +654,6 @@ static const struct ide_port_info cmd640_port_info __initdata = {
 	.chipset		= ide_cmd640,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_NO_AUTOTUNE |
 				  IDE_HFLAG_ABUSE_PREFETCH |
 				  IDE_HFLAG_ABUSE_FAST_DEVSEL,
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
@@ -862,29 +836,16 @@ static int __init cmd640x_init(void)
 		}
 
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-		if (drive->autotune || ((index > 1) && second_port_toggled)) {
-			/*
-			 * Reset timing to the slowest speed and turn off
-			 * prefetch.  This way, the drive identify code has
-			 * a better chance.
-			 */
-			setup_counts    [index] = 4;	/* max possible */
-			active_counts   [index] = 16;	/* max possible */
-			recovery_counts [index] = 16;	/* max possible */
-			program_drive_counts(drive, index);
-			set_prefetch_mode(drive, index, 0);
-			printk("cmd640: drive%d timings/prefetch cleared\n", index);
-		} else {
-			/*
-			 * Record timings/prefetch without changing them.
-			 * This preserves any prior BIOS setup.
-			 */
-			retrieve_drive_counts (index);
-			check_prefetch(drive, index);
-			printk("cmd640: drive%d timings/prefetch(%s) preserved",
-				index, drive->no_io_32bit ? "off" : "on");
-			display_clocks(index);
-		}
+		/*
+		 * Reset timing to the slowest speed and turn off prefetch.
+		 * This way, the drive identify code has a better chance.
+		 */
+		setup_counts    [index] = 4;	/* max possible */
+		active_counts   [index] = 16;	/* max possible */
+		recovery_counts [index] = 16;	/* max possible */
+		program_drive_counts(drive, index);
+		set_prefetch_mode(drive, index, 0);
+		printk("cmd640: drive%d timings/prefetch cleared\n", index);
 #else
 		/*
 		 * Set the drive unmask flags to match the prefetch setting
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 006fb62..0867471 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -68,8 +68,8 @@ static u8 quantize_timing(int timing, int quant)
  */
 static void program_cycle_times (ide_drive_t *drive, int cycle_time, int active_time)
 {
-	struct pci_dev *dev	= to_pci_dev(drive->hwif->dev);
-	int clock_time		= 1000 / system_bus_clock();
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
+	int clock_time = 1000 / (ide_pci_clk ? ide_pci_clk : system_bus_clock());
 	u8  cycle_count, active_count, recovery_count, drwtim;
 	static const u8 recovery_values[] =
 		{15, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0};
@@ -128,7 +128,7 @@ static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 			    ide_pio_timings[pio].active_time);
 
 	setup_count = quantize_timing(ide_pio_timings[pio].setup_time,
-				      1000 / system_bus_clock());
+			1000 / (ide_pci_clk ? ide_pci_clk : system_bus_clock()));
 
 	/*
 	 * The primary channel has individual address setup timing registers
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index e30eae5..77cc22c 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -18,8 +18,6 @@
  *   hdparm -t reports 8.17 MB/sec at about 6% CPU usage for the DTTA
  * - this is my first linux driver, so there's probably a lot  of room
  *   for optimizations and bug fixing, so feel free to do it.
- * - use idebus=xx parameter to set PCI bus speed - needed to calc
- *   timings for PIO modes (default will be 40)
  * - if using PIO mode it's a good idea to set the PIO mode and
  *   32-bit I/O support (if possible), e.g. hdparm -p2 -c1 /dev/hda
  * - I had some problems with my IBM DHEA with PIO modes < 2
@@ -136,7 +134,7 @@ static int calc_clk(int time, int bus_speed)
 static void compute_clocks(u8 pio, pio_clocks_t *p_pclk)
 {
 	int clk1, clk2;
-	int bus_speed = system_bus_clock();	/* get speed of PCI bus */
+	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
 
 	/* we don't check against CY82C693's min and max speed,
 	 * so you can play with the idebus=xx parameter
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index c7b7e04..b9e4579 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -87,11 +87,7 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 
 	i = hwif->index;
 
-	if (hwif->present)
-		ide_unregister(i);
-	else
-		ide_init_port_data(hwif, i);
-
+	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 	hwif->port_ops = &delkin_cb_port_ops;
 
@@ -123,8 +119,7 @@ delkin_cb_remove (struct pci_dev *dev)
 {
 	ide_hwif_t *hwif = pci_get_drvdata(dev);
 
-	if (hwif)
-		ide_unregister(hwif->index);
+	ide_unregister(hwif);
 
 	pci_release_regions(dev);
 	pci_disable_device(dev);
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 8c02961..c929dad 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -760,7 +760,7 @@ static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 		}
 	} else
 		outb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-		     hwif->io_ports[IDE_CONTROL_OFFSET]);
+		     hwif->io_ports.ctl_addr);
 }
 
 /*
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index e1b0c9a..c13e299 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -72,8 +72,8 @@ static void __devinit superio_ide_init_iops (struct hwif_s *hwif)
 	base = pci_resource_start(pdev, port * 2) & ~3;
 	dmabase = pci_resource_start(pdev, 4) & ~3;
 
-	superio_ide_status[port] = base + IDE_STATUS_OFFSET;
-	superio_ide_select[port] = base + IDE_SELECT_OFFSET;
+	superio_ide_status[port] = base + 7;
+	superio_ide_select[port] = base + 6;
 	superio_ide_dma_status[port] = dmabase + (!port ? 2 : 0xa);
 
 	/* Clear error/interrupt, enable dma */
@@ -231,12 +231,12 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 		 *      SELECT_DRIVE() properly during first ide_probe_port().
 		 */
 		timeout = 10000;
-		outb(12, hwif->io_ports[IDE_CONTROL_OFFSET]);
+		outb(12, hwif->io_ports.ctl_addr);
 		udelay(10);
-		outb(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
+		outb(8, hwif->io_ports.ctl_addr);
 		do {
 			udelay(50);
-			stat = hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+			stat = hwif->INB(hwif->io_ports.status_addr);
                 	if (stat == 0xff)
                         	break;
         	} while ((stat & BUSY_STAT) && --timeout);
@@ -244,7 +244,7 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 	}
 
 	if (!using_inta)
-		hwif->irq = ide_default_irq(hwif->io_ports[IDE_DATA_OFFSET]);
+		hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
 	else if (!hwif->irq && hwif->mate && hwif->mate->irq)
 		hwif->irq = hwif->mate->irq;	/* share IRQ with mate */
 
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 9edacba..6e99080 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -53,8 +53,7 @@
  * If you then set the second drive to another PIO, the old value
  * (automatically selected) will be overrided by yours.
  * There is a 25/33MHz switch in configuration
- * register, but driver is written for use at any frequency which get
- * (use idebus=xx to select PCI bus speed).
+ * register, but driver is written for use at any frequency.
  *
  * Version 0.1, Nov 8, 1996
  * by Jaromir Koutek, for 2.1.8.
@@ -210,7 +209,7 @@ static void compute_clocks(int pio, pio_clocks_t *clks)
 {
 	if (pio != PIO_NOT_EXIST) {
 		int adr_setup, data_pls;
-		int bus_speed = system_bus_clock();
+		int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
 
 		adr_setup = ide_pio_timings[pio].setup_time;
 		data_pls = ide_pio_timings[pio].active_time;
@@ -280,7 +279,7 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 	spin_lock_irqsave(&opti621_lock, flags);
 
-	reg_base = hwif->io_ports[IDE_DATA_OFFSET];
+	reg_base = hwif->io_ports.data_addr;
 
 	/* allow Register-B */
 	outb(0xc0, reg_base + CNTRL_REG);
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 17cf864..ad7cdf9 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -334,7 +334,7 @@ static int scc_dma_end(ide_drive_t *drive)
 
 	/* errata A308 workaround: Step5 (check data loss) */
 	/* We don't check non ide_disk because it is limited to UDMA4 */
-	if (!(in_be32((void __iomem *)hwif->io_ports[IDE_ALTSTATUS_OFFSET])
+	if (!(in_be32((void __iomem *)hwif->io_ports.ctl_addr)
 	      & ERR_STAT) &&
 	    drive->media == ide_disk && drive->current_speed > XFER_UDMA_4) {
 		reg = in_be32((void __iomem *)intsts_port);
@@ -438,7 +438,7 @@ static int scc_dma_test_irq(ide_drive_t *drive)
 	u32 int_stat = in_be32((void __iomem *)hwif->dma_base + 0x014);
 
 	/* SCC errata A252,A308 workaround: Step4 */
-	if ((in_be32((void __iomem *)hwif->io_ports[IDE_ALTSTATUS_OFFSET])
+	if ((in_be32((void __iomem *)hwif->io_ports.ctl_addr)
 	     & ERR_STAT) &&
 	    (int_stat & INTSTS_INTRQ))
 		return 1;
@@ -534,8 +534,8 @@ static int scc_ide_setup_pci_device(struct pci_dev *dev,
 	}
 
 	memset(&hw, 0, sizeof(hw));
-	for (i = IDE_DATA_OFFSET; i <= IDE_CONTROL_OFFSET; i++)
-		hw.io_ports[i] = ports->dma + 0x20 + i * 4;
+	for (i = 0; i <= 8; i++)
+		hw.io_ports_array[i] = ports->dma + 0x20 + i * 4;
 	hw.irq = dev->irq;
 	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;
@@ -763,9 +763,8 @@ static void __devexit scc_remove(struct pci_dev *dev)
 		hwif->dmatable_cpu = NULL;
 	}
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif);
 
-	hwif->chipset = ide_unknown;
 	iounmap((void*)ports->dma);
 	iounmap((void*)ports->ctl);
 	pci_release_selected_regions(dev, (1 << 2) - 1);
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 321a4e2..63e28f4 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -98,28 +98,28 @@ sgiioc4_init_hwif_ports(hw_regs_t * hw, unsigned long data_port,
 	int i;
 
 	/* Registers are word (32 bit) aligned */
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		hw->io_ports[i] = reg + i * 4;
+	for (i = 0; i <= 7; i++)
+		hw->io_ports_array[i] = reg + i * 4;
 
 	if (ctrl_port)
-		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
+		hw->io_ports.ctl_addr = ctrl_port;
 
 	if (irq_port)
-		hw->io_ports[IDE_IRQ_OFFSET] = irq_port;
+		hw->io_ports.irq_addr = irq_port;
 }
 
 static void
 sgiioc4_maskproc(ide_drive_t * drive, int mask)
 {
 	writeb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-	       (void __iomem *)drive->hwif->io_ports[IDE_CONTROL_OFFSET]);
+	       (void __iomem *)drive->hwif->io_ports.ctl_addr);
 }
 
 static int
 sgiioc4_checkirq(ide_hwif_t * hwif)
 {
 	unsigned long intr_addr =
-		hwif->io_ports[IDE_IRQ_OFFSET] + IOC4_INTR_REG * 4;
+		hwif->io_ports.irq_addr + IOC4_INTR_REG * 4;
 
 	if ((u8)readl((void __iomem *)intr_addr) & 0x03)
 		return 1;
@@ -134,8 +134,8 @@ sgiioc4_clearirq(ide_drive_t * drive)
 {
 	u32 intr_reg;
 	ide_hwif_t *hwif = HWIF(drive);
-	unsigned long other_ir =
-	    hwif->io_ports[IDE_IRQ_OFFSET] + (IOC4_INTR_REG << 2);
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long other_ir = io_ports->irq_addr + (IOC4_INTR_REG << 2);
 
 	/* Code to check for PCI error conditions */
 	intr_reg = readl((void __iomem *)other_ir);
@@ -147,12 +147,12 @@ sgiioc4_clearirq(ide_drive_t * drive)
 		 * a "clear" status if it got cleared.  If not, then spin
 		 * for a bit trying to clear it.
 		 */
-		u8 stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+		u8 stat = sgiioc4_INB(io_ports->status_addr);
 		int count = 0;
-		stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+		stat = sgiioc4_INB(io_ports->status_addr);
 		while ((stat & 0x80) && (count++ < 100)) {
 			udelay(1);
-			stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+			stat = sgiioc4_INB(io_ports->status_addr);
 		}
 
 		if (intr_reg & 0x02) {
@@ -162,9 +162,9 @@ sgiioc4_clearirq(ide_drive_t * drive)
 			    pci_stat_cmd_reg;
 
 			pci_err_addr_low =
-				readl((void __iomem *)hwif->io_ports[IDE_IRQ_OFFSET]);
+				readl((void __iomem *)io_ports->irq_addr);
 			pci_err_addr_high =
-				readl((void __iomem *)(hwif->io_ports[IDE_IRQ_OFFSET] + 4));
+				readl((void __iomem *)(io_ports->irq_addr + 4));
 			pci_read_config_dword(dev, PCI_COMMAND,
 					      &pci_stat_cmd_reg);
 			printk(KERN_ERR
@@ -573,7 +573,6 @@ static const struct ide_port_info sgiioc4_port_info __devinitdata = {
 	.init_dma		= ide_dma_sgiioc4,
 	.port_ops		= &sgiioc4_port_ops,
 	.dma_ops		= &sgiioc4_dma_ops,
-	.host_flags		= IDE_HFLAG_NO_AUTOTUNE,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
 
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 1fffea3..c2040a0 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -622,9 +622,10 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	void *addr		= pci_get_drvdata(dev);
 	u8 ch			= hwif->channel;
-	hw_regs_t		hw;
 	unsigned long		base;
 
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+
 	/*
 	 *	Fill in the basic HWIF bits
 	 */
@@ -638,7 +639,7 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 	 *	based I/O
 	 */
 
-	memset(&hw, 0, sizeof(hw_regs_t));
+	memset(io_ports, 0, sizeof(*io_ports));
 
 	base = (unsigned long)addr;
 	if (ch)
@@ -651,17 +652,15 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 	 *	so we can't currently use it sanely since we want to
 	 *	use LBA48 mode.
 	 */	
-	hw.io_ports[IDE_DATA_OFFSET]	= base;
-	hw.io_ports[IDE_ERROR_OFFSET]	= base + 1;
-	hw.io_ports[IDE_NSECTOR_OFFSET]	= base + 2;
-	hw.io_ports[IDE_SECTOR_OFFSET]	= base + 3;
-	hw.io_ports[IDE_LCYL_OFFSET]	= base + 4;
-	hw.io_ports[IDE_HCYL_OFFSET]	= base + 5;
-	hw.io_ports[IDE_SELECT_OFFSET]	= base + 6;
-	hw.io_ports[IDE_STATUS_OFFSET]	= base + 7;
-	hw.io_ports[IDE_CONTROL_OFFSET]	= base + 10;
-
-	hw.io_ports[IDE_IRQ_OFFSET]	= 0;
+	io_ports->data_addr	= base;
+	io_ports->error_addr	= base + 1;
+	io_ports->nsect_addr	= base + 2;
+	io_ports->lbal_addr	= base + 3;
+	io_ports->lbam_addr	= base + 4;
+	io_ports->lbah_addr	= base + 5;
+	io_ports->device_addr	= base + 6;
+	io_ports->status_addr	= base + 7;
+	io_ports->ctl_addr	= base + 10;
 
 	if (pdev_is_sata(dev)) {
 		base = (unsigned long)addr;
@@ -672,8 +671,6 @@ static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 		hwif->sata_scr[SATA_CONTROL_OFFSET]	= base + 0x100;
 	}
 
-	memcpy(hwif->io_ports, hw.io_ports, sizeof(hwif->io_ports));
-
 	hwif->irq = dev->irq;
 
 	hwif->dma_base = (unsigned long)addr + (ch ? 0x08 : 0x00);
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index 15ee38f..a8a3138 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -298,7 +298,7 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 		if (old != compat && old_mask == 0xff) {
 			/* leave lower 10 bits untouched */
 			compat += (next_offset += 0x400);
-			hwif->io_ports[IDE_CONTROL_OFFSET] = compat + 2;
+			hwif->io_ports.ctl_addr = compat + 2;
 			outw(compat | 1, hwif->config_data);
 			new = inw(hwif->config_data);
 			printk(KERN_INFO "%s: control basereg workaround: "
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index bbd17be..566e0ec 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -340,7 +340,7 @@ static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev, const
 	 * Determine system bus clock.
 	 */
 
-	via_clock = system_bus_clock() * 1000;
+	via_clock = (ide_pci_clk ? ide_pci_clk : system_bus_clock()) * 1000;
 
 	switch (via_clock) {
 		case 33000: via_clock = 33333; break;
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index a82f6ef..f0e638d 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -131,7 +131,7 @@ static int pcmcia_schlvl = PCMCIA_SCHLVL;
 #if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
 static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
-	unsigned long *p = hw->io_ports;
+	unsigned long *p = hw->io_ports_array;
 	int i;
 
 	typedef struct {
@@ -314,7 +314,7 @@ static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 #if defined(CONFIG_IDE_EXT_DIRECT)
 static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
-	unsigned long *p = hw->io_ports;
+	unsigned long *p = hw->io_ports_array;
 	int i;
 
 	u32 ide_phy_base;
@@ -811,24 +811,28 @@ static int __init mpc8xx_ide_probe(void)
 #ifdef IDE0_BASE_OFFSET
 	memset(&hw, 0, sizeof(hw));
 	if (!m8xx_ide_init_ports(&hw, 0)) {
-		ide_hwif_t *hwif = &ide_hwifs[0];
+		ide_hwif_t *hwif = ide_find_port();
 
-		ide_init_port_hw(hwif, &hw);
-		hwif->pio_mask = ATA_PIO4;
-		hwif->port_ops = &m8xx_port_ops;
+		if (hwif) {
+			ide_init_port_hw(hwif, &hw);
+			hwif->pio_mask = ATA_PIO4;
+			hwif->port_ops = &m8xx_port_ops;
 
-		idx[0] = 0;
+			idx[0] = hwif->index;
+		}
 	}
 #ifdef IDE1_BASE_OFFSET
 	memset(&hw, 0, sizeof(hw));
 	if (!m8xx_ide_init_ports(&hw, 1)) {
-		ide_hwif_t *mate = &ide_hwifs[1];
+		ide_hwif_t *mate = ide_find_port();
 
-		ide_init_port_hw(mate, &hw);
-		mate->pio_mask = ATA_PIO4;
-		mate->port_ops = &m8xx_port_ops;
+		if (mate) {
+			ide_init_port_hw(mate, &hw);
+			mate->pio_mask = ATA_PIO4;
+			mate->port_ops = &m8xx_port_ops;
 
-		idx[1] = 1;
+			idx[1] = mate->index;
+		}
 	}
 #endif
 #endif
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 185faa0..3cac6b2 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -417,7 +417,7 @@ static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
 
 #define PMAC_IDE_REG(x) \
-	((void __iomem *)((drive)->hwif->io_ports[IDE_DATA_OFFSET] + (x)))
+	((void __iomem *)((drive)->hwif->io_ports.data_addr + (x)))
 
 /*
  * Apply the timings of the proper unit (master/slave) to the shared
@@ -1086,8 +1086,9 @@ static void __devinit pmac_ide_init_ports(hw_regs_t *hw, unsigned long base)
 	int i;
 
 	for (i = 0; i < 8; ++i)
-		hw->io_ports[i] = base + i * 0x10;
-	hw->io_ports[8] = base + 0x160;
+		hw->io_ports_array[i] = base + i * 0x10;
+
+	hw->io_ports.ctl_addr = base + 0x160;
 }
 
 /*
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 3638fa8..3255363 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -258,8 +258,7 @@ idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE,
-			   hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTB(WIN_IDLEIMMEDIATE, hwif->io_ports.command_addr);
 
 	rq->errors++;
 
@@ -410,9 +409,9 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
 	}
-	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
-		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
+		  hwif->INB(hwif->io_ports.lbam_addr);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
@@ -485,7 +484,7 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 			"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-scsi: (IO,CoD) != (0,1) while "
 				"issuing a packet command\n");
@@ -575,7 +574,7 @@ static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
 		return idescsi_transfer_pc(drive);
 	}
 }
diff --git a/include/asm-arm/arch-sa1100/ide.h b/include/asm-arm/arch-sa1100/ide.h
index 98b10bc..b14cbda 100644
--- a/include/asm-arm/arch-sa1100/ide.h
+++ b/include/asm-arm/arch-sa1100/ide.h
@@ -37,12 +37,12 @@ static inline void ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
 
 	memset(hw, 0, sizeof(*hw));
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw->io_ports[i] = reg;
+	for (i = 0; i <= 7; i++) {
+		hw->io_ports_array[i] = reg;
 		reg += regincr;
 	}
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
+	hw->io_ports.ctl_addr = ctrl_port;
 
 	if (irq)
 		*irq = 0;
diff --git a/include/asm-cris/arch-v10/ide.h b/include/asm-cris/arch-v10/ide.h
index ea34e0d..5366e62 100644
--- a/include/asm-cris/arch-v10/ide.h
+++ b/include/asm-cris/arch-v10/ide.h
@@ -59,22 +59,19 @@ static inline void ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port, u
 	int i;
 
 	/* fill in ports for ATA addresses 0 to 7 */
-
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw->io_ports[i] = data_port |
+	for (i = 0; i <= 7; i++) {
+		hw->io_ports_array[i] = data_port |
 			IO_FIELD(R_ATA_CTRL_DATA, addr, i) |
 			IO_STATE(R_ATA_CTRL_DATA, cs0, active);
 	}
 
 	/* the IDE control register is at ATA address 6, with CS1 active instead of CS0 */
-
-	hw->io_ports[IDE_CONTROL_OFFSET] = data_port |
+	hw->io_ports.ctl_addr = data_port |
 			IO_FIELD(R_ATA_CTRL_DATA, addr, 6) |
 			IO_STATE(R_ATA_CTRL_DATA, cs1, active);
 
 	/* whats this for ? */
-
-	hw->io_ports[IDE_IRQ_OFFSET] = 0;
+	hw->io_ports.irq_addr = 0;
 }
 
 static inline void ide_init_default_hwifs(void)
diff --git a/include/linux/ide.h b/include/linux/ide.h
index f0af504..32fd77b 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -48,13 +48,6 @@ typedef unsigned char	byte;	/* used everywhere */
 #define ERROR_RECAL	1	/* Recalibrate every 2nd retry */
 
 /*
- * Tune flags
- */
-#define IDE_TUNE_NOAUTO		2
-#define IDE_TUNE_AUTO		1
-#define IDE_TUNE_DEFAULT	0
-
-/*
  * state flags
  */
 
@@ -68,23 +61,30 @@ typedef unsigned char	byte;	/* used everywhere */
  */
 #define IDE_NR_PORTS		(10)
 
-#define IDE_DATA_OFFSET		(0)
-#define IDE_ERROR_OFFSET	(1)
-#define IDE_NSECTOR_OFFSET	(2)
-#define IDE_SECTOR_OFFSET	(3)
-#define IDE_LCYL_OFFSET		(4)
-#define IDE_HCYL_OFFSET		(5)
-#define IDE_SELECT_OFFSET	(6)
-#define IDE_STATUS_OFFSET	(7)
-#define IDE_CONTROL_OFFSET	(8)
-#define IDE_IRQ_OFFSET		(9)
-
-#define IDE_FEATURE_OFFSET	IDE_ERROR_OFFSET
-#define IDE_COMMAND_OFFSET	IDE_STATUS_OFFSET
-#define IDE_ALTSTATUS_OFFSET	IDE_CONTROL_OFFSET
-#define IDE_IREASON_OFFSET	IDE_NSECTOR_OFFSET
-#define IDE_BCOUNTL_OFFSET	IDE_LCYL_OFFSET
-#define IDE_BCOUNTH_OFFSET	IDE_HCYL_OFFSET
+struct ide_io_ports {
+	unsigned long	data_addr;
+
+	union {
+		unsigned long error_addr;	/*   read:  error */
+		unsigned long feature_addr;	/*  write: feature */
+	};
+
+	unsigned long	nsect_addr;
+	unsigned long	lbal_addr;
+	unsigned long	lbam_addr;
+	unsigned long	lbah_addr;
+
+	unsigned long	device_addr;
+
+	union {
+		unsigned long status_addr;	/*  read: status  */
+		unsigned long command_addr;	/* write: command */
+	};
+
+	unsigned long	ctl_addr;
+
+	unsigned long	irq_addr;
+};
 
 #define OK_STAT(stat,good,bad)	(((stat)&((good)|(bad)))==(good))
 #define BAD_R_STAT		(BUSY_STAT   | ERR_STAT)
@@ -163,7 +163,11 @@ typedef u8 hwif_chipset_t;
  * Structure to hold all information about the location of this port
  */
 typedef struct hw_regs_s {
-	unsigned long	io_ports[IDE_NR_PORTS];	/* task file registers */
+	union {
+		struct ide_io_ports	io_ports;
+		unsigned long		io_ports_array[IDE_NR_PORTS];
+	};
+
 	int		irq;			/* our irq number */
 	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
 	hwif_chipset_t  chipset;
@@ -179,10 +183,10 @@ static inline void ide_std_init_ports(hw_regs_t *hw,
 {
 	unsigned int i;
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		hw->io_ports[i] = io_addr++;
+	for (i = 0; i <= 7; i++)
+		hw->io_ports_array[i] = io_addr++;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ctl_addr;
+	hw->io_ports.ctl_addr = ctl_addr;
 }
 
 #include <asm/ide.h>
@@ -328,7 +332,6 @@ typedef struct ide_drive_s {
 	unsigned atapi_overlap	: 1;	/* ATAPI overlap (not supported) */
 	unsigned doorlocking	: 1;	/* for removable only: door lock/unlock works */
 	unsigned nodma		: 1;	/* disallow DMA */
-	unsigned autotune	: 2;	/* 0=default, 1=autotune, 2=noautotune */
 	unsigned remap_0_to_1	: 1;	/* 0=noremap, 1=remap 0->1 (for EZDrive) */
 	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
 	unsigned vdma		: 1;	/* 1=doing PIO over DMA 0=doing normal DMA */
@@ -432,8 +435,8 @@ typedef struct hwif_s {
 
 	char name[6];			/* name of interface, eg. "ide0" */
 
-		/* task file registers for pata and sata */
-	unsigned long	io_ports[IDE_NR_PORTS];
+	struct ide_io_ports	io_ports;
+
 	unsigned long	sata_scr[SATA_NR_PORTS];
 
 	ide_drive_t	drives[MAX_DRIVES];	/* drive info */
@@ -520,7 +523,6 @@ typedef struct hwif_s {
 	unsigned	present    : 1;	/* this interface exists */
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
-	unsigned	reset      : 1;	/* reset after probe */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 	unsigned	mmio       : 1; /* host uses MMIO */
 
@@ -703,10 +705,6 @@ void ide_add_generic_settings(ide_drive_t *);
 read_proc_t proc_ide_read_capacity;
 read_proc_t proc_ide_read_geometry;
 
-#ifdef CONFIG_BLK_DEV_IDEPCI
-void ide_pci_create_host_proc(const char *, get_info_t *);
-#endif
-
 /*
  * Standard exit stuff:
  */
@@ -807,8 +805,14 @@ int generic_ide_ioctl(ide_drive_t *, struct file *, struct block_device *, unsig
 #ifndef _IDE_C
 extern	ide_hwif_t	ide_hwifs[];		/* master data repository */
 #endif
+extern int ide_noacpi;
+extern int ide_acpigtf;
+extern int ide_acpionboot;
 extern int noautodma;
 
+extern int ide_vlb_clk;
+extern int ide_pci_clk;
+
 ide_hwif_t *ide_find_port_slot(const struct ide_port_info *);
 
 static inline ide_hwif_t *ide_find_port(void)
@@ -1068,8 +1072,6 @@ enum {
 	IDE_HFLAG_NO_DMA		= (1 << 14),
 	/* check if host is PCI IDE device before allowing DMA */
 	IDE_HFLAG_NO_AUTODMA		= (1 << 15),
-	/* don't autotune PIO */
-	IDE_HFLAG_NO_AUTOTUNE		= (1 << 16),
 	/* host is CS5510/CS5520 */
 	IDE_HFLAG_CS5520		= IDE_HFLAG_VDMA,
 	/* no LBA48 */
@@ -1215,13 +1217,15 @@ static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
 void ide_remove_port_from_hwgroup(ide_hwif_t *);
-void ide_unregister(unsigned int);
+void ide_unregister(ide_hwif_t *);
 
 void ide_register_region(struct gendisk *);
 void ide_unregister_region(struct gendisk *);
 
 void ide_undecoded_slave(ide_drive_t *);
 
+void ide_port_apply_params(ide_hwif_t *);
+
 int ide_device_add_all(u8 *idx, const struct ide_port_info *);
 int ide_device_add(u8 idx[4], const struct ide_port_info *);
 int ide_legacy_device_add(const struct ide_port_info *, unsigned long);
@@ -1333,29 +1337,28 @@ static inline void ide_set_irq(ide_drive_t *drive, int on)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	hwif->OUTB(drive->ctl | (on ? 0 : 2),
-		   hwif->io_ports[IDE_CONTROL_OFFSET]);
+	hwif->OUTB(drive->ctl | (on ? 0 : 2), hwif->io_ports.ctl_addr);
 }
 
 static inline u8 ide_read_status(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	return hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+	return hwif->INB(hwif->io_ports.status_addr);
 }
 
 static inline u8 ide_read_altstatus(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	return hwif->INB(hwif->io_ports[IDE_CONTROL_OFFSET]);
+	return hwif->INB(hwif->io_ports.ctl_addr);
 }
 
 static inline u8 ide_read_error(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	return hwif->INB(hwif->io_ports[IDE_ERROR_OFFSET]);
+	return hwif->INB(hwif->io_ports.error_addr);
 }
 
 /*
@@ -1368,7 +1371,7 @@ static inline void ide_atapi_discard_data(ide_drive_t *drive, unsigned bcount)
 
 	/* FIXME: use ->atapi_input_bytes */
 	while (bcount--)
-		(void)hwif->INB(hwif->io_ports[IDE_DATA_OFFSET]);
+		(void)hwif->INB(hwif->io_ports.data_addr);
 }
 
 static inline void ide_atapi_write_zeros(ide_drive_t *drive, unsigned bcount)
@@ -1377,7 +1380,7 @@ static inline void ide_atapi_write_zeros(ide_drive_t *drive, unsigned bcount)
 
 	/* FIXME: use ->atapi_output_bytes */
 	while (bcount--)
-		hwif->OUTB(0, hwif->io_ports[IDE_DATA_OFFSET]);
+		hwif->OUTB(0, hwif->io_ports.data_addr);
 }
 
 #endif /* _IDE_H */
