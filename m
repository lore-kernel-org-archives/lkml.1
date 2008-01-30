Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbYA3UI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbYA3UI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbYA3UCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:02:17 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51760 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759584AbYA3UCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:02:13 -0500
Date: Wed, 30 Jan 2008 22:02:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Buesch <mb@bu3sch.de>, "John W. Linville" <linville@tuxdriver.com>,
       stefano.brivio@polimi.it
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make b43_mac_{enable,suspend}() static
Message-ID: <20080130200247.GA29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

b43_mac_{enable,suspend}() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/net/wireless/b43/main.c |    4 ++--
 drivers/net/wireless/b43/main.h |    3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

e2a91b00d125ed4b60bdf9e37f550aed23d84747 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 88d2c15..360515c 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2042,7 +2042,7 @@ static void b43_gpio_cleanup(struct b43_wldev *dev)
 }
 
 /* http://bcm-specs.sipsolutions.net/EnableMac */
-void b43_mac_enable(struct b43_wldev *dev)
+static void b43_mac_enable(struct b43_wldev *dev)
 {
 	dev->mac_suspended--;
 	B43_WARN_ON(dev->mac_suspended < 0);
@@ -2066,7 +2066,7 @@ void b43_mac_enable(struct b43_wldev *dev)
 }
 
 /* http://bcm-specs.sipsolutions.net/SuspendMAC */
-void b43_mac_suspend(struct b43_wldev *dev)
+static void b43_mac_suspend(struct b43_wldev *dev)
 {
 	int i;
 	u32 tmp;
diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index 2d52d9d..4397f49 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -102,9 +102,6 @@ void b43_dummy_transmission(struct b43_wldev *dev);
 
 void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags);
 
-void b43_mac_suspend(struct b43_wldev *dev);
-void b43_mac_enable(struct b43_wldev *dev);
-
 void b43_controller_restart(struct b43_wldev *dev, const char *reason);
 
 #define B43_PS_ENABLED	(1 << 0)	/* Force enable hardware power saving */

