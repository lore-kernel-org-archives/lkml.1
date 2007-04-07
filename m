Return-Path: <linux-kernel-owner+w=401wt.eu-S966079AbXDGQXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966079AbXDGQXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966083AbXDGQXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:23:53 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:33345 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966079AbXDGQXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:23:52 -0400
Date: Sat, 7 Apr 2007 12:23:49 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: axboe@kernel.dk
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block layer: Add bdev capacity helper function
 get_sect_count
Message-ID: <alpine.DEB.0.83.0704071209070.15343@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Add static inline function get_sect_count to include/linux/genhd.h to 
complement get_start_sect. Returns sector_t capacity of block device 
whether it is whole or a partition.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

This will be useful for fill_super functions of filesystems with online 
resizing for checks against recorded and actual device size. 
get_start_sect and get_sect_count are helper functions useful to keep 
things from breaking in case the block_device structure decides to change.

Applied against Linux v2.6.20.6.

--- linux-2.6.20.6-orig/include/linux/genhd.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/include/linux/genhd.h	2007-04-07 11:58:55.000000000 -0400
@@ -244,6 +244,10 @@ static inline sector_t get_start_sect(st
 {
 	return bdev->bd_contains == bdev ? 0 : bdev->bd_part->start_sect;
 }
+static inline sector_t get_sect_count(struct block_device *bdev)
+{
+	return bdev->bd_contains == bdev ? bdev->bd_disk->capacity : bdev->bd_part->nr_sects;
+}
 static inline sector_t get_capacity(struct gendisk *disk)
 {
 	return disk->capacity;
