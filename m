Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbXDASUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbXDASUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbXDASUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:20:00 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:41246 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933816AbXDASTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:19:43 -0400
Date: Sun, 1 Apr 2007 20:18:12 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Jouni Malinen <jkmaline@cc.hut.fi>, Jeroen Vreeken <pe1rxq@amsat.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH 15/16] use-regular-eth-suffix.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012010530.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Some radio adapter drivers wrongly(?) name their devices "wlan%d"
instead of "eth%d" (if you ask me, it should be %u - but not today).

Technically, they operate like Ethernet, and in fact, running
`/sbin/ip a` shows "link/ether" instead of "link/ieee80211".
This patch renames them back, but I would appreciate some comment,
explanation or at least link why they actually have wlan%d there.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Jouni Malinen <jkmaline@cc.hut.fi> (hostap)
Cc: Jeroen Vreeken <pe1rxq@amsat.org> (zd1201)

 hostap/hostap_hw.c |    4 ++--
 zd1201.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc5/drivers/net/wireless/hostap/hostap_hw.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/net/wireless/hostap/hostap_hw.c
+++ linux-2.6.21-rc5/drivers/net/wireless/hostap/hostap_hw.c
@@ -81,10 +81,10 @@ static int dtim_period[MAX_PARM_DEVICES]
 module_param_array(dtim_period, int, NULL, 0444);
 MODULE_PARM_DESC(dtim_period, "DTIM period");
 
-static char dev_template[16] = "wlan%d";
+static char dev_template[16] = "eth%d";
 module_param_string(dev_template, dev_template, sizeof(dev_template), 0444);
 MODULE_PARM_DESC(dev_template, "Prefix for network device name (default: "
-		 "wlan%d)");
+		 "eth%d)");
 
 #ifdef final_version
 #define EXTRA_EVENTS_WTERR 0
Index: linux-2.6.21-rc5/drivers/net/wireless/zd1201.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/net/wireless/zd1201.c
+++ linux-2.6.21-rc5/drivers/net/wireless/zd1201.c
@@ -1787,7 +1787,7 @@ static int zd1201_probe(struct usb_inter
 	zd->dev->tx_timeout = zd1201_tx_timeout;
 	zd->dev->set_multicast_list = zd1201_set_multicast;
 	zd->dev->set_mac_address = zd1201_set_mac_address;
-	strcpy(zd->dev->name, "wlan%d");
+	strcpy(zd->dev->name, "eth%d");
 
 	err = zd1201_getconfig(zd, ZD1201_RID_CNFOWNMACADDR, 
 	    zd->dev->dev_addr, zd->dev->addr_len);
#<EOF>
