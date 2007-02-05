Return-Path: <linux-kernel-owner+w=401wt.eu-S965098AbXBEX01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965098AbXBEX01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965081AbXBEX01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:26:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:43004 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965069AbXBEX0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:26:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=a9ERRjyXHQIYXcud6/3VjENkhWVZH1IALBj5RiGenrJfLxlNYozcxCXoclmkAkJQowozs3NmXA1IOqXPOqGuJsvV+M4FmtaTYg985PFloDhLQrAnMgFGYrf2aGsM/F5NbQGH2zXc2VNzNDLej3vkAnijIbAD/gF4ZLaeenaF8vs=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][1/5] floppy.c: Initial (partial) CodingStyle cleanup
Date: Tue, 6 Feb 2007 00:28:50 +0100
User-Agent: KMail/1.9.4
Cc: Andi Kleen <ak@suse.de>, Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702060028.50439.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a basic CodingStyle cleanup for drivers/block/floppy.c

There are no functional changes in this patch. 

Changes made are : 
 - remove some blank lines and insers others where it improves readability
 - make comments a bit more similar in style
 - make most lines fit within 80 columns
 - remove some unneeded curly braces
 - remove some trailing newlines
 - add some missing spaces
 - other minor trivialities

The reason for starting with this patch is simply to make the file nicer 
to work with for me and get whitespace changes and such out of the way 
from the beginning (and of course also to make it conform better to the 
CodingStyle document).


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 floppy.c |  203 ++++++++++++++++++++++++-----------------------------
 1 file changed, 94 insertions(+), 109 deletions(-)

--- linux-2.6.20-orig/drivers/block/floppy.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20/drivers/block/floppy.c	2007-02-05 23:08:39.000000000 +0100
@@ -5,6 +5,7 @@
  *  Copyright (C) 1993, 1994  Alain Knaff
  *  Copyright (C) 1998 Alan Cox
  */
+
 /*
  * 02.12.91 - Changed to static variables to indicate need for reset
  * and recalibrate. This makes some things easier (output_byte reset
@@ -149,22 +150,23 @@
 #define REALLY_SLOW_IO
 
 #define DEBUGT 2
-#define DCL_DEBUG		/* debug disk change line */
+#define DCL_DEBUG	/* debug disk change line */
 
 /* do print messages for unexpected interrupts */
 static int print_unex = 1;
+
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+
 #define FDPATCHES
-#include <linux/fdreg.h>
 
+#include <linux/fdreg.h>
 #include <linux/fd.h>
 #include <linux/hdreg.h>
-
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
@@ -224,7 +226,7 @@
 irqreturn_t floppy_interrupt(int irq, void *dev_id);
 static int set_dor(int fdc, char mask, char data);
 
-#define K_64	0x10000		/* 64KB */
+#define K_64	0x10000	/* 64KB */
 
 /* the following is the mask of allowed drives. By default units 2 and
  * 3 of both floppy controllers are disabled, because switching on the
@@ -271,11 +273,11 @@
 {
 #ifdef FLOPPY_CAN_FALLBACK_ON_NODMA
 	if (*addr)
-		return;		/* we have the memory */
+		return;	/* we have the memory */
 	if (can_use_virtual_dma != 2)
-		return;		/* no fallback allowed */
-	printk
-	    ("DMA memory shortage. Temporarily falling back on virtual DMA\n");
+		return;	/* no fallback allowed */
+	printk("DMA memory shortage. "
+		"Temporarily falling back on virtual DMA\n");
 	*addr = (char *)nodma_mem_alloc(l);
 #else
 	return;
@@ -309,7 +311,8 @@
 #define USETF(x) (set_bit(x##_BIT, &UDRS->flags))
 #define UTESTF(x) (test_bit(x##_BIT, &UDRS->flags))
 
