Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYBWOGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYBWOGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbYBWOFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:05:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:33567 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593AbYBWOFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:05:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ggLWElTyGnwC9BUvShf/WfXqJkEljnHXiFzJYNhLBwl4gsOSgC59RL22LqZUrZ8ZxejEPyvC0wiOlA5HpKvBWAtUSPcT5ED/32I7pchDtRZIFtKkfV0sooy1Wabt5QWUK7Rk76a/kPXZ0XUB4Kzm/57mqTRFgFu8MwpoiteD1yA=
Date: Sat, 23 Feb 2008 15:04:57 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 02/10] IDE: Coding Style fixes to
 drivers/ide/legacy/umc8672.c
Message-ID: <20080223150457.2683f888@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/legacy/umc8672.c |   53 ++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index 43ee632..7783b59 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -19,7 +19,7 @@
  */
 
 /*
- * VLB Controller Support from 
+ * VLB Controller Support from
  * Wolfram Podien
  * Rohoefe 3
  * D28832 Achim
@@ -32,7 +32,7 @@
  * #define UMC_DRIVE0 11
  * in the beginning of the driver, which sets the speed of drive 0 to 11 (there
  * are some lines present). 0 - 11 are allowed speed values. These values are
- * the results from the DOS speed test program supplied from UMC. 11 is the 
+ * the results from the DOS speed test program supplied from UMC. 11 is the
  * highest speed (about PIO mode 3)
  */
 #define REALLY_SLOW_IO		/* some systems can safely undef this */
@@ -60,46 +60,45 @@
 #define UMC_DRIVE3      1              /* In case of crash reduce speed */
 
 static u8 current_speeds[4] = {UMC_DRIVE0, UMC_DRIVE1, UMC_DRIVE2, UMC_DRIVE3};
-static const u8 pio_to_umc [5] = {0,3,7,10,11};	/* rough guesses */
+static const u8 pio_to_umc [5] = {0, 3, 7, 10, 11};	/* rough guesses */
 
 /*       0    1    2    3    4    5    6    7    8    9    10   11      */
 static const u8 speedtab [3][12] = {
 	{0xf, 0xb, 0x2, 0x2, 0x2, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 },
 	{0x3, 0x2, 0x2, 0x2, 0x2, 0x2, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 },
-	{0xff,0xcb,0xc0,0x58,0x36,0x33,0x23,0x22,0x21,0x11,0x10,0x0}};
+	{0xff, 0xcb, 0xc0, 0x58, 0x36, 0x33, 0x23, 0x22, 0x21, 0x11, 0x10, 0x0} };
 
-static void out_umc (char port,char wert)
+static void out_umc(char port, char wert)
 {
-	outb_p(port,0x108);
-	outb_p(wert,0x109);
+	outb_p(port, 0x108);
+	outb_p(wert, 0x109);
 }
 
-static inline u8 in_umc (char port)
+static inline u8 in_umc(char port)
 {
-	outb_p(port,0x108);
+	outb_p(port, 0x108);
 	return inb_p(0x109);
 }
 
-static void umc_set_speeds (u8 speeds[])
+static void umc_set_speeds(u8 speeds[])
 {
 	int i, tmp;
 
-	outb_p(0x5A,0x108); /* enable umc */
+	outb_p(0x5A, 0x108); /* enable umc */
 
-	out_umc (0xd7,(speedtab[0][speeds[2]] | (speedtab[0][speeds[3]]<<4)));
-	out_umc (0xd6,(speedtab[0][speeds[0]] | (speedtab[0][speeds[1]]<<4)));
+	out_umc(0xd7, (speedtab[0][speeds[2]] | (speedtab[0][speeds[3]]<<4)));
+	out_umc(0xd6, (speedtab[0][speeds[0]] | (speedtab[0][speeds[1]]<<4)));
 	tmp = 0;
-	for (i = 3; i >= 0; i--) {
+	for (i = 3; i >= 0; i--)
 		tmp = (tmp << 2) | speedtab[1][speeds[i]];
+	out_umc(0xdc, tmp);
+	for (i = 0; i < 4; i++) {
+		out_umc(0xd0+i, speedtab[2][speeds[i]]);
+		out_umc(0xd8+i, speedtab[2][speeds[i]]);
 	}
-	out_umc (0xdc,tmp);
-	for (i = 0;i < 4; i++) {
-		out_umc (0xd0+i,speedtab[2][speeds[i]]);
-		out_umc (0xd8+i,speedtab[2][speeds[i]]);
-	}
-	outb_p(0xa5,0x108); /* disable umc */
+	outb_p(0xa5, 0x108); /* disable umc */
 
-	printk ("umc8672: drive speeds [0 to 11]: %d %d %d %d\n",
+	printk("umc8672: drive speeds [0 to 11]: %d %d %d %d\n",
 		speeds[0], speeds[1], speeds[2], speeds[3]);
 }
 
@@ -115,7 +114,7 @@ static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		printk(KERN_ERR "umc8672: other interface is busy: exiting tune_umc()\n");
 	} else {
 		current_speeds[drive->name[2] - 'a'] = pio_to_umc[pio];
-		umc_set_speeds (current_speeds);
+		umc_set_speeds(current_speeds);
 	}
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -138,16 +137,16 @@ static int __init umc8672_probe(void)
 		return 1;
 	}
 	local_irq_save(flags);
-	outb_p(0x5A,0x108); /* enable umc */
+	outb_p(0x5A, 0x108); /* enable umc */
 	if (in_umc (0xd5) != 0xa0) {
 		local_irq_restore(flags);
 		printk(KERN_ERR "umc8672: not found\n");
 		release_region(0x108, 2);
-		return 1;  
+		return 1;
 	}
-	outb_p(0xa5,0x108); /* disable umc */
+	outb_p(0xa5, 0x108); /* disable umc */
 
-	umc_set_speeds (current_speeds);
+	umc_set_speeds(current_speeds);
 	local_irq_restore(flags);
 
 	memset(&hw, 0, sizeof(hw));
@@ -177,7 +176,7 @@ static int __init umc8672_probe(void)
 	return 0;
 }
 
-int probe_umc8672 = 0;
+int probe_umc8672;
 
 module_param_named(probe, probe_umc8672, bool, 0);
 MODULE_PARM_DESC(probe, "probe for UMC8672 chipset");
-- 
1.5.4.2.316.gf7a7

