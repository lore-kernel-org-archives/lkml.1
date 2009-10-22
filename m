Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbZJVWLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbZJVWLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbZJVWLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:11:47 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50059 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbZJVWLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:11:46 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18lk2LHOTCElK8FyVJTO/jC
Subject: [PATCH 03/10] omap: iommu: fix wrong condition check for SUPERSECTION
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Srinivas Pulukuru <srinivas.pulukuru@ti.com>, linux-omap@vger.kernel.org,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org
Date: Thu, 22 Oct 2009 15:11:49 -0700
Message-ID: <20091022221149.27408.67112.stgit@localhost>
In-Reply-To: <20091022221013.27408.443.stgit@localhost>
References: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

A bit (2 << 0) is set both on SECTION and SUPERSECTION. To identify
SUPERSECTION correctly, other bits should be compared too.

Reported-by: "Srinivas Pulukuru" <srinivas.pulukuru@ti.com>
Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index 4b60127..94584f1 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -664,7 +664,7 @@ static size_t iopgtable_clear_entry_core(struct iommu *obj, u32 da)
 		nent = 1; /* for the next L1 entry */
 	} else {
 		bytes = IOPGD_SIZE;
-		if (*iopgd & IOPGD_SUPER) {
+		if ((*iopgd & IOPGD_SUPER) == IOPGD_SUPER) {
 			nent *= 16;
 			/* rewind to the 1st entry */
 			iopgd = (u32 *)((u32)iopgd & IOSUPER_MASK);

