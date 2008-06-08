Return-Path: <linux-kernel-owner+w=401wt.eu-S1765435AbYFHM7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765435AbYFHM7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 08:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762132AbYFHM6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 08:58:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42924 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758305AbYFHM6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 08:58:52 -0400
Date: Sun, 8 Jun 2008 14:58:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/input/tablet/gtco.c: eliminate early return
Message-ID: <Pine.LNX.4.64.0806081458190.10294@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There seems to be no reason why this error case should do less cleaning up
than the other adjacent ones, so the goto, which is currently dead code,
seems to be what is intended.


Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -863,7 +863,7 @@ static int gtco_probe(struct usb_interfa
 	gtco->urbinfo = usb_alloc_urb(0, GFP_KERNEL);
 	if (!gtco->urbinfo) {
 		err("Failed to allocate URB");
-		return -ENOMEM;
+		error = -ENOMEM;
 		goto err_free_buf;
 	}
 
