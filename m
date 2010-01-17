Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400Ab0AQXOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0AQXOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 18:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172Ab0AQXOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 18:14:09 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:25533 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0AQXOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 18:14:07 -0500
Date: Sun, 17 Jan 2010 15:13:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: [PATCH -next] staging/winbond: fix wbusb struct warnings/error
Message-Id: <20100117151350.073381bc.randy.dunlap@oracle.com>
In-Reply-To: <20100114172047.406ebda8.sfr@canb.auug.org.au>
References: <20100114172047.406ebda8.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B5399B2.00FB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix winbond wbusb warnings:

drivers/staging/winbond/wbusb.c:68: warning: 'struct ieee80211_if_init_conf' declared inside parameter list
drivers/staging/winbond/wbusb.c:68: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/staging/winbond/wbusb.c:72: error: dereferencing pointer to incomplete type
drivers/staging/winbond/wbusb.c:78: warning: 'struct ieee80211_if_init_conf' declared inside parameter list
drivers/staging/winbond/wbusb.c:284: warning: initialization from incompatible pointer type
drivers/staging/winbond/wbusb.c:285: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/winbond/wbusb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20100111.orig/drivers/staging/winbond/wbusb.c
+++ linux-next-20100111/drivers/staging/winbond/wbusb.c
@@ -65,17 +65,17 @@ static void hal_set_beacon_period(struct
 }
 
 static int wbsoft_add_interface(struct ieee80211_hw *dev,
-				struct ieee80211_if_init_conf *conf)
+				struct ieee80211_vif *conf)
 {
 	struct wbsoft_priv *priv = dev->priv;
 
-	hal_set_beacon_period(&priv->sHwData, conf->vif->bss_conf.beacon_int);
+	hal_set_beacon_period(&priv->sHwData, conf->>bss_conf.beacon_int);
 
 	return 0;
 }
 
 static void wbsoft_remove_interface(struct ieee80211_hw *dev,
-				    struct ieee80211_if_init_conf *conf)
+				    struct ieee80211_vif *conf)
 {
 	printk("wbsoft_remove interface called\n");
 }
