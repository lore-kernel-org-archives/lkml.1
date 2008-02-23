Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbYBWRjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbYBWRjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760182AbYBWRic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:38:32 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:2422 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbYBWRia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:38:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Esimx+tuGXCbHthtB/ggN6WIFG16kjvLb7t9dCvGpBGwquDLiCWccHbtV/XaOXx14t1tt3zli17lTOrBhTnrhrXCz9WFVzqB9pO7rFr/i4B8yB0Yggf8wOXrwPitxM7H6ZdxDd1HzCHbVgvqCoScu0i6U4agRUr+urHQmQ05Ctg=
Date: Sat, 23 Feb 2008 18:38:24 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 2/6] IDE: Coding Style fixes to drivers/ide/legacy/hd.c
Message-ID: <20080223183824.392fdc87@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a lot of errors and warnings.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/legacy/hd.c |   79 ++++++++++++++++++++++++-----------------------
 1 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/ide/legacy/hd.c b/drivers/ide/legacy/hd.c
index 0b0d867..b16bdbd 100644
--- a/drivers/ide/legacy/hd.c
+++ b/drivers/ide/legacy/hd.c
@@ -122,12 +122,12 @@ static int hd_error;
  *  This struct defines the HD's and their types.
  */
 struct hd_i_struct {
-	unsigned int head,sect,cyl,wpcom,lzone,ctl;
+	unsigned int head, sect, cyl, wpcom, lzone, ctl;
 	int unit;
 	int recalibrate;
 	int special_op;
 };
-	
+
 #ifdef HD_TYPE
 static struct hd_i_struct hd_info[] = { HD_TYPE };
 static int NR_HD = ARRAY_SIZE(hd_info);
@@ -147,7 +147,7 @@ static struct timer_list device_timer;
 		mod_timer(&device_timer, jiffies + TIMEOUT_VALUE);	\
 	} while (0)
 
-static void (*do_hd)(void) = NULL;
+static void (*do_hd)(void);
 #define SET_HANDLER(x) \
 if ((do_hd = (x)) != NULL) \
 	SET_TIMER; \
@@ -168,7 +168,7 @@ unsigned long read_timer(void)
 
 	spin_lock_irqsave(&i8253_lock, flags);
 	t = jiffies * 11932;
-    	outb_p(0, 0x43);
+	outb_p(0, 0x43);
 	i = inb_p(0x40);
 	i |= inb(0x40) << 8;
 	spin_unlock_irqrestore(&i8253_lock, flags);
@@ -183,7 +183,7 @@ static void __init hd_setup(char *str, int *ints)
 	if (ints[0] != 3)
 		return;
 	if (hd_info[0].head != 0)
-		hdind=1;
+		hdind = 1;
 	hd_info[hdind].head = ints[2];
 	hd_info[hdind].sect = ints[3];
 	hd_info[hdind].cyl = ints[1];
@@ -193,7 +193,7 @@ static void __init hd_setup(char *str, int *ints)
 	NR_HD = hdind+1;
 }
 
-static void dump_status (const char *msg, unsigned int stat)
+static void dump_status(const char *msg, unsigned int stat)
 {
 	char *name = "hd?";
 	if (CURRENT)
@@ -291,7 +291,7 @@ static int controller_ready(unsigned int drive, unsigned int head)
 	return 0;
 }
 
-		
+
 static void hd_out(struct hd_i_struct *disk,
 		   unsigned int nsect,
 		   unsigned int sect,
@@ -313,15 +313,15 @@ static void hd_out(struct hd_i_struct *disk,
 		return;
 	}
 	SET_HANDLER(intr_addr);
-	outb_p(disk->ctl,HD_CMD);
-	port=HD_DATA;
-	outb_p(disk->wpcom>>2,++port);
-	outb_p(nsect,++port);
-	outb_p(sect,++port);
-	outb_p(cyl,++port);
-	outb_p(cyl>>8,++port);
-	outb_p(0xA0|(disk->unit<<4)|head,++port);
-	outb_p(cmd,++port);
+	outb_p(disk->ctl, HD_CMD);
+	port = HD_DATA;
+	outb_p(disk->wpcom>>2, ++port);
+	outb_p(nsect, ++port);
+	outb_p(sect, ++port);
+	outb_p(cyl, ++port);
+	outb_p(cyl>>8, ++port);
+	outb_p(0xA0|(disk->unit<<4)|head, ++port);
+	outb_p(cmd, ++port);
 }
 
 static void hd_request (void);
@@ -344,14 +344,14 @@ static void reset_controller(void)
 {
 	int	i;
 
-	outb_p(4,HD_CMD);
-	for(i = 0; i < 1000; i++) barrier();
-	outb_p(hd_info[0].ctl & 0x0f,HD_CMD);
-	for(i = 0; i < 1000; i++) barrier();
+	outb_p(4, HD_CMD);
+	for (i = 0; i < 1000; i++) barrier();
+	outb_p(hd_info[0].ctl & 0x0f, HD_CMD);
+	for (i = 0; i < 1000; i++) barrier();
 	if (drive_busy())
 		printk("hd: controller still busy\n");
 	else if ((hd_error = inb(HD_ERROR)) != 1)
-		printk("hd: controller reset failed: %02x\n",hd_error);
+		printk("hd: controller reset failed: %02x\n", hd_error);
 }
 
 static void reset_hd(void)
@@ -371,8 +371,8 @@ repeat:
 	if (++i < NR_HD) {
 		struct hd_i_struct *disk = &hd_info[i];
 		disk->special_op = disk->recalibrate = 1;
-		hd_out(disk,disk->sect,disk->sect,disk->head-1,
-			disk->cyl,WIN_SPECIFY,&reset_hd);
+		hd_out(disk, disk->sect, disk->sect, disk->head-1,
+			disk->cyl, WIN_SPECIFY, &reset_hd);
 		if (reset)
 			goto repeat;
 	} else
