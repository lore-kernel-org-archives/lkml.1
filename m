Return-Path: <linux-kernel-owner+w=401wt.eu-S936430AbYD1Pq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936430AbYD1Pq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964985AbYD1PkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:40:09 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49145 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935474AbYD1PkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:40:07 -0400
Date: Mon, 28 Apr 2008 18:39:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: isely@pobox.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] media/video/pvrusb2/: make code static
Message-ID: <20080428153934.GP2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code static:
- pvrusb2-devattr.c: struct pvr2_onair_creator_fe_props
- pvrusb2-devattr.c: struct pvr2_onair_usb2_fe_props
- pvrusb2-devattr.c: struct pvr2_73xxx_dvb_props
- pvrusb2-devattr.c: struct pvr2_750xx_dvb_props
- pvrusb2-devattr.c: struct pvr2_751xx_dvb_props
- pvrusb2-hdw.c:pvr2_led_ctrl_hauppauge()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/pvrusb2/pvrusb2-devattr.c |   10 +++++-----
 drivers/media/video/pvrusb2/pvrusb2-hdw.c     |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

1746583f68ca0d56bf5979151ab705deb59809b6 diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.c b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
index 3a141d9..9c670d7 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-devattr.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
@@ -183,7 +183,7 @@ static int pvr2_lgh06xf_attach(struct pvr2_dvb_adapter *adap)
 	return 0;
 }
 
-struct pvr2_dvb_props pvr2_onair_creator_fe_props = {
+static struct pvr2_dvb_props pvr2_onair_creator_fe_props = {
 	.frontend_attach = pvr2_lgdt3303_attach,
 	.tuner_attach    = pvr2_lgh06xf_attach,
 };
@@ -245,7 +245,7 @@ static int pvr2_fcv1236d_attach(struct pvr2_dvb_adapter *adap)
 	return 0;
 }
 
-struct pvr2_dvb_props pvr2_onair_usb2_fe_props = {
+static struct pvr2_dvb_props pvr2_onair_usb2_fe_props = {
 	.frontend_attach = pvr2_lgdt3302_attach,
 	.tuner_attach    = pvr2_fcv1236d_attach,
 };
@@ -319,7 +319,7 @@ static int pvr2_73xxx_tda18271_8295_attach(struct pvr2_dvb_adapter *adap)
 	return 0;
 }
 
-struct pvr2_dvb_props pvr2_73xxx_dvb_props = {
+static struct pvr2_dvb_props pvr2_73xxx_dvb_props = {
 	.frontend_attach = pvr2_tda10048_attach,
 	.tuner_attach    = pvr2_73xxx_tda18271_8295_attach,
 };
@@ -422,12 +422,12 @@ static int pvr2_tda18271_8295_attach(struct pvr2_dvb_adapter *adap)
 	return 0;
 }
 
-struct pvr2_dvb_props pvr2_750xx_dvb_props = {
+static struct pvr2_dvb_props pvr2_750xx_dvb_props = {
 	.frontend_attach = pvr2_s5h1409_attach,
 	.tuner_attach    = pvr2_tda18271_8295_attach,
 };
 
-struct pvr2_dvb_props pvr2_751xx_dvb_props = {
+static struct pvr2_dvb_props pvr2_751xx_dvb_props = {
 	.frontend_attach = pvr2_s5h1411_attach,
 	.tuner_attach    = pvr2_tda18271_8295_attach,
 };
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index 0a86888..37364b0 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -3421,7 +3421,7 @@ static void pvr2_hdw_cmd_modeswitch(struct pvr2_hdw *hdw,int digitalFl)
 }
 
 
-void pvr2_led_ctrl_hauppauge(struct pvr2_hdw *hdw, int onoff)
+static void pvr2_led_ctrl_hauppauge(struct pvr2_hdw *hdw, int onoff)
 {
 	/* change some GPIO data
 	 *


