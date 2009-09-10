Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZIJGc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZIJGc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZIJGc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:32:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56632 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZIJGc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:32:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] lowmemorykiller: fix build error to move oom_adj
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>
In-Reply-To: <20090910152551.DB3C.A69D9226@jp.fujitsu.com>
References: <20090910152551.DB3C.A69D9226@jp.fujitsu.com>
Message-Id: <20090910153108.DB42.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Sep 2009 15:32:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recently, oom_adj moved from task_struct to signal_struct. Then, the oom_adj
treating code in android driver also should be changed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/staging/android/lowmemorykiller.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index f91ed1c..63ef837 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -106,7 +106,7 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = p->oomkilladj;
+		oom_adj = p->signal->oom_adj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
-- 
1.6.2.5



