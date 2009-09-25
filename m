Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZIYXJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZIYXJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 19:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZIYXJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 19:09:54 -0400
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:55027 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752690AbZIYXJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 19:09:53 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] fs/bio.c: move EXPORT* macros to line after function
Date: Fri, 25 Sep 2009 19:10:00 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901D4276C@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fs/bio.c: move EXPORT* macros to line after function
Thread-Index: Aco+NU5cSCWI9df5STytWgF4o9Z2rg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <jens.axboe@oracle.com>, <linux-fsdevel@vger.kernel.org>
X-OriginalArrivalTime: 25 Sep 2009 23:09:56.0244 (UTC) FILETIME=[4BFB7540:01CA3E35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in Documentation/CodingStyle, move EXPORT* macro's
to the line immediately after the closing function brace line.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jens Axboe <jens.axboe@oracle.com>

---

diff --git a/fs/bio.c b/fs/bio.c
index 7673800..402cb84 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -249,6 +249,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 
 	mempool_free(p, bs->bio_pool);
 }
+EXPORT_SYMBOL(bio_free);
 
 void bio_init(struct bio *bio)
 {
@@ -257,6 +258,7 @@ void bio_init(struct bio *bio)
 	bio->bi_comp_cpu = -1;
 	atomic_set(&bio->bi_cnt, 1);
 }
