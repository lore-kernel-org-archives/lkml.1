Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbZBMOC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbZBMOC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbZBMOCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:02:37 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:54949 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZBMOCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:02:36 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 2/2] Staging: rtl8187se: fix build warnings
Date: Fri, 13 Feb 2009 08:35:13 -0500
Message-Id: <1234532113-14081-2-git-send-email-herton@mandriva.com.br>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/rtl8187se/r8180_wx.c:1386: warning: initialization from incompatible pointer type
drivers/staging/rtl8187se/r8180_wx.c:1388: warning: initialization from incompatible pointer type

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/staging/rtl8187se/r8180_wx.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 8b3901d..979ba0b 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -1274,8 +1274,8 @@ static int r8180_wx_set_enc_ext(struct net_device *dev,
 
 }
 static int r8180_wx_set_auth(struct net_device *dev,
-                                        struct iw_request_info *info,
-                                        struct iw_param *data, char *extra)
+			     struct iw_request_info *info,
+			     union iwreq_data *wrqu, char *extra)
 {
 	//printk("====>%s()\n", __func__);
 	struct r8180_priv *priv = ieee80211_priv(dev);
@@ -1285,7 +1285,7 @@ static int r8180_wx_set_auth(struct net_device *dev,
 		return 0;
 
 	down(&priv->wx_sem);
-	ret = ieee80211_wx_set_auth(priv->ieee80211, info, data, extra);
+	ret = ieee80211_wx_set_auth(priv->ieee80211, info, &wrqu->param, extra);
 	up(&priv->wx_sem);
 	return ret;
 }
@@ -1312,8 +1312,8 @@ static int r8180_wx_set_mlme(struct net_device *dev,
 	return ret;
 }
 static int r8180_wx_set_gen_ie(struct net_device *dev,
-                                        struct iw_request_info *info,
-                                        struct iw_point *data, char *extra)
+			       struct iw_request_info *info,
+			       union iwreq_data *wrqu, char *extra)
 {
 //	printk("====>%s(), len:%d\n", __func__, data->length);
 	int ret=0;
@@ -1325,7 +1325,7 @@ static int r8180_wx_set_gen_ie(struct net_device *dev,
 
         down(&priv->wx_sem);
 #if 1
-        ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, data->length);
+        ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, wrqu->data.length);
 #endif
         up(&priv->wx_sem);
 	//printk("<======%s(), ret:%d\n", __func__, ret);
-- 
1.6.1.3

