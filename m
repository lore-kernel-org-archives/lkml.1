Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYBWOFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYBWOFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbYBWOE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:04:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:35830 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912AbYBWOEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:04:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=KHLuj7Z/MF5a+ebVNegrxJh3Exvxx0f+pF5wiwTBB1eihZYUUzLqINRnEt9yOMQiUpBq3XtL+VKxQIXNousc0HXXoOoUVZByhk/vdLrtAMa9qVEtqsR5wLQ8b8nh3DbbxznbLl1YRxCs7hUzpnh7tFu0RHqMAXnW772X/nihFYA=
Date: Sat, 23 Feb 2008 15:04:49 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 01/10] IDE: Coding Style fixes to drivers/ide/pci/sis5513.c
Message-ID: <20080223150449.2a8aa051@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

About 300 errors and warnings fixed.
File is now error free.
Compile tested.

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/pci/sis5513.c |  190 ++++++++++++++++++++++-----------------------
 1 files changed, 93 insertions(+), 97 deletions(-)

diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index e29c90f..bf4ddbc 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -59,10 +59,10 @@
 #define ATA_16		0x01
 #define ATA_33		0x02
 #define ATA_66		0x03
-#define ATA_100a	0x04 // SiS730/SiS550 is ATA100 with ATA66 layout
+#define ATA_100a	0x04 /* SiS730/SiS550 is ATA100 with ATA66 layout */
 #define ATA_100		0x05
-#define ATA_133a	0x06 // SiS961b with 133 support
-#define ATA_133		0x07 // SiS962/963
+#define ATA_133a	0x06 /* SiS961b with 133 support */
+#define ATA_133		0x07 /* SiS962/963 */
 
 static u8 chipset_family;
 