-#define DPRINT(format, args...) printk(DEVICE_NAME "%d: " format, current_drive , ## args)
+#define DPRINT(format, args...) \
+	printk(DEVICE_NAME "%d: " format, current_drive , ## args)
 
 #define PH_HEAD(floppy,head) (((((floppy)->stretch & 2) >>1) ^ head) << 2)
 #define STRETCH(floppy) ((floppy)->stretch & FD_STRETCH)
@@ -340,14 +343,14 @@
  * current disk size is unknown.
  * [Now it is rather a minimum]
  */
-#define MAX_DISK_SIZE 4		/* 3984 */
+#define MAX_DISK_SIZE 4	/* 3984 */
 
 /*
  * globals used by 'result()'
  */
 #define MAX_REPLIES 16
 static unsigned char reply_buffer[MAX_REPLIES];
-static int inr;			/* size of reply buffer, when called from interrupt */
+static int inr;	/* size of reply buffer, when called from interrupt */
 #define ST0 (reply_buffer[0])
 #define ST1 (reply_buffer[1])
 #define ST2 (reply_buffer[2])
@@ -357,7 +360,7 @@
 #define R_SECTOR (reply_buffer[5])
 #define R_SIZECODE (reply_buffer[6])
 
-#define SEL_DLY (2*HZ/100)
+#define SEL_DLY (2 * HZ / 100)
 
 /*
  * this struct defines the different floppy drive types.
@@ -539,12 +542,12 @@
 static int max_buffer_sectors;
 
 static int *errors;
-typedef void (*done_f) (int);
+typedef void (*done_f)(int);
 static struct cont_t {
-	void (*interrupt) (void);	/* this is called after the interrupt of the
-					 * main command */
-	void (*redo) (void);	/* this is called to retry the operation */
-	void (*error) (void);	/* this is called to tally an error */
+	void (*interrupt)(void);	/* this is called after the interrupt
+					 * of the main command */
+	void (*redo)(void);	/* this is called to retry the operation */
+	void (*error)(void);	/* this is called to tally an error */
 	done_f done;		/* this is called to say if the operation has
 				 * succeeded/failed */
 } *cont;
@@ -565,7 +568,7 @@
  * reset doesn't need to be tested before sending commands, because
  * output_byte is automatically disabled when reset is set.
  */
-#define CHECK_RESET { if (FDCS->reset){ reset_fdc(); return; } }
+#define CHECK_RESET { if (FDCS->reset) { reset_fdc(); return; } }
 static void reset_fdc(void);
 
 /*
@@ -587,7 +590,7 @@
 
 /* fdc related variables, should end up in a struct */
 static struct floppy_fdc_state fdc_state[N_FDC];
-static int fdc;			/* current fdc */
+static int fdc;	/* current fdc */
 
 static struct floppy_struct *_floppy = floppy_type;
 static unsigned char current_drive;
@@ -625,7 +628,7 @@
 static inline void debugt(const char *message) { }
 #endif /* DEBUGT */
 
-typedef void (*timeout_fn) (unsigned long);
+typedef void (*timeout_fn)(unsigned long);
 static DEFINE_TIMER(fd_timeout, floppy_shutdown, 0, 0);
 
 static const char *timeout_message;
@@ -641,13 +644,13 @@
 }
 #endif
 
-static void (*do_floppy) (void) = NULL;
+static void (*do_floppy)(void) = NULL;
 
 #ifdef FLOPPY_SANITY_CHECK
 
 #define OLOGSIZE 20
 
-static void (*lasthandler) (void);
+static void (*lasthandler)(void);
 static unsigned long interruptjiffies;
 static unsigned long resultjiffies;
 static int resultsize;
@@ -733,6 +736,7 @@
 static int disk_change(int drive)
 {
 	int fdc = FDC(drive);
+
 #ifdef FLOPPY_SANITY_CHECK
 	if (time_before(jiffies, UDRS->select_date + UDP->select_delay))
 		DPRINT("WARNING disk change called early\n");
@@ -771,7 +775,7 @@
 			floppy_sizes[TOMINOR(drive)] = MAX_DISK_SIZE << 1;
 		}
 
