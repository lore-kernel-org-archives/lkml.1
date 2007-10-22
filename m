Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXJVCrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXJVCrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbXJVCr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:47:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47836 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754385AbXJVCr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:47:26 -0400
Date: Mon, 22 Oct 2007 04:47:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Krufky <mkrufky@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix CONFIG_TUNER_TEA5761=m
Message-ID: <20071022024755.GJ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes CONFIG_TUNER_TEA5761=m broken by
commit ca805d57cf5ea7482ed3da28653f30621249ee45.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/tuner-core.c |    6 ------
 1 file changed, 6 deletions(-)

26336c30e76c37bda368a24b8b12978388a18cf3 
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 9484308..1795b78 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -30,9 +30,7 @@
 
 /* standard i2c insmod options */
 static unsigned short normal_i2c[] = {
-#ifdef CONFIG_TUNER_TEA5761
 	0x10,
-#endif
 	0x42, 0x43, 0x4a, 0x4b,			/* tda8290 */
 	0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
 	0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f,
@@ -292,7 +290,6 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		}
 		t->mode_mask = T_RADIO;
 		break;
-#ifdef CONFIG_TUNER_TEA5761
 	case TUNER_TEA5761:
 		if (tea5761_attach(&t->fe, t->i2c.adapter, t->i2c.addr) == NULL) {
 			t->type = TUNER_ABSENT;
@@ -301,7 +298,6 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		}
 		t->mode_mask = T_RADIO;
 		break;
-#endif
 	case TUNER_PHILIPS_FMD1216ME_MK3:
 		buffer[0] = 0x0b;
 		buffer[1] = 0xdc;
@@ -594,7 +590,6 @@ static int tuner_attach(struct i2c_adapter *adap, int addr, int kind)
 	/* autodetection code based on the i2c addr */
 	if (!no_autodetect) {
 		switch (addr) {
-#ifdef CONFIG_TUNER_TEA5761
 		case 0x10:
 			if (tea5761_autodetection(t->i2c.adapter, t->i2c.addr) != EINVAL) {
 				t->type = TUNER_TEA5761;
@@ -606,7 +601,6 @@ static int tuner_attach(struct i2c_adapter *adap, int addr, int kind)
 				goto register_client;
 			}
 			break;
-#endif
 		case 0x42:
 		case 0x43:
 		case 0x4a:

