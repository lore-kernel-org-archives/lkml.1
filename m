Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0CIWMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:12:40 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:19220 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab0CIWMf (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 9 Mar 2010 17:12:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, chrisw@sous-sol.org, alex.williamson@hp.com,
       dwmw2@infradead.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] swiotlb: Normalize the swiotlb_init_* function's naming syntax.
Date: Tue,  9 Mar 2010 16:54:20 -0500
Message-Id: <1268171662-12701-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268171662-12701-2-git-send-email-konrad.wilk@oracle.com>
References: <1268171662-12701-1-git-send-email-konrad.wilk@oracle.com>
 <1268171662-12701-2-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B96C78B.00D5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous function names were misleading by including "with_default_size"
as the size was being passed in as argument. Change the functions names
to be clear on what they do.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e6d9e32..737ceb7 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -146,7 +146,7 @@ void swiotlb_print_info(void)
  * structures for the software IO TLB used to implement the DMA API.
  */
 void __init
-swiotlb_init_with_default_size(size_t default_size, int verbose)
+swiotlb_init_early(size_t default_size, int verbose)
 {
 	unsigned long i, bytes;
 
@@ -189,7 +189,7 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 void __init
 swiotlb_init(int verbose)
 {
-	swiotlb_init_with_default_size(64 * (1<<20), verbose);	/* default to 64MB */
+	swiotlb_init_early(64 * (1<<20), verbose);	/* default to 64MB */
 }
 
 /*
@@ -198,7 +198,7 @@ swiotlb_init(int verbose)
  * This should be just like above, but with some error catching.
  */
 int
-swiotlb_late_init_with_default_size(size_t default_size)
+swiotlb_init_late(size_t default_size)
 {
 	unsigned long i, bytes, req_nslabs = io_tlb_nslabs;
 	unsigned int order;
-- 
1.6.2.5

