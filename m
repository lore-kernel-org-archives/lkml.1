Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbZG1KjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbZG1KjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZG1KjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:39:11 -0400
Received: from smtp.nokia.com ([192.100.122.230]:31906 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbZG1KjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:39:09 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:39:19 +0300
Message-Id: <20090728103919.2371.80197.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 6/32] mmc: power off once at removal
X-OriginalArrivalTime: 28 Jul 2009 10:38:51.0233 (UTC) FILETIME=[98C53D10:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cf9505241b8ac5da1a3ebd0b77c1e0f5a149e461 Mon Sep 17 00:00:00 2001
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
index 0611bf7..8d03da4 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1137,6 +1137,8 @@ void mmc_stop_host(struct mmc_host *host)
 		mmc_claim_host(host);
 		mmc_detach_bus(host);
 		mmc_release_host(host);
+		mmc_bus_put(host);
+		return;
 	}
 	mmc_bus_put(host);
 
-- 
1.5.6.3

