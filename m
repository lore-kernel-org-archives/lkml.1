Return-Path: <linux-kernel-owner+w=401wt.eu-S1422651AbXDLET6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422651AbXDLET6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 00:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422650AbXDLET5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 00:19:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:45888 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422651AbXDLET4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 00:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=uPEVXqVRmfkYegxoCcLbuw1SFBUdhO3kWtNkKTvwOXDtUT5aclFncPeYnEvLGpumOeGRHKJM1jlEplq3PpCvx0d2k6LbUhkPCmleRAaZfzOpR05ufnyZZfTpS2AFVqDu/jOgemy1k0aMklC8wEU27eIy12/bWZjW4tQ8ACuDGxQ=
Date: Thu, 12 Apr 2007 09:51:50 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org, linuxsh-shmedia-dev@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       lethal@linux-sh.org
Subject: [KJ][PATCH] ROUND_UP macro cleanup in arch/sh64/kernel/pci_sh5.c
Message-ID: <20070412042150.GA11888@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ROUND_UP macro cleanup, use ALIGN where ever appropriate.

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 pci_sh5.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/sh64/kernel/pci_sh5.c b/arch/sh64/kernel/pci_sh5.c
index 9dae689..11d1fef 100644
--- a/arch/sh64/kernel/pci_sh5.c
+++ b/arch/sh64/kernel/pci_sh5.c
@@ -376,8 +376,6 @@ irqreturn_t pcish5_serr_irq(int irq, void *dev_id, struct pt_regs *regs)
 	return IRQ_NONE;
 }
 
-#define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
-
 static void __init
 pcibios_size_bridge(struct pci_bus *bus, struct resource *ior,
 		    struct resource *memr)
@@ -434,8 +432,8 @@ pcibios_size_bridge(struct pci_bus *bus, struct resource *ior,
 	mem_res.end -= mem_res.start;
 
 	/* Align the sizes up by bridge rules */
-	io_res.end = ROUND_UP(io_res.end, 4*1024) - 1;
-	mem_res.end = ROUND_UP(mem_res.end, 1*1024*1024) - 1;
+	io_res.end = ALIGN(io_res.end, 4*1024) - 1;
+	mem_res.end = ALIGN(mem_res.end, 1*1024*1024) - 1;
 
 	/* Adjust the bridge's allocation requirements */
 	bridge->resource[0].end = bridge->resource[0].start + io_res.end;
@@ -448,18 +446,16 @@ pcibios_size_bridge(struct pci_bus *bus, struct resource *ior,
 
 	/* adjust parent's resource requirements */
 	if (ior) {
-		ior->end = ROUND_UP(ior->end, 4*1024);
+		ior->end = ALIGN(ior->end, 4*1024);
 		ior->end += io_res.end;
 	}
 
 	if (memr) {
-		memr->end = ROUND_UP(memr->end, 1*1024*1024);
+		memr->end = ALIGN(memr->end, 1*1024*1024);
 		memr->end += mem_res.end;
 	}
 }
 
-#undef ROUND_UP
-
 static void __init pcibios_size_bridges(void)
 {
 	struct resource io_res, mem_res;

-- 
Milind Arun Choudhary
