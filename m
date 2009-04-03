Return-Path: <linux-kernel-owner+w=401wt.eu-S934849AbZDCPsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934849AbZDCPsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934504AbZDCPrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:47:05 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:20855 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZDCPrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:47:01 -0400
Date: Fri, 3 Apr 2009 17:46:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8187se: Use to_delayed_work
Message-ID: <20090403174649.42626ae6@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the recently added to_delayed_work() helper function.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/staging/rtl8187se/r8180_dm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.30-rc0.orig/drivers/staging/rtl8187se/r8180_dm.c	2009-04-03 17:19:23.000000000 +0200
+++ linux-2.6.30-rc0/drivers/staging/rtl8187se/r8180_dm.c	2009-04-03 17:40:32.000000000 +0200
@@ -132,7 +132,7 @@ void rtl8180_tx_pw_wq (struct work_struc
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
-        struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+	struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,tx_pw_wq);
         struct net_device *dev = ieee->dev;
 #else
@@ -314,7 +314,7 @@ void rtl8180_hw_dig_wq (struct work_stru
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
-        struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+	struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_dig_wq);
         struct net_device *dev = ieee->dev;
 #else
@@ -1250,7 +1250,7 @@ SetInitialGain:
 #if LINUX_VERSION_CODE >=KERNEL_VERSION(2,6,20)
 void rtl8180_rate_adapter(struct work_struct * work)
 {
-	struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+	struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,rate_adapter_wq);
         struct net_device *dev = ieee->dev;
 #else


-- 
Jean Delvare
