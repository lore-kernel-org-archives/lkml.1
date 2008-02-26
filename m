Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbYBZJs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbYBZJs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761321AbYBZJsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:48:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:37581 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760940AbYBZJsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:48:09 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19DNoUbQ3NDxkodt9F/W+qpJGmy8fKp8j4vrZnPc8
	oZt8vQ+Cv02UQ8
Subject: Re: regression: CD burning (k3b) went broke
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <1203839683.17463.9.camel@homer.simson.net>
References: <1203583379.6244.27.camel@homer.simson.net>
	 <20080222073228.GZ23197@kernel.dk>
	 <1203752563.5225.4.camel@homer.simson.net>
	 <1203839683.17463.9.camel@homer.simson.net>
Content-Type: multipart/mixed; boundary="=-/4psmbZyY+3dhdEEmK44"
Date: Tue, 26 Feb 2008 10:48:03 +0100
Message-Id: <1204019283.8731.11.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/4psmbZyY+3dhdEEmK44
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Greetings,

I straced both a good and a bad kernel (good being .git with attached
revert patch applied) and filtered/diffed/merged the output.  Scroll
down to "HERE" to see the problem (resid).

I'm poking around, but not having much luck.

--- good	2008-02-26 09:11:08.000000000 +0100
+++ bad	2008-02-26 09:03:44.000000000 +0100
@@ -1,48 +1,44 @@
 open("/dev/sr0", O_RDWR|O_NONBLOCK) = 3
 fcntl64(3, F_GETFL)         = 0x8802 (flags O_RDWR|O_NONBLOCK|O_LARGEFILE)
 fcntl64(3, F_SETFL, O_RDWR|O_LARGEFILE) = 0
-ioctl(3, CDROMAUDIOBUFSIZ or SCSI_IOCTL_GET_IDLUN, 0xaf8d9194) = 0
-ioctl(3, SCSI_IOCTL_GET_BUS_NUMBER, 0xaf8d9190) = 0
-ioctl(3, SG_GET_VERSION_NUM, 0xaf8d9198) = 0
+ioctl(3, CDROMAUDIOBUFSIZ or SCSI_IOCTL_GET_IDLUN, 0xafa1a2d4) = 0
+ioctl(3, SCSI_IOCTL_GET_BUS_NUMBER, 0xafa1a2d0) = 0
+ioctl(3, SG_GET_VERSION_NUM, 0xafa1a2d8) = 0
 write(2, "Linux sg driver version: 3.5.27\n", 32Linux sg driver version: 3.5.27
 ) = 32
-ioctl(3, CDROMAUDIOBUFSIZ or SCSI_IOCTL_GET_IDLUN, 0xaf8d9134) = 0
-ioctl(3, SCSI_IOCTL_GET_BUS_NUMBER, 0xaf8d9130) = 0
-ioctl(3, SG_SET_TIMEOUT, 0xaf8d9030) = 0
-fstat64(3, {st_dev=makedev(0, 13), st_ino=4758, st_mode=S_IFBLK|0640, st_nlink=1, st_uid=0, st_gid=6, st_blksize=4096, st_blocks=0, st_rdev=makedev(11, 0), st_atime=2008/02/26-08:45:17, st_mtime=2008/02/26-08:45:17, st_ctime=2008/02/26-08:45:17}) = 0
+ioctl(3, CDROMAUDIOBUFSIZ or SCSI_IOCTL_GET_IDLUN, 0xafa1a274) = 0
+ioctl(3, SCSI_IOCTL_GET_BUS_NUMBER, 0xafa1a270) = 0
+ioctl(3, SG_SET_TIMEOUT, 0xafa1a170) = 0
+fstat64(3, {st_dev=makedev(0, 13), st_ino=4572, st_mode=S_IFBLK|0640, st_nlink=1, st_uid=0, st_gid=6, st_blksize=4096, st_blocks=0, st_rdev=makedev(11, 0), st_atime=2008/02/26-09:36:43, st_mtime=2008/02/26-09:36:43, st_ctime=2008/02/26-09:36:43}) = 0
 geteuid32()                 = 0
 getuid32()                  = 0
 write(1, "Using libscg version \'schily-0.9"..., 35) = 35
 write(1, "Driveropts: \'burnfree\'\n", 23) = 23
-ioctl(3, SG_GET_RESERVED_SIZE, 0xaf8d93d4) = 0
-ioctl(3, SG_GET_RESERVED_SIZE, 0xaf8d93d8) = 0
-ioctl(3, SG_GET_PACK_ID, 0xaf8d93d0) = -1 ENOTTY (Inappropriate ioctl for device)
+ioctl(3, SG_GET_RESERVED_SIZE, 0xafa1a514) = 0
+ioctl(3, SG_GET_RESERVED_SIZE, 0xafa1a518) = 0
+ioctl(3, SG_GET_PACK_ID, 0xafa1a510) = -1 ENOTTY (Inappropriate ioctl for device)
 write(2, "SCSI buffer size: 64512\n", 24SCSI buffer size: 64512
 ) = 24
