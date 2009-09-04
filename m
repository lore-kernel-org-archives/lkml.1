Return-Path: <linux-kernel-owner+w=401wt.eu-S932647AbZIDCbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbZIDCbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 22:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932563AbZIDCbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 22:31:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:46513 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633AbZIDCbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 22:31:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,329,1249282800"; 
   d="scan'208";a="490400225"
Subject: [PATCH 07/29] ioat: fix type mismatch for ->dmacount
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, netdev@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Date: Thu, 03 Sep 2009 19:31:05 -0700
Message-ID: <20090904023105.32667.76009.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->dmacount tracks the sequence number of active descriptors.  It is
written to the DMACOUNT register to update the channel's view of pending
descriptors in the chain.  The register is 16-bits so ->dmacount should
be unsigned and 16-bit as well.  Also modify ->desccount to maintain
alignment.

This was never a problem in practice because we never compared dmacount
values, but this is a bug waiting to happen.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 1226e35..9f0c853 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -102,8 +102,8 @@ struct ioat_dma_chan {
 	struct delayed_work work;
 
 	int pending;
-	int dmacount;
-	int desccount;
+	u16 dmacount;
+	u16 desccount;
 
 	struct ioatdma_device *device;
 	struct dma_chan common;

