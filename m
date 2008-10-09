Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbYJIGmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbYJIGmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYJIGmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:42:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59207 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYJIGmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:42:09 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [mmotm 02/Oct PATCH 2/3] adjust hugepage related field of /proc/meminfo
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20081009153432.DEC7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081009153432.DEC7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081009153854.DECD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  9 Oct 2008 15:42:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adjust hugepage related field in /proc/meminfo.
(because vmscan-split-lru-lists-into-anon-file-sets.patch changed
length of other field)


before:

CommitLimit:     6028800 kB
Committed_AS:    8685888 kB
VmallocTotal:   17592177655808 kB
VmallocUsed:       28544 kB
VmallocChunk:   17592177626816 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:    262144 kB

after:

CommitLimit:     6028800 kB
Committed_AS:    8685888 kB
VmallocTotal:   17592177655808 kB
VmallocUsed:       28544 kB
VmallocChunk:   17592177626816 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:     262144 kB


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/hugetlb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: b/mm/hugetlb.c
===================================================================
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1459,11 +1459,11 @@ int hugetlb_report_meminfo(char *buf)
 {
 	struct hstate *h = &default_hstate;
 	return sprintf(buf,
-			"HugePages_Total: %5lu\n"
-			"HugePages_Free:  %5lu\n"
-			"HugePages_Rsvd:  %5lu\n"
-			"HugePages_Surp:  %5lu\n"
-			"Hugepagesize:    %5lu kB\n",
+			"HugePages_Total:   %5lu\n"
+			"HugePages_Free:    %5lu\n"
+			"HugePages_Rsvd:    %5lu\n"
+			"HugePages_Surp:    %5lu\n"
+			"Hugepagesize:   %8lu kB\n",
 			h->nr_huge_pages,
 			h->free_huge_pages,
 			h->resv_huge_pages,


