Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZLMLmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZLMLmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZLMLm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:42:29 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:39115 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752751AbZLMLm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:42:26 -0500
Date: Sun, 13 Dec 2009 12:42:24 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: david.vrabel@csr.com, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/9] drivers/usb: Correct code taking the size of a pointer
Message-ID: <Pine.LNX.4.64.0912131242080.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

sizeof(chid) is just the size of the pointer.  Change it to the size of the
referenced structure.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/wusbcore/mmc.c          |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/wusbcore/mmc.c b/drivers/usb/wusbcore/mmc.c
index 3b52161..2d82739 100644
--- a/drivers/usb/wusbcore/mmc.c
+++ b/drivers/usb/wusbcore/mmc.c
@@ -263,7 +263,7 @@ int wusbhc_chid_set(struct wusbhc *wusbhc, const struct wusb_ckhdid *chid)
 {
 	int result = 0;
 
-	if (memcmp(chid, &wusb_ckhdid_zero, sizeof(chid)) == 0)
+	if (memcmp(chid, &wusb_ckhdid_zero, sizeof(*chid)) == 0)
 		chid = NULL;
 
 	mutex_lock(&wusbhc->mutex);
