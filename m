Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZERHjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZERHjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbZERHjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:39:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53570 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbZERHjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:39:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] virtio_blk: add missing __dev{init,exit} markings
Date: Mon, 18 May 2009 03:39:09 -0400
Message-Id: <1242632349-15894-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove member of the virtio_driver structure uses __devexit_p(), so
the remove function itself should be marked with __devexit.  And where
there be __devexit on the remove, so is there __devinit on the probe.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
note: i dont actually know anything about virtio_blk, so this isnt
tested in any way.  simply noticed the hotplug discrepancies.

 drivers/block/virtio_blk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 5d34764..bc4fabf 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -190,7 +190,7 @@ static int index_to_minor(int index)
 	return index << PART_BITS;
 }
 
-static int virtblk_probe(struct virtio_device *vdev)
+static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
 	int err;
@@ -330,7 +330,7 @@ out:
 	return err;
 }
 
-static void virtblk_remove(struct virtio_device *vdev)
+static void __devexit virtblk_remove(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 
-- 
1.6.3