@@ -111,69 +111,69 @@ static const struct {
    Indexed by chipset_family and (dma_mode - XFER_UDMA_0) */
 
 /* {0, ATA_16, ATA_33, ATA_66, ATA_100a, ATA_100, ATA_133} */
-static u8 cycle_time_offset[] = {0,0,5,4,4,0,0};
-static u8 cycle_time_range[] = {0,0,2,3,3,4,4};
+static u8 cycle_time_offset[] = {0, 0, 5, 4, 4, 0, 0};
+static u8 cycle_time_range[] = {0, 0, 2, 3, 3, 4, 4};
 static u8 cycle_time_value[][XFER_UDMA_6 - XFER_UDMA_0 + 1] = {
-	{0,0,0,0,0,0,0}, /* no udma */
-	{0,0,0,0,0,0,0}, /* no udma */
-	{3,2,1,0,0,0,0}, /* ATA_33 */
-	{7,5,3,2,1,0,0}, /* ATA_66 */
-	{7,5,3,2,1,0,0}, /* ATA_100a (730 specific), differences are on cycle_time range and offset */
-	{11,7,5,4,2,1,0}, /* ATA_100 */
-	{15,10,7,5,3,2,1}, /* ATA_133a (earliest 691 southbridges) */
-	{15,10,7,5,3,2,1}, /* ATA_133 */
+	{0, 0, 0, 0, 0, 0, 0}, /* no udma */
+	{0, 0, 0, 0, 0, 0, 0}, /* no udma */
+	{3, 2, 1, 0, 0, 0, 0}, /* ATA_33 */
+	{7, 5, 3, 2, 1, 0, 0}, /* ATA_66 */
+	{7, 5, 3, 2, 1, 0, 0}, /* ATA_100a (730 specific), differences are on cycle_time range and offset */
+	{11, 7, 5, 4, 2, 1, 0}, /* ATA_100 */
+	{15, 10, 7, 5, 3, 2, 1}, /* ATA_133a (earliest 691 southbridges) */
+	{15, 10, 7, 5, 3, 2, 1}, /* ATA_133 */
 };
 /* CRC Valid Setup Time vary across IDE clock setting 33/66/100/133
    See SiS962 data sheet for more detail */
 static u8 cvs_time_value[][XFER_UDMA_6 - XFER_UDMA_0 + 1] = {
-	{0,0,0,0,0,0,0}, /* no udma */
-	{0,0,0,0,0,0,0}, /* no udma */
-	{2,1,1,0,0,0,0},
-	{4,3,2,1,0,0,0},
-	{4,3,2,1,0,0,0},
-	{6,4,3,1,1,1,0},
-	{9,6,4,2,2,2,2},
-	{9,6,4,2,2,2,2},
+	{0, 0, 0, 0, 0, 0, 0}, /* no udma */
+	{0, 0, 0, 0, 0, 0, 0}, /* no udma */
+	{2, 1, 1, 0, 0, 0, 0},
+	{4, 3, 2, 1, 0, 0, 0},
+	{4, 3, 2, 1, 0, 0, 0},
+	{6, 4, 3, 1, 1, 1, 0},
+	{9, 6, 4, 2, 2, 2, 2},
+	{9, 6, 4, 2, 2, 2, 2},
 };
 /* Initialize time, Active time, Recovery time vary across
    IDE clock settings. These 3 arrays hold the register value
    for PIO0/1/2/3/4 and DMA0/1/2 mode in order */
 static u8 ini_time_value[][8] = {
-	{0,0,0,0,0,0,0,0},
-	{0,0,0,0,0,0,0,0},
-	{2,1,0,0,0,1,0,0},
-	{4,3,1,1,1,3,1,1},
-	{4,3,1,1,1,3,1,1},
-	{6,4,2,2,2,4,2,2},
-	{9,6,3,3,3,6,3,3},
-	{9,6,3,3,3,6,3,3},
+	{0, 0, 0, 0, 0, 0, 0, 0},
+	{0, 0, 0, 0, 0, 0, 0, 0},
+	{2, 1, 0, 0, 0, 1, 0, 0},
+	{4, 3, 1, 1, 1, 3, 1, 1},
+	{4, 3, 1, 1, 1, 3, 1, 1},
+	{6, 4, 2, 2, 2, 4, 2, 2},
+	{9, 6, 3, 3, 3, 6, 3, 3},
+	{9, 6, 3, 3, 3, 6, 3, 3},
 };
 static u8 act_time_value[][8] = {
-	{0,0,0,0,0,0,0,0},
-	{0,0,0,0,0,0,0,0},
-	{9,9,9,2,2,7,2,2},
-	{19,19,19,5,4,14,5,4},
-	{19,19,19,5,4,14,5,4},
-	{28,28,28,7,6,21,7,6},
-	{38,38,38,10,9,28,10,9},
-	{38,38,38,10,9,28,10,9},
+	{0, 0, 0, 0, 0, 0, 0, 0},
+	{0, 0, 0, 0, 0, 0, 0, 0},
+	{9, 9, 9, 2, 2, 7, 2, 2},
+	{19, 19, 19, 5, 4, 14, 5, 4},
+	{19, 19, 19, 5, 4, 14, 5, 4},
+	{28, 28, 28, 7, 6, 21, 7, 6},
+	{38, 38, 38, 10, 9, 28, 10, 9},
+	{38, 38, 38, 10, 9, 28, 10, 9},
 };
 static u8 rco_time_value[][8] = {
-	{0,0,0,0,0,0,0,0},
-	{0,0,0,0,0,0,0,0},
-	{9,2,0,2,0,7,1,1},
-	{19,5,1,5,2,16,3,2},
-	{19,5,1,5,2,16,3,2},
-	{30,9,3,9,4,25,6,4},
-	{40,12,4,12,5,34,12,5},
-	{40,12,4,12,5,34,12,5},
+	{0, 0, 0, 0, 0, 0, 0, 0},
+	{0, 0, 0, 0, 0, 0, 0, 0},
+	{9, 2, 0, 2, 0, 7, 1, 1},
+	{19, 5, 1, 5, 2, 16, 3, 2},
+	{19, 5, 1, 5, 2, 16, 3, 2},
+	{30, 9, 3, 9, 4, 25, 6, 4},
+	{40, 12, 4, 12, 5, 34, 12, 5},
+	{40, 12, 4, 12, 5, 34, 12, 5},
 };
 
 /*
  * Printing configuration
  */
 /* Used for chipset type printing at boot time */
-static char* chipset_capability[] = {
+static char *chipset_capability[] = {
 	"ATA", "ATA 16",
 	"ATA 33", "ATA 66",
 	"ATA 100 (1st gen)", "ATA 100 (2nd gen)",
@@ -272,7 +272,7 @@ static void sis_program_timings(ide_drive_t *drive, const u8 mode)
 		sis_ata133_program_timings(drive, mode);
 }
 
-static void config_drive_art_rwp (ide_drive_t *drive)
+static void config_drive_art_rwp(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
@@ -359,7 +359,7 @@ static u8 sis5513_ata133_udma_filter(ide_drive_t *drive)
 }
 
 /* Chip detection and general config */
-static unsigned int __devinit init_chipset_sis5513 (struct pci_dev *dev, const char *name)
+static unsigned int __devinit init_chipset_sis5513(struct pci_dev *dev, const char *name)
 {
 	struct pci_dev *host;
 	int i = 0;
@@ -381,7 +381,7 @@ static unsigned int __devinit init_chipset_sis5513 (struct pci_dev *dev, const c
 				chipset_family = ATA_100a;
 		}
 		pci_dev_put(host);
-	
+
 		printk(KERN_INFO "SIS5513: %s %s controller\n",
 			 SiSHostChipInfo[i].name, chipset_capability[chipset_family]);
 	}
@@ -451,52 +451,48 @@ static unsigned int __devinit init_chipset_sis5513 (struct pci_dev *dev, const c
 		u8 reg;
 		u16 regw;
 
-		switch(chipset_family) {
-			case ATA_133:
-				/* SiS962 operation mode */
-				pci_read_config_word(dev, 0x50, &regw);
-				if (regw & 0x08)
-					pci_write_config_word(dev, 0x50, regw&0xfff7);
-				pci_read_config_word(dev, 0x52, &regw);
-				if (regw & 0x08)
-					pci_write_config_word(dev, 0x52, regw&0xfff7);
-				break;
-			case ATA_133a:
-			case ATA_100:
-				/* Fixup latency */
-				pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x80);
-				/* Set compatibility bit */
-				pci_read_config_byte(dev, 0x49, &reg);
-				if (!(reg & 0x01)) {
-					pci_write_config_byte(dev, 0x49, reg|0x01);
-				}
-				break;
-			case ATA_100a:
-			case ATA_66:
-				/* Fixup latency */
-				pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x10);
-
-				/* On ATA_66 chips the bit was elsewhere */
-				pci_read_config_byte(dev, 0x52, &reg);
-				if (!(reg & 0x04)) {
-					pci_write_config_byte(dev, 0x52, reg|0x04);
-				}
-				break;
-			case ATA_33:
-				/* On ATA_33 we didn't have a single bit to set */
-				pci_read_config_byte(dev, 0x09, &reg);
-				if ((reg & 0x0f) != 0x00) {
-					pci_write_config_byte(dev, 0x09, reg&0xf0);
-				}
-			case ATA_16:
-				/* force per drive recovery and active timings
-				   needed on ATA_33 and below chips */
-				pci_read_config_byte(dev, 0x52, &reg);
-				if (!(reg & 0x08)) {
-					pci_write_config_byte(dev, 0x52, reg|0x08);
-				}
-				break;
-		}
+		switch (chipset_family) {
+		case ATA_133:
+			/* SiS962 operation mode */
+			pci_read_config_word(dev, 0x50, &regw);
+			if (regw & 0x08)
+				pci_write_config_word(dev, 0x50, regw&0xfff7);
+			pci_read_config_word(dev, 0x52, &regw);
+			if (regw & 0x08)
+				pci_write_config_word(dev, 0x52, regw&0xfff7);
+			break;
+		case ATA_133a:
+		case ATA_100:
+			/* Fixup latency */
+			pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x80);
+			/* Set compatibility bit */
+			pci_read_config_byte(dev, 0x49, &reg);
+			if (!(reg & 0x01))
+				pci_write_config_byte(dev, 0x49, reg|0x01);
+			break;
+		case ATA_100a:
+		case ATA_66:
+			/* Fixup latency */
+			pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x10);
+
+			/* On ATA_66 chips the bit was elsewhere */
+			pci_read_config_byte(dev, 0x52, &reg);
+			if (!(reg & 0x04))
+				pci_write_config_byte(dev, 0x52, reg|0x04);
+			break;
+		case ATA_33:
+			/* On ATA_33 we didn't have a single bit to set */
+			pci_read_config_byte(dev, 0x09, &reg);
+			if ((reg & 0x0f) != 0x00)
+				pci_write_config_byte(dev, 0x09, reg&0xf0);
+		case ATA_16:
+			/* force per drive recovery and active timings
+			   needed on ATA_33 and below chips */
+			pci_read_config_byte(dev, 0x52, &reg);
+			if (!(reg & 0x08))
+				pci_write_config_byte(dev, 0x52, reg|0x08);
+			break;
+	}
 	}
 
 	return 0;
@@ -546,7 +542,7 @@ static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
 	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
-static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
+static void __devinit init_hwif_sis5513(ide_hwif_t *hwif)
 {
 	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
 
@@ -568,7 +564,7 @@ static const struct ide_port_info sis5513_chipset __devinitdata = {
 	.name		= "SIS5513",
 	.init_chipset	= init_chipset_sis5513,
 	.init_hwif	= init_hwif_sis5513,
-	.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
+	.enablebits	= { {0x4a, 0x02, 0x02}, {0x4a, 0x04, 0x04} },
 	.host_flags	= IDE_HFLAG_LEGACY_IRQS | IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
-- 
1.5.4.2.316.gf7a7

