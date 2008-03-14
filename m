Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbYCNTof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbYCNTof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758487AbYCNTmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:42:04 -0400
Received: from smtp.nokia.com ([192.100.105.134]:36388 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473AbYCNTmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:42:02 -0400
Message-ID: <47DAD3CC.3090302@indt.org.br>
Date: Fri, 14 Mar 2008 15:36:44 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/18] MMC: OMAP: Check the get_cover_state function pointer
 if not set
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2008 19:39:24.0649 (UTC) FILETIME=[1BA30590:01C8860B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

If the get_cover_state is not set, it occurs the oops.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index e6bf5e7..a90b276 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -236,7 +236,10 @@ static void mmc_omap_release_slot(struct mmc_omap_slot *slot)
 static inline
 int mmc_omap_cover_is_open(struct mmc_omap_slot *slot)
 {
-	return slot->pdata->get_cover_state(mmc_dev(slot->mmc), slot->id);
+	if (slot->pdata->get_cover_state)
+		return slot->pdata->get_cover_state(mmc_dev(slot->mmc),
+						    slot->id);
+	return 0;
 }
 
 static ssize_t
-- 1.5.3.GIT

