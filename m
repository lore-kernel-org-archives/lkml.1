Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbYKZVQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbYKZVQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYKZVQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:16:41 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:64115 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYKZVQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:16:40 -0500
Date: Wed, 26 Nov 2008 13:15:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: jens.axboe@oracle.com, akpm <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH -next] virtio_blk: fix type warning
Message-Id: <20081126131550.69eea284.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.492DBC89.00A8:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix parameter type warning:

linux-next-20081126/drivers/block/virtio_blk.c:307: warning: large integer implicitly truncated to unsigned type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/virtio_blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20081126.orig/drivers/block/virtio_blk.c
+++ linux-next-20081126/drivers/block/virtio_blk.c
@@ -304,7 +304,7 @@ static int virtblk_probe(struct virtio_d
 	if (!err)
 		blk_queue_max_segment_size(vblk->disk->queue, v);
 	else
-		blk_queue_max_segment_size(vblk->disk->queue, -1UL);
+		blk_queue_max_segment_size(vblk->disk->queue, -1U);
 
 	/* Host can optionally specify the block size of the device */
 	err = virtio_config_val(vdev, VIRTIO_BLK_F_BLK_SIZE,
