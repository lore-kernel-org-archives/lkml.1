Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYGUTfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYGUTfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbYGUTeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:34:00 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34181 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbYGUTd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:33:59 -0400
Date: Mon, 21 Jul 2008 22:33:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] media/video/gspca/: make functions static
Message-ID: <20080721193353.GG14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- gspca.c: get_isoc_ep()
- pac207.c: pac207_write_reg()
- pac207.c: pac207_read_reg()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/gspca/gspca.c  |    2 +-
 drivers/media/video/gspca/pac207.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

e8ca82cf2b769787da857de503ee07ef2cf44a7c 
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 16e367c..a7d0463 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -399,7 +399,7 @@ static struct usb_host_endpoint *alt_isoc(struct usb_host_interface *alt,
  * This routine may be called many times when the bandwidth is too small
  * (the bandwidth is checked on urb submit).
  */
-struct usb_host_endpoint *get_isoc_ep(struct gspca_dev *gspca_dev)
+static struct usb_host_endpoint *get_isoc_ep(struct gspca_dev *gspca_dev)
 {
 	struct usb_interface *intf;
 	struct usb_host_endpoint *ep;
diff --git a/drivers/media/video/gspca/pac207.c b/drivers/media/video/gspca/pac207.c
index fa7abc4..cb49502 100644
--- a/drivers/media/video/gspca/pac207.c
+++ b/drivers/media/video/gspca/pac207.c
@@ -208,7 +208,7 @@ static int pac207_write_regs(struct gspca_dev *gspca_dev, u16 index,
 }
 
 
-int pac207_write_reg(struct gspca_dev *gspca_dev, u16 index, u16 value)
+static int pac207_write_reg(struct gspca_dev *gspca_dev, u16 index, u16 value)
 {
 	struct usb_device *udev = gspca_dev->dev;
 	int err;
@@ -224,7 +224,7 @@ int pac207_write_reg(struct gspca_dev *gspca_dev, u16 index, u16 value)
 }
 
 
-int pac207_read_reg(struct gspca_dev *gspca_dev, u16 index)
+static int pac207_read_reg(struct gspca_dev *gspca_dev, u16 index)
 {
 	struct usb_device *udev = gspca_dev->dev;
 	int res;

