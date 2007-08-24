Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbXHXAGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbXHXAGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764210AbXHXAGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:06:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:6309 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbXHXAGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=qhIkzBOFZCo+Yhgk4qREnZHruWK+9l0l7syQhlsvqCQhX9E2TuhOgVlQkG2JnEpRHgo+gqa04hM+IczKVVngWC6ProVCmHdq1AP2J7JRQKoX3g8Gyn5I8/TjpYknEgI08MVaFrHGirmF8ILWRc5Ysmde27E1seSmzlnFSYcEaj4=
Message-Id: <2ac91f5f0eed967cf1709cfbe476b351e536c299.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:03:50 +0200
Subject: [PATCH 14/30] net: Kill some unneeded allocation return value casts in libertas
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() and friends return void*, no need to cast it.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/net/wireless/libertas/debugfs.c |    2 +-
 drivers/net/wireless/libertas/ethtool.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 715cbda..6ade63e 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -1839,7 +1839,7 @@ static ssize_t wlan_debugfs_write(struct file *f, const char __user *buf,
 	char *p2;
 	struct debug_data *d = (struct debug_data *)f->private_data;
 
-	pdata = (char *)kmalloc(cnt, GFP_KERNEL);
+	pdata = kmalloc(cnt, GFP_KERNEL);
 	if (pdata == NULL)
 		return 0;
 
diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index 96f1974..7dad493 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -60,8 +60,7 @@ static int libertas_ethtool_get_eeprom(struct net_device *dev,
 
 //      mutex_lock(&priv->mutex);
 
-	adapter->prdeeprom =
-		    (char *)kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNEL);
+	adapter->prdeeprom = kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNEL);
 	if (!adapter->prdeeprom)
 		return -ENOMEM;
 	memcpy(adapter->prdeeprom, &regctrl, sizeof(regctrl));
-- 
1.5.2.2

