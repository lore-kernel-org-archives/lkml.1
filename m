Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYGaCzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYGaCzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbYGaCuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:50:13 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60578 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177AbYGaCuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:50:11 -0400
Date: Wed, 30 Jul 2008 21:49:54 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 19/30] W1: ds2490.c correct print message
Message-ID: <20080731024954.GT12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:49:55 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected print message, it was writing not reading, this also prints
the endpoint used for the write instead of hardcoding it.
        Failed to write 1-wire data to ep0x%x: err=%d.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index b63b5e0..c8365fb 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -341,7 +341,8 @@ static int ds_send_data(struct ds_device *dev, unsigned char *buf, int len)
 	count = 0;
 	err = usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, dev->ep[EP_DATA_OUT]), buf, len, &count, 1000);
 	if (err < 0) {
-		printk(KERN_ERR "Failed to read 1-wire data from 0x02: err=%d.\n", err);
+		printk(KERN_ERR "Failed to write 1-wire data to ep0x%x: "
+			"err=%d.\n", dev->ep[EP_DATA_OUT], err);
 		return err;
 	}
 
-- 
1.4.4.4
