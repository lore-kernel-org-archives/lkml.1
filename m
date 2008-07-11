Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYGKNve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYGKNve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbYGKNsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:03 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34981 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759384AbYGKNry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:54 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 19/30] W1: ds2490.c correct print message
Date: Fri, 11 Jul 2008 17:51:34 +0400
Message-Id: <12157843062647-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
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

