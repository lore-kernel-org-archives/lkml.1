Return-Path: <linux-kernel-owner+w=401wt.eu-S1763527AbYEYK0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763527AbYEYK0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761914AbYEYKXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41993 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762114AbYEYKXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:47 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 12/28] aic94xx: treat firmware data as const
Message-Id: <E1K0DO9-0007DY-JQ@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:41 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/scsi/aic94xx/aic94xx_sds.c |   12 ++++++------
 drivers/scsi/aic94xx/aic94xx_sds.h |    4 ++--
 drivers/scsi/aic94xx/aic94xx_seq.c |    7 ++++---
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 4446e3d..8630a75 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -1093,9 +1093,9 @@ out:
  * @bytes_to_verify: total bytes to verify
  */
 int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
-		void *src, u32 dest_offset, u32 bytes_to_verify)
+			 const void *src, u32 dest_offset, u32 bytes_to_verify)
 {
-	u8 *src_buf;
+	const u8 *src_buf;
 	u8 flash_char;
 	int err;
 	u32 nv_offset, reg, i;
@@ -1105,7 +1105,7 @@ int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
 
 	err = FLASH_OK;
 	nv_offset = dest_offset;
-	src_buf = (u8 *)src;
+	src_buf = (const u8 *)src;
 	for (i = 0; i < bytes_to_verify; i++) {
 		flash_char = asd_read_reg_byte(asd_ha, reg + nv_offset + i);
 		if (flash_char != src_buf[i]) {
@@ -1124,9 +1124,9 @@ int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
  * @bytes_to_write: total bytes to write
  */
 int asd_write_flash_seg(struct asd_ha_struct *asd_ha,
-		void *src, u32 dest_offset, u32 bytes_to_write)
+			const void *src, u32 dest_offset, u32 bytes_to_write)
 {
-	u8 *src_buf;
+	const u8 *src_buf;
 	u32 nv_offset, reg, i;
 	int err;
 
@@ -1153,7 +1153,7 @@ int asd_write_flash_seg(struct asd_ha_struct *asd_ha,
 		return err;
 	}
 
-	src_buf = (u8 *)src;
+	src_buf = (const u8 *)src;
 	for (i = 0; i < bytes_to_write; i++) {
 		/* Setup program command sequence */
 		switch (asd_ha->hw_prof.flash.method) {
diff --git a/drivers/scsi/aic94xx/aic94xx_sds.h b/drivers/scsi/aic94xx/aic94xx_sds.h
index bb9795a..a06dc01 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.h
+++ b/drivers/scsi/aic94xx/aic94xx_sds.h
@@ -110,9 +110,9 @@ struct bios_file_header {
 };
 
 int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
-		void *src, u32 dest_offset, u32 bytes_to_verify);
+		const void *src, u32 dest_offset, u32 bytes_to_verify);
 int asd_write_flash_seg(struct asd_ha_struct *asd_ha,
-		void *src, u32 dest_offset, u32 bytes_to_write);
+		const void *src, u32 dest_offset, u32 bytes_to_write);
 int asd_chk_write_status(struct asd_ha_struct *asd_ha,
 		u32 sector_addr, u8 erase_flag);
 int asd_check_flash_type(struct asd_ha_struct *asd_ha);
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index f4272ac..8f98e33 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -46,7 +46,7 @@
 static const struct firmware *sequencer_fw;
 static u16 cseq_vecs[CSEQ_NUM_VECS], lseq_vecs[LSEQ_NUM_VECS], mode2_task,
 	cseq_idle_loop, lseq_idle_loop;
-static u8 *cseq_code, *lseq_code;
+static const u8 *cseq_code, *lseq_code;
 static u32 cseq_code_size, lseq_code_size;
 
 static u16 first_scb_site_no = 0xFFFF;
@@ -1235,7 +1235,8 @@ int asd_release_firmware(void)
 static int asd_request_firmware(struct asd_ha_struct *asd_ha)
 {
 	int err, i;
-	struct sequencer_file_header header, *hdr_ptr;
+	struct sequencer_file_header header;
+	const struct sequencer_file_header *hdr_ptr;
 	u32 csum = 0;
 	u16 *ptr_cseq_vecs, *ptr_lseq_vecs;
 
@@ -1249,7 +1250,7 @@ static int asd_request_firmware(struct asd_ha_struct *asd_ha)
 	if (err)
 		return err;
 
-	hdr_ptr = (struct sequencer_file_header *)sequencer_fw->data;
+	hdr_ptr = (const struct sequencer_file_header *)sequencer_fw->data;
 
 	header.csum = le32_to_cpu(hdr_ptr->csum);
 	header.major = le32_to_cpu(hdr_ptr->major);
-- 
1.5.4.5

