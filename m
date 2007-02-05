Return-Path: <linux-kernel-owner+w=401wt.eu-S965100AbXBEX1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965100AbXBEX1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965092AbXBEX1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:27:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:43004 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080AbXBEX1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:27:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=D+gqtD9Ee1hSrccrY/MWCjxFHK+Me3aXucjZNISOVu3NFixirvaU33TgMz+FrUh6U7O86AlB1t5GdQtKO5EsRpw2isvWoMBHAuR2try/rbK9dV/RwOnlHcgcoBF8Ev/7qhEQcch7gyCbi7kCwVyjY/LjOq4iFvJhLDmXddDtpDs=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][3/5] floppy.c: Remove dead/commented out code
Date: Tue, 6 Feb 2007 00:29:35 +0100
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
Message-Id: <200702060029.35399.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This removes commented out/dead code from floppy.c

The code in question has been commented out for quite a while (at least as 
far as I can see) and I see no reason for it to clutter up the source any 
longer.
If, in the future, someone sees a real need to resurrect this code then 
they can still find it in the revision history.
Let's kill the cruft :)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 floppy.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- linux-2.6.20/drivers/block/floppy.c.patch2	2007-02-05 23:12:27.000000000 +0100
+++ linux-2.6.20/drivers/block/floppy.c	2007-02-05 23:18:17.000000000 +0100
@@ -774,8 +774,6 @@
 			current_type[drive] = NULL;
 			floppy_sizes[TOMINOR(drive)] = MAX_DISK_SIZE << 1;
 		}
-
-		/* USETF(FD_DISK_NEWCHANGE); */
 		return 1;
 	} else {
 		UDRS->last_checked = jiffies;
@@ -1325,7 +1323,6 @@
 	if (FDCS->need_configure && FDCS->version >= FDC_82072A) {
 		fdc_configure();
 		FDCS->need_configure = 0;
-		/* DPRINT("FIFO enabled\n"); */
 	}
 
 	switch (raw_cmd->rate & 0x03) {
@@ -1917,8 +1914,6 @@
 	is_alive("floppy shutdown");
 }
 
-/* typedef void (*timeout_fn)(unsigned long); */
-
 /* start motor, check media-changed condition and write protection */
 static int start_motor(void (*function)(void))
 {
@@ -2564,19 +2559,6 @@
 #endif
 }
 
-#if 0
-static inline int check_dma_crossing(char *start,
-		unsigned long length, char *message)
-{
-	if (CROSS_64KB(start, length)) {
-		printk("DMA xfer crosses 64KB boundary in %s %p-%p\n",
-		       message, start, start + length);
-		return 1;
-	} else
-		return 0;
-}
-#endif
-
 /* work around a bug in pseudo DMA
  * (on some FDCs) pseudo DMA does not stop when the CPU stops
  * sending data.  Hence we need a different way to signal the
@@ -2768,7 +2750,6 @@
 		 */
 		if (!direct || (indirect * 2 > direct * 3 &&
 		     *errors < DP->max_errors.read_track &&
-		     /* !TESTF(FD_NEED_TWADDLE) && */
 		     ((!probing
 		       || (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = current_req->nr_sectors;
@@ -2782,9 +2763,6 @@
 				       indirect, direct, fsector_t);
 				return 0;
 			}
-			/* check_dma_crossing(raw_cmd->kernel_data,
-					   raw_cmd->length,
-					   "end of make_raw_request [1]"); */
 			virtualdmabug_workaround();
 			return 2;
 		}
@@ -2834,8 +2812,6 @@
 	raw_cmd->length = ((raw_cmd->length - 1) | (ssize - 1)) + 1;
 	raw_cmd->length <<= 9;
 #ifdef FLOPPY_SANITY_CHECK
-	/*check_dma_crossing(raw_cmd->kernel_data, raw_cmd->length,
-	   "end of make_raw_request"); */
 	if ((raw_cmd->length < current_count_sectors << 9) ||
 	    (raw_cmd->kernel_data != current_req->buffer &&
 	     CT(COMMAND) == FD_WRITE &&



