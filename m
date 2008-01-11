Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbYAKMFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbYAKMFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759129AbYAKMDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:03:40 -0500
Received: from smtp108.plus.mail.re1.yahoo.com ([69.147.102.71]:24340 "HELO
	smtp108.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758548AbYAKMDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=ghh5R855ffmHE+cBvCcnYmMdCA86T9fLeyWxuki5fP5X5yIj70F87Y7mxbStdvRqRl3sGZSXkYj6x7jt6+RcSPA8M6HMQiu/eZ8QlZdZ+VzKMSNaR7dybu8HOB/h6QtABz8cVGsNemfw43spZftPNve3lAWXjibZush2ksAc3f8=  ;
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 11/21] ide-floppy: fix comments formatting
Date: Fri, 11 Jan 2008 12:58:09 +0100
Message-Id: <1200052699-28420-12-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-11-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-9-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-10-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-11-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is,
- remove unnecessary comments
- shorten comments
- shorten lines longer 80 columns
- cleanup whitespace
- add a missing loglevel KERN_ to a printk-call
- fix misc checkpatch warnings

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |  402 +++++++++++++++++++++-------------------------
 1 files changed, 181 insertions(+), 221 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 11c2c9b..5d612e7 100644
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
@@ -47,14 +42,11 @@
 #include <asm/io.h>
 #include <asm/unaligned.h>
 
-/*
- *	The following are used to debug the driver.
- */
+/* The following are used to debug the driver. */
 #define IDEFLOPPY_DEBUG_LOG		0
 #define IDEFLOPPY_DEBUG_INFO		0
 #define IDEFLOPPY_DEBUG_BUGS		1
 
-/* #define IDEFLOPPY_DEBUG(fmt, args...) printk(KERN_INFO fmt, ## args) */
 #define IDEFLOPPY_DEBUG( fmt, args... )
 
 #if IDEFLOPPY_DEBUG_LOG
@@ -65,59 +57,56 @@
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
+ * With each packet command, we allocate a buffer of
+ * IDEFLOPPY_PC_BUFFER_SIZE bytes.
  */
 #define IDEFLOPPY_PC_BUFFER_SIZE	256
 
 /*
- *	In various places in the driver, we need to allocate storage
- *	for packet commands and requests, which will remain valid while
- *	we leave the driver to wait for an interrupt or a timeout event.
+ * In various places in the driver, we need to allocate storage for packet
+ * commands and requests, which will remain valid while we leave the driver to
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
+	unsigned long flags;			/* Status/Action bit flags:
+						   long for set_bit */
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
+/* Packet command flag bits. */
+#define	PC_ABORT		0	/* Set when an error is considered\
+					   normal - We won't retry */
+#define PC_DMA_RECOMMENDED	2	/* DMA use preferred, if possible */
+#define	PC_DMA_IN_PROGRESS	3	/* 1 while DMA in progress */
+#define	PC_DMA_ERROR		4	/* problem encountered during DMA */
+#define	PC_WRITING		5	/* Data direction */
+#define	PC_SUPPRESS_ERROR	6	/* Suppress error reporting */
 
 /* format capacities descriptor codes */
 #define CAPACITY_INVALID	0x00
