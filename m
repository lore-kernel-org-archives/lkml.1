Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbYBBTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbYBBTYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759443AbYBBTXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:23:54 -0500
Received: from ag-out-0708.google.com ([72.14.246.240]:21582 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759698AbYBBTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=V/RGz8Zvi3L4rKAkkoQ/geKH6SnAoZ7QadONZX/lE/keFXPi7d53LMS+Qo5EHsgLy/XeThIaNemRRuBL+DF2iUNKGbgYs9NtLD0cVu2JLPtMfeXhr6g2Vz51QowDB01FI7lpa8HCYiHzfe/rsprr2shit8CG4LPMavgs/HVyfOE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates part #4
Date: Sat, 2 Feb 2008 20:35:01 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802022035.02326.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This time:

* ide-floppy/ide-tape revamps similar to previous ide-cd redux
  (Borislav Petkov)

* next part of IDE probing code re-organization saga
  (that would be me)

* misc cleanups/fixes

As a result drivers/ide/ shrinks by ~1300 LOC...


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/ide/ChangeLog.ide-tape.1995-2002 |  257 +++++
 Documentation/ide/ide-tape.txt                 |  146 +++
 drivers/ide/Kconfig                            |    3 +-
 drivers/ide/arm/bast-ide.c                     |   20 +-
 drivers/ide/arm/icside.c                       |   25 +-
 drivers/ide/arm/ide_arm.c                      |    2 +-
 drivers/ide/arm/rapide.c                       |    4 +-
 drivers/ide/cris/ide-cris.c                    |   24 +-
 drivers/ide/h8300/ide-h8300.c                  |    2 +-
 drivers/ide/ide-acpi.c                         |   63 +-
 drivers/ide/ide-cd.c                           |    2 -
 drivers/ide/ide-dma.c                          |   20 +
 drivers/ide/ide-floppy.c                       | 1438 +++++++++---------------
 drivers/ide/ide-generic.c                      |    2 +-
 drivers/ide/ide-iops.c                         |  109 +--
 drivers/ide/ide-pnp.c                          |    9 +-
 drivers/ide/ide-probe.c                        |  278 ++++--
 drivers/ide/ide-proc.c                         |    7 +-
 drivers/ide/ide-tape.c                         | 1240 ++++-----------------
 drivers/ide/ide-taskfile.c                     |   11 +-
 drivers/ide/ide.c                              |   77 +-
 drivers/ide/legacy/ali14xx.c                   |   24 +-
 drivers/ide/legacy/buddha.c                    |    2 +-
 drivers/ide/legacy/dtc2278.c                   |   36 +-
 drivers/ide/legacy/falconide.c                 |    2 +-
 drivers/ide/legacy/gayle.c                     |    2 +-
 drivers/ide/legacy/ht6560b.c                   |   48 +-
 drivers/ide/legacy/ide-cs.c                    |   29 +-
 drivers/ide/legacy/ide_platform.c              |    4 +-
 drivers/ide/legacy/macide.c                    |   12 +-
 drivers/ide/legacy/q40ide.c                    |    2 +-
 drivers/ide/legacy/qd65xx.c                    |   67 +-
 drivers/ide/legacy/umc8672.c                   |   24 +-
 drivers/ide/mips/au1xxx-ide.c                  |   37 +-
 drivers/ide/mips/swarm.c                       |    2 +-
 drivers/ide/pci/aec62xx.c                      |   26 +-
 drivers/ide/pci/alim15x3.c                     |    6 +-
 drivers/ide/pci/amd74xx.c                      |   21 +-
 drivers/ide/pci/atiixp.c                       |   30 +-
 drivers/ide/pci/cmd640.c                       |   33 +-
 drivers/ide/pci/cmd64x.c                       |    6 +-
 drivers/ide/pci/cs5520.c                       |   12 +-
 drivers/ide/pci/cs5530.c                       |    8 +-
 drivers/ide/pci/cs5535.c                       |   10 +-
 drivers/ide/pci/cy82c693.c                     |    1 -
 drivers/ide/pci/delkin_cb.c                    |   41 +-
 drivers/ide/pci/generic.c                      |    7 -
 drivers/ide/pci/hpt34x.c                       |    7 -
 drivers/ide/pci/hpt366.c                       |   89 +-
 drivers/ide/pci/it8213.c                       |   24 +-
 drivers/ide/pci/it821x.c                       |    8 +-
 drivers/ide/pci/jmicron.c                      |    9 +-
 drivers/ide/pci/ns87415.c                      |    4 -
 drivers/ide/pci/opti621.c                      |   15 +-
 drivers/ide/pci/pdc202xx_new.c                 |   14 +-
 drivers/ide/pci/pdc202xx_old.c                 |   17 +-
 drivers/ide/pci/piix.c                         |    9 +-
 drivers/ide/pci/rz1000.c                       |   10 +-
 drivers/ide/pci/sc1200.c                       |    8 +-
 drivers/ide/pci/scc_pata.c                     |   10 +-
 drivers/ide/pci/serverworks.c                  |   11 +-
 drivers/ide/pci/sgiioc4.c                      |   20 +-
 drivers/ide/pci/siimage.c                      |   31 +-
 drivers/ide/pci/sis5513.c                      |   14 +-
 drivers/ide/pci/sl82c105.c                     |    6 -
 drivers/ide/pci/slc90e66.c                     |   26 +-
 drivers/ide/pci/tc86c001.c                     |   24 +-
 drivers/ide/pci/triflex.c                      |    5 -
 drivers/ide/pci/trm290.c                       |    7 +-
 drivers/ide/pci/via82cxxx.c                    |   10 +-
 drivers/ide/ppc/mpc8xx.c                       |    2 +-
 drivers/ide/ppc/pmac.c                         |   84 +-
 drivers/ide/setup-pci.c                        |   77 +-
 drivers/macintosh/mediabay.c                   |    2 +-
 drivers/scsi/ide-scsi.c                        |    9 +-
 include/linux/hdreg.h                          |    4 +-
 include/linux/ide.h                            |   51 +-
 77 files changed, 1989 insertions(+), 2849 deletions(-)
 create mode 100644 Documentation/ide/ChangeLog.ide-tape.1995-2002
 create mode 100644 Documentation/ide/ide-tape.txt


Alan Cox (1):
      pdc202xx_old: remove surplus initialiser

Bartlomiej Zolnierkiewicz (50):
      dtc2278: fix ->io_32bit handling
      au1xxx-ide: fix ->io_32bit handling
      atiixp/cs5535/scc_pata: fix "idex=ata66" parameter handling
      macide: remove drive->capacity64 quirk
      ide: always set DMA masks in ide_pci_setup_ports()
      ide: separate PCI specific init from generic init in ide_pci_setup_ports()
      ide: add struct ide_port_info instances to legacy host drivers
      ide: add ->cable_detect method to ide_hwif_t
      ide: remove needless includes from PCI host drivers
      ide: remove redundant hwif->present check from ide_register_hw()
      ide: remove redundant init_hwif_default() call from ide_register_hw()
      ide: add 'init_default' and 'restore' arguments to ide_unregister()
      ide: add ide_deprecated_find_port() helper
      ide: fix ide_unregister() usage in host drivers
      ide: factor out code initializing devices from ide_init_port()
      ide: add IDE_HFLAG_NO_{IO32_BIT,UNMASK_IRQS} host flags
      ide: add ->port_init_devs method to ide_hwif_t
      ide: remove incorrect init_gendisk() comment
      ide: skip not present devices in init_gendisk()
      ide: move blk_register_region() call out from init_gendisk()
      ide: call init_gendisk() after ide_acpi_init()
      ide: merge init_gendisk() into hwif_register_devices()
      ide: move hwif->rqsize init from ide_init_queue() to init_irq()
      ide: factor out adding drive to hwgroup from init_irq()
      ide: factor out devices setup from init_irq()
      ide: move ide_acpi_init() call to ide_device_add_all()
      ide-acpi: remove needless exports
      ide-acpi: remove dead code from do_drive_get_GTF()
      ide: factor out devices setup from ide_acpi_init()
      ide: move hwif->present check out from ide_proc_register_port()
      ide: move create_proc_ide_drives() call to ide_device_add_all()
      ide-tape: use ide_execute_command()
      ide-scsi: use ide_execute_command()
      trm290: use ide_execute_command()
      ide-cris: use ide_execute_command()
      ide-probe: remove needless Status register reads
      ide: remove unused ->auto_poll field from ide_hwif_t
      ide: convert ->straight8 field in ide_hwif_t to bit flag
      ide: remove ->nice0 and ->nice2 fields from ide_drive_t
      ide: remove SATA_*_REG macros
      ide: use __ide_set_handler() in ide_execute_command()
      ide-scsi: remove needless SELECT_DRIVE() call
      ide: unexport SELECT_DRIVE()
      ide: remove set_transfer()
      ide: remove ide_ata66_check()
      ide: move drive->crc_count check out from check_dma_crc()
      ide: remove ide_auto_reduce_xfer()
      ide: move check_dma_crc() to ide-dma.c
      ide-cs: use ide_std_init_ports()
      ide-tape: dump gcw fields on error in idetape_identify_device()

Borislav Petkov (44):
      ide-floppy: convert to generic packet commands
      ide-floppy: replace ntoh{s,l} and hton{s,l} calls with the generic byteorder
      ide-floppy: remove unnecessary ->handler != NULL check
      ide-floppy: disambiguate function names
      ide-floppy: include the proper headers
      ide-floppy: cleanup and unify debugging macro calls
      ide-floppy: remove struct idefloppy_capabilities_page
      ide-floppy: remove struct idefloppy_inquiry_result
      ide-floppy: remove struct idefloppy_request_sense_result
      ide-floppy: remove struct idefloppy_mode_parameter_header
      ide-floppy: remove struct idefloppy_flexible_disk_page
      ide-floppy: remove struct idefloppy_capacity_descriptor
      ide-floppy: factor out ioctl handlers from idefloppy_ioctl()
      ide-floppy: report DMA handling in idefloppy_pc_intr() properly
      ide-floppy: mv idefloppy_{should_,}report_error
      ide-floppy: remove IDEFLOPPY_DEBUG_BUGS macro
      ide-floppy: use an xfer_func_t and io_buf_t typedefs in order to unify rw
      ide-floppy: merge idefloppy_{input,output}_buffers
      ide-floppy: remove unused IDEFLOPPY_USE_READ12
      ide-floppy: remove IDEFLOPPY_DEBUG_INFO
      ide-floppy: remove unused flag PC_ABORT
      ide-floppy: remove atomic test_*bit macros
      ide-floppy: fix most of the remaining checkpatch.pl issues
      ide-floppy: bump driver version number
      ide-tape: move historical changelog to Documentation/ide/ChangeLog.ide-tape.1995-2002
      ide-tape: remove dead code
      ide-tape: remove struct idetape_request_sense_result_t
      ide-tape: remove struct idetape_mode_parameter_header_t
      ide-tape: remove IDETAPE_DEBUG_INFO
      ide-tape: remove IDETAPE_DEBUG_BUGS
      ide-tape: remove struct idetape_capabilities_page_t
      ide-tape: remove struct idetape_inquiry_result_t
      ide-tape: remove struct idetape_data_compression_page_t
      ide-tape: remove struct idetape_medium_partition_page_t
      ide-tape: remove struct idetape_parameter_block_descriptor_t
      ide-tape: remove structs os_partition_t, os_dat_entry_t, os_dat_t
      ide-tape: remove struct idetape_block_size_page_t
      ide-tape: use generic scsi commands
      ide-tape: remove EXPERIMENTAL driver status
      ide-tape: use generic byteorder macros
      ide-tape: remove unused sense packet commands.
      ide-tape: make function name more accurate
      ide-tape: remove mtio.h related comments
      ide-tape: remove idetape_config_t typedef


diff --git a/Documentation/ide/ChangeLog.ide-tape.1995-2002 b/Documentation/ide/ChangeLog.ide-tape.1995-2002
new file mode 100644
index 0000000..877fac8
--- /dev/null
+++ b/Documentation/ide/ChangeLog.ide-tape.1995-2002
@@ -0,0 +1,257 @@
+/*
+ * Ver 0.1   Nov  1 95   Pre-working code :-)
+ * Ver 0.2   Nov 23 95   A short backup (few megabytes) and restore procedure
+ *                        was successful ! (Using tar cvf ... on the block
+ *                        device interface).
+ *                       A longer backup resulted in major swapping, bad
+ *                        overall Linux performance and eventually failed as
+ *                        we received non serial read-ahead requests from the
+ *                        buffer cache.
+ * Ver 0.3   Nov 28 95   Long backups are now possible, thanks to the
+ *                        character device interface. Linux's responsiveness
+ *                        and performance doesn't seem to be much affected
+ *                        from the background backup procedure.
+ *                       Some general mtio.h magnetic tape operations are
+ *                        now supported by our character device. As a result,
+ *                        popular tape utilities are starting to work with
+ *                        ide tapes :-)
+ *                       The following configurations were tested:
+ *                       1. An IDE ATAPI TAPE shares the same interface
+ *                        and irq with an IDE ATAPI CDROM.
+ *                       2. An IDE ATAPI TAPE shares the same interface
+ *                        and irq with a normal IDE disk.
+ *                        Both configurations seemed to work just fine !
+ *                        However, to be on the safe side, it is meanwhile
+ *                        recommended to give the IDE TAPE its own interface
+ *                        and irq.
+ *                       The one thing which needs to be done here is to
+ *                        add a "request postpone" feature to ide.c,
+ *                        so that we won't have to wait for the tape to finish
+ *                        performing a long media access (DSC) request (such
+ *                        as a rewind) before we can access the other device
+ *                        on the same interface. This effect doesn't disturb
+ *                        normal operation most of the time because read/write
+ *                        requests are relatively fast, and once we are
+ *                        performing one tape r/w request, a lot of requests
+ *                        from the other device can be queued and ide.c will
+ *			  service all of them after this single tape request.
+ * Ver 1.0   Dec 11 95   Integrated into Linux 1.3.46 development tree.
+ *                       On each read / write request, we now ask the drive
+ *                        if we can transfer a constant number of bytes
+ *                        (a parameter of the drive) only to its buffers,
+ *                        without causing actual media access. If we can't,
+ *                        we just wait until we can by polling the DSC bit.
+ *                        This ensures that while we are not transferring
+ *                        more bytes than the constant referred to above, the
+ *                        interrupt latency will not become too high and
+ *                        we won't cause an interrupt timeout, as happened
+ *                        occasionally in the previous version.
+ *                       While polling for DSC, the current request is
+ *                        postponed and ide.c is free to handle requests from
+ *                        the other device. This is handled transparently to
+ *                        ide.c. The hwgroup locking method which was used
+ *                        in the previous version was removed.
+ *                       Use of new general features which are provided by
+ *                        ide.c for use with atapi devices.
+ *                        (Programming done by Mark Lord)
+ *                       Few potential bug fixes (Again, suggested by Mark)
+ *                       Single character device data transfers are now
+ *                        not limited in size, as they were before.
+ *                       We are asking the tape about its recommended
+ *                        transfer unit and send a larger data transfer
+ *                        as several transfers of the above size.
+ *                        For best results, use an integral number of this
+ *                        basic unit (which is shown during driver
+ *                        initialization). I will soon add an ioctl to get
+ *                        this important parameter.
+ *                       Our data transfer buffer is allocated on startup,
+ *                        rather than before each data transfer. This should
+ *                        ensure that we will indeed have a data buffer.
+ * Ver 1.1   Dec 14 95   Fixed random problems which occurred when the tape
+ *                        shared an interface with another device.
+ *                        (poll_for_dsc was a complete mess).
+ *                       Removed some old (non-active) code which had
+ *                        to do with supporting buffer cache originated
+ *                        requests.
+ *                       The block device interface can now be opened, so
+ *                        that general ide driver features like the unmask
+ *                        interrupts flag can be selected with an ioctl.
+ *                        This is the only use of the block device interface.
+ *                       New fast pipelined operation mode (currently only on
+ *                        writes). When using the pipelined mode, the
+ *                        throughput can potentially reach the maximum
+ *                        tape supported throughput, regardless of the
+ *                        user backup program. On my tape drive, it sometimes
+ *                        boosted performance by a factor of 2. Pipelined
+ *                        mode is enabled by default, but since it has a few
+ *                        downfalls as well, you may want to disable it.
+ *                        A short explanation of the pipelined operation mode
+ *                        is available below.
+ * Ver 1.2   Jan  1 96   Eliminated pipelined mode race condition.
+ *                       Added pipeline read mode. As a result, restores
+ *                        are now as fast as backups.
+ *                       Optimized shared interface behavior. The new behavior
+ *                        typically results in better IDE bus efficiency and
+ *                        higher tape throughput.
+ *                       Pre-calculation of the expected read/write request
+ *                        service time, based on the tape's parameters. In
+ *                        the pipelined operation mode, this allows us to
+ *                        adjust our polling frequency to a much lower value,
+ *                        and thus to dramatically reduce our load on Linux,
+ *                        without any decrease in performance.
+ *                       Implemented additional mtio.h operations.
+ *                       The recommended user block size is returned by
+ *                        the MTIOCGET ioctl.
+ *                       Additional minor changes.
+ * Ver 1.3   Feb  9 96   Fixed pipelined read mode bug which prevented the
+ *                        use of some block sizes during a restore procedure.
+ *                       The character device interface will now present a
+ *                        continuous view of the media - any mix of block sizes
+ *                        during a backup/restore procedure is supported. The
+ *                        driver will buffer the requests internally and
+ *                        convert them to the tape's recommended transfer
+ *                        unit, making performance almost independent of the
+ *                        chosen user block size.
+ *                       Some improvements in error recovery.
+ *                       By cooperating with ide-dma.c, bus mastering DMA can
+ *                        now sometimes be used with IDE tape drives as well.
+ *                        Bus mastering DMA has the potential to dramatically
+ *                        reduce the CPU's overhead when accessing the device,
+ *                        and can be enabled by using hdparm -d1 on the tape's
+ *                        block device interface. For more info, read the
+ *                        comments in ide-dma.c.
+ * Ver 1.4   Mar 13 96   Fixed serialize support.
+ * Ver 1.5   Apr 12 96   Fixed shared interface operation, broken in 1.3.85.
+ *                       Fixed pipelined read mode inefficiency.
+ *                       Fixed nasty null dereferencing bug.
+ * Ver 1.6   Aug 16 96   Fixed FPU usage in the driver.
+ *                       Fixed end of media bug.
+ * Ver 1.7   Sep 10 96   Minor changes for the CONNER CTT8000-A model.
+ * Ver 1.8   Sep 26 96   Attempt to find a better balance between good
+ *                        interactive response and high system throughput.
+ * Ver 1.9   Nov  5 96   Automatically cross encountered filemarks rather
+ *                        than requiring an explicit FSF command.
+ *                       Abort pending requests at end of media.
+ *                       MTTELL was sometimes returning incorrect results.
+ *                       Return the real block size in the MTIOCGET ioctl.
+ *                       Some error recovery bug fixes.
+ * Ver 1.10  Nov  5 96   Major reorganization.
+ *                       Reduced CPU overhead a bit by eliminating internal
+ *                        bounce buffers.
+ *                       Added module support.
+ *                       Added multiple tape drives support.
+ *                       Added partition support.
+ *                       Rewrote DSC handling.
+ *                       Some portability fixes.
+ *                       Removed ide-tape.h.
+ *                       Additional minor changes.
+ * Ver 1.11  Dec  2 96   Bug fix in previous DSC timeout handling.
+ *                       Use ide_stall_queue() for DSC overlap.
+ *                       Use the maximum speed rather than the current speed
+ *                        to compute the request service time.
+ * Ver 1.12  Dec  7 97   Fix random memory overwriting and/or last block data
+ *                        corruption, which could occur if the total number
+ *                        of bytes written to the tape was not an integral
+ *                        number of tape blocks.
+ *                       Add support for INTERRUPT DRQ devices.
+ * Ver 1.13  Jan  2 98   Add "speed == 0" work-around for HP COLORADO 5GB
+ * Ver 1.14  Dec 30 98   Partial fixes for the Sony/AIWA tape drives.
+ *                       Replace cli()/sti() with hwgroup spinlocks.
+ * Ver 1.15  Mar 25 99   Fix SMP race condition by replacing hwgroup
+ *                        spinlock with private per-tape spinlock.
+ * Ver 1.16  Sep  1 99   Add OnStream tape support.
+ *                       Abort read pipeline on EOD.
+ *                       Wait for the tape to become ready in case it returns
+ *                        "in the process of becoming ready" on open().
+ *                       Fix zero padding of the last written block in
+ *                        case the tape block size is larger than PAGE_SIZE.
+ *                       Decrease the default disconnection time to tn.
+ * Ver 1.16e Oct  3 99   Minor fixes.
+ * Ver 1.16e1 Oct 13 99  Patches by Arnold Niessen,
+ *                          niessen@iae.nl / arnold.niessen@philips.com
+ *                   GO-1)  Undefined code in idetape_read_position
+ *				according to Gadi's email
+ *                   AJN-1) Minor fix asc == 11 should be asc == 0x11
+ *                               in idetape_issue_packet_command (did effect
+ *                               debugging output only)
+ *                   AJN-2) Added more debugging output, and
+ *                              added ide-tape: where missing. I would also
+ *				like to add tape->name where possible
+ *                   AJN-3) Added different debug_level's
+ *                              via /proc/ide/hdc/settings
+ *				"debug_level" determines amount of debugging output;
+ *				can be changed using /proc/ide/hdx/settings
+ *				0 : almost no debugging output
+ *				1 : 0+output errors only
+ *				2 : 1+output all sensekey/asc
+ *				3 : 2+follow all chrdev related procedures
+ *				4 : 3+follow all procedures
+ *				5 : 4+include pc_stack rq_stack info
+ *				6 : 5+USE_COUNT updates
+ *                   AJN-4) Fixed timeout for retension in idetape_queue_pc_tail
+ *				from 5 to 10 minutes
+ *                   AJN-5) Changed maximum number of blocks to skip when
+ *                              reading tapes with multiple consecutive write
+ *                              errors from 100 to 1000 in idetape_get_logical_blk
+ *                   Proposed changes to code:
+ *                   1) output "logical_blk_num" via /proc
+ *                   2) output "current_operation" via /proc
+ *                   3) Either solve or document the fact that `mt rewind' is
+ *                      required after reading from /dev/nhtx to be
+ *			able to rmmod the idetape module;
+ *			Also, sometimes an application finishes but the
+ *			device remains `busy' for some time. Same cause ?
+ *                   Proposed changes to release-notes:
+ *		     4) write a simple `quickstart' section in the
+ *                      release notes; I volunteer if you don't want to
+ *		     5) include a pointer to video4linux in the doc
+ *                      to stimulate video applications
+ *                   6) release notes lines 331 and 362: explain what happens
+ *			if the application data rate is higher than 1100 KB/s;
+ *			similar approach to lower-than-500 kB/s ?
+ *		     7) 6.6 Comparison; wouldn't it be better to allow different
+ *			strategies for read and write ?
+ *			Wouldn't it be better to control the tape buffer
+ *			contents instead of the bandwidth ?
+ *		     8) line 536: replace will by would (if I understand
+ *			this section correctly, a hypothetical and unwanted situation
+ *			 is being described)
+ * Ver 1.16f Dec 15 99   Change place of the secondary OnStream header frames.
+ * Ver 1.17  Nov 2000 / Jan 2001  Marcel Mol, marcel@mesa.nl
+ *			- Add idetape_onstream_mode_sense_tape_parameter_page
+ *			  function to get tape capacity in frames: tape->capacity.
+ *			- Add support for DI-50 drives( or any DI- drive).
+ *			- 'workaround' for read error/blank block around block 3000.
+ *			- Implement Early warning for end of media for Onstream.
+ *			- Cosmetic code changes for readability.
+ *			- Idetape_position_tape should not use SKIP bit during
+ *			  Onstream read recovery.
+ *			- Add capacity, logical_blk_num and first/last_frame_position
+ *			  to /proc/ide/hd?/settings.
+ *			- Module use count was gone in the Linux 2.4 driver.
+ * Ver 1.17a Apr 2001 Willem Riede osst@riede.org
+ *			- Get drive's actual block size from mode sense block descriptor
+ *			- Limit size of pipeline
+ * Ver 1.17b Oct 2002   Alan Stern <stern@rowland.harvard.edu>
+ *			Changed IDETAPE_MIN_PIPELINE_STAGES to 1 and actually used
+ *			 it in the code!
+ *			Actually removed aborted stages in idetape_abort_pipeline
+ *			 instead of just changing the command code.
+ *			Made the transfer byte count for Request Sense equal to the
+ *			 actual length of the data transfer.
+ *			Changed handling of partial data transfers: they do not
+ *			 cause DMA errors.
+ *			Moved initiation of DMA transfers to the correct place.
+ *			Removed reference to unallocated memory.
+ *			Made __idetape_discard_read_pipeline return the number of
+ *			 sectors skipped, not the number of stages.
+ *			Replaced errant kfree() calls with __idetape_kfree_stage().
+ *			Fixed off-by-one error in testing the pipeline length.
+ *			Fixed handling of filemarks in the read pipeline.
+ *			Small code optimization for MTBSF and MTBSFM ioctls.
+ *			Don't try to unlock the door during device close if is
+ *			 already unlocked!
+ *			Cosmetic fixes to miscellaneous debugging output messages.
+ *			Set the minimum /proc/ide/hd?/settings values for "pipeline",
+ *			 "pipeline_min", and "pipeline_max" to 1.
+ */
diff --git a/Documentation/ide/ide-tape.txt b/Documentation/ide/ide-tape.txt
new file mode 100644
index 0000000..658f271
--- /dev/null
+++ b/Documentation/ide/ide-tape.txt
@@ -0,0 +1,146 @@
+/*
+ * IDE ATAPI streaming tape driver.
+ *
+ * This driver is a part of the Linux ide driver.
+ *
+ * The driver, in co-operation with ide.c, basically traverses the
+ * request-list for the block device interface. The character device
+ * interface, on the other hand, creates new requests, adds them
+ * to the request-list of the block device, and waits for their completion.
+ *
+ * Pipelined operation mode is now supported on both reads and writes.
+ *
+ * The block device major and minor numbers are determined from the
+ * tape's relative position in the ide interfaces, as explained in ide.c.
+ *
+ * The character device interface consists of the following devices:
+ *
+ * ht0		major 37, minor 0	first  IDE tape, rewind on close.
+ * ht1		major 37, minor 1	second IDE tape, rewind on close.
+ * ...
+ * nht0		major 37, minor 128	first  IDE tape, no rewind on close.
+ * nht1		major 37, minor 129	second IDE tape, no rewind on close.
+ * ...
+ *
+ * The general magnetic tape commands compatible interface, as defined by
+ * include/linux/mtio.h, is accessible through the character device.
+ *
+ * General ide driver configuration options, such as the interrupt-unmask
+ * flag, can be configured by issuing an ioctl to the block device interface,
+ * as any other ide device.
+ *
+ * Our own ide-tape ioctl's can be issued to either the block device or
+ * the character device interface.
+ *
+ * Maximal throughput with minimal bus load will usually be achieved in the
+ * following scenario:
+ *
+ *	1.	ide-tape is operating in the pipelined operation mode.
+ *	2.	No buffering is performed by the user backup program.
+ *
+ * Testing was done with a 2 GB CONNER CTMA 4000 IDE ATAPI Streaming Tape Drive.
+ *
+ * Here are some words from the first releases of hd.c, which are quoted
+ * in ide.c and apply here as well:
+ *
+ * | Special care is recommended.  Have Fun!
+ *
+ *
+ * An overview of the pipelined operation mode.
+ *
+ * In the pipelined write mode, we will usually just add requests to our
+ * pipeline and return immediately, before we even start to service them. The
+ * user program will then have enough time to prepare the next request while
+ * we are still busy servicing previous requests. In the pipelined read mode,
+ * the situation is similar - we add read-ahead requests into the pipeline,
+ * before the user even requested them.
+ *
+ * The pipeline can be viewed as a "safety net" which will be activated when
+ * the system load is high and prevents the user backup program from keeping up
+ * with the current tape speed. At this point, the pipeline will get
+ * shorter and shorter but the tape will still be streaming at the same speed.
+ * Assuming we have enough pipeline stages, the system load will hopefully
+ * decrease before the pipeline is completely empty, and the backup program
+ * will be able to "catch up" and refill the pipeline again.
+ *
+ * When using the pipelined mode, it would be best to disable any type of
+ * buffering done by the user program, as ide-tape already provides all the
+ * benefits in the kernel, where it can be done in a more efficient way.
+ * As we will usually not block the user program on a request, the most
+ * efficient user code will then be a simple read-write-read-... cycle.
+ * Any additional logic will usually just slow down the backup process.
+ *
+ * Using the pipelined mode, I get a constant over 400 KBps throughput,
+ * which seems to be the maximum throughput supported by my tape.
+ *
+ * However, there are some downfalls:
+ *
+ *	1.	We use memory (for data buffers) in proportional to the number
+ *		of pipeline stages (each stage is about 26 KB with my tape).
+ *	2.	In the pipelined write mode, we cheat and postpone error codes
+ *		to the user task. In read mode, the actual tape position
+ *		will be a bit further than the last requested block.
+ *
+ * Concerning (1):
+ *
+ *	1.	We allocate stages dynamically only when we need them. When
+ *		we don't need them, we don't consume additional memory. In
+ *		case we can't allocate stages, we just manage without them
+ *		(at the expense of decreased throughput) so when Linux is
+ *		tight in memory, we will not pose additional difficulties.
+ *
+ *	2.	The maximum number of stages (which is, in fact, the maximum
+ *		amount of memory) which we allocate is limited by the compile
+ *		time parameter IDETAPE_MAX_PIPELINE_STAGES.
+ *
+ *	3.	The maximum number of stages is a controlled parameter - We
+ *		don't start from the user defined maximum number of stages
+ *		but from the lower IDETAPE_MIN_PIPELINE_STAGES (again, we
+ *		will not even allocate this amount of stages if the user
+ *		program can't handle the speed). We then implement a feedback
+ *		loop which checks if the pipeline is empty, and if it is, we
+ *		increase the maximum number of stages as necessary until we
+ *		reach the optimum value which just manages to keep the tape
+ *		busy with minimum allocated memory or until we reach
+ *		IDETAPE_MAX_PIPELINE_STAGES.
+ *
+ * Concerning (2):
+ *
+ *	In pipelined write mode, ide-tape can not return accurate error codes
+ *	to the user program since we usually just add the request to the
+ *      pipeline without waiting for it to be serviced. In case an error
+ *      occurs, I will report it on the next user request.
+ *
+ *	In the pipelined read mode, subsequent read requests or forward
+ *	filemark spacing will perform correctly, as we preserve all blocks
+ *	and filemarks which we encountered during our excess read-ahead.
+ *
+ *	For accurate tape positioning and error reporting, disabling
+ *	pipelined mode might be the best option.
+ *
+ * You can enable/disable/tune the pipelined operation mode by adjusting
+ * the compile time parameters below.
+ *
+ *
+ *	Possible improvements.
+ *
+ *	1.	Support for the ATAPI overlap protocol.
+ *
+ *		In order to maximize bus throughput, we currently use the DSC
+ *		overlap method which enables ide.c to service requests from the
+ *		other device while the tape is busy executing a command. The
+ *		DSC overlap method involves polling the tape's status register
+ *		for the DSC bit, and servicing the other device while the tape
+ *		isn't ready.
+ *
+ *		In the current QIC development standard (December 1995),
+ *		it is recommended that new tape drives will *in addition*
+ *		implement the ATAPI overlap protocol, which is used for the
+ *		same purpose - efficient use of the IDE bus, but is interrupt
+ *		driven and thus has much less CPU overhead.
+ *
+ *		ATAPI overlap is likely to be supported in most new ATAPI
+ *		devices, including new ATAPI cdroms, and thus provides us
+ *		a method by which we can achieve higher throughput when
+ *		sharing a (fast) ATA-2 disk with any (slow) new ATAPI device.
+ */
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index e42a465..45b26ed 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -216,8 +216,7 @@ config BLK_DEV_IDECD_VERBOSE_ERRORS
 	  memory, though.
 
 config BLK_DEV_IDETAPE
-	tristate "Include IDE/ATAPI TAPE support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Include IDE/ATAPI TAPE support"
 	help
 	  If you have an IDE tape drive using the ATAPI protocol, say Y.
 	  ATAPI is a newer protocol used by IDE tape and CD-ROM drives,
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
index 037300f..0e7574c 100644
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -28,8 +28,10 @@ static int __init
 bastide_register(unsigned int base, unsigned int aux, int irq,
 		 ide_hwif_t **hwif)
 {
+	ide_hwif_t *hwif;
 	hw_regs_t hw;
 	int i;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	memset(&hw, 0, sizeof(hw));
 
@@ -44,8 +46,24 @@ bastide_register(unsigned int base, unsigned int aux, int irq,
 	hw.io_ports[IDE_CONTROL_OFFSET] = aux + (6 * 0x20);
 	hw.irq = irq;
 
-	ide_register_hw(&hw, NULL, hwif);
+	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	if (hwif == NULL)
+		goto out;
 
+	i = hwif->index;
+
+	if (hwif->present)
+		ide_unregister(i, 0, 0);
+	else if (!hwif->hold)
+		ide_init_port_data(hwif, i);
+
+	ide_init_port_hw(hwif, &hw);
+	hwif->quirkproc = NULL;
+
+	idx[0] = i;
+
+	ide_device_add(idx, NULL);
+out:
 	return 0;
 }
 
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 8d2cc47..fb00f38 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -377,9 +377,6 @@ static void icside_dma_lost_irq(ide_drive_t *drive)
 
 static void icside_dma_init(ide_hwif_t *hwif)
 {
-	hwif->mwdma_mask	= 7; /* MW0..2 */
-	hwif->swdma_mask	= 7; /* SW0..2 */
-
 	hwif->dmatable_cpu	= NULL;
 	hwif->dmatable_dma	= 0;
 	hwif->set_dma_mode	= icside_set_dma_mode;
@@ -459,11 +456,19 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	return 0;
 }
 
+static const struct ide_port_info icside_v6_port_info __initdata = {
+	.host_flags		= IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
+				  IDE_HFLAG_NO_AUTOTUNE,
+	.mwdma_mask		= ATA_MWDMA2,
+	.swdma_mask		= ATA_SWDMA2,
+};
+
 static int __init
 icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 {
@@ -472,6 +477,7 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	unsigned int sel = 0;
 	int ret;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	struct ide_port_info d = icside_v6_port_info;
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
 	if (!ioc_base) {
@@ -521,30 +527,25 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	state->hwif[1]    = mate;
 
 	hwif->maskproc    = icside_maskproc;
-	hwif->channel     = 0;
 	hwif->hwif_data   = state;
-	hwif->mate        = mate;
-	hwif->serialized  = 1;
 	hwif->config_data = (unsigned long)ioc_base;
 	hwif->select_data = sel;
 
 	mate->maskproc    = icside_maskproc;
-	mate->channel     = 1;
 	mate->hwif_data   = state;
-	mate->mate        = hwif;
-	mate->serialized  = 1;
 	mate->config_data = (unsigned long)ioc_base;
 	mate->select_data = sel | 1;
 
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
 		icside_dma_init(hwif);
 		icside_dma_init(mate);
-	}
+	} else
+		d.mwdma_mask = d.swdma_mask = 0;
 
 	idx[0] = hwif->index;
 	idx[1] = mate->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &d);
 
 	return 0;
 
diff --git a/drivers/ide/arm/ide_arm.c b/drivers/ide/arm/ide_arm.c
index 60f2497..43a70e9 100644
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -39,7 +39,7 @@ static int __init ide_arm_init(void)
 		ide_init_port_hw(hwif, &hw);
 		idx[0] = hwif->index;
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 	}
 
 	return 0;
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index c8b6581..efba00d 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -58,7 +58,7 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 		idx[0] = hwif->index;
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 
 		ecard_set_drvdata(ec, hwif);
 		goto out;
@@ -76,7 +76,7 @@ static void __devexit rapide_remove(struct expansion_card *ec)
 
 	ecard_set_drvdata(ec, NULL);
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif->index, 0, 0);
 
 	ecard_release_resources(ec);
 }
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 0640a38..00587a8 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -753,6 +753,15 @@ static void cris_set_dma_mode(ide_drive_t *drive, const u8 speed)
 		cris_ide_set_speed(TYPE_DMA, 0, strobe, hold);
 }
 
+static const struct ide_port_info cris_port_info __initdata = {
+	.chipset		= ide_etrax100,
+	.host_flags		= IDE_HFLAG_NO_ATAPI_DMA |
+				  IDE_HFLAG_NO_DMA, /* no SFF-style DMA */
+	.pio_mask		= ATA_PIO4,
+	.udma_mask		= cris_ultra_mask,
+	.mwdma_mask		= ATA_MWDMA2,
+};
+
 static int __init init_e100_ide(void)
 {
 	hw_regs_t hw;
@@ -780,7 +789,6 @@ static int __init init_e100_ide(void)
 		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
 		hwif->mmio = 1;
-		hwif->chipset = ide_etrax100;
 		hwif->set_pio_mode = &cris_set_pio_mode;
 		hwif->set_dma_mode = &cris_set_dma_mode;
 		hwif->ata_input_data = &cris_ide_input_data;
@@ -799,12 +807,6 @@ static int __init init_e100_ide(void)
 		hwif->INB = &cris_ide_inb;
 		hwif->INW = &cris_ide_inw;
 		hwif->cbl = ATA_CBL_PATA40;
-		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
-		hwif->pio_mask = ATA_PIO4,
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
-		hwif->ultra_mask = cris_ultra_mask;
-		hwif->mwdma_mask = 0x07; /* Multiword DMA 0-2 */
 
 		idx[h] = hwif->index;
 	}
@@ -820,7 +822,7 @@ static int __init init_e100_ide(void)
 	cris_ide_set_speed(TYPE_DMA, 0, ATA_DMA2_STROBE, ATA_DMA2_HOLD);
 	cris_ide_set_speed(TYPE_UDMA, ATA_UDMA2_CYC, ATA_UDMA2_DVS, 0);
 
-	ide_device_add(idx);
+	ide_device_add(idx, &cris_port_info);
 
 	return 0;
 }