+EXPORT_SYMBOL(bio_init);
 
 /**
  * bio_alloc_bioset - allocate a bio for I/O
@@ -311,6 +313,7 @@ err_free:
 	mempool_free(p, bs->bio_pool);
 	return NULL;
 }
+EXPORT_SYMBOL(bio_alloc_bioset);
 
 static void bio_fs_destructor(struct bio *bio)
 {
@@ -337,6 +340,7 @@ struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
 
 	return bio;
 }
+EXPORT_SYMBOL(bio_alloc);
 
 static void bio_kmalloc_destructor(struct bio *bio)
 {
@@ -380,6 +384,7 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs)
 
 	return bio;
 }
+EXPORT_SYMBOL(bio_kmalloc);
 
 void zero_fill_bio(struct bio *bio)
 {
@@ -416,6 +421,7 @@ void bio_put(struct bio *bio)
 		bio->bi_destructor(bio);
 	}
 }
+EXPORT_SYMBOL(bio_put);
 
 inline int bio_phys_segments(struct request_queue *q, struct bio *bio)
 {
@@ -424,6 +430,7 @@ inline int bio_phys_segments(struct request_queue *q, struct bio *bio)
 
 	return bio->bi_phys_segments;
 }
+EXPORT_SYMBOL(bio_phys_segments);
 
 /**
  * 	__bio_clone	-	clone a bio
@@ -451,6 +458,7 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	bio->bi_size = bio_src->bi_size;
 	bio->bi_idx = bio_src->bi_idx;
 }
+EXPORT_SYMBOL(__bio_clone);
 
 /**
  *	bio_clone	-	clone a bio
@@ -482,6 +490,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 
 	return b;
 }
+EXPORT_SYMBOL(bio_clone);
 
 /**
  *	bio_get_nr_vecs		- return approx number of vecs
@@ -505,6 +514,7 @@ int bio_get_nr_vecs(struct block_device *bdev)
 
 	return nr_pages;
 }
+EXPORT_SYMBOL(bio_get_nr_vecs);
 
 static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 			  *page, unsigned int len, unsigned int offset,
@@ -635,6 +645,7 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
 	return __bio_add_page(q, bio, page, len, offset,
 			      queue_max_hw_sectors(q));
 }
+EXPORT_SYMBOL(bio_add_pc_page);
 
 /**
  *	bio_add_page	-	attempt to add page to bio
@@ -655,6 +666,7 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	return __bio_add_page(q, bio, page, len, offset, queue_max_sectors(q));
 }
+EXPORT_SYMBOL(bio_add_page);
 
 struct bio_map_data {
 	struct bio_vec *iovecs;
@@ -776,6 +788,7 @@ int bio_uncopy_user(struct bio *bio)
 	bio_put(bio);
 	return ret;
 }
+EXPORT_SYMBOL(bio_uncopy_user);
 
 /**
  *	bio_copy_user_iov	-	copy user data to bio
@@ -920,6 +933,7 @@ struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
 
 	return bio_copy_user_iov(q, map_data, &iov, 1, write_to_vm, gfp_mask);
 }
+EXPORT_SYMBOL(bio_copy_user);
 
 static struct bio *__bio_map_user_iov(struct request_queue *q,
 				      struct block_device *bdev,
@@ -1050,6 +1064,7 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
 
 	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm, gfp_mask);
 }
+EXPORT_SYMBOL(bio_map_user);
 
 /**
  *	bio_map_user_iov - map user sg_iovec table into bio
@@ -1117,13 +1132,13 @@ void bio_unmap_user(struct bio *bio)
 	__bio_unmap_user(bio);
 	bio_put(bio);
 }
+EXPORT_SYMBOL(bio_unmap_user);
 
 static void bio_map_kern_endio(struct bio *bio, int err)
 {
 	bio_put(bio);
 }
 
-
 static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 				  unsigned int len, gfp_t gfp_mask)
 {
@@ -1189,6 +1204,7 @@ struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 	bio_put(bio);
 	return ERR_PTR(-EINVAL);
 }
+EXPORT_SYMBOL(bio_map_kern);
 
 static void bio_copy_kern_endio(struct bio *bio, int err)
 {
@@ -1250,6 +1266,7 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 
 	return bio;
 }
+EXPORT_SYMBOL(bio_copy_kern);
 
 /*
  * bio_set_pages_dirty() and bio_check_pages_dirty() are support functions
@@ -1400,6 +1417,7 @@ void bio_endio(struct bio *bio, int error)
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
+EXPORT_SYMBOL(bio_endio);
 
 void bio_pair_release(struct bio_pair *bp)
 {
@@ -1410,6 +1428,7 @@ void bio_pair_release(struct bio_pair *bp)
 		mempool_free(bp, bp->bio2.bi_private);
 	}
 }
+EXPORT_SYMBOL(bio_pair_release);
 
 static void bio_pair_end_1(struct bio *bi, int err)
 {
@@ -1477,6 +1496,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 
 	return bp;
 }
+EXPORT_SYMBOL(bio_split);
 
 /**
  *      bio_sector_offset - Find hardware sector offset in bio
@@ -1547,6 +1567,7 @@ void bioset_free(struct bio_set *bs)
 
 	kfree(bs);
 }
+EXPORT_SYMBOL(bioset_free);
 
 /**
  * bioset_create  - Create a bio_set
@@ -1592,6 +1613,7 @@ bad:
 	bioset_free(bs);
 	return NULL;
 }
+EXPORT_SYMBOL(bioset_create);
 
 static void __init biovec_init_slabs(void)
 {
@@ -1636,29 +1658,4 @@ static int __init init_bio(void)
 
 	return 0;
 }
-
 subsys_initcall(init_bio);
-
-EXPORT_SYMBOL(bio_alloc);
-EXPORT_SYMBOL(bio_kmalloc);
-EXPORT_SYMBOL(bio_put);
-EXPORT_SYMBOL(bio_free);
-EXPORT_SYMBOL(bio_endio);
-EXPORT_SYMBOL(bio_init);
-EXPORT_SYMBOL(__bio_clone);
-EXPORT_SYMBOL(bio_clone);
-EXPORT_SYMBOL(bio_phys_segments);
-EXPORT_SYMBOL(bio_add_page);
-EXPORT_SYMBOL(bio_add_pc_page);
-EXPORT_SYMBOL(bio_get_nr_vecs);
-EXPORT_SYMBOL(bio_map_user);
-EXPORT_SYMBOL(bio_unmap_user);
-EXPORT_SYMBOL(bio_map_kern);
-EXPORT_SYMBOL(bio_copy_kern);
-EXPORT_SYMBOL(bio_pair_release);
-EXPORT_SYMBOL(bio_split);
-EXPORT_SYMBOL(bio_copy_user);
-EXPORT_SYMBOL(bio_uncopy_user);
-EXPORT_SYMBOL(bioset_create);
-EXPORT_SYMBOL(bioset_free);
-EXPORT_SYMBOL(bio_alloc_bioset); 
