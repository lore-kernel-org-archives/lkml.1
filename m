Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZGJMmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZGJMmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbZGJMjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:39:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:35036 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbZGJMja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:39:30 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:42:41 +0300
Message-Id: <20090710124241.1262.79000.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 22/32] omap_hsmmc: fix NULL pointer dereference
X-OriginalArrivalTime: 10 Jul 2009 12:39:07.0792 (UTC) FILETIME=[6ABD4100:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ece776be05f73787dad93802000f2d04218197d0 Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Tue, 12 May 2009 19:46:14 +0300
Subject: [PATCH] omap_hsmmc: fix NULL pointer dereference

Do not call 'mmc_omap_xfer_done()' if the request is
already done.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 41c330d..fe46234 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -670,7 +670,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 
 	if (end_cmd || ((status & CC) && host->cmd))
 		mmc_omap_cmd_done(host, host->cmd);
-	if (end_trans || (status & TC))
+	if ((end_trans || (status & TC)) && host->mrq)
 		mmc_omap_xfer_done(host, data);
 
 	return IRQ_HANDLED;
-- 
1.5.6.3