@@ -1032,11 +1034,7 @@ static int cris_dma_setup(ide_drive_t *drive)
 
 static void cris_dma_exec_cmd(ide_drive_t *drive, u8 command)
 {
-	/* set the irq handler which will finish the request when DMA is done */
-	ide_set_handler(drive, &cris_dma_intr, WAIT_CMD, NULL);
-
-	/* issue cmd to drive */
-	cris_ide_outb(command, IDE_COMMAND_REG);
+	ide_execute_command(drive, command, &cris_dma_intr, WAIT_CMD, NULL);
 }
 
 static void cris_dma_start(ide_drive_t *drive)
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index 0243295..520aec0 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -114,7 +114,7 @@ static int __init h8300_ide_init(void)
 
 	idx[0] = index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	return 0;
 
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 68bc618..25aaeae 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -39,7 +39,6 @@ struct GTM_buffer {
 };
 
 struct ide_acpi_drive_link {
-	ide_drive_t	*drive;
 	acpi_handle	 obj_handle;
 	u8		 idbuff[512];
 };
@@ -280,16 +279,6 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 
 	port = hwif->channel ? drive->dn - 2: drive->dn;
 
-	if (!drive->acpidata) {
-		if (port == 0) {
-			drive->acpidata = &hwif->acpidata->master;
-			hwif->acpidata->master.drive = drive;
-		} else {
-			drive->acpidata = &hwif->acpidata->slave;
-			hwif->acpidata->slave.drive = drive;
-		}
-	}
-
 	DEBPRINT("ENTER: %s at %s, port#: %d, hard_port#: %d\n",
 		 hwif->name, dev->bus_id, port, hwif->channel);
 
@@ -494,7 +483,6 @@ int ide_acpi_exec_tfs(ide_drive_t *drive)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ide_acpi_exec_tfs);
 
 /**
  * ide_acpi_get_timing - get the channel (controller) timings
@@ -580,7 +568,6 @@ void ide_acpi_get_timing(ide_hwif_t *hwif)
 
 	kfree(output.pointer);
 }
-EXPORT_SYMBOL_GPL(ide_acpi_get_timing);
 
 /**
  * ide_acpi_push_timing - set the channel (controller) timings
@@ -634,7 +621,6 @@ void ide_acpi_push_timing(ide_hwif_t *hwif)
 	}
 	DEBPRINT("_STM status: %d\n", status);
 }
-EXPORT_SYMBOL_GPL(ide_acpi_push_timing);
 
 /**
  * ide_acpi_set_state - set the channel power state
@@ -688,11 +674,6 @@ void ide_acpi_set_state(ide_hwif_t *hwif, int on)
  */
 void ide_acpi_init(ide_hwif_t *hwif)
 {
-	int unit;
-	int			err;
-	struct ide_acpi_drive_link	*master;
-	struct ide_acpi_drive_link	*slave;
-
 	ide_acpi_blacklist();
 
 	hwif->acpidata = kzalloc(sizeof(struct ide_acpi_hwif_link), GFP_KERNEL);
@@ -704,40 +685,38 @@ void ide_acpi_init(ide_hwif_t *hwif)
 		DEBPRINT("no ACPI object for %s found\n", hwif->name);
 		kfree(hwif->acpidata);
 		hwif->acpidata = NULL;
-		return;
 	}
+}
+
+void ide_acpi_port_init_devices(ide_hwif_t *hwif)
+{
+	ide_drive_t *drive;
+	int i, err;
+
+	if (hwif->acpidata == NULL)
+		return;
 
 	/*
 	 * The ACPI spec mandates that we send information
 	 * for both drives, regardless whether they are connected
 	 * or not.
 	 */
-	hwif->acpidata->master.drive = &hwif->drives[0];
 	hwif->drives[0].acpidata = &hwif->acpidata->master;
-	master = &hwif->acpidata->master;
-
-	hwif->acpidata->slave.drive = &hwif->drives[1];
 	hwif->drives[1].acpidata = &hwif->acpidata->slave;
-	slave = &hwif->acpidata->slave;
-
 
 	/*
 	 * Send IDENTIFY for each drive
 	 */
-	if (master->drive->present) {
-		err = taskfile_lib_get_identify(master->drive, master->idbuff);
-		if (err) {
-			DEBPRINT("identify device %s failed (%d)\n",
-				 master->drive->name, err);
-		}
-	}
+	for (i = 0; i < MAX_DRIVES; i++) {
+		drive = &hwif->drives[i];
+
+		if (!drive->present)
+			continue;
 
-	if (slave->drive->present) {
-		err = taskfile_lib_get_identify(slave->drive, slave->idbuff);
-		if (err) {
+		err = taskfile_lib_get_identify(drive, drive->acpidata->idbuff);
+		if (err)
 			DEBPRINT("identify device %s failed (%d)\n",
-				 slave->drive->name, err);
-		}
+				 drive->name, err);
 	}
 
 	if (ide_noacpionboot) {
@@ -753,13 +732,11 @@ void ide_acpi_init(ide_hwif_t *hwif)
 	ide_acpi_get_timing(hwif);
 	ide_acpi_push_timing(hwif);
 
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t *drive = &hwif->drives[unit];
+	for (i = 0; i < MAX_DRIVES; i++) {
+		drive = &hwif->drives[i];
 
-		if (drive->present) {
+		if (drive->present)
 			/* Execute ACPI startup code */
 			ide_acpi_exec_tfs(drive);
-		}
 	}
 }
-EXPORT_SYMBOL_GPL(ide_acpi_init);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 23074e8..ee4d458 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -604,8 +604,6 @@ static ide_startstop_t cdrom_transfer_packet_command (ide_drive_t *drive,
  * Block read functions.
  */
 
-typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
-
 static void ide_cd_pad_transfer(ide_drive_t *drive, xfer_func_t *xf, int len)
 {
 	while (len > 0) {
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 7beaf1e..3cf59f2 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -819,6 +819,26 @@ int ide_set_dma(ide_drive_t *drive)
 	return 0;
 }
 
+void ide_check_dma_crc(ide_drive_t *drive)
+{
+	u8 mode;
+
+	ide_dma_off_quietly(drive);
+	drive->crc_count = 0;
+	mode = drive->current_speed;
+	/*
+	 * Don't try non Ultra-DMA modes without iCRC's.  Force the
+	 * device to PIO and make the user enable SWDMA/MWDMA modes.
+	 */
+	if (mode > XFER_UDMA_0 && mode <= XFER_UDMA_7)
+		mode--;
+	else
+		mode = XFER_PIO_4;
+	ide_set_xfer_rate(drive, mode);
+	if (drive->current_speed >= XFER_SW_DMA_0)
+		ide_dma_on(drive);
+}
+
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 void ide_dma_lost_irq (ide_drive_t *drive)
 {
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3512637..f8fe6ee 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -4,11 +4,6 @@
  * Copyright (C) 1996-1999  Gadi Oxman <gadio@netvision.net.il>
  * Copyright (C) 2000-2002  Paul Bristow <paul@paulbristow.net>
  * Copyright (C) 2005       Bartlomiej Zolnierkiewicz
- */
-
-/*
- * The driver currently doesn't have any fancy features, just the bare
- * minimum read/write support.
  *
  * This driver supports the following IDE floppy drives:
  *
@@ -20,7 +15,7 @@
  * Documentation/ide/ChangeLog.ide-floppy.1996-2002
  */
 
-#define IDEFLOPPY_VERSION "0.99.newide"
+#define IDEFLOPPY_VERSION "1.00"
 
 #include <linux/module.h>
 #include <linux/types.h>
@@ -42,179 +37,91 @@
 #include <scsi/scsi_ioctl.h>
 
 #include <asm/byteorder.h>
-#include <asm/irq.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/irq.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/unaligned.h>
 
-/*
- *	The following are used to debug the driver.
- */
+/* define to see debug info */
 #define IDEFLOPPY_DEBUG_LOG		0
-#define IDEFLOPPY_DEBUG_INFO		0
-#define IDEFLOPPY_DEBUG_BUGS		1
 
 /* #define IDEFLOPPY_DEBUG(fmt, args...) printk(KERN_INFO fmt, ## args) */
-#define IDEFLOPPY_DEBUG( fmt, args... )
+#define IDEFLOPPY_DEBUG(fmt, args...)
 
 #if IDEFLOPPY_DEBUG_LOG
-#define debug_log printk
+#define debug_log(fmt, args...) \
+	printk(KERN_INFO "ide-floppy: " fmt, ## args)
 #else
-#define debug_log(fmt, args... ) do {} while(0)
+#define debug_log(fmt, args...) do {} while (0)
 #endif
 
 
-/*
- *	Some drives require a longer irq timeout.
- */
+/* Some drives require a longer irq timeout. */
 #define IDEFLOPPY_WAIT_CMD		(5 * WAIT_CMD)
 
 /*
- *	After each failed packet command we issue a request sense command
- *	and retry the packet command IDEFLOPPY_MAX_PC_RETRIES times.
+ * After each failed packet command we issue a request sense command and retry
+ * the packet command IDEFLOPPY_MAX_PC_RETRIES times.
  */
 #define IDEFLOPPY_MAX_PC_RETRIES	3
 
 /*
- *	With each packet command, we allocate a buffer of
- *	IDEFLOPPY_PC_BUFFER_SIZE bytes.
+ * With each packet command, we allocate a buffer of IDEFLOPPY_PC_BUFFER_SIZE
+ * bytes.
  */
 #define IDEFLOPPY_PC_BUFFER_SIZE	256
 
 /*
- *	In various places in the driver, we need to allocate storage
- *	for packet commands and requests, which will remain valid while
- *	we leave the driver to wait for an interrupt or a timeout event.
+ * In various places in the driver, we need to allocate storage for packet
+ * commands and requests, which will remain valid while	we leave the driver to
+ * wait for an interrupt or a timeout event.
  */
 #define IDEFLOPPY_PC_STACK		(10 + IDEFLOPPY_MAX_PC_RETRIES)
 
-/*
- *	Our view of a packet command.
- */
 typedef struct idefloppy_packet_command_s {
 	u8 c[12];				/* Actual packet bytes */
-	int retries;				/* On each retry, we increment retries */
+	int retries;				/* On each retry, we increment
+						   retries */
 	int error;				/* Error code */
 	int request_transfer;			/* Bytes to transfer */
 	int actually_transferred;		/* Bytes actually transferred */
 	int buffer_size;			/* Size of our data buffer */
-	int b_count;				/* Missing/Available data on the current buffer */
+	int b_count;				/* Missing/Available data on
+						   the current buffer */
 	struct request *rq;			/* The corresponding request */
 	u8 *buffer;				/* Data buffer */
-	u8 *current_position;			/* Pointer into the above buffer */
-	void (*callback) (ide_drive_t *);	/* Called when this packet command is completed */
+	u8 *current_position;			/* Pointer into above buffer */
+	void (*callback) (ide_drive_t *);	/* Called when this packet
+						   command is completed */
 	u8 pc_buffer[IDEFLOPPY_PC_BUFFER_SIZE];	/* Temporary buffer */
-	unsigned long flags;			/* Status/Action bit flags: long for set_bit */
+	unsigned long flags;			/* Status/Action bit flags: long
+						   for set_bit */
 } idefloppy_pc_t;
 
-/*
- *	Packet command flag bits.
- */
-#define	PC_ABORT			0	/* Set when an error is considered normal - We won't retry */
-#define PC_DMA_RECOMMENDED		2	/* 1 when we prefer to use DMA if possible */
-#define	PC_DMA_IN_PROGRESS		3	/* 1 while DMA in progress */
-#define	PC_DMA_ERROR			4	/* 1 when encountered problem during DMA */
-#define	PC_WRITING			5	/* Data direction */
-
-#define	PC_SUPPRESS_ERROR		6	/* Suppress error reporting */
-
-/*
- *	Removable Block Access Capabilities Page
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	page_code	:6;	/* Page code - Should be 0x1b */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	ps		:1;	/* Should be 0 */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	ps		:1;	/* Should be 0 */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	page_code	:6;	/* Page code - Should be 0x1b */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		page_length;		/* Page Length - Should be 0xa */
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	reserved2	:6;
-	unsigned	srfp		:1;	/* Supports reporting progress of format */
-	unsigned	sflp		:1;	/* System floppy type device */
-	unsigned	tlun		:3;	/* Total logical units supported by the device */
-	unsigned	reserved3	:3;
-	unsigned	sml		:1;	/* Single / Multiple lun supported */
-	unsigned	ncd		:1;	/* Non cd optical device */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	sflp		:1;	/* System floppy type device */
-	unsigned	srfp		:1;	/* Supports reporting progress of format */
-	unsigned	reserved2	:6;
-	unsigned	ncd		:1;	/* Non cd optical device */
-	unsigned	sml		:1;	/* Single / Multiple lun supported */
-	unsigned	reserved3	:3;
-	unsigned	tlun		:3;	/* Total logical units supported by the device */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		reserved[8];
-} idefloppy_capabilities_page_t;
-
-/*
- *	Flexible disk page.
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	page_code	:6;	/* Page code - Should be 0x5 */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	ps		:1;	/* The device is capable of saving the page */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	ps		:1;	/* The device is capable of saving the page */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	page_code	:6;	/* Page code - Should be 0x5 */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		page_length;		/* Page Length - Should be 0x1e */
-	u16		transfer_rate;		/* In kilobits per second */
-	u8		heads, sectors;		/* Number of heads, Number of sectors per track */
-	u16		sector_size;		/* Byes per sector */
-	u16		cyls;			/* Number of cylinders */
-	u8		reserved10[10];
-	u8		motor_delay;		/* Motor off delay */
-	u8		reserved21[7];
-	u16		rpm;			/* Rotations per minute */
-	u8		reserved30[2];
-} idefloppy_flexible_disk_page_t;
- 
-/*
- *	Format capacity
- */
-typedef struct {
-	u8		reserved[3];
-	u8		length;			/* Length of the following descriptors in bytes */
-} idefloppy_capacity_header_t;
-
-typedef struct {
-	u32		blocks;			/* Number of blocks */
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	dc		:2;	/* Descriptor Code */
-	unsigned	reserved	:6;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	reserved	:6;
-	unsigned	dc		:2;	/* Descriptor Code */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		length_msb;		/* Block Length (MSB)*/
-	u16		length;			/* Block Length */
-} idefloppy_capacity_descriptor_t;
+/* Packet command flag bits. */
+enum {
+	/* 1 when we prefer to use DMA if possible */
+	PC_FLAG_DMA_RECOMMENDED	= (1 << 0),
+	/* 1 while DMA in progress */
+	PC_FLAG_DMA_IN_PROGRESS	= (1 << 1),
+	/* 1 when encountered problem during DMA */
+	PC_FLAG_DMA_ERROR	= (1 << 2),
+	/* Data direction */
+	PC_FLAG_WRITING		= (1 << 3),
+	/* Suppress error reporting */
+	PC_FLAG_SUPPRESS_ERROR	= (1 << 4),
+};
 
+/* format capacities descriptor codes */
 #define CAPACITY_INVALID	0x00
 #define CAPACITY_UNFORMATTED	0x01
 #define CAPACITY_CURRENT	0x02
 #define CAPACITY_NO_CARTRIDGE	0x03
 
 /*
- *	Most of our global data which we need to save even as we leave the
- *	driver due to an interrupt or a timer event is stored in a variable
- *	of type idefloppy_floppy_t, defined below.
+ * Most of our global data which we need to save even as we leave the driver
+ * due to an interrupt or a timer event is stored in a variable of type
+ * idefloppy_floppy_t, defined below.
  */
 typedef struct ide_floppy_obj {
 	ide_drive_t	*drive;
@@ -235,23 +142,19 @@ typedef struct ide_floppy_obj {
 	/* We implement a circular array */
 	int rq_stack_index;
 
-	/*
-	 *	Last error information
-	 */
+	/* Last error information */
 	u8 sense_key, asc, ascq;
 	/* delay this long before sending packet command */
 	u8 ticks;
 	int progress_indication;
 
-	/*
-	 *	Device information
-	 */
+	/* Device information */
 	/* Current format */
 	int blocks, block_size, bs_factor;
-	/* Last format capacity */
-	idefloppy_capacity_descriptor_t capacity;
+	/* Last format capacity descriptor */
+	u8 cap_desc[8];
 	/* Copy of the flexible disk page */
-	idefloppy_flexible_disk_page_t flexible_disk_page;
+	u8 flexible_disk_page[32];
 	/* Write protect */
 	int wp;
 	/* Supports format progress report */
@@ -262,64 +165,40 @@ typedef struct ide_floppy_obj {
 
 #define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
 
-/*
- *	Floppy flag bits values.
- */
-#define IDEFLOPPY_DRQ_INTERRUPT		0	/* DRQ interrupt device */
-#define IDEFLOPPY_MEDIA_CHANGED		1	/* Media may have changed */
-#define IDEFLOPPY_USE_READ12		2	/* Use READ12/WRITE12 or READ10/WRITE10 */
-#define	IDEFLOPPY_FORMAT_IN_PROGRESS	3	/* Format in progress */
-#define IDEFLOPPY_CLIK_DRIVE	        4       /* Avoid commands not supported in Clik drive */
-#define IDEFLOPPY_ZIP_DRIVE		5	/* Requires BH algorithm for packets */
-
-/*
- *	ATAPI floppy drive packet commands
- */
-#define IDEFLOPPY_FORMAT_UNIT_CMD	0x04
-#define IDEFLOPPY_INQUIRY_CMD		0x12
-#define IDEFLOPPY_MODE_SELECT_CMD	0x55
-#define IDEFLOPPY_MODE_SENSE_CMD	0x5a
-#define IDEFLOPPY_READ10_CMD		0x28
-#define IDEFLOPPY_READ12_CMD		0xa8
-#define IDEFLOPPY_READ_CAPACITY_CMD	0x23
-#define IDEFLOPPY_REQUEST_SENSE_CMD	0x03
-#define IDEFLOPPY_PREVENT_REMOVAL_CMD	0x1e
-#define IDEFLOPPY_SEEK_CMD		0x2b
-#define IDEFLOPPY_START_STOP_CMD	0x1b
-#define IDEFLOPPY_TEST_UNIT_READY_CMD	0x00
-#define IDEFLOPPY_VERIFY_CMD		0x2f
-#define IDEFLOPPY_WRITE10_CMD		0x2a
-#define IDEFLOPPY_WRITE12_CMD		0xaa
-#define IDEFLOPPY_WRITE_VERIFY_CMD	0x2e
+/* Floppy flag bits values. */
+enum {
+	/* DRQ interrupt device */
+	IDEFLOPPY_FLAG_DRQ_INTERRUPT		= (1 <<	0),
+	/* Media may have changed */
+	IDEFLOPPY_FLAG_MEDIA_CHANGED		= (1 << 1),
+	/* Format in progress */
+	IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS	= (1 << 2),
+	/* Avoid commands not supported in Clik drive */
+	IDEFLOPPY_FLAG_CLIK_DRIVE		= (1 << 3),
+	/* Requires BH algorithm for packets */
+	IDEFLOPPY_FLAG_ZIP_DRIVE		= (1 << 4),
+};
 
-/*
- *	Defines for the mode sense command
- */
+/* Defines for the MODE SENSE command */
 #define MODE_SENSE_CURRENT		0x00
 #define MODE_SENSE_CHANGEABLE		0x01
-#define MODE_SENSE_DEFAULT		0x02 
+#define MODE_SENSE_DEFAULT		0x02
 #define MODE_SENSE_SAVED		0x03
 
-/*
- *	IOCTLs used in low-level formatting.
- */
-
+/* IOCTLs used in low-level formatting. */
 #define	IDEFLOPPY_IOCTL_FORMAT_SUPPORTED	0x4600
 #define	IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY	0x4601
 #define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
 #define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
 
-/*
- *	Error codes which are returned in rq->errors to the higher part
- *	of the driver.
- */
+/* Error code returned in rq->errors to the higher part of the driver. */
 #define	IDEFLOPPY_ERROR_GENERAL		101
 
 /*
- *	The following is used to format the general configuration word of
- *	the ATAPI IDENTIFY DEVICE command.
+ * The following is used to format the general configuration word of the
+ * ATAPI IDENTIFY DEVICE command.
  */
-struct idefloppy_id_gcw {	
+struct idefloppy_id_gcw {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	unsigned packet_size		:2;	/* Packet Size */
 	unsigned reserved234		:3;	/* Reserved */
@@ -342,103 +221,12 @@ struct idefloppy_id_gcw {
 };
 
 /*
- *	INQUIRY packet command - Data Format
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	device_type	:5;	/* Peripheral Device Type */
-	unsigned	reserved0_765	:3;	/* Peripheral Qualifier - Reserved */
-	unsigned	reserved1_6t0	:7;	/* Reserved */
-	unsigned	rmb		:1;	/* Removable Medium Bit */
-	unsigned	ansi_version	:3;	/* ANSI Version */
-	unsigned	ecma_version	:3;	/* ECMA Version */
-	unsigned	iso_version	:2;	/* ISO Version */
-	unsigned	response_format :4;	/* Response Data Format */
-	unsigned	reserved3_45	:2;	/* Reserved */
-	unsigned	reserved3_6	:1;	/* TrmIOP - Reserved */
-	unsigned	reserved3_7	:1;	/* AENC - Reserved */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	reserved0_765	:3;	/* Peripheral Qualifier - Reserved */
-	unsigned	device_type	:5;	/* Peripheral Device Type */
-	unsigned	rmb		:1;	/* Removable Medium Bit */
-	unsigned	reserved1_6t0	:7;	/* Reserved */
-	unsigned	iso_version	:2;	/* ISO Version */
-	unsigned	ecma_version	:3;	/* ECMA Version */
-	unsigned	ansi_version	:3;	/* ANSI Version */
-	unsigned	reserved3_7	:1;	/* AENC - Reserved */
-	unsigned	reserved3_6	:1;	/* TrmIOP - Reserved */
-	unsigned	reserved3_45	:2;	/* Reserved */
-	unsigned	response_format :4;	/* Response Data Format */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		additional_length;	/* Additional Length (total_length-4) */
-	u8		rsv5, rsv6, rsv7;	/* Reserved */
-	u8		vendor_id[8];		/* Vendor Identification */
-	u8		product_id[16];		/* Product Identification */
-	u8		revision_level[4];	/* Revision Level */
-	u8		vendor_specific[20];	/* Vendor Specific - Optional */
-	u8		reserved56t95[40];	/* Reserved - Optional */
-						/* Additional information may be returned */
-} idefloppy_inquiry_result_t;
-
-/*
- *	REQUEST SENSE packet command result - Data Format.
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	error_code	:7;	/* Current error (0x70) */
-	unsigned	valid		:1;	/* The information field conforms to SFF-8070i */
-	u8		reserved1	:8;	/* Reserved */
-	unsigned	sense_key	:4;	/* Sense Key */
-	unsigned	reserved2_4	:1;	/* Reserved */
-	unsigned	ili		:1;	/* Incorrect Length Indicator */
-	unsigned	reserved2_67	:2;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	valid		:1;	/* The information field conforms to SFF-8070i */
-	unsigned	error_code	:7;	/* Current error (0x70) */
-	u8		reserved1	:8;	/* Reserved */
-	unsigned	reserved2_67	:2;
-	unsigned	ili		:1;	/* Incorrect Length Indicator */
-	unsigned	reserved2_4	:1;	/* Reserved */
-	unsigned	sense_key	:4;	/* Sense Key */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u32		information __attribute__ ((packed));
-	u8		asl;			/* Additional sense length (n-7) */
-	u32		command_specific;	/* Additional command specific information */
-	u8		asc;			/* Additional Sense Code */
-	u8		ascq;			/* Additional Sense Code Qualifier */
-	u8		replaceable_unit_code;	/* Field Replaceable Unit Code */
-	u8		sksv[3];
-	u8		pad[2];			/* Padding to 20 bytes */
-} idefloppy_request_sense_result_t;
-
-/*
- *	Pages of the SELECT SENSE / MODE SENSE packet commands.
+ * Pages of the SELECT SENSE / MODE SENSE packet commands.
+ * See SFF-8070i spec.
  */
 #define	IDEFLOPPY_CAPABILITIES_PAGE	0x1b
 #define IDEFLOPPY_FLEXIBLE_DISK_PAGE	0x05
 
-/*
- *	Mode Parameter Header for the MODE SENSE packet command
- */
-typedef struct {
-	u16		mode_data_length;	/* Length of the following data transfer */
-	u8		medium_type;		/* Medium Type */
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	reserved3	:7;
-	unsigned	wp		:1;	/* Write protect */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	wp		:1;	/* Write protect */
-	unsigned	reserved3	:7;
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		reserved[4];
-} idefloppy_mode_parameter_header_t;
-
 static DEFINE_MUTEX(idefloppy_ref_mutex);
 
 #define to_ide_floppy(obj) container_of(obj, struct ide_floppy_obj, kref)
@@ -458,39 +246,35 @@ static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
 	return floppy;
 }
 
-static void ide_floppy_release(struct kref *);
+static void idefloppy_cleanup_obj(struct kref *);
 
 static void ide_floppy_put(struct ide_floppy_obj *floppy)
 {
 	mutex_lock(&idefloppy_ref_mutex);
-	kref_put(&floppy->kref, ide_floppy_release);
+	kref_put(&floppy->kref, idefloppy_cleanup_obj);
 	mutex_unlock(&idefloppy_ref_mutex);
 }
 
 /*
- *	Too bad. The drive wants to send us data which we are not ready to accept.
- *	Just throw it away.
+ * Too bad. The drive wants to send us data which we are not ready to accept.
+ * Just throw it away.
  */
-static void idefloppy_discard_data (ide_drive_t *drive, unsigned int bcount)
+static void idefloppy_discard_data(ide_drive_t *drive, unsigned int bcount)
 {
 	while (bcount--)
 		(void) HWIF(drive)->INB(IDE_DATA_REG);
 }
 
-#if IDEFLOPPY_DEBUG_BUGS
-static void idefloppy_write_zeros (ide_drive_t *drive, unsigned int bcount)
+static void idefloppy_write_zeros(ide_drive_t *drive, unsigned int bcount)
 {
 	while (bcount--)
 		HWIF(drive)->OUTB(0, IDE_DATA_REG);
 }
-#endif /* IDEFLOPPY_DEBUG_BUGS */
 
 
 /*
- *	idefloppy_do_end_request is used to finish servicing a request.
- *
- *	For read/write requests, we will call ide_end_request to pass to the
- *	next buffer.
+ * Used to finish servicing a request. For read/write requests, we will call
+ * ide_end_request to pass to the next buffer.
  */
 static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
@@ -498,12 +282,12 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	struct request *rq = HWGROUP(drive)->rq;
 	int error;
 
-	debug_log(KERN_INFO "Reached idefloppy_end_request\n");
+	debug_log("Reached %s\n", __func__);
 
 	switch (uptodate) {
-		case 0: error = IDEFLOPPY_ERROR_GENERAL; break;
-		case 1: error = 0; break;
-		default: error = uptodate;
+	case 0: error = IDEFLOPPY_ERROR_GENERAL; break;
+	case 1: error = 0; break;
+	default: error = uptodate;
 	}
 	if (error)
 		floppy->failed_pc = NULL;
@@ -521,39 +305,8 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	return 0;
 }
 
-static void idefloppy_input_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, unsigned int bcount)
-{
-	struct request *rq = pc->rq;
-	struct bio_vec *bvec;
-	struct req_iterator iter;
-	unsigned long flags;
-	char *data;
-	int count, done = 0;
-
-	rq_for_each_segment(bvec, rq, iter) {
-		if (!bcount)
-			break;
-
-		count = min(bvec->bv_len, bcount);
-
-		data = bvec_kmap_irq(bvec, &flags);
-		drive->hwif->atapi_input_bytes(drive, data, count);
-		bvec_kunmap_irq(data, &flags);
-
-		bcount -= count;
-		pc->b_count += count;
-		done += count;
-	}
-
-	idefloppy_do_end_request(drive, 1, done >> 9);
-
-	if (bcount) {
-		printk(KERN_ERR "%s: leftover data in idefloppy_input_buffers, bcount == %d\n", drive->name, bcount);
-		idefloppy_discard_data(drive, bcount);
-	}
-}
-
-static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, unsigned int bcount)
+static void ide_floppy_io_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
+				  unsigned int bcount, int direction)
 {
 	struct request *rq = pc->rq;
 	struct req_iterator iter;
@@ -569,7 +322,10 @@ static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, un
 		count = min(bvec->bv_len, bcount);
 
 		data = bvec_kmap_irq(bvec, &flags);
-		drive->hwif->atapi_output_bytes(drive, data, count);
+		if (direction)
+			drive->hwif->atapi_output_bytes(drive, data, count);
+		else
+			drive->hwif->atapi_input_bytes(drive, data, count);
 		bvec_kunmap_irq(data, &flags);
 
 		bcount -= count;
@@ -579,15 +335,18 @@ static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, un
 
 	idefloppy_do_end_request(drive, 1, done >> 9);
 
-#if IDEFLOPPY_DEBUG_BUGS
 	if (bcount) {
-		printk(KERN_ERR "%s: leftover data in idefloppy_output_buffers, bcount == %d\n", drive->name, bcount);
-		idefloppy_write_zeros(drive, bcount);
+		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
+				drive->name, __func__, bcount);
+		if (direction)
+			idefloppy_write_zeros(drive, bcount);
+		else
+			idefloppy_discard_data(drive, bcount);
+
 	}
-#endif
 }
 
-static void idefloppy_update_buffers (ide_drive_t *drive, idefloppy_pc_t *pc)
+static void idefloppy_update_buffers(ide_drive_t *drive, idefloppy_pc_t *pc)
 {
 	struct request *rq = pc->rq;
 	struct bio *bio = rq->bio;
@@ -597,11 +356,12 @@ static void idefloppy_update_buffers (ide_drive_t *drive, idefloppy_pc_t *pc)
 }
 
 /*
- *	idefloppy_queue_pc_head generates a new packet command request in front
- *	of the request queue, before the current request, so that it will be
- *	processed immediately, on the next pass through the driver.
+ * Generate a new packet command request in front of the request queue, before
+ * the current request so that it will be processed immediately, on the next
+ * pass through the driver.
  */
-static void idefloppy_queue_pc_head (ide_drive_t *drive,idefloppy_pc_t *pc,struct request *rq)
+static void idefloppy_queue_pc_head(ide_drive_t *drive, idefloppy_pc_t *pc,
+		struct request *rq)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 
@@ -612,16 +372,16 @@ static void idefloppy_queue_pc_head (ide_drive_t *drive,idefloppy_pc_t *pc,struc
 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
 }
 
-static idefloppy_pc_t *idefloppy_next_pc_storage (ide_drive_t *drive)
+static idefloppy_pc_t *idefloppy_next_pc_storage(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 	if (floppy->pc_stack_index == IDEFLOPPY_PC_STACK)
-		floppy->pc_stack_index=0;
+		floppy->pc_stack_index = 0;
 	return (&floppy->pc_stack[floppy->pc_stack_index++]);
 }
 
-static struct request *idefloppy_next_rq_storage (ide_drive_t *drive)
+static struct request *idefloppy_next_rq_storage(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
@@ -630,60 +390,53 @@ static struct request *idefloppy_next_rq_storage (ide_drive_t *drive)
 	return (&floppy->rq_stack[floppy->rq_stack_index++]);
 }
 
-/*
- *	idefloppy_analyze_error is called on each failed packet command retry
- *	to analyze the request sense.
- */
-static void idefloppy_analyze_error (ide_drive_t *drive,idefloppy_request_sense_result_t *result)
+static void idefloppy_request_sense_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	u8 *buf = floppy->pc->buffer;
 
-	floppy->sense_key = result->sense_key;
-	floppy->asc = result->asc;
-	floppy->ascq = result->ascq;
-	floppy->progress_indication = result->sksv[0] & 0x80 ?
-		(u16)get_unaligned((u16 *)(result->sksv+1)):0x10000;
-	if (floppy->failed_pc)
-		debug_log(KERN_INFO "ide-floppy: pc = %x, sense key = %x, "
-			"asc = %x, ascq = %x\n", floppy->failed_pc->c[0],
-			result->sense_key, result->asc, result->ascq);
-	else
-		debug_log(KERN_INFO "ide-floppy: sense key = %x, asc = %x, "
-			"ascq = %x\n", result->sense_key,
-			result->asc, result->ascq);
-}
-
-static void idefloppy_request_sense_callback (ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	debug_log("Reached %s\n", __func__);
 
-	debug_log(KERN_INFO "ide-floppy: Reached %s\n", __FUNCTION__);
-	
 	if (!floppy->pc->error) {
-		idefloppy_analyze_error(drive,(idefloppy_request_sense_result_t *) floppy->pc->buffer);
+		floppy->sense_key = buf[2] & 0x0F;
+		floppy->asc = buf[12];
+		floppy->ascq = buf[13];
+		floppy->progress_indication = buf[15] & 0x80 ?
+			(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
+
+		if (floppy->failed_pc)
+			debug_log("pc = %x, sense key = %x, asc = %x,"
+					" ascq = %x\n",
+					floppy->failed_pc->c[0],
+					floppy->sense_key,
+					floppy->asc,
+					floppy->ascq);
+		else
+			debug_log("sense key = %x, asc = %x, ascq = %x\n",
+					floppy->sense_key,
+					floppy->asc,
+					floppy->ascq);
+
+
 		idefloppy_do_end_request(drive, 1, 0);
 	} else {
-		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting request!\n");
+		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting"
+				" request!\n");
 		idefloppy_do_end_request(drive, 0, 0);
 	}
 }
 
-/*
- *	General packet command callback function.
- */
-static void idefloppy_pc_callback (ide_drive_t *drive)
+/* General packet command callback function. */
+static void idefloppy_pc_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	
-	debug_log(KERN_INFO "ide-floppy: Reached %s\n", __FUNCTION__);
+
+	debug_log("Reached %s\n", __func__);
 
 	idefloppy_do_end_request(drive, floppy->pc->error ? 0 : 1, 0);
 }
 
-/*
- *	idefloppy_init_pc initializes a packet command.
- */
-static void idefloppy_init_pc (idefloppy_pc_t *pc)
+static void idefloppy_init_pc(idefloppy_pc_t *pc)
 {
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
@@ -694,21 +447,20 @@ static void idefloppy_init_pc (idefloppy_pc_t *pc)
 	pc->callback = &idefloppy_pc_callback;
 }
 
-static void idefloppy_create_request_sense_cmd (idefloppy_pc_t *pc)
+static void idefloppy_create_request_sense_cmd(idefloppy_pc_t *pc)
 {
-	idefloppy_init_pc(pc);	
-	pc->c[0] = IDEFLOPPY_REQUEST_SENSE_CMD;
+	idefloppy_init_pc(pc);
+	pc->c[0] = GPCMD_REQUEST_SENSE;
 	pc->c[4] = 255;
 	pc->request_transfer = 18;
 	pc->callback = &idefloppy_request_sense_callback;
 }
 
 /*
- *	idefloppy_retry_pc is called when an error was detected during the
- *	last packet command. We queue a request sense packet command in
- *	the head of the request list.
+ * Called when an error was detected during the last packet command. We queue a
+ * request sense packet command in the head of the request list.
  */
-static void idefloppy_retry_pc (ide_drive_t *drive)
+static void idefloppy_retry_pc(ide_drive_t *drive)
 {
 	idefloppy_pc_t *pc;
 	struct request *rq;
@@ -720,49 +472,50 @@ static void idefloppy_retry_pc (ide_drive_t *drive)
 	idefloppy_queue_pc_head(drive, pc, rq);
 }
 
-/*
- *	idefloppy_pc_intr is the usual interrupt handler which will be called
- *	during a packet command.
- */
+/* The usual interrupt handler called during a packet command. */
 static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 	idefloppy_pc_t *pc = floppy->pc;
 	struct request *rq = pc->rq;
+	xfer_func_t *xferfunc;
 	unsigned int temp;
+	int dma_error = 0;
 	u16 bcount;
 	u8 stat, ireason;
 
-	debug_log(KERN_INFO "ide-floppy: Reached %s interrupt handler\n",
-		__FUNCTION__);
+	debug_log("Reached %s interrupt handler\n", __func__);
 
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
-		if (HWIF(drive)->ide_dma_end(drive)) {
-			set_bit(PC_DMA_ERROR, &pc->flags);
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		dma_error = hwif->ide_dma_end(drive);
+		if (dma_error) {
+			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
+					rq_data_dir(rq) ? "write" : "read");
+			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->actually_transferred = pc->request_transfer;
 			idefloppy_update_buffers(drive, pc);
 		}
-		debug_log(KERN_INFO "ide-floppy: DMA finished\n");
+		debug_log("DMA finished\n");
 	}
 
 	/* Clear the interrupt */
 	stat = drive->hwif->INB(IDE_STATUS_REG);
 
-	if ((stat & DRQ_STAT) == 0) {		/* No more interrupts */
-		debug_log(KERN_INFO "Packet command completed, %d bytes "
-			"transferred\n", pc->actually_transferred);
-		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+	/* No more interrupts */
+	if ((stat & DRQ_STAT) == 0) {
+		debug_log("Packet command completed, %d bytes transferred\n",
+				pc->actually_transferred);
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 
 		local_irq_enable_in_hardirq();
 
-		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
+		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
 			/* Error detected */
-			debug_log(KERN_INFO "ide-floppy: %s: I/O error\n",
-				drive->name);
+			debug_log("%s: I/O error\n", drive->name);
 			rq->errors++;
-			if (pc->c[0] == IDEFLOPPY_REQUEST_SENSE_CMD) {
+			if (pc->c[0] == GPCMD_REQUEST_SENSE) {
 				printk(KERN_ERR "ide-floppy: I/O error in "
 					"request sense command\n");
 				return ide_do_reset(drive);
@@ -780,7 +533,8 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 		return ide_stopped;
 	}
 
-	if (test_and_clear_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		printk(KERN_ERR "ide-floppy: The floppy wants to issue "
 			"more interrupts in DMA mode\n");
 		ide_dma_off(drive);
@@ -794,10 +548,10 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	ireason = hwif->INB(IDE_IREASON_REG);
 
 	if (ireason & CD) {
-		printk(KERN_ERR "ide-floppy: CoD != 0 in idefloppy_pc_intr\n");
+		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __func__);
 		return ide_do_reset(drive);
 	}
-	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
+	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "ide-floppy: We wanted to %s, ",
 				(ireason & IO) ? "Write" : "Read");
@@ -805,7 +559,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
-	if (!test_bit(PC_WRITING, &pc->flags)) {
+	if (!(pc->flags & PC_FLAG_WRITING)) {
 		/* Reading - Check that we have enough space */
 		temp = pc->actually_transferred + bcount;
 		if (temp > pc->request_transfer) {
@@ -814,39 +568,34 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 					"to send us more data than expected "
 					"- discarding data\n");
 				idefloppy_discard_data(drive, bcount);
-				BUG_ON(HWGROUP(drive)->handler != NULL);
+
 				ide_set_handler(drive,
 						&idefloppy_pc_intr,
 						IDEFLOPPY_WAIT_CMD,
 						NULL);
 				return ide_started;
 			}
-			debug_log(KERN_NOTICE "ide-floppy: The floppy wants to "
-				"send us more data than expected - "
-				"allowing transfer\n");
+			debug_log("The floppy wants to send us more data than"
+					" expected - allowing transfer\n");
 		}
 	}
-	if (test_bit(PC_WRITING, &pc->flags)) {
-		if (pc->buffer != NULL)
-			/* Write the current buffer */
-			hwif->atapi_output_bytes(drive, pc->current_position,
-						 bcount);
-		else
-			idefloppy_output_buffers(drive, pc, bcount);
-	} else {
-		if (pc->buffer != NULL)
-			/* Read the current buffer */
-			hwif->atapi_input_bytes(drive, pc->current_position,
-						bcount);
-		else
-			idefloppy_input_buffers(drive, pc, bcount);
-	}
+	if (pc->flags & PC_FLAG_WRITING)
+		xferfunc = hwif->atapi_output_bytes;
+	else
+		xferfunc = hwif->atapi_input_bytes;
+
+	if (pc->buffer)
+		xferfunc(drive, pc->current_position, bcount);
+	else
+		ide_floppy_io_buffers(drive, pc, bcount,
+				      !!(pc->flags & PC_FLAG_WRITING));
+
 	/* Update the current position */
 	pc->actually_transferred += bcount;
 	pc->current_position += bcount;
 
-	BUG_ON(HWGROUP(drive)->handler != NULL);
-	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);		/* And set the interrupt handler again */
+	/* And set the interrupt handler again */
+	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
 	return ide_started;
 }
 
