Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbYERS4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbYERS4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759998AbYERSsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:23 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37519 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760574AbYERSsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:14 -0400
X-Sasl-enc: NeWtJOvBoA2orraTh2dZaTeAeRl/FmHfKhJTsavd4/J4 1211136492
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 12/15] rfkill: add type string helper
Date: Sun, 18 May 2008 15:48:02 -0300
Message-Id: <1211136485-19878-13-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will need access to the rfkill switch type in string format for more
than just sysfs.  Therefore, move it to a generic helper.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 251defe..4ed8d19 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -220,34 +220,31 @@ static ssize_t rfkill_name_show(struct device *dev,
 	return sprintf(buf, "%s\n", rfkill->name);
 }
 
-static ssize_t rfkill_type_show(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
+static const char const *rfkill_get_type_str(enum rfkill_type type)
 {
-	struct rfkill *rfkill = to_rfkill(dev);
-	const char *type;
-
-	switch (rfkill->type) {
+	switch (type) {
 	case RFKILL_TYPE_WLAN:
-		type = "wlan";
-		break;
+		return "wlan";
 	case RFKILL_TYPE_BLUETOOTH:
-		type = "bluetooth";
-		break;
+		return "bluetooth";
 	case RFKILL_TYPE_UWB:
-		type = "ultrawideband";
-		break;
+		return "ultrawideband";
 	case RFKILL_TYPE_WIMAX:
-		type = "wimax";
-		break;
+		return "wimax";
 	case RFKILL_TYPE_WWAN:
-		type = "wwan";
-		break;
+		return "wwan";
 	default:
 		BUG();
 	}
+}
+
+static ssize_t rfkill_type_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%s\n", type);
+	return sprintf(buf, "%s\n", rfkill_get_type_str(rfkill->type));
 }
 
 static ssize_t rfkill_state_show(struct device *dev,
-- 
1.5.5.1

