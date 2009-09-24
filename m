Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZIXABa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZIXABa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZIXAB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:01:28 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:42645 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZIXAB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:01:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACNTukqrR7PE/2dsb2JhbAC+a4hPAY9uBYQb
X-IronPort-AV: E=Sophos;i="4.44,441,1249257600"; 
   d="scan'208";a="394836698"
From: Roland Dreier <rdreier@cisco.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] intel-iommu: Make "Unknown DMAR structure" message more informative
X-Message-Flag: Warning: May contain useful information
Date: Wed, 23 Sep 2009 17:01:29 -0700
Message-ID: <adafxad2oti.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Sep 2009 00:01:30.0202 (UTC) FILETIME=[2B4C7BA0:01CA3CAA]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We might as well print the type of the DMAR structure we don't know how
to handle when skipping it.  Then someone getting this message has a
chance of telling whether the structure is just bogus, or if there
really is something valid that the kernel doesn't know how to handle.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/pci/dmar.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 14bbaa1..d199bca 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -461,7 +461,8 @@ parse_dmar_table(void)
 			break;
 		default:
 			printk(KERN_WARNING PREFIX
-				"Unknown DMAR structure type\n");
+				"Unknown DMAR structure type %d\n",
+				entry_header->type);
 			ret = 0; /* for forward compatibility */
 			break;
 		}