@@ -855,7 +604,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
  * It fails at high speeds on the Iomega ZIP drive, so there's a slower version
  * for that drive below. The algorithm is chosen based on drive type
  */
-static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
+static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
 {
 	ide_startstop_t startstop;
 	idefloppy_floppy_t *floppy = drive->driver_data;
@@ -872,7 +621,7 @@ static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
 				"issuing a packet command\n");
 		return ide_do_reset(drive);
 	}
-	BUG_ON(HWGROUP(drive)->handler != NULL);
+
 	/* Set the interrupt routine */
 	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
 	/* Send the actual packet */
@@ -882,18 +631,16 @@ static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
 
 
 /*
- * What we have here is a classic case of a top half / bottom half
- * interrupt service routine. In interrupt mode, the device sends
- * an interrupt to signal it's ready to receive a packet. However,
- * we need to delay about 2-3 ticks before issuing the packet or we
- * gets in trouble.
+ * What we have here is a classic case of a top half / bottom half interrupt
+ * service routine. In interrupt mode, the device sends an interrupt to signal
+ * that it is ready to receive a packet. However, we need to delay about 2-3
+ * ticks before issuing the packet or we gets in trouble.
  *
- * So, follow carefully. transfer_pc1 is called as an interrupt (or
- * directly). In either case, when the device says it's ready for a 
- * packet, we schedule the packet transfer to occur about 2-3 ticks
- * later in transfer_pc2.
+ * So, follow carefully. transfer_pc1 is called as an interrupt (or directly).
+ * In either case, when the device says it's ready for a packet, we schedule
+ * the packet transfer to occur about 2-3 ticks later in transfer_pc2.
  */
-static int idefloppy_transfer_pc2 (ide_drive_t *drive)
+static int idefloppy_transfer_pc2(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
@@ -903,7 +650,7 @@ static int idefloppy_transfer_pc2 (ide_drive_t *drive)
 	return IDEFLOPPY_WAIT_CMD;
 }
 
-static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
+static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_startstop_t startstop;
@@ -920,7 +667,7 @@ static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
 				"while issuing a packet command\n");
 		return ide_do_reset(drive);
 	}
-	/* 
+	/*
 	 * The following delay solves a problem with ATAPI Zip 100 drives
 	 * where the Busy flag was apparently being deasserted before the
 	 * unit was ready to receive data. This was happening on a
@@ -928,32 +675,30 @@ static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
 	 * 40 and 50msec work well. idefloppy_pc_intr will not be actually
 	 * used until after the packet is moved in about 50 msec.
 	 */
-	BUG_ON(HWGROUP(drive)->handler != NULL);
-	ide_set_handler(drive, 
-	  &idefloppy_pc_intr, 		/* service routine for packet command */
-	  floppy->ticks,		/* wait this long before "failing" */
-	  &idefloppy_transfer_pc2);	/* fail == transfer_pc2 */
+
+	ide_set_handler(drive, &idefloppy_pc_intr, floppy->ticks,
+			&idefloppy_transfer_pc2);
 	return ide_started;
 }
 
-/**
- * idefloppy_should_report_error()
- *
- * Supresses error messages resulting from Medium not present
- */
-static inline int idefloppy_should_report_error(idefloppy_floppy_t *floppy)
+static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
+				    idefloppy_pc_t *pc)
 {
+	/* supress error messages resulting from Medium not present */
 	if (floppy->sense_key == 0x02 &&
 	    floppy->asc       == 0x3a &&
 	    floppy->ascq      == 0x00)
-		return 0;
-	return 1;
+		return;
+
+	printk(KERN_ERR "ide-floppy: %s: I/O error, pc = %2x, key = %2x, "
+			"asc = %2x, ascq = %2x\n",
+			floppy->drive->name, pc->c[0], floppy->sense_key,
+			floppy->asc, floppy->ascq);
+
 }
 
-/*
- *	Issue a packet command
- */
-static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *pc)
+static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
+		idefloppy_pc_t *pc)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
@@ -962,36 +707,23 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 	u8 dma;
 
 	if (floppy->failed_pc == NULL &&
-	    pc->c[0] != IDEFLOPPY_REQUEST_SENSE_CMD)
+	    pc->c[0] != GPCMD_REQUEST_SENSE)
 		floppy->failed_pc = pc;
 	/* Set the current packet command */
 	floppy->pc = pc;
 
-	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES ||
-	    test_bit(PC_ABORT, &pc->flags)) {
-		/*
-		 *	We will "abort" retrying a packet command in case
-		 *	a legitimate error code was received.
-		 */
-		if (!test_bit(PC_ABORT, &pc->flags)) {
-			if (!test_bit(PC_SUPPRESS_ERROR, &pc->flags)) {
-				if (idefloppy_should_report_error(floppy))
-					printk(KERN_ERR "ide-floppy: %s: I/O error, "
-					       "pc = %2x, key = %2x, "
-					       "asc = %2x, ascq = %2x\n",
-					       drive->name, pc->c[0],
-					       floppy->sense_key,
-					       floppy->asc, floppy->ascq);
-			}
-			/* Giving up */
-			pc->error = IDEFLOPPY_ERROR_GENERAL;
-		}
+	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES) {
+		if (!(pc->flags & PC_FLAG_SUPPRESS_ERROR))
+			ide_floppy_report_error(floppy, pc);
+		/* Giving up */
+		pc->error = IDEFLOPPY_ERROR_GENERAL;
+
 		floppy->failed_pc = NULL;
 		pc->callback(drive);
 		return ide_stopped;
 	}
 
-	debug_log(KERN_INFO "Retry number - %d\n",pc->retries);
+	debug_log("Retry number - %d\n", pc->retries);
 
 	pc->retries++;
 	/* We haven't transferred any data yet */
@@ -999,24 +731,26 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 	pc->current_position = pc->buffer;
 	bcount = min(pc->request_transfer, 63 * 1024);
 
-	if (test_and_clear_bit(PC_DMA_ERROR, &pc->flags))
+	if (pc->flags & PC_FLAG_DMA_ERROR) {
+		pc->flags &= ~PC_FLAG_DMA_ERROR;
 		ide_dma_off(drive);
-
+	}
 	dma = 0;
 
-	if (test_bit(PC_DMA_RECOMMENDED, &pc->flags) && drive->using_dma)
+	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
 		dma = !hwif->dma_setup(drive);
 
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
 			   IDE_TFLAG_OUT_DEVICE, bcount, dma);
 
-	if (dma) {	/* Begin DMA, if necessary */
-		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+	if (dma) {
+		/* Begin DMA, if necessary */
+		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
 		hwif->dma_start(drive);
 	}
 
 	/* Can we transfer the packet when we get the interrupt or wait? */
-	if (test_bit(IDEFLOPPY_ZIP_DRIVE, &floppy->flags)) {
+	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) {
 		/* wait */
 		pkt_xfer_routine = &idefloppy_transfer_pc1;
 	} else {
@@ -1024,7 +758,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 		pkt_xfer_routine = &idefloppy_transfer_pc;
 	}
 	
-	if (test_bit (IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags)) {
+	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
 				pkt_xfer_routine,
@@ -1038,38 +772,37 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 	}
 }
 
-static void idefloppy_rw_callback (ide_drive_t *drive)
+static void idefloppy_rw_callback(ide_drive_t *drive)
 {
-	debug_log(KERN_INFO "ide-floppy: Reached idefloppy_rw_callback\n");
+	debug_log("Reached %s\n", __func__);
 
 	idefloppy_do_end_request(drive, 1, 0);
 	return;
 }
 
-static void idefloppy_create_prevent_cmd (idefloppy_pc_t *pc, int prevent)
+static void idefloppy_create_prevent_cmd(idefloppy_pc_t *pc, int prevent)
 {
-	debug_log(KERN_INFO "ide-floppy: creating prevent removal command, "
-		"prevent = %d\n", prevent);
+	debug_log("creating prevent removal command, prevent = %d\n", prevent);
 
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_PREVENT_REMOVAL_CMD;
+	pc->c[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
 	pc->c[4] = prevent;
 }
 
-static void idefloppy_create_read_capacity_cmd (idefloppy_pc_t *pc)
+static void idefloppy_create_read_capacity_cmd(idefloppy_pc_t *pc)
 {
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_READ_CAPACITY_CMD;
+	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
 	pc->c[7] = 255;
 	pc->c[8] = 255;
 	pc->request_transfer = 255;
 }
 
-static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
+static void idefloppy_create_format_unit_cmd(idefloppy_pc_t *pc, int b, int l,
 					      int flags)
 {
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_FORMAT_UNIT_CMD;
+	pc->c[0] = GPCMD_FORMAT_UNIT;
 	pc->c[1] = 0x17;
 
 	memset(pc->buffer, 0, 12);
@@ -1080,83 +813,79 @@ static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
 		pc->buffer[1] ^= 0x20;		/* ... turn off DCRT bit */
 	pc->buffer[3] = 8;
 
-	put_unaligned(htonl(b), (unsigned int *)(&pc->buffer[4]));
-	put_unaligned(htonl(l), (unsigned int *)(&pc->buffer[8]));
-	pc->buffer_size=12;
-	set_bit(PC_WRITING, &pc->flags);
+	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buffer[4]));
+	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buffer[8]));
+	pc->buffer_size = 12;
+	pc->flags |= PC_FLAG_WRITING;
 }
 
-/*
- *	A mode sense command is used to "sense" floppy parameters.
- */
-static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code, u8 type)
+/* A mode sense command is used to "sense" floppy parameters. */
+static void idefloppy_create_mode_sense_cmd(idefloppy_pc_t *pc, u8 page_code,
+		u8 type)
 {
-	u16 length = sizeof(idefloppy_mode_parameter_header_t);
-	
+	u16 length = 8; /* sizeof(Mode Parameter Header) = 8 Bytes */
+
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_MODE_SENSE_CMD;
+	pc->c[0] = GPCMD_MODE_SENSE_10;
 	pc->c[1] = 0;
 	pc->c[2] = page_code + (type << 6);
 
 	switch (page_code) {
-		case IDEFLOPPY_CAPABILITIES_PAGE:
-			length += 12;
-			break;
-		case IDEFLOPPY_FLEXIBLE_DISK_PAGE:
-			length += 32;
-			break;
-		default:
-			printk(KERN_ERR "ide-floppy: unsupported page code "
+	case IDEFLOPPY_CAPABILITIES_PAGE:
+		length += 12;
+		break;
+	case IDEFLOPPY_FLEXIBLE_DISK_PAGE:
+		length += 32;
+		break;
+	default:
+		printk(KERN_ERR "ide-floppy: unsupported page code "
 				"in create_mode_sense_cmd\n");
 	}
-	put_unaligned(htons(length), (u16 *) &pc->c[7]);
+	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
 	pc->request_transfer = length;
 }
 
-static void idefloppy_create_start_stop_cmd (idefloppy_pc_t *pc, int start)
+static void idefloppy_create_start_stop_cmd(idefloppy_pc_t *pc, int start)
 {
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_START_STOP_CMD;
+	pc->c[0] = GPCMD_START_STOP_UNIT;
 	pc->c[4] = start;
 }
 
 static void idefloppy_create_test_unit_ready_cmd(idefloppy_pc_t *pc)
 {
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_TEST_UNIT_READY_CMD;
+	pc->c[0] = GPCMD_TEST_UNIT_READY;
 }
 
-static void idefloppy_create_rw_cmd (idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct request *rq, unsigned long sector)
+static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
+				    idefloppy_pc_t *pc, struct request *rq,
+				    unsigned long sector)
 {
 	int block = sector / floppy->bs_factor;
 	int blocks = rq->nr_sectors / floppy->bs_factor;
 	int cmd = rq_data_dir(rq);
 
-	debug_log("create_rw1%d_cmd: block == %d, blocks == %d\n",
-		2 * test_bit (IDEFLOPPY_USE_READ12, &floppy->flags),
+	debug_log("create_rw10_cmd: block == %d, blocks == %d\n",
 		block, blocks);
 
 	idefloppy_init_pc(pc);
-	if (test_bit(IDEFLOPPY_USE_READ12, &floppy->flags)) {
-		pc->c[0] = cmd == READ ? IDEFLOPPY_READ12_CMD : IDEFLOPPY_WRITE12_CMD;
-		put_unaligned(htonl(blocks), (unsigned int *) &pc->c[6]);
-	} else {
-		pc->c[0] = cmd == READ ? IDEFLOPPY_READ10_CMD : IDEFLOPPY_WRITE10_CMD;
-		put_unaligned(htons(blocks), (unsigned short *) &pc->c[7]);
-	}
-	put_unaligned(htonl(block), (unsigned int *) &pc->c[2]);
+	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
+	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
+	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
+
 	pc->callback = &idefloppy_rw_callback;
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
-		set_bit(PC_WRITING, &pc->flags);
+		pc->flags |= PC_FLAG_WRITING;
 	pc->buffer = NULL;
 	pc->request_transfer = pc->buffer_size = blocks * floppy->block_size;
-	set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+	pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
-static void
-idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct request *rq)
+static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
+		idefloppy_pc_t *pc, struct request *rq)
 {
 	idefloppy_init_pc(pc);
 	pc->callback = &idefloppy_rw_callback;
@@ -1164,11 +893,10 @@ idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct req
 	pc->rq = rq;
 	pc->b_count = rq->data_len;
 	if (rq->data_len && rq_data_dir(rq) == WRITE)
-		set_bit(PC_WRITING, &pc->flags);
+		pc->flags |= PC_FLAG_WRITING;
 	pc->buffer = rq->data;
 	if (rq->bio)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
-		
+		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 	/*
 	 * possibly problematic, doesn't look like ide-floppy correctly
 	 * handled scattered requests if dma fails...
@@ -1176,30 +904,23 @@ idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct req
 	pc->request_transfer = pc->buffer_size = rq->data_len;
 }
 
-/*
- *	idefloppy_do_request is our request handling function.	
- */
-static ide_startstop_t idefloppy_do_request (ide_drive_t *drive, struct request *rq, sector_t block_s)
+static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
+		struct request *rq, sector_t block_s)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t *pc;
 	unsigned long block = (unsigned long)block_s;
 
-	debug_log(KERN_INFO "dev: %s, flags: %lx, errors: %d\n",
+	debug_log("dev: %s, cmd_type: %x, errors: %d\n",
 			rq->rq_disk ? rq->rq_disk->disk_name : "?",
-			rq->flags, rq->errors);
-	debug_log(KERN_INFO "sector: %ld, nr_sectors: %ld, "
+			rq->cmd_type, rq->errors);
+	debug_log("sector: %ld, nr_sectors: %ld, "
 			"current_nr_sectors: %d\n", (long)rq->sector,
 			rq->nr_sectors, rq->current_nr_sectors);
 
 	if (rq->errors >= ERROR_MAX) {
-		if (floppy->failed_pc != NULL) {
-			if (idefloppy_should_report_error(floppy))
-				printk(KERN_ERR "ide-floppy: %s: I/O error, pc = %2x,"
-				       " key = %2x, asc = %2x, ascq = %2x\n",
-				       drive->name, floppy->failed_pc->c[0],
-				       floppy->sense_key, floppy->asc, floppy->ascq);
-		}
+		if (floppy->failed_pc)
+			ide_floppy_report_error(floppy, floppy->failed_pc);
 		else
 			printk(KERN_ERR "ide-floppy: %s: I/O error\n",
 				drive->name);
@@ -1209,8 +930,8 @@ static ide_startstop_t idefloppy_do_request (ide_drive_t *drive, struct request
 	if (blk_fs_request(rq)) {
 		if (((long)rq->sector % floppy->bs_factor) ||
 		    (rq->nr_sectors % floppy->bs_factor)) {
-			printk("%s: unsupported r/w request size\n",
-				drive->name);
+			printk(KERN_ERR "%s: unsupported r/w request size\n",
+					drive->name);
 			idefloppy_do_end_request(drive, 0, 0);
 			return ide_stopped;
 		}
@@ -1233,15 +954,15 @@ static ide_startstop_t idefloppy_do_request (ide_drive_t *drive, struct request
 }
 
 /*
- *	idefloppy_queue_pc_tail adds a special packet command request to the
- *	tail of the request queue, and waits for it to be serviced.
+ * Add a special packet command request to the tail of the request queue,
+ * and wait for it to be serviced.
  */
-static int idefloppy_queue_pc_tail (ide_drive_t *drive,idefloppy_pc_t *pc)
+static int idefloppy_queue_pc_tail(ide_drive_t *drive, idefloppy_pc_t *pc)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 	struct request rq;
 
-	ide_init_drive_cmd (&rq);
+	ide_init_drive_cmd(&rq);
 	rq.buffer = (char *) pc;
 	rq.cmd_type = REQ_TYPE_SPECIAL;
 	rq.rq_disk = floppy->disk;
@@ -1250,88 +971,90 @@ static int idefloppy_queue_pc_tail (ide_drive_t *drive,idefloppy_pc_t *pc)
 }
 
 /*
- *	Look at the flexible disk page parameters. We will ignore the CHS
- *	capacity parameters and use the LBA parameters instead.
+ * Look at the flexible disk page parameters. We ignore the CHS capacity
+ * parameters and use the LBA parameters instead.
  */
-static int idefloppy_get_flexible_disk_page (ide_drive_t *drive)
+static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_mode_parameter_header_t *header;
-	idefloppy_flexible_disk_page_t *page;
+	u8 *page;
 	int capacity, lba_capacity;
+	u16 transfer_rate, sector_size, cyls, rpm;
+	u8 heads, sectors;
+
+	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE,
+					MODE_SENSE_CURRENT);
 
-	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE, MODE_SENSE_CURRENT);
-	if (idefloppy_queue_pc_tail(drive,&pc)) {
-		printk(KERN_ERR "ide-floppy: Can't get flexible disk "
-			"page parameters\n");
+	if (idefloppy_queue_pc_tail(drive, &pc)) {
+		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
+				" parameters\n");
 		return 1;
 	}
-	header = (idefloppy_mode_parameter_header_t *) pc.buffer;
-	floppy->wp = header->wp;
+	floppy->wp = !!(pc.buffer[3] & 0x80);
 	set_disk_ro(floppy->disk, floppy->wp);
-	page = (idefloppy_flexible_disk_page_t *) (header + 1);
-
-	page->transfer_rate = ntohs(page->transfer_rate);
-	page->sector_size = ntohs(page->sector_size);
-	page->cyls = ntohs(page->cyls);
-	page->rpm = ntohs(page->rpm);
-	capacity = page->cyls * page->heads * page->sectors * page->sector_size;
-	if (memcmp (page, &floppy->flexible_disk_page, sizeof (idefloppy_flexible_disk_page_t)))
+	page = &pc.buffer[8];
+
+	transfer_rate = be16_to_cpu(*(u16 *)&pc.buffer[8 + 2]);
+	sector_size   = be16_to_cpu(*(u16 *)&pc.buffer[8 + 6]);
+	cyls          = be16_to_cpu(*(u16 *)&pc.buffer[8 + 8]);
+	rpm           = be16_to_cpu(*(u16 *)&pc.buffer[8 + 28]);
+	heads         = pc.buffer[8 + 4];
+	sectors       = pc.buffer[8 + 5];
+
+	capacity = cyls * heads * sectors * sector_size;
+
+	if (memcmp(page, &floppy->flexible_disk_page, 32))
 		printk(KERN_INFO "%s: %dkB, %d/%d/%d CHS, %d kBps, "
 				"%d sector size, %d rpm\n",
-			drive->name, capacity / 1024, page->cyls,
-			page->heads, page->sectors,
-			page->transfer_rate / 8, page->sector_size, page->rpm);
-
-	floppy->flexible_disk_page = *page;
-	drive->bios_cyl = page->cyls;
-	drive->bios_head = page->heads;
-	drive->bios_sect = page->sectors;
+				drive->name, capacity / 1024, cyls, heads,
+				sectors, transfer_rate / 8, sector_size, rpm);
+
+	memcpy(&floppy->flexible_disk_page, page, 32);
+	drive->bios_cyl = cyls;
+	drive->bios_head = heads;
+	drive->bios_sect = sectors;
 	lba_capacity = floppy->blocks * floppy->block_size;
+
 	if (capacity < lba_capacity) {
 		printk(KERN_NOTICE "%s: The disk reports a capacity of %d "
 			"bytes, but the drive only handles %d\n",
 			drive->name, lba_capacity, capacity);
-		floppy->blocks = floppy->block_size ? capacity / floppy->block_size : 0;
+		floppy->blocks = floppy->block_size ?
+			capacity / floppy->block_size : 0;
 	}
 	return 0;
 }
 
-static int idefloppy_get_capability_page(ide_drive_t *drive)
+static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_mode_parameter_header_t *header;
-	idefloppy_capabilities_page_t *page;
 
 	floppy->srfp = 0;
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE,
 						 MODE_SENSE_CURRENT);
 
-	set_bit(PC_SUPPRESS_ERROR, &pc.flags);
-	if (idefloppy_queue_pc_tail(drive,&pc)) {
+	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
+	if (idefloppy_queue_pc_tail(drive, &pc))
 		return 1;
-	}
 
-	header = (idefloppy_mode_parameter_header_t *) pc.buffer;
-	page= (idefloppy_capabilities_page_t *)(header+1);
-	floppy->srfp = page->srfp;
+	floppy->srfp = pc.buffer[8 + 2] & 0x40;
 	return (0);
 }
 
 /*
- *	Determine if a media is present in the floppy drive, and if so,
- *	its LBA capacity.
+ * Determine if a media is present in the floppy drive, and if so, its LBA
+ * capacity.
  */
-static int idefloppy_get_capacity (ide_drive_t *drive)
+static int ide_floppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_capacity_header_t *header;
-	idefloppy_capacity_descriptor_t *descriptor;
-	int i, descriptors, rc = 1, blocks, length;
-	
+	u8 *cap_desc;
+	u8 header_len, desc_cnt;
+	int i, rc = 1, blocks, length;
+
 	drive->bios_cyl = 0;
 	drive->bios_head = drive->bios_sect = 0;
 	floppy->blocks = 0;
@@ -1343,44 +1066,55 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return 1;
 	}
-	header = (idefloppy_capacity_header_t *) pc.buffer;
-	descriptors = header->length / sizeof(idefloppy_capacity_descriptor_t);
-	descriptor = (idefloppy_capacity_descriptor_t *) (header + 1);
+	header_len = pc.buffer[3];
+	cap_desc = &pc.buffer[4];
+	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
+
+	for (i = 0; i < desc_cnt; i++) {
+		unsigned int desc_start = 4 + i*8;
+
+		blocks = be32_to_cpu(*(u32 *)&pc.buffer[desc_start]);
+		length = be16_to_cpu(*(u16 *)&pc.buffer[desc_start + 6]);
 
-	for (i = 0; i < descriptors; i++, descriptor++) {
-		blocks = descriptor->blocks = ntohl(descriptor->blocks);
-		length = descriptor->length = ntohs(descriptor->length);
+		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
+				i, blocks * length / 1024, blocks, length);
 
-		if (!i) 
-		{
-		switch (descriptor->dc) {
+		if (i)
+			continue;
+		/*
+		 * the code below is valid only for the 1st descriptor, ie i=0
+		 */
+
+		switch (pc.buffer[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
-			if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
-                                /*
+			if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE))
+				/*
 				 * If it is not a clik drive, break out
 				 * (maintains previous driver behaviour)
 				 */
 				break;
 		case CAPACITY_CURRENT:
 			/* Normal Zip/LS-120 disks */
-			if (memcmp(descriptor, &floppy->capacity, sizeof (idefloppy_capacity_descriptor_t)))
+			if (memcmp(cap_desc, &floppy->cap_desc, 8))
 				printk(KERN_INFO "%s: %dkB, %d blocks, %d "
 					"sector size\n", drive->name,
 					blocks * length / 1024, blocks, length);
-			floppy->capacity = *descriptor;
+			memcpy(&floppy->cap_desc, cap_desc, 8);
+
 			if (!length || length % 512) {
 				printk(KERN_NOTICE "%s: %d bytes block size "
 					"not supported\n", drive->name, length);
 			} else {
-                                floppy->blocks = blocks;
-                                floppy->block_size = length;
-                                if ((floppy->bs_factor = length / 512) != 1)
-                                        printk(KERN_NOTICE "%s: warning: non "
+				floppy->blocks = blocks;
+				floppy->block_size = length;
+				floppy->bs_factor = length / 512;
+				if (floppy->bs_factor != 1)
+					printk(KERN_NOTICE "%s: warning: non "
 						"512 bytes block size not "
 						"fully supported\n",
 						drive->name);
-                                rc = 0;
+				rc = 0;
 			}
 			break;
 		case CAPACITY_NO_CARTRIDGE:
@@ -1395,54 +1129,42 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 				"in drive\n", drive->name);
 			break;
 		}
-		}
-		if (!i) {
-			debug_log( "Descriptor 0 Code: %d\n",
-				descriptor->dc);
-		}
-		debug_log( "Descriptor %d: %dkB, %d blocks, %d "
-			"sector size\n", i, blocks * length / 1024, blocks,
-			length);
+		debug_log("Descriptor 0 Code: %d\n",
+			  pc.buffer[desc_start + 4] & 0x03);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
-        if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
-		(void) idefloppy_get_flexible_disk_page(drive);
-	}
+	if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE))
+		(void) ide_floppy_get_flexible_disk_page(drive);
 
 	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
 	return rc;
 }
 
 /*
-** Obtain the list of formattable capacities.
-** Very similar to idefloppy_get_capacity, except that we push the capacity
-** descriptors to userland, instead of our own structures.
-**
-** Userland gives us the following structure:
-**
-** struct idefloppy_format_capacities {
-**        int nformats;
-**        struct {
-**                int nblocks;
-**                int blocksize;
-**                } formats[];
-**        } ;
-**
-** userland initializes nformats to the number of allocated formats[]
-** records.  On exit we set nformats to the number of records we've
-** actually initialized.
-**
-*/
-
-static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
+ * Obtain the list of formattable capacities.
+ * Very similar to ide_floppy_get_capacity, except that we push the capacity
+ * descriptors to userland, instead of our own structures.
+ *
+ * Userland gives us the following structure:
+ *
+ * struct idefloppy_format_capacities {
+ *	int nformats;
+ *	struct {
+ *		int nblocks;
+ *		int blocksize;
+ *	} formats[];
+ * };
+ *
+ * userland initializes nformats to the number of allocated formats[] records.
+ * On exit we set nformats to the number of records we've actually initialized.
+ */
+
+static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 {
-        idefloppy_pc_t pc;
-	idefloppy_capacity_header_t *header;
-        idefloppy_capacity_descriptor_t *descriptor;
-	int i, descriptors, blocks, length;
-	int u_array_size;
-	int u_index;
+	idefloppy_pc_t pc;
+	u8 header_len, desc_cnt;
+	int i, blocks, length, u_array_size, u_index;
 	int __user *argp;
 
 	if (get_user(u_array_size, arg))
@@ -1454,30 +1176,27 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 	idefloppy_create_read_capacity_cmd(&pc);
 	if (idefloppy_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
-                return (-EIO);
-        }
-        header = (idefloppy_capacity_header_t *) pc.buffer;
-        descriptors = header->length /
-		sizeof(idefloppy_capacity_descriptor_t);
-	descriptor = (idefloppy_capacity_descriptor_t *) (header + 1);
+		return (-EIO);
+	}
+	header_len = pc.buffer[3];
+	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	u_index = 0;
 	argp = arg + 1;
 
 	/*
-	** We always skip the first capacity descriptor.  That's the
-	** current capacity.  We are interested in the remaining descriptors,
-	** the formattable capacities.
-	*/
+	 * We always skip the first capacity descriptor.  That's the current
+	 * capacity.  We are interested in the remaining descriptors, the
+	 * formattable capacities.
+	 */
+	for (i = 1; i < desc_cnt; i++) {
+		unsigned int desc_start = 4 + i*8;
 
-	for (i=0; i<descriptors; i++, descriptor++) {
 		if (u_index >= u_array_size)
 			break;	/* User-supplied buffer too small */
-		if (i == 0)
-			continue;	/* Skip the first descriptor */
 
-		blocks = ntohl(descriptor->blocks);
-		length = ntohs(descriptor->length);
+		blocks = be32_to_cpu(*(u32 *)&pc.buffer[desc_start]);
+		length = be16_to_cpu(*(u16 *)&pc.buffer[desc_start + 6]);
 
 		if (put_user(blocks, argp))
 			return(-EFAULT);
@@ -1496,53 +1215,14 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 }
 
 /*
-** Send ATAPI_FORMAT_UNIT to the drive.
-**
-** Userland gives us the following structure:
-**
-** struct idefloppy_format_command {
-**        int nblocks;
-**        int blocksize;
-**        int flags;
-**        } ;
-**
-** flags is a bitmask, currently, the only defined flag is:
-**
-**        0x01 - verify media after format.
-*/
-
-static int idefloppy_begin_format(ide_drive_t *drive, int __user *arg)
-{
-	int blocks;
-	int length;
-	int flags;
-	idefloppy_pc_t pc;
-
-	if (get_user(blocks, arg) ||
-	    get_user(length, arg+1) ||
-	    get_user(flags, arg+2)) {
-		return (-EFAULT);
-	}
-
-	/* Get the SFRP bit */
-	(void) idefloppy_get_capability_page(drive);
-	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
-                return (-EIO);
-	}
-
-	return (0);
-}
-
-/*
-** Get ATAPI_FORMAT_UNIT progress indication.
-**
-** Userland gives a pointer to an int.  The int is set to a progress
-** indicator 0-65536, with 65536=100%.
-**
-** If the drive does not support format progress indication, we just check
-** the dsc bit, and return either 0 or 65536.
-*/
+ * Get ATAPI_FORMAT_UNIT progress indication.
+ *
+ * Userland gives a pointer to an int.  The int is set to a progress
+ * indicator 0-65536, with 65536=100%.
+ *
+ * If the drive does not support format progress indication, we just check
+ * the dsc bit, and return either 0 or 65536.
+ */
 
 static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 {
@@ -1552,17 +1232,15 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 
 	if (floppy->srfp) {
 		idefloppy_create_request_sense_cmd(&pc);
-		if (idefloppy_queue_pc_tail(drive, &pc)) {
+		if (idefloppy_queue_pc_tail(drive, &pc))
 			return (-EIO);
-		}
 
 		if (floppy->sense_key == 2 &&
 		    floppy->asc == 4 &&
-		    floppy->ascq == 4) {
+		    floppy->ascq == 4)
 			progress_indication = floppy->progress_indication;
-		}
-		/* Else assume format_unit has finished, and we're
-		** at 0x10000 */
+
+		/* Else assume format_unit has finished, and we're at 0x10000 */
 	} else {
 		unsigned long flags;
 		u8 stat;
@@ -1579,10 +1257,7 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 	return (0);
 }
 
-/*
- *	Return the current floppy capacity.
- */
-static sector_t idefloppy_capacity (ide_drive_t *drive)
+static sector_t idefloppy_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	unsigned long capacity = floppy->blocks * floppy->bs_factor;
@@ -1591,15 +1266,12 @@ static sector_t idefloppy_capacity (ide_drive_t *drive)
 }
 
 /*
- *	idefloppy_identify_device checks if we can support a drive,
- *	based on the ATAPI IDENTIFY command results.
+ * Check whether we can support a drive, based on the ATAPI IDENTIFY command
+ * results.
  */
-static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
+static int idefloppy_identify_device(ide_drive_t *drive, struct hd_driveid *id)
 {
 	struct idefloppy_id_gcw gcw;
-#if IDEFLOPPY_DEBUG_INFO
-	char buffer[80];
-#endif /* IDEFLOPPY_DEBUG_INFO */
 
 	*((u16 *) &gcw) = id->config;
 
@@ -1608,54 +1280,23 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 	if ((gcw.device_type == 5) &&
 	    !strstr(id->model, "CD-ROM") &&
 	    strstr(id->model, "ZIP"))
-		gcw.device_type = 0;			
+		gcw.device_type = 0;
 #endif
 
-#if IDEFLOPPY_DEBUG_INFO
-	printk(KERN_INFO "Dumping ATAPI Identify Device floppy parameters\n");
-	switch (gcw.protocol) {
-		case 0: case 1: sprintf(buffer, "ATA");break;
-		case 2:	sprintf(buffer, "ATAPI");break;
-		case 3: sprintf(buffer, "Reserved (Unknown to ide-floppy)");break;
-	}
-	printk(KERN_INFO "Protocol Type: %s\n", buffer);
-	switch (gcw.device_type) {
-		case 0: sprintf(buffer, "Direct-access Device");break;
-		case 1: sprintf(buffer, "Streaming Tape Device");break;
-		case 2: case 3: case 4: sprintf (buffer, "Reserved");break;
-		case 5: sprintf(buffer, "CD-ROM Device");break;
-		case 6: sprintf(buffer, "Reserved");
-		case 7: sprintf(buffer, "Optical memory Device");break;
-		case 0x1f: sprintf(buffer, "Unknown or no Device type");break;
-		default: sprintf(buffer, "Reserved");
-	}
-	printk(KERN_INFO "Device Type: %x - %s\n", gcw.device_type, buffer);
-	printk(KERN_INFO "Removable: %s\n",gcw.removable ? "Yes":"No");	
-	switch (gcw.drq_type) {
-		case 0: sprintf(buffer, "Microprocessor DRQ");break;
-		case 1: sprintf(buffer, "Interrupt DRQ");break;
-		case 2: sprintf(buffer, "Accelerated DRQ");break;
-		case 3: sprintf(buffer, "Reserved");break;
-	}
-	printk(KERN_INFO "Command Packet DRQ Type: %s\n", buffer);
-	switch (gcw.packet_size) {
-		case 0: sprintf(buffer, "12 bytes");break;
-		case 1: sprintf(buffer, "16 bytes");break;
-		default: sprintf(buffer, "Reserved");break;
-	}
-	printk(KERN_INFO "Command Packet Size: %s\n", buffer);
-#endif /* IDEFLOPPY_DEBUG_INFO */
-
 	if (gcw.protocol != 2)
-		printk(KERN_ERR "ide-floppy: Protocol is not ATAPI\n");
+		printk(KERN_ERR "ide-floppy: Protocol (0x%02x) is not ATAPI\n",
+				gcw.protocol);
 	else if (gcw.device_type != 0)
-		printk(KERN_ERR "ide-floppy: Device type is not set to floppy\n");
+		printk(KERN_ERR "ide-floppy: Device type (0x%02x) is not set "
+				"to floppy\n", gcw.device_type);
 	else if (!gcw.removable)
 		printk(KERN_ERR "ide-floppy: The removable flag is not set\n");
 	else if (gcw.drq_type == 3) {
-		printk(KERN_ERR "ide-floppy: Sorry, DRQ type %d not supported\n", gcw.drq_type);
+		printk(KERN_ERR "ide-floppy: Sorry, DRQ type (0x%02x) not "
+				"supported\n", gcw.drq_type);
 	} else if (gcw.packet_size != 0) {
-		printk(KERN_ERR "ide-floppy: Packet size is not 12 bytes long\n");
+		printk(KERN_ERR "ide-floppy: Packet size (0x%02x) is not 12 "
+				"bytes long\n", gcw.packet_size);
 	} else
 		return 1;
 	return 0;
@@ -1666,59 +1307,53 @@ static void idefloppy_add_settings(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
-/*
- *			drive	setting name	read/write	data type	min	max	mul_factor	div_factor	data pointer		set function
- */
-	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	TYPE_INT,	0,	1023,		1,		1,	&drive->bios_cyl,	NULL);
-	ide_add_setting(drive,	"bios_head",	SETTING_RW,	TYPE_BYTE,	0,	255,		1,		1,	&drive->bios_head,	NULL);
-	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	TYPE_BYTE,	0,	63,		1,		1,	&drive->bios_sect,	NULL);
-	ide_add_setting(drive,	"ticks",	SETTING_RW,	TYPE_BYTE,	0,	255,		1,		1,	&floppy->ticks,		NULL);
+	ide_add_setting(drive, "bios_cyl", SETTING_RW, TYPE_INT, 0, 1023, 1, 1,
+			&drive->bios_cyl, NULL);
+	ide_add_setting(drive, "bios_head", SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
+			&drive->bios_head, NULL);
+	ide_add_setting(drive, "bios_sect", SETTING_RW,	TYPE_BYTE, 0,  63, 1, 1,
+			&drive->bios_sect, NULL);
+	ide_add_setting(drive, "ticks",	   SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
+			&floppy->ticks,	 NULL);
 }
 #else
 static inline void idefloppy_add_settings(ide_drive_t *drive) { ; }
 #endif
 
