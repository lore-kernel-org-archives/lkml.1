Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbZL1OMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbZL1OMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZL1OMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:12:17 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:35345 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZL1OMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:12:16 -0500
Date: Mon, 28 Dec 2009 15:09:55 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/media/video: Correct NULL test
Message-ID: <Pine.LNX.4.64.0912281509340.6928@ask.diku.dk>
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
@r@
identifier f;
@@

f(...) { <+... return NULL; ...+> }

@@
expression *x;
expression y;
identifier r.f;
statement S;
@@

x = f(...);
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
 drivers/media/video/usbvision/usbvision-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1487,7 +1487,7 @@ static int __devinit usbvision_register_
 		usbvision->vbi = usbvision_vdev_init(usbvision,
 						     &usbvision_vbi_template,
 						     "USBVision VBI");
-		if (usbvision->vdev == NULL) {
+		if (usbvision->vbi == NULL) {
 			goto err_exit;
 		}
 		if (video_register_device(usbvision->vbi,
