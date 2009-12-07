Return-Path: <linux-kernel-owner+w=401wt.eu-S934419AbZLGA0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419AbZLGA0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbZLGA0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:26:33 -0500
Received: from kroah.org ([198.145.64.141]:34476 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758515AbZLGANS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:18 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:51 2009
Message-Id: <20091207000650.986021785@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Lowery <rglowery@exemail.com.au>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [061/119] V4L/DVB (13436): cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13436-cxusb-fix-hang-on-dvico-fusionhdtv-dvb-t-dual-digital-4-rev-1.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Robert Lowery <rglowery@exemail.com.au>

commit 0bc3518019f917a370935055f07698a4e9b3ea20 upstream.

Address yet another regression introduced by the introduction of the zl10353
disable_i2c_gate field.

djh - I unmangled the patch which apparently got screwed up in the user's
email client.

Signed-off-by: Robert Lowery <rglowery@exemail.com.au>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-usb/cxusb.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -663,6 +663,14 @@ static struct zl10353_config cxusb_zl103
 	.parallel_ts = 1,
 };
 
+static struct zl10353_config cxusb_zl10353_xc3028_config_no_i2c_gate = {
+	.demod_address = 0x0f,
+	.if2 = 45600,
+	.no_tuner = 1,
+	.parallel_ts = 1,
+	.disable_i2c_gate_ctrl = 1,
+};
+
 static struct mt352_config cxusb_mt352_xc3028_config = {
 	.demod_address = 0x0f,
 	.if2 = 4560,
@@ -894,7 +902,7 @@ static int cxusb_dualdig4_frontend_attac
 	cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
 
 	if ((adap->fe = dvb_attach(zl10353_attach,
-				   &cxusb_zl10353_xc3028_config,
+				   &cxusb_zl10353_xc3028_config_no_i2c_gate,
 				   &adap->dev->i2c_adap)) == NULL)
 		return -EIO;
 