@@ -126,9 +115,9 @@ typedef struct idefloppy_packet_command_s {
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
@@ -149,17 +138,13 @@ typedef struct ide_floppy_obj {
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
 	/* Write protect */
@@ -172,44 +157,36 @@ typedef struct ide_floppy_obj {
 
 #define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
 
-/*
- *	Floppy flag bits values.
- */
+/* Floppy flag bits values. */
 #define IDEFLOPPY_DRQ_INTERRUPT		0	/* DRQ interrupt device */
 #define IDEFLOPPY_MEDIA_CHANGED		1	/* Media may have changed */
-#define IDEFLOPPY_USE_READ12		2	/* Use READ12/WRITE12 or READ10/WRITE10 */
+#define IDEFLOPPY_USE_READ12		2	/* READ(10|12)/WRITE(10|12) */
 #define	IDEFLOPPY_FORMAT_IN_PROGRESS	3	/* Format in progress */
-#define IDEFLOPPY_CLIK_DRIVE	        4       /* Avoid commands not supported in Clik drive */
-#define IDEFLOPPY_ZIP_DRIVE		5	/* Requires BH algorithm for packets */
+#define IDEFLOPPY_CLIK_DRIVE	        4       /* Avoid commands not supported\
+						   in Clik drive */
+#define IDEFLOPPY_ZIP_DRIVE		5	/* Requires BH algorithm for\
+						   packets */
 
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
+ * The following is used to format the general configuration word of the ATAPI
+ * IDENTIFY DEVICE command.
  */
-struct idefloppy_id_gcw {	
+struct idefloppy_id_gcw {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	unsigned packet_size		:2;	/* Packet Size */
 	unsigned reserved234		:3;	/* Reserved */
@@ -267,17 +244,17 @@ static void ide_floppy_put(struct ide_floppy_obj *floppy)
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
 
 #if IDEFLOPPY_DEBUG_BUGS
-static void idefloppy_write_zeros (ide_drive_t *drive, unsigned int bcount)
+static void idefloppy_write_zeros(ide_drive_t *drive, unsigned int bcount)
 {
 	while (bcount--)
 		HWIF(drive)->OUTB(0, IDE_DATA_REG);
@@ -286,10 +263,8 @@ static void idefloppy_write_zeros (ide_drive_t *drive, unsigned int bcount)
 
 
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
@@ -320,7 +295,8 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	return 0;
 }
 
-static void idefloppy_input_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, unsigned int bcount)
+static void idefloppy_input_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
+		unsigned int bcount)
 {
 	struct request *rq = pc->rq;
 	struct bio_vec *bvec;
@@ -347,12 +323,14 @@ static void idefloppy_input_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, uns
 	idefloppy_do_end_request(drive, 1, done >> 9);
 
 	if (bcount) {
-		printk(KERN_ERR "%s: leftover data in idefloppy_input_buffers, bcount == %d\n", drive->name, bcount);
+		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
+				drive->name, __FUNCTION__, bcount);
 		idefloppy_discard_data(drive, bcount);
 	}
 }
 
-static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, unsigned int bcount)
+static void idefloppy_output_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
+		unsigned int bcount)
 {
 	struct request *rq = pc->rq;
 	struct req_iterator iter;
@@ -380,13 +358,14 @@ static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, un
 
 #if IDEFLOPPY_DEBUG_BUGS
 	if (bcount) {
-		printk(KERN_ERR "%s: leftover data in idefloppy_output_buffers, bcount == %d\n", drive->name, bcount);
+		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
+				drive->name, __FUNCTION__, bcount);
 		idefloppy_write_zeros(drive, bcount);
 	}
 #endif
 }
 
-static void idefloppy_update_buffers (ide_drive_t *drive, idefloppy_pc_t *pc)
+static void idefloppy_update_buffers(ide_drive_t *drive, idefloppy_pc_t *pc)
 {
 	struct request *rq = pc->rq;
 	struct bio *bio = rq->bio;
@@ -396,11 +375,12 @@ static void idefloppy_update_buffers (ide_drive_t *drive, idefloppy_pc_t *pc)
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
 
@@ -411,7 +391,7 @@ static void idefloppy_queue_pc_head (ide_drive_t *drive,idefloppy_pc_t *pc,struc
 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
 }
 
-static idefloppy_pc_t *idefloppy_next_pc_storage (ide_drive_t *drive)
+static idefloppy_pc_t *idefloppy_next_pc_storage(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
@@ -420,7 +400,7 @@ static idefloppy_pc_t *idefloppy_next_pc_storage (ide_drive_t *drive)
 	return (&floppy->pc_stack[floppy->pc_stack_index++]);
 }
 
-static struct request *idefloppy_next_rq_storage (ide_drive_t *drive)
+static struct request *idefloppy_next_rq_storage(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
@@ -465,10 +445,8 @@ static void idefloppy_request_sense_callback(ide_drive_t *drive)
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
 
@@ -477,10 +455,7 @@ static void idefloppy_pc_callback (ide_drive_t *drive)
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
@@ -491,7 +466,7 @@ static void idefloppy_init_pc (idefloppy_pc_t *pc)
 	pc->callback = &idefloppy_pc_callback;
 }
 
-static void idefloppy_create_request_sense_cmd (idefloppy_pc_t *pc)
+static void idefloppy_create_request_sense_cmd(idefloppy_pc_t *pc)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_REQUEST_SENSE;
@@ -501,11 +476,10 @@ static void idefloppy_create_request_sense_cmd (idefloppy_pc_t *pc)
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
@@ -518,10 +492,9 @@ static void idefloppy_retry_pc (ide_drive_t *drive)
 }
 
 /*
- *	idefloppy_pc_intr is the usual interrupt handler which will be called
- *	during a packet command.
+ * The usual interrupt handler called during a packet command.
  */
