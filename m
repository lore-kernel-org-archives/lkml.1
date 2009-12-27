Return-Path: <linux-kernel-owner+w=401wt.eu-S1751507AbZL0V1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbZL0V1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZL0V1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:27:19 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60621 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbZL0V1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:27:14 -0500
Date: Sun, 27 Dec 2009 22:27:11 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] drivers/block: Correct NULL test
Message-ID: <Pine.LNX.4.64.0912272226550.20548@ask.diku.dk>
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
 drivers/block/drbd/drbd_receiver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3944,7 +3944,7 @@ static int drbd_do_auth(struct drbd_conf
 	}
 
 	right_response = kmalloc(resp_size, GFP_NOIO);
-	if (response == NULL) {
+	if (right_response == NULL) {
 		dev_err(DEV, "kmalloc of right_response failed\n");
 		rv = 0;
 		goto fail;
