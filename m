Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbZEMDTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbZEMDTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZEMDGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47697 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbZEMDGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/4] vmscan: drop PF_SWAPWRITE from zone_reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090513120155.5879.A69D9226@jp.fujitsu.com>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com>
Message-Id: <20090513120627.587F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 May 2009 12:06:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] vmscan: drop PF_SWAPWRITE from zone_reclaim

PF_SWAPWRITE mean ignore write congestion. (see may_write_to_queue())

foreground reclaim shouldn't ignore it because to write congested device cause
large IO lantency.
it isn't better than remote node allocation.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2406,7 +2406,7 @@ static int __zone_reclaim(struct zone *z
 	 * and we also need to be able to write out pages for RECLAIM_WRITE
 	 * and RECLAIM_SWAP.
 	 */
-	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
+	p->flags |= PF_MEMALLOC;
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
@@ -2453,7 +2453,7 @@ static int __zone_reclaim(struct zone *z
 	}
 
 	p->reclaim_state = NULL;
-	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
+	current->flags &= ~PF_MEMALLOC;
 	return sc.nr_reclaimed >= nr_pages;
 }
 


