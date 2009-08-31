Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZHaFY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZHaFY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 01:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZHaFY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 01:24:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53694 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbZHaFYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 01:24:25 -0400
Date: Mon, 31 Aug 2009 15:24:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Subject: linux-next: dwmw2-iommu tree build failure
Message-Id: <20090831152423.13e06c4a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/pci/intel-iommu.c: In function 'iommu_prepare_identity_map':
drivers/pci/intel-iommu.c:1979: error: implicit declaration of function 'dmi_get_system_info'

Caused by commit 2ff729f5445cc47d1910386c36e53fc6b1c5e47a ("intel-iommu:
Cope with yet another BIOS screwup causing crashes") from the dwmw2-iommu
tree interacting with commit 2e15511d37cded52140573b72c3b5b085fdb7f80
("ACPI: linux/acpi.h should not include linux/dmi.h") from he acpi tree.

This file needs to include linux/dmi.h directly ... I applied the
following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 31 Aug 2009 15:20:33 +1000
Subject: [PATCH] intel-iommu: include linux/dmi.h to use dmi_ routines

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/pci/intel-iommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index d36fa80..2ec5899 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -37,6 +37,7 @@
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 #include <linux/sysdev.h>
+#include <linux/dmi.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 #include "pci.h"
-- 
1.6.3.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
