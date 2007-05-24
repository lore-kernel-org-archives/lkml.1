Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbXEXBZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbXEXBZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761357AbXEXBYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:24:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:2956 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892AbXEXBYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=moBwxLi0cQfwoTxSOQf4QvIQ1ZnIt4g/fjeR0qYqB3m2hRMApkmVrEs0Vyz0qKzV2xEdX9+Ic3UQM7sC/Xa1APFR9XoKr5maqDcToOTZx39Zg7H45HkKwTHOrIEW+vAfsi62IK4wKmuKmMGJrQRjqcO9/rG87NeNZKFUMtedFEk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Thu, 24 May 2007 02:46:18 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705240246.19039.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-dma.c         |    4 +++-
 drivers/ide/ide-proc.c        |    2 ++
 drivers/ide/pci/atiixp.c      |    1 +
 drivers/ide/pci/serverworks.c |   14 ++++++++++----
 include/linux/pci_ids.h       |    1 +
 5 files changed, 17 insertions(+), 5 deletions(-)


Alan Cox (1):
      ide/pci/serverworks.c: Fix corruption/timeouts with MegaIDE

Andrew Morton (1):
      ide serverworks warning fixes

Henry Su (1):
      add the IDE device ID for ATI SB700

Junio C Hamano (1):
      Match DMA blacklist entries between ide-dma.c and libata-core.c

Mika Kukkonen (1):
      Add two missing chipsets to drivers/ide/ide-proc.c


diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index b77b7d1..ead141e 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -119,15 +119,17 @@ static const struct drive_list_entry drive_blacklist [] = {
 	{ "HITACHI CDR-8335"	,	"ALL"		},
 	{ "HITACHI CDR-8435"	,	"ALL"		},
 	{ "Toshiba CD-ROM XM-6202B"	,	"ALL"		},
+	{ "TOSHIBA CD-ROM XM-1702BC",	"ALL"		},
 	{ "CD-532E-A"		,	"ALL"		},
 	{ "E-IDE CD-ROM CR-840",	"ALL"		},
 	{ "CD-ROM Drive/F5A",	"ALL"		},
 	{ "WPI CDD-820",		"ALL"		},
 	{ "SAMSUNG CD-ROM SC-148C",	"ALL"		},
 	{ "SAMSUNG CD-ROM SC",	"ALL"		},
-	{ "SanDisk SDP3B-64"	,	"ALL"		},
 	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",	"ALL"		},
 	{ "_NEC DV5800A",               "ALL"           },  
+	{ "SAMSUNG CD-ROM SN-124",	"N001" },
+	{ "Seagate STT20000A",		"ALL" },
 	{ NULL			,	NULL		}
 
 };
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index d50bd99..ea94c9a 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -67,6 +67,8 @@ static int proc_ide_read_imodel
 		case ide_4drives:	name = "4drives";	break;
 		case ide_pmac:		name = "mac-io";	break;
 		case ide_au1xxx:	name = "au1xxx";	break;
+		case ide_etrax100:	name = "etrax100";	break;
+		case ide_acorn:		name = "acorn";		break;
 		default:		name = "(unknown)";	break;
 	}
 	len = sprintf(page, "%s\n", name);
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 0e52ad7..8ab33fa 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -317,6 +317,7 @@ static struct pci_device_id atiixp_pci_tbl[] = {
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index 6234f80..47bcd91 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -158,6 +158,12 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	pci_read_config_word(dev, 0x4A, &csb5_pio);
 	pci_read_config_byte(dev, 0x54, &ultra_enable);
 
+	/* If we are in RAID mode (eg AMI MegaIDE) then we can't it
+	   turns out trust the firmware configuration */
+
+	if ((dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
+		goto oem_setup_failed;
+
 	/* Per Specified Design by OEM, and ASIC Architect */
 	if ((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE) ||
 	    (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2)) {
@@ -173,7 +179,7 @@ dma_pio:
 				   ((dma_stat&(1<<(5+unit)))==(1<<(5+unit)))) {
 				u8 dmaspeed = dma_timing;
 
-				dma_timing &= ~0xFF;
+				dma_timing &= ~0xFFU;
 				if ((dmaspeed & 0x20) == 0x20)
 					dmaspeed = XFER_MW_DMA_2;
 				else if ((dmaspeed & 0x21) == 0x21)
@@ -187,7 +193,7 @@ dma_pio:
 			} else if (pio_timing) {
 				u8 piospeed = pio_timing;
 
-				pio_timing &= ~0xFF;
+				pio_timing &= ~0xFFU;
 				if ((piospeed & 0x20) == 0x20)
 					piospeed = XFER_PIO_4;
 				else if ((piospeed & 0x22) == 0x22)
@@ -208,8 +214,8 @@ dma_pio:
 
 oem_setup_failed:
 
-	pio_timing	&= ~0xFF;
-	dma_timing	&= ~0xFF;
+	pio_timing	&= ~0xFFU;
+	dma_timing	&= ~0xFFU;
 	ultra_timing	&= ~(0x0F << (4*unit));
 	ultra_enable	&= ~(0x01 << drive->dn);
 	csb5_pio	&= ~(0x0F << (4*drive->dn));
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 62b3e00..4712e26 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -371,6 +371,7 @@
 #define PCI_DEVICE_ID_ATI_IXP600_SMBUS	0x4385
 #define PCI_DEVICE_ID_ATI_IXP600_IDE	0x438c
 #define PCI_DEVICE_ID_ATI_IXP700_SATA	0x4390
+#define PCI_DEVICE_ID_ATI_IXP700_IDE	0x439c
 
 #define PCI_VENDOR_ID_VLSI		0x1004
 #define PCI_DEVICE_ID_VLSI_82C592	0x0005
