Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbYJPRSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbYJPRSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYJPROP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:15 -0400
Received: from kroah.org ([198.145.64.141]:46937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756098AbYJPROM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 08/46] device create: net: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:09 -0700
Message-Id: <1224177047-11859-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/ppp_generic.c             |    4 ++--
 drivers/net/wan/cosa.c                |    4 ++--
 drivers/net/wireless/mac80211_hwsim.c |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 0ca0fcb..03d027c 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -866,8 +866,8 @@ static int __init ppp_init(void)
 			err = PTR_ERR(ppp_class);
 			goto out_chrdev;
 		}
-		device_create_drvdata(ppp_class, NULL, MKDEV(PPP_MAJOR, 0),
-				      NULL, "ppp");
+		device_create(ppp_class, NULL, MKDEV(PPP_MAJOR, 0), NULL,
+			      "ppp");
 	}
 
 out:
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index f140515..7f97f8d 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -388,8 +388,8 @@ static int __init cosa_init(void)
 		goto out_chrdev;
 	}
 	for (i = 0; i < nr_cards; i++)
-		device_create_drvdata(cosa_class, NULL, MKDEV(cosa_major, i),
-				      NULL, "cosa%d", i);
+		device_create(cosa_class, NULL, MKDEV(cosa_major, i), NULL,
+			      "cosa%d", i);
 	err = 0;
 	goto out;
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c9e4a43..1a019e9 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -533,11 +533,11 @@ static int __init init_mac80211_hwsim(void)
 		data = hw->priv;
 		data->hw = hw;
 
-		data->dev = device_create_drvdata(hwsim_class, NULL, 0, hw,
-						"hwsim%d", i);
+		data->dev = device_create(hwsim_class, NULL, 0, hw,
+					  "hwsim%d", i);
 		if (IS_ERR(data->dev)) {
 			printk(KERN_DEBUG
-			       "mac80211_hwsim: device_create_drvdata "
+			       "mac80211_hwsim: device_create "
 			       "failed (%ld)\n", PTR_ERR(data->dev));
 			err = -ENOMEM;
 			goto failed_drvdata;
-- 
1.6.0.2

