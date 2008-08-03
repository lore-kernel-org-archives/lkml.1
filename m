Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbYHCUOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbYHCUOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYHCUN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:13:56 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:64282 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753754AbYHCUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:13:56 -0400
Message-ID: <48961182.5030800@lwfinger.net>
Date: Sun, 03 Aug 2008 15:13:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: "David S. Miller" <davem@davemloft.net>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC/RFT] p54usb: Regression  due to commit b19fa1f
References: <4893CF3D.1070504@lwfinger.net>
In-Reply-To: <4893CF3D.1070504@lwfinger.net>
Content-Type: multipart/mixed;
 boundary="------------010002040905000000030306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010002040905000000030306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

In commit b19fa1fa91845234961c64dbd564671aa7c0fd27, the configuration
parameter NETDEVICES_MULTIQUEUE was eliminated making multiple TX queues
the normal behavior. For p54usb, enabling multiple queues broke the driver.

A temporary hack that forces only one queue is presented here. With it, the 
driver works as before. Obviously, a proper fix is needed in the long run.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: linux-2.6/drivers/net/wireless/p54/p54common.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/p54/p54common.c
+++ linux-2.6/drivers/net/wireless/p54/p54common.c
@@ -150,7 +150,7 @@ void p54_parse_firmware(struct ieee80211
  		priv->tx_stats[1].limit = 4;
  		priv->tx_stats[2].limit = 3;
  		priv->tx_stats[3].limit = 1;
-		dev->queues = 4;
+		dev->queues = 1; /* temp. hack, set to 1 as 4 breaks p54usb */
  	}
  }
  EXPORT_SYMBOL_GPL(p54_parse_firmware);



--------------010002040905000000030306
Content-Type: text/plain;
 name="p54usb_fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="p54usb_fix"

In commit b19fa1fa91845234961c64dbd564671aa7c0fd27, the configuration
parameter NETDEVICES_MULTIQUEUE was eliminated making multiple TX queues
the normal behavior. For p54usb, enabling multiple queues broke the driver.

The real failure is not known, but a temporary hack that forces only one
queue is presented here.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: linux-2.6/drivers/net/wireless/p54/p54common.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/p54/p54common.c
+++ linux-2.6/drivers/net/wireless/p54/p54common.c
@@ -150,7 +150,7 @@ void p54_parse_firmware(struct ieee80211
 		priv->tx_stats[1].limit = 4;
 		priv->tx_stats[2].limit = 3;
 		priv->tx_stats[3].limit = 1;
-		dev->queues = 4;
+		dev->queues = 1; /* temp. hack, set to 1 as 4 breaks p54usb */
 	}
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);



--------------010002040905000000030306--
