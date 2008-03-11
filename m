Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYCKMGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYCKMGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYCKMFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:05:51 -0400
Received: from ozlabs.org ([203.10.76.45]:55555 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbYCKMFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:05:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: [PATCH 2/4] virtio: Fix sysfs bits to have proper block symlink
Date: Tue, 11 Mar 2008 23:04:21 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Jeremy Katz <katzj@redhat.com>
References: <200803112303.22984.rusty@rustcorp.com.au>
In-Reply-To: <200803112303.22984.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112304.21680.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Katz <katzj@redhat.com>

Fix up so that the virtio_blk devices in sysfs link correctly to their
block device.  This then allows them to be detected by hal, etc

Signed-off-by: Jeremy Katz <katzj@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/virtio_blk.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 3b1a68d..0cfbe8c 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -238,6 +238,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	vblk->disk->first_minor = index_to_minor(index);
 	vblk->disk->private_data = vblk;
 	vblk->disk->fops = &virtblk_fops;
+	vblk->disk->driverfs_dev = &vdev->dev;
 	index++;
 
 	/* If barriers are supported, tell block layer that queue is ordered */
