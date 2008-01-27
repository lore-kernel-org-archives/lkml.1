Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYA0IoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYA0IoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 03:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbYA0Ims
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 03:42:48 -0500
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:30223 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756294AbYA0Imk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 03:42:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=uB54QJEFGULuQOAU/bvvLIu8xHzQdG7K/2HQ0IfdtvIUqhpqUJ5QJlH9z8SNPiqwEez+NC+fciX5q+CWGzvUBN63iX3b7U6gMJ/irXzVNW4YAXraI3ILXN0YuKTwrjTqAuspgTkRYl4y+UxcywyLEOxnK+7AXh4v46nPcxyhMFs=  ;
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 1/32] ide-tape: move historical changelog to Documentation/ide/ChangeLog.ide-tape.1995-2002
Date: Sun, 27 Jan 2008 09:41:21 +0100
Message-Id: <1201423312-2460-2-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
References: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, cleanup whitespace and update comments.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 Documentation/ide/ChangeLog.ide-tape.1995-2002 |  405 +++++++++++++++++++++++
 drivers/ide/ide-tape.c                         |  414 +-----------------------
 2 files changed, 409 insertions(+), 410 deletions(-)

diff --git a/Documentation/ide/ChangeLog.ide-tape.1995-2002 b/Documentation/ide/ChangeLog.ide-tape.1995-2002
new file mode 100644
index 0000000..e406762
--- /dev/null
+++ b/Documentation/ide/ChangeLog.ide-tape.1995-2002
@@ -0,0 +1,405 @@
+/*
+ * IDE ATAPI streaming tape driver.
+ *
+ * This driver is a part of the Linux ide driver and works in co-operation
+ * with drivers/block/ide.c.
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
+
+
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index f159e7b..552cfed 100644
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
- *
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
  *
- *		ATAPI overlap is likely to be supported in most new ATAPI
- *		devices, including new ATAPI cdroms, and thus provides us
- *		a method by which we can achieve higher throughput when
- *		sharing a (fast) ATA-2 disk with any (slow) new ATAPI device.
+ * For a historical changelog see
+ * Documentation/ide/ChangeLog.ide-tape.1995-2002
  */
 
 #define IDETAPE_VERSION "1.19"
-- 
1.5.3.7