@@ -393,7 +393,7 @@ static void unexpected_hd_interrupt(void)
 	unsigned int stat = inb_p(HD_STATUS);
 
 	if (stat & (BUSY_STAT|DRQ_STAT|ECC_STAT|ERR_STAT)) {
-		dump_status ("unexpected interrupt", stat);
+		dump_status("unexpected interrupt", stat);
 		SET_TIMER;
 	}
 }
@@ -453,7 +453,7 @@ static void read_intr(void)
 	return;
 ok_to_read:
 	req = CURRENT;
-	insw(HD_DATA,req->buffer,256);
+	insw(HD_DATA, req->buffer, 256);
 	req->sector++;
 	req->buffer += 512;
 	req->errors = 0;
@@ -507,7 +507,7 @@ ok_to_write:
 		end_request(req, 1);
 	if (i > 0) {
 		SET_HANDLER(&write_intr);
-		outsw(HD_DATA,req->buffer,256);
+		outsw(HD_DATA, req->buffer, 256);
 		local_irq_enable();
 	} else {
 #if (HD_DELAY > 0)
@@ -560,11 +560,11 @@ static int do_special_op(struct hd_i_struct *disk, struct request *req)
 {
 	if (disk->recalibrate) {
 		disk->recalibrate = 0;
-		hd_out(disk,disk->sect,0,0,0,WIN_RESTORE,&recal_intr);
+		hd_out(disk, disk->sect, 0, 0, 0, WIN_RESTORE, &recal_intr);
 		return reset;
 	}
 	if (disk->head > 16) {
-		printk ("%s: cannot handle device with more than 16 heads - giving up\n", req->rq_disk->disk_name);
+		printk("%s: cannot handle device with more than 16 heads - giving up\n", req->rq_disk->disk_name);
 		end_request(req, 0);
 	}
 	disk->special_op = 0;
@@ -633,19 +633,19 @@ repeat:
 	if (blk_fs_request(req)) {
 		switch (rq_data_dir(req)) {
 		case READ:
-			hd_out(disk,nsect,sec,head,cyl,WIN_READ,&read_intr);
+			hd_out(disk, nsect, sec, head, cyl, WIN_READ, &read_intr);
 			if (reset)
 				goto repeat;
 			break;
 		case WRITE:
-			hd_out(disk,nsect,sec,head,cyl,WIN_WRITE,&write_intr);
+			hd_out(disk, nsect, sec, head, cyl, WIN_WRITE, &write_intr);
 			if (reset)
 				goto repeat;
 			if (wait_DRQ()) {
 				bad_rw_intr();
 				goto repeat;
 			}
-			outsw(HD_DATA,req->buffer,256);
+			outsw(HD_DATA, req->buffer, 256);
 			break;
 		default:
 			printk("unknown hd-command\n");
@@ -655,7 +655,7 @@ repeat:
 	}
 }
 
-static void do_hd_request (struct request_queue * q)
+static void do_hd_request(struct request_queue *q)
 {
 	disable_irq(HD_IRQ);
 	hd_request();
@@ -708,12 +708,12 @@ static int __init hd_init(void)
 {
 	int drive;
 
-	if (register_blkdev(MAJOR_NR,"hd"))
+	if (register_blkdev(MAJOR_NR, "hd"))
 		return -1;
 
 	hd_queue = blk_init_queue(do_hd_request, &hd_lock);
 	if (!hd_queue) {
-		unregister_blkdev(MAJOR_NR,"hd");
+		unregister_blkdev(MAJOR_NR, "hd");
 		return -ENOMEM;
 	}
 
@@ -742,7 +742,7 @@ static int __init hd_init(void)
 		goto out;
 	}
 
-	for (drive=0 ; drive < NR_HD ; drive++) {
+	for (drive = 0 ; drive < NR_HD ; drive++) {
 		struct gendisk *disk = alloc_disk(64);
 		struct hd_i_struct *p = &hd_info[drive];
 		if (!disk)
@@ -756,7 +756,7 @@ static int __init hd_init(void)
 		disk->queue = hd_queue;
 		p->unit = drive;
 		hd_gendisk[drive] = disk;
-		printk ("%s: %luMB, CHS=%d/%d/%d\n",
+		printk("%s: %luMB, CHS=%d/%d/%d\n",
 			disk->disk_name, (unsigned long)get_capacity(disk)/2048,
 			p->cyl, p->head, p->sect);
 	}
@@ -776,7 +776,7 @@ static int __init hd_init(void)
 	}
 
 	/* Let them fly */
-	for(drive=0; drive < NR_HD; drive++)
+	for (drive = 0; drive < NR_HD; drive++)
 		add_disk(hd_gendisk[drive]);
 
 	return 0;
@@ -791,7 +791,7 @@ out1:
 	NR_HD = 0;
 out:
 	del_timer(&device_timer);
-	unregister_blkdev(MAJOR_NR,"hd");
+	unregister_blkdev(MAJOR_NR, "hd");
 	blk_cleanup_queue(hd_queue);
 	return -1;
 Enomem:
@@ -800,7 +800,8 @@ Enomem:
 	goto out;
 }
 
-static int __init parse_hd_setup (char *line) {
+static int __init parse_hd_setup(char *line)
+{
 	int ints[6];
 
 	(void) get_options(line, ARRAY_SIZE(ints), ints);
-- 
1.5.4.2.316.gf7a7

