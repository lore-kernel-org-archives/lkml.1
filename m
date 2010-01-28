Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841Ab0A1PqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab0A1PqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800Ab0A1PqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:46:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:61828 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab0A1PqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:46:19 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] Set block size to PAGE_SIZE
Date: Thu, 28 Jan 2010 21:13:39 +0530
Message-Id: <1264693423-2694-4-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
References: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ramzswap block size needs to be set equal to PAGE_SIZE to
avoid receiving any unaligned block I/O requests (happens
due to readahead logic during swapon). These unaligned
accesses produce unnecessary I/O errors, scaring users.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index 3567ee3..2021ad6 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -1335,6 +1335,10 @@ static int create_device(struct ramzswap *rzs, int device_id)
 	 * or set equal to backing swap device (if provided)
 	 */
 	set_capacity(rzs->disk, 0);
+
+	blk_queue_physical_block_size(rzs->disk->queue, PAGE_SIZE);
+	blk_queue_logical_block_size(rzs->disk->queue, PAGE_SIZE);
+
 	add_disk(rzs->disk);
 
 	rzs->init_done = 0;
-- 
1.6.2.5

