Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbYGYK6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbYGYK6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYGYK54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:57:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46403 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbYGYK5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:57:55 -0400
Date: Fri, 25 Jul 2008 12:57:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] mm/hugetlb.c: fix build failure
Message-ID: <20080725105741.GA24336@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    
on !CONFIG_SYSCTL on x86 with latest -git i get:
    
     mm/hugetlb.c: In function 'decrement_hugepage_resv_vma':
     mm/hugetlb.c:83: error: 'reserve' undeclared (first use in this function)
     mm/hugetlb.c:83: error: (Each undeclared identifier is reported only once
     mm/hugetlb.c:83: error: for each function it appears in.)
    
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/hugetlb.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 41341c4..a8bf4ab 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1026,6 +1026,17 @@ static void __init report_hugepages(void)
 	}
 }
 
+static unsigned int cpuset_mems_nr(unsigned int *array)
+{
+	int node;
+	unsigned int nr = 0;
+
+	for_each_node_mask(node, cpuset_current_mems_allowed)
+		nr += array[node];
+
+	return nr;
+}
+
 #ifdef CONFIG_SYSCTL
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(struct hstate *h, unsigned long count)
@@ -1375,17 +1386,6 @@ static int __init hugetlb_default_setup(char *s)
 }
 __setup("default_hugepagesz=", hugetlb_default_setup);
 
-static unsigned int cpuset_mems_nr(unsigned int *array)
-{
-	int node;
-	unsigned int nr = 0;
-
-	for_each_node_mask(node, cpuset_current_mems_allowed)
-		nr += array[node];
-
-	return nr;
-}
-
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
 			   struct file *file, void __user *buffer,
 			   size_t *length, loff_t *ppos)
