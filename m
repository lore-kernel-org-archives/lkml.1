Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXKERLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXKERLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757416AbXKERHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:12 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59492 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754687AbXKERHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:07:11 -0500
Date: Mon, 5 Nov 2007 18:06:47 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb-usb/vp702x.c: cleanups
Message-ID: <20071105170647.GE12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the needlessly global vp702x_usb_out_op() static
- #if 0 the unused vp702x_power_ctrl()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/dvb/dvb-usb/vp702x.c |    4 +++-
 drivers/media/dvb/dvb-usb/vp702x.h |    2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

6fa11043546466fd262adfcc9a6ba9ed7bd06ba2 
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 16533b3..c11d993 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -56,7 +56,7 @@ int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
 	return ret;
 }
 
-int vp702x_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
+static int vp702x_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 			     u16 index, u8 *b, int blen)
 {
 	int ret;
@@ -204,6 +204,7 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	return 0;
 }
 
+#if 0
 int vp702x_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	struct vp702x_device_state *st = d->priv;
@@ -217,6 +218,7 @@ int vp702x_power_ctrl(struct dvb_usb_device *d, int onoff)
 
 	return 0;
 }
+#endif  /*  0  */
 
 static int vp702x_read_mac_addr(struct dvb_usb_device *d,u8 mac[6])
 {
diff --git a/drivers/media/dvb/dvb-usb/vp702x.h b/drivers/media/dvb/dvb-usb/vp702x.h
index 25a9dee..c2f97f9 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.h
+++ b/drivers/media/dvb/dvb-usb/vp702x.h
@@ -102,7 +102,5 @@ extern struct dvb_frontend * vp702x_fe_attach(struct dvb_usb_device *d);
 
 extern int vp702x_usb_inout_op(struct dvb_usb_device *d, u8 *o, int olen, u8 *i, int ilen, int msec);
 extern int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen);
-extern int vp702x_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen);
-extern int vp702x_power_ctrl(struct dvb_usb_device *d, int onoff);
 
 #endif

