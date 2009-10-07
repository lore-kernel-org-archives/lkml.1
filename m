Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbZJGRGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbZJGRGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZJGRGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:06:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:37318 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZJGRGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:06:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,520,1249282800"; 
   d="scan'208";a="733893985"
Message-Id: <20091007170149.169012562@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 07 Oct 2009 10:00:51 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       a.beregalov@gmail.com, len.brown@intel.com
Subject: [patch 2/2] acpi: define acpi_map_pxm_to_node() for !CONFIG_NUMA
References: <20091007170149.080617784@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_acpi_map_pxm_to_node_for_nonnuma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov reported:
	drivers/pci/dmar.c: In function 'dmar_parse_one_rhsa':
	drivers/pci/dmar.c:360: error: implicit declaration of function
	'acpi_map_pxm_to_node'

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/acpi/acpi_numa.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: iommu-2.6/include/acpi/acpi_numa.h
===================================================================
--- iommu-2.6.orig/include/acpi/acpi_numa.h
+++ iommu-2.6/include/acpi/acpi_numa.h
@@ -16,5 +16,12 @@ extern int node_to_pxm(int);
 extern void __acpi_map_pxm_to_node(int, int);
 extern int acpi_map_pxm_to_node(int);
 
+#else				/* !CONFIG_ACPI_NUMA */
+
+static inline int acpi_map_pxm_to_node(int pxm)
+{
+	return -1;
+}
+
 #endif				/* CONFIG_ACPI_NUMA */
 #endif				/* __ACP_NUMA_H */


