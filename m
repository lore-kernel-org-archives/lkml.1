Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYGVUwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYGVUwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYGVUwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:52:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:62131 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYGVUwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:52:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=kzjXrtit/5WGvwY3mAoE0GmU8d3yYFqF3PFRNQlOq6VMqMLakjeheEP2B7fDgKgLsc
         9KCvYtkOhOUz883t8tgbnC911OqtxO/B/nz1nTZ5NkEC/IM37ku4Ijd/wny3GrzZnkGO
         YQ1xBWTmacaemKyptgZd1ZxDTzfvuwqcuV7OY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ata: add missing ATA_ID_* defines (take 2)
Date: Tue, 22 Jul 2008 22:49:31 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807222249.32242.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing ATA_ID_* defines and update {ata,atapi}_*()
inlines accordingly.  The currently unused defines are
needed for the forthcoming drivers/ide/ changes.

v2:
Add ATA_ID_SPG.

Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
v2 was needed because one define got lost :/

 include/linux/ata.h |  122 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 76 insertions(+), 46 deletions(-)

Index: b/include/linux/ata.h
===================================================================
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -46,18 +46,48 @@ enum {
 	ATA_MAX_SECTORS_TAPE	= 65535,
 
 	ATA_ID_WORDS		= 256,
+	ATA_ID_CONFIG		= 0,
+	ATA_ID_CYLS		= 1,
+	ATA_ID_HEADS		= 3,
+	ATA_ID_SECTORS		= 6,
 	ATA_ID_SERNO		= 10,
+	ATA_ID_BUF_SIZE		= 21,
 	ATA_ID_FW_REV		= 23,
 	ATA_ID_PROD		= 27,
+	ATA_ID_MAX_MULTSECT	= 47,
+	ATA_ID_DWORD_IO		= 48,
+	ATA_ID_CAPABILITY	= 49,
 	ATA_ID_OLD_PIO_MODES	= 51,
+	ATA_ID_OLD_DMA_MODES	= 52,
 	ATA_ID_FIELD_VALID	= 53,
+	ATA_ID_CUR_CYLS		= 54,
+	ATA_ID_CUR_HEADS	= 55,
+	ATA_ID_CUR_SECTORS	= 56,
+	ATA_ID_MULTSECT		= 59,
+	ATA_ID_LBA_CAPACITY	= 60,
+	ATA_ID_SWDMA_MODES	= 62,
 	ATA_ID_MWDMA_MODES	= 63,
 	ATA_ID_PIO_MODES	= 64,
 	ATA_ID_EIDE_DMA_MIN	= 65,
+	ATA_ID_EIDE_DMA_TIME	= 66,
 	ATA_ID_EIDE_PIO		= 67,
 	ATA_ID_EIDE_PIO_IORDY	= 68,
-	ATA_ID_UDMA_MODES	= 88,
+	ATA_ID_QUEUE_DEPTH	= 75,
 	ATA_ID_MAJOR_VER	= 80,
+	ATA_ID_COMMAND_SET_1	= 82,
+	ATA_ID_COMMAND_SET_2	= 83,
+	ATA_ID_CFSSE		= 84,
+	ATA_ID_CFS_ENABLE_1	= 85,
+	ATA_ID_CFS_ENABLE_2	= 86,
+	ATA_ID_CSF_DEFAULT	= 87,
+	ATA_ID_UDMA_MODES	= 88,
+	ATA_ID_HW_CONFIG	= 93,
+	ATA_ID_SPG		= 98,
+	ATA_ID_LBA_CAPACITY_2	= 100,
+	ATA_ID_LAST_LUN		= 126,
+	ATA_ID_DLF		= 128,
+	ATA_ID_CSFO		= 129,
+	ATA_ID_CFA_POWER	= 160,
 	ATA_ID_PIO4		= (1 << 1),
 
 	ATA_ID_SERNO_LEN	= 20,
@@ -438,17 +468,17 @@ static inline int ata_is_data(u8 prot)
 /*
  * id tests
  */
-#define ata_id_is_ata(id)	(((id)[0] & (1 << 15)) == 0)
-#define ata_id_has_lba(id)	((id)[49] & (1 << 9))
-#define ata_id_has_dma(id)	((id)[49] & (1 << 8))
+#define ata_id_is_ata(id)	(((id)[ATA_ID_CONFIG] & (1 << 15)) == 0)
+#define ata_id_has_lba(id)	((id)[ATA_ID_CAPABILITY] & (1 << 9))
+#define ata_id_has_dma(id)	((id)[ATA_ID_CAPABILITY] & (1 << 8))
 #define ata_id_has_ncq(id)	((id)[76] & (1 << 8))
-#define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
-#define ata_id_removeable(id)	((id)[0] & (1 << 7))
+#define ata_id_queue_depth(id)	(((id)[ATA_ID_QUEUE_DEPTH] & 0x1f) + 1)
+#define ata_id_removeable(id)	((id)[ATA_ID_CONFIG] & (1 << 7))
 #define ata_id_has_atapi_AN(id)	\
 	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
 	  ((id)[78] & (1 << 5)) )
