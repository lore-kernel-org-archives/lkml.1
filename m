Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZKKCEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZKKCEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbZKKCEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:04:21 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50329 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbZKKCEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:04:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5][nit fix] vmscan Make consistent of reclaim bale out between do_try_to_free_page and shrink_zone
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20091111104744.FD3B.A69D9226@jp.fujitsu.com>
References: <20091111104744.FD3B.A69D9226@jp.fujitsu.com>
Message-Id: <20091111110343.FD4A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 11:04:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix small inconsistent of ">" and ">=".

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d53a934..0d0a948 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1632,7 +1632,7 @@ static void shrink_zone(int priority, struct zone *zone,
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed > nr_to_reclaim && priority < DEF_PRIORITY)
+		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
 			break;
 	}
 
-- 
1.6.2.5



