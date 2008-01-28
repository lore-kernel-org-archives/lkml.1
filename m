Return-Path: <linux-kernel-owner+w=401wt.eu-S1763086AbYA1TNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763086AbYA1TNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYA1TKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:10:00 -0500
Received: from smtp.nokia.com ([192.100.122.230]:62323 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762161AbYA1TJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:09:59 -0500
Message-ID: <479E280C.5010705@indt.org.br>
Date: Mon, 28 Jan 2008 15:07:56 -0400
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
X-OriginalArrivalTime: 28 Jan 2008 19:09:41.0696 (UTC) FILETIME=[55E97C00:01C861E1]
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
index 7525727..61d2293 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -237,7 +237,10 @@ static void mmc_omap_release_slot(struct mmc_omap_slot *slot)
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

