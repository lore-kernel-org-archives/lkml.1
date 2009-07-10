Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZGJMix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZGJMix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZGJMhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:37:32 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19398 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbZGJMhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:37:17 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:40:47 +0300
Message-Id: <20090710124047.1262.99417.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 6/32] mmc: power off once at removal
X-OriginalArrivalTime: 10 Jul 2009 12:37:11.0175 (UTC) FILETIME=[253AE970:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 72aa4541a135f40ebe41e67680be912ad56a076f Mon Sep 17 00:00:00 2001
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Date: Thu, 14 May 2009 09:11:38 +0200
Subject: [PATCH] mmc: power off once at removal

Fix MMC host stop sequence: power off once.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/core/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 1461025..c5a7857 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1134,6 +1134,8 @@ void mmc_stop_host(struct mmc_host *host)
 		mmc_claim_host(host);
 		mmc_detach_bus(host);
 		mmc_release_host(host);
+		mmc_bus_put(host);
+		return;
 	}
 	mmc_bus_put(host);
 
-- 
1.5.6.3

