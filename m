Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYIAI5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYIAI5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 04:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYIAI5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 04:57:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51410 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYIAI5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 04:57:32 -0400
From: Julien Brunel <brunel@diku.dk>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/usb/misc: Use an IS_ERR test rather than a NULL test
Date: Mon, 1 Sep 2008 10:57:27 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011057.28293.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Brunel <brunel@diku.dk>

In case of error, the function backlight_device_register returns an
ERR pointer, but never returns a NULL pointer. So a NULL test that may
come after a call to this function should be strengthened by an IS_ERR
test.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match_bad_null_test@
expression x, E;
statement S1,S2;
@@
x = backlight_device_register(...)
... when != x = E
* if (x != NULL) 
S1 else S2
// </smpl>

Signed-off-by:  Julien Brunel <brunel@diku.dk>
Signed-off-by:  Julia Lawall <julia@diku.dk>

---
 drivers/usb/misc/appledisplay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -314,7 +314,7 @@ error:
 					pdata->urbdata, pdata->urb->transfer_dma);
 			usb_free_urb(pdata->urb);
 		}
-		if (pdata->bd)
+		if (pdata->bd && !IS_ERR(pdata->bd))
 			backlight_device_unregister(pdata->bd);
 		kfree(pdata->msgdata);
 	}
