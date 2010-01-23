Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249Ab0AWA1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0AWA1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925Ab0AWASr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:18:47 -0500
Received: from kroah.org ([198.145.64.141]:35000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab0AWASk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:10 2010
Message-Id: <20100123001110.490750780@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:09:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean-Francois Moine <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [02/29] V4L/DVB (13900): gspca - sunplus: Fix bridge exchanges.
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean-Francois Moine <moinejf@free.fr>

commit 07d1c69b2dcfdd1b21e36af0ff8b9506234908ee upstream.

A previous code optimization inverted bridge registers and values,
doing a regression in kernel  2.6.32.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/sunplus.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/media/video/gspca/sunplus.c
+++ b/drivers/media/video/gspca/sunplus.c
@@ -705,7 +705,7 @@ static void spca504B_SetSizeType(struct 
 		rc = spca504B_PollingDataReady(gspca_dev);
 
 		/* Init the cam width height with some values get on init ? */
-		reg_w_riv(dev, 0x31, 0, 0x04);
+		reg_w_riv(dev, 0x31, 0x04, 0);
 		spca504B_WaitCmdStatus(gspca_dev);
 		rc = spca504B_PollingDataReady(gspca_dev);
 		break;
@@ -807,14 +807,14 @@ static void init_ctl_reg(struct gspca_de
 	default:
 /*	case BRIDGE_SPCA533: */
 /*	case BRIDGE_SPCA504B: */
-		reg_w_riv(dev, 0, 0x00, 0x21ad);	/* hue */
-		reg_w_riv(dev, 0, 0x01, 0x21ac);	/* sat/hue */
-		reg_w_riv(dev, 0, 0x00, 0x21a3);	/* gamma */
+		reg_w_riv(dev, 0, 0x21ad, 0x00);	/* hue */
+		reg_w_riv(dev, 0, 0x21ac, 0x01);	/* sat/hue */
+		reg_w_riv(dev, 0, 0x21a3, 0x00);	/* gamma */
 		break;
 	case BRIDGE_SPCA536:
-		reg_w_riv(dev, 0, 0x40, 0x20f5);
-		reg_w_riv(dev, 0, 0x01, 0x20f4);
-		reg_w_riv(dev, 0, 0x00, 0x2089);
+		reg_w_riv(dev, 0, 0x20f5, 0x40);
+		reg_w_riv(dev, 0, 0x20f4, 0x01);
+		reg_w_riv(dev, 0, 0x2089, 0x00);
 		break;
 	}
 	if (pollreg)
@@ -888,11 +888,11 @@ static int sd_init(struct gspca_dev *gsp
 	switch (sd->bridge) {
 	case BRIDGE_SPCA504B:
 		reg_w_riv(dev, 0x1d, 0x00, 0);
-		reg_w_riv(dev, 0, 0x01, 0x2306);
-		reg_w_riv(dev, 0, 0x00, 0x0d04);
-		reg_w_riv(dev, 0, 0x00, 0x2000);
-		reg_w_riv(dev, 0, 0x13, 0x2301);
-		reg_w_riv(dev, 0, 0x00, 0x2306);
+		reg_w_riv(dev, 0, 0x2306, 0x01);
+		reg_w_riv(dev, 0, 0x0d04, 0x00);
+		reg_w_riv(dev, 0, 0x2000, 0x00);
+		reg_w_riv(dev, 0, 0x2301, 0x13);
+		reg_w_riv(dev, 0, 0x2306, 0x00);
 		/* fall thru */
 	case BRIDGE_SPCA533:
 		spca504B_PollingDataReady(gspca_dev);
@@ -1011,7 +1011,7 @@ static int sd_start(struct gspca_dev *gs
 			spca504B_WaitCmdStatus(gspca_dev);
 			break;
 		default:
-			reg_w_riv(dev, 0x31, 0, 0x04);
+			reg_w_riv(dev, 0x31, 0x04, 0);
 			spca504B_WaitCmdStatus(gspca_dev);
 			spca504B_PollingDataReady(gspca_dev);
 			break;