-		/*USETF(FD_DISK_NEWCHANGE); */
+		/* USETF(FD_DISK_NEWCHANGE); */
 		return 1;
 	} else {
 		UDRS->last_checked = jiffies;
@@ -994,7 +998,7 @@
 
 static DECLARE_WORK(floppy_work, NULL);
 
-static void schedule_bh(void (*handler) (void))
+static void schedule_bh(void (*handler)(void))
 {
 	PREPARE_WORK(&floppy_work, (work_func_t)handler);
 	schedule_work(&floppy_work);
@@ -1030,7 +1034,7 @@
 		reset_fdc();
 	} else {
 		del_timer(&fd_timer);
-		fd_timer.function = (timeout_fn) fd_watchdog;
+		fd_timer.function = (timeout_fn)fd_watchdog;
 		fd_timer.expires = jiffies + HZ / 10;
 		add_timer(&fd_timer);
 	}
@@ -1147,6 +1151,7 @@
 static int wait_til_ready(void)
 {
 	int counter, status;
+
 	if (FDCS->reset)
 		return -1;
 	for (counter = 0; counter < 10000; counter++) {
@@ -1188,7 +1193,7 @@
 	return -1;
 }
 
-#define LAST_OUT(x) if (output_byte(x)<0){ reset_fdc();return;}
+#define LAST_OUT(x) if (output_byte(x) < 0) { reset_fdc(); return; }
 
 /* gets the response from the fdc */
 static int result(void)
@@ -1226,6 +1231,7 @@
 static int need_more_output(void)
 {
 	int status;
+
 	if ((status = wait_til_ready()) < 0)
 		return -1;
 	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY)
@@ -1252,8 +1258,8 @@
 			DPRINT("Invalid data rate for perpendicular mode!\n");
 			cont->done(0);
 			FDCS->reset = 1;	/* convenient way to return to
-						 * redo without to much hassle (deep
-						 * stack et al. */
+						 * redo without to much hassle
+						 * (deep stack et al. */
 			return;
 		}
 	} else
@@ -1319,7 +1325,7 @@
 	if (FDCS->need_configure && FDCS->version >= FDC_82072A) {
 		fdc_configure();
 		FDCS->need_configure = 0;
-		/*DPRINT("FIFO enabled\n"); */
+		/* DPRINT("FIFO enabled\n"); */
 	}
 
 	switch (raw_cmd->rate & 0x03) {
@@ -1351,9 +1357,9 @@
 
 	/* Convert step rate from microseconds to milliseconds and 4 bits */
 	srt = 16 - (DP->srt * scale_dtr / 1000 + NOMINAL_DTR - 1) / NOMINAL_DTR;
-	if (slow_floppy) {
+	if (slow_floppy)
 		srt = srt / 4;
-	}
+
 	SUPBOUND(srt, 0xf);
 	INFBOUND(srt, 0);
 
@@ -1463,12 +1469,11 @@
 					printk("probe failed...");
 			} else if (ST2 & ST2_WC) {	/* seek error */
 				printk("wrong cylinder");
-			} else if (ST2 & ST2_BC) {	/* cylinder marked as bad */
+			} else if (ST2 & ST2_BC) {	/* cylinder marked bad */
 				printk("bad cylinder");
 			} else {
-				printk
-				    ("unknown error. ST[0..2] are: 0x%x 0x%x 0x%x",
-				     ST0, ST1, ST2);
+				printk("unknown error. ST[0..2] are: "
+					"0x%x 0x%x 0x%x", ST0, ST1, ST2);
 				tell_sector();
 			}
 			printk("\n");
@@ -1912,10 +1917,10 @@
 	is_alive("floppy shutdown");
 }
 
