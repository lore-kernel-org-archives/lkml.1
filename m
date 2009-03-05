Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZCETyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZCETyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbZCETyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:54:21 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:21859 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZCETyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:54:20 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v3 02/15] NULL noise: arch/x86/kernel/amd_iommu*.c
Date: Thu, 05 Mar 2009 20:53:42 +0100
Message-ID: <20090305195228.2407.4911.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>
In-Reply-To: <20090305191312.30062.28919.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net> <20090305191312.30062.28919.stgit@f10box.hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning(s):
  arch/x86/kernel/amd_iommu_init.c:901:37: warning: Using plain integer as NULL pointer
  arch/x86/kernel/amd_iommu.c:1522:24: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro
v3: no need to init the variable (thanks to Joe Perches)

 arch/x86/kernel/amd_iommu.c      |    2 +-
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 008e522..3f6e1c8 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1519,7 +1519,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	flag |= __GFP_ZERO;
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
-		return 0;
+		return NULL;
 
 	paddr = virt_to_phys(virt_addr);
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 42c33ce..9bccd0f 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -898,7 +898,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
 /* called for unity map ACPI definition */
 static int __init init_unity_map_range(struct ivmd_header *m)
 {
-	struct unity_map_entry *e = 0;
+	struct unity_map_entry *e;
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (e == NULL)