-/*
- *	Driver initialization.
- */
-static void idefloppy_setup (ide_drive_t *drive, idefloppy_floppy_t *floppy)
+static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 {
 	struct idefloppy_id_gcw gcw;
 
 	*((u16 *) &gcw) = drive->id->config;
 	floppy->pc = floppy->pc_stack;
 	if (gcw.drq_type == 1)
-		set_bit(IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags);
+		floppy->flags |= IDEFLOPPY_FLAG_DRQ_INTERRUPT;
 	/*
-	 *	We used to check revisions here. At this point however
-	 *	I'm giving up. Just assume they are all broken, its easier.
+	 * We used to check revisions here. At this point however I'm giving up.
+	 * Just assume they are all broken, its easier.
 	 *
-	 *	The actual reason for the workarounds was likely
-	 *	a driver bug after all rather than a firmware bug,
-	 *	and the workaround below used to hide it. It should
-	 *	be fixed as of version 1.9, but to be on the safe side
-	 *	we'll leave the limitation below for the 2.2.x tree.
+	 * The actual reason for the workarounds was likely a driver bug after
+	 * all rather than a firmware bug, and the workaround below used to hide
+	 * it. It should be fixed as of version 1.9, but to be on the safe side
+	 * we'll leave the limitation below for the 2.2.x tree.
 	 */
-
 	if (!strncmp(drive->id->model, "IOMEGA ZIP 100 ATAPI", 20)) {
-		set_bit(IDEFLOPPY_ZIP_DRIVE, &floppy->flags);
+		floppy->flags |= IDEFLOPPY_FLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		floppy->ticks = IDEFLOPPY_TICKS_DELAY;
 		blk_queue_max_sectors(drive->queue, 64);
 	}
 
 	/*
-	*      Guess what?  The IOMEGA Clik! drive also needs the
-	*      above fix.  It makes nasty clicking noises without
-	*      it, so please don't remove this.
-	*/
+	 * Guess what? The IOMEGA Clik! drive also needs the above fix. It makes
+	 * nasty clicking noises without it, so please don't remove this.
+	 */
 	if (strncmp(drive->id->model, "IOMEGA Clik!", 11) == 0) {
 		blk_queue_max_sectors(drive->queue, 64);
-		set_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags);
+		floppy->flags |= IDEFLOPPY_FLAG_CLIK_DRIVE;
 	}
 
-
-	(void) idefloppy_get_capacity(drive);
+	(void) ide_floppy_get_capacity(drive);
 	idefloppy_add_settings(drive);
 }
 
@@ -1734,7 +1369,7 @@ static void ide_floppy_remove(ide_drive_t *drive)
 	ide_floppy_put(floppy);
 }
 
