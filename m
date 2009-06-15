Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbZFOLPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbZFOLPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZFOLOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:14:44 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45682 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbZFOLOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:14:43 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] mm: Fix documentation of min_unmapped_ratio
Date: Mon, 15 Jun 2009 12:14:42 +0100
Message-Id: <1245064482-19245-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245064482-19245-1-git-send-email-mel@csn.ul.ie>
References: <1245064482-19245-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kosaki Motohiro pointed out that the documentation for
min_unmapped_ratio no longer matches the implementation. This patch
updates the documentation.

This patch can be merged with
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-re
claim.patch .

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 Documentation/sysctl/vm.txt |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 0ea5adb..c4de635 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -315,10 +315,14 @@ min_unmapped_ratio:
 
 This is available only on NUMA kernels.
 
-A percentage of the total pages in each zone.  Zone reclaim will only
-occur if more than this percentage of pages are file backed and unmapped.
-This is to insure that a minimal amount of local pages is still available for
-file I/O even if the node is overallocated.
+This is a percentage of the total pages in each zone. Zone reclaim will
+only occur if more than this percentage of pages are in a state that
+zone_reclaim_mode allows to be reclaimed.
+
+If zone_reclaim_mode has the value 4 OR'd, then the percentage is compared
+against all file-backed unmapped pages including swapcache pages and tmpfs
+files. Otherwise, only unmapped pages backed by normal files but not tmpfs
+files and similar are considered.
 
 The default is 1 percent.
 
-- 
1.5.6.5

