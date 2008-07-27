Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYG0Ops@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYG0Ops (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 10:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbYG0Op2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 10:45:28 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:28101 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYG0OpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 10:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=nPxeRxRdHo8iZfNi1B5XxDaPb+E7xBI3wHpI1IKaKe+MaXgJzEWgOrTNM7yYIbcM2X
         vGPhoFYiDzL09psreuT/a3HqwQYVL8BzmpP5h7owCBneLNfJQ2aVm39DPu2j0cAaK+38
         sAf9UOXHdzb/SaaLFTmdFD+eaQnqVPFf4Fy0o=
From: Bryan Wu <cooloney@kernel.org>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/3] Blackfin EMAC Driver: add proper __devinit/__devexit markings
Date: Sun, 27 Jul 2008 22:45:03 +0800
Message-Id: <1217169905-7055-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217169905-7055-1-git-send-email-cooloney@kernel.org>
References: <1217169905-7055-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/net/bfin_mac.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 4144343..17951cb 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -956,7 +956,7 @@ static int bfin_mac_close(struct net_device *dev)
 	return 0;
 }
 
-static int __init bfin_mac_probe(struct platform_device *pdev)
+static int __devinit bfin_mac_probe(struct platform_device *pdev)
 {
 	struct net_device *ndev;
 	struct bfin_mac_local *lp;
@@ -1082,7 +1082,7 @@ out_err_probe_mac:
 	return rc;
 }
 
-static int bfin_mac_remove(struct platform_device *pdev)
+static int __devexit bfin_mac_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct bfin_mac_local *lp = netdev_priv(ndev);
@@ -1129,7 +1129,7 @@ static int bfin_mac_resume(struct platform_device *pdev)
 
 static struct platform_driver bfin_mac_driver = {
 	.probe = bfin_mac_probe,
-	.remove = bfin_mac_remove,
+	.remove = __devexit_p(bfin_mac_remove),
 	.resume = bfin_mac_resume,
 	.suspend = bfin_mac_suspend,
 	.driver = {
-- 
1.5.6