-static void ide_floppy_release(struct kref *kref)
+static void idefloppy_cleanup_obj(struct kref *kref)
 {
 	struct ide_floppy_obj *floppy = to_ide_floppy(kref);
 	ide_drive_t *drive = floppy->drive;
@@ -1747,19 +1382,19 @@ static void ide_floppy_release(struct kref *kref)
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static int proc_idefloppy_read_capacity
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
+static int proc_idefloppy_read_capacity(char *page, char **start, off_t off,
+		int count, int *eof, void *data)
 {
 	ide_drive_t*drive = (ide_drive_t *)data;
 	int len;
 
-	len = sprintf(page,"%llu\n", (long long)idefloppy_capacity(drive));
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	len = sprintf(page, "%llu\n", (long long)idefloppy_capacity(drive));
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static ide_proc_entry_t idefloppy_proc[] = {
-	{ "capacity",	S_IFREG|S_IRUGO,	proc_idefloppy_read_capacity, NULL },
-	{ "geometry",	S_IFREG|S_IRUGO,	proc_ide_read_geometry,	NULL },
+	{ "capacity",	S_IFREG|S_IRUGO, proc_idefloppy_read_capacity,	NULL },
+	{ "geometry",	S_IFREG|S_IRUGO, proc_ide_read_geometry,	NULL },
 	{ NULL, 0, NULL, NULL }
 };
 #endif	/* CONFIG_IDE_PROC_FS */
@@ -1794,9 +1429,10 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	idefloppy_pc_t pc;
 	int ret = 0;
 
-	debug_log(KERN_INFO "Reached idefloppy_open\n");
+	debug_log("Reached %s\n", __func__);
 
-	if (!(floppy = ide_floppy_get(disk)))
+	floppy = ide_floppy_get(disk);
+	if (!floppy)
 		return -ENXIO;
 
 	drive = floppy->drive;
@@ -1804,7 +1440,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	floppy->openers++;
 
 	if (floppy->openers == 1) {
-		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
 		idefloppy_create_test_unit_ready_cmd(&pc);
@@ -1813,13 +1449,13 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 
-		if (idefloppy_get_capacity (drive)
+		if (ide_floppy_get_capacity(drive)
 		   && (filp->f_flags & O_NDELAY) == 0
 		    /*
-		    ** Allow O_NDELAY to open a drive without a disk, or with
-		    ** an unreadable disk, so that we can get the format
-		    ** capacity of the drive or begin the format - Sam
-		    */
+		     * Allow O_NDELAY to open a drive without a disk, or with an
+		     * unreadable disk, so that we can get the format capacity
+		     * of the drive or begin the format - Sam
+		     */
 		    ) {
 			ret = -EIO;
 			goto out_put_floppy;
@@ -1829,14 +1465,14 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 			ret = -EROFS;
 			goto out_put_floppy;
 		}
-		set_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
+		floppy->flags |= IDEFLOPPY_FLAG_MEDIA_CHANGED;
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
 			idefloppy_create_prevent_cmd(&pc, 1);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 		check_disk_change(inode->i_bdev);
-	} else if (test_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags)) {
+	} else if (floppy->flags & IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS) {
 		ret = -EBUSY;
 		goto out_put_floppy;
 	}
@@ -1854,17 +1490,17 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
 	idefloppy_pc_t pc;
-	
-	debug_log(KERN_INFO "Reached idefloppy_release\n");
+
+	debug_log("Reached %s\n", __func__);
 
 	if (floppy->openers == 1) {
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
 			idefloppy_create_prevent_cmd(&pc, 0);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 
-		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
 	}
 
 	floppy->openers--;
@@ -1885,64 +1521,105 @@ static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
+static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc,
+			       unsigned long arg, unsigned int cmd)
+{
+	if (floppy->openers > 1)
+		return -EBUSY;
+
+	/* The IOMEGA Clik! Drive doesn't support this command -
+	 * no room for an eject mechanism */
+	if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
+		int prevent = arg ? 1 : 0;
+
+		if (cmd == CDROMEJECT)
+			prevent = 0;
+
+		idefloppy_create_prevent_cmd(pc, prevent);
+		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
+	}
+
+	if (cmd == CDROMEJECT) {
+		idefloppy_create_start_stop_cmd(pc, 2);
+		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
+	}
+
+	return 0;
+}
+
+static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
+				  int __user *arg)
+{
+	int blocks, length, flags, err = 0;
+	idefloppy_pc_t pc;
+
+	if (floppy->openers > 1) {
+		/* Don't format if someone is using the disk */
+		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+		return -EBUSY;
+	}
+
+	floppy->flags |= IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+
+	/*
+	 * Send ATAPI_FORMAT_UNIT to the drive.
+	 *
+	 * Userland gives us the following structure:
+	 *
+	 * struct idefloppy_format_command {
+	 *        int nblocks;
+	 *        int blocksize;
+	 *        int flags;
+	 *        } ;
+	 *
+	 * flags is a bitmask, currently, the only defined flag is:
+	 *
+	 *        0x01 - verify media after format.
+	 */
+	if (get_user(blocks, arg) ||
+			get_user(length, arg+1) ||
+			get_user(flags, arg+2)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	(void) idefloppy_get_sfrp_bit(floppy->drive);
+	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
+
+	if (idefloppy_queue_pc_tail(floppy->drive, &pc))
+		err = -EIO;
+
+out:
+	if (err)
+		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+	return err;
+}
+
+
 static int idefloppy_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
 	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
 	ide_drive_t *drive = floppy->drive;
+	idefloppy_pc_t pc;
 	void __user *argp = (void __user *)arg;
 	int err;
-	int prevent = (arg) ? 1 : 0;
-	idefloppy_pc_t pc;
 
 	switch (cmd) {
 	case CDROMEJECT:
-		prevent = 0;
 		/* fall through */
 	case CDROM_LOCKDOOR:
-		if (floppy->openers > 1)
-			return -EBUSY;
-
-		/* The IOMEGA Clik! Drive doesn't support this command - no room for an eject mechanism */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
-			idefloppy_create_prevent_cmd(&pc, prevent);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
-		if (cmd == CDROMEJECT) {
-			idefloppy_create_start_stop_cmd(&pc, 2);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
-		return 0;
+		return ide_floppy_lockdoor(floppy, &pc, arg, cmd);
 	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
 		return 0;
 	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
-		return idefloppy_get_format_capacities(drive, argp);
+		return ide_floppy_get_format_capacities(drive, argp);
 	case IDEFLOPPY_IOCTL_FORMAT_START:
-
 		if (!(file->f_mode & 2))
 			return -EPERM;
 
-		if (floppy->openers > 1) {
-			/* Don't format if someone is using the disk */
-
-			clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS,
-				  &floppy->flags);
-			return -EBUSY;
-		}
-
-		set_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
-
-		err = idefloppy_begin_format(drive, argp);
-		if (err)
-			clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
-		return err;
-		/*
-		** Note, the bit will be cleared when the device is
-		** closed.  This is the cleanest way to handle the
-		** situation where the drive does not support
-		** format progress reporting.
-		*/
+		return ide_floppy_format_unit(floppy, (int __user *)arg);
 	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
 		return idefloppy_get_format_progress(drive, argp);
 	}
@@ -1967,13 +1644,16 @@ static int idefloppy_media_changed(struct gendisk *disk)
 {
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
+	int ret;
 
 	/* do not scan partitions twice if this is a removable device */
 	if (drive->attach) {
 		drive->attach = 0;
 		return 0;
 	}
-	return test_and_clear_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
+	ret = !!(floppy->flags & IDEFLOPPY_FLAG_MEDIA_CHANGED);
+	floppy->flags &= ~IDEFLOPPY_FLAG_MEDIA_CHANGED;
+	return ret;
 }
 
 static int idefloppy_revalidate_disk(struct gendisk *disk)
@@ -2004,16 +1684,20 @@ static int ide_floppy_probe(ide_drive_t *drive)
 		goto failed;
 	if (drive->media != ide_floppy)
 		goto failed;
-	if (!idefloppy_identify_device (drive, drive->id)) {
-		printk (KERN_ERR "ide-floppy: %s: not supported by this version of ide-floppy\n", drive->name);
+	if (!idefloppy_identify_device(drive, drive->id)) {
+		printk(KERN_ERR "ide-floppy: %s: not supported by this version"
+				" of ide-floppy\n", drive->name);
 		goto failed;
 	}
 	if (drive->scsi) {
-		printk("ide-floppy: passing drive %s to ide-scsi emulation.\n", drive->name);
+		printk(KERN_INFO "ide-floppy: passing drive %s to ide-scsi"
+				" emulation.\n", drive->name);
 		goto failed;
 	}
-	if ((floppy = kzalloc(sizeof (idefloppy_floppy_t), GFP_KERNEL)) == NULL) {
-		printk (KERN_ERR "ide-floppy: %s: Can't allocate a floppy structure\n", drive->name);
+	floppy = kzalloc(sizeof(idefloppy_floppy_t), GFP_KERNEL);
+	if (!floppy) {
+		printk(KERN_ERR "ide-floppy: %s: Can't allocate a floppy"
+				" structure\n", drive->name);
 		goto failed;
 	}
 
@@ -2035,7 +1719,7 @@ static int ide_floppy_probe(ide_drive_t *drive)
 
 	drive->driver_data = floppy;
 
-	idefloppy_setup (drive, floppy);
+	idefloppy_setup(drive, floppy);
 
 	g->minors = 1 << PARTN_BITS;
 	g->driverfs_dev = &drive->gendev;
@@ -2051,9 +1735,7 @@ failed:
 	return -ENODEV;
 }
 
-MODULE_DESCRIPTION("ATAPI FLOPPY Driver");
-
-static void __exit idefloppy_exit (void)
+static void __exit idefloppy_exit(void)
 {
 	driver_unregister(&idefloppy_driver.gen_driver);
 }
@@ -2068,3 +1750,5 @@ MODULE_ALIAS("ide:*m-floppy*");
 module_init(idefloppy_init);
 module_exit(idefloppy_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ATAPI FLOPPY Driver");
+
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index bb30c29..be469db 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -23,7 +23,7 @@ static int __init ide_generic_init(void)
 	for (i = 0; i < MAX_HWIFS; i++)
 		idx[i] = ide_hwifs[i].present ? 0xff : i;
 
-	ide_device_add_all(idx);
+	ide_device_add_all(idx, NULL);
 
 	if (ide_hwifs[0].io_ports[IDE_DATA_OFFSET])
 		ide_release_lock();	/* for atari only */
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 16b1f6e..a95178f 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -163,8 +163,6 @@ void SELECT_DRIVE (ide_drive_t *drive)
 	HWIF(drive)->OUTB(drive->select.all, IDE_SELECT_REG);
 }
 
-EXPORT_SYMBOL(SELECT_DRIVE);
-
 void SELECT_MASK (ide_drive_t *drive, int mask)
 {
 	if (HWIF(drive)->maskproc)
@@ -614,66 +612,6 @@ no_80w:
 	return 0;
 }
 
-int ide_ata66_check (ide_drive_t *drive, ide_task_t *args)
-{
-	if (args->tf.command == WIN_SETFEATURES &&
-	    args->tf.nsect > XFER_UDMA_2 &&
-	    args->tf.feature == SETFEATURES_XFER) {
-		if (eighty_ninty_three(drive) == 0) {
-			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
-					    "be set\n", drive->name);
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
-/*
- * Backside of HDIO_DRIVE_CMD call of SETFEATURES_XFER.
- * 1 : Safe to update drive->id DMA registers.
- * 0 : OOPs not allowed.
- */
-int set_transfer (ide_drive_t *drive, ide_task_t *args)
-{
-	if (args->tf.command == WIN_SETFEATURES &&
-	    args->tf.nsect >= XFER_SW_DMA_0 &&
-	    args->tf.feature == SETFEATURES_XFER &&
-	    (drive->id->dma_ultra ||
-	     drive->id->dma_mword ||
-	     drive->id->dma_1word))
-		return 1;
-
-	return 0;
-}
-
-#ifdef CONFIG_BLK_DEV_IDEDMA
-static u8 ide_auto_reduce_xfer (ide_drive_t *drive)
-{
-	if (!drive->crc_count)
-		return drive->current_speed;
-	drive->crc_count = 0;
-
-	switch(drive->current_speed) {
-		case XFER_UDMA_7:	return XFER_UDMA_6;
-		case XFER_UDMA_6:	return XFER_UDMA_5;
-		case XFER_UDMA_5:	return XFER_UDMA_4;
-		case XFER_UDMA_4:	return XFER_UDMA_3;
-		case XFER_UDMA_3:	return XFER_UDMA_2;
-		case XFER_UDMA_2:	return XFER_UDMA_1;
-		case XFER_UDMA_1:	return XFER_UDMA_0;
-			/*
-			 * OOPS we do not goto non Ultra DMA modes
-			 * without iCRC's available we force
-			 * the system to PIO and make the user
-			 * invoke the ATA-1 ATA-2 DMA modes.
-			 */
-		case XFER_UDMA_0:
-		default:		return XFER_PIO_4;
-	}
-}
-#endif /* CONFIG_BLK_DEV_IDEDMA */
-
 int ide_driveid_update(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -882,22 +820,17 @@ void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 	unsigned long flags;
 	ide_hwgroup_t *hwgroup = HWGROUP(drive);
 	ide_hwif_t *hwif = HWIF(drive);
-	
+
 	spin_lock_irqsave(&ide_lock, flags);
-	
 	BUG_ON(hwgroup->handler);
-	hwgroup->handler	= handler;
-	hwgroup->expiry		= expiry;
-	hwgroup->timer.expires	= jiffies + timeout;
-	hwgroup->req_gen_timer = hwgroup->req_gen;
-	add_timer(&hwgroup->timer);
+	__ide_set_handler(drive, handler, timeout, expiry);
 	hwif->OUTBSYNC(drive, cmd, IDE_COMMAND_REG);
-	/* Drive takes 400nS to respond, we must avoid the IRQ being
-	   serviced before that. 
-	   
-	   FIXME: we could skip this delay with care on non shared
-	   devices 
-	*/
+	/*
+	 * Drive takes 400nS to respond, we must avoid the IRQ being
+	 * serviced before that.
+	 *
+	 * FIXME: we could skip this delay with care on non shared devices
+	 */
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -1005,19 +938,6 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void check_dma_crc(ide_drive_t *drive)
-{
-#ifdef CONFIG_BLK_DEV_IDEDMA
-	if (drive->crc_count) {
-		ide_dma_off_quietly(drive);
-		ide_set_xfer_rate(drive, ide_auto_reduce_xfer(drive));
-		if (drive->current_speed >= XFER_SW_DMA_0)
-			ide_dma_on(drive);
-	} else
-		ide_dma_off(drive);
-#endif
-}
-
 static void ide_disk_pre_reset(ide_drive_t *drive)
 {
 	int legacy = (drive->id->cfs_enable_2 & 0x0400) ? 0 : 1;
@@ -1039,17 +959,20 @@ static void pre_reset(ide_drive_t *drive)
 	else
 		drive->post_reset = 1;
 
+	if (drive->using_dma) {
+		if (drive->crc_count)
+			ide_check_dma_crc(drive);
+		else
+			ide_dma_off(drive);
+	}
+
 	if (!drive->keep_settings) {
-		if (drive->using_dma) {
-			check_dma_crc(drive);
-		} else {
+		if (!drive->using_dma) {
 			drive->unmask = 0;
 			drive->io_32bit = 0;
 		}
 		return;
 	}
-	if (drive->using_dma)
-		check_dma_crc(drive);
 
 	if (HWIF(drive)->pre_reset != NULL)
 		HWIF(drive)->pre_reset(drive);
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 4bda5cf..b163b2e 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -49,7 +49,7 @@ static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id
 		printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
 		pnp_set_drvdata(dev,hwif);
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 
 		return 0;
 	}
@@ -60,9 +60,10 @@ static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id
 static void idepnp_remove(struct pnp_dev * dev)
 {
 	ide_hwif_t *hwif = pnp_get_drvdata(dev);
-	if (hwif) {
-		ide_unregister(hwif->index);
-	} else
+
+	if (hwif)
+		ide_unregister(hwif->index, 0, 0);
+	else
 		printk(KERN_ERR "idepnp: Unable to remove device, please report.\n");
 }
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 98a8af4..9c07bdb 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -423,8 +423,9 @@ static int ide_busy_sleep(ide_hwif_t *hwif)
 
 static int do_probe (ide_drive_t *drive, u8 cmd)
 {
-	int rc;
 	ide_hwif_t *hwif = HWIF(drive);
+	int rc;
+	u8 stat;
 
 	if (drive->present) {
 		/* avoid waiting for inappropriate probes */
@@ -461,15 +462,17 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			/* failed: try again */
 			rc = try_to_identify(drive,cmd);
 		}
-		if (hwif->INB(IDE_STATUS_REG) == (BUSY_STAT|READY_STAT))
+
+		stat = hwif->INB(IDE_STATUS_REG);
+
+		if (stat == (BUSY_STAT | READY_STAT))
 			return 4;
 
 		if ((rc == 1 && cmd == WIN_PIDENTIFY) &&
 			((drive->autotune == IDE_TUNE_DEFAULT) ||
 			(drive->autotune == IDE_TUNE_AUTO))) {
-			printk("%s: no response (status = 0x%02x), "
-				"resetting drive\n", drive->name,
-				hwif->INB(IDE_STATUS_REG));
+			printk(KERN_ERR "%s: no response (status = 0x%02x), "
+					"resetting drive\n", drive->name, stat);
 			msleep(50);
 			hwif->OUTB(drive->select.all, IDE_SELECT_REG);
 			msleep(50);
@@ -477,11 +480,13 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
+
+		/* ensure drive IRQ is clear */
+		stat = hwif->INB(IDE_STATUS_REG);
+
 		if (rc == 1)
-			printk("%s: no response (status = 0x%02x)\n",
-				drive->name, hwif->INB(IDE_STATUS_REG));
-		/* ensure drive irq is clear */
-		(void) hwif->INB(IDE_STATUS_REG);
+			printk(KERN_ERR "%s: no response (status = 0x%02x)\n",
+					drive->name, stat);
 	} else {
 		/* not present or maybe ATAPI */
 		rc = 3;
@@ -502,6 +507,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 static void enable_nest (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	u8 stat;
 
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
@@ -515,11 +521,12 @@ static void enable_nest (ide_drive_t *drive)
 
 	msleep(50);
 
-	if (!OK_STAT((hwif->INB(IDE_STATUS_REG)), 0, BAD_STAT)) {
-		printk("failed (status = 0x%02x)\n", hwif->INB(IDE_STATUS_REG));
-	} else {
-		printk("success\n");
-	}
+	stat = hwif->INB(IDE_STATUS_REG);
+
+	if (!OK_STAT(stat, 0, BAD_STAT))
+		printk(KERN_CONT "failed (status = 0x%02x)\n", stat);
+	else
+		printk(KERN_CONT "success\n");
 
 	/* if !(success||timed-out) */
 	if (do_probe(drive, WIN_IDENTIFY) >= 2) {
@@ -822,7 +829,7 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
-		if (hwif->no_io_32bit)
+		if (hwif->host_flags & IDE_HFLAG_NO_IO_32BIT)
 			drive->no_io_32bit = 1;
 		else
 			drive->no_io_32bit = drive->id->dword_io ? 1 : 0;
@@ -881,13 +888,6 @@ static int ide_init_queue(ide_drive_t *drive)
 	q->queuedata = drive;
 	blk_queue_segment_boundary(q, 0xffff);
 
-	if (!hwif->rqsize) {
-		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
-		    (hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA))
-			hwif->rqsize = 256;
-		else
-			hwif->rqsize = 65536;
-	}
 	if (hwif->rqsize < max_sectors)
 		max_sectors = hwif->rqsize;
 	blk_queue_max_sectors(q, max_sectors);
@@ -918,6 +918,48 @@ static int ide_init_queue(ide_drive_t *drive)
 	return 0;
 }
 
+static void ide_add_drive_to_hwgroup(ide_drive_t *drive)
+{
+	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+
+	spin_lock_irq(&ide_lock);
+	if (!hwgroup->drive) {
+		/* first drive for hwgroup. */
+		drive->next = drive;
+		hwgroup->drive = drive;
+		hwgroup->hwif = HWIF(hwgroup->drive);
+	} else {
+		drive->next = hwgroup->drive->next;
+		hwgroup->drive->next = drive;
+	}
+	spin_unlock_irq(&ide_lock);
+}
+
+/*
+ * For any present drive:
+ * - allocate the block device queue
+ * - link drive into the hwgroup
+ */
+static void ide_port_setup_devices(ide_hwif_t *hwif)
+{
+	int i;
+
+	for (i = 0; i < MAX_DRIVES; i++) {
+		ide_drive_t *drive = &hwif->drives[i];
+
+		if (!drive->present)
+			continue;
+
+		if (ide_init_queue(drive)) {
+			printk(KERN_ERR "ide: failed to init %s\n",
+					drive->name);
+			continue;
+		}
+
+		ide_add_drive_to_hwgroup(drive);
+	}
+}
+
 /*
  * This routine sets up the irq for an ide interface, and creates a new
  * hwgroup for the irq/hwif if none was previously assigned.
@@ -1019,30 +1061,12 @@ static int init_irq (ide_hwif_t *hwif)
 	       		goto out_unlink;
 	}
 
-	/*
-	 * For any present drive:
-	 * - allocate the block device queue
-	 * - link drive into the hwgroup
-	 */
-	for (index = 0; index < MAX_DRIVES; ++index) {
-		ide_drive_t *drive = &hwif->drives[index];
-		if (!drive->present)
-			continue;
-		if (ide_init_queue(drive)) {
-			printk(KERN_ERR "ide: failed to init %s\n",drive->name);
-			continue;
-		}
-		spin_lock_irq(&ide_lock);
-		if (!hwgroup->drive) {
-			/* first drive for hwgroup. */
-			drive->next = drive;
-			hwgroup->drive = drive;
-			hwgroup->hwif = HWIF(hwgroup->drive);
-		} else {
-			drive->next = hwgroup->drive->next;
-			hwgroup->drive->next = drive;
-		}
-		spin_unlock_irq(&ide_lock);
+	if (!hwif->rqsize) {
+		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
+		    (hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA))
+			hwif->rqsize = 256;
+		else
+			hwif->rqsize = 65536;
 	}
 
 #if !defined(__mc68000__) && !defined(CONFIG_APUS)
@@ -1058,6 +1082,9 @@ static int init_irq (ide_hwif_t *hwif)
 		printk(" (%sed with %s)",
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
 	printk("\n");
+
+	ide_port_setup_devices(hwif);
+
 	mutex_unlock(&ide_cfg_mtx);
 	return 0;
 out_unlink:
@@ -1182,30 +1209,6 @@ static void drive_release_dev (struct device *dev)
 	complete(&drive->gendev_rel_comp);
 }
 
-/*
- * init_gendisk() (as opposed to ide_geninit) is called for each major device,
- * after probing for drives, to allocate partition tables and other data
- * structures needed for the routines in genhd.c.  ide_geninit() gets called
- * somewhat later, during the partition check.
- */
-static void init_gendisk (ide_hwif_t *hwif)
-{
-	unsigned int unit;
-
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t * drive = &hwif->drives[unit];
-		ide_add_generic_settings(drive);
-		snprintf(drive->gendev.bus_id,BUS_ID_SIZE,"%u.%u",
-			 hwif->index,unit);
-		drive->gendev.parent = &hwif->gendev;
-		drive->gendev.bus = &ide_bus_type;
-		drive->gendev.driver_data = drive;
-		drive->gendev.release = drive_release_dev;
-	}
-	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
-			THIS_MODULE, ata_probe, ata_lock, hwif);
-}
-
 static int hwif_init(ide_hwif_t *hwif)
 {
 	int old_irq;
@@ -1262,8 +1265,8 @@ static int hwif_init(ide_hwif_t *hwif)
 		hwif->name, hwif->irq);
 
 done:
-	init_gendisk(hwif);
-	ide_acpi_init(hwif);
+	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
+			    THIS_MODULE, ata_probe, ata_lock, hwif);
 	return 1;
 
 out:
@@ -1277,24 +1280,119 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 
 	for (i = 0; i < MAX_DRIVES; i++) {
 		ide_drive_t *drive = &hwif->drives[i];
+		struct device *dev = &drive->gendev;
+		int ret;
 
-		if (drive->present) {
-			int ret = device_register(&drive->gendev);
+		if (!drive->present)
+			continue;
 
-			if (ret < 0)
-				printk(KERN_WARNING "IDE: %s: "
-					"device_register error: %d\n",
-					__FUNCTION__, ret);
-		}
+		ide_add_generic_settings(drive);
+
+		snprintf(dev->bus_id, BUS_ID_SIZE, "%u.%u", hwif->index, i);
+		dev->parent = &hwif->gendev;
+		dev->bus = &ide_bus_type;
+		dev->driver_data = drive;
+		dev->release = drive_release_dev;
+
+		ret = device_register(dev);
+		if (ret < 0)
+			printk(KERN_WARNING "IDE: %s: device_register error: "
+					    "%d\n", __func__, ret);
+	}
+}
+
+static void ide_port_init_devices(ide_hwif_t *hwif)
+{
+	int i;
+
+	for (i = 0; i < MAX_DRIVES; i++) {
+		ide_drive_t *drive = &hwif->drives[i];
+
+		if (hwif->host_flags & IDE_HFLAG_IO_32BIT)
+			drive->io_32bit = 1;
+		if (hwif->host_flags & IDE_HFLAG_UNMASK_IRQS)
+			drive->unmask = 1;
+		if (hwif->host_flags & IDE_HFLAG_NO_UNMASK_IRQS)
+			drive->no_unmask = 1;
+		if ((hwif->host_flags & IDE_HFLAG_NO_AUTOTUNE) == 0)
+			drive->autotune = 1;
+	}
+
+	if (hwif->port_init_devs)
+		hwif->port_init_devs(hwif);
+}
+
+static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
+			  const struct ide_port_info *d)
+{
+	if (d->chipset != ide_etrax100)
+		hwif->channel = port;
+
+	if (d->chipset)
+		hwif->chipset = d->chipset;
+
+	if (d->init_iops)
+		d->init_iops(hwif);
+
+	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0)
+		ide_hwif_setup_dma(hwif, d);
+
+	if ((!hwif->irq && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
+	    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS))
+		hwif->irq = port ? 15 : 14;
+
+	hwif->host_flags = d->host_flags;
+	hwif->pio_mask = d->pio_mask;
+
+	if ((d->host_flags & IDE_HFLAG_SERIALIZE) && hwif->mate)
+		hwif->mate->serialized = hwif->serialized = 1;
+
+	hwif->swdma_mask = d->swdma_mask;
+	hwif->mwdma_mask = d->mwdma_mask;
+	hwif->ultra_mask = d->udma_mask;
+
+	/* reset DMA masks only for SFF-style DMA controllers */
+	if ((d->host_flags && IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
+		hwif->swdma_mask = hwif->mwdma_mask = hwif->ultra_mask = 0;
+
+	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
+		hwif->rqsize = 256;
+
+	/* call chipset specific routine for each enabled port */
+	if (d->init_hwif)
+		d->init_hwif(hwif);
+
+	if (hwif->cable_detect && (hwif->ultra_mask & 0x78)) {
+		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+			hwif->cbl = hwif->cable_detect(hwif);
 	}
 }
 
-int ide_device_add_all(u8 *idx)
+int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 {
-	ide_hwif_t *hwif;
+	ide_hwif_t *hwif, *mate = NULL;
 	int i, rc = 0;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
+		if (d == NULL || idx[i] == 0xff) {
+			mate = NULL;
+			continue;
+		}
+
+		hwif = &ide_hwifs[idx[i]];
+
+		if (d->chipset != ide_etrax100 && (i & 1) && mate) {
+			hwif->mate = mate;
+			mate->mate = hwif;
+		}
+
+		mate = (i & 1) ? NULL : hwif;
+
+		ide_init_port(hwif, i & 1, d);
+		ide_port_init_devices(hwif);
+	}
+
+	for (i = 0; i < MAX_HWIFS; i++) {
 		if (idx[i] == 0xff)
 			continue;
 
@@ -1337,6 +1435,9 @@ int ide_device_add_all(u8 *idx)
 			rc = -1;
 			continue;
 		}
+
+		ide_acpi_init(hwif);
+		ide_acpi_port_init_devices(hwif);
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
@@ -1354,15 +1455,22 @@ int ide_device_add_all(u8 *idx)
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		if (idx[i] != 0xff)
-			ide_proc_register_port(&ide_hwifs[idx[i]]);
+		if (idx[i] == 0xff)
+			continue;
+
+		hwif = &ide_hwifs[idx[i]];
+
+		if (hwif->present) {
+			ide_proc_register_port(hwif);
+			ide_proc_port_register_devices(hwif);
+		}
 	}
 
 	return rc;
 }
 EXPORT_SYMBOL_GPL(ide_device_add_all);
 
-int ide_device_add(u8 idx[4])
+int ide_device_add(u8 idx[4], const struct ide_port_info *d)
 {
 	u8 idx_all[MAX_HWIFS];
 	int i;
@@ -1370,6 +1478,6 @@ int ide_device_add(u8 idx[4])
 	for (i = 0; i < MAX_HWIFS; i++)
 		idx_all[i] = (i < 4) ? idx[i] : 0xff;
 
-	return ide_device_add_all(idx_all);
+	return ide_device_add_all(idx_all, d);
 }
 EXPORT_SYMBOL_GPL(ide_device_add);
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 00c249c..975c0ff 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -739,7 +739,7 @@ void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
 
 EXPORT_SYMBOL(ide_proc_unregister_driver);
 
-static void create_proc_ide_drives(ide_hwif_t *hwif)
+void ide_proc_port_register_devices(ide_hwif_t *hwif)
 {
 	int	d;
 	struct proc_dir_entry *ent;
@@ -793,9 +793,6 @@ static ide_proc_entry_t hwif_entries[] = {
 
 void ide_proc_register_port(ide_hwif_t *hwif)
 {
-	if (!hwif->present)
-		return;
-
 	if (!hwif->proc) {
 		hwif->proc = proc_mkdir(hwif->name, proc_ide_root);
 
@@ -804,8 +801,6 @@ void ide_proc_register_port(ide_hwif_t *hwif)
 
 		ide_add_proc_entries(hwif->proc, hwif_entries, hwif);
 	}
-
-	create_proc_ide_drives(hwif);
 }
 
 #ifdef CONFIG_BLK_DEV_IDEPCI
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 5aef63a..bf40d8c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1,424 +1,18 @@
 /*
+ * IDE ATAPI streaming tape driver.
+ *
  * Copyright (C) 1995-1999  Gadi Oxman <gadio@netvision.net.il>
  * Copyright (C) 2003-2005  Bartlomiej Zolnierkiewicz
  *
- * $Header$
- *
  * This driver was constructed as a student project in the software laboratory
  * of the faculty of electrical engineering in the Technion - Israel's
  * Institute Of Technology, with the guide of Avner Lottem and Dr. Ilana David.
  *
  * It is hereby placed under the terms of the GNU general public license.
  * (See linux/COPYING).
- */
- 
-/*
- * IDE ATAPI streaming tape driver.
- *
- * This driver is a part of the Linux ide driver and works in co-operation
- * with linux/drivers/block/ide.c.
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
- * Run linux/scripts/MAKEDEV.ide to create the above entries.
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
- * Ver 0.1   Nov  1 95   Pre-working code :-)
- * Ver 0.2   Nov 23 95   A short backup (few megabytes) and restore procedure
- *                        was successful ! (Using tar cvf ... on the block
- *                        device interface).
- *                       A longer backup resulted in major swapping, bad
- *                        overall Linux performance and eventually failed as
- *                        we received non serial read-ahead requests from the
- *                        buffer cache.
- * Ver 0.3   Nov 28 95   Long backups are now possible, thanks to the
- *                        character device interface. Linux's responsiveness
- *                        and performance doesn't seem to be much affected
- *                        from the background backup procedure.
- *                       Some general mtio.h magnetic tape operations are
- *                        now supported by our character device. As a result,
- *                        popular tape utilities are starting to work with
- *                        ide tapes :-)
- *                       The following configurations were tested:
- *                       	1. An IDE ATAPI TAPE shares the same interface
- *                       	   and irq with an IDE ATAPI CDROM.
- *                        	2. An IDE ATAPI TAPE shares the same interface
- *                          	   and irq with a normal IDE disk.
- *                        Both configurations seemed to work just fine !
- *                        However, to be on the safe side, it is meanwhile
- *                        recommended to give the IDE TAPE its own interface
- *                        and irq.
- *                       The one thing which needs to be done here is to
- *                        add a "request postpone" feature to ide.c,
- *                        so that we won't have to wait for the tape to finish
- *                        performing a long media access (DSC) request (such
- *                        as a rewind) before we can access the other device
- *                        on the same interface. This effect doesn't disturb
- *                        normal operation most of the time because read/write
- *                        requests are relatively fast, and once we are
- *                        performing one tape r/w request, a lot of requests
- *                        from the other device can be queued and ide.c will
- *			  service all of them after this single tape request.
- * Ver 1.0   Dec 11 95   Integrated into Linux 1.3.46 development tree.
- *                       On each read / write request, we now ask the drive
- *                        if we can transfer a constant number of bytes
- *                        (a parameter of the drive) only to its buffers,
- *                        without causing actual media access. If we can't,
- *                        we just wait until we can by polling the DSC bit.
- *                        This ensures that while we are not transferring
- *                        more bytes than the constant referred to above, the
- *                        interrupt latency will not become too high and
- *                        we won't cause an interrupt timeout, as happened
- *                        occasionally in the previous version.
- *                       While polling for DSC, the current request is
- *                        postponed and ide.c is free to handle requests from
- *                        the other device. This is handled transparently to
- *                        ide.c. The hwgroup locking method which was used
- *                        in the previous version was removed.
- *                       Use of new general features which are provided by
- *                        ide.c for use with atapi devices.
- *                        (Programming done by Mark Lord)
- *                       Few potential bug fixes (Again, suggested by Mark)
- *                       Single character device data transfers are now
- *                        not limited in size, as they were before.
- *                       We are asking the tape about its recommended
- *                        transfer unit and send a larger data transfer
- *                        as several transfers of the above size.
- *                        For best results, use an integral number of this
- *                        basic unit (which is shown during driver
- *                        initialization). I will soon add an ioctl to get
- *                        this important parameter.
- *                       Our data transfer buffer is allocated on startup,
- *                        rather than before each data transfer. This should
- *                        ensure that we will indeed have a data buffer.
- * Ver 1.1   Dec 14 95   Fixed random problems which occurred when the tape
- *                        shared an interface with another device.
- *                        (poll_for_dsc was a complete mess).
- *                       Removed some old (non-active) code which had
- *                        to do with supporting buffer cache originated
- *                        requests.
- *                       The block device interface can now be opened, so
- *                        that general ide driver features like the unmask
- *                        interrupts flag can be selected with an ioctl.
- *                        This is the only use of the block device interface.
- *                       New fast pipelined operation mode (currently only on
- *                        writes). When using the pipelined mode, the
- *                        throughput can potentially reach the maximum
- *                        tape supported throughput, regardless of the
- *                        user backup program. On my tape drive, it sometimes
- *                        boosted performance by a factor of 2. Pipelined
- *                        mode is enabled by default, but since it has a few
- *                        downfalls as well, you may want to disable it.
- *                        A short explanation of the pipelined operation mode
- *                        is available below.
- * Ver 1.2   Jan  1 96   Eliminated pipelined mode race condition.
- *                       Added pipeline read mode. As a result, restores
- *                        are now as fast as backups.
- *                       Optimized shared interface behavior. The new behavior
- *                        typically results in better IDE bus efficiency and
- *                        higher tape throughput.
- *                       Pre-calculation of the expected read/write request
- *                        service time, based on the tape's parameters. In
- *                        the pipelined operation mode, this allows us to
- *                        adjust our polling frequency to a much lower value,
- *                        and thus to dramatically reduce our load on Linux,
- *                        without any decrease in performance.
- *                       Implemented additional mtio.h operations.
- *                       The recommended user block size is returned by
- *                        the MTIOCGET ioctl.
- *                       Additional minor changes.
- * Ver 1.3   Feb  9 96   Fixed pipelined read mode bug which prevented the
- *                        use of some block sizes during a restore procedure.
- *                       The character device interface will now present a
- *                        continuous view of the media - any mix of block sizes
- *                        during a backup/restore procedure is supported. The
- *                        driver will buffer the requests internally and
- *                        convert them to the tape's recommended transfer
- *                        unit, making performance almost independent of the
- *                        chosen user block size.
- *                       Some improvements in error recovery.
- *                       By cooperating with ide-dma.c, bus mastering DMA can
- *                        now sometimes be used with IDE tape drives as well.
- *                        Bus mastering DMA has the potential to dramatically
- *                        reduce the CPU's overhead when accessing the device,
- *                        and can be enabled by using hdparm -d1 on the tape's
- *                        block device interface. For more info, read the
- *                        comments in ide-dma.c.
- * Ver 1.4   Mar 13 96   Fixed serialize support.
- * Ver 1.5   Apr 12 96   Fixed shared interface operation, broken in 1.3.85.
- *                       Fixed pipelined read mode inefficiency.
- *                       Fixed nasty null dereferencing bug.
- * Ver 1.6   Aug 16 96   Fixed FPU usage in the driver.
- *                       Fixed end of media bug.
- * Ver 1.7   Sep 10 96   Minor changes for the CONNER CTT8000-A model.
- * Ver 1.8   Sep 26 96   Attempt to find a better balance between good
- *                        interactive response and high system throughput.
- * Ver 1.9   Nov  5 96   Automatically cross encountered filemarks rather
- *                        than requiring an explicit FSF command.
- *                       Abort pending requests at end of media.
- *                       MTTELL was sometimes returning incorrect results.
- *                       Return the real block size in the MTIOCGET ioctl.
- *                       Some error recovery bug fixes.
- * Ver 1.10  Nov  5 96   Major reorganization.
- *                       Reduced CPU overhead a bit by eliminating internal
- *                        bounce buffers.
- *                       Added module support.
- *                       Added multiple tape drives support.
- *                       Added partition support.
- *                       Rewrote DSC handling.
- *                       Some portability fixes.
- *                       Removed ide-tape.h.
- *                       Additional minor changes.
- * Ver 1.11  Dec  2 96   Bug fix in previous DSC timeout handling.
- *                       Use ide_stall_queue() for DSC overlap.
- *                       Use the maximum speed rather than the current speed
- *                        to compute the request service time.
- * Ver 1.12  Dec  7 97   Fix random memory overwriting and/or last block data
- *                        corruption, which could occur if the total number
- *                        of bytes written to the tape was not an integral
- *                        number of tape blocks.
- *                       Add support for INTERRUPT DRQ devices.
- * Ver 1.13  Jan  2 98   Add "speed == 0" work-around for HP COLORADO 5GB
- * Ver 1.14  Dec 30 98   Partial fixes for the Sony/AIWA tape drives.
- *                       Replace cli()/sti() with hwgroup spinlocks.
- * Ver 1.15  Mar 25 99   Fix SMP race condition by replacing hwgroup
- *                        spinlock with private per-tape spinlock.
- * Ver 1.16  Sep  1 99   Add OnStream tape support.
- *                       Abort read pipeline on EOD.
- *                       Wait for the tape to become ready in case it returns
- *                        "in the process of becoming ready" on open().
- *                       Fix zero padding of the last written block in
- *                        case the tape block size is larger than PAGE_SIZE.
- *                       Decrease the default disconnection time to tn.
- * Ver 1.16e Oct  3 99   Minor fixes.
- * Ver 1.16e1 Oct 13 99  Patches by Arnold Niessen,
- *                          niessen@iae.nl / arnold.niessen@philips.com
- *                   GO-1)  Undefined code in idetape_read_position
- *				according to Gadi's email
- *                   AJN-1) Minor fix asc == 11 should be asc == 0x11
- *                               in idetape_issue_packet_command (did effect
- *                               debugging output only)
- *                   AJN-2) Added more debugging output, and
- *                              added ide-tape: where missing. I would also
- *				like to add tape->name where possible
- *                   AJN-3) Added different debug_level's 
- *                              via /proc/ide/hdc/settings
- * 				"debug_level" determines amount of debugging output;
- * 				can be changed using /proc/ide/hdx/settings
- * 				0 : almost no debugging output
- * 				1 : 0+output errors only
- * 				2 : 1+output all sensekey/asc
- * 				3 : 2+follow all chrdev related procedures
- * 				4 : 3+follow all procedures
- * 				5 : 4+include pc_stack rq_stack info
- * 				6 : 5+USE_COUNT updates
- *                   AJN-4) Fixed timeout for retension in idetape_queue_pc_tail
- *				from 5 to 10 minutes
- *                   AJN-5) Changed maximum number of blocks to skip when
- *                              reading tapes with multiple consecutive write
- *                              errors from 100 to 1000 in idetape_get_logical_blk
- *                   Proposed changes to code:
- *                   1) output "logical_blk_num" via /proc
- *                   2) output "current_operation" via /proc
- *                   3) Either solve or document the fact that `mt rewind' is
- *                      required after reading from /dev/nhtx to be
- *			able to rmmod the idetape module;
- *			Also, sometimes an application finishes but the
- *			device remains `busy' for some time. Same cause ?
- *                   Proposed changes to release-notes:
- *		     4) write a simple `quickstart' section in the
- *                      release notes; I volunteer if you don't want to
- * 		     5) include a pointer to video4linux in the doc
- *                      to stimulate video applications
- *                   6) release notes lines 331 and 362: explain what happens
- *			if the application data rate is higher than 1100 KB/s; 
- *			similar approach to lower-than-500 kB/s ?
- *		     7) 6.6 Comparison; wouldn't it be better to allow different 
- *			strategies for read and write ?
- *			Wouldn't it be better to control the tape buffer
- *			contents instead of the bandwidth ?
- *		     8) line 536: replace will by would (if I understand
- *			this section correctly, a hypothetical and unwanted situation
- *			 is being described)
- * Ver 1.16f Dec 15 99   Change place of the secondary OnStream header frames.
- * Ver 1.17  Nov 2000 / Jan 2001  Marcel Mol, marcel@mesa.nl
- *			- Add idetape_onstream_mode_sense_tape_parameter_page
- *			  function to get tape capacity in frames: tape->capacity.
- *			- Add support for DI-50 drives( or any DI- drive).
- *			- 'workaround' for read error/blank block around block 3000.
- *			- Implement Early warning for end of media for Onstream.
- *			- Cosmetic code changes for readability.
- *			- Idetape_position_tape should not use SKIP bit during
- *			  Onstream read recovery.
- *			- Add capacity, logical_blk_num and first/last_frame_position
- *			  to /proc/ide/hd?/settings.
- *			- Module use count was gone in the Linux 2.4 driver.
- * Ver 1.17a Apr 2001 Willem Riede osst@riede.org
- * 			- Get drive's actual block size from mode sense block descriptor
- * 			- Limit size of pipeline
- * Ver 1.17b Oct 2002   Alan Stern <stern@rowland.harvard.edu>
- *			Changed IDETAPE_MIN_PIPELINE_STAGES to 1 and actually used
- *			 it in the code!
- *			Actually removed aborted stages in idetape_abort_pipeline
- *			 instead of just changing the command code.
- *			Made the transfer byte count for Request Sense equal to the
- *			 actual length of the data transfer.
- *			Changed handling of partial data transfers: they do not
- *			 cause DMA errors.
- *			Moved initiation of DMA transfers to the correct place.
- *			Removed reference to unallocated memory.
- *			Made __idetape_discard_read_pipeline return the number of
- *			 sectors skipped, not the number of stages.
- *			Replaced errant kfree() calls with __idetape_kfree_stage().
- *			Fixed off-by-one error in testing the pipeline length.
- *			Fixed handling of filemarks in the read pipeline.
- *			Small code optimization for MTBSF and MTBSFM ioctls.
- *			Don't try to unlock the door during device close if is
- *			 already unlocked!
- *			Cosmetic fixes to miscellaneous debugging output messages.
- *			Set the minimum /proc/ide/hd?/settings values for "pipeline",
- *			 "pipeline_min", and "pipeline_max" to 1.
- *
- * Here are some words from the first releases of hd.c, which are quoted
- * in ide.c and apply here as well:
- *
- * | Special care is recommended.  Have Fun!
  *
- */
-
-/*
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
- */
-
-/*
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
+ * For a historical changelog see
+ * Documentation/ide/ChangeLog.ide-tape.1995-2002
  */
 
 #define IDETAPE_VERSION "1.19"
@@ -442,49 +36,13 @@
 #include <linux/completion.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
+#include <scsi/scsi.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/unaligned.h>
-
-/*
- * partition
- */
-typedef struct os_partition_s {
-	__u8	partition_num;
-	__u8	par_desc_ver;
-	__u16	wrt_pass_cntr;
-	__u32	first_frame_addr;
-	__u32	last_frame_addr;
-	__u32	eod_frame_addr;
-} os_partition_t;
-
-/*
- * DAT entry
- */
-typedef struct os_dat_entry_s {
-	__u32	blk_sz;
-	__u16	blk_cnt;
-	__u8	flags;
-	__u8	reserved;
-} os_dat_entry_t;
-
-/*
- * DAT
- */
-#define OS_DAT_FLAGS_DATA	(0xc)
-#define OS_DAT_FLAGS_MARK	(0x1)
-
-typedef struct os_dat_s {
-	__u8		dat_sz;
-	__u8		reserved1;
-	__u8		entry_cnt;
-	__u8		reserved3;
-	os_dat_entry_t	dat_list[16];
-} os_dat_t;
-
 #include <linux/mtio.h>
 
 /**************************** Tunable parameters *****************************/
@@ -512,10 +70,7 @@ typedef struct os_dat_s {
 /*
  *	The following are used to debug the driver:
  *
- *	Setting IDETAPE_DEBUG_INFO to 1 will report device capabilities.
  *	Setting IDETAPE_DEBUG_LOG to 1 will log driver flow control.
- *	Setting IDETAPE_DEBUG_BUGS to 1 will enable self-sanity checks in
- *	some places.
  *
  *	Setting them to 0 will restore normal operation mode:
  *
@@ -527,9 +82,7 @@ typedef struct os_dat_s {
  *	is verified to be stable enough. This will make it much more
  *	esthetic.
  */
-#define IDETAPE_DEBUG_INFO		0
 #define IDETAPE_DEBUG_LOG		0
-#define IDETAPE_DEBUG_BUGS		1
 
 /*
  *	After each failed packet command we issue a request sense command
@@ -671,65 +224,6 @@ typedef struct idetape_packet_command_s {
 #define	PC_WRITING			5
 
 /*
- *	Capabilities and Mechanical Status Page
- */
-typedef struct {
-	unsigned	page_code	:6;	/* Page code - Should be 0x2a */
-	__u8		reserved0_6	:1;
-	__u8		ps		:1;	/* parameters saveable */
-	__u8		page_length;		/* Page Length - Should be 0x12 */
-	__u8		reserved2, reserved3;
-	unsigned	ro		:1;	/* Read Only Mode */
-	unsigned	reserved4_1234	:4;
-	unsigned	sprev		:1;	/* Supports SPACE in the reverse direction */
-	unsigned	reserved4_67	:2;
-	unsigned	reserved5_012	:3;
-	unsigned	efmt		:1;	/* Supports ERASE command initiated formatting */
-	unsigned	reserved5_4	:1;
-	unsigned	qfa		:1;	/* Supports the QFA two partition formats */
-	unsigned	reserved5_67	:2;
-	unsigned	lock		:1;	/* Supports locking the volume */
-	unsigned	locked		:1;	/* The volume is locked */
-	unsigned	prevent		:1;	/* The device defaults in the prevent state after power up */	
-	unsigned	eject		:1;	/* The device can eject the volume */
-	__u8		disconnect	:1;	/* The device can break request > ctl */	
-	__u8		reserved6_5	:1;
-	unsigned	ecc		:1;	/* Supports error correction */
-	unsigned	cmprs		:1;	/* Supports data compression */
-	unsigned	reserved7_0	:1;
-	unsigned	blk512		:1;	/* Supports 512 bytes block size */
-	unsigned	blk1024		:1;	/* Supports 1024 bytes block size */
-	unsigned	reserved7_3_6	:4;
-	unsigned	blk32768	:1;	/* slowb - the device restricts the byte count for PIO */
-						/* transfers for slow buffer memory ??? */
-						/* Also 32768 block size in some cases */
-	__u16		max_speed;		/* Maximum speed supported in KBps */
-	__u8		reserved10, reserved11;
-	__u16		ctl;			/* Continuous Transfer Limit in blocks */
-	__u16		speed;			/* Current Speed, in KBps */
-	__u16		buffer_size;		/* Buffer Size, in 512 bytes */
-	__u8		reserved18, reserved19;
-} idetape_capabilities_page_t;
-
-/*
- *	Block Size Page
- */
-typedef struct {
-	unsigned	page_code	:6;	/* Page code - Should be 0x30 */
-	unsigned	reserved1_6	:1;
-	unsigned	ps		:1;
-	__u8		page_length;		/* Page Length - Should be 2 */
-	__u8		reserved2;
-	unsigned	play32		:1;
-	unsigned	play32_5	:1;
-	unsigned	reserved2_23	:2;
-	unsigned	record32	:1;
-	unsigned	record32_5	:1;
-	unsigned	reserved2_6	:1;
-	unsigned	one		:1;
-} idetape_block_size_page_t;
-
-/*
  *	A pipeline stage.
  */
 typedef struct idetape_stage_s {
@@ -739,32 +233,6 @@ typedef struct idetape_stage_s {
 } idetape_stage_t;
 
 /*
- *	REQUEST SENSE packet command result - Data Format.
- */
-typedef struct {
-	unsigned	error_code	:7;	/* Current of deferred errors */
-	unsigned	valid		:1;	/* The information field conforms to QIC-157C */
-	__u8		reserved1	:8;	/* Segment Number - Reserved */
-	unsigned	sense_key	:4;	/* Sense Key */
-	unsigned	reserved2_4	:1;	/* Reserved */
-	unsigned	ili		:1;	/* Incorrect Length Indicator */
-	unsigned	eom		:1;	/* End Of Medium */
-	unsigned	filemark 	:1;	/* Filemark */
-	__u32		information __attribute__ ((packed));
-	__u8		asl;			/* Additional sense length (n-7) */
-	__u32		command_specific;	/* Additional command specific information */
-	__u8		asc;			/* Additional Sense Code */
-	__u8		ascq;			/* Additional Sense Code Qualifier */
-	__u8		replaceable_unit_code;	/* Field Replaceable Unit Code */
-	unsigned	sk_specific1 	:7;	/* Sense Key Specific */
-	unsigned	sksv		:1;	/* Sense Key Specific information is valid */
-	__u8		sk_specific2;		/* Sense Key Specific */
-	__u8		sk_specific3;		/* Sense Key Specific */
-	__u8		pad[2];			/* Padding to 20 bytes */
-} idetape_request_sense_result_t;
-
-
-/*
  *	Most of our global data which we need to save even as we leave the
  *	driver due to an interrupt or a timer event is stored in a variable
  *	of type idetape_tape_t, defined below.
@@ -854,8 +322,9 @@ typedef struct ide_tape_obj {
 	/* Usually 512 or 1024 bytes */
 	unsigned short tape_block_size;
 	int user_bs_factor;
+
 	/* Copy of the tape's Capabilities and Mechanical Page */
-	idetape_capabilities_page_t capabilities;
+	u8 caps[20];
 
 	/*
 	 *	Active data transfer request parameters.
@@ -918,9 +387,6 @@ typedef struct ide_tape_obj {
 	int avg_size;
 	int avg_speed;
 
-	/* last sense information */
-	idetape_request_sense_result_t sense;
-
 	char vendor_id[10];
 	char product_id[18];
 	char firmware_revision[6];
@@ -1052,27 +518,6 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 #define IDETAPE_MEDIUM_PRESENT		9
 
 /*
- *	Supported ATAPI tape drives packet commands
- */
-#define IDETAPE_TEST_UNIT_READY_CMD	0x00
-#define IDETAPE_REWIND_CMD		0x01
-#define IDETAPE_REQUEST_SENSE_CMD	0x03
-#define IDETAPE_READ_CMD		0x08
-#define IDETAPE_WRITE_CMD		0x0a
-#define IDETAPE_WRITE_FILEMARK_CMD	0x10
-#define IDETAPE_SPACE_CMD		0x11
-#define IDETAPE_INQUIRY_CMD		0x12
-#define IDETAPE_ERASE_CMD		0x19
-#define IDETAPE_MODE_SENSE_CMD		0x1a
-#define IDETAPE_MODE_SELECT_CMD		0x15
-#define IDETAPE_LOAD_UNLOAD_CMD		0x1b
-#define IDETAPE_PREVENT_CMD		0x1e
-#define IDETAPE_LOCATE_CMD		0x2b
-#define IDETAPE_READ_POSITION_CMD	0x34
-#define IDETAPE_READ_BUFFER_CMD		0x3c
-#define IDETAPE_SET_SPEED_CMD		0xbb
-
-/*
  *	Some defines for the READ BUFFER command
  */
 #define IDETAPE_RETRIEVE_FAULTY_BLOCK	6
@@ -1129,31 +574,6 @@ struct idetape_id_gcw {
 };
 
 /*
- *	INQUIRY packet command - Data Format (From Table 6-8 of QIC-157C)
- */
-typedef struct {
-	unsigned	device_type	:5;	/* Peripheral Device Type */
-	unsigned	reserved0_765	:3;	/* Peripheral Qualifier - Reserved */
-	unsigned	reserved1_6t0	:7;	/* Reserved */
-	unsigned	rmb		:1;	/* Removable Medium Bit */
-	unsigned	ansi_version	:3;	/* ANSI Version */
-	unsigned	ecma_version	:3;	/* ECMA Version */
-	unsigned	iso_version	:2;	/* ISO Version */
-	unsigned	response_format :4;	/* Response Data Format */
-	unsigned	reserved3_45	:2;	/* Reserved */
-	unsigned	reserved3_6	:1;	/* TrmIOP - Reserved */
-	unsigned	reserved3_7	:1;	/* AENC - Reserved */
-	__u8		additional_length;	/* Additional Length (total_length-4) */
-	__u8		rsv5, rsv6, rsv7;	/* Reserved */
-	__u8		vendor_id[8];		/* Vendor Identification */
-	__u8		product_id[16];		/* Product Identification */
-	__u8		revision_level[4];	/* Revision Level */
-	__u8		vendor_specific[20];	/* Vendor Specific - Optional */
-	__u8		reserved56t95[40];	/* Reserved - Optional */
-						/* Additional information may be returned */
-} idetape_inquiry_result_t;
-
-/*
  *	READ POSITION packet command - Data Format (From Table 6-57)
  */
 typedef struct {
@@ -1171,100 +591,9 @@ typedef struct {
 	u32		bytes_in_buffer;	/* Bytes In Buffer (Optional) */
 } idetape_read_position_result_t;
 
-/*
- *	Follows structures which are related to the SELECT SENSE / MODE SENSE
- *	packet commands. Those packet commands are still not supported
- *	by ide-tape.
- */
+/* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
 #define IDETAPE_BLOCK_DESCRIPTOR	0
 #define	IDETAPE_CAPABILITIES_PAGE	0x2a
-#define IDETAPE_PARAMTR_PAGE		0x2b   /* Onstream DI-x0 only */
-#define IDETAPE_BLOCK_SIZE_PAGE		0x30
-#define IDETAPE_BUFFER_FILLING_PAGE	0x33
-
-/*
- *	Mode Parameter Header for the MODE SENSE packet command
- */
-typedef struct {
-	__u8	mode_data_length;	/* Length of the following data transfer */
-	__u8	medium_type;		/* Medium Type */
-	__u8	dsp;			/* Device Specific Parameter */
-	__u8	bdl;			/* Block Descriptor Length */
-#if 0
-	/* data transfer page */
-	__u8	page_code	:6;
-	__u8	reserved0_6	:1;
-	__u8	ps		:1;	/* parameters saveable */
-	__u8	page_length;		/* page Length == 0x02 */
-	__u8	reserved2;
-	__u8	read32k		:1;	/* 32k blk size (data only) */
-	__u8	read32k5	:1;	/* 32.5k blk size (data&AUX) */
-	__u8	reserved3_23	:2;
-	__u8	write32k	:1;	/* 32k blk size (data only) */
-	__u8	write32k5	:1;	/* 32.5k blk size (data&AUX) */
-	__u8	reserved3_6	:1;
-	__u8	streaming	:1;	/* streaming mode enable */
-#endif
-} idetape_mode_parameter_header_t;
-
-/*
- *	Mode Parameter Block Descriptor the MODE SENSE packet command
- *
- *	Support for block descriptors is optional.
- */
-typedef struct {
-	__u8		density_code;		/* Medium density code */
-	__u8		blocks[3];		/* Number of blocks */
-	__u8		reserved4;		/* Reserved */
-	__u8		length[3];		/* Block Length */
-} idetape_parameter_block_descriptor_t;
-
-/*
- *	The Data Compression Page, as returned by the MODE SENSE packet command.
- */
-typedef struct {
-	unsigned	page_code	:6;	/* Page Code - Should be 0xf */
-	unsigned	reserved0	:1;	/* Reserved */
-	unsigned	ps		:1;
-	__u8		page_length;		/* Page Length - Should be 14 */
-	unsigned	reserved2	:6;	/* Reserved */
-	unsigned	dcc		:1;	/* Data Compression Capable */
-	unsigned	dce		:1;	/* Data Compression Enable */
-	unsigned	reserved3	:5;	/* Reserved */
-	unsigned	red		:2;	/* Report Exception on Decompression */
-	unsigned	dde		:1;	/* Data Decompression Enable */
-	__u32		ca;			/* Compression Algorithm */
-	__u32		da;			/* Decompression Algorithm */
-	__u8		reserved[4];		/* Reserved */
-} idetape_data_compression_page_t;
-
-/*
- *	The Medium Partition Page, as returned by the MODE SENSE packet command.
- */
-typedef struct {
-	unsigned	page_code	:6;	/* Page Code - Should be 0x11 */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	ps		:1;
-	__u8		page_length;		/* Page Length - Should be 6 */
-	__u8		map;			/* Maximum Additional Partitions - Should be 0 */
-	__u8		apd;			/* Additional Partitions Defined - Should be 0 */
-	unsigned	reserved4_012	:3;	/* Reserved */
-	unsigned	psum		:2;	/* Should be 0 */
-	unsigned	idp		:1;	/* Should be 0 */
-	unsigned	sdp		:1;	/* Should be 0 */
-	unsigned	fdp		:1;	/* Fixed Data Partitions */
-	__u8		mfr;			/* Medium Format Recognition */
-	__u8		reserved[2];		/* Reserved */
-} idetape_medium_partition_page_t;
-
-/*
- *	Run time configurable parameters.
- */
-typedef struct {
-	int	dsc_rw_frequency;
-	int	dsc_media_access_frequency;
-	int	nr_stages;
-} idetape_config_t;
 
 /*
  *	The variables below are used for the character device interface.
@@ -1309,14 +638,12 @@ static void idetape_input_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigne
 	int count;
 
 	while (bcount) {
-#if IDETAPE_DEBUG_BUGS
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_input_buffers\n");
 			idetape_discard_data(drive, bcount);
 			return;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		count = min((unsigned int)(bh->b_size - atomic_read(&bh->b_count)), bcount);
 		HWIF(drive)->atapi_input_bytes(drive, bh->b_data + atomic_read(&bh->b_count), count);
 		bcount -= count;
@@ -1336,13 +663,11 @@ static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsign
 	int count;
 
 	while (bcount) {
-#if IDETAPE_DEBUG_BUGS
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_output_buffers\n");
 			return;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
 		HWIF(drive)->atapi_output_bytes(drive, pc->b_data, count);
 		bcount -= count;
@@ -1367,13 +692,11 @@ static void idetape_update_buffers (idetape_pc_t *pc)
 	if (test_bit(PC_WRITING, &pc->flags))
 		return;
 	while (bcount) {
-#if IDETAPE_DEBUG_BUGS
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_update_buffers\n");
 			return;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		count = min((unsigned int)bh->b_size, (unsigned int)bcount);
 		atomic_set(&bh->b_count, count);
 		if (atomic_read(&bh->b_count) == bh->b_size)
@@ -1446,36 +769,34 @@ static void idetape_init_pc (idetape_pc_t *pc)
 }
 
 /*
- *	idetape_analyze_error is called on each failed packet command retry
- *	to analyze the request sense. We currently do not utilize this
- *	information.
+ * called on each failed packet command retry to analyze the request sense. We
+ * currently do not utilize this information.
  */
-static void idetape_analyze_error (ide_drive_t *drive, idetape_request_sense_result_t *result)
+static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = tape->failed_pc;
 
-	tape->sense     = *result;
-	tape->sense_key = result->sense_key;
-	tape->asc       = result->asc;
-	tape->ascq      = result->ascq;
+	tape->sense_key = sense[2] & 0xF;
+	tape->asc       = sense[12];
+	tape->ascq      = sense[13];
 #if IDETAPE_DEBUG_LOG
 	/*
-	 *	Without debugging, we only log an error if we decided to
-	 *	give up retrying.
+	 * Without debugging, we only log an error if we decided to give up
+	 * retrying.
 	 */
 	if (tape->debug_level >= 1)
 		printk(KERN_INFO "ide-tape: pc = %x, sense key = %x, "
 			"asc = %x, ascq = %x\n",
-			pc->c[0], result->sense_key,
-			result->asc, result->ascq);
+			pc->c[0], tape->sense_key,
+			tape->asc, tape->ascq);
 #endif /* IDETAPE_DEBUG_LOG */
 
-	/*
-	 *	Correct pc->actually_transferred by asking the tape.
-	 */
+	/* Correct pc->actually_transferred by asking the tape.	 */
 	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
-		pc->actually_transferred = pc->request_transfer - tape->tape_block_size * ntohl(get_unaligned(&result->information));
+		pc->actually_transferred = pc->request_transfer -
+			tape->tape_block_size *
+			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
 		idetape_update_buffers(pc);
 	}
 
@@ -1484,29 +805,29 @@ static void idetape_analyze_error (ide_drive_t *drive, idetape_request_sense_res
 	 * with sense key=5, asc=0x22, ascq=0, let it slide.  Some drives
 	 * (i.e. Seagate STT3401A Travan) don't support 0-length read/writes.
 	 */
-	if ((pc->c[0] == IDETAPE_READ_CMD || pc->c[0] == IDETAPE_WRITE_CMD)
-	    && pc->c[4] == 0 && pc->c[3] == 0 && pc->c[2] == 0) { /* length==0 */
-		if (result->sense_key == 5) {
+	if ((pc->c[0] == READ_6 || pc->c[0] == WRITE_6)
+	    /* length == 0 */
+	    && pc->c[4] == 0 && pc->c[3] == 0 && pc->c[2] == 0) {
+		if (tape->sense_key == 5) {
 			/* don't report an error, everything's ok */
 			pc->error = 0;
 			/* don't retry read/write */
 			set_bit(PC_ABORT, &pc->flags);
 		}
 	}
-	if (pc->c[0] == IDETAPE_READ_CMD && result->filemark) {
+	if (pc->c[0] == READ_6 && (sense[2] & 0x80)) {
 		pc->error = IDETAPE_ERROR_FILEMARK;
 		set_bit(PC_ABORT, &pc->flags);
 	}
-	if (pc->c[0] == IDETAPE_WRITE_CMD) {
-		if (result->eom ||
-		    (result->sense_key == 0xd && result->asc == 0x0 &&
-		     result->ascq == 0x2)) {
+	if (pc->c[0] == WRITE_6) {
+		if ((sense[2] & 0x40) || (tape->sense_key == 0xd
+		     && tape->asc == 0x0 && tape->ascq == 0x2)) {
 			pc->error = IDETAPE_ERROR_EOD;
 			set_bit(PC_ABORT, &pc->flags);
 		}
 	}
-	if (pc->c[0] == IDETAPE_READ_CMD || pc->c[0] == IDETAPE_WRITE_CMD) {
-		if (result->sense_key == 8) {
+	if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
+		if (tape->sense_key == 8) {
 			pc->error = IDETAPE_ERROR_EOD;
 			set_bit(PC_ABORT, &pc->flags);
 		}
@@ -1516,10 +837,7 @@ static void idetape_analyze_error (ide_drive_t *drive, idetape_request_sense_res
 	}
 }
 
-/*
- * idetape_active_next_stage will declare the next stage as "active".
- */
-static void idetape_active_next_stage (ide_drive_t *drive)
+static void idetape_activate_next_stage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage = tape->next_stage;
@@ -1529,12 +847,10 @@ static void idetape_active_next_stage (ide_drive_t *drive)
 	if (tape->debug_level >= 4)
 		printk(KERN_INFO "ide-tape: Reached idetape_active_next_stage\n");
 #endif /* IDETAPE_DEBUG_LOG */
-#if IDETAPE_DEBUG_BUGS
 	if (stage == NULL) {
 		printk(KERN_ERR "ide-tape: bug: Trying to activate a non existing stage\n");
 		return;
 	}
-#endif /* IDETAPE_DEBUG_BUGS */	
 
 	rq->rq_disk = tape->disk;
 	rq->buffer = NULL;
@@ -1609,28 +925,24 @@ static void idetape_remove_stage_head (ide_drive_t *drive)
 	if (tape->debug_level >= 4)
 		printk(KERN_INFO "ide-tape: Reached idetape_remove_stage_head\n");
 #endif /* IDETAPE_DEBUG_LOG */
-#if IDETAPE_DEBUG_BUGS
 	if (tape->first_stage == NULL) {
 		printk(KERN_ERR "ide-tape: bug: tape->first_stage is NULL\n");
-		return;		
+		return;
 	}
 	if (tape->active_stage == tape->first_stage) {
 		printk(KERN_ERR "ide-tape: bug: Trying to free our active pipeline stage\n");
 		return;
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 	stage = tape->first_stage;
 	tape->first_stage = stage->next;
 	idetape_kfree_stage(tape, stage);
 	tape->nr_stages--;
 	if (tape->first_stage == NULL) {
 		tape->last_stage = NULL;
-#if IDETAPE_DEBUG_BUGS
 		if (tape->next_stage != NULL)
 			printk(KERN_ERR "ide-tape: bug: tape->next_stage != NULL\n");
 		if (tape->nr_stages)
 			printk(KERN_ERR "ide-tape: bug: nr_stages should be 0 now\n");
-#endif /* IDETAPE_DEBUG_BUGS */
 	}
 }
 
@@ -1716,7 +1028,7 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 			}
 		}
 		if (tape->next_stage != NULL) {
-			idetape_active_next_stage(drive);
+			idetape_activate_next_stage(drive);
 
 			/*
 			 * Insert the next request into the request queue.
@@ -1748,7 +1060,7 @@ static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
 		printk(KERN_INFO "ide-tape: Reached idetape_request_sense_callback\n");
 #endif /* IDETAPE_DEBUG_LOG */
 	if (!tape->pc->error) {
-		idetape_analyze_error(drive, (idetape_request_sense_result_t *) tape->pc->buffer);
+		idetape_analyze_error(drive, tape->pc->buffer);
 		idetape_end_request(drive, 1, 0);
 	} else {
 		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself - Aborting request!\n");
@@ -1760,7 +1072,7 @@ static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
 static void idetape_create_request_sense_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);	
-	pc->c[0] = IDETAPE_REQUEST_SENSE_CMD;
+	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
 	pc->request_transfer = 20;
 	pc->callback = &idetape_request_sense_callback;
@@ -1913,15 +1225,14 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		local_irq_enable();
 
 #if SIMULATE_ERRORS
-		if ((pc->c[0] == IDETAPE_WRITE_CMD ||
-		     pc->c[0] == IDETAPE_READ_CMD) &&
+		if ((pc->c[0] == WRITE_6 || pc->c[0] == READ_6) &&
 		    (++error_sim_count % 100) == 0) {
 			printk(KERN_INFO "ide-tape: %s: simulating error\n",
 				tape->name);
 			stat |= ERR_STAT;
 		}
 #endif
-		if ((stat & ERR_STAT) && pc->c[0] == IDETAPE_REQUEST_SENSE_CMD)
+		if ((stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
 			stat &= ~ERR_STAT;
 		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
 			/* Error detected */
@@ -1930,7 +1241,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 				printk(KERN_INFO "ide-tape: %s: I/O error\n",
 					tape->name);
 #endif /* IDETAPE_DEBUG_LOG */
-			if (pc->c[0] == IDETAPE_REQUEST_SENSE_CMD) {
+			if (pc->c[0] == REQUEST_SENSE) {
 				printk(KERN_ERR "ide-tape: I/O error in request sense command\n");
 				return ide_do_reset(drive);
 			}
@@ -2118,15 +1429,13 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 	int dma_ok = 0;
 	u16 bcount;
 
-#if IDETAPE_DEBUG_BUGS
-	if (tape->pc->c[0] == IDETAPE_REQUEST_SENSE_CMD &&
-	    pc->c[0] == IDETAPE_REQUEST_SENSE_CMD) {
+	if (tape->pc->c[0] == REQUEST_SENSE &&
+	    pc->c[0] == REQUEST_SENSE) {
 		printk(KERN_ERR "ide-tape: possible ide-tape.c bug - "
 			"Two request sense in serial were issued\n");
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 
-	if (tape->failed_pc == NULL && pc->c[0] != IDETAPE_REQUEST_SENSE_CMD)
+	if (tape->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
 		tape->failed_pc = pc;
 	/* Set the current packet command */
 	tape->pc = pc;
@@ -2139,7 +1448,7 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 		 *	filemark, or end of the media, for example).
 		 */
 		if (!test_bit(PC_ABORT, &pc->flags)) {
-			if (!(pc->c[0] == IDETAPE_TEST_UNIT_READY_CMD &&
+			if (!(pc->c[0] == TEST_UNIT_READY &&
 			      tape->sense_key == 2 && tape->asc == 4 &&
 			     (tape->ascq == 1 || tape->ascq == 8))) {
 				printk(KERN_ERR "ide-tape: %s: I/O error, "
@@ -2181,8 +1490,8 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 	if (dma_ok)			/* Will begin DMA later */
 		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 	if (test_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags)) {
-		ide_set_handler(drive, &idetape_transfer_pc, IDETAPE_WAIT_CMD, NULL);
-		hwif->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		ide_execute_command(drive, WIN_PACKETCMD, &idetape_transfer_pc,
+				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
 	} else {
 		hwif->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
@@ -2212,7 +1521,7 @@ static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
 static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_MODE_SENSE_CMD;
+	pc->c[0] = MODE_SENSE;
 	if (page_code != IDETAPE_BLOCK_DESCRIPTOR)
 		pc->c[1] = 8;	/* DBD = 1 - Don't return block descriptors */
 	pc->c[2] = page_code;
@@ -2293,7 +1602,7 @@ static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
 	if (stat & SEEK_STAT) {
 		if (stat & ERR_STAT) {
 			/* Error detected */
-			if (pc->c[0] != IDETAPE_TEST_UNIT_READY_CMD)
+			if (pc->c[0] != TEST_UNIT_READY)
 				printk(KERN_ERR "ide-tape: %s: I/O error, ",
 						tape->name);
 			/* Retry operation */
@@ -2350,8 +1659,8 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_READ_CMD;
-	put_unaligned(htonl(length), (unsigned int *) &pc->c[1]);
+	pc->c[0] = READ_6;
+	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
 	pc->bh = bh;
@@ -2368,7 +1677,7 @@ static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *p
 	struct idetape_bh *p = bh;
 
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_READ_BUFFER_CMD;
+	pc->c[0] = READ_BUFFER;
 	pc->c[1] = IDETAPE_RETRIEVE_FAULTY_BLOCK;
 	pc->c[7] = size >> 8;
 	pc->c[8] = size & 0xff;
@@ -2386,8 +1695,8 @@ static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *p
 static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_WRITE_CMD;
-	put_unaligned(htonl(length), (unsigned int *) &pc->c[1]);
+	pc->c[0] = WRITE_6;
+	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
 	set_bit(PC_WRITING, &pc->flags);
@@ -2412,12 +1721,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	u8 stat;
 
 #if IDETAPE_DEBUG_LOG
-#if 0
-	if (tape->debug_level >= 5)
-		printk(KERN_INFO "ide-tape:  %d, "
-			"dev: %s, cmd: %ld, errors: %d\n",
-			 rq->rq_disk->disk_name, rq->cmd[0], rq->errors);
-#endif
 	if (tape->debug_level >= 2)
 		printk(KERN_INFO "ide-tape: sector: %ld, "
 			"nr_sectors: %ld, current_nr_sectors: %d\n",
@@ -2438,10 +1741,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 *	Retry a failed packet command
 	 */
 	if (tape->failed_pc != NULL &&
-	    tape->pc->c[0] == IDETAPE_REQUEST_SENSE_CMD) {
+	    tape->pc->c[0] == REQUEST_SENSE) {
 		return idetape_issue_packet_command(drive, tape->failed_pc);
 	}
-#if IDETAPE_DEBUG_BUGS
 	if (postponed_rq != NULL)
 		if (rq != postponed_rq) {
 			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
@@ -2449,7 +1751,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			idetape_end_request(drive, 0, 0);
 			return ide_stopped;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 
 	tape->postponed_rq = NULL;
 
@@ -2636,13 +1937,11 @@ static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *
 	int ret = 0;
 
 	while (n) {
-#if IDETAPE_DEBUG_BUGS
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_copy_stage_from_user\n");
 			return 1;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		count = min((unsigned int)(bh->b_size - atomic_read(&bh->b_count)), (unsigned int)n);
 		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf, count))
 			ret = 1;
@@ -2666,13 +1965,11 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 	int ret = 0;
 
 	while (n) {
-#if IDETAPE_DEBUG_BUGS
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_copy_stage_to_user\n");
 			return 1;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		count = min(tape->b_count, n);
 		if  (copy_to_user(buf, tape->b_data, count))
 			ret = 1;
@@ -2752,12 +2049,10 @@ static void idetape_wait_for_request (ide_drive_t *drive, struct request *rq)
 	DECLARE_COMPLETION_ONSTACK(wait);
 	idetape_tape_t *tape = drive->driver_data;
 
-#if IDETAPE_DEBUG_BUGS
 	if (rq == NULL || !blk_special_request(rq)) {
 		printk (KERN_ERR "ide-tape: bug: Trying to sleep on non-valid request\n");
 		return;
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 	rq->end_io_data = &wait;
 	rq->end_io = blk_end_sync_rq;
 	spin_unlock_irq(&tape->spinlock);
@@ -2817,7 +2112,7 @@ static ide_startstop_t idetape_read_position_callback (ide_drive_t *drive)
 static void idetape_create_write_filemark_cmd (ide_drive_t *drive, idetape_pc_t *pc,int write_filemark)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_WRITE_FILEMARK_CMD;
+	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
@@ -2826,7 +2121,7 @@ static void idetape_create_write_filemark_cmd (ide_drive_t *drive, idetape_pc_t
 static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_TEST_UNIT_READY_CMD;
+	pc->c[0] = TEST_UNIT_READY;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2864,7 +2159,7 @@ static int __idetape_queue_pc_tail (ide_drive_t *drive, idetape_pc_t *pc)
 static void idetape_create_load_unload_cmd (ide_drive_t *drive, idetape_pc_t *pc,int cmd)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_LOAD_UNLOAD_CMD;
+	pc->c[0] = START_STOP;
 	pc->c[4] = cmd;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
@@ -2921,7 +2216,7 @@ static int idetape_flush_tape_buffers (ide_drive_t *drive)
 static void idetape_create_read_position_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_READ_POSITION_CMD;
+	pc->c[0] = READ_POSITION;
 	pc->request_transfer = 20;
 	pc->callback = &idetape_read_position_callback;
 }
@@ -2947,9 +2242,9 @@ static int idetape_read_position (ide_drive_t *drive)
 static void idetape_create_locate_cmd (ide_drive_t *drive, idetape_pc_t *pc, unsigned int block, u8 partition, int skip)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_LOCATE_CMD;
+	pc->c[0] = POSITION_TO_ELEMENT;
 	pc->c[1] = 2;
-	put_unaligned(htonl(block), (unsigned int *) &pc->c[3]);
+	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
 	pc->c[8] = partition;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
@@ -2959,11 +2254,12 @@ static int idetape_create_prevent_cmd (ide_drive_t *drive, idetape_pc_t *pc, int
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	if (!tape->capabilities.lock)
+	/* device supports locking according to capabilities page */
+	if (!(tape->caps[6] & 0x01))
 		return 0;
 
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_PREVENT_CMD;
+	pc->c[0] = ALLOW_MEDIUM_REMOVAL;
 	pc->c[4] = prevent;
 	pc->callback = &idetape_pc_callback;
 	return 1;
@@ -3072,12 +2368,10 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 	if (tape->debug_level >= 2)
 		printk(KERN_INFO "ide-tape: idetape_queue_rw_tail: cmd=%d\n",cmd);
 #endif /* IDETAPE_DEBUG_LOG */
-#if IDETAPE_DEBUG_BUGS
 	if (idetape_pipeline_active(tape)) {
 		printk(KERN_ERR "ide-tape: bug: the pipeline is active in idetape_queue_rw_tail\n");
 		return (0);
 	}
-#endif /* IDETAPE_DEBUG_BUGS */	
 
 	idetape_init_rq(&rq, cmd);
 	rq.rq_disk = tape->disk;
@@ -3108,7 +2402,7 @@ static void idetape_insert_pipeline_into_queue (ide_drive_t *drive)
 		return;
 	if (!idetape_pipeline_active(tape)) {
 		set_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
-		idetape_active_next_stage(drive);
+		idetape_activate_next_stage(drive);
 		(void) ide_do_drive_cmd(drive, tape->active_data_request, ide_end);
 	}
 }
@@ -3116,7 +2410,7 @@ static void idetape_insert_pipeline_into_queue (ide_drive_t *drive)
 static void idetape_create_inquiry_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_INQUIRY_CMD;
+	pc->c[0] = INQUIRY;
 	pc->c[4] = pc->request_transfer = 254;
 	pc->callback = &idetape_pc_callback;
 }
@@ -3124,28 +2418,15 @@ static void idetape_create_inquiry_cmd (idetape_pc_t *pc)
 static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_REWIND_CMD;
+	pc->c[0] = REZERO_UNIT;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
 }
 
-#if 0
-static void idetape_create_mode_select_cmd (idetape_pc_t *pc, int length)
-{
-	idetape_init_pc(pc);
-	set_bit(PC_WRITING, &pc->flags);
-	pc->c[0] = IDETAPE_MODE_SELECT_CMD;
-	pc->c[1] = 0x10;
-	put_unaligned(htons(length), (unsigned short *) &pc->c[3]);
-	pc->request_transfer = 255;
-	pc->callback = &idetape_pc_callback;
-}
-#endif
-
 static void idetape_create_erase_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_ERASE_CMD;
+	pc->c[0] = ERASE;
 	pc->c[1] = 1;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
@@ -3154,8 +2435,8 @@ static void idetape_create_erase_cmd (idetape_pc_t *pc)
 static void idetape_create_space_cmd (idetape_pc_t *pc,int count, u8 cmd)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_SPACE_CMD;
-	put_unaligned(htonl(count), (unsigned int *) &pc->c[1]);
+	pc->c[0] = SPACE;
+	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
@@ -3275,8 +2556,7 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	idetape_tape_t *tape = drive->driver_data;
 	int blocks, min;
 	struct idetape_bh *bh;
-	
-#if IDETAPE_DEBUG_BUGS
+
 	if (tape->chrdev_direction != idetape_direction_write) {
 		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline, but we are not writing.\n");
 		return;
@@ -3285,7 +2565,6 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
 		tape->merge_stage_size = tape->stage_size;
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 	if (tape->merge_stage_size) {
 		blocks = tape->merge_stage_size / tape->tape_block_size;
 		if (tape->merge_stage_size % tape->tape_block_size) {
@@ -3330,7 +2609,6 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	 *	 can be totally different on the next backup).
 	 */
 	tape->max_stages = tape->min_pipeline;
-#if IDETAPE_DEBUG_BUGS
 	if (tape->first_stage != NULL ||
 	    tape->next_stage != NULL ||
 	    tape->last_stage != NULL ||
@@ -3341,7 +2619,6 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 			tape->first_stage, tape->next_stage,
 			tape->last_stage, tape->nr_stages);
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 }
 
 static void idetape_restart_speed_control (ide_drive_t *drive)
@@ -3364,7 +2641,7 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 	idetape_stage_t *new_stage;
 	struct request rq;
 	int bytes_read;
-	int blocks = tape->capabilities.ctl;
+	u16 blocks = *(u16 *)&tape->caps[12];
 
 	/* Initialize read operation */
 	if (tape->chrdev_direction != idetape_direction_read) {
@@ -3372,12 +2649,10 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 			idetape_empty_write_pipeline(drive);
 			idetape_flush_tape_buffers(drive);
 		}
-#if IDETAPE_DEBUG_BUGS
 		if (tape->merge_stage || tape->merge_stage_size) {
 			printk (KERN_ERR "ide-tape: merge_stage_size should be 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
 			return -ENOMEM;
 		tape->chrdev_direction = idetape_direction_read;
@@ -3478,12 +2753,10 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 		tape->pipeline_head++;
 		calculate_speeds(drive);
 	}
-#if IDETAPE_DEBUG_BUGS
 	if (bytes_read > blocks * tape->tape_block_size) {
 		printk(KERN_ERR "ide-tape: bug: trying to return more bytes than requested\n");
 		bytes_read = blocks * tape->tape_block_size;
 	}
-#endif /* IDETAPE_DEBUG_BUGS */
 	return (bytes_read);
 }
 
@@ -3567,16 +2840,21 @@ static int idetape_rewind_tape (ide_drive_t *drive)
 static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_config_t config;
 	void __user *argp = (void __user *)arg;
 
+	struct idetape_config {
+		int dsc_rw_frequency;
+		int dsc_media_access_frequency;
+		int nr_stages;
+	} config;
+
 #if IDETAPE_DEBUG_LOG	
 	if (tape->debug_level >= 4)
 		printk(KERN_INFO "ide-tape: Reached idetape_blkdev_ioctl\n");
 #endif /* IDETAPE_DEBUG_LOG */
 	switch (cmd) {
 		case 0x0340:
-			if (copy_from_user(&config, argp, sizeof (idetape_config_t)))
+			if (copy_from_user(&config, argp, sizeof(config)))
 				return -EFAULT;
 			tape->best_dsc_rw_frequency = config.dsc_rw_frequency;
 			tape->max_stages = config.nr_stages;
@@ -3584,7 +2862,7 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
 		case 0x0350:
 			config.dsc_rw_frequency = (int) tape->best_dsc_rw_frequency;
 			config.nr_stages = tape->max_stages; 
-			if (copy_to_user(argp, &config, sizeof (idetape_config_t)))
+			if (copy_to_user(argp, &config, sizeof(config)))
 				return -EFAULT;
 			break;
 		default:
@@ -3608,11 +2886,12 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 	idetape_pc_t pc;
 	unsigned long flags;
 	int retval,count=0;
+	int sprev = !!(tape->caps[4] & 0x20);
 
 	if (mt_count == 0)
 		return 0;
 	if (MTBSF == mt_op || MTBSFM == mt_op) {
-		if (!tape->capabilities.sprev)
+		if (!sprev)
 			return -EIO;
 		mt_count = - mt_count;
 	}
@@ -3666,7 +2945,7 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 			return (idetape_queue_pc_tail(drive, &pc));
 		case MTFSFM:
 		case MTBSFM:
-			if (!tape->capabilities.sprev)
+			if (!sprev)
 				return (-EIO);
 			retval = idetape_space_over_filemarks(drive, MTFSF, mt_count-count);
 			if (retval) return (retval);
@@ -3703,6 +2982,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 	ide_drive_t *drive = tape->drive;
 	ssize_t bytes_read,temp, actually_read = 0, rc;
 	ssize_t ret = 0;
+	u16 ctl = *(u16 *)&tape->caps[12];
 
 #if IDETAPE_DEBUG_LOG
 	if (tape->debug_level >= 3)
@@ -3728,7 +3008,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		count -= actually_read;
 	}
 	while (count >= tape->stage_size) {
-		bytes_read = idetape_add_chrdev_read_request(drive, tape->capabilities.ctl);
+		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
 		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, bytes_read))
@@ -3738,7 +3018,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		actually_read += bytes_read;
 	}
 	if (count) {
-		bytes_read = idetape_add_chrdev_read_request(drive, tape->capabilities.ctl);
+		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
 		temp = min((unsigned long)count, (unsigned long)bytes_read);
@@ -3767,6 +3047,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	ide_drive_t *drive = tape->drive;
 	ssize_t actually_written = 0;
 	ssize_t ret = 0;
+	u16 ctl = *(u16 *)&tape->caps[12];
 
 	/* The drive is write protected. */
 	if (tape->write_prot)
@@ -3782,13 +3063,11 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	if (tape->chrdev_direction != idetape_direction_write) {
 		if (tape->chrdev_direction == idetape_direction_read)
 			idetape_discard_read_pipeline(drive, 1);
-#if IDETAPE_DEBUG_BUGS
 		if (tape->merge_stage || tape->merge_stage_size) {
 			printk(KERN_ERR "ide-tape: merge_stage_size "
 				"should be 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
 			return -ENOMEM;
 		tape->chrdev_direction = idetape_direction_write;
@@ -3816,12 +3095,10 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	if (tape->restart_speed_control_req)
 		idetape_restart_speed_control(drive);
 	if (tape->merge_stage_size) {
-#if IDETAPE_DEBUG_BUGS
 		if (tape->merge_stage_size >= tape->stage_size) {
 			printk(KERN_ERR "ide-tape: bug: merge buffer too big\n");
 			tape->merge_stage_size = 0;
 		}
-#endif /* IDETAPE_DEBUG_BUGS */
 		actually_written = min((unsigned int)(tape->stage_size - tape->merge_stage_size), (unsigned int)count);
 		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, actually_written))
 				ret = -EFAULT;
@@ -3832,7 +3109,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 		if (tape->merge_stage_size == tape->stage_size) {
 			ssize_t retval;
 			tape->merge_stage_size = 0;
-			retval = idetape_add_chrdev_write_request(drive, tape->capabilities.ctl);
+			retval = idetape_add_chrdev_write_request(drive, ctl);
 			if (retval <= 0)
 				return (retval);
 		}
@@ -3843,7 +3120,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 			ret = -EFAULT;
 		buf += tape->stage_size;
 		count -= tape->stage_size;
-		retval = idetape_add_chrdev_write_request(drive, tape->capabilities.ctl);
+		retval = idetape_add_chrdev_write_request(drive, ctl);
 		actually_written += tape->stage_size;
 		if (retval <= 0)
 			return (retval);
@@ -3871,69 +3148,20 @@ static int idetape_write_filemark (ide_drive_t *drive)
 }
 
 /*
- *	idetape_mtioctop is called from idetape_chrdev_ioctl when
- *	the general mtio MTIOCTOP ioctl is requested.
- *
- *	We currently support the following mtio.h operations:
+ * Called from idetape_chrdev_ioctl when the general mtio MTIOCTOP ioctl is
+ * requested.
  *
- *	MTFSF	-	Space over mt_count filemarks in the positive direction.
- *			The tape is positioned after the last spaced filemark.
+ * Note: MTBSF and MTBSFM are not supported when the tape doesn't support
+ * spacing over filemarks in the reverse direction. In this case, MTFSFM is also
+ * usually not supported (it is supported in the rare case in which we crossed
+ * the filemark during our read-ahead pipelined operation mode).
  *
- *	MTFSFM	-	Same as MTFSF, but the tape is positioned before the
- *			last filemark.
+ * The following commands are currently not supported:
  *
- *	MTBSF	-	Steps background over mt_count filemarks, tape is
- *			positioned before the last filemark.
- *
- *	MTBSFM	-	Like MTBSF, only tape is positioned after the last filemark.
- *
- *	Note:
- *
- *		MTBSF and MTBSFM are not supported when the tape doesn't
- *		support spacing over filemarks in the reverse direction.
- *		In this case, MTFSFM is also usually not supported (it is
- *		supported in the rare case in which we crossed the filemark
- *		during our read-ahead pipelined operation mode).
- *		
- *	MTWEOF	-	Writes mt_count filemarks. Tape is positioned after
- *			the last written filemark.
- *
- *	MTREW	-	Rewinds tape.
- *
- *	MTLOAD	-	Loads the tape.
- *
- *	MTOFFL	-	Puts the tape drive "Offline": Rewinds the tape and
- *	MTUNLOAD	prevents further access until the media is replaced.
- *
- *	MTNOP	-	Flushes tape buffers.
- *
- *	MTRETEN	-	Retension media. This typically consists of one end
- *			to end pass on the media.
- *
- *	MTEOM	-	Moves to the end of recorded data.
- *
- *	MTERASE	-	Erases tape.
- *
- *	MTSETBLK - 	Sets the user block size to mt_count bytes. If
- *			mt_count is 0, we will attempt to autodetect
- *			the block size.
- *
- *	MTSEEK	-	Positions the tape in a specific block number, where
- *			each block is assumed to contain which user_block_size
- *			bytes.
- *
- *	MTSETPART - 	Switches to another tape partition.
- *
- *	MTLOCK - 	Locks the tape door.
- *
- *	MTUNLOCK - 	Unlocks the tape door.
- *
- *	The following commands are currently not supported:
- *
- *	MTFSS, MTBSS, MTWSM, MTSETDENSITY,
- *	MTSETDRVBUFFER, MT_ST_BOOLEANS, MT_ST_WRITE_THRESHOLD.
+ * MTFSS, MTBSS, MTWSM, MTSETDENSITY, MTSETDRVBUFFER, MT_ST_BOOLEANS,
+ * MT_ST_WRITE_THRESHOLD.
  */
-static int idetape_mtioctop (ide_drive_t *drive,short mt_op,int mt_count)
+static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
@@ -4048,29 +3276,12 @@ static int idetape_mtioctop (ide_drive_t *drive,short mt_op,int mt_count)
 }
 
 /*
- *	Our character device ioctls.
- *
- *	General mtio.h magnetic io commands are supported here, and not in
- *	the corresponding block interface.
- *
- *	The following ioctls are supported:
- *
- *	MTIOCTOP -	Refer to idetape_mtioctop for detailed description.
- *
- *	MTIOCGET - 	The mt_dsreg field in the returned mtget structure
- *			will be set to (user block size in bytes <<
- *			MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK.
- *
- *			The mt_blkno is set to the current user block number.
- *			The other mtget fields are not supported.
- *
- *	MTIOCPOS -	The current tape "block position" is returned. We
- *			assume that each block contains user_block_size
- *			bytes.
- *
- *	Our own ide-tape ioctls are supported on both interfaces.
+ * Our character device ioctls. General mtio.h magnetic io commands are
+ * supported here, and not in the corresponding block interface. Our own
+ * ide-tape ioctls are supported on both interfaces.
  */
-static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	struct ide_tape_obj *tape = ide_tape_f(file);
 	ide_drive_t *drive = tape->drive;
@@ -4124,7 +3335,30 @@ static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigne
 	}
 }
 
-static void idetape_get_blocksize_from_block_descriptor(ide_drive_t *drive);
+/*
+ * Do a mode sense page 0 with block descriptor and if it succeeds set the tape
+ * block size with the reported value.
+ */
+static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
+{
+	idetape_tape_t *tape = drive->driver_data;
+	idetape_pc_t pc;
+
+	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
+	if (idetape_queue_pc_tail(drive, &pc)) {
+		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
+		if (tape->tape_block_size == 0) {
+			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
+					    "block size, assuming 32k\n");
+			tape->tape_block_size = 32768;
+		}
+		return;
+	}
+	tape->tape_block_size = (pc.buffer[4 + 5] << 16) +
+				(pc.buffer[4 + 6] << 8)  +
+				 pc.buffer[4 + 7];
+	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
+}
 
 /*
  *	Our character device open function.
@@ -4178,7 +3412,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 		clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
 
 	/* Read block size and write protect status from drive. */
-	idetape_get_blocksize_from_block_descriptor(drive);
+	ide_tape_get_bsize_from_bdesc(drive);
 
 	/* Set write protect flag if device is opened as read-only. */
 	if ((filp->f_flags & O_ACCMODE) == O_RDONLY)
@@ -4296,190 +3530,100 @@ static int idetape_identify_device (ide_drive_t *drive)
 
 	*((unsigned short *) &gcw) = id->config;
 
-#if IDETAPE_DEBUG_INFO
-	printk(KERN_INFO "ide-tape: Dumping ATAPI Identify Device tape parameters\n");
-	printk(KERN_INFO "ide-tape: Protocol Type: ");
-	switch (gcw.protocol) {
-		case 0: case 1: printk("ATA\n");break;
-		case 2:	printk("ATAPI\n");break;
-		case 3: printk("Reserved (Unknown to ide-tape)\n");break;
-	}
-	printk(KERN_INFO "ide-tape: Device Type: %x - ",gcw.device_type);	
-	switch (gcw.device_type) {
-		case 0: printk("Direct-access Device\n");break;
-		case 1: printk("Streaming Tape Device\n");break;
-		case 2: case 3: case 4: printk("Reserved\n");break;
-		case 5: printk("CD-ROM Device\n");break;
-		case 6: printk("Reserved\n");
-		case 7: printk("Optical memory Device\n");break;
-		case 0x1f: printk("Unknown or no Device type\n");break;
-		default: printk("Reserved\n");
-	}
-	printk(KERN_INFO "ide-tape: Removable: %s",gcw.removable ? "Yes\n":"No\n");	
-	printk(KERN_INFO "ide-tape: Command Packet DRQ Type: ");
-	switch (gcw.drq_type) {
-		case 0: printk("Microprocessor DRQ\n");break;
-		case 1: printk("Interrupt DRQ\n");break;
-		case 2: printk("Accelerated DRQ\n");break;
-		case 3: printk("Reserved\n");break;
-	}
-	printk(KERN_INFO "ide-tape: Command Packet Size: ");
-	switch (gcw.packet_size) {
-		case 0: printk("12 bytes\n");break;
-		case 1: printk("16 bytes\n");break;
-		default: printk("Reserved\n");break;
-	}
-#endif /* IDETAPE_DEBUG_INFO */
-
 	/* Check that we can support this device */
 
-	if (gcw.protocol !=2 )
-		printk(KERN_ERR "ide-tape: Protocol is not ATAPI\n");
+	if (gcw.protocol != 2)
+		printk(KERN_ERR "ide-tape: Protocol (0x%02x) is not ATAPI\n",
+				gcw.protocol);
 	else if (gcw.device_type != 1)
-		printk(KERN_ERR "ide-tape: Device type is not set to tape\n");
+		printk(KERN_ERR "ide-tape: Device type (0x%02x) is not set "
+				"to tape\n", gcw.device_type);
 	else if (!gcw.removable)
 		printk(KERN_ERR "ide-tape: The removable flag is not set\n");
 	else if (gcw.packet_size != 0) {
-		printk(KERN_ERR "ide-tape: Packet size is not 12 bytes long\n");
-		if (gcw.packet_size == 1)
-			printk(KERN_ERR "ide-tape: Sorry, padding to 16 bytes is still not supported\n");
+		printk(KERN_ERR "ide-tape: Packet size (0x%02x) is not 12 "
+				"bytes long\n", gcw.packet_size);
 	} else
 		return 1;
 	return 0;
 }
 
-/*
- * Use INQUIRY to get the firmware revision
- */
-static void idetape_get_inquiry_results (ide_drive_t *drive)
+static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
 	char *r;
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
-	idetape_inquiry_result_t *inquiry;
-	
+
 	idetape_create_inquiry_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc)) {
-		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n", tape->name);
+		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
+				tape->name);
 		return;
 	}
-	inquiry = (idetape_inquiry_result_t *) pc.buffer;
-	memcpy(tape->vendor_id, inquiry->vendor_id, 8);
-	memcpy(tape->product_id, inquiry->product_id, 16);
-	memcpy(tape->firmware_revision, inquiry->revision_level, 4);
+	memcpy(tape->vendor_id, &pc.buffer[8], 8);
+	memcpy(tape->product_id, &pc.buffer[16], 16);
+	memcpy(tape->firmware_revision, &pc.buffer[32], 4);
+
 	ide_fixstring(tape->vendor_id, 10, 0);
 	ide_fixstring(tape->product_id, 18, 0);
 	ide_fixstring(tape->firmware_revision, 6, 0);
 	r = tape->firmware_revision;
 	if (*(r + 1) == '.')
-		tape->firmware_revision_num = (*r - '0') * 100 + (*(r + 2) - '0') * 10 + *(r + 3) - '0';
-	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n", drive->name, tape->name, tape->vendor_id, tape->product_id, tape->firmware_revision);
+		tape->firmware_revision_num = (*r - '0') * 100 +
+			(*(r + 2) - '0') * 10 +	*(r + 3) - '0';
+	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
+			drive->name, tape->name, tape->vendor_id,
+			tape->product_id, tape->firmware_revision);
 }
 
 /*
- *	idetape_get_mode_sense_results asks the tape about its various
- *	parameters. In particular, we will adjust our data transfer buffer
- *	size to the recommended value as returned by the tape.
+ * Ask the tape about its various parameters. In particular, we will adjust our
+ * data transfer buffer	size to the recommended value as returned by the tape.
  */
 static void idetape_get_mode_sense_results (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
-	idetape_mode_parameter_header_t *header;
-	idetape_capabilities_page_t *capabilities;
-	
+	u8 *caps;
+	u8 speed, max_speed;
+
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
 	if (idetape_queue_pc_tail(drive, &pc)) {
-		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming some default values\n");
+		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
+				" some default values\n");
 		tape->tape_block_size = 512;
-		tape->capabilities.ctl = 52;
-		tape->capabilities.speed = 450;
-		tape->capabilities.buffer_size = 6 * 52;
+		put_unaligned(52,   (u16 *)&tape->caps[12]);
+		put_unaligned(540,  (u16 *)&tape->caps[14]);
+		put_unaligned(6*52, (u16 *)&tape->caps[16]);
 		return;
 	}
-	header = (idetape_mode_parameter_header_t *) pc.buffer;
-	capabilities = (idetape_capabilities_page_t *) (pc.buffer + sizeof(idetape_mode_parameter_header_t) + header->bdl);
+	caps = pc.buffer + 4 + pc.buffer[3];
 
-	capabilities->max_speed = ntohs(capabilities->max_speed);
-	capabilities->ctl = ntohs(capabilities->ctl);
-	capabilities->speed = ntohs(capabilities->speed);
-	capabilities->buffer_size = ntohs(capabilities->buffer_size);
+	/* convert to host order and save for later use */
+	speed = be16_to_cpu(*(u16 *)&caps[14]);
+	max_speed = be16_to_cpu(*(u16 *)&caps[8]);
 
-	if (!capabilities->speed) {
-		printk(KERN_INFO "ide-tape: %s: overriding capabilities->speed (assuming 650KB/sec)\n", drive->name);
-		capabilities->speed = 650;
+	put_unaligned(max_speed, (u16 *)&caps[8]);
+	put_unaligned(be16_to_cpu(*(u16 *)&caps[12]), (u16 *)&caps[12]);
+	put_unaligned(speed, (u16 *)&caps[14]);
+	put_unaligned(be16_to_cpu(*(u16 *)&caps[16]), (u16 *)&caps[16]);
+
+	if (!speed) {
+		printk(KERN_INFO "ide-tape: %s: invalid tape speed "
+				"(assuming 650KB/sec)\n", drive->name);
+		put_unaligned(650, (u16 *)&caps[14]);
 	}
-	if (!capabilities->max_speed) {
-		printk(KERN_INFO "ide-tape: %s: overriding capabilities->max_speed (assuming 650KB/sec)\n", drive->name);
-		capabilities->max_speed = 650;
+	if (!max_speed) {
+		printk(KERN_INFO "ide-tape: %s: invalid max_speed "
+				"(assuming 650KB/sec)\n", drive->name);
+		put_unaligned(650, (u16 *)&caps[8]);
 	}
 
-	tape->capabilities = *capabilities;		/* Save us a copy */
-	if (capabilities->blk512)
+	memcpy(&tape->caps, caps, 20);
+	if (caps[7] & 0x02)
 		tape->tape_block_size = 512;
-	else if (capabilities->blk1024)
+	else if (caps[7] & 0x04)
 		tape->tape_block_size = 1024;
-
-#if IDETAPE_DEBUG_INFO
-	printk(KERN_INFO "ide-tape: Dumping the results of the MODE SENSE packet command\n");
-	printk(KERN_INFO "ide-tape: Mode Parameter Header:\n");
-	printk(KERN_INFO "ide-tape: Mode Data Length - %d\n",header->mode_data_length);
-	printk(KERN_INFO "ide-tape: Medium Type - %d\n",header->medium_type);
-	printk(KERN_INFO "ide-tape: Device Specific Parameter - %d\n",header->dsp);
-	printk(KERN_INFO "ide-tape: Block Descriptor Length - %d\n",header->bdl);
-	
-	printk(KERN_INFO "ide-tape: Capabilities and Mechanical Status Page:\n");
-	printk(KERN_INFO "ide-tape: Page code - %d\n",capabilities->page_code);
-	printk(KERN_INFO "ide-tape: Page length - %d\n",capabilities->page_length);
-	printk(KERN_INFO "ide-tape: Read only - %s\n",capabilities->ro ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Supports reverse space - %s\n",capabilities->sprev ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Supports erase initiated formatting - %s\n",capabilities->efmt ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Supports QFA two Partition format - %s\n",capabilities->qfa ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Supports locking the medium - %s\n",capabilities->lock ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: The volume is currently locked - %s\n",capabilities->locked ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: The device defaults in the prevent state - %s\n",capabilities->prevent ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Supports ejecting the medium - %s\n",capabilities->eject ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Supports error correction - %s\n",capabilities->ecc ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Supports data compression - %s\n",capabilities->cmprs ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Supports 512 bytes block size - %s\n",capabilities->blk512 ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Supports 1024 bytes block size - %s\n",capabilities->blk1024 ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Supports 32768 bytes block size / Restricted byte count for PIO transfers - %s\n",capabilities->blk32768 ? "Yes":"No");
-	printk(KERN_INFO "ide-tape: Maximum supported speed in KBps - %d\n",capabilities->max_speed);
-	printk(KERN_INFO "ide-tape: Continuous transfer limits in blocks - %d\n",capabilities->ctl);
-	printk(KERN_INFO "ide-tape: Current speed in KBps - %d\n",capabilities->speed);	
-	printk(KERN_INFO "ide-tape: Buffer size - %d\n",capabilities->buffer_size*512);
-#endif /* IDETAPE_DEBUG_INFO */
-}
-
-/*
- *	ide_get_blocksize_from_block_descriptor does a mode sense page 0 with block descriptor
- *	and if it succeeds sets the tape block size with the reported value
- */
-static void idetape_get_blocksize_from_block_descriptor(ide_drive_t *drive)
-{
-
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
-	idetape_mode_parameter_header_t *header;
-	idetape_parameter_block_descriptor_t *block_descrp;
-	
-	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
-	if (idetape_queue_pc_tail(drive, &pc)) {
-		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
-		if (tape->tape_block_size == 0) {
-			printk(KERN_WARNING "ide-tape: Cannot deal with zero block size, assume 32k\n");
-			tape->tape_block_size =  32768;
-		}
-		return;
-	}
-	header = (idetape_mode_parameter_header_t *) pc.buffer;
-	block_descrp = (idetape_parameter_block_descriptor_t *) (pc.buffer + sizeof(idetape_mode_parameter_header_t));
-	tape->tape_block_size =( block_descrp->length[0]<<16) + (block_descrp->length[1]<<8) + block_descrp->length[2];
-	tape->drv_write_prot = (header->dsp & 0x80) >> 7;
-
-#if IDETAPE_DEBUG_INFO
-	printk(KERN_INFO "ide-tape: Adjusted block size - %d\n", tape->tape_block_size);
-#endif /* IDETAPE_DEBUG_INFO */
 }
 
 #ifdef CONFIG_IDE_PROC_FS
@@ -4490,13 +3634,15 @@ static void idetape_add_settings (ide_drive_t *drive)
 /*
  *			drive	setting name		read/write	data type	min			max			mul_factor			div_factor	data pointer				set function
  */
-	ide_add_setting(drive,	"buffer",		SETTING_READ,	TYPE_SHORT,	0,			0xffff,			1,				2,		&tape->capabilities.buffer_size,	NULL);
+	ide_add_setting(drive, "buffer", SETTING_READ, TYPE_SHORT, 0, 0xffff,
+			1, 2, (u16 *)&tape->caps[16], NULL);
 	ide_add_setting(drive,	"pipeline_min",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->min_pipeline,			NULL);
 	ide_add_setting(drive,	"pipeline",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_stages,			NULL);
 	ide_add_setting(drive,	"pipeline_max",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_pipeline,			NULL);
 	ide_add_setting(drive,	"pipeline_used",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_stages,			NULL);
 	ide_add_setting(drive,	"pipeline_pending",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_pending_stages,		NULL);
-	ide_add_setting(drive,	"speed",		SETTING_READ,	TYPE_SHORT,	0,			0xffff,			1,				1,		&tape->capabilities.speed,		NULL);
+	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
+			1, 1, (u16 *)&tape->caps[14], NULL);
 	ide_add_setting(drive,	"stage",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1024,		&tape->stage_size,			NULL);
 	ide_add_setting(drive,	"tdsc",			SETTING_RW,	TYPE_INT,	IDETAPE_DSC_RW_MIN,	IDETAPE_DSC_RW_MAX,	1000,				HZ,		&tape->best_dsc_rw_frequency,		NULL);
 	ide_add_setting(drive,	"dsc_overlap",		SETTING_RW,	TYPE_BYTE,	0,			1,			1,				1,		&drive->dsc_overlap,			NULL);
@@ -4528,6 +3674,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	struct idetape_id_gcw gcw;
 	int stage_size;
 	struct sysinfo si;
+	u16 *ctl = (u16 *)&tape->caps[12];
 
 	spin_lock_init(&tape->spinlock);
 	drive->dsc_overlap = 1;
@@ -4555,13 +3702,13 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
-	idetape_get_blocksize_from_block_descriptor(drive);
+	ide_tape_get_bsize_from_bdesc(drive);
 	tape->user_bs_factor = 1;
-	tape->stage_size = tape->capabilities.ctl * tape->tape_block_size;
+	tape->stage_size = *ctl * tape->tape_block_size;
 	while (tape->stage_size > 0xffff) {
 		printk(KERN_NOTICE "ide-tape: decreasing stage size\n");
-		tape->capabilities.ctl /= 2;
-		tape->stage_size = tape->capabilities.ctl * tape->tape_block_size;
+		*ctl /= 2;
+		tape->stage_size = *ctl * tape->tape_block_size;
 	}
 	stage_size = tape->stage_size;
 	tape->pages_per_stage = stage_size / PAGE_SIZE;
@@ -4570,11 +3717,8 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		tape->excess_bh_size = PAGE_SIZE - stage_size % PAGE_SIZE;
 	}
 
-	/*
-	 *	Select the "best" DSC read/write polling frequency
-	 *	and pipeline size.
-	 */
-	speed = max(tape->capabilities.speed, tape->capabilities.max_speed);
+	/* Select the "best" DSC read/write polling freq and pipeline size. */
+	speed = max(*(u16 *)&tape->caps[14], *(u16 *)&tape->caps[8]);
 
 	tape->max_stages = speed * 1000 * 10 / tape->stage_size;
 
@@ -4591,7 +3735,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		tape->max_stages = tape->min_pipeline = tape->max_pipeline = 1;
 
 	t1 = (tape->stage_size * HZ) / (speed * 1000);
-	tmid = (tape->capabilities.buffer_size * 32 * HZ) / (speed * 125);
+	tmid = (*(u16 *)&tape->caps[16] * 32 * HZ) / (speed * 125);
 	tn = (IDETAPE_FIFO_THRESHOLD * tape->stage_size * HZ) / (speed * 1000);
 
 	if (tape->max_stages)
@@ -4606,8 +3750,8 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->best_dsc_rw_frequency = max_t(unsigned long, min_t(unsigned long, t, IDETAPE_DSC_RW_MAX), IDETAPE_DSC_RW_MIN);
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%dkB pipeline, %lums tDSC%s\n",
-		drive->name, tape->name, tape->capabilities.speed,
-		(tape->capabilities.buffer_size * 512) / tape->stage_size,
+		drive->name, tape->name, *(u16 *)&tape->caps[14],
+		(*(u16 *)&tape->caps[16] * 512) / tape->stage_size,
 		tape->stage_size / 1024,
 		tape->max_stages * tape->stage_size / 1024,
 		tape->best_dsc_rw_frequency * 1000 / HZ,
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 16a9a58..4e1da1c 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -755,6 +755,7 @@ int ide_cmd_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 	u8 args[4], xfer_rate = 0;
 	ide_task_t tfargs;
 	struct ide_taskfile *tf = &tfargs.tf;
+	struct hd_driveid *id = drive->id;
 
 	if (NULL == (void *) arg) {
 		struct request rq;
@@ -792,10 +793,16 @@ int ide_cmd_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 			return -ENOMEM;
 	}
 
-	if (set_transfer(drive, &tfargs)) {
+	if (tf->command == WIN_SETFEATURES &&
+	    tf->feature == SETFEATURES_XFER &&
+	    tf->nsect >= XFER_SW_DMA_0 &&
+	    (id->dma_ultra || id->dma_mword || id->dma_1word)) {
 		xfer_rate = args[1];
-		if (ide_ata66_check(drive, &tfargs))
+		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
+			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
+					    "be set\n", drive->name);
 			goto abort;
+		}
 	}
 
 	err = ide_raw_taskfile(drive, &tfargs, buf, args[3]);
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index ab9ca2b..ac61360 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -499,6 +499,8 @@ void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 /**
  *	ide_unregister		-	free an IDE interface
  *	@index: index of interface (will change soon to a pointer)
+ *	@init_default: init default hwif flag
+ *	@restore: restore hwif flag
  *
  *	Perform the final unregister of an IDE interface. At the moment
  *	we don't refcount interfaces so this will also get split up.
@@ -518,7 +520,7 @@ void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
  *	This is raving bonkers.
  */
 
-void ide_unregister(unsigned int index)
+void ide_unregister(unsigned int index, int init_default, int restore)
 {
 	ide_drive_t *drive;
 	ide_hwif_t *hwif, *g;
@@ -602,9 +604,12 @@ void ide_unregister(unsigned int index)
 
 	/* restore hwif data to pristine status */
 	ide_init_port_data(hwif, index);
-	init_hwif_default(hwif, index);
 
-	ide_hwif_restore(hwif, &tmp_hwif);
+	if (init_default)
+		init_hwif_default(hwif, index);
+
+	if (restore)
+		ide_hwif_restore(hwif, &tmp_hwif);
 
 abort:
 	spin_unlock_irq(&ide_lock);
@@ -678,6 +683,31 @@ void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 }
 EXPORT_SYMBOL_GPL(ide_init_port_hw);
 
+ide_hwif_t *ide_deprecated_find_port(unsigned long base)
+{
+	ide_hwif_t *hwif;
+	int i;
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		hwif = &ide_hwifs[i];
+		if (hwif->io_ports[IDE_DATA_OFFSET] == base)
+			goto found;
+	}
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		hwif = &ide_hwifs[i];
+		if (hwif->hold)
+			continue;
+		if (!hwif->present && hwif->mate == NULL)
+			goto found;
+	}
+
+	hwif = NULL;
+found:
+	return hwif;
+}
+EXPORT_SYMBOL_GPL(ide_deprecated_find_port);
+
 /**
  *	ide_register_hw		-	register IDE interface
  *	@hw: hardware registers
@@ -697,38 +727,26 @@ int ide_register_hw(hw_regs_t *hw, void (*quirkproc)(ide_drive_t *),
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	do {
-		for (index = 0; index < MAX_HWIFS; ++index) {
-			hwif = &ide_hwifs[index];
-			if (hwif->io_ports[IDE_DATA_OFFSET] == hw->io_ports[IDE_DATA_OFFSET])
-				goto found;
-		}
-		for (index = 0; index < MAX_HWIFS; ++index) {
-			hwif = &ide_hwifs[index];
-			if (hwif->hold)
-				continue;
-			if (!hwif->present && hwif->mate == NULL)
-				goto found;
-		}
+		hwif = ide_deprecated_find_port(hw->io_ports[IDE_DATA_OFFSET]);
+		index = hwif->index;
+		if (hwif)
+			goto found;
 		for (index = 0; index < MAX_HWIFS; index++)
-			ide_unregister(index);
+			ide_unregister(index, 1, 1);
 	} while (retry--);
 	return -1;
 found:
 	if (hwif->present)
-		ide_unregister(index);
-	else if (!hwif->hold) {
+		ide_unregister(index, 0, 1);
+	else if (!hwif->hold)
 		ide_init_port_data(hwif, index);
-		init_hwif_default(hwif, index);
-	}
-	if (hwif->present)
-		return -1;
 
 	ide_init_port_hw(hwif, hw);
 	hwif->quirkproc = quirkproc;
 
 	idx[0] = index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	if (hwifp)
 		*hwifp = hwif;
@@ -791,10 +809,6 @@ int set_io_32bit(ide_drive_t *drive, int arg)
 		return -EBUSY;
 
 	drive->io_32bit = arg;
-#ifdef CONFIG_BLK_DEV_DTC2278
-	if (HWIF(drive)->chipset == ide_dtc2278)
-		HWIF(drive)->drives[!drive->select.b.unit].io_32bit = arg;
-#endif /* CONFIG_BLK_DEV_DTC2278 */
 
 	spin_unlock_irq(&ide_lock);
 
@@ -1021,11 +1035,8 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 		case HDIO_GET_NICE:
 			return put_user(drive->dsc_overlap	<<	IDE_NICE_DSC_OVERLAP	|
 					drive->atapi_overlap	<<	IDE_NICE_ATAPI_OVERLAP	|
-					drive->nice0		<< 	IDE_NICE_0		|
-					drive->nice1		<<	IDE_NICE_1		|
-					drive->nice2		<<	IDE_NICE_2,
+					drive->nice1 << IDE_NICE_1,
 					(long __user *) arg);
-
 #ifdef CONFIG_IDE_TASK_IOCTL
 		case HDIO_DRIVE_TASKFILE:
 		        if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
@@ -1066,7 +1077,7 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 	        case HDIO_UNREGISTER_HWIF:
 			if (!capable(CAP_SYS_RAWIO)) return -EACCES;
 			/* (arg > MAX_HWIFS) checked in function */
-			ide_unregister(arg);
+			ide_unregister(arg, 1, 1);
 			return 0;
 		case HDIO_SET_NICE:
 			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
@@ -1711,7 +1722,7 @@ void __exit cleanup_module (void)
 	int index;
 
 	for (index = 0; index < MAX_HWIFS; ++index)
-		ide_unregister(index);
+		ide_unregister(index, 0, 0);
 
 	proc_ide_destroy();
 
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index e3ea209..d4d1a6b 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -191,9 +191,14 @@ static int __init initRegisters (void) {
 	return t;
 }
 
+static const struct ide_port_info ali14xx_port_info = {
+	.chipset		= ide_ali14xx,
+	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
+	.pio_mask		= ATA_PIO4,
+};
+
 static int __init ali14xx_probe(void)
 {
-	ide_hwif_t *hwif, *mate;
 	static u8 idx[4] = { 0, 1, 0xff, 0xff };
 
 	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
@@ -205,21 +210,10 @@ static int __init ali14xx_probe(void)
 		return 1;
 	}
 
-	hwif = &ide_hwifs[0];
-	mate = &ide_hwifs[1];
-
-	hwif->chipset = ide_ali14xx;
-	hwif->pio_mask = ATA_PIO4;
-	hwif->set_pio_mode = &ali14xx_set_pio_mode;
-	hwif->mate = mate;
-
-	mate->chipset = ide_ali14xx;
-	mate->pio_mask = ATA_PIO4;
-	mate->set_pio_mode = &ali14xx_set_pio_mode;
-	mate->mate = hwif;
-	mate->channel = 1;
+	ide_hwifs[0].set_pio_mode = &ali14xx_set_pio_mode;
+	ide_hwifs[1].set_pio_mode = &ali14xx_set_pio_mode;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &ali14xx_port_info);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index dd3d198..8bdb79d 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -232,7 +232,7 @@ fail_base2:
 			}
 		}
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 	}
 
 	return 0;
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index 611c970..73396f7 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -84,14 +84,20 @@ static void dtc2278_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		/* Actually we do - there is a data sheet available for the
 		   Winbond but does anyone actually care */
 	}
-
-	/*
-	 * 32bit I/O has to be enabled for *both* drives at the same time.
-	 */
-	drive->io_32bit = 1;
-	HWIF(drive)->drives[!drive->select.b.unit].io_32bit = 1;
 }
 
+static const struct ide_port_info dtc2278_port_info __initdata = {
+	.chipset		= ide_dtc2278,
+	.host_flags		= IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_NO_UNMASK_IRQS |
+				  IDE_HFLAG_IO_32BIT |
+				  /* disallow ->io_32bit changes */
+				  IDE_HFLAG_NO_IO_32BIT |
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_NO_AUTOTUNE,
+	.pio_mask		= ATA_PIO4,
+};
+
 static int __init dtc2278_probe(void)
 {
 	unsigned long flags;
@@ -122,23 +128,9 @@ static int __init dtc2278_probe(void)
 #endif
 	local_irq_restore(flags);
 
-	hwif->serialized = 1;
-	hwif->chipset = ide_dtc2278;
-	hwif->pio_mask = ATA_PIO4;
 	hwif->set_pio_mode = &dtc2278_set_pio_mode;
-	hwif->drives[0].no_unmask = 1;
-	hwif->drives[1].no_unmask = 1;
-	hwif->mate = mate;
-
-	mate->serialized = 1;
-	mate->chipset = ide_dtc2278;
-	mate->pio_mask = ATA_PIO4;
-	mate->drives[0].no_unmask = 1;
-	mate->drives[1].no_unmask = 1;
-	mate->mate = hwif;
-	mate->channel = 1;
-
-	ide_device_add(idx);
+
+	ide_device_add(idx, &dtc2278_port_info);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index c9bd6bf..85b69a8 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -83,7 +83,7 @@ static int __init falconide_init(void)
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 	}
     }
 
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index f67c51a..fc29ce7 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -186,7 +186,7 @@ found:
 	    release_mem_region(res_start, res_n);
     }
 
-    ide_device_add(idx);
+    ide_device_add(idx, NULL);
 
     return 0;
 }
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 57bc15c..02d12c7 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -300,16 +300,36 @@ static void ht6560b_set_pio_mode(ide_drive_t *drive, const u8 pio)
 #endif
 }
 
+static void __init ht6560b_port_init_devs(ide_hwif_t *hwif)
+{
+	/* Setting default configurations for drives. */
+	int t = (HT_CONFIG_DEFAULT << 8) | HT_TIMING_DEFAULT;
+
+	if (hwif->channel)
+		t |= (HT_SECONDARY_IF << 8);
+
+	hwif->drives[0].drive_data = t;
+	hwif->drives[1].drive_data = t;
+}
+
 int probe_ht6560b = 0;
 
 module_param_named(probe, probe_ht6560b, bool, 0);
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
 
+static const struct ide_port_info ht6560b_port_info __initdata = {
+	.chipset		= ide_ht6560b,
+	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_NO_AUTOTUNE |
+				  IDE_HFLAG_ABUSE_PREFETCH,
+	.pio_mask		= ATA_PIO5,
+};
+
 static int __init ht6560b_init(void)
 {
 	ide_hwif_t *hwif, *mate;
 	static u8 idx[4] = { 0, 1, 0xff, 0xff };
-	int t;
 
 	if (probe_ht6560b == 0)
 		return -ENODEV;
@@ -328,36 +348,16 @@ static int __init ht6560b_init(void)
 		goto release_region;
 	}
 
-	hwif->chipset = ide_ht6560b;
 	hwif->selectproc = &ht6560b_selectproc;
-	hwif->host_flags = IDE_HFLAG_ABUSE_PREFETCH;
-	hwif->pio_mask = ATA_PIO5;
 	hwif->set_pio_mode = &ht6560b_set_pio_mode;
-	hwif->serialized = 1;	/* is this needed? */
-	hwif->mate = mate;
 
-	mate->chipset = ide_ht6560b;
 	mate->selectproc = &ht6560b_selectproc;
-	mate->host_flags = IDE_HFLAG_ABUSE_PREFETCH;
-	mate->pio_mask = ATA_PIO5;
 	mate->set_pio_mode = &ht6560b_set_pio_mode;
-	mate->serialized = 1;	/* is this needed? */
-	mate->mate = hwif;
-	mate->channel = 1;
-
-	/*
-	 * Setting default configurations for drives
-	 */
-	t = (HT_CONFIG_DEFAULT << 8);
-	t |= HT_TIMING_DEFAULT;
-	hwif->drives[0].drive_data = t;
-	hwif->drives[1].drive_data = t;
 
-	t |= (HT_SECONDARY_IF << 8);
-	mate->drives[0].drive_data = t;
-	mate->drives[1].drive_data = t;
+	hwif->port_init_devs = ht6560b_port_init_devs;
+	mate->port_init_devs = ht6560b_port_init_devs;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &ht6560b_port_info);
 
 	return 0;
 
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index 3bd2967..15ccf69 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -145,13 +145,36 @@ static void ide_detach(struct pcmcia_device *link)
 
 static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq, struct pcmcia_device *handle)
 {
+    ide_hwif_t *hwif;
     hw_regs_t hw;
+    int i;
+    u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+
     memset(&hw, 0, sizeof(hw));
-    ide_init_hwif_ports(&hw, io, ctl, NULL);
+    ide_std_init_ports(&hw, io, ctl);
     hw.irq = irq;
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
-    return ide_register_hw(&hw, &ide_undecoded_slave, NULL);
+
+    hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+    if (hwif == NULL)
+	return -1;
+
+    i = hwif->index;
+
+    if (hwif->present)
+	ide_unregister(i, 0, 0);
+    else if (!hwif->hold)
+	ide_init_port_data(hwif, i);
+
+    ide_init_port_hw(hwif, &hw);
+    hwif->quirkproc = &ide_undecoded_slave;
+
+    idx[0] = i;
+
+    ide_device_add(idx, NULL);
+
+    return hwif->present ? i : -1;
 }
 
 /*======================================================================
@@ -337,7 +360,7 @@ void ide_release(struct pcmcia_device *link)
     if (info->ndev) {
 	/* FIXME: if this fails we need to queue the cleanup somehow
 	   -- need to investigate the required PCMCIA magic */
-	ide_unregister(info->hd);
+	ide_unregister(info->hd, 0, 0);
     }
     info->ndev = 0;
 
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index 7c3231a..26c82ce 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -108,7 +108,7 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	platform_set_drvdata(pdev, hwif);
 
