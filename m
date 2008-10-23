Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYJWWj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYJWWj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYJWWjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:39:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:19892 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYJWWjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:39:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,473,1220252400"; 
   d="scan'208";a="630996116"
Date: Thu, 23 Oct 2008 15:39:06 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix compile warning CONFIG_I7300_IDLE_IOAT_CHANNEL not defined
Message-ID: <20081023223906.GA26918@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I7300_idle driver is not configured, there is a compile time
warning about IDLE_IOAT_CHANNEL not defined. Fix it.

Reported-by: Suresh Siddha <suresh.b.siddha@intel.com>

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 drivers/dma/ioat_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/dma/ioat_dma.c
===================================================================
--- linux-2.6.orig/drivers/dma/ioat_dma.c	2008-10-23 15:27:43.000000000 -0700
+++ linux-2.6/drivers/dma/ioat_dma.c	2008-10-23 15:28:03.000000000 -0700
@@ -171,7 +171,7 @@ static int ioat_dma_enumerate_channels(s
 	xfercap_scale = readb(device->reg_base + IOAT_XFERCAP_OFFSET);
 	xfercap = (xfercap_scale == 0 ? -1 : (1UL << xfercap_scale));
 
-#if CONFIG_I7300_IDLE_IOAT_CHANNEL
+#ifdef CONFIG_I7300_IDLE_IOAT_CHANNEL
 	device->common.chancnt--;
 #endif
 	for (i = 0; i < device->common.chancnt; i++) {
