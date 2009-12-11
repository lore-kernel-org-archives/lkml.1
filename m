Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZLKGm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZLKGm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbZLKGmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:42:24 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48205 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZLKGmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:42:24 -0500
Date: Fri, 11 Dec 2009 15:42:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] net: smc91x: Fix up type mismatch in smc_drv_resume().
Message-ID: <20091211064226.GA7625@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smc_drv_resume() takes a struct device, while smc_enable_device() takes a
platform device. This fixes up the smc_enable_device() callsite with the
proper pointer.

It's not obvious when this change was introduced, as git history doesn't
go back that far. Presumably the resume code has always been broken in
this fashion.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/net/smc91x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index ae4983a..5c9222d 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -2387,7 +2387,7 @@ static int smc_drv_resume(struct device *dev)
 
 	if (ndev) {
 		struct smc_local *lp = netdev_priv(ndev);
-		smc_enable_device(dev);
+		smc_enable_device(pdev);
 		if (netif_running(ndev)) {
 			smc_reset(ndev);
 			smc_enable(ndev);