-static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
+static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
@@ -639,16 +612,17 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	pc->actually_transferred += bcount;
 	pc->current_position += bcount;
 
-	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);		/* And set the interrupt handler again */
+	/* And set the interrupt handler again */
+	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
 	return ide_started;
 }
 
 /*
  * This is the original routine that did the packet transfer.
  * It fails at high speeds on the Iomega ZIP drive, so there's a slower version
- * for that drive below. The algorithm is chosen based on drive type
+ * for that drive below. The algorithm is chosen based on drive type.
  */
-static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
+static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
 {
 	ide_startstop_t startstop;
 	idefloppy_floppy_t *floppy = drive->driver_data;
@@ -675,18 +649,16 @@ static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
 
 
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
 
@@ -696,7 +668,7 @@ static int idefloppy_transfer_pc2 (ide_drive_t *drive)
 	return IDEFLOPPY_WAIT_CMD;
 }
 
-static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
+static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_startstop_t startstop;
@@ -713,7 +685,7 @@ static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
 				"while issuing a packet command\n");
 		return ide_do_reset(drive);
 	}
-	/* 
+	/*
 	 * The following delay solves a problem with ATAPI Zip 100 drives
 	 * where the Busy flag was apparently being deasserted before the
 	 * unit was ready to receive data. This was happening on a
@@ -722,17 +694,15 @@ static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
 	 * used until after the packet is moved in about 50 msec.
 	 */
 
-	ide_set_handler(drive, 
-	  &idefloppy_pc_intr, 		/* service routine for packet command */
+	ide_set_handler(drive,
+	  &idefloppy_pc_intr,		/* service routine for packet command */
 	  floppy->ticks,		/* wait this long before "failing" */
 	  &idefloppy_transfer_pc2);	/* fail == transfer_pc2 */
 	return ide_started;
 }
 
-/**
- * idefloppy_should_report_error()
- *
- * Supresses error messages resulting from Medium not present
+/*
+ * Suppresses error messages resulting from Medium not present.
  */
 static inline int idefloppy_should_report_error(idefloppy_floppy_t *floppy)
 {
@@ -743,10 +713,8 @@ static inline int idefloppy_should_report_error(idefloppy_floppy_t *floppy)
 	return 1;
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
@@ -816,7 +784,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 		/* immediate */
 		pkt_xfer_routine = &idefloppy_transfer_pc;
 	}
-	
+
 	if (test_bit (IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags)) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
@@ -831,7 +799,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 	}
 }
 
-static void idefloppy_rw_callback (ide_drive_t *drive)
+static void idefloppy_rw_callback(ide_drive_t *drive)
 {
 	debug_log("Reached %s\n", __FUNCTION__);
 
@@ -839,7 +807,7 @@ static void idefloppy_rw_callback (ide_drive_t *drive)
 	return;
 }
 
-static void idefloppy_create_prevent_cmd (idefloppy_pc_t *pc, int prevent)
+static void idefloppy_create_prevent_cmd(idefloppy_pc_t *pc, int prevent)
 {
 	debug_log("creating prevent removal command, prevent = %d\n", prevent);
 
@@ -848,7 +816,7 @@ static void idefloppy_create_prevent_cmd (idefloppy_pc_t *pc, int prevent)
 	pc->c[4] = prevent;
 }
 
-static void idefloppy_create_read_capacity_cmd (idefloppy_pc_t *pc)
+static void idefloppy_create_read_capacity_cmd(idefloppy_pc_t *pc)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
@@ -857,7 +825,7 @@ static void idefloppy_create_read_capacity_cmd (idefloppy_pc_t *pc)
 	pc->request_transfer = 255;
 }
 
-static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
+static void idefloppy_create_format_unit_cmd(idefloppy_pc_t *pc, int b, int l,
 					      int flags)
 {
 	idefloppy_init_pc(pc);
@@ -878,9 +846,7 @@ static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
 	set_bit(PC_WRITING, &pc->flags);
 }
 
