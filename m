Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbZKTHGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbZKTHGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZKTHGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:06:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:54518 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbZKTHGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:06:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,776,1249282800"; 
   d="scan'208";a="213750381"
Subject: [PATCH 0/8] ioat fixes for 2.6.32
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Date: Fri, 20 Nov 2009 00:06:14 -0700
Message-ID: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This primarily addresses driver stability issues around pq/xor-validate
operations.  The complete fix is staged for 2.6.33.  Commit: "async_tx:
build-time toggling of async_{syndrome,xor}_val dma support" simply
disables this operation type for 2.6.32.

The rest are 1-line or few-line fixes.

---

Dan Williams (8):
      ioat3: fix pq completion versus channel deallocation race
      async_tx: build-time toggling of async_{syndrome,xor}_val dma support
      dmaengine: include xor/pq validate in device_has_all_tx_types()
      ioat2,3: report all uncorrectable errors
      ioat3: specify valid address for disabled-Q or disabled-P
      ioat2,3: disable asynchronous error notifications
      ioat3: dca and raid operations are incompatible
      ioat: silence "dca disabled" messages


 crypto/async_tx/Kconfig      |    5 +++++
 crypto/async_tx/async_pq.c   |   14 +++++++++++---
 crypto/async_tx/async_xor.c  |   15 ++++++++++++---
 drivers/dma/Kconfig          |    2 ++
 drivers/dma/dmaengine.c      |   10 ++++++++++
 drivers/dma/ioat/dca.c       |    6 +++---
 drivers/dma/ioat/dma.h       |    4 +---
 drivers/dma/ioat/dma_v2.c    |    2 ++
 drivers/dma/ioat/dma_v3.c    |   42 ++++++++++++++++++++++++++++++++++++------
 drivers/dma/ioat/hw.h        |    2 ++
 drivers/dma/ioat/registers.h |    4 +---
 11 files changed, 85 insertions(+), 21 deletions(-)

-- 
Dan
