Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbZEFOtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbZEFOtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760207AbZEFOs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:48:59 -0400
Received: from mail.crca.org.au ([67.207.131.56]:42979 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZEFOs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:48:57 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Cc: Nigel Cunningham <nigel@tuxonice.net>
Subject: [PATCH 19/19] TuxOnIce: Don't try to wake kswapd if the freezer is on.
Date: Thu,  7 May 2009 00:39:15 +1000
Message-Id: <1241620755-22133-20-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a process gets into wakeup_kswapd while other processes are frozen,
we don't want it to actually wake kswapd (memory pressure may be caused
by TuxOnIce trying to free memory).

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 mm/vmscan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5fa3eda..ae44189 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2034,6 +2034,9 @@ void wakeup_kswapd(struct zone *zone, int order)
 	if (!populated_zone(zone))
 		return;
 
+	if (freezer_is_on())
+		return;
+
 	pgdat = zone->zone_pgdat;
 	if (zone_watermark_ok(zone, order, zone->pages_low, 0, 0))
 		return;
-- 
1.5.6.3