-ioctl(3, SG_GET_RESERVED_SIZE, 0xaf8d93b4) = 0
-ioctl(3, SG_GET_RESERVED_SIZE, 0xaf8d93b8) = 0
-ioctl(3, SG_GET_PACK_ID, 0xaf8d93b0) = -1 ENOTTY (Inappropriate ioctl for device)
-brk(0x9520000)              = 0x9520000
-ioctl(3, SG_EMULATED_HOST, 0xaf8d93ec) = 0
+ioctl(3, SG_GET_RESERVED_SIZE, 0xafa1a4f4) = 0
+ioctl(3, SG_GET_RESERVED_SIZE, 0xafa1a4f8) = 0
+ioctl(3, SG_GET_PACK_ID, 0xafa1a4f0) = -1 ENOTTY (Inappropriate ioctl for device)
+brk(0x9fa8000)              = 0x9fa8000
+ioctl(3, SG_EMULATED_HOST, 0xafa1a52c) = 0
 
HERE

write(1, "atapi: 1\n", 9)   = 9
 ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[00, 00, 00, 00, 00, 00], mx_sb_len=16, iovec_count=0, dxfer_len=0, timeout=200000, flags=0x1, status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
 ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[00, 00, 00, 00, 00, 00], mx_sb_len=16, iovec_count=0, dxfer_len=0, timeout=200000, flags=0x1, status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
-ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[6]=[12, 00, 00, 00, 24, 00], mx_sb_len=16, iovec_count=0, dxfer_len=36, timeout=200000, flags=0x1, data[36]=["\5\200\0052[\0\0\0BENQ    DVD DD DW1625   "...], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
+ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[6]=[12, 00, 00, 00, 24, 00], mx_sb_len=16, iovec_count=0, dxfer_len=36, timeout=200000, flags=0x1, data[36]=["\5\200\0052[\0\0\0BENQ    DVD DD DW1625   "...], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=36, duration=2, info=0}) = 0
 ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[00, 00, 00, 00, 00, 00], mx_sb_len=16, iovec_count=0, dxfer_len=0, timeout=200000, flags=0x1, status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
-ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[5a, 00, 3f, 00, 00, 00, 00, 00, 08, 00], mx_sb_len=16, iovec_count=0, dxfer_len=8, timeout=200000, flags=0x1, data[8]=["\1\36\21\0\0\0\0\0"], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=6, info=0}) = 0
+ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[5a, 00, 3f, 00, 00, 00, 00, 00, 08, 00], mx_sb_len=16, iovec_count=0, dxfer_len=8, timeout=200000, flags=0x1, data[8]=["\1\36\21\0\0\0\0\0"], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=8, duration=4, info=0}) = 0
 ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[00, 00, 00, 00, 00, 00], mx_sb_len=16, iovec_count=0, dxfer_len=0, timeout=200000, flags=0x1, status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
-ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[5a, 00, 2a, 00, 00, 00, 00, 00, 02, 00], mx_sb_len=16, iovec_count=0, dxfer_len=2, timeout=200000, flags=0x1, data[2]=["\0>"], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=2, info=0}) = 0
+ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[5a, 00, 2a, 00, 00, 00, 00, 00, 02, 00], mx_sb_len=16, iovec_count=0, dxfer_len=2, timeout=200000, flags=0x1, data[2]=["\0>"], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=2, duration=3, info=0}) = 0
-ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[00, 00, 00, 00, 00, 00], mx_sb_len=16, iovec_count=0, dxfer_len=0, timeout=200000, flags=0x1, status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
+ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[00, 00, 00, 00, 00, 00], mx_sb_len=16, iovec_count=0, dxfer_len=0, timeout=200000, flags=0x1, status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=2, info=0}) = 0
-ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[5a, 00, 2a, 00, 00, 00, 00, 00, 40, 00], mx_sb_len=16, iovec_count=0, dxfer_len=64, timeout=200000, flags=0x1, data[64]=["\0>\21\0\0\0\0\0*6\37\27\365g) \33\220\0\2\10\0\33\220\0\0\33\220\33\220\0\1"...], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=3, info=0}) = 0
+ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[5a, 00, 2a, 00, 00, 00, 00, 00, 40, 00], mx_sb_len=16, iovec_count=0, dxfer_len=64, timeout=200000, flags=0x1, data[64]=["\0>\21\0\0\0\0\0*6\37\27\365g) \33\220\0\2\10\0\33\220\0\0\33\220\33\220\0\1"...], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=64, duration=3, info=0}) = 0
-ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[00, 00, 00, 00, 00, 00], mx_sb_len=16, iovec_count=0, dxfer_len=0, timeout=200000, flags=0x1, status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
+ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[00, 00, 00, 00, 00, 00], mx_sb_len=16, iovec_count=0, dxfer_len=0, timeout=200000, flags=0x1, status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
-ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[5a, 00, 2a, 00, 00, 00, 00, 00, 40, 00], mx_sb_len=16, iovec_count=0, dxfer_len=64, timeout=200000, flags=0x1, data[64]=["\0>\21\0\0\0\0\0*6\37\27\365g) \33\220\0\2\10\0\33\220\0\0\33\220\33\220\0\1"...], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=3, info=0}) = 0
+ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[5a, 00, 2a, 00, 00, 00, 00, 00, 0a, 00], mx_sb_len=16, iovec_count=0, dxfer_len=10, timeout=200000, flags=0x1, data[10]=["\0>\21\0\0\0\0\0*6"], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=10, duration=3, info=0}) = 0
-ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[00, 00, 00, 00, 00, 00], mx_sb_len=16, iovec_count=0, dxfer_len=0, timeout=200000, flags=0x1, status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
+ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[00, 00, 00, 00, 00, 00], mx_sb_len=16, iovec_count=0, dxfer_len=0, timeout=200000, flags=0x1, status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=0, info=0}) = 0
-
-write(1, "Device type    : Removable CD-RO"..., 34) = 34
-write(1, "Version        : 5\n", 19) = 19
-write(1, "Response Format: 2\n", 19) = 19
-write(1, "Capabilities   : \n", 18) = 18
-write(1, "Vendor_info    : \'BENQ    \'\n", 28) = 28
-write(1, "Identifikation : \'DVD DD DW1625 "..., 36) = 36
-write(1, "Revision       : \'BBIA\'\n", 24) = 24
-write(1, "Device seems to be: Generic mmc2"..., 55) = 55
+ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[5a, 00, 2a, 00, 00, 00, 00, 00, 40, 00], mx_sb_len=16, iovec_count=0, dxfer_len=64, timeout=200000, flags=0x1, data[64]=["\0>\21\0\0\0\0\0*6\37\27\365g) \33\220\0\2\10\0\33\220\0\0\33\220\33\220\0\1"...], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=64, duration=3, info=0}) = 0
+write(2, "/usr/bin/cdrecord: Warning: cont"..., 80/usr/bin/cdrecord: Warning: controller returns zero sized CD capabilities page.
+) = 80
+write(2, "/usr/bin/cdrecord: Warning: cont"..., 91/usr/bin/cdrecord: Warning: controller returns wrong page 0 for CD capabilities page (2A).
+) = 91


--=-/4psmbZyY+3dhdEEmK44
Content-Disposition: attachment; filename=revert_add_raw_data_len.diff
Content-Type: text/x-patch; name=revert_add_raw_data_len.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/block/blk-core.c b/block/blk-core.c
index 775c851..c013ca2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -127,7 +127,6 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->nr_hw_segments = 0;
 	rq->ioprio = 0;
 	rq->special = NULL;
-	rq->raw_data_len = 0;
 	rq->buffer = NULL;
 	rq->tag = -1;
 	rq->errors = 0;
@@ -2016,7 +2015,6 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->buffer = bio_data(bio);
-	rq->raw_data_len = bio->bi_size;
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
diff --git a/block/blk-map.c b/block/blk-map.c
index 09f7fd0..bc5ce60 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -19,7 +19,6 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
-		rq->raw_data_len += bio->bi_size;
 		rq->data_len += bio->bi_size;
 	}
 	return 0;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7506c4f..a15d0ee 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -231,7 +231,6 @@ new_segment:
 			    ((unsigned long)q->dma_drain_buffer) &
 			    (PAGE_SIZE - 1));
 		nsegs++;
-		rq->data_len += q->dma_drain_size;
 	}
 
 	if (sg)
diff --git a/block/bsg.c b/block/bsg.c
index 7f3c095..8917c51 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -437,14 +437,14 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	}
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->raw_data_len;
-		hdr->din_resid = rq->next_rq->raw_data_len;
+		hdr->dout_resid = rq->data_len;
+		hdr->din_resid = rq->next_rq->data_len;
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->raw_data_len;
+		hdr->din_resid = rq->data_len;
 	else
-		hdr->dout_resid = rq->raw_data_len;
+		hdr->dout_resid = rq->data_len;
 
 	/*
 	 * If the request generated a negative error number, return it
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index e993cac..9675b34 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -266,7 +266,7 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->raw_data_len;
+	hdr->resid = rq->data_len;
 	hdr->sb_len_wr = 0;
 
 	if (rq->sense_len && hdr->sbp) {
@@ -528,7 +528,6 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->data = NULL;
-	rq->raw_data_len = 0;
 	rq->data_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f888bab..a3baf69 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2539,7 +2539,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	 * want to set it properly, and for DMA where it is
 	 * effectively meaningless.
 	 */
-	nbytes = min(scmd->request->raw_data_len, (unsigned int)63 * 1024);
+	nbytes = min(qc->nbytes, (unsigned int)63 * 1024);
 
 	/* Most ATAPI devices which honor transfer chunk size don't
 	 * behave according to the spec when odd chunk size which
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6fe67d1..094eba2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -216,7 +216,6 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	unsigned int raw_data_len;
 	unsigned int data_len;
 	unsigned int sense_len;
 	void *data;

--=-/4psmbZyY+3dhdEEmK44--

