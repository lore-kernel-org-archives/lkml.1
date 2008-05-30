Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYE3X6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYE3X6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYE3X6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:58:35 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:37127
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbYE3X6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:58:34 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 19:58:34 EDT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 5] xen/blkfront: Make sure that the device is fully ready
	before allowing release
X-Mercurial-Node: 6f8184a546bd5f9be417f407e9d29f040eda4453
Message-Id: <6f8184a546bd5f9be417.1212191403@localhost>
In-Reply-To: <patchbomb.1212191400@localhost>
Date: Sat, 31 May 2008 00:50:03 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jeff Garzik <jgarzik.pobox.com@goop.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wim Colgate <wim@xensource.com>

[ linux-2.6.18-xen changeset c1c57fea77e9 ]

Signed-off-by: Wim Colgate <wim@xensource.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 drivers/block/xen-blkfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -997,7 +997,7 @@
 		struct xenbus_device *dev = info->xbdev;
 		enum xenbus_state state = xenbus_read_driver_state(dev->otherend);
 
-		if (state == XenbusStateClosing)
+		if (state == XenbusStateClosing && info->is_ready)
 			blkfront_closing(dev);
 	}
 	return 0;


