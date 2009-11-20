Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZKTHGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZKTHGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZKTHG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:06:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:43086 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbZKTHGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:06:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,774,1249282800"; 
   d="scan'208";a="515739402"
Subject: [PATCH 3/8] ioat2,3: disable asynchronous error notifications
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Date: Fri, 20 Nov 2009 00:06:29 -0700
Message-ID: <20091120070629.13478.67985.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error interrupts and error completions may cause channel hangs, so
poll the channel status register after a timeout.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/registers.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ioat/registers.h b/drivers/dma/ioat/registers.h
index 63038e1..f015ec1 100644
--- a/drivers/dma/ioat/registers.h
+++ b/drivers/dma/ioat/registers.h
@@ -92,9 +92,7 @@
 #define IOAT_CHANCTRL_ERR_COMPLETION_EN		0x0004
 #define IOAT_CHANCTRL_INT_REARM			0x0001
 #define IOAT_CHANCTRL_RUN			(IOAT_CHANCTRL_INT_REARM |\
-						 IOAT_CHANCTRL_ERR_COMPLETION_EN |\
-						 IOAT_CHANCTRL_ANY_ERR_ABORT_EN |\
-						 IOAT_CHANCTRL_ERR_INT_EN)
+						 IOAT_CHANCTRL_ANY_ERR_ABORT_EN)
 
 #define IOAT_DMA_COMP_OFFSET			0x02	/* 16-bit DMA channel compatibility */
 #define IOAT_DMA_COMP_V1			0x0001	/* Compatibility with DMA version 1 */

