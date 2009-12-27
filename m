Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbZL0V2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbZL0V2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZL0V2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:28:07 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60647 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbZL0V2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:28:03 -0500
Date: Sun, 27 Dec 2009 22:28:00 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] drivers/staging/tm6000: Correct NULL test
Message-ID: <Pine.LNX.4.64.0912272227450.20548@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Test the just-allocated value for NULL rather than some other value.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,y;
statement S;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
(
if ((x) == NULL) S
|
if (
-   y
+   x
       == NULL)
 S
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/tm6000/tm6000-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -642,7 +642,7 @@ static int tm6000_prepare_isoc(struct tm
 
 	dev->isoc_ctl.transfer_buffer = kmalloc(sizeof(void *)*num_bufs,
 				   GFP_KERNEL);
-	if (!dev->isoc_ctl.urb) {
+	if (!dev->isoc_ctl.transfer_buffer) {
 		tm6000_err("cannot allocate memory for usbtransfer\n");
 		kfree(dev->isoc_ctl.urb);
 		return -ENOMEM;
