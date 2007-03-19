Return-Path: <linux-kernel-owner+w=401wt.eu-S965726AbXCSPLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965726AbXCSPLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965846AbXCSPLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:11:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:39115 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965726AbXCSPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Xv/tWICS6nR7J1uxbw/wHUp0xKb/hiTnKUDwpSnFVtIuoSYzrceZCooQxHH9ucmlHOstRXZWyOl0I+B+QOSHmY0aLCKhGvfv9Z90k+x+e2JNjWuaTmiDrhF9Xo1YE4sPeyy9+gCGf702X/Na0TUl1mgRjlQxvb8LJX3J/QPTAjE=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][3/5][resend] floppy.c: Remove dead/commented out code
Date: Mon, 19 Mar 2007 16:10:45 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703191610.46102.jesper.juhl@gmail.com>
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
Acked-by: Alan Cox <alan@redhat.com>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index dea7c4f..9a52ca6 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -774,8 +774,6 @@ static int disk_change(int drive)
 			current_type[drive] = NULL;
 			floppy_sizes[TOMINOR(drive)] = MAX_DISK_SIZE << 1;
 		}
-
-		/* USETF(FD_DISK_NEWCHANGE); */
 		return 1;
 	} else {
 		UDRS->last_checked = jiffies;
@@ -1325,7 +1323,6 @@ static void fdc_specify(void)
 	if (FDCS->need_configure && FDCS->version >= FDC_82072A) {
 		fdc_configure();
 		FDCS->need_configure = 0;
-		/* DPRINT("FIFO enabled\n"); */
 	}
 
 	switch (raw_cmd->rate & 0x03) {
@@ -1917,8 +1914,6 @@ static void floppy_shutdown(unsigned long data)
 	is_alive("floppy shutdown");
 }
 
-/* typedef void (*timeout_fn)(unsigned long); */
-
 /* start motor, check media-changed condition and write protection */
 static int start_motor(void (*function)(void))
 {
@@ -2564,19 +2559,6 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
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
@@ -2768,7 +2750,6 @@ static int make_raw_rw_request(void)
 		 */
 		if (!direct || (indirect * 2 > direct * 3 &&
 		     *errors < DP->max_errors.read_track &&
-		     /* !TESTF(FD_NEED_TWADDLE) && */
 		     ((!probing
 		       || (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = current_req->nr_sectors;
@@ -2782,9 +2763,6 @@ static int make_raw_rw_request(void)
 				       indirect, direct, fsector_t);
 				return 0;
 			}
-			/* check_dma_crossing(raw_cmd->kernel_data,
-					   raw_cmd->length,
-					   "end of make_raw_request [1]"); */
 			virtualdmabug_workaround();
 			return 2;
 		}
@@ -2834,8 +2812,6 @@ static int make_raw_rw_request(void)
 	raw_cmd->length = ((raw_cmd->length - 1) | (ssize - 1)) + 1;
 	raw_cmd->length <<= 9;
 #ifdef FLOPPY_SANITY_CHECK
-	/*check_dma_crossing(raw_cmd->kernel_data, raw_cmd->length,
-	   "end of make_raw_request"); */
 	if ((raw_cmd->length < current_count_sectors << 9) ||
 	    (raw_cmd->kernel_data != current_req->buffer &&
 	     CT(COMMAND) == FD_WRITE &&