-/*typedef void (*timeout_fn)(unsigned long);*/
+/* typedef void (*timeout_fn)(unsigned long); */
 
 /* start motor, check media-changed condition and write protection */
-static int start_motor(void (*function) (void))
+static int start_motor(void (*function)(void))
 {
 	int mask, data;
 
@@ -2030,7 +2035,7 @@
 	.done		= (done_f) empty
 };
 
-static int wait_til_done(void (*handler) (void), int interruptible)
+static int wait_til_done(void (*handler)(void), int interruptible)
 {
 	int ret;
 
@@ -2052,7 +2057,6 @@
 
 			schedule();
 		}
-
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&command_done, &wait);
 	}
@@ -2066,10 +2070,12 @@
 
 	if (FDCS->reset)
 		command_status = FD_COMMAND_ERROR;
+
 	if (command_status == FD_COMMAND_OKAY)
 		ret = 0;
 	else
 		ret = -EIO;
+
 	command_status = FD_COMMAND_NONE;
 	return ret;
 }
@@ -2141,6 +2147,7 @@
 static void set_floppy(int drive)
 {
 	int type = ITYPE(UDRS->fd_device);
+
 	if (type)
 		_floppy = floppy_type + type;
 	else
@@ -2179,7 +2186,7 @@
 	raw_cmd->track = track;
 
 	raw_cmd->flags = FD_RAW_WRITE | FD_RAW_INTR | FD_RAW_SPIN |
-	    FD_RAW_NEED_DISK | FD_RAW_NEED_SEEK;
+				FD_RAW_NEED_DISK | FD_RAW_NEED_SEEK;
 	raw_cmd->rate = _floppy->rate & 0x43;
 	raw_cmd->cmd_count = NR_F;
 	COMMAND = FM_MODE(_floppy, FD_FORMAT);
@@ -2200,7 +2207,7 @@
 
 	/* position of logical sector 1 on this track */
 	n = (track_shift * format_req.track + head_shift * format_req.head)
-	    % F_SECT_PER_TRACK;
+		% F_SECT_PER_TRACK;
 
 	/* determine interleave */
 	il = 1;
@@ -2276,7 +2283,6 @@
  * Buffer read/write and support
  * =============================
  */
-
 static void floppy_end_request(struct request *req, int uptodate)
 {
 	unsigned int nr_sectors = current_count_sectors;
@@ -2370,8 +2376,8 @@
 		heads = 1;
 
 	nr_sectors = (((R_TRACK - TRACK) * heads +
-		       R_HEAD - HEAD) * SECT_PER_TRACK +
-		      R_SECTOR - SECTOR + eoc) << SIZECODE >> 2;
+			R_HEAD - HEAD) * SECT_PER_TRACK +
+			R_SECTOR - SECTOR + eoc) << SIZECODE >> 2;
 
 #ifdef FLOPPY_SANITY_CHECK
 	if (nr_sectors / ssize >
@@ -2450,7 +2456,6 @@
 			if (page_address(bv->bv_page) + bv->bv_offset !=
 			    base + size)
 				break;
-
 			size += bv->bv_len;
 		}
 	}
@@ -2509,9 +2514,7 @@
 #endif
 
 	buffer_max = max(max_sector, buffer_max);
-
 	dma_buffer = floppy_track_buffer + ((fsector_t - buffer_min) << 9);
-
 	size = current_req->current_nr_sectors << 9;
 
 	rq_for_each_bio(bio, current_req) {
@@ -2563,7 +2566,7 @@
 
 #if 0
 static inline int check_dma_crossing(char *start,
-				     unsigned long length, char *message)
+		unsigned long length, char *message)
 {
 	if (CROSS_64KB(start, length)) {
 		printk("DMA xfer crosses 64KB boundary in %s %p-%p\n",
@@ -2593,12 +2596,12 @@
 #ifdef FLOPPY_SANITY_CHECK
 		if (end_sector > SECT_PER_TRACK) {
 			printk("too many sectors %d > %d\n",
-			       end_sector, SECT_PER_TRACK);
+				end_sector, SECT_PER_TRACK);
 			return;
 		}
 #endif
-		SECT_PER_TRACK = end_sector;	/* make sure SECT_PER_TRACK points
-						 * to end of transfer */
+		SECT_PER_TRACK = end_sector;	/* make sure SECT_PER_TRACK
+						 * points to end of transfer */
 	}
 }
 
