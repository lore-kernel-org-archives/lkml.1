Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbZKAPNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbZKAPNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZKAPNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:13:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35943 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZKAPNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:13:50 -0500
Date: Mon, 2 Nov 2009 00:13:04 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 5/5][nit fix] vmscan Make consistent of reclaim bale out between do_try_to_free_page and shrink_zone
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091101234614.F401.A69D9226@jp.fujitsu.com>
References: <20091101234614.F401.A69D9226@jp.fujitsu.com>
Message-Id: <20091102001210.F40D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix small inconsistent of ">" and ">=".

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7bdf4f0..e6ea011 100644
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