@@ -122,7 +122,7 @@ static int __devexit plat_ide_remove(struct platform_device *pdev)
 {
 	ide_hwif_t *hwif = pdev->dev.driver_data;
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif->index, 0, 0);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index c54d07f..06df8df 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -123,19 +123,9 @@ static int __init macide_init(void)
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
-		if (macintosh_config->ide_type == MAC_IDE_BABOON &&
-		    macintosh_config->ident == MAC_MODEL_PB190) {
-			/* Fix breakage in ide-disk.c: drive capacity	*/
-			/* is not initialized for drives without a 	*/
-			/* hardware ID, and we can't get that without	*/
-			/* probing the drive which freezes a 190.	*/
-			ide_drive_t *drive = &hwif->drives[0];
-			drive->capacity64 = drive->cyl*drive->head*drive->sect;
-		}
-
 		hwif->mmio = 1;
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 	}
 
 	return 0;
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index a9c6b06..2f0b34d 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -154,7 +154,7 @@ static int __init q40ide_init(void)
 	}
     }
 
-    ide_device_add(idx);
+    ide_device_add(idx, NULL);
 
     return 0;
 }
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 37534bb..bba29df 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -305,18 +305,33 @@ static int __init qd_testreg(int port)
  * called to setup an ata channel : adjusts attributes & links for tuning
  */
 