@@ -2611,7 +2614,6 @@
  * allocation on the fly, it should be done here. No other part should need
  * modification.
  */
-
 static int make_raw_rw_request(void)
 {
 	int aligned_sector_t;
@@ -2626,7 +2628,7 @@
 
 	raw_cmd = &default_raw_cmd;
 	raw_cmd->flags = FD_RAW_SPIN | FD_RAW_NEED_DISK | FD_RAW_NEED_DISK |
-	    FD_RAW_NEED_SEEK;
+				FD_RAW_NEED_SEEK;
 	raw_cmd->cmd_count = NR_RW;
 	if (rq_data_dir(current_req) == READ) {
 		raw_cmd->flags |= FD_RAW_READ;
@@ -2682,7 +2684,7 @@
 	CODE2SIZE;
 	SECT_PER_TRACK = _floppy->sect << 2 >> SIZECODE;
 	SECTOR = ((fsector_t % _floppy->sect) << 2 >> SIZECODE) +
-	    ((_floppy->stretch & FD_ZEROBASED) ? 0 : 1);
+			((_floppy->stretch & FD_ZEROBASED) ? 0 : 1);
 
 	/* tracksize describes the size which can be filled up with sectors
 	 * of size ssize.
@@ -2704,12 +2706,11 @@
 			tracksize += ssize;
 		}
 		max_sector = HEAD * _floppy->sect + tracksize;
-	} else if (!TRACK && !HEAD && !(_floppy->rate & FD_2M) && probing) {
+	} else if (!TRACK && !HEAD && !(_floppy->rate & FD_2M) && probing)
 		max_sector = _floppy->sect;
-	} else if (!HEAD && CT(COMMAND) == FD_WRITE) {
+	else if (!HEAD && CT(COMMAND) == FD_WRITE)
 		/* for virtual DMA bug workaround */
 		max_sector = _floppy->sect;
-	}
 
 	in_sector_offset = (fsector_t % _floppy->sect) % ssize;
 	aligned_sector_t = fsector_t - in_sector_offset;
@@ -2742,16 +2743,16 @@
 				  max_buffer_sectors * 2) - fsector_t;
 
 		/*
-		 * Do NOT use minimum() here---MAX_DMA_ADDRESS is 64 bits wide
+		 * Do NOT use minimum() here - MAX_DMA_ADDRESS is 64 bits wide
 		 * on a 64 bit machine!
 		 */
 		max_size = buffer_chain_size();
 		dma_limit =
 		    (MAX_DMA_ADDRESS -
 		     ((unsigned long)current_req->buffer)) >> 9;
