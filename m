Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbYA3UMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbYA3UMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762470AbYA3UCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:02:55 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37652 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762223AbYA3UCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:02:49 -0500
Date: Wed, 30 Jan 2008 22:03:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sparc64/kernel/pci_sun4v.c section fixes
Message-ID: <20080130200324.GJ29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x39be4): Section mismatch in reference from the function probe_existing_entries() to the function .init.text:page_in_phys_avail()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sparc64/kernel/pci_sun4v.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

5a836480057dcc064ae02a69ae4bb2b7698e333f 
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index 1aa8e04..87c5cf5 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -625,8 +625,8 @@ static void __init pci_sun4v_scan_bus(struct pci_pbm_info *pbm)
 	/* XXX register error interrupt handlers XXX */
 }
 
-static unsigned long probe_existing_entries(struct pci_pbm_info *pbm,
-					    struct iommu *iommu)
+static unsigned long __init probe_existing_entries(struct pci_pbm_info *pbm,
+						   struct iommu *iommu)
 {
 	struct iommu_arena *arena = &iommu->arena;
 	unsigned long i, cnt = 0;
@@ -653,7 +653,7 @@ static unsigned long probe_existing_entries(struct pci_pbm_info *pbm,
 	return cnt;
 }
 
-static void pci_sun4v_iommu_init(struct pci_pbm_info *pbm)
+static void __init pci_sun4v_iommu_init(struct pci_pbm_info *pbm)
 {
 	struct iommu *iommu = pbm->iommu;
 	struct property *prop;

