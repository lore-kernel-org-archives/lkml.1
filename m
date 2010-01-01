Return-Path: <linux-kernel-owner+w=401wt.eu-S1751651Ab0AAJyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab0AAJyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 04:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271Ab0AAJyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 04:54:09 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:51837 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0AAJyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 04:54:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=tQa+Tfjp+U1EsMVUKICJ/qvTwf/TcxPsQDSit0kxXjVTlosukGymh8G28g2sYY2FZS
         E8gKg7a09V3AV3Xp/KJkLDhDNVpyG3gGl1OUQH8zZ3C7wdipRhW+SHenYzWtnpGmF52i
         T+ToF7QDcguAEA+PuNM1KJJApKNf/JSfji/T0=
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] mm, lockdep: annotate reclaim context to zone reclaim too
Date: Fri,  1 Jan 2010 18:45:41 +0900
Message-Id: <1262339141-4682-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cf40bd16fd (lockdep: annotate reclaim context) introduced reclaim
context annotation. But it didn't annotate zone reclaim. This patch do it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2bbee91..a039e78 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2547,6 +2547,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	 * and RECLAIM_SWAP.
 	 */
 	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
+	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
@@ -2590,6 +2591,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 
 	p->reclaim_state = NULL;
 	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
+	lockdep_clear_current_reclaim_state();
 	return sc.nr_reclaimed >= nr_pages;
 }
 
-- 
1.6.6

