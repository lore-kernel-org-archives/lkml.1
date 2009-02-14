Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZBNVv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZBNVv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZBNVuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:50:52 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:50319 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbZBNVuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:50:50 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 43/43] drivers/net/wireless/prism54: fix sparse warning: fix
	signedness
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:50:45 +0100
Message-ID: <20090214215034.24377.54126.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning:
  drivers/net/wireless/prism54/isl_ioctl.c:2997:32: warning: incorrect type in argument 2 (different signedness)
  drivers/net/wireless/prism54/oid_mgt.c:712:42: warning: incorrect type in argument 2 (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/wireless/prism54/isl_ioctl.c |    3 ++-
 drivers/net/wireless/prism54/oid_mgt.c   |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 57a150a..4c97c6a 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2981,7 +2981,8 @@ prism54_set_spy(struct net_device *ndev,
 		union iwreq_data *uwrq, char *extra)
 {
 	islpci_private *priv = netdev_priv(ndev);
-	u32 u, oid = OID_INL_CONFIG;
+	u32 u;
+	enum oid_num_t oid = OID_INL_CONFIG;
 
 	down_write(&priv->mib_sem);
 	mgt_get(priv, OID_INL_CONFIG, &u);
diff --git a/drivers/net/wireless/prism54/oid_mgt.c b/drivers/net/wireless/prism54/oid_mgt.c
index 57a4ac3..1187e61 100644
--- a/drivers/net/wireless/prism54/oid_mgt.c
+++ b/drivers/net/wireless/prism54/oid_mgt.c
@@ -698,7 +698,7 @@ int
 mgt_commit(islpci_private *priv)
 {
 	int rvalue;
-	u32 u;
+	enum oid_num_t u;
 
 	if (islpci_get_state(priv) < PRV_STATE_INIT)
 		return 0;

