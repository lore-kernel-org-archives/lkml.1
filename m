Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbYFPVqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbYFPVqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbYFPVpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:45:44 -0400
Received: from gw.goop.org ([64.81.55.164]:45418 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865AbYFPVpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:45:43 -0400
Message-ID: <4856DEDD.50306@goop.org>
Date: Mon, 16 Jun 2008 14:45:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wim Colgate <wim@xensource.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 3/5] xen/blkfront: Make sure that the device is fully ready
 before allowing release.
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

===================================================================
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


