Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab0BDRXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:23:21 -0500
Received: from kroah.org ([198.145.64.141]:34984 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933384Ab0BDRWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:33 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:28 2010
Message-Id: <20100204171528.299088377@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Peter Osterlund <petero2@telia.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [71/74] pktcdvd: removing device does not remove its sysfs dir
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

commit ca0bf64d99f6e3f6e2fe2585e52a0ac57354beac upstream.

This is the counterpart to cba767175becadc5c4016cceb7bfdd2c7fe722f4
("pktcdvd: remove broken dev_t export of class devices").  Device is not
registered using dev_t, so it should not be destroyed using device_destroy
which looks up the device by dev_t.  This will fail and adding the device
again will fail with the "duplicate name" error.  This is fixed using
device_unregister instead of device_destroy.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/pktcdvd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -322,7 +322,7 @@ static void pkt_sysfs_dev_remove(struct
 	pkt_kobj_remove(pd->kobj_stat);
 	pkt_kobj_remove(pd->kobj_wqueue);
 	if (class_pktcdvd)
-		device_destroy(class_pktcdvd, pd->pkt_dev);
+		device_unregister(pd->dev);
 }
 
 


