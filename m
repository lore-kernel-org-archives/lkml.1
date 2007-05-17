Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbXEQOdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbXEQOdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbXEQOcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:32:54 -0400
Received: from verein.lst.de ([213.95.11.210]:53817 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbXEQOcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:32:52 -0400
Date: Thu, 17 May 2007 16:32:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: dedekind@infradead.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517143200.GA30850@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kill ubis homegrown endianess handling crap and replace it with
the normal kernel endianess handling.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/mtd/ubi/debug.c
===================================================================
--- linux-2.6.orig/drivers/mtd/ubi/debug.c	2007-05-17 15:06:33.000000000 +0200
+++ linux-2.6/drivers/mtd/ubi/debug.c	2007-05-17 15:19:56.000000000 +0200
@@ -35,12 +35,12 @@
 void ubi_dbg_dump_ec_hdr(const struct ubi_ec_hdr *ec_hdr)
 {
 	dbg_msg("erase counter header dump:");
-	dbg_msg("magic          %#08x", ubi32_to_cpu(ec_hdr->magic));
+	dbg_msg("magic          %#08x", be32_to_cpu(ec_hdr->magic));
 	dbg_msg("version        %d",    (int)ec_hdr->version);
-	dbg_msg("ec             %llu",  (long long)ubi64_to_cpu(ec_hdr->ec));
-	dbg_msg("vid_hdr_offset %d",    ubi32_to_cpu(ec_hdr->vid_hdr_offset));
-	dbg_msg("data_offset    %d",    ubi32_to_cpu(ec_hdr->data_offset));
-	dbg_msg("hdr_crc        %#08x", ubi32_to_cpu(ec_hdr->hdr_crc));
+	dbg_msg("ec             %llu",  (long long)be64_to_cpu(ec_hdr->ec));
+	dbg_msg("vid_hdr_offset %d",    be32_to_cpu(ec_hdr->vid_hdr_offset));
+	dbg_msg("data_offset    %d",    be32_to_cpu(ec_hdr->data_offset));
+	dbg_msg("hdr_crc        %#08x", be32_to_cpu(ec_hdr->hdr_crc));
 	dbg_msg("erase counter header hexdump:");
 	ubi_dbg_hexdump(ec_hdr, UBI_EC_HDR_SIZE);
 }
@@ -52,20 +52,20 @@ void ubi_dbg_dump_ec_hdr(const struct ub
 void ubi_dbg_dump_vid_hdr(const struct ubi_vid_hdr *vid_hdr)
 {
 	dbg_msg("volume identifier header dump:");
-	dbg_msg("magic     %08x", ubi32_to_cpu(vid_hdr->magic));
+	dbg_msg("magic     %08x", be32_to_cpu(vid_hdr->magic));
 	dbg_msg("version   %d",   (int)vid_hdr->version);
 	dbg_msg("vol_type  %d",   (int)vid_hdr->vol_type);
 	dbg_msg("copy_flag %d",   (int)vid_hdr->copy_flag);
 	dbg_msg("compat    %d",   (int)vid_hdr->compat);
-	dbg_msg("vol_id    %d",   ubi32_to_cpu(vid_hdr->vol_id));
-	dbg_msg("lnum      %d",   ubi32_to_cpu(vid_hdr->lnum));
-	dbg_msg("leb_ver   %u",   ubi32_to_cpu(vid_hdr->leb_ver));
-	dbg_msg("data_size %d",   ubi32_to_cpu(vid_hdr->data_size));
-	dbg_msg("used_ebs  %d",   ubi32_to_cpu(vid_hdr->used_ebs));
-	dbg_msg("data_pad  %d",   ubi32_to_cpu(vid_hdr->data_pad));
+	dbg_msg("vol_id    %d",   be32_to_cpu(vid_hdr->vol_id));
+	dbg_msg("lnum      %d",   be32_to_cpu(vid_hdr->lnum));
+	dbg_msg("leb_ver   %u",   be32_to_cpu(vid_hdr->leb_ver));
+	dbg_msg("data_size %d",   be32_to_cpu(vid_hdr->data_size));
+	dbg_msg("used_ebs  %d",   be32_to_cpu(vid_hdr->used_ebs));
+	dbg_msg("data_pad  %d",   be32_to_cpu(vid_hdr->data_pad));
 	dbg_msg("sqnum     %llu",
-		(unsigned long long)ubi64_to_cpu(vid_hdr->sqnum));
-	dbg_msg("hdr_crc   %08x", ubi32_to_cpu(vid_hdr->hdr_crc));
+		(unsigned long long)be64_to_cpu(vid_hdr->sqnum));
+	dbg_msg("hdr_crc   %08x", be32_to_cpu(vid_hdr->hdr_crc));
 	dbg_msg("volume identifier header hexdump:");
 }
 
@@ -106,12 +106,12 @@ void ubi_dbg_dump_vol_info(const struct 
  */
 void ubi_dbg_dump_vtbl_record(const struct ubi_vtbl_record *r, int idx)
 {
-	int name_len = ubi16_to_cpu(r->name_len);
+	int name_len = be16_to_cpu(r->name_len);
 
 	dbg_msg("volume table record %d dump:", idx);
-	dbg_msg("reserved_pebs   %d", ubi32_to_cpu(r->reserved_pebs));
-	dbg_msg("alignment       %d", ubi32_to_cpu(r->alignment));
-	dbg_msg("data_pad        %d", ubi32_to_cpu(r->data_pad));
+	dbg_msg("reserved_pebs   %d", be32_to_cpu(r->reserved_pebs));
+	dbg_msg("alignment       %d", be32_to_cpu(r->alignment));
+	dbg_msg("data_pad        %d", be32_to_cpu(r->data_pad));
 	dbg_msg("vol_type        %d", (int)r->vol_type);
 	dbg_msg("upd_marker      %d", (int)r->upd_marker);
 	dbg_msg("name_len        %d", name_len);
@@ -129,7 +129,7 @@ void ubi_dbg_dump_vtbl_record(const stru
 			r->name[0], r->name[1], r->name[2], r->name[3],
 			r->name[4]);
 	}
-	dbg_msg("crc             %#08x", ubi32_to_cpu(r->crc));
+	dbg_msg("crc             %#08x", be32_to_cpu(r->crc));
 }
 
 /**
Index: linux-2.6/drivers/mtd/ubi/eba.c
===================================================================
--- linux-2.6.orig/drivers/mtd/ubi/eba.c	2007-05-17 15:06:33.000000000 +0200
+++ linux-2.6/drivers/mtd/ubi/eba.c	2007-05-17 15:19:18.000000000 +0200
@@ -425,10 +425,10 @@ retry:
 		} else if (err == UBI_IO_BITFLIPS)
 			scrub = 1;
 
-		ubi_assert(lnum < ubi32_to_cpu(vid_hdr->used_ebs));
-		ubi_assert(len == ubi32_to_cpu(vid_hdr->data_size));
+		ubi_assert(lnum < be32_to_cpu(vid_hdr->used_ebs));
+		ubi_assert(len == be32_to_cpu(vid_hdr->data_size));
 
-		crc = ubi32_to_cpu(vid_hdr->data_crc);
+		crc = be32_to_cpu(vid_hdr->data_crc);
 		ubi_free_vid_hdr(ubi, vid_hdr);
 	}
 
@@ -518,7 +518,7 @@ retry:
 		goto out_put;
 	}
 
-	vid_hdr->sqnum = cpu_to_ubi64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
 	err = ubi_io_write_vid_hdr(ubi, new_pnum, vid_hdr);
 	if (err)
 		goto write_error;
@@ -634,11 +634,11 @@ int ubi_eba_write_leb(struct ubi_device 
 	}
 
 	vid_hdr->vol_type = UBI_VID_DYNAMIC;
-	vid_hdr->sqnum = cpu_to_ubi64(next_sqnum(ubi));
-	vid_hdr->vol_id = cpu_to_ubi32(vol_id);
-	vid_hdr->lnum = cpu_to_ubi32(lnum);
+	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->vol_id = cpu_to_be32(vol_id);
+	vid_hdr->lnum = cpu_to_be32(lnum);
 	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
-	vid_hdr->data_pad = cpu_to_ubi32(vol->data_pad);
+	vid_hdr->data_pad = cpu_to_be32(vol->data_pad);
 
 retry:
 	pnum = ubi_wl_get_peb(ubi, dtype);
@@ -692,7 +692,7 @@ write_error:
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_ubi64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
 	ubi_msg("try another PEB");
 	goto retry;
 }
@@ -748,17 +748,17 @@ int ubi_eba_write_leb_st(struct ubi_devi
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_ubi64(next_sqnum(ubi));
-	vid_hdr->vol_id = cpu_to_ubi32(vol_id);
-	vid_hdr->lnum = cpu_to_ubi32(lnum);
+	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->vol_id = cpu_to_be32(vol_id);
+	vid_hdr->lnum = cpu_to_be32(lnum);
 	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
-	vid_hdr->data_pad = cpu_to_ubi32(vol->data_pad);
+	vid_hdr->data_pad = cpu_to_be32(vol->data_pad);
 
 	crc = crc32(UBI_CRC32_INIT, buf, data_size);
 	vid_hdr->vol_type = UBI_VID_STATIC;
-	vid_hdr->data_size = cpu_to_ubi32(data_size);
-	vid_hdr->used_ebs = cpu_to_ubi32(used_ebs);
-	vid_hdr->data_crc = cpu_to_ubi32(crc);
+	vid_hdr->data_size = cpu_to_be32(data_size);
+	vid_hdr->used_ebs = cpu_to_be32(used_ebs);
+	vid_hdr->data_crc = cpu_to_be32(crc);
 
 retry:
 	pnum = ubi_wl_get_peb(ubi, dtype);
@@ -813,7 +813,7 @@ write_error:
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_ubi64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
 	ubi_msg("try another PEB");
 	goto retry;
 }
@@ -854,17 +854,17 @@ int ubi_eba_atomic_leb_change(struct ubi
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_ubi64(next_sqnum(ubi));
-	vid_hdr->vol_id = cpu_to_ubi32(vol_id);
-	vid_hdr->lnum = cpu_to_ubi32(lnum);
+	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
+	vid_hdr->vol_id = cpu_to_be32(vol_id);
+	vid_hdr->lnum = cpu_to_be32(lnum);
 	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
-	vid_hdr->data_pad = cpu_to_ubi32(vol->data_pad);
+	vid_hdr->data_pad = cpu_to_be32(vol->data_pad);
 
 	crc = crc32(UBI_CRC32_INIT, buf, len);
 	vid_hdr->vol_type = UBI_VID_STATIC;
-	vid_hdr->data_size = cpu_to_ubi32(len);
+	vid_hdr->data_size = cpu_to_be32(len);
 	vid_hdr->copy_flag = 1;
-	vid_hdr->data_crc = cpu_to_ubi32(crc);
+	vid_hdr->data_crc = cpu_to_be32(crc);
 
 retry:
 	pnum = ubi_wl_get_peb(ubi, dtype);
@@ -924,7 +924,7 @@ write_error:
 		return err;
 	}
 
-	vid_hdr->sqnum = cpu_to_ubi64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
 	ubi_msg("try another PEB");
 	goto retry;
 }
@@ -965,17 +965,17 @@ int ubi_eba_copy_leb(struct ubi_device *
 	uint32_t crc;
 	void *buf, *buf1 = NULL;
 
-	vol_id = ubi32_to_cpu(vid_hdr->vol_id);
-	lnum = ubi32_to_cpu(vid_hdr->lnum);
+	vol_id = be32_to_cpu(vid_hdr->vol_id);
+	lnum = be32_to_cpu(vid_hdr->lnum);
 
 	dbg_eba("copy LEB %d:%d, PEB %d to PEB %d", vol_id, lnum, from, to);
 
 	if (vid_hdr->vol_type == UBI_VID_STATIC) {
-		data_size = ubi32_to_cpu(vid_hdr->data_size);
+		data_size = be32_to_cpu(vid_hdr->data_size);
 		aldata_size = ALIGN(data_size, ubi->min_io_size);
 	} else
 		data_size = aldata_size =
-			    ubi->leb_size - ubi32_to_cpu(vid_hdr->data_pad);
+			    ubi->leb_size - be32_to_cpu(vid_hdr->data_pad);
 
 	buf = kmalloc(aldata_size, GFP_KERNEL);
 	if (!buf)
@@ -1054,10 +1054,10 @@ int ubi_eba_copy_leb(struct ubi_device *
 	 */
 	if (data_size > 0) {
 		vid_hdr->copy_flag = 1;
-		vid_hdr->data_size = cpu_to_ubi32(data_size);
-		vid_hdr->data_crc = cpu_to_ubi32(crc);
+		vid_hdr->data_size = cpu_to_be32(data_size);
+		vid_hdr->data_crc = cpu_to_be32(crc);
 	}
-	vid_hdr->sqnum = cpu_to_ubi64(next_sqnum(ubi));
+	vid_hdr->sqnum = cpu_to_be64(next_sqnum(ubi));
 
 	err = ubi_io_write_vid_hdr(ubi, to, vid_hdr);
 	if (err)
Index: linux-2.6/drivers/mtd/ubi/io.c
===================================================================
--- linux-2.6.orig/drivers/mtd/ubi/io.c	2007-05-17 15:06:33.000000000 +0200
+++ linux-2.6/drivers/mtd/ubi/io.c	2007-05-17 15:15:22.000000000 +0200
@@ -557,9 +557,9 @@ static int validate_ec_hdr(const struct 
 	long long ec;
 	int vid_hdr_offset, leb_start;
 
-	ec = ubi64_to_cpu(ec_hdr->ec);
-	vid_hdr_offset = ubi32_to_cpu(ec_hdr->vid_hdr_offset);
-	leb_start = ubi32_to_cpu(ec_hdr->data_offset);
+	ec = be64_to_cpu(ec_hdr->ec);
+	vid_hdr_offset = be32_to_cpu(ec_hdr->vid_hdr_offset);
+	leb_start = be32_to_cpu(ec_hdr->data_offset);
 
 	if (ec_hdr->version != UBI_VERSION) {
 		ubi_err("node with incompatible UBI version found: "
@@ -640,7 +640,7 @@ int ubi_io_read_ec_hdr(const struct ubi_
 		read_err = err;
 	}
 
-	magic = ubi32_to_cpu(ec_hdr->magic);
+	magic = be32_to_cpu(ec_hdr->magic);
 	if (magic != UBI_EC_HDR_MAGIC) {
 		/*
 		 * The magic field is wrong. Let's check if we have read all
@@ -684,7 +684,7 @@ int ubi_io_read_ec_hdr(const struct ubi_
 	}
 
 	crc = crc32(UBI_CRC32_INIT, ec_hdr, UBI_EC_HDR_SIZE_CRC);
-	hdr_crc = ubi32_to_cpu(ec_hdr->hdr_crc);
+	hdr_crc = be32_to_cpu(ec_hdr->hdr_crc);
 
 	if (hdr_crc != crc) {
 		if (verbose) {
@@ -729,12 +729,12 @@ int ubi_io_write_ec_hdr(const struct ubi
 	dbg_io("write EC header to PEB %d", pnum);
 	ubi_assert(pnum >= 0 &&  pnum < ubi->peb_count);
 
-	ec_hdr->magic = cpu_to_ubi32(UBI_EC_HDR_MAGIC);
+	ec_hdr->magic = cpu_to_be32(UBI_EC_HDR_MAGIC);
 	ec_hdr->version = UBI_VERSION;
-	ec_hdr->vid_hdr_offset = cpu_to_ubi32(ubi->vid_hdr_offset);
-	ec_hdr->data_offset = cpu_to_ubi32(ubi->leb_start);
+	ec_hdr->vid_hdr_offset = cpu_to_be32(ubi->vid_hdr_offset);
+	ec_hdr->data_offset = cpu_to_be32(ubi->leb_start);
 	crc = crc32(UBI_CRC32_INIT, ec_hdr, UBI_EC_HDR_SIZE_CRC);
-	ec_hdr->hdr_crc = cpu_to_ubi32(crc);
+	ec_hdr->hdr_crc = cpu_to_be32(crc);
 
 	err = paranoid_check_ec_hdr(ubi, pnum, ec_hdr);
 	if (err)
@@ -757,13 +757,13 @@ static int validate_vid_hdr(const struct
 {
 	int vol_type = vid_hdr->vol_type;
 	int copy_flag = vid_hdr->copy_flag;
-	int vol_id = ubi32_to_cpu(vid_hdr->vol_id);
-	int lnum = ubi32_to_cpu(vid_hdr->lnum);
+	int vol_id = be32_to_cpu(vid_hdr->vol_id);
+	int lnum = be32_to_cpu(vid_hdr->lnum);
 	int compat = vid_hdr->compat;
-	int data_size = ubi32_to_cpu(vid_hdr->data_size);
-	int used_ebs = ubi32_to_cpu(vid_hdr->used_ebs);
-	int data_pad = ubi32_to_cpu(vid_hdr->data_pad);
-	int data_crc = ubi32_to_cpu(vid_hdr->data_crc);
+	int data_size = be32_to_cpu(vid_hdr->data_size);
+	int used_ebs = be32_to_cpu(vid_hdr->used_ebs);
+	int data_pad = be32_to_cpu(vid_hdr->data_pad);
+	int data_crc = be32_to_cpu(vid_hdr->data_crc);
 	int usable_leb_size = ubi->leb_size - data_pad;
 
 	if (copy_flag != 0 && copy_flag != 1) {
@@ -914,7 +914,7 @@ int ubi_io_read_vid_hdr(const struct ubi
 		read_err = err;
 	}
 
-	magic = ubi32_to_cpu(vid_hdr->magic);
+	magic = be32_to_cpu(vid_hdr->magic);
 	if (magic != UBI_VID_HDR_MAGIC) {
 		/*
 		 * If we have read all 0xFF bytes, the VID header probably does
@@ -957,7 +957,7 @@ int ubi_io_read_vid_hdr(const struct ubi
 	}
 
 	crc = crc32(UBI_CRC32_INIT, vid_hdr, UBI_VID_HDR_SIZE_CRC);
-	hdr_crc = ubi32_to_cpu(vid_hdr->hdr_crc);
+	hdr_crc = be32_to_cpu(vid_hdr->hdr_crc);
 
 	if (hdr_crc != crc) {
 		if (verbose) {
@@ -1007,10 +1007,10 @@ int ubi_io_write_vid_hdr(const struct ub
 	if (err)
 		return err > 0 ? -EINVAL: err;
 
-	vid_hdr->magic = cpu_to_ubi32(UBI_VID_HDR_MAGIC);
+	vid_hdr->magic = cpu_to_be32(UBI_VID_HDR_MAGIC);
 	vid_hdr->version = UBI_VERSION;
 	crc = crc32(UBI_CRC32_INIT, vid_hdr, UBI_VID_HDR_SIZE_CRC);
-	vid_hdr->hdr_crc = cpu_to_ubi32(crc);
+	vid_hdr->hdr_crc = cpu_to_be32(crc);
 
 	err = paranoid_check_vid_hdr(ubi, pnum, vid_hdr);
 	if (err)
@@ -1060,7 +1060,7 @@ static int paranoid_check_ec_hdr(const s
 	int err;
 	uint32_t magic;
 
-	magic = ubi32_to_cpu(ec_hdr->magic);
+	magic = be32_to_cpu(ec_hdr->magic);
 	if (magic != UBI_EC_HDR_MAGIC) {
 		ubi_err("bad magic %#08x, must be %#08x",
 			magic, UBI_EC_HDR_MAGIC);
@@ -1105,7 +1105,7 @@ static int paranoid_check_peb_ec_hdr(con
 		goto exit;
 
 	crc = crc32(UBI_CRC32_INIT, ec_hdr, UBI_EC_HDR_SIZE_CRC);
-	hdr_crc = ubi32_to_cpu(ec_hdr->hdr_crc);
+	hdr_crc = be32_to_cpu(ec_hdr->hdr_crc);
 	if (hdr_crc != crc) {
 		ubi_err("bad CRC, calculated %#08x, read %#08x", crc, hdr_crc);
 		ubi_err("paranoid check failed for PEB %d", pnum);
@@ -1137,7 +1137,7 @@ static int paranoid_check_vid_hdr(const 
 	int err;
 	uint32_t magic;
 
-	magic = ubi32_to_cpu(vid_hdr->magic);
+	magic = be32_to_cpu(vid_hdr->magic);
 	if (magic != UBI_VID_HDR_MAGIC) {
 		ubi_err("bad VID header magic %#08x at PEB %d, must be %#08x",
 			magic, pnum, UBI_VID_HDR_MAGIC);
@@ -1187,7 +1187,7 @@ static int paranoid_check_peb_vid_hdr(co
 		goto exit;
 
 	crc = crc32(UBI_CRC32_INIT, vid_hdr, UBI_EC_HDR_SIZE_CRC);
-	hdr_crc = ubi32_to_cpu(vid_hdr->hdr_crc);
+	hdr_crc = be32_to_cpu(vid_hdr->hdr_crc);
 	if (hdr_crc != crc) {
 		ubi_err("bad VID header CRC at PEB %d, calculated %#08x, "
 			"read %#08x", pnum, crc, hdr_crc);
Index: linux-2.6/drivers/mtd/ubi/scan.c
===================================================================
--- linux-2.6.orig/drivers/mtd/ubi/scan.c	2007-05-17 15:06:33.000000000 +0200
+++ linux-2.6/drivers/mtd/ubi/scan.c	2007-05-17 15:16:07.000000000 +0200
@@ -121,9 +121,9 @@ static int validate_vid_hdr(const struct
 			    const struct ubi_scan_volume *sv, int pnum)
 {
 	int vol_type = vid_hdr->vol_type;
-	int vol_id = ubi32_to_cpu(vid_hdr->vol_id);
-	int used_ebs = ubi32_to_cpu(vid_hdr->used_ebs);
-	int data_pad = ubi32_to_cpu(vid_hdr->data_pad);
+	int vol_id = be32_to_cpu(vid_hdr->vol_id);
+	int used_ebs = be32_to_cpu(vid_hdr->used_ebs);
+	int data_pad = be32_to_cpu(vid_hdr->data_pad);
 
 	if (sv->leb_count != 0) {
 		int sv_vol_type;
@@ -189,7 +189,7 @@ static struct ubi_scan_volume *add_volum
 	struct ubi_scan_volume *sv;
 	struct rb_node **p = &si->volumes.rb_node, *parent = NULL;
 
-	ubi_assert(vol_id == ubi32_to_cpu(vid_hdr->vol_id));
+	ubi_assert(vol_id == be32_to_cpu(vid_hdr->vol_id));
 
 	/* Walk the volume RB-tree to look if this volume is already present */
 	while (*p) {
@@ -214,8 +214,8 @@ static struct ubi_scan_volume *add_volum
 	si->max_sqnum = 0;
 	sv->vol_id = vol_id;
 	sv->root = RB_ROOT;
-	sv->used_ebs = ubi32_to_cpu(vid_hdr->used_ebs);
-	sv->data_pad = ubi32_to_cpu(vid_hdr->data_pad);
+	sv->used_ebs = be32_to_cpu(vid_hdr->used_ebs);
+	sv->data_pad = be32_to_cpu(vid_hdr->data_pad);
 	sv->compat = vid_hdr->compat;
 	sv->vol_type = vid_hdr->vol_type == UBI_VID_DYNAMIC ? UBI_DYNAMIC_VOLUME
 							    : UBI_STATIC_VOLUME;
@@ -257,10 +257,10 @@ static int compare_lebs(const struct ubi
 	int len, err, second_is_newer, bitflips = 0, corrupted = 0;
 	uint32_t data_crc, crc;
 	struct ubi_vid_hdr *vidh = NULL;
-	unsigned long long sqnum2 = ubi64_to_cpu(vid_hdr->sqnum);
+	unsigned long long sqnum2 = be64_to_cpu(vid_hdr->sqnum);
 
 	if (seb->sqnum == 0 && sqnum2 == 0) {
-		long long abs, v1 = seb->leb_ver, v2 = ubi32_to_cpu(vid_hdr->leb_ver);
+		long long abs, v1 = seb->leb_ver, v2 = be32_to_cpu(vid_hdr->leb_ver);
 
 		/*
 		 * UBI constantly increases the logical eraseblock version
@@ -344,7 +344,7 @@ static int compare_lebs(const struct ubi
 
 	/* Read the data of the copy and check the CRC */
 
-	len = ubi32_to_cpu(vid_hdr->data_size);
+	len = be32_to_cpu(vid_hdr->data_size);
 	buf = kmalloc(len, GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
@@ -355,7 +355,7 @@ static int compare_lebs(const struct ubi
 	if (err && err != UBI_IO_BITFLIPS)
 		goto out_free_buf;
 
-	data_crc = ubi32_to_cpu(vid_hdr->data_crc);
+	data_crc = be32_to_cpu(vid_hdr->data_crc);
 	crc = crc32(UBI_CRC32_INIT, buf, len);
 	if (crc != data_crc) {
 		dbg_bld("PEB %d CRC error: calculated %#08x, must be %#08x",
@@ -410,10 +410,10 @@ int ubi_scan_add_used(const struct ubi_d
 	struct ubi_scan_leb *seb;
 	struct rb_node **p, *parent = NULL;
 
-	vol_id = ubi32_to_cpu(vid_hdr->vol_id);
-	lnum = ubi32_to_cpu(vid_hdr->lnum);
-	sqnum = ubi64_to_cpu(vid_hdr->sqnum);
-	leb_ver = ubi32_to_cpu(vid_hdr->leb_ver);
+	vol_id = be32_to_cpu(vid_hdr->vol_id);
+	lnum = be32_to_cpu(vid_hdr->lnum);
+	sqnum = be64_to_cpu(vid_hdr->sqnum);
+	leb_ver = be32_to_cpu(vid_hdr->leb_ver);
 
 	dbg_bld("PEB %d, LEB %d:%d, EC %d, sqnum %llu, ver %u, bitflips %d",
 		pnum, vol_id, lnum, ec, sqnum, leb_ver, bitflips);
@@ -508,7 +508,7 @@ int ubi_scan_add_used(const struct ubi_d
 
 			if (sv->highest_lnum == lnum)
 				sv->last_data_size =
-					ubi32_to_cpu(vid_hdr->data_size);
+					be32_to_cpu(vid_hdr->data_size);
 
 			return 0;
 		} else {
@@ -547,7 +547,7 @@ int ubi_scan_add_used(const struct ubi_d
 
 	if (sv->highest_lnum <= lnum) {
 		sv->highest_lnum = lnum;
-		sv->last_data_size = ubi32_to_cpu(vid_hdr->data_size);
+		sv->last_data_size = be32_to_cpu(vid_hdr->data_size);
 	}
 
 	if (si->max_sqnum < sqnum)
@@ -674,7 +674,7 @@ int ubi_scan_erase_peb(const struct ubi_
 		return -EINVAL;
 	}
 
-	ec_hdr->ec = cpu_to_ubi64(ec);
+	ec_hdr->ec = cpu_to_be64(ec);
 
 	err = ubi_io_sync_erase(ubi, pnum, 0);
 	if (err < 0)
@@ -806,7 +806,7 @@ static int process_eb(struct ubi_device 
 			return -EINVAL;
 		}
 
-		ec = ubi64_to_cpu(ech->ec);
+		ec = be64_to_cpu(ech->ec);
 		if (ec > UBI_MAX_ERASECOUNTER) {
 			/*
 			 * Erase counter overflow. The EC headers have 64 bits
@@ -844,9 +844,9 @@ static int process_eb(struct ubi_device 
 		goto adjust_mean_ec;
 	}
 
-	vol_id = ubi32_to_cpu(vidh->vol_id);
+	vol_id = be32_to_cpu(vidh->vol_id);
 	if (vol_id > UBI_MAX_VOLUMES && vol_id != UBI_LAYOUT_VOL_ID) {
-		int lnum = ubi32_to_cpu(vidh->lnum);
+		int lnum = be32_to_cpu(vidh->lnum);
 
 		/* Unsupported internal volume */
 		switch (vidh->compat) {
@@ -1249,12 +1249,12 @@ static int paranoid_check_si(const struc
 				goto bad_vid_hdr;
 			}
 
-			if (seb->sqnum != ubi64_to_cpu(vidh->sqnum)) {
+			if (seb->sqnum != be64_to_cpu(vidh->sqnum)) {
 				ubi_err("bad sqnum %llu", seb->sqnum);
 				goto bad_vid_hdr;
 			}
 
-			if (sv->vol_id != ubi32_to_cpu(vidh->vol_id)) {
+			if (sv->vol_id != be32_to_cpu(vidh->vol_id)) {
 				ubi_err("bad vol_id %d", sv->vol_id);
 				goto bad_vid_hdr;
 			}
@@ -1264,22 +1264,22 @@ static int paranoid_check_si(const struc
 				goto bad_vid_hdr;
 			}
 
-			if (seb->lnum != ubi32_to_cpu(vidh->lnum)) {
+			if (seb->lnum != be32_to_cpu(vidh->lnum)) {
 				ubi_err("bad lnum %d", seb->lnum);
 				goto bad_vid_hdr;
 			}
 
-			if (sv->used_ebs != ubi32_to_cpu(vidh->used_ebs)) {
+			if (sv->used_ebs != be32_to_cpu(vidh->used_ebs)) {
 				ubi_err("bad used_ebs %d", sv->used_ebs);
 				goto bad_vid_hdr;
 			}
 
-			if (sv->data_pad != ubi32_to_cpu(vidh->data_pad)) {
+			if (sv->data_pad != be32_to_cpu(vidh->data_pad)) {
 				ubi_err("bad data_pad %d", sv->data_pad);
 				goto bad_vid_hdr;
 			}
 
-			if (seb->leb_ver != ubi32_to_cpu(vidh->leb_ver)) {
+			if (seb->leb_ver != be32_to_cpu(vidh->leb_ver)) {
 				ubi_err("bad leb_ver %u", seb->leb_ver);
 				goto bad_vid_hdr;
 			}
@@ -1288,12 +1288,12 @@ static int paranoid_check_si(const struc
 		if (!last_seb)
 			continue;
 
-		if (sv->highest_lnum != ubi32_to_cpu(vidh->lnum)) {
+		if (sv->highest_lnum != be32_to_cpu(vidh->lnum)) {
 			ubi_err("bad highest_lnum %d", sv->highest_lnum);
 			goto bad_vid_hdr;
 		}
 
-		if (sv->last_data_size != ubi32_to_cpu(vidh->data_size)) {
+		if (sv->last_data_size != be32_to_cpu(vidh->data_size)) {
 			ubi_err("bad last_data_size %d", sv->last_data_size);
 			goto bad_vid_hdr;
 		}
Index: linux-2.6/drivers/mtd/ubi/vmt.c
===================================================================
--- linux-2.6.orig/drivers/mtd/ubi/vmt.c	2007-05-17 15:06:33.000000000 +0200
+++ linux-2.6/drivers/mtd/ubi/vmt.c	2007-05-17 15:18:23.000000000 +0200
@@ -320,10 +320,10 @@ int ubi_create_volume(struct ubi_device 
 
 	/* Fill volume table record */
 	memset(&vtbl_rec, 0, sizeof(struct ubi_vtbl_record));
-	vtbl_rec.reserved_pebs = cpu_to_ubi32(vol->reserved_pebs);
-	vtbl_rec.alignment     = cpu_to_ubi32(vol->alignment);
-	vtbl_rec.data_pad      = cpu_to_ubi32(vol->data_pad);
-	vtbl_rec.name_len      = cpu_to_ubi16(vol->name_len);
+	vtbl_rec.reserved_pebs = cpu_to_be32(vol->reserved_pebs);
+	vtbl_rec.alignment     = cpu_to_be32(vol->alignment);
+	vtbl_rec.data_pad      = cpu_to_be32(vol->data_pad);
+	vtbl_rec.name_len      = cpu_to_be16(vol->name_len);
 	if (vol->vol_type == UBI_DYNAMIC_VOLUME)
 		vtbl_rec.vol_type = UBI_VID_DYNAMIC;
 	else
@@ -503,7 +503,7 @@ int ubi_resize_volume(struct ubi_volume_
 
 	/* Change volume table record */
 	memcpy(&vtbl_rec, &ubi->vtbl[vol_id], sizeof(struct ubi_vtbl_record));
-	vtbl_rec.reserved_pebs = cpu_to_ubi32(reserved_pebs);
+	vtbl_rec.reserved_pebs = cpu_to_be32(reserved_pebs);
 	err = ubi_change_vtbl_record(ubi, vol_id, &vtbl_rec);
 	if (err)
 		goto out_acc;
@@ -651,7 +651,7 @@ static void paranoid_check_volume(const 
 	long long n;
 	const char *name;
 
-	reserved_pebs = ubi32_to_cpu(ubi->vtbl[vol_id].reserved_pebs);
+	reserved_pebs = be32_to_cpu(ubi->vtbl[vol_id].reserved_pebs);
 
 	if (!vol) {
 		if (reserved_pebs) {
@@ -765,9 +765,9 @@ static void paranoid_check_volume(const 
 		}
 	}
 
-	alignment  = ubi32_to_cpu(ubi->vtbl[vol_id].alignment);
-	data_pad   = ubi32_to_cpu(ubi->vtbl[vol_id].data_pad);
-	name_len   = ubi16_to_cpu(ubi->vtbl[vol_id].name_len);
+	alignment  = be32_to_cpu(ubi->vtbl[vol_id].alignment);
+	data_pad   = be32_to_cpu(ubi->vtbl[vol_id].data_pad);
+	name_len   = be16_to_cpu(ubi->vtbl[vol_id].name_len);
 	upd_marker = ubi->vtbl[vol_id].upd_marker;
 	name       = &ubi->vtbl[vol_id].name[0];
 	if (ubi->vtbl[vol_id].vol_type == UBI_VID_DYNAMIC)
Index: linux-2.6/drivers/mtd/ubi/vtbl.c
===================================================================
--- linux-2.6.orig/drivers/mtd/ubi/vtbl.c	2007-05-17 15:06:33.000000000 +0200
+++ linux-2.6/drivers/mtd/ubi/vtbl.c	2007-05-17 15:14:11.000000000 +0200
@@ -93,7 +93,7 @@ int ubi_change_vtbl_record(struct ubi_de
 		vtbl_rec = &empty_vtbl_record;
 	else {
 		crc = crc32(UBI_CRC32_INIT, vtbl_rec, UBI_VTBL_RECORD_SIZE_CRC);
-		vtbl_rec->crc = cpu_to_ubi32(crc);
+		vtbl_rec->crc = cpu_to_be32(crc);
 	}
 
 	dbg_msg("change record %d", idx);
@@ -141,18 +141,18 @@ static int vtbl_check(const struct ubi_d
 	for (i = 0; i < ubi->vtbl_slots; i++) {
 		cond_resched();
 
-		reserved_pebs = ubi32_to_cpu(vtbl[i].reserved_pebs);
-		alignment = ubi32_to_cpu(vtbl[i].alignment);
-		data_pad = ubi32_to_cpu(vtbl[i].data_pad);
+		reserved_pebs = be32_to_cpu(vtbl[i].reserved_pebs);
+		alignment = be32_to_cpu(vtbl[i].alignment);
+		data_pad = be32_to_cpu(vtbl[i].data_pad);
 		upd_marker = vtbl[i].upd_marker;
 		vol_type = vtbl[i].vol_type;
-		name_len = ubi16_to_cpu(vtbl[i].name_len);
+		name_len = be16_to_cpu(vtbl[i].name_len);
 		name = &vtbl[i].name[0];
 
 		crc = crc32(UBI_CRC32_INIT, &vtbl[i], UBI_VTBL_RECORD_SIZE_CRC);
-		if (ubi32_to_cpu(vtbl[i].crc) != crc) {
+		if (be32_to_cpu(vtbl[i].crc) != crc) {
 			ubi_err("bad CRC at record %u: %#08x, not %#08x",
-				 i, crc, ubi32_to_cpu(vtbl[i].crc));
+				 i, crc, be32_to_cpu(vtbl[i].crc));
 			ubi_dbg_dump_vtbl_record(&vtbl[i], i);
 			return 1;
 		}
@@ -225,8 +225,8 @@ static int vtbl_check(const struct ubi_d
 	/* Checks that all names are unique */
 	for (i = 0; i < ubi->vtbl_slots - 1; i++) {
 		for (n = i + 1; n < ubi->vtbl_slots; n++) {
-			int len1 = ubi16_to_cpu(vtbl[i].name_len);
-			int len2 = ubi16_to_cpu(vtbl[n].name_len);
+			int len1 = be16_to_cpu(vtbl[i].name_len);
+			int len2 = be16_to_cpu(vtbl[n].name_len);
 
 			if (len1 > 0 && len1 == len2 &&
 			    !strncmp(vtbl[i].name, vtbl[n].name, len1)) {
@@ -288,13 +288,13 @@ retry:
 	}
 
 	vid_hdr->vol_type = UBI_VID_DYNAMIC;
-	vid_hdr->vol_id = cpu_to_ubi32(UBI_LAYOUT_VOL_ID);
+	vid_hdr->vol_id = cpu_to_be32(UBI_LAYOUT_VOL_ID);
 	vid_hdr->compat = UBI_LAYOUT_VOLUME_COMPAT;
 	vid_hdr->data_size = vid_hdr->used_ebs =
-			     vid_hdr->data_pad = cpu_to_ubi32(0);
-	vid_hdr->lnum = cpu_to_ubi32(copy);
-	vid_hdr->sqnum = cpu_to_ubi64(++si->max_sqnum);
-	vid_hdr->leb_ver = cpu_to_ubi32(old_seb ? old_seb->leb_ver + 1: 0);
+			     vid_hdr->data_pad = cpu_to_be32(0);
+	vid_hdr->lnum = cpu_to_be32(copy);
+	vid_hdr->sqnum = cpu_to_be64(++si->max_sqnum);
+	vid_hdr->leb_ver = cpu_to_be32(old_seb ? old_seb->leb_ver + 1: 0);
 
 	/* The EC header is already there, write the VID header */
 	err = ubi_io_write_vid_hdr(ubi, new_seb->pnum, vid_hdr);
@@ -500,19 +500,19 @@ static int init_volumes(struct ubi_devic
 	for (i = 0; i < ubi->vtbl_slots; i++) {
 		cond_resched();
 
-		if (ubi32_to_cpu(vtbl[i].reserved_pebs) == 0)
+		if (be32_to_cpu(vtbl[i].reserved_pebs) == 0)
 			continue; /* Empty record */
 
 		vol = kzalloc(sizeof(struct ubi_volume), GFP_KERNEL);
 		if (!vol)
 			return -ENOMEM;
 
-		vol->reserved_pebs = ubi32_to_cpu(vtbl[i].reserved_pebs);
-		vol->alignment = ubi32_to_cpu(vtbl[i].alignment);
-		vol->data_pad = ubi32_to_cpu(vtbl[i].data_pad);
+		vol->reserved_pebs = be32_to_cpu(vtbl[i].reserved_pebs);
+		vol->alignment = be32_to_cpu(vtbl[i].alignment);
+		vol->data_pad = be32_to_cpu(vtbl[i].data_pad);
 		vol->vol_type = vtbl[i].vol_type == UBI_VID_DYNAMIC ?
 					UBI_DYNAMIC_VOLUME : UBI_STATIC_VOLUME;
-		vol->name_len = ubi16_to_cpu(vtbl[i].name_len);
+		vol->name_len = be16_to_cpu(vtbl[i].name_len);
 		vol->usable_leb_size = ubi->leb_size - vol->data_pad;
 		memcpy(vol->name, vtbl[i].name, vol->name_len);
 		vol->name[vol->name_len] = '\0';
@@ -718,7 +718,7 @@ int ubi_read_volume_table(struct ubi_dev
 	int i, err;
 	struct ubi_scan_volume *sv;
 
-	empty_vtbl_record.crc = cpu_to_ubi32(0xf116c36b);
+	empty_vtbl_record.crc = cpu_to_be32(0xf116c36b);
 
 	/*
 	 * The number of supported volumes is limited by the eraseblock size
Index: linux-2.6/include/mtd/ubi-header.h
===================================================================
--- linux-2.6.orig/include/mtd/ubi-header.h	2007-05-17 15:09:40.000000000 +0200
+++ linux-2.6/include/mtd/ubi-header.h	2007-05-17 15:12:20.000000000 +0200
@@ -74,42 +74,13 @@ enum {
 	UBI_COMPAT_REJECT   = 5
 };
 
-/*
- * ubi16_t/ubi32_t/ubi64_t - 16, 32, and 64-bit integers used in UBI on-flash
- * data structures.
- */
-typedef struct {
-	uint16_t int16;
-} __attribute__ ((packed)) ubi16_t;
-
-typedef struct {
-	uint32_t int32;
-} __attribute__ ((packed)) ubi32_t;
-
-typedef struct {
-	uint64_t int64;
-} __attribute__ ((packed)) ubi64_t;
-
-/*
- * In this implementation of UBI uses the big-endian format for on-flash
- * integers. The below are the corresponding conversion macros.
- */
-#define cpu_to_ubi16(x) ((ubi16_t){__cpu_to_be16(x)})
-#define ubi16_to_cpu(x) ((uint16_t)__be16_to_cpu((x).int16))
-
-#define cpu_to_ubi32(x) ((ubi32_t){__cpu_to_be32(x)})
-#define ubi32_to_cpu(x) ((uint32_t)__be32_to_cpu((x).int32))
-
-#define cpu_to_ubi64(x) ((ubi64_t){__cpu_to_be64(x)})
-#define ubi64_to_cpu(x) ((uint64_t)__be64_to_cpu((x).int64))
-
 /* Sizes of UBI headers */
 #define UBI_EC_HDR_SIZE  sizeof(struct ubi_ec_hdr)
 #define UBI_VID_HDR_SIZE sizeof(struct ubi_vid_hdr)
 
 /* Sizes of UBI headers without the ending CRC */
-#define UBI_EC_HDR_SIZE_CRC  (UBI_EC_HDR_SIZE  - sizeof(ubi32_t))
-#define UBI_VID_HDR_SIZE_CRC (UBI_VID_HDR_SIZE - sizeof(ubi32_t))
+#define UBI_EC_HDR_SIZE_CRC  (UBI_EC_HDR_SIZE  - sizeof(__be32))
+#define UBI_VID_HDR_SIZE_CRC (UBI_VID_HDR_SIZE - sizeof(__be32))
 
 /**
  * struct ubi_ec_hdr - UBI erase counter header.
@@ -137,14 +108,14 @@ typedef struct {
  * eraseblocks.
  */
 struct ubi_ec_hdr {
-	ubi32_t magic;
-	uint8_t version;
-	uint8_t padding1[3];
-	ubi64_t ec; /* Warning: the current limit is 31-bit anyway! */
-	ubi32_t vid_hdr_offset;
-	ubi32_t data_offset;
-	uint8_t padding2[36];
-	ubi32_t hdr_crc;
+	__be32  magic;
+	__u8    version;
+	__u8    padding1[3];
+	__be64  ec; /* Warning: the current limit is 31-bit anyway! */
+	__be32  vid_hdr_offset;
+	__be32  data_offset;
+	__u8    padding2[36];
+	__be32  hdr_crc;
 } __attribute__ ((packed));
 
 /**
@@ -262,22 +233,22 @@ struct ubi_ec_hdr {
  * software (say, cramfs) on top of the UBI volume.
  */
 struct ubi_vid_hdr {
-	ubi32_t magic;
-	uint8_t version;
-	uint8_t vol_type;
-	uint8_t copy_flag;
-	uint8_t compat;
-	ubi32_t vol_id;
-	ubi32_t lnum;
-	ubi32_t leb_ver; /* obsolete, to be removed, don't use */
-	ubi32_t data_size;
-	ubi32_t used_ebs;
-	ubi32_t data_pad;
-	ubi32_t data_crc;
-	uint8_t padding1[4];
-	ubi64_t sqnum;
-	uint8_t padding2[12];
-	ubi32_t hdr_crc;
+	__be32  magic;
+	__u8    version;
+	__u8    vol_type;
+	__u8    copy_flag;
+	__u8    compat;
+	__be32  vol_id;
+	__be32  lnum;
+	__be32  leb_ver; /* obsolete, to be removed, don't use */
+	__be32  data_size;
+	__be32  used_ebs;
+	__be32  data_pad;
+	__be32  data_crc;
+	__u8    padding1[4];
+	__be64  sqnum;
+	__u8    padding2[12];
+	__be32  hdr_crc;
 } __attribute__ ((packed));
 
 /* Internal UBI volumes count */
@@ -306,7 +277,7 @@ struct ubi_vid_hdr {
 #define UBI_VTBL_RECORD_SIZE sizeof(struct ubi_vtbl_record)
 
 /* Size of the volume table record without the ending CRC */
-#define UBI_VTBL_RECORD_SIZE_CRC (UBI_VTBL_RECORD_SIZE - sizeof(ubi32_t))
+#define UBI_VTBL_RECORD_SIZE_CRC (UBI_VTBL_RECORD_SIZE - sizeof(__be32))
 
 /**
  * struct ubi_vtbl_record - a record in the volume table.
@@ -346,15 +317,15 @@ struct ubi_vid_hdr {
  * Empty records contain all zeroes and the CRC checksum of those zeroes.
  */
 struct ubi_vtbl_record {
-	ubi32_t reserved_pebs;
-	ubi32_t alignment;
-	ubi32_t data_pad;
-	uint8_t vol_type;
-	uint8_t upd_marker;
-	ubi16_t name_len;
-	uint8_t name[UBI_VOL_NAME_MAX+1];
-	uint8_t padding2[24];
-	ubi32_t crc;
+	__be32  reserved_pebs;
+	__be32  alignment;
+	__be32  data_pad;
+	__u8    vol_type;
+	__u8    upd_marker;
+	__be16  name_len;
+	__u8    name[UBI_VOL_NAME_MAX+1];
+	__u8    padding2[24];
+	__be32  crc;
 } __attribute__ ((packed));
 
 #endif /* !__UBI_HEADER_H__ */
Index: linux-2.6/drivers/mtd/ubi/wl.c
===================================================================
--- linux-2.6.orig/drivers/mtd/ubi/wl.c	2007-05-17 15:15:27.000000000 +0200
+++ linux-2.6/drivers/mtd/ubi/wl.c	2007-05-17 15:15:42.000000000 +0200
@@ -667,7 +667,7 @@ static int sync_erase(struct ubi_device 
 
 	dbg_wl("erased PEB %d, new EC %llu", e->pnum, ec);
 
-	ec_hdr->ec = cpu_to_ubi64(ec);
+	ec_hdr->ec = cpu_to_be64(ec);
 
 	err = ubi_io_write_ec_hdr(ubi, e->pnum, ec_hdr);
 	if (err)
@@ -1633,7 +1633,7 @@ static int paranoid_check_ec(const struc
 		goto out_free;
 	}
 
-	read_ec = ubi64_to_cpu(ec_hdr->ec);
+	read_ec = be64_to_cpu(ec_hdr->ec);
 	if (ec != read_ec) {
 		ubi_err("paranoid check failed for PEB %d", pnum);
 		ubi_err("read EC is %lld, should be %d", read_ec, ec);