-/*
- *	A mode sense command is used to "sense" floppy parameters.
- */
+/* A mode sense command is used to "sense" floppy parameters. */
 static void idefloppy_create_mode_sense_cmd(idefloppy_pc_t *pc, u8 page_code,
 		u8 type)
 {
@@ -906,7 +872,7 @@ static void idefloppy_create_mode_sense_cmd(idefloppy_pc_t *pc, u8 page_code,
 	pc->request_transfer = length;
 }
 
-static void idefloppy_create_start_stop_cmd (idefloppy_pc_t *pc, int start)
+static void idefloppy_create_start_stop_cmd(idefloppy_pc_t *pc, int start)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_START_STOP_UNIT;
@@ -919,7 +885,8 @@ static void idefloppy_create_test_unit_ready_cmd(idefloppy_pc_t *pc)
 	pc->c[0] = GPCMD_TEST_UNIT_READY;
 }
 
-static void idefloppy_create_rw_cmd (idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct request *rq, unsigned long sector)
+static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
+		idefloppy_pc_t *pc, struct request *rq, unsigned long sector)
 {
 	int block = sector / floppy->bs_factor;
 	int blocks = rq->nr_sectors / floppy->bs_factor;
@@ -948,8 +915,8 @@ static void idefloppy_create_rw_cmd (idefloppy_floppy_t *floppy, idefloppy_pc_t
 	set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
 
-static void
-idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct request *rq)
+static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
+		idefloppy_pc_t *pc, struct request *rq)
 {
 	idefloppy_init_pc(pc);
 	pc->callback = &idefloppy_rw_callback;
@@ -961,18 +928,17 @@ idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct req
 	pc->buffer = rq->data;
 	if (rq->bio)
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
-		
+
 	/*
-	 * possibly problematic, doesn't look like ide-floppy correctly
-	 * handled scattered requests if dma fails...
+	 * possibly problematic, doesn't look like ide-floppy correctly handled
+	 * scattered requests if dma fails...
 	 */
 	pc->request_transfer = pc->buffer_size = rq->data_len;
 }
 
-/*
- *	idefloppy_do_request is our request handling function.	
- */
-static ide_startstop_t idefloppy_do_request (ide_drive_t *drive, struct request *rq, sector_t block_s)
+/* Our request handler */
+static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
+		struct request *rq, sector_t block_s)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t *pc;
@@ -1026,10 +992,10 @@ static ide_startstop_t idefloppy_do_request (ide_drive_t *drive, struct request
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
@@ -1278,20 +1244,20 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
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
+ * Send ATAPI_FORMAT_UNIT to the drive.
+ *
+ * Userland gives us the following structure:
+ *
+ * struct idefloppy_format_command {
+ *        int nblocks;
+ *        int blocksize;
+ *        int flags;
+ *        } ;
+ *
+ * flags is a bitmask, currently, the only defined flag is:
+ *
+ *        0x01 - verify media after format.
+ */
 
 static int idefloppy_begin_format(ide_drive_t *drive, int __user *arg)
 {
@@ -1316,14 +1282,14 @@ static int idefloppy_begin_format(ide_drive_t *drive, int __user *arg)
 }
 
 /*
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
@@ -1342,8 +1308,7 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 		    floppy->ascq == 4) {
 			progress_indication = floppy->progress_indication;
 		}
-		/* Else assume format_unit has finished, and we're
-		** at 0x10000 */
+		/* Else assume format_unit has finished, and we're at 0x10000 */
 	} else {
 		unsigned long flags;
 		u8 stat;
@@ -1360,10 +1325,7 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
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
@@ -1372,8 +1334,7 @@ static sector_t idefloppy_capacity (ide_drive_t *drive)
 }
 
 /*
- *	idefloppy_identify_device checks if we can support a drive,
- *	based on the ATAPI IDENTIFY command results.
+ * Check if we can support a drive, based on the ATAPI IDENTIFY command results.
  */
 static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 {
@@ -1389,7 +1350,7 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 	if ((gcw.device_type == 5) &&
 	    !strstr(id->model, "CD-ROM") &&
 	    strstr(id->model, "ZIP"))
-		gcw.device_type = 0;			
+		gcw.device_type = 0;
 #endif
 
 #if IDEFLOPPY_DEBUG_INFO
@@ -1411,7 +1372,7 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 		default: sprintf(buffer, "Reserved");
 	}
 	printk(KERN_INFO "Device Type: %x - %s\n", gcw.device_type, buffer);