-		if ((unsigned long)max_size > dma_limit) {
+		if ((unsigned long)max_size > dma_limit)
 			max_size = dma_limit;
-		}
+
 		/* 64 kb boundaries */
 		if (CROSS_64KB(current_req->buffer, max_size << 9))
 			max_size = (K_64 -
@@ -2765,10 +2766,9 @@
 		 * This means we should be able to read a sector even if there
 		 * are other bad sectors on this track.
 		 */
-		if (!direct ||
-		    (indirect * 2 > direct * 3 &&
+		if (!direct || (indirect * 2 > direct * 3 &&
 		     *errors < DP->max_errors.read_track &&
-		     /*!TESTF(FD_NEED_TWADDLE) && */
+		     /* !TESTF(FD_NEED_TWADDLE) && */
 		     ((!probing
 		       || (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = current_req->nr_sectors;
@@ -2776,16 +2776,15 @@
 			raw_cmd->kernel_data = current_req->buffer;
 			raw_cmd->length = current_count_sectors << 9;
 			if (raw_cmd->length == 0) {
-				DPRINT
-				    ("zero dma transfer attempted from make_raw_request\n");
+				DPRINT("zero dma transfer attempted from "
+					"make_raw_request\n");
 				DPRINT("indirect=%d direct=%d fsector_t=%d",
 				       indirect, direct, fsector_t);
 				return 0;
 			}
-/*			check_dma_crossing(raw_cmd->kernel_data, 
-					   raw_cmd->length, 
-					   "end of make_raw_request [1]");*/
-
+			/* check_dma_crossing(raw_cmd->kernel_data,
+					   raw_cmd->length,
+					   "end of make_raw_request [1]"); */
 			virtualdmabug_workaround();
 			return 2;
 		}
@@ -2835,7 +2834,7 @@
 	raw_cmd->length = ((raw_cmd->length - 1) | (ssize - 1)) + 1;
 	raw_cmd->length <<= 9;
 #ifdef FLOPPY_SANITY_CHECK
-	/*check_dma_crossing(raw_cmd->kernel_data, raw_cmd->length, 
+	/*check_dma_crossing(raw_cmd->kernel_data, raw_cmd->length,
 	   "end of make_raw_request"); */
 	if ((raw_cmd->length < current_count_sectors << 9) ||
 	    (raw_cmd->kernel_data != current_req->buffer &&
@@ -2894,14 +2893,13 @@
 		return 0;
 	}
 #endif
-
 	virtualdmabug_workaround();
 	return 2;
 }
 
 static void redo_fd_request(void)
 {
-#define REPEAT {request_done(0); continue; }
+#define REPEAT { request_done(0); continue; }
 	int drive;
 	int tmp;
 
@@ -2981,7 +2979,7 @@
 	schedule_bh(redo_fd_request);
 }
 
-static void do_fd_request(request_queue_t * q)
+static void do_fd_request(request_queue_t *q)
 {
 	if (max_buffer_sectors == 0) {
 		printk("VFS: do_fd_request called on non-open device\n");
@@ -3016,6 +3014,7 @@
 static int poll_drive(int interruptible, int flag)
 {
 	int ret;
+
 	/* no auto-sense, just clear dcl */
 	raw_cmd = &default_raw_cmd;
 	raw_cmd->flags = flag;
@@ -3036,7 +3035,6 @@
  * User triggered reset
  * ====================
  */
-
 static void reset_intr(void)
 {
 	printk("weird, reset interrupt called\n");
@@ -3080,8 +3078,10 @@
 	return copy_from_user(address, param, size) ? -EFAULT : 0;
 }
 
-#define _COPYOUT(x) (copy_to_user((void __user *)param, &(x), sizeof(x)) ? -EFAULT : 0)
-#define _COPYIN(x) (copy_from_user(&(x), (void __user *)param, sizeof(x)) ? -EFAULT : 0)
+#define _COPYOUT(x) \
+	(copy_to_user((void __user *)param, &(x), sizeof(x)) ? -EFAULT : 0)
+#define _COPYIN(x) \
+	(copy_from_user(&(x), (void __user *)param, sizeof(x)) ? -EFAULT : 0)
 
 #define COPYOUT(x) ECALL(_COPYOUT(x))
 #define COPYIN(x) ECALL(_COPYIN(x))
@@ -3343,7 +3343,7 @@
 		LOCK_FDC(drive, 1);
 		if (cmd != FDDEFPRM)
 			/* notice a disk change immediately, else
-			 * we lose our settings immediately*/
+			 * we lose our settings immediately */
 			CALL(poll_drive(1, FD_RAW_NEED_DISK));
 		oldStretch = g->stretch;
 		user_params[drive] = *g;
@@ -3451,7 +3451,7 @@
 }
 
 static int fd_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		    unsigned long param)
+		unsigned long param)
 {
 #define FD_IOCTL_ALLOWED ((filp) && (filp)->private_data)
 #define OUT(c,x) case c: outparam = (const char *) (x); break
@@ -3525,14 +3525,12 @@
 						  (struct floppy_struct **)
 						  &outparam));
 			break;
-
 		case FDMSGON:
 			UDP->flags |= FTD_MSG;
 			return 0;
 		case FDMSGOFF:
 			UDP->flags &= ~FTD_MSG;
 			return 0;
-
 		case FDFMTBEG:
 			LOCK_FDC(drive, 1);
 			CALL(poll_drive(1, FD_RAW_NEED_DISK));
@@ -3551,39 +3549,31 @@
 		case FDFLUSH:
 			LOCK_FDC(drive, 1);
 			return invalidate_drive(inode->i_bdev);
-
 		case FDSETEMSGTRESH:
 			UDP->max_errors.reporting =
 			    (unsigned short)(param & 0x0f);
 			return 0;
 			OUT(FDGETMAXERRS, &UDP->max_errors);
 			IN(FDSETMAXERRS, &UDP->max_errors, max_errors);
-
 		case FDGETDRVTYP:
 			outparam = drive_name(type, drive);
 			SUPBOUND(size, strlen(outparam) + 1);
 			break;
-
 			IN(FDSETDRVPRM, UDP, dp);
 			OUT(FDGETDRVPRM, UDP);
-
 		case FDPOLLDRVSTAT:
 			LOCK_FDC(drive, 1);
 			CALL(poll_drive(1, FD_RAW_NEED_DISK));
 			process_fd_request();
 			/* fall through */
 			OUT(FDGETDRVSTAT, UDRS);
-
 		case FDRESET:
 			return user_reset_fdc(drive, (int)param, 1);
-
 			OUT(FDGETFDCSTAT, UFDCS);
-
 		case FDWERRORCLR:
 			CLEARSTRUCT(UDRWE);
 			return 0;
 			OUT(FDWERRORGET, UDRWE);
-
 		case FDRAWCMD:
 			if (type)
 				return -EINVAL;
@@ -3592,13 +3582,11 @@
 			CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
 			process_fd_request();
 			return i;
-
 		case FDTWADDLE:
 			LOCK_FDC(drive, 1);
 			twaddle();
 			process_fd_request();
 			return 0;
-
 		default:
 			return -EINVAL;
 		}
@@ -3626,7 +3614,6 @@
 
 	/* XXX */
 	/* additional physical CMOS drive detection should go here */
-
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		unsigned int type = UDP->cmos;
 		struct floppy_drive_params *params;
@@ -3816,7 +3803,7 @@
  */
 
 static int floppy_rb0_complete(struct bio *bio, unsigned int bytes_done,
-			       int err)
+		int err)
 {
 	if (bio->bi_size)
 		return 1;
@@ -3965,7 +3952,7 @@
 	r = result();
 	if ((r == 1) && (reply_buffer[0] == 0x80)) {
 		printk(KERN_INFO "FDC %d is a pre-1991 82077\n", fdc);
-		return FDC_82077_ORIG;	/* Pre-1991 82077, doesn't know 
+		return FDC_82077_ORIG;	/* Pre-1991 82077, doesn't know
 					 * LOCK/UNLOCK */
 	}
 	if ((r != 1) || (reply_buffer[0] != 0x00)) {
@@ -3982,11 +3969,11 @@
 	}
 	if (reply_buffer[0] == 0x80) {
 		printk(KERN_INFO "FDC %d is a post-1991 82077\n", fdc);
-		return FDC_82077;	/* Revised 82077AA passes all the tests */
+		return FDC_82077;	/* Revised 82077AA passes all tests */
 	}
 	switch (reply_buffer[0] >> 5) {
 	case 0x0:
-		/* Either a 82078-1 or a 82078SL running at 5Volt */
+		/* Either a 82078-1 or a 82078SL running at 5 Volt */
 		printk(KERN_INFO "FDC %d is an 82078.\n", fdc);
 		return FDC_82078;
 	case 0x1:
@@ -3996,16 +3983,16 @@
 		printk(KERN_INFO "FDC %d is a S82078B\n", fdc);
 		return FDC_S82078B;
 	case 0x3:
-		printk(KERN_INFO "FDC %d is a National Semiconductor PC87306\n",
-		       fdc);
+		printk(KERN_INFO "FDC %d is a National Semiconductor "
+			"PC87306\n", fdc);
 		return FDC_87306;
 	default:
 		printk(KERN_INFO
-		       "FDC %d init: 82078 variant with unknown PARTID=%d.\n",
-		       fdc, reply_buffer[0] >> 5);
+		       "FDC %d init: 82078 variant with unknown "
+		       "PARTID=%d.\n", fdc, reply_buffer[0] >> 5);
 		return FDC_82078_UNKN;
 	}
-}				/* get_fdc_version */
+}	/* get_fdc_version */
 
 /* lilo configuration */
 
@@ -4064,7 +4051,7 @@
 
 static struct param_table {
 	const char *name;
-	void (*fn) (int *ints, int param, int param2);
+	void (*fn)(int *ints, int param, int param2);
 	int *var;
 	int def_param;
 	int param2;
@@ -4095,7 +4082,6 @@
 	{"unexpected_interrupts", NULL, &print_unex, 1, 0},
 	{"no_unexpected_interrupts", NULL, &print_unex, 0, 0},
 	{"L40SX", NULL, &print_unex, 0, 0}
-
 	EXTRA_FLOPPY_PARAMS
 };
 
@@ -4127,7 +4113,6 @@
 	}
 	if (str) {
 		DPRINT("unknown floppy option [%s]\n", str);
-
 		DPRINT("allowed options are:");
 		for (i = 0; i < ARRAY_SIZE(config_params); i++)
 			printk(" %s", config_params[i].name);
@@ -4141,7 +4126,7 @@
 static int have_no_fdc = -ENODEV;
 
 static ssize_t floppy_cmos_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
+		struct device_attribute *attr, char *buf)
 {
 	struct platform_device *p;
 	int drive;
@@ -4230,7 +4215,7 @@
 		FDCS->dtr = -1;
 		FDCS->dor = 0x4;
 #if defined(__sparc__) || defined(__mc68000__)
-		/*sparcs/sun3x don't have a DOR reset which we can fall back on to */
+		/* sparcs/sun3x don't have a DOR reset to fall back on */
 #ifdef __mc68000__
 		if (MACH_IS_SUN3X)
 #endif
@@ -4249,7 +4234,7 @@
 	fdc_state[1].address = FDC2;
 #endif
 
-	fdc = 0;		/* reset fdc in case of unexpected interrupt */
+	fdc = 0;	/* reset fdc in case of unexpected interrupt */
 	err = floppy_grab_irq_and_dma();
 	if (err) {
 		del_timer(&fd_timeout);
@@ -4428,8 +4413,8 @@
 		if (FDCS->address != -1)
 			fd_outb(FDCS->dor, FD_DOR);
 	/*
-	 *      The driver will try and free resources and relies on us
-	 *      to know if they were allocated or not.
+	 * The driver will try and free resources and relies on us to know if
+	 * they were allocated or not.
 	 */
 	fdc = 0;
 	irqdma_allocated = 1;
@@ -4519,7 +4504,7 @@
 	char *ptr;
 
 	while (*cfg) {
-		for (ptr = cfg; *cfg && *cfg != ' ' && *cfg != '\t'; cfg++) ;
+		for (ptr = cfg; *cfg && *cfg != ' ' && *cfg != '\t'; cfg++);
 		if (*cfg) {
 			*cfg = '\0';
 			cfg++;



