Return-Path: <linux-kernel-owner+w=401wt.eu-S1765920AbXHTUgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765920AbXHTUgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764854AbXHTU3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:29:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:59002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764668AbXHTU32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:29:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,285,1183359600"; 
   d="scan'208";a="285416294"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH -mm] IOAT: fix for UP use of cpu_physical_id()
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: chris.leech@gmail.com, ak@suse.de, tony.luck@intel.com,
       shannon.nelson@intel.com
Date: Mon, 20 Aug 2007 13:29:08 -0700
Message-ID: <20070820202908.14306.31248.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we can use cpu_physical_id() even when compiled for
uni-processor.

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Chris Leech <chris.leech@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/ioat_dca.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat_dca.c b/drivers/dma/ioat_dca.c
index c3a500b..b1af49c 100644
--- a/drivers/dma/ioat_dca.c
+++ b/drivers/dma/ioat_dca.c
@@ -25,6 +25,14 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/dca.h>
+
+// either a kernel change is needed, or we need something like this in kernel
+#ifndef CONFIG_SMP
+#include <asm/smp.h>
+#undef cpu_physical_id
+#define cpu_physical_id(cpu) (cpuid_ebx(1) >> 24)
+#endif
+
 #include "ioatdma.h"
 #include "ioatdma_registers.h"
 
