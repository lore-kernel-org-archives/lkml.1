Return-Path: <linux-kernel-owner+w=401wt.eu-S1030378AbXCCTDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030378AbXCCTDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 14:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030379AbXCCTDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 14:03:19 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38059 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030378AbXCCTDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 14:03:18 -0500
Date: Sat, 3 Mar 2007 20:03:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] bcm43xx: do not rebuild when kernel version changes
Message-ID: <20070303190328.GA30463@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing use of UTS_RELEASE with utsname()->release
avoids that this module is rebuild each
time the kernel version changes.

Compile tested only.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c b/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
index c947025..d2df6a0 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
@@ -32,7 +32,7 @@
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 #include <linux/string.h>
-#include <linux/utsrelease.h>
+#include <linux/utsname.h>
 
 
 static void bcm43xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
@@ -40,7 +40,7 @@ static void bcm43xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *
 	struct bcm43xx_private *bcm = bcm43xx_priv(dev);
 
 	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strncpy(info->version, UTS_RELEASE, sizeof(info->version));
+	strncpy(info->version, utsname()->release, sizeof(info->version));
 	strncpy(info->bus_info, pci_name(bcm->pci_dev), ETHTOOL_BUSINFO_LEN);
 }
 
