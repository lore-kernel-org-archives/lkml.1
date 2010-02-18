Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab0BRRAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:00:17 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:41125 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab0BRRAN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 18 Feb 2010 12:00:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@ORACLE.COM>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Cc: jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@ORACLE.COM>
Subject: [PATCH 03/10] swiotlb: Normalize the swiotlb_init_* function's naming syntax.
Date: Thu, 18 Feb 2010 11:26:59 -0500
Message-Id: <1266510426-6815-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B7D6EA3.0176:SCFMA4539814,ss=1,fgs=0
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
index 0663879..7b66fc3 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -174,7 +174,7 @@ void swiotlb_print_info(void)
  * structures for the software IO TLB used to implement the DMA API.
  */
 void __init
-swiotlb_init_with_default_size(size_t default_size, int verbose)
+swiotlb_init_early(size_t default_size, int verbose)
 {
 	unsigned long i, bytes;
 
@@ -217,7 +217,7 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 void __init
 swiotlb_init(int verbose)
 {
-	swiotlb_init_with_default_size(64 * (1<<20), verbose);	/* default to 64MB */
+	swiotlb_init_early(64 * (1<<20), verbose);	/* default to 64MB */
 }
 
 /*
@@ -226,7 +226,7 @@ swiotlb_init(int verbose)
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

