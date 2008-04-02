Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbYDBSlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbYDBSlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758216AbYDBSft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:49 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38408 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757379AbYDBSfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 14 of 24] xen/blkfront: use bdget_disk
X-Mercurial-Node: 394741841688f1db2ab9cb7bae4994ee2da5bbb1
Message-Id: <394741841688f1db2ab9.1207158843@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

info->dev is never initialized to anything, so bdget(info->dev) is
meaningless.  Get rid of info->dev, and use bdget_disk on the gendisk.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 drivers/block/xen-blkfront.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -75,7 +75,6 @@
 struct blkfront_info
 {
 	struct xenbus_device *xbdev;
-	dev_t dev;
 	struct gendisk *gd;
 	int vdevice;
 	blkif_vdev_t handle;
@@ -903,7 +902,7 @@
 		break;
 
 	case XenbusStateClosing:
-		bd = bdget(info->dev);
+		bd = bdget_disk(info->gd, 0);
 		if (bd == NULL)
 			xenbus_dev_fatal(dev, -ENODEV, "bdget failed");
 


