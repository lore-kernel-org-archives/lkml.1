Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbZLNMa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbZLNMa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZLNMa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:30:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35288 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZLNMa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:30:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: [PATCH 5/8] Use io_schedule() instead schedule()
Cc: kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
Message-Id: <20091214213026.BBBD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 14 Dec 2009 21:30:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All task sleeping point in vmscan (e.g. congestion_wait) use
io_schedule. then shrink_zone_begin use it too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3562a2d..0880668 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1624,7 +1624,7 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
 		    max_zone_concurrent_reclaimers)
 			break;
 
-		schedule();
+		io_schedule();
 
                /*
                 * If other processes freed enough memory while we waited,
-- 
1.6.5.2



