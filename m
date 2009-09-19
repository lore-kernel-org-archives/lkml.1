Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZISHNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZISHNp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZISHNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:13:42 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60392 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZISHNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:13:42 -0400
Date: Sat, 19 Sep 2009 09:13:43 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/usb: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0909190913050.21312@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Correct priority problem in the use of ! and &.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ expression E; constant C; @@
- !E & C
+ !(E & C)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/usb-skeleton.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -358,7 +358,7 @@ retry:
 		rv = skel_do_read_io(dev, count);
 		if (rv < 0)
 			goto exit;
-		else if (!file->f_flags & O_NONBLOCK)
+		else if (!(file->f_flags & O_NONBLOCK))
 			goto retry;
 		rv = -EAGAIN;
 	}
@@ -411,7 +411,7 @@ static ssize_t skel_write(struct file *f
 	 * limit the number of URBs in flight to stop a user from using up all
 	 * RAM
 	 */
-	if (!file->f_flags & O_NONBLOCK) {
+	if (!(file->f_flags & O_NONBLOCK)) {
 		if (down_interruptible(&dev->limit_sem)) {
 			retval = -ERESTARTSYS;
 			goto exit;
