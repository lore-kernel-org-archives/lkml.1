Return-Path: <linux-kernel-owner+w=401wt.eu-S969849AbXFHRLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969849AbXFHRLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968260AbXFHRLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:11:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:20145 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967881AbXFHRLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:11:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,400,1175497200"; 
   d="scan'208";a="254809330"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] checkpatch: add an exclusion for 'for_each' helper macros
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2007 10:11:05 -0700
Message-ID: <20070608171105.7391.40550.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch currently complains about macros like the following:

#define for_each_dma_cap_mask(cap, mask) \
	for ((cap) = first_dma_cap(mask);       \
		(cap) < DMA_TX_TYPE_END;        \
		(cap) = next_dma_cap((cap), (mask)))


Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e216d49..ee6bac9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -548,10 +548,10 @@ sub process {
 			}
 		}
 
-#multiline macros should be enclosed in a do while loop
+#multiline macros should be enclosed in a do while loop, unless they are a for_each helper
 		if (($prevline=~/\#define.*\\/) and !($prevline=~/do\s+{/) and
 		   !($prevline=~/\(\{/) and ($line=~/;\s*\\/) and
-		   !($line=~/do.*{/) and !($line=~/\(\{/)) {
+		   !($line=~/do.*{/) and !($line=~/\(\{/) and !($prevline=~/.*for_each.*/)) {
 			print "Macros with multiple statements should be enclosed in a do - while loop\n";
 			print "$hereprev";
 			$clean = 0;
