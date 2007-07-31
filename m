Return-Path: <linux-kernel-owner+w=401wt.eu-S1762688AbXGaNM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688AbXGaNM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761298AbXGaNKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:10:06 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761817AbXGaNKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:10:04 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125445.063594000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:28 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, John Linville <linville@tuxdriver.com>
Subject: [Patch 12/16] Remove unnecessary kmalloc casts in the libertas drivers.
Content-Disposition: inline; filename=drivers_net_wireless_libertas_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: John Linville <linville@tuxdriver.com>

---
 drivers/net/wireless/libertas/debugfs.c |    2 +-
 drivers/net/wireless/libertas/ethtool.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

Index: b/drivers/net/wireless/libertas/debugfs.c
===================================================================
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -1839,7 +1839,7 @@ static ssize_t wlan_debugfs_write(struct
 	char *p2;
 	struct debug_data *d = (struct debug_data *)f->private_data;
 
-	pdata = (char *)kmalloc(cnt, GFP_KERNEL);
+	pdata = kmalloc(cnt, GFP_KERNEL);
 	if (pdata == NULL)
 		return 0;
 
Index: b/drivers/net/wireless/libertas/ethtool.c
===================================================================
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -60,8 +60,7 @@ static int libertas_ethtool_get_eeprom(s
 
 //      mutex_lock(&priv->mutex);
 
-	adapter->prdeeprom =
-		    (char *)kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNEL);
+	adapter->prdeeprom = kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNEL);
 	if (!adapter->prdeeprom)
 		return -ENOMEM;
 	memcpy(adapter->prdeeprom, &regctrl, sizeof(regctrl));

-- 
