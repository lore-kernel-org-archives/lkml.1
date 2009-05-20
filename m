Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbZETHRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbZETHRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZETHRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:17:17 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34756 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbZETHRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:17:16 -0400
Date: Wed, 20 May 2009 09:17:11 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, haas@ems-wuensche.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/staging/cpc-usb: Adjust NULL test
Message-ID: <Pine.LNX.4.64.0905200916280.12274@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Since card must already be non-NULL, it seems that what was intended
was to test the result of kmalloc.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E,E1;
identifier f,fld,fld1;
statement S1,S2;
@@

E->fld = f(...);
... when != E = E1
    when != E->fld1 = E1
if (
-   E
+   E->fld
           == NULL) S1 else S2
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/cpc-usb/cpc-usb_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/staging/cpc-usb/cpc-usb_drv.c b/drivers/staging/cpc-usb/cpc-usb_drv.c
--- a/drivers/staging/cpc-usb/cpc-usb_drv.c
+++ b/drivers/staging/cpc-usb/cpc-usb_drv.c
@@ -899,7 +899,7 @@ static int cpcusb_probe(struct usb_inter
 
 	/* allocate and initialize the channel struct */
 	card->chan = kmalloc(sizeof(CPC_CHAN_T), GFP_KERNEL);
-	if (!card) {
+	if (!card->chan) {
 		kfree(card);
 		err("Out of memory");
 		return -ENOMEM;