-static void __init qd_setup(ide_hwif_t *hwif, int base, int config,
-			    unsigned int data0, unsigned int data1)
+static void __init qd_setup(ide_hwif_t *hwif, int base, int config)
 {
-	hwif->chipset = ide_qd65xx;
-	hwif->channel = hwif->index;
 	hwif->select_data = base;
 	hwif->config_data = config;
-	hwif->drives[0].drive_data = data0;
-	hwif->drives[1].drive_data = data1;
-	hwif->drives[0].io_32bit =
-	hwif->drives[1].io_32bit = 1;
-	hwif->pio_mask = ATA_PIO4;
+}
+
+static void __init qd6500_port_init_devs(ide_hwif_t *hwif)
+{
+	u8 base = hwif->select_data, config = QD_CONFIG(hwif);
+
+	hwif->drives[0].drive_data = QD6500_DEF_DATA;
+	hwif->drives[1].drive_data = QD6500_DEF_DATA;
+}
+
+static void __init qd6580_port_init_devs(ide_hwif_t *hwif)
+{
+	u16 t1, t2;
+	u8 base = hwif->select_data, config = QD_CONFIG(hwif);
+
+	if (QD_CONTROL(hwif) & QD_CONTR_SEC_DISABLED) {
+		t1 = QD6580_DEF_DATA;
+		t2 = QD6580_DEF_DATA2;
+	} else
+		t2 = t1 = hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA;
+
+	hwif->drives[0].drive_data = t1;
+	hwif->drives[1].drive_data = t2;
 }
 
 /*
@@ -356,6 +371,14 @@ static void __exit qd_unsetup(ide_hwif_t *hwif)
 }
 */
 
+static const struct ide_port_info qd65xx_port_info __initdata = {
+	.chipset		= ide_qd65xx,
+	.host_flags		= IDE_HFLAG_IO_32BIT |
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_NO_AUTOTUNE,
+	.pio_mask		= ATA_PIO4,
+};
+
 /*
  * qd_probe:
  *
@@ -393,13 +416,14 @@ static int __init qd_probe(int base)
 			return 1;
 		}
 
-		qd_setup(hwif, base, config, QD6500_DEF_DATA, QD6500_DEF_DATA);
+		qd_setup(hwif, base, config);
 
+		hwif->port_init_devs = qd6500_port_init_devs;
 		hwif->set_pio_mode = &qd6500_set_pio_mode;
 
-		idx[0] = unit;
+		idx[unit] = unit;
 
-		ide_device_add(idx);
+		ide_device_add(idx, &qd65xx_port_info);
 
 		return 1;
 	}
@@ -426,14 +450,15 @@ static int __init qd_probe(int base)
 			hwif = &ide_hwifs[unit];
 			printk(KERN_INFO "%s: qd6580: single IDE board\n",
 					 hwif->name);
-			qd_setup(hwif, base, config | (control << 8),
-				 QD6580_DEF_DATA, QD6580_DEF_DATA2);
 
+			qd_setup(hwif, base, config | (control << 8));
+
+			hwif->port_init_devs = qd6580_port_init_devs;
 			hwif->set_pio_mode = &qd6580_set_pio_mode;
 
-			idx[0] = unit;
+			idx[unit] = unit;
 
-			ide_device_add(idx);
+			ide_device_add(idx, &qd65xx_port_info);
 
 			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
 
@@ -447,20 +472,20 @@ static int __init qd_probe(int base)
 			printk(KERN_INFO "%s&%s: qd6580: dual IDE board\n",
 					hwif->name, mate->name);
 
-			qd_setup(hwif, base, config | (control << 8),
-				 QD6580_DEF_DATA, QD6580_DEF_DATA);
+			qd_setup(hwif, base, config | (control << 8));
 
+			hwif->port_init_devs = qd6580_port_init_devs;
 			hwif->set_pio_mode = &qd6580_set_pio_mode;
 
-			qd_setup(mate, base, config | (control << 8),
-				 QD6580_DEF_DATA2, QD6580_DEF_DATA2);
+			qd_setup(mate, base, config | (control << 8));
 
+			mate->port_init_devs = qd6580_port_init_devs;
 			mate->set_pio_mode = &qd6580_set_pio_mode;
 
 			idx[0] = 0;
 			idx[1] = 1;
 
-			ide_device_add(idx);
+			ide_device_add(idx, &qd65xx_port_info);
 
 			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
 
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index 26f38ce..5696ba0 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -120,9 +120,14 @@ static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
+static const struct ide_port_info umc8672_port_info __initdata = {
+	.chipset		= ide_umc8672,
+	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
+	.pio_mask		= ATA_PIO4,
+};
+
 static int __init umc8672_probe(void)
 {
-	ide_hwif_t *hwif, *mate;
 	unsigned long flags;
 	static u8 idx[4] = { 0, 1, 0xff, 0xff };
 
@@ -143,21 +148,10 @@ static int __init umc8672_probe(void)
 	umc_set_speeds (current_speeds);
 	local_irq_restore(flags);
 
-	hwif = &ide_hwifs[0];
-	mate = &ide_hwifs[1];
-
-	hwif->chipset = ide_umc8672;
-	hwif->pio_mask = ATA_PIO4;
-	hwif->set_pio_mode = &umc_set_pio_mode;
-	hwif->mate = mate;
-
-	mate->chipset = ide_umc8672;
-	mate->pio_mask = ATA_PIO4;
-	mate->set_pio_mode = &umc_set_pio_mode;
-	mate->mate = hwif;
-	mate->channel = 1;
+	ide_hwifs[0].set_pio_mode = &umc_set_pio_mode;
+	ide_hwifs[1].set_pio_mode = &umc_set_pio_mode;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &umc8672_port_info);
 
 	return 0;
 }
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index cd42b30..0f4bf5d 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -548,6 +548,17 @@ static void auide_setup_ports(hw_regs_t *hw, _auide_hwif *ahwif)
 	*ata_regs = ahwif->regbase + (14 << AU1XXX_ATA_REG_OFFSET);
 }
 
+static const struct ide_port_info au1xxx_port_info = {
+	.host_flags		= IDE_HFLAG_POST_SET_MODE |
+				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
+				  IDE_HFLAG_NO_IO_32BIT |
+				  IDE_HFLAG_UNMASK_IRQS,
+	.pio_mask		= ATA_PIO4,
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
+	.mwdma_mask		= ATA_MWDMA2,
+#endif
+};
+
 static int au_ide_probe(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -606,21 +617,6 @@ static int au_ide_probe(struct device *dev)
 
 	hwif->dev = dev;
 
-	hwif->ultra_mask                = 0x0;  /* Disable Ultra DMA */
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-	hwif->mwdma_mask                = 0x07; /* Multimode-2 DMA  */
-	hwif->swdma_mask                = 0x00;
-#else
-	hwif->mwdma_mask                = 0x0;
-	hwif->swdma_mask                = 0x0;
-#endif
-
-	hwif->pio_mask = ATA_PIO4;
-	hwif->host_flags = IDE_HFLAG_POST_SET_MODE;
-
-	hwif->drives[0].unmask          = 1;
-	hwif->drives[1].unmask          = 1;
-
 	/* hold should be on in all cases */
 	hwif->hold                      = 1;
 
@@ -651,16 +647,9 @@ static int au_ide_probe(struct device *dev)
 	hwif->ide_dma_test_irq          = &auide_dma_test_irq;
 	hwif->dma_lost_irq		= &auide_dma_lost_irq;
 #endif
-	hwif->channel                   = 0;
 	hwif->select_data               = 0;    /* no chipset-specific code */
 	hwif->config_data               = 0;    /* no chipset-specific code */
 
-	hwif->drives[0].autotune        = 1;    /* 1=autotune, 2=noautotune, 0=default */
-	hwif->drives[1].autotune	= 1;
-
-	hwif->drives[0].no_io_32bit	= 1;
-	hwif->drives[1].no_io_32bit	= 1;
-
 	auide_hwif.hwif                 = hwif;
 	hwif->hwif_data                 = &auide_hwif;
 
@@ -671,7 +660,7 @@ static int au_ide_probe(struct device *dev)
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &au1xxx_port_info);
 
 	dev_set_drvdata(dev, hwif);
 
@@ -688,7 +677,7 @@ static int au_ide_remove(struct device *dev)
 	ide_hwif_t *hwif = dev_get_drvdata(dev);
 	_auide_hwif *ahwif = &auide_hwif;
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif->index, 0, 0);
 
 	iounmap((void *)ahwif->regbase);
 
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
index 8b3959d..956259f 100644
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -129,7 +129,7 @@ static int __devinit swarm_ide_probe(struct device *dev)
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	dev_set_drvdata(dev, hwif);
 
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 824df78..cfb3265 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
@@ -166,6 +165,16 @@ static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const ch
 	return dev->irq;
 }
 
+static u8 __devinit atp86x_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
+
+	pci_read_config_byte(dev, 0x49, &ata66);
+
+	return (ata66 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
 static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -174,21 +183,10 @@ static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 
 	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
 		hwif->set_dma_mode = &aec6210_set_mode;
-	else
+	else {
 		hwif->set_dma_mode = &aec6260_set_mode;
 
-	if (hwif->dma_base == 0)
-		return;
-
-	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
-		u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
-
-		pci_read_config_byte(dev, 0x49, &ata66);
-
-		hwif->cbl = (ata66 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+		hwif->cable_detect = atp86x_cable_detect;
 	}
 }
 
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 130cc6e..b3b6f51 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -31,7 +31,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
@@ -666,13 +665,12 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 	hwif->set_dma_mode = &ali_set_dma_mode;
 	hwif->udma_filter = &ali_udma_filter;
 
+	hwif->cable_detect = ata66_ali15x3;
+
 	if (hwif->dma_base == 0)
 		return;
 
 	hwif->dma_setup = &ali15x3_dma_setup;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_ali15x3(hwif);
 }
 
 /**
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 8c52bc9..2ef890c 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -17,12 +17,9 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
-#include <asm/io.h>
 
 #include "ide-timing.h"
 
@@ -199,6 +196,14 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev,
 	return dev->irq;
 }
 
+static u8 __devinit amd_cable_detect(ide_hwif_t *hwif)
+{
+	if ((amd_80w >> hwif->channel) & 1)
+		return ATA_CBL_PATA80;
+	else
+		return ATA_CBL_PATA40;
+}
+
 static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -209,15 +214,7 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 	hwif->set_pio_mode = &amd_set_pio_mode;
 	hwif->set_dma_mode = &amd_set_drive;
 
-	if (!hwif->dma_base)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
-		if ((amd_80w >> hwif->channel) & 1)
-			hwif->cbl = ATA_CBL_PATA80;
-		else
-			hwif->cbl = ATA_CBL_PATA40;
-	}
+	hwif->cable_detect = amd_cable_detect;
 }
 
 #define IDE_HFLAGS_AMD \
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index b56274a..7e037c8 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -6,15 +6,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 #define ATIIXP_IDE_PIO_TIMING		0x40
 #define ATIIXP_IDE_MDMA_TIMING		0x44
 #define ATIIXP_IDE_PIO_CONTROL		0x48
@@ -121,6 +117,19 @@ static void atiixp_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
+static u8 __devinit atiixp_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
+	u8 udma_mode = 0, ch = hwif->channel;
+
+	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
+
+	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
+		return ATA_CBL_PATA80;
+	else
+		return ATA_CBL_PATA40;
+}
+
 /**
  *	init_hwif_atiixp		-	fill in the hwif for the ATIIXP
  *	@hwif: IDE interface
@@ -131,21 +140,10 @@ static void atiixp_set_dma_mode(ide_drive_t *drive, const u8 speed)
 
 static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 {
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	u8 udma_mode = 0, ch = hwif->channel;
-
 	hwif->set_pio_mode = &atiixp_set_pio_mode;
 	hwif->set_dma_mode = &atiixp_set_dma_mode;
 
-	if (!hwif->dma_base)
-		return;
-
-	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
-
-	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
-		hwif->cbl = ATA_CBL_PATA80;
-	else
-		hwif->cbl = ATA_CBL_PATA40;
+	hwif->cable_detect = atiixp_cable_detect;
 }
 
 static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index 7240c20..bd24dad 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -103,10 +103,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
@@ -703,6 +699,18 @@ static int pci_conf2(void)
 	return 0;
 }
 
+static const struct ide_port_info cmd640_port_info __initdata = {
+	.chipset		= ide_cmd640,
+	.host_flags		= IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_NO_AUTOTUNE |
+				  IDE_HFLAG_ABUSE_PREFETCH |
+				  IDE_HFLAG_ABUSE_FAST_DEVSEL,
+#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
+	.pio_mask		= ATA_PIO5,
+#endif
+};
+
 /*
  * Probe for a cmd640 chipset, and initialize it if found.
  */
@@ -760,11 +768,7 @@ static int __init cmd640x_init(void)
 	setup_device_ptrs ();
 	printk("%s: buggy cmd640%c interface on %s, config=0x%02x\n",
 	       cmd_hwif0->name, 'a' + cmd640_chip_version - 1, bus_type, cfr);
-	cmd_hwif0->chipset = ide_cmd640;
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-	cmd_hwif0->host_flags = IDE_HFLAG_ABUSE_PREFETCH |
-				IDE_HFLAG_ABUSE_FAST_DEVSEL;
-	cmd_hwif0->pio_mask = ATA_PIO5;
 	cmd_hwif0->set_pio_mode = &cmd640_set_pio_mode;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
@@ -815,23 +819,14 @@ static int __init cmd640x_init(void)
 	 * Initialize data for secondary cmd640 port, if enabled
 	 */
 	if (second_port_cmd640) {
-		cmd_hwif0->serialized = 1;
-		cmd_hwif1->serialized = 1;
-		cmd_hwif1->chipset = ide_cmd640;
-		cmd_hwif0->mate = cmd_hwif1;
-		cmd_hwif1->mate = cmd_hwif0;
-		cmd_hwif1->channel = 1;
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-		cmd_hwif1->host_flags = IDE_HFLAG_ABUSE_PREFETCH |
-					IDE_HFLAG_ABUSE_FAST_DEVSEL;
-		cmd_hwif1->pio_mask = ATA_PIO5;
 		cmd_hwif1->set_pio_mode = &cmd640_set_pio_mode;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
 		idx[1] = cmd_hwif1->index;
 	}
 	printk(KERN_INFO "%s: %sserialized, secondary interface %s\n", cmd_hwif1->name,
-		cmd_hwif0->serialized ? "" : "not ", port2);
+			 second_port_cmd640 ? "" : "not ", port2);
 
 	/*
 	 * Establish initial timings/prefetch for all drives.
@@ -876,7 +871,7 @@ static int __init cmd640x_init(void)
 	cmd640_dump_regs();
 #endif
 
-	ide_device_add(idx);
+	ide_device_add(idx, &cmd640_port_info);
 
 	return 1;
 }
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 04aa9e5..edabe62 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
@@ -393,6 +392,8 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	hwif->set_pio_mode = &cmd64x_set_pio_mode;
 	hwif->set_dma_mode = &cmd64x_set_dma_mode;
 
+	hwif->cable_detect = ata66_cmd64x;
+
 	if (!hwif->dma_base)
 		return;
 
@@ -411,9 +412,6 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	if (dev->device == PCI_DEVICE_ID_CMD_646 && dev->revision < 5)
 		hwif->ultra_mask = 0x00;
 
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_cmd64x(hwif);
-
 	switch (dev->device) {
 	case PCI_DEVICE_ID_CMD_648:
 	case PCI_DEVICE_ID_CMD_649:
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index eb68a9a..0be1a82 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -35,22 +35,12 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
-
-#include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/io.h>
-#include <asm/irq.h>
-
 struct pio_clocks
 {
 	int address;
@@ -180,7 +170,7 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
 
 	ide_pci_setup_ports(dev, d, 14, &idx[0]);
 
-	ide_device_add(idx);
+	ide_device_add(idx, d);
 
 	return 0;
 }
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index 765aac3..941a134 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -15,18 +15,12 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
-#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
+
 #include <asm/io.h>
-#include <asm/irq.h>
 
 /*
  * Here are the standard PIO mode 0-4 timings for each "format".
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 66433aa..d7b5ea9 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -155,8 +155,9 @@ static void cs5535_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	cs5535_set_speed(drive, XFER_PIO_0 + pio);
 }
 
-static u8 __devinit cs5535_cable_detect(struct pci_dev *dev)
+static u8 __devinit cs5535_cable_detect(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 bit;
 
 	/* if a 80 wire cable was detected */
@@ -175,15 +176,10 @@ static u8 __devinit cs5535_cable_detect(struct pci_dev *dev)
  */
 static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
 	hwif->set_pio_mode = &cs5535_set_pio_mode;
 	hwif->set_dma_mode = &cs5535_set_dma_mode;
 
-	if (hwif->dma_base == 0)
-		return;
-
-	hwif->cbl = cs5535_cable_detect(dev);
+	hwif->cable_detect = cs5535_cable_detect;
 }
 
 static const struct ide_port_info cs5535_chipset __devinitdata = {
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index 50100ac..724cbac 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -45,7 +45,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index 27e47fc..3f9cd64 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -16,15 +16,14 @@
  *  License.  See the file COPYING in the main directory of this archive for
  *  more details.
  */
-#include <linux/autoconf.h>
+
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+
 #include <asm/io.h>
 
 /*
@@ -52,6 +51,7 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 	ide_hwif_t *hwif = NULL;
 	ide_drive_t *drive;
 	int i, rc;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	rc = pci_enable_device(dev);
 	if (rc) {
@@ -78,12 +78,27 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 	hw.irq = dev->irq;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	rc = ide_register_hw(&hw, &ide_undecoded_slave, &hwif);
-	if (rc < 0) {
-		printk(KERN_ERR "delkin_cb: ide_register_hw failed (%d)\n", rc);
-		pci_disable_device(dev);
-		return -ENODEV;
-	}
+	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	if (hwif == NULL)
+		goto out_disable;
+
+	i = hwif->index;
+
+	if (hwif->present)
+		ide_unregister(i, 0, 0);
+	else if (!hwif->hold)
+		ide_init_port_data(hwif, i);
+
+	ide_init_port_hw(hwif, &hw);
+	hwif->quirkproc = &ide_undecoded_slave;
+
+	idx[0] = i;
+
+	ide_device_add(idx, NULL);
+
+	if (!hwif->present)
+		goto out_disable;
+
 	pci_set_drvdata(dev, hwif);
 	hwif->dev = &dev->dev;
 	drive = &hwif->drives[0];
@@ -92,6 +107,11 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 		drive->unmask   = 1;
 	}
 	return 0;
+
+out_disable:
+	printk(KERN_ERR "delkin_cb: no IDE devices found\n");
+	pci_disable_device(dev);
+	return -ENODEV;
 }
 
 static void
@@ -100,7 +120,8 @@ delkin_cb_remove (struct pci_dev *dev)
 	ide_hwif_t *hwif = pci_get_drvdata(dev);
 
 	if (hwif)
-		ide_unregister(hwif->index);
+		ide_unregister(hwif->index, 0, 0);
+
 	pci_disable_device(dev);
 }
 
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index 59ebe84..9262a91 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -22,18 +22,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 static int ide_generic_all;		/* Set to claim all devices */
 
 /*
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 25dbb81..9f01da4 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -26,20 +26,13 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 
-#include <asm/io.h>
-#include <asm/irq.h>
-
 #define HPT343_DEBUG_DRIVE_INFO		0
 
 static void hpt34x_set_mode(ide_drive_t *drive, const u8 speed)
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 5623cad..d0f7bb8 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -121,12 +121,8 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
-
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
@@ -134,7 +130,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/irq.h>
 
 /* various tuning parameters */
 #define HPT_RESET_STATE_ENGINE
@@ -1279,12 +1274,55 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 	return dev->irq;
 }
 
+static u8 __devinit hpt3xx_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
+	struct hpt_info *info	= pci_get_drvdata(dev);
+	u8 chip_type		= info->chip_type;
+	u8 scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
+
+	/*
+	 * The HPT37x uses the CBLID pins as outputs for MA15/MA16
+	 * address lines to access an external EEPROM.  To read valid
+	 * cable detect state the pins must be enabled as inputs.
+	 */
+	if (chip_type == HPT374 && (PCI_FUNC(dev->devfn) & 1)) {
+		/*
+		 * HPT374 PCI function 1
+		 * - set bit 15 of reg 0x52 to enable TCBLID as input
+		 * - set bit 15 of reg 0x56 to enable FCBLID as input
+		 */
+		u8  mcr_addr = hwif->select_data + 2;
+		u16 mcr;
+
+		pci_read_config_word(dev, mcr_addr, &mcr);
+		pci_write_config_word(dev, mcr_addr, (mcr | 0x8000));
+		/* now read cable id register */
+		pci_read_config_byte(dev, 0x5a, &scr1);
+		pci_write_config_word(dev, mcr_addr, mcr);
+	} else if (chip_type >= HPT370) {
+		/*
+		 * HPT370/372 and 374 pcifn 0
+		 * - clear bit 0 of reg 0x5b to enable P/SCBLID as inputs
+		 */
+		u8 scr2 = 0;
+
+		pci_read_config_byte(dev, 0x5b, &scr2);
+		pci_write_config_byte(dev, 0x5b, (scr2 & ~1));
+		/* now read cable id register */
+		pci_read_config_byte(dev, 0x5a, &scr1);
+		pci_write_config_byte(dev, 0x5b,  scr2);
+	} else
+		pci_read_config_byte(dev, 0x5a, &scr1);
+
+	return (scr1 & ata66) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= pci_get_drvdata(dev);
 	int serialize		= HPT_SERIALIZE_IO;
-	u8  scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
 	u8  chip_type		= info->chip_type;
 	u8  new_mcr, old_mcr	= 0;
 
@@ -1301,6 +1339,8 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	hwif->udma_filter	= &hpt3xx_udma_filter;
 	hwif->mdma_filter	= &hpt3xx_mdma_filter;
 
+	hwif->cable_detect	= hpt3xx_cable_detect;
+
 	/*
 	 * HPT3xxN chips have some complications:
 	 *
@@ -1346,43 +1386,6 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	if (hwif->dma_base == 0)
 		return;
 
-	/*
-	 * The HPT37x uses the CBLID pins as outputs for MA15/MA16
-	 * address lines to access an external EEPROM.  To read valid
-	 * cable detect state the pins must be enabled as inputs.
-	 */
-	if (chip_type == HPT374 && (PCI_FUNC(dev->devfn) & 1)) {
-		/*
-		 * HPT374 PCI function 1
-		 * - set bit 15 of reg 0x52 to enable TCBLID as input
-		 * - set bit 15 of reg 0x56 to enable FCBLID as input
-		 */
-		u8  mcr_addr = hwif->select_data + 2;
-		u16 mcr;
-
-		pci_read_config_word (dev, mcr_addr, &mcr);
-		pci_write_config_word(dev, mcr_addr, (mcr | 0x8000));
-		/* now read cable id register */
-		pci_read_config_byte (dev, 0x5a, &scr1);
-		pci_write_config_word(dev, mcr_addr, mcr);
-	} else if (chip_type >= HPT370) {
-		/*
-		 * HPT370/372 and 374 pcifn 0
-		 * - clear bit 0 of reg 0x5b to enable P/SCBLID as inputs
-		 */
-		u8 scr2 = 0;
-
-		pci_read_config_byte (dev, 0x5b, &scr2);
-		pci_write_config_byte(dev, 0x5b, (scr2 & ~1));
-		/* now read cable id register */
-		pci_read_config_byte (dev, 0x5a, &scr1);
-		pci_write_config_byte(dev, 0x5b,  scr2);
-	} else
-		pci_read_config_byte (dev, 0x5a, &scr1);
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = (scr1 & ata66) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
-
 	if (chip_type >= HPT374) {
 		hwif->ide_dma_test_irq	= &hpt374_ide_dma_test_irq;
 		hwif->ide_dma_end	= &hpt374_ide_dma_end;
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index df74e58..e3427ea 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -10,13 +10,10 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 /**
  *	it8213_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
@@ -143,6 +140,16 @@ static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	}
 }
 
+static u8 __devinit it8213_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	u8 reg42h = 0;
+
+	pci_read_config_byte(dev, 0x42, &reg42h);
+
+	return (reg42h & 0x02) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
 /**
  *	init_hwif_it8213	-	set up hwif structs
  *	@hwif: interface to set up
@@ -152,19 +159,10 @@ static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
 
 static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 reg42h = 0;
-
 	hwif->set_dma_mode = &it8213_set_dma_mode;
 	hwif->set_pio_mode = &it8213_set_pio_mode;
 
-	if (!hwif->dma_base)
-		return;
-
-	pci_read_config_byte(dev, 0x42, &reg42h);
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = (reg42h & 0x02) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+	hwif->cable_detect = it8213_cable_detect;
 }
 
 
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 938d35f..1597f0c 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -63,13 +63,10 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 struct it821x_dev
 {
 	unsigned int smart:1,		/* Are we in smart raid mode */
@@ -579,14 +576,13 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	} else
 		hwif->host_flags |= IDE_HFLAG_NO_SET_MODE;
 
+	hwif->cable_detect = ata66_it821x;
+
 	if (hwif->dma_base == 0)
 		return;
 
 	hwif->ultra_mask = ATA_UDMA6;
 	hwif->mwdma_mask = ATA_MWDMA2;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_it821x(hwif);
 }
 
 static void __devinit it8212_disable_raid(struct pci_dev *dev)
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index 8b40f64..a56bcb4 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -8,13 +8,10 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 typedef enum {
 	PORT_PATA0 = 0,
 	PORT_PATA1 = 1,
@@ -111,11 +108,7 @@ static void __devinit init_hwif_jmicron(ide_hwif_t *hwif)
 	hwif->set_pio_mode = &jmicron_set_pio_mode;
 	hwif->set_dma_mode = &jmicron_set_dma_mode;
 
-	if (hwif->dma_base == 0)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_jmicron(hwif);
+	hwif->cable_detect = ata66_jmicron;
 }
 
 static const struct ide_port_info jmicron_chipset __devinitdata = {
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index fc9eee9..bf0d3b2 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -10,11 +10,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
 #include <linux/interrupt.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 0ce92d3..46e8748 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -87,11 +87,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/pci.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
@@ -320,14 +315,18 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	spin_unlock_irqrestore(&opti621_lock, flags);
 }
 
+static void __devinit opti621_port_init_devs(ide_hwif_t *hwif)
+{
+	hwif->drives[0].drive_data = PIO_DONT_KNOW;
+	hwif->drives[1].drive_data = PIO_DONT_KNOW;
+}
+
 /*
  * init_hwif_opti621() is called once for each hwif found at boot.
  */
 static void __devinit init_hwif_opti621 (ide_hwif_t *hwif)
 {
-	hwif->drives[0].drive_data = PIO_DONT_KNOW;
-	hwif->drives[1].drive_data = PIO_DONT_KNOW;
-
+	hwif->port_init_devs = opti621_port_init_devs;
 	hwif->set_pio_mode = &opti621_set_pio_mode;
 }
 
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index bb29db0..1c8cb77 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -19,18 +19,12 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
-#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 
 #include <asm/io.h>
-#include <asm/irq.h>
 
 #ifdef CONFIG_PPC_PMAC
 #include <asm/prom.h>
@@ -197,7 +191,7 @@ static void pdcnew_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	}
 }
 
