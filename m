Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916Ab0ARSfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0ARSfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898Ab0ARSfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:35:01 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57660 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755888Ab0ARSe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:34:58 -0500
Message-Id: <20100118183451.770128000@alcatraz.americas.sgi.com>
References: <20100118183412.560438000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jan 2010 12:34:16 -0600
From: Mike Travis <travis@sgi.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>, Dave Airlie <airlied@redhat.com>,
       Alex Chiang <achiang@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robin Holt <holt@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adam Jackson <ajax@nwnk.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gaetan Nadon <memsize@videotron.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       Aaron Plattner <aplattner@nvidia.com>, Jack Steiner <steiner@sgi.com>,
       Tiago Vignatti <tiago.vignatti@nokia.com>, Cliff Wickman <cpw@sgi.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Christian Zander <chzander@nvidia.com>, Yu Zhao <yu.zhao@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH 4/4] vgaarb: Add user selectability of the number of GPUS in a system
Content-Disposition: inline; filename=update-vga-max-cards
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the VGA Arbiter to allow the user to select the number
of GPU's supported in a system.

Signed-off-by: Mike Travis <travis@sgi.com>

Cc: Dave Airlie <airlied@redhat.com>
Cc: Alex Chiang <achiang@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Adam Jackson <ajax@nwnk.net>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Gaetan Nadon <memsize@videotron.ca>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Aaron Plattner <aplattner@nvidia.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Christian Zander <chzander@nvidia.com>
Cc: Yu Zhao <yu.zhao@intel.com>

Cc: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: x86@kernel.org
---
 drivers/gpu/vga/Kconfig  |    8 ++++++++
 drivers/gpu/vga/vgaarb.c |    4 ++++
 2 files changed, 12 insertions(+)

--- linux.orig/drivers/gpu/vga/Kconfig
+++ linux/drivers/gpu/vga/Kconfig
@@ -8,3 +8,11 @@
 	  are accessed at same time they need some kind of coordination. Please
 	  see Documentation/vgaarbiter.txt for more details. Select this to
 	  enable VGA arbiter.
+
+config VGA_ARB_MAX_GPUS
+	int "Maximum number of GPUs"
+	default 64
+	depends on VGA_ARB
+	help
+	  Reserves space in the kernel to maintain resource locking for
+	  multiple GPUS.  The overhead for each GPU is very small.
--- linux.orig/drivers/gpu/vga/vgaarb.c
+++ linux/drivers/gpu/vga/vgaarb.c
@@ -688,7 +688,11 @@
  * the arbiter.
  */
 
+#ifdef CONFIG_VGA_ARB_MAX_GPUS
+#define MAX_USER_CARDS         CONFIG_VGA_ARB_MAX_GPUS
+#else
 #define MAX_USER_CARDS         16
+#endif
 #define PCI_INVALID_CARD       ((struct pci_dev *)-1UL)
 
 /*

-- 
