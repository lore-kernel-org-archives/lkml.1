Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZKTHG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZKTHG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbZKTHGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:06:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:61356 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641AbZKTHGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:06:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,776,1249282800"; 
   d="scan'208";a="571400142"
Subject: [PATCH 1/8] ioat: silence "dca disabled" messages
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Date: Fri, 20 Nov 2009 00:06:19 -0700
Message-ID: <20091120070619.13478.14991.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turning off dca is not an "error", and the dca-enabled state can be
viewed from sysfs.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dca.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dca.c b/drivers/dma/ioat/dca.c
index 69d0261..14f0a78 100644
--- a/drivers/dma/ioat/dca.c
+++ b/drivers/dma/ioat/dca.c
@@ -98,7 +98,7 @@ static int dca_enabled_in_bios(struct pci_dev *pdev)
 	cpuid_level_9 = cpuid_eax(9);
 	res = test_bit(0, &cpuid_level_9);
 	if (!res)
-		dev_err(&pdev->dev, "DCA is disabled in BIOS\n");
+		dev_dbg(&pdev->dev, "DCA is disabled in BIOS\n");
 
 	return res;
 }
@@ -108,7 +108,7 @@ static int system_has_dca_enabled(struct pci_dev *pdev)
 	if (boot_cpu_has(X86_FEATURE_DCA))
 		return dca_enabled_in_bios(pdev);
 
-	dev_err(&pdev->dev, "boot cpu doesn't have X86_FEATURE_DCA\n");
+	dev_dbg(&pdev->dev, "boot cpu doesn't have X86_FEATURE_DCA\n");
 	return 0;
 }
 

