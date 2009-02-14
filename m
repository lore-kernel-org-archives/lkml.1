Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbZBNVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbZBNVlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZBNVlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:41:11 -0500
Received: from mail-fx0-f25.google.com ([209.85.220.25]:42497 "EHLO
	mail-fx0-f25.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbZBNVlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:41:09 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 26/43] drivers/net/sfc: fix sparse warning: symbol shadows an
	earlier one
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:41:03 +0100
Message-ID: <20090214213932.24377.94262.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Move variable declaration as close to their usage as possible.

Fix this sparse warning:
  drivers/net/sfc/tenxpress.c:589:22: warning: symbol 'link_ok' shadows an earlier one
  drivers/net/sfc/tenxpress.c:575:30: originally declared here

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/sfc/tenxpress.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/sfc/tenxpress.c b/drivers/net/sfc/tenxpress.c
index ac9eeab..5b0f451 100644
--- a/drivers/net/sfc/tenxpress.c
+++ b/drivers/net/sfc/tenxpress.c
@@ -572,15 +572,14 @@ static void tenxpress_phy_reconfigure(struct efx_nic *efx)
 static void tenxpress_phy_poll(struct efx_nic *efx)
 {
 	struct tenxpress_phy_data *phy_data = efx->phy_data;
-	bool change = false, link_ok;
-	unsigned link_fc;
+	bool change = false;
 
 	if (efx->phy_type == PHY_TYPE_SFX7101) {
-		link_ok = sfx7101_link_ok(efx);
+		bool link_ok = sfx7101_link_ok(efx);
 		if (link_ok != efx->link_up) {
 			change = true;
 		} else {
-			link_fc = mdio_clause45_get_pause(efx);
+			unsigned int link_fc = mdio_clause45_get_pause(efx);
 			if (link_fc != efx->link_fc)
 				change = true;
 		}