-static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
+static u8 __devinit pdcnew_cable_detect(ide_hwif_t *hwif)
 {
 	if (get_indexed_reg(hwif, 0x0b) & 0x04)
 		return ATA_CBL_PATA40;
@@ -456,11 +450,7 @@ static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 	hwif->quirkproc = &pdcnew_quirkproc;
 	hwif->resetproc = &pdcnew_reset;
 
-	if (hwif->dma_base == 0)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = pdcnew_cable_detect(hwif);
+	hwif->cable_detect = pdcnew_cable_detect;
 }
 
 static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index 31a1308..da43297 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -32,18 +32,13 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
-#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 
 #include <asm/io.h>
-#include <asm/irq.h>
 
 #define PDC202XX_DEBUG_DRIVE_INFO	0
 
@@ -140,10 +135,10 @@ static void pdc202xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	pdc202xx_set_mode(drive, XFER_PIO_0 + pio);
 }
 
-static u8 pdc202xx_old_cable_detect (ide_hwif_t *hwif)
+static u8 __devinit pdc2026x_old_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u16 CIS = 0, mask = (hwif->channel) ? (1<<11) : (1<<10);
+	u16 CIS, mask = hwif->channel ? (1 << 11) : (1 << 10);
 
 	pci_read_config_word(dev, 0x50, &CIS);
 
@@ -311,9 +306,12 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 
 	hwif->quirkproc = &pdc202xx_quirkproc;
 
-	if (dev->device != PCI_DEVICE_ID_PROMISE_20246)
+	if (dev->device != PCI_DEVICE_ID_PROMISE_20246) {
 		hwif->resetproc = &pdc202xx_reset;
 
+		hwif->cable_detect = pdc2026x_old_cable_detect;
+	}
+
 	if (hwif->dma_base == 0)
 		return;
 
@@ -321,9 +319,6 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 	hwif->dma_timeout = &pdc202xx_dma_timeout;
 
 	if (dev->device != PCI_DEVICE_ID_PROMISE_20246) {
-		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-			hwif->cbl = pdc202xx_old_cable_detect(hwif);
-
 		hwif->dma_start = &pdc202xx_old_ide_dma_start;
 		hwif->ide_dma_end = &pdc202xx_old_ide_dma_end;
 	} 
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index c1a6b68..decef0f 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -47,11 +47,9 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 
 #include <asm/io.h>
@@ -290,14 +288,11 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 	hwif->set_pio_mode = &piix_set_pio_mode;
 	hwif->set_dma_mode = &piix_set_dma_mode;
 
+	hwif->cable_detect = piix_cable_detect;
+
 	if (!hwif->dma_base)
 		return;
 
-	if (hwif->ultra_mask & 0x78) {
-		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-			hwif->cbl = piix_cable_detect(hwif);
-	}
-
 	if (no_piix_dma)
 		hwif->ultra_mask = hwif->mwdma_mask = hwif->swdma_mask = 0;
 }
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index 7ed6625..5167661 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -16,18 +16,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -40,8 +33,7 @@ static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 	} else {
 		if (hwif->mate)
 			hwif->mate->serialized = hwif->serialized = 1;
-		hwif->drives[0].no_unmask = 1;
-		hwif->drives[1].no_unmask = 1;
+		hwif->host_flags |= IDE_HFLAG_NO_UNMASK_IRQS;
 		printk(KERN_INFO "%s: serialized, disabled unmasking "
 			"(buggy RZ1000/RZ1001)\n", hwif->name);
 	}
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index af499a6..561aa47 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -14,19 +14,13 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
-#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 #include <linux/pm.h>
+
 #include <asm/io.h>
-#include <asm/irq.h>
 
 #define SC1200_REV_A	0x00
 #define SC1200_REV_B1	0x01
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 7694969..238e3e1 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -644,6 +644,11 @@ static void __devinit init_iops_scc(ide_hwif_t *hwif)
 	init_mmio_iops_scc(hwif);
 }
 
+static u8 __devinit scc_cable_detect(ide_hwif_t *hwif)
+{
+	return ATA_CBL_PATA80;
+}
+
 /**
  *	init_hwif_scc	-	set up hwif
  *	@hwif: interface to set up
@@ -678,8 +683,7 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 	else
 		hwif->ultra_mask = ATA_UDMA5; /* 100MHz */
 
-	/* we support 80c cable only. */
-	hwif->cbl = ATA_CBL_PATA80;
+	hwif->cable_detect = scc_cable_detect;
 }
 
 #define DECLARE_SCC_DEV(name_str)			\
@@ -732,7 +736,7 @@ static void __devexit scc_remove(struct pci_dev *dev)
 		hwif->dmatable_cpu = NULL;
 	}
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif->index, 0, 0);
 
 	hwif->chipset = ide_unknown;
 	iounmap((void*)ports->dma);
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index f495253..c11880b 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -31,12 +31,10 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
-#include <linux/delay.h>
 
 #include <asm/io.h>
 
@@ -346,13 +344,8 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 	hwif->set_dma_mode = &svwks_set_dma_mode;
 	hwif->udma_filter = &svwks_udma_filter;
 
-	if (!hwif->dma_base)
-		return;
-
-	if (dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
-		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-			hwif->cbl = ata66_svwks(hwif);
-	}
+	if (dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE)
+		hwif->cable_detect = ata66_svwks;
 }
 
 #define IDE_HFLAGS_SVWKS \
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 8590207..0546264 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -25,8 +25,6 @@
 #include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
@@ -555,7 +553,6 @@ static void __devinit
 ide_init_sgiioc4(ide_hwif_t * hwif)
 {
 	hwif->mmio = 1;
-	hwif->pio_mask = 0x00;
 	hwif->set_pio_mode = NULL; /* Sets timing for PIO mode */
 	hwif->set_dma_mode = &sgiioc4_set_dma_mode;
 	hwif->selectproc = NULL;/* Use the default routine to select drive */
@@ -572,8 +569,6 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->mwdma_mask = ATA_MWDMA2_ONLY;
-
 	hwif->dma_host_set = &sgiioc4_dma_host_set;
 	hwif->dma_setup = &sgiioc4_ide_dma_setup;
 	hwif->dma_start = &sgiioc4_ide_dma_start;
@@ -583,6 +578,13 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	hwif->dma_timeout = &ide_dma_timeout;
 }
 
+static const struct ide_port_info sgiioc4_port_info __devinitdata = {
+	.chipset		= ide_pci,
+	.host_flags		= IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
+				  IDE_HFLAG_NO_AUTOTUNE,
+	.mwdma_mask		= ATA_MWDMA2_ONLY,
+};
+
 static int __devinit
 sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 {
@@ -593,6 +595,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	int h;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw;
+	struct ide_port_info d = sgiioc4_port_info;
 
 	/*
 	 * Find an empty HWIF; if none available, return -ENOMEM.
@@ -641,7 +644,6 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	ide_init_port_hw(hwif, &hw);
 
 	hwif->dev = &dev->dev;
-	hwif->channel = 0;	/* Single Channel chip */
 
 	/* The IOC4 uses MMIO rather than Port IO. */
 	default_hwif_mmiops(hwif);
@@ -649,15 +651,17 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	if (dma_base == 0 || ide_dma_sgiioc4(hwif, dma_base))
+	if (dma_base == 0 || ide_dma_sgiioc4(hwif, dma_base)) {
 		printk(KERN_INFO "%s: %s Bus-Master DMA disabled\n",
 				 hwif->name, DRV_NAME);
+		d.mwdma_mask = 0;
+	}
 
 	ide_init_sgiioc4(hwif);
 
 	idx[0] = hwif->index;
 
-	if (ide_device_add(idx))
+	if (ide_device_add(idx, &d))
 		return -EIO;
 
 	return 0;
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 4877bc8..ef5b39f 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -39,7 +39,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
@@ -332,15 +331,18 @@ static int siimage_mmio_ide_dma_test_irq (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long addr	= siimage_selreg(hwif, 0x1);
+	void __iomem *sata_error_addr
+		= (void __iomem *)hwif->sata_scr[SATA_ERROR_OFFSET];
 
-	if (SATA_ERROR_REG) {
+	if (sata_error_addr) {
 		unsigned long base = (unsigned long)hwif->hwif_data;
-
 		u32 ext_stat = readl((void __iomem *)(base + 0x10));
 		u8 watchdog = 0;
+
 		if (ext_stat & ((hwif->channel) ? 0x40 : 0x10)) {
-			u32 sata_error = readl((void __iomem *)SATA_ERROR_REG);
-			writel(sata_error, (void __iomem *)SATA_ERROR_REG);
+			u32 sata_error = readl(sata_error_addr);
+
+			writel(sata_error, sata_error_addr);
 			watchdog = (sata_error & 0x00680000) ? 1 : 0;
 			printk(KERN_WARNING "%s: sata_error = 0x%08x, "
 				"watchdog = %d, %s\n",
@@ -419,13 +421,17 @@ static int sil_sata_busproc(ide_drive_t * drive, int state)
 
 static int sil_sata_reset_poll(ide_drive_t *drive)
 {
-	if (SATA_STATUS_REG) {
-		ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
+	void __iomem *sata_status_addr
+		= (void __iomem *)hwif->sata_scr[SATA_STATUS_OFFSET];
 
-		/* SATA_STATUS_REG is valid only when in MMIO mode */
-		if ((readl((void __iomem *)SATA_STATUS_REG) & 0x03) != 0x03) {
+	if (sata_status_addr) {
+		/* SATA Status is available only when in MMIO mode */
+		u32 sata_stat = readl(sata_status_addr);
+
+		if ((sata_stat & 0x03) != 0x03) {
 			printk(KERN_WARNING "%s: reset phy dead, status=0x%08x\n",
-				hwif->name, readl((void __iomem *)SATA_STATUS_REG));
+					    hwif->name, sata_stat);
 			HWGROUP(drive)->polling = 0;
 			return ide_started;
 		}
@@ -827,15 +833,14 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 	} else
 		hwif->udma_filter = &sil_pata_udma_filter;
 
+	hwif->cable_detect = ata66_siimage;
+
 	if (hwif->dma_base == 0)
 		return;
 
 	if (sata)
 		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_siimage(hwif);
-
 	if (hwif->mmio) {
 		hwif->ide_dma_test_irq = &siimage_mmio_ide_dma_test_irq;
 	} else {
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 2a461de..512bb4c 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -47,20 +47,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
-
-#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 
-#include <asm/irq.h>
-
 #include "ide-timing.h"
 
 /* registers layout and init values are chipset family dependant */
@@ -565,13 +556,12 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 	if (chipset_family >= ATA_133)
 		hwif->udma_filter = sis5513_ata133_udma_filter;
 
+	hwif->cable_detect = ata66_sis5513;
+
 	if (hwif->dma_base == 0)
 		return;
 
 	hwif->ultra_mask = udma_rates[chipset_family];
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_sis5513(hwif);
 }
 
 static const struct ide_port_info sis5513_chipset __devinitdata = {
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index da13a12..ee261ae 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -17,17 +17,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/interrupt.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 
 #include <asm/io.h>
-#include <asm/dma.h>
 
 #undef DEBUG
 
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index a6cf810..65f4c2f 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -10,15 +10,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 static DEFINE_SPINLOCK(slc90e66_lock);
 
 static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -118,23 +114,23 @@ static void slc90e66_set_dma_mode(ide_drive_t *drive, const u8 speed)
 	}
 }
 
-static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
+static u8 __devinit slc90e66_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 reg47 = 0;
-	u8 mask = hwif->channel ? 0x01 : 0x02;  /* bit0:Primary */
-
-	hwif->set_pio_mode = &slc90e66_set_pio_mode;
-	hwif->set_dma_mode = &slc90e66_set_dma_mode;
+	u8 reg47 = 0, mask = hwif->channel ? 0x01 : 0x02;
 
 	pci_read_config_byte(dev, 0x47, &reg47);
 
-	if (hwif->dma_base == 0)
-		return;
+	/* bit[0(1)]: 0:80, 1:40 */
+	return (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
+static void __devinit init_hwif_slc90e66(ide_hwif_t *hwif)
+{
+	hwif->set_pio_mode = &slc90e66_set_pio_mode;
+	hwif->set_dma_mode = &slc90e66_set_dma_mode;
 
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		/* bit[0(1)]: 0:80, 1:40 */
-		hwif->cbl = (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+	hwif->cable_detect = slc90e66_cable_detect;
 }
 
 static const struct ide_port_info slc90e66_chipset __devinitdata = {
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 9fbbb4f..2ef2ed2 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -160,6 +160,19 @@ static int tc86c001_busproc(ide_drive_t *drive, int state)
 	return 0;
 }
 
+static u8 __devinit tc86c001_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	unsigned long sc_base = pci_resource_start(dev, 5);
+	u16 scr1 = inw(sc_base + 0x00);
+
+	/*
+	 * System Control  1 Register bit 13 (PDIAGN):
+	 * 0=80-pin cable, 1=40-pin cable
+	 */
+	return (scr1 & 0x2000) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
 static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
@@ -183,6 +196,8 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 
 	hwif->busproc	= &tc86c001_busproc;
 
+	hwif->cable_detect = tc86c001_cable_detect;
+
 	if (!hwif->dma_base)
 		return;
 
@@ -196,15 +211,6 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 	hwif->rqsize	 = 0xffff;
 
 	hwif->dma_start 	= &tc86c001_dma_start;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
-		/*
-		 * System Control  1 Register bit 13 (PDIAGN):
-		 * 0=80-pin cable, 1=40-pin cable
-		 */
-		scr1 = inw(sc_base + 0x00);
-		hwif->cbl = (scr1 & 0x2000) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
-	}
 }
 
 static unsigned int __devinit init_chipset_tc86c001(struct pci_dev *dev,
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index 852b726..a67d02a 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -28,11 +28,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/pci/trm290.c
index d9ebb69..de750f7 100644
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -131,14 +131,12 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/ide.h>
 
 #include <asm/io.h>
@@ -179,10 +177,7 @@ static void trm290_selectproc (ide_drive_t *drive)
 
 static void trm290_dma_exec_cmd(ide_drive_t *drive, u8 command)
 {
-	BUG_ON(HWGROUP(drive)->handler != NULL);	/* paranoia check */
-	ide_set_handler(drive, &ide_dma_intr, WAIT_CMD, NULL);
-	/* issue cmd to drive */
-	outb(command, IDE_COMMAND_REG);
+	ide_execute_command(drive, command, &ide_dma_intr, WAIT_CMD, NULL);
 }
 
 static int trm290_dma_setup(ide_drive_t *drive)
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 24cb904..f3f79f8 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -26,15 +26,11 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 #include <linux/dmi.h>
 
-#include <asm/io.h>
-
 #ifdef CONFIG_PPC_CHRP
 #include <asm/processor.h>
 #endif
@@ -424,11 +420,7 @@ static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 	hwif->set_pio_mode = &via_set_pio_mode;
 	hwif->set_dma_mode = &via_set_drive;
 
-	if (!hwif->dma_base)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = via82cxxx_cable_detect(hwif);
+	hwif->cable_detect = via82cxxx_cable_detect;
 }
 
 static const struct ide_port_info via82cxxx_chipset __devinitdata = {
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index 45c1d55..06190b1 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -848,7 +848,7 @@ static int __init mpc8xx_ide_probe(void)
 #endif
 #endif
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	return 0;
 }
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 23112ef..12ac3bf 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -412,7 +412,7 @@ kauai_lookup_timing(struct kauai_timing* table, int cycle_time)
  */
 #define IDE_WAKEUP_DELAY	(1*HZ)
 
-static void pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif);
+static int pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif);
 static int pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq);
 static void pmac_ide_selectproc(ide_drive_t *drive);
 static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
@@ -1003,6 +1003,17 @@ pmac_ide_do_resume(ide_hwif_t *hwif)
 	return 0;
 }
 
+static const struct ide_port_info pmac_port_info = {
+	.chipset		= ide_pmac,
+	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
+				  IDE_HFLAG_PIO_NO_DOWNGRADE |
+				  IDE_HFLAG_POST_SET_MODE |
+				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
+				  IDE_HFLAG_UNMASK_IRQS,
+	.pio_mask		= ATA_PIO4,
+	.mwdma_mask		= ATA_MWDMA2,
+};
+
 /*
  * Setup, register & probe an IDE channel driven by this driver, this is
  * called by one of the 2 probe functions (macio or PCI). Note that a channel
@@ -1016,23 +1027,28 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 	struct device_node *np = pmif->node;
 	const int *bidp;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	struct ide_port_info d = pmac_port_info;
 
 	pmif->cable_80 = 0;
 	pmif->broken_dma = pmif->broken_dma_warn = 0;
-	if (of_device_is_compatible(np, "shasta-ata"))
+	if (of_device_is_compatible(np, "shasta-ata")) {
 		pmif->kind = controller_sh_ata6;
-	else if (of_device_is_compatible(np, "kauai-ata"))
+		d.udma_mask = ATA_UDMA6;
+	} else if (of_device_is_compatible(np, "kauai-ata")) {
 		pmif->kind = controller_un_ata6;
-	else if (of_device_is_compatible(np, "K2-UATA"))
+		d.udma_mask = ATA_UDMA5;
+	} else if (of_device_is_compatible(np, "K2-UATA")) {
 		pmif->kind = controller_k2_ata6;
-	else if (of_device_is_compatible(np, "keylargo-ata")) {
-		if (strcmp(np->name, "ata-4") == 0)
+		d.udma_mask = ATA_UDMA5;
+	} else if (of_device_is_compatible(np, "keylargo-ata")) {
+		if (strcmp(np->name, "ata-4") == 0) {
 			pmif->kind = controller_kl_ata4;
-		else
+			d.udma_mask = ATA_UDMA4;
+		} else
 			pmif->kind = controller_kl_ata3;
-	} else if (of_device_is_compatible(np, "heathrow-ata"))
+	} else if (of_device_is_compatible(np, "heathrow-ata")) {
 		pmif->kind = controller_heathrow;
-	else {
+	} else {
 		pmif->kind = controller_ohare;
 		pmif->broken_dma = 1;
 	}
@@ -1101,19 +1117,10 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 	/* Tell common code _not_ to mess with resources */
 	hwif->mmio = 1;
 	hwif->hwif_data = pmif;
-	hw->chipset = ide_pmac;
 	ide_init_port_hw(hwif, hw);
 	hwif->noprobe = pmif->mediabay;
 	hwif->hold = pmif->mediabay;
 	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
-	hwif->drives[0].unmask = 1;
-	hwif->drives[1].unmask = 1;
-	hwif->drives[0].autotune = IDE_TUNE_AUTO;
-	hwif->drives[1].autotune = IDE_TUNE_AUTO;
-	hwif->host_flags = IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
-			   IDE_HFLAG_PIO_NO_DOWNGRADE |
-			   IDE_HFLAG_POST_SET_MODE;
-	hwif->pio_mask = ATA_PIO4;
 	hwif->set_pio_mode = pmac_ide_set_pio_mode;
 	if (pmif->kind == controller_un_ata6
 	    || pmif->kind == controller_k2_ata6
@@ -1133,14 +1140,16 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 #endif /* CONFIG_PMAC_MEDIABAY */
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
+	if (pmif->cable_80 == 0)
+		d.udma_mask &= ATA_UDMA2;
 	/* has a DBDMA controller channel */
-	if (pmif->dma_regs)
-		pmac_ide_setup_dma(pmif, hwif);
-#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
+	if (pmif->dma_regs == 0 || pmac_ide_setup_dma(pmif, hwif) < 0)
+#endif
+		d.udma_mask = d.mwdma_mask = 0;
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &d);
 
 	return 0;
 }
@@ -1721,8 +1730,7 @@ pmac_ide_dma_lost_irq (ide_drive_t *drive)
  * Allocate the data structures needed for using DMA with an interface
  * and fill the proper list of functions pointers
  */
-static void __devinit
-pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
+static int __devinit pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
@@ -1730,7 +1738,7 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	 * DMA routines ...
 	 */
 	if (dev == NULL)
-		return;
+		return -ENODEV;
 	/*
 	 * Allocate space for the DBDMA commands.
 	 * The +2 is +1 for the stop command and +1 to allow for
@@ -1743,7 +1751,7 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	if (pmif->dma_table_cpu == NULL) {
 		printk(KERN_ERR "%s: unable to allocate DMA command list\n",
 		       hwif->name);
-		return;
+		return -ENOMEM;
 	}
 
 	hwif->sg_max_nents = MAX_DCMDS;
@@ -1757,29 +1765,7 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	hwif->dma_timeout = &ide_dma_timeout;
 	hwif->dma_lost_irq = &pmac_ide_dma_lost_irq;
 
-	switch(pmif->kind) {
-		case controller_sh_ata6:
-			hwif->ultra_mask = pmif->cable_80 ? 0x7f : 0x07;
-			hwif->mwdma_mask = 0x07;
-			hwif->swdma_mask = 0x00;
-			break;
-		case controller_un_ata6:
-		case controller_k2_ata6:
-			hwif->ultra_mask = pmif->cable_80 ? 0x3f : 0x07;
-			hwif->mwdma_mask = 0x07;
-			hwif->swdma_mask = 0x00;
-			break;
-		case controller_kl_ata4:
-			hwif->ultra_mask = pmif->cable_80 ? 0x1f : 0x07;
-			hwif->mwdma_mask = 0x07;
-			hwif->swdma_mask = 0x00;
-			break;
-		default:
-			hwif->ultra_mask = 0x00;
-			hwif->mwdma_mask = 0x07;
-			hwif->swdma_mask = 0x00;
-			break;
-	}
+	return 0;
 }
 
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 05db429..634e3f6 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -339,7 +339,8 @@ static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *
  *	ide_hwif_configure	-	configure an IDE interface
  *	@dev: PCI device holding interface
  *	@d: IDE port info
- *	@mate: Paired interface if any
+ *	@port: port number
+ *	@irq: PCI IRQ
  *
  *	Perform the initial set up for the hardware interface structure. This
  *	is done per interface port rather than per PCI device. There may be
@@ -348,7 +349,9 @@ static int ide_pci_check_iomem(struct pci_dev *dev, const struct ide_port_info *
  *	Returns the new hardware interface structure, or NULL on a failure
  */
 
-static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev, const struct ide_port_info *d, ide_hwif_t *mate, int port, int irq)
+static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
+				      const struct ide_port_info *d,
+				      unsigned int port, int irq)
 {
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
@@ -394,29 +397,24 @@ static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev, const struct ide_port
 
 	hwif->dev = &dev->dev;
 	hwif->cds = d;
-	hwif->channel = port;
 
-	if (mate) {
-		hwif->mate = mate;
-		mate->mate = hwif;
-	}
 	return hwif;
 }
 
+#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 /**
  *	ide_hwif_setup_dma	-	configure DMA interface
- *	@dev: PCI device
- *	@d: IDE port info
  *	@hwif: IDE interface
+ *	@d: IDE port info
  *
  *	Set up the DMA base for the interface. Enable the master bits as
  *	necessary and attempt to bring the device DMA into a ready to use
  *	state
  */
 
-static void ide_hwif_setup_dma(struct pci_dev *dev, const struct ide_port_info *d, ide_hwif_t *hwif)
+void ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
-#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u16 pcicmd;
 
 	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
@@ -448,8 +446,8 @@ static void ide_hwif_setup_dma(struct pci_dev *dev, const struct ide_port_info *
 				"(BIOS)\n", hwif->name, d->name);
 		}
 	}
-#endif /* CONFIG_BLK_DEV_IDEDMA_PCI*/
 }
+#endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 /**
  *	ide_setup_pci_controller	-	set up IDE PCI
@@ -511,7 +509,7 @@ out:
 void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d, int pciirq, u8 *idx)
 {
 	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
-	ide_hwif_t *hwif, *mate = NULL;
+	ide_hwif_t *hwif;
 	u8 tmp;
 
 	/*
@@ -527,56 +525,11 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d, int
 			continue;	/* port not enabled */
 		}
 
-		if ((hwif = ide_hwif_configure(dev, d, mate, port, pciirq)) == NULL)
+		hwif = ide_hwif_configure(dev, d, port, pciirq);
+		if (hwif == NULL)
 			continue;
 
 		*(idx + port) = hwif->index;
-
-		if (d->init_iops)
-			d->init_iops(hwif);
-
-		if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0)
-			ide_hwif_setup_dma(dev, d, hwif);
-
-		if ((!hwif->irq && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
-		    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS))
-			hwif->irq = port ? 15 : 14;
-
-		hwif->host_flags = d->host_flags;
-		hwif->pio_mask = d->pio_mask;
-
-		if ((d->host_flags & IDE_HFLAG_SERIALIZE) && hwif->mate)
-			hwif->mate->serialized = hwif->serialized = 1;
-
-		if (d->host_flags & IDE_HFLAG_IO_32BIT) {
-			hwif->drives[0].io_32bit = 1;
-			hwif->drives[1].io_32bit = 1;
-		}
-
-		if (d->host_flags & IDE_HFLAG_UNMASK_IRQS) {
-			hwif->drives[0].unmask = 1;
-			hwif->drives[1].unmask = 1;
-		}
-
-		if (hwif->dma_base) {
-			hwif->swdma_mask = d->swdma_mask;
-			hwif->mwdma_mask = d->mwdma_mask;
-			hwif->ultra_mask = d->udma_mask;
-		}
-
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
-
-		if (d->host_flags & IDE_HFLAG_RQSIZE_256)
-			hwif->rqsize = 256;
-
-		if (d->init_hwif)
-			/* Call chipset-specific routine
-			 * for each enabled hwif
-			 */
-			d->init_hwif(hwif);
-
-		mate = hwif;
 	}
 }
 
@@ -658,7 +611,7 @@ int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
 	ret = do_ide_setup_pci_device(dev, d, &idx[0], 1);
 
 	if (ret >= 0)
-		ide_device_add(idx);
+		ide_device_add(idx, d);
 
 	return ret;
 }
@@ -682,7 +635,7 @@ int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
 			goto out;
 	}
 
-	ide_device_add(idx);
+	ide_device_add(idx, d);
 out:
 	return ret;
 }
diff --git a/drivers/macintosh/mediabay.c b/drivers/macintosh/mediabay.c
index 18dde2a..de9ebbf 100644
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -595,7 +595,7 @@ static void media_bay_step(int i)
     	        if (bay->cd_index >= 0) {
 			printk(KERN_DEBUG "Unregistering mb %d ide, index:%d\n", i,
 			       bay->cd_index);
-			ide_unregister(bay->cd_index);
+			ide_unregister(bay->cd_index, 1, 1);
 			bay->cd_index = -1;
 		}
 	    	if (bay->cd_retry) {
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 5ed0006..6c4f0f0 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -588,19 +588,14 @@ static ide_startstop_t idescsi_issue_pc (ide_drive_t *drive, idescsi_pc_t *pc)
 		hwif->sg_mapped = 0;
 	}
 
-	SELECT_DRIVE(drive);
-
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK, bcount, dma);
 
 	if (dma)
 		set_bit(PC_DMA_OK, &pc->flags);
 
 	if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
-		BUG_ON(HWGROUP(drive)->handler != NULL);
-		ide_set_handler(drive, &idescsi_transfer_pc,
-				get_timeout(pc), idescsi_expiry);
-		/* Issue the packet command */
-		HWIF(drive)->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		ide_execute_command(drive, WIN_PACKETCMD, &idescsi_transfer_pc,
+				    get_timeout(pc), idescsi_expiry);
 		return ide_started;
 	} else {
 		/* Issue the packet command */
diff --git a/include/linux/hdreg.h b/include/linux/hdreg.h
index ff43f8d..3882013 100644
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -706,8 +706,10 @@ struct hd_driveid {
  */
 #define IDE_NICE_DSC_OVERLAP	(0)	/* per the DSC overlap protocol */
 #define IDE_NICE_ATAPI_OVERLAP	(1)	/* not supported yet */
-#define IDE_NICE_0		(2)	/* when sure that it won't affect us */
 #define IDE_NICE_1		(3)	/* when probably won't affect us much */
+#ifndef __KERNEL__
+#define IDE_NICE_0		(2)	/* when sure that it won't affect us */
 #define IDE_NICE_2		(4)	/* when we know it's on our expense */
+#endif
 
 #endif	/* _LINUX_HDREG_H */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index ec10b2a..367c170 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -112,18 +112,12 @@ typedef unsigned char	byte;	/* used everywhere */
 #define SATA_NR_PORTS		(3)	/* 16 possible ?? */
 
 #define SATA_STATUS_OFFSET	(0)
-#define SATA_STATUS_REG		(HWIF(drive)->sata_scr[SATA_STATUS_OFFSET])
 #define SATA_ERROR_OFFSET	(1)
-#define SATA_ERROR_REG		(HWIF(drive)->sata_scr[SATA_ERROR_OFFSET])
 #define SATA_CONTROL_OFFSET	(2)
-#define SATA_CONTROL_REG	(HWIF(drive)->sata_scr[SATA_CONTROL_OFFSET])
 
 #define SATA_MISC_OFFSET	(0)
-#define SATA_MISC_REG		(HWIF(drive)->sata_misc[SATA_MISC_OFFSET])
 #define SATA_PHY_OFFSET		(1)
-#define SATA_PHY_REG		(HWIF(drive)->sata_misc[SATA_PHY_OFFSET])
 #define SATA_IEN_OFFSET		(2)
-#define SATA_IEN_REG		(HWIF(drive)->sata_misc[SATA_IEN_OFFSET])
 
 /*
  * Our Physical Region Descriptor (PRD) table should be large enough
@@ -196,6 +190,7 @@ typedef struct hw_regs_s {
 } hw_regs_t;
 
 struct hwif_s * ide_find_port(unsigned long);
+struct hwif_s *ide_deprecated_find_port(unsigned long);
 void ide_init_port_data(struct hwif_s *, unsigned int);
 void ide_init_port_hw(struct hwif_s *, hw_regs_t *);
 
@@ -406,8 +401,6 @@ typedef struct ide_drive_s {
 	unsigned no_unmask	: 1;	/* disallow setting unmask bit */
 	unsigned no_io_32bit	: 1;	/* disallow enabling 32bit I/O */
 	unsigned atapi_overlap	: 1;	/* ATAPI overlap (not supported) */
-	unsigned nice0		: 1;	/* give obvious excess bandwidth */
-	unsigned nice2		: 1;	/* give a share in our own bandwidth */
 	unsigned doorlocking	: 1;	/* for removable only: door lock/unlock works */
 	unsigned nodma		: 1;	/* disallow DMA */
 	unsigned autotune	: 2;	/* 0=default, 1=autotune, 2=noautotune */
@@ -487,7 +480,6 @@ typedef struct hwif_s {
 	u8 major;	/* our major number */
 	u8 index;	/* 0 for ide0; 1 for ide1; ... */
 	u8 channel;	/* for dual-port chips: 0=primary, 1=secondary */
-	u8 straight8;	/* Alan's straight 8 check */
 	u8 bus_state;	/* power state of the IDE bus */
 
 	u32 host_flags;
@@ -513,6 +505,8 @@ typedef struct hwif_s {
 #if 0
 	ide_hwif_ops_t	*hwifops;
 #else
+	/* host specific initialization of devices on a port */
+	void	(*port_init_devs)(struct hwif_s *);
 	/* routine to program host for PIO mode */
 	void	(*set_pio_mode)(ide_drive_t *, const u8);
 	/* routine to program host for DMA mode */
@@ -535,6 +529,8 @@ typedef struct hwif_s {
 	u8 (*mdma_filter)(ide_drive_t *);
 	u8 (*udma_filter)(ide_drive_t *);
 
+	u8 (*cable_detect)(struct hwif_s *);
+
 	void (*ata_input_data)(ide_drive_t *, void *, u32);
 	void (*ata_output_data)(ide_drive_t *, void *, u32);
 
@@ -602,10 +598,9 @@ typedef struct hwif_s {
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
 	unsigned	reset      : 1;	/* reset after probe */
-	unsigned	auto_poll  : 1; /* supports nop auto-poll */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
-	unsigned	no_io_32bit : 1; /* 1 = can not do 32-bit IO ops */
 	unsigned	mmio       : 1; /* host uses MMIO */
+	unsigned	straight8  : 1;	/* Alan's straight 8 check */
 
 	struct device	gendev;
 	struct completion gendev_rel_comp; /* To deal with device release() */
@@ -625,6 +620,9 @@ typedef struct hwif_s {
 typedef ide_startstop_t (ide_handler_t)(ide_drive_t *);
 typedef int (ide_expiry_t)(ide_drive_t *);
 
+/* used by ide-cd, ide-floppy, etc. */
+typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
+
 typedef struct hwgroup_s {
 		/* irq handler, if active */
 	ide_startstop_t	(*handler)(ide_drive_t *);
@@ -708,6 +706,7 @@ typedef struct {
 void proc_ide_create(void);
 void proc_ide_destroy(void);
 void ide_proc_register_port(ide_hwif_t *);
+void ide_proc_port_register_devices(ide_hwif_t *);
 void ide_proc_unregister_port(ide_hwif_t *);
 void ide_proc_register_driver(ide_drive_t *, ide_driver_t *);
 void ide_proc_unregister_driver(ide_drive_t *, ide_driver_t *);
@@ -740,6 +739,7 @@ void ide_pci_create_host_proc(const char *, get_info_t *);
 static inline void proc_ide_create(void) { ; }
 static inline void proc_ide_destroy(void) { ; }
 static inline void ide_proc_register_port(ide_hwif_t *hwif) { ; }
+static inline void ide_proc_port_register_devices(ide_hwif_t *hwif) { ; }
 static inline void ide_proc_unregister_port(ide_hwif_t *hwif) { ; }
 static inline void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
 static inline void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
@@ -988,10 +988,8 @@ int ide_task_ioctl(ide_drive_t *, unsigned int, unsigned long);
 extern int system_bus_clock(void);
 
 extern int ide_driveid_update(ide_drive_t *);
-extern int ide_ata66_check(ide_drive_t *, ide_task_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
 extern u8 eighty_ninty_three (ide_drive_t *);
-extern int set_transfer(ide_drive_t *, ide_task_t *);
 extern int taskfile_lib_get_identify(ide_drive_t *drive, u8 *);
 
 extern int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout);
@@ -1016,6 +1014,13 @@ extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *o
 void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int, u8 *);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
+#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+void ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
+#else
+static inline void ide_hwif_setup_dma(ide_hwif_t *hwif,
+				      const struct ide_port_info *d) { }
+#endif
+
 extern void default_hwif_iops(ide_hwif_t *);
 extern void default_hwif_mmiops(ide_hwif_t *);
 extern void default_hwif_transport(ide_hwif_t *);
@@ -1052,7 +1057,7 @@ enum {
 	IDE_HFLAG_NO_SET_MODE		= (1 << 9),
 	/* trust BIOS for programming chipset/device for DMA */
 	IDE_HFLAG_TRUST_BIOS_FOR_DMA	= (1 << 10),
-	/* host uses VDMA */
+	/* host uses VDMA (tied with IDE_HFLAG_CS5520 for now) */
 	IDE_HFLAG_VDMA			= (1 << 11),
 	/* ATAPI DMA is unsupported */
 	IDE_HFLAG_NO_ATAPI_DMA		= (1 << 12),
@@ -1062,8 +1067,10 @@ enum {
 	IDE_HFLAG_NO_DMA		= (1 << 14),
 	/* check if host is PCI IDE device before allowing DMA */
 	IDE_HFLAG_NO_AUTODMA		= (1 << 15),
+	/* don't autotune PIO */
+	IDE_HFLAG_NO_AUTOTUNE		= (1 << 16),
 	/* host is CS5510/CS5520 */
-	IDE_HFLAG_CS5520		= (1 << 16),
+	IDE_HFLAG_CS5520		= IDE_HFLAG_VDMA,
 	/* no LBA48 */
 	IDE_HFLAG_NO_LBA48		= (1 << 17),
 	/* no LBA48 DMA */
@@ -1089,6 +1096,10 @@ enum {
 	IDE_HFLAG_CLEAR_SIMPLEX		= (1 << 28),
 	/* DSC overlap is unsupported */
 	IDE_HFLAG_NO_DSC		= (1 << 29),
+	/* never use 32-bit I/O ops */
+	IDE_HFLAG_NO_IO_32BIT		= (1 << 30),
+	/* never unmask IRQs */
+	IDE_HFLAG_NO_UNMASK_IRQS	= (1 << 31),
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
@@ -1144,6 +1155,7 @@ void ide_dma_off_quietly(ide_drive_t *);
 void ide_dma_off(ide_drive_t *);
 void ide_dma_on(ide_drive_t *);
 int ide_set_dma(ide_drive_t *);
+void ide_check_dma_crc(ide_drive_t *);
 ide_startstop_t ide_dma_intr(ide_drive_t *);
 
 int ide_build_sglist(ide_drive_t *, struct request *);
@@ -1171,6 +1183,7 @@ static inline void ide_dma_off(ide_drive_t *drive) { ; }
 static inline void ide_dma_on(ide_drive_t *drive) { ; }
 static inline void ide_dma_verbose(ide_drive_t *drive) { ; }
 static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
+static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifndef CONFIG_BLK_DEV_IDEDMA_PCI
@@ -1182,27 +1195,29 @@ extern int ide_acpi_exec_tfs(ide_drive_t *drive);
 extern void ide_acpi_get_timing(ide_hwif_t *hwif);
 extern void ide_acpi_push_timing(ide_hwif_t *hwif);
 extern void ide_acpi_init(ide_hwif_t *hwif);
+void ide_acpi_port_init_devices(ide_hwif_t *);
 extern void ide_acpi_set_state(ide_hwif_t *hwif, int on);
 #else
 static inline int ide_acpi_exec_tfs(ide_drive_t *drive) { return 0; }
 static inline void ide_acpi_get_timing(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_push_timing(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_init(ide_hwif_t *hwif) { ; }
+static inline void ide_acpi_port_init_devices(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
 void ide_remove_port_from_hwgroup(ide_hwif_t *);
 extern int ide_hwif_request_regions(ide_hwif_t *hwif);
 extern void ide_hwif_release_regions(ide_hwif_t* hwif);
-extern void ide_unregister (unsigned int index);
+void ide_unregister(unsigned int, int, int);
 
 void ide_register_region(struct gendisk *);
 void ide_unregister_region(struct gendisk *);
 
 void ide_undecoded_slave(ide_drive_t *);
 
-int ide_device_add_all(u8 *idx);
-int ide_device_add(u8 idx[4]);
+int ide_device_add_all(u8 *idx, const struct ide_port_info *);
+int ide_device_add(u8 idx[4], const struct ide_port_info *);
 
 static inline void *ide_get_hwifdata (ide_hwif_t * hwif)
 {
