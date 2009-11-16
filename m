Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZKPESy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZKPESy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZKPESw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:18:52 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:64232 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbZKPESu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:18:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q2AVy0lOajUpmpnFIsZNjlewhrzNMokQoTsGuetMSb9wdHXFXK8zTEWaBrM1lifNCW
         ycYrfqSi1VbfvXyWCBJMuQn+5x8PIJ+7G3/S2m5DbI4TS8o3ly5e+cgXlsHMFC76jVip
         mL6IlptOaeVOF0rINJ5nX1sapDPAI5JMJAtxs=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 06/13] staging: line6: Fix some checkpatch warnings in control.c
Date: Sun, 15 Nov 2009 22:17:55 -0600
Message-Id: <1258345082-11811-7-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/control.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/line6/control.c b/drivers/staging/line6/control.c
index cfc6543..2d98935 100644
--- a/drivers/staging/line6/control.c
+++ b/drivers/staging/line6/control.c
@@ -22,18 +22,18 @@
 struct device_attribute dev_attr_##_name1 = __ATTR(_name2, _mode, _show, _store)
 
 #define LINE6_PARAM_R(PREFIX, prefix, type, param) \
-static ssize_t prefix ## _get_ ## param(struct device *dev, \
+static ssize_t prefix##_get_##param(struct device *dev, \
 			struct device_attribute *attr, char *buf) \
 { \
-	return prefix ## _get_param_ ## type(dev, buf, PREFIX ## _ ## param); \
+	return prefix##_get_param_##type(dev, buf, PREFIX##_##param); \
 }
 
 #define LINE6_PARAM_RW(PREFIX, prefix, type, param) \
 LINE6_PARAM_R(PREFIX, prefix, type, param); \
-static ssize_t prefix ## _set_ ## param(struct device *dev, \
+static ssize_t prefix##_set_##param(struct device *dev, \
 		struct device_attribute *attr, const char *buf, size_t count) \
 { \
-	return prefix ## _set_param_ ## type(dev, buf, count, PREFIX ## _ ## param); \
+	return prefix##_set_param_##type(dev, buf, count, PREFIX##_##param); \
 }
 
 #define POD_PARAM_R(type, param) LINE6_PARAM_R(POD, pod, type, param)
@@ -727,6 +727,7 @@ int pod_create_files(int firmware, int type, struct device *dev)
 				     (dev, &dev_attr_band_6_gain__bass));
 	return 0;
 }
+EXPORT_SYMBOL(pod_create_files);
 
 void pod_remove_files(int firmware, int type, struct device *dev)
 {
@@ -901,8 +902,6 @@ void pod_remove_files(int firmware, int type, struct device *dev)
 		if (firmware >= 200)
 			device_remove_file(dev, &dev_attr_band_6_gain__bass);
 }
-
-EXPORT_SYMBOL(pod_create_files);
 EXPORT_SYMBOL(pod_remove_files);
 
 int variax_create_files(int firmware, int type, struct device *dev)
@@ -949,6 +948,7 @@ int variax_create_files(int firmware, int type, struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup_wiring));
 	return 0;
 }
+EXPORT_SYMBOL(variax_create_files);
 
 void variax_remove_files(int firmware, int type, struct device *dev)
 {
@@ -992,6 +992,4 @@ void variax_remove_files(int firmware, int type, struct device *dev)
 	device_remove_file(dev, &dev_attr_mix1);
 	device_remove_file(dev, &dev_attr_pickup_wiring);
 }
-
-EXPORT_SYMBOL(variax_create_files);
 EXPORT_SYMBOL(variax_remove_files);
-- 
1.6.5