-#define ata_id_iordy_disable(id) ((id)[49] & (1 << 10))
-#define ata_id_has_iordy(id) ((id)[49] & (1 << 11))
+#define ata_id_iordy_disable(id) ((id)[ATA_ID_CAPABILITY] & (1 << 10))
+#define ata_id_has_iordy(id) ((id)[ATA_ID_CAPABILITY] & (1 << 11))
 #define ata_id_u32(id,n)	\
 	(((u32) (id)[(n) + 1] << 16) | ((u32) (id)[(n)]))
 #define ata_id_u64(id,n)	\
@@ -457,7 +487,7 @@ static inline int ata_is_data(u8 prot)
 	  ((u64) (id)[(n) + 1] << 16) |	\
 	  ((u64) (id)[(n) + 0]) )
 
-#define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
+#define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG] & 0x60) == 0x20)
 
 static inline bool ata_id_has_hipm(const u16 *id)
 {
@@ -482,75 +512,75 @@ static inline bool ata_id_has_dipm(const
 
 static inline int ata_id_has_fua(const u16 *id)
 {
-	if ((id[84] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_CFSSE] & 0xC000) != 0x4000)
 		return 0;
-	return id[84] & (1 << 6);
+	return id[ATA_ID_CFSSE] & (1 << 6);
 }
 
 static inline int ata_id_has_flush(const u16 *id)
 {
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
-	return id[83] & (1 << 12);
+	return id[ATA_ID_COMMAND_SET_2] & (1 << 12);
 }
 
 static inline int ata_id_has_flush_ext(const u16 *id)
 {
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
-	return id[83] & (1 << 13);
+	return id[ATA_ID_COMMAND_SET_2] & (1 << 13);
 }
 
 static inline int ata_id_has_lba48(const u16 *id)
 {
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
-	if (!ata_id_u64(id, 100))
+	if (!ata_id_u64(id, ATA_ID_LBA_CAPACITY_2))
 		return 0;
-	return id[83] & (1 << 10);
+	return id[ATA_ID_COMMAND_SET_2] & (1 << 10);
 }
 
 static inline int ata_id_hpa_enabled(const u16 *id)
 {
 	/* Yes children, word 83 valid bits cover word 82 data */
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
 	/* And 87 covers 85-87 */
-	if ((id[87] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
 		return 0;
 	/* Check command sets enabled as well as supported */
-	if ((id[85] & ( 1 << 10)) == 0)
+	if ((id[ATA_ID_CFS_ENABLE_1] & (1 << 10)) == 0)
 		return 0;
-	return id[82] & (1 << 10);
+	return id[ATA_ID_COMMAND_SET_1] & (1 << 10);
 }
 
 static inline int ata_id_has_wcache(const u16 *id)
 {
 	/* Yes children, word 83 valid bits cover word 82 data */
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
-	return id[82] & (1 << 5);
+	return id[ATA_ID_COMMAND_SET_1] & (1 << 5);
 }
 
 static inline int ata_id_has_pm(const u16 *id)
 {
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
-	return id[82] & (1 << 3);
+	return id[ATA_ID_COMMAND_SET_1] & (1 << 3);
 }
 
 static inline int ata_id_rahead_enabled(const u16 *id)
 {
-	if ((id[87] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
 		return 0;
-	return id[85] & (1 << 6);
+	return id[ATA_ID_CFS_ENABLE_1] & (1 << 6);
 }
 
 static inline int ata_id_wcache_enabled(const u16 *id)
 {
-	if ((id[87] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
 		return 0;
-	return id[85] & (1 << 5);
+	return id[ATA_ID_CFS_ENABLE_1] & (1 << 5);
 }
 
 /**
@@ -581,7 +611,7 @@ static inline unsigned int ata_id_major_
 
 static inline int ata_id_is_sata(const u16 *id)
 {
-	return ata_id_major_version(id) >= 5 && id[93] == 0;
+	return ata_id_major_version(id) >= 5 && id[ATA_ID_HW_CONFIG] == 0;
 }
 
 static inline int ata_id_has_tpm(const u16 *id)
@@ -599,7 +629,7 @@ static inline int ata_id_has_dword_io(co
 	/* ATA 8 reuses this flag for "trusted" computing */
 	if (ata_id_major_version(id) > 7)
 		return 0;
-	if (id[48] & (1 << 0))
+	if (id[ATA_ID_DWORD_IO] & (1 << 0))
 		return 1;
 	return 0;
 }
@@ -608,22 +638,22 @@ static inline int ata_id_current_chs_val
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
 	   has not been issued to the device then the values of
-	   id[54] to id[56] are vendor specific. */
-	return (id[53] & 0x01) && /* Current translation valid */
-		id[54] &&  /* cylinders in current translation */
-		id[55] &&  /* heads in current translation */
-		id[55] <= 16 &&
-		id[56];    /* sectors in current translation */
+	   id[ATA_ID_CUR_CYLS] to id[ATA_ID_CUR_SECTORS] are vendor specific. */
+	return (id[ATA_ID_FIELD_VALID] & 1) && /* Current translation valid */
+		id[ATA_ID_CUR_CYLS] &&  /* cylinders in current translation */
+		id[ATA_ID_CUR_HEADS] &&  /* heads in current translation */
+		id[ATA_ID_CUR_HEADS] <= 16 &&
+		id[ATA_ID_CUR_SECTORS];    /* sectors in current translation */
 }
 
 static inline int ata_id_is_cfa(const u16 *id)
 {
-	u16 v = id[0];
-	if (v == 0x848A)	/* Standard CF */
+	if (id[ATA_ID_CONFIG] == 0x848A)	/* Standard CF */
 		return 1;
 	/* Could be CF hiding as standard ATA */
-	if (ata_id_major_version(id) >= 3 &&  id[82] != 0xFFFF &&
-			(id[82] & ( 1 << 2)))
+	if (ata_id_major_version(id) >= 3 &&
+	    id[ATA_ID_COMMAND_SET_1] != 0xFFFF &&
+	   (id[ATA_ID_COMMAND_SET_1] & (1 << 2)))
 		return 1;
 	return 0;
 }
@@ -632,21 +662,21 @@ static inline int ata_drive_40wire(const
 {
 	if (ata_id_is_sata(dev_id))
 		return 0;	/* SATA */
-	if ((dev_id[93] & 0xE000) == 0x6000)
+	if ((dev_id[ATA_ID_HW_CONFIG] & 0xE000) == 0x6000)
 		return 0;	/* 80 wire */
 	return 1;
 }
 
 static inline int ata_drive_40wire_relaxed(const u16 *dev_id)
 {
-	if ((dev_id[93] & 0x2000) == 0x2000)
+	if ((dev_id[ATA_ID_HW_CONFIG] & 0x2000) == 0x2000)
 		return 0;	/* 80 wire */
 	return 1;
 }
 
 static inline int atapi_cdb_len(const u16 *dev_id)
 {
-	u16 tmp = dev_id[0] & 0x3;
+	u16 tmp = dev_id[ATA_ID_CONFIG] & 0x3;
 	switch (tmp) {
 	case 0:		return 12;
 	case 1:		return 16;
@@ -656,7 +686,7 @@ static inline int atapi_cdb_len(const u1
 
 static inline int atapi_command_packet_set(const u16 *dev_id)
 {
-	return (dev_id[0] >> 8) & 0x1f;
+	return (dev_id[ATA_ID_CONFIG] >> 8) & 0x1f;
 }
 
 static inline int atapi_id_dmadir(const u16 *dev_id)
