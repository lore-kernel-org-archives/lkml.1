Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbZEMDUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbZEMDUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbZEMDIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:08:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47777 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683AbZEMDIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:08:13 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090513120155.5879.A69D9226@jp.fujitsu.com>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com>
Message-Id: <20090513120729.5885.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 May 2009 12:08:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] zone_reclaim_mode is always 0 by default

Current linux policy is, if the machine has large remote node distance,
 zone_reclaim_mode is enabled by default because we've be able to assume to 
large distance mean large server until recently.

Unfrotunately, recent modern x86 CPU (e.g. Core i7, Opeteron) have P2P transport
memory controller. IOW it's NUMA from software view.

Some Core i7 machine has large remote node distance and zone_reclaim don't
fit desktop and small file server. it cause performance degression.

Thus, zone_reclaim == 0 is better by default. sorry, HPC gusy. 
you need to turn zone_reclaim_mode on manually now.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/page_alloc.c |    7 -------
 1 file changed, 7 deletions(-)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2494,13 +2494,6 @@ static void build_zonelists(pg_data_t *p
 		int distance = node_distance(local_node, node);
 
 		/*
-		 * If another node is sufficiently far away then it is better
-		 * to reclaim pages in a zone before going off node.
-		 */
-		if (distance > RECLAIM_DISTANCE)
-			zone_reclaim_mode = 1;
-
-		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
 		 * distance group to make it round-robin.


