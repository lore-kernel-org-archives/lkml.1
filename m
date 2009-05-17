Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZEQJ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZEQJ3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 05:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZEQJ24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 05:28:56 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:59778 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZEQJ2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 05:28:54 -0400
Date: Sun, 17 May 2009 11:28:42 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] drivers/net: use dev_get_drvdata
Message-ID: <Pine.LNX.4.64.0905171128140.20440@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Eliminate direct accesses to the driver_data field.
cf 82ab13b26f15f49be45f15ccc96bfa0b81dfd015

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct device *dev;
expression E;
type T;
@@

- dev->driver_data = (T)E
+ dev_set_drvdata(dev, E)

@@
struct device *dev;
type T;
@@

- (T)dev->driver_data
+ dev_get_drvdata(dev)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2478,7 +2478,7 @@ static DEVICE_ATTR(power_level, S_IWUSR 
 static ssize_t show_qos(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	char *p = buf;
 	int   q;
 