-	printk(KERN_INFO "Removable: %s\n",gcw.removable ? "Yes":"No");	
+	printk(KERN_INFO "Removable: %s\n", gcw.removable ? "Yes":"No");
 	switch (gcw.drq_type) {
 		case 0: sprintf(buffer, "Microprocessor DRQ");break;
 		case 1: sprintf(buffer, "Interrupt DRQ");break;
@@ -1447,22 +1408,20 @@ static void idefloppy_add_settings(ide_drive_t *drive)
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
 
@@ -1470,15 +1429,15 @@ static void idefloppy_setup (ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	floppy->pc = floppy->pc_stack;
 	if (gcw.drq_type == 1)
 		set_bit(IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags);
+
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
 
 	if (!strncmp(drive->id->model, "IOMEGA ZIP 100 ATAPI", 20)) {
@@ -1489,16 +1448,14 @@ static void idefloppy_setup (ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	}
 
 	/*
-	*      Guess what?  The IOMEGA Clik! drive also needs the
-	*      above fix.  It makes nasty clicking noises without
-	*      it, so please don't remove this.
-	*/
+	 * Guess what?  The IOMEGA Clik! drive also needs the above fix. It
+	 * makes nasty clicking noises without it, so please don't remove this.
+	 */
 	if (strncmp(drive->id->model, "IOMEGA Clik!", 11) == 0) {
 		blk_queue_max_sectors(drive->queue, 64);
 		set_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags);
 	}
 
-
 	(void) idefloppy_get_capacity(drive);
 	idefloppy_add_settings(drive);
 }
@@ -1528,8 +1485,8 @@ static void ide_floppy_release(struct kref *kref)
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static int proc_idefloppy_read_capacity
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
+static int proc_idefloppy_read_capacity(char *page, char **start, off_t off,
+		int count, int *eof, void *data)
 {
 	ide_drive_t*drive = (ide_drive_t *)data;
 	int len;
@@ -1539,8 +1496,8 @@ static int proc_idefloppy_read_capacity
 }
 
 static ide_proc_entry_t idefloppy_proc[] = {
-	{ "capacity",	S_IFREG|S_IRUGO,	proc_idefloppy_read_capacity, NULL },
-	{ "geometry",	S_IFREG|S_IRUGO,	proc_ide_read_geometry,	NULL },
+	{ "capacity",	S_IFREG|S_IRUGO, proc_idefloppy_read_capacity,	NULL },
+	{ "geometry",	S_IFREG|S_IRUGO, proc_ide_read_geometry,	NULL },
 	{ NULL, 0, NULL, NULL }
 };
 #endif	/* CONFIG_IDE_PROC_FS */
@@ -1597,10 +1554,10 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 		if (idefloppy_get_capacity (drive)
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
@@ -1685,7 +1642,8 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 		if (floppy->openers > 1)
 			return -EBUSY;
 
-		/* The IOMEGA Clik! Drive doesn't support this command - no room for an eject mechanism */
+		/* The IOMEGA Clik! Drive doesn't support this command - no room
+		 * for an eject mechanism */
                 if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
 			idefloppy_create_prevent_cmd(&pc, prevent);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
@@ -1719,11 +1677,10 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 			clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
 		return err;
 		/*
-		** Note, the bit will be cleared when the device is
-		** closed.  This is the cleanest way to handle the
-		** situation where the drive does not support
-		** format progress reporting.
-		*/
+		 * Note, the bit will be cleared when the device is closed. This
+		 * is the cleanest way to handle the situation where the drive
+		 * does not support format progress reporting.
+		 */
 	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
 		return idefloppy_get_format_progress(drive, argp);
 	}
@@ -1786,15 +1743,18 @@ static int ide_floppy_probe(ide_drive_t *drive)
 	if (drive->media != ide_floppy)
 		goto failed;
 	if (!idefloppy_identify_device (drive, drive->id)) {
-		printk (KERN_ERR "ide-floppy: %s: not supported by this version of ide-floppy\n", drive->name);
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
 	if ((floppy = kzalloc(sizeof (idefloppy_floppy_t), GFP_KERNEL)) == NULL) {
-		printk (KERN_ERR "ide-floppy: %s: Can't allocate a floppy structure\n", drive->name);
+		printk(KERN_ERR "ide-floppy: %s: Can't allocate a floppy"
+				" structure\n", drive->name);
 		goto failed;
 	}
 
-- 
1.5.3.7

