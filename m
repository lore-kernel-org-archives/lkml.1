Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbXLVBJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbXLVBJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXLVBIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:08:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:15467 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXLVBIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:08:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,197,1196668800"; 
   d="scan'208";a="347353173"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/4] towards an async_tx update for 2.6.25
To: linux-kernel@vger.kernel.org
Cc: shannon.nelson@intel.com, yur@emcraft.com, hskinnemoen@atmel.com,
       olof@lixom.net, wei.zhang@freescale.com
Date: Fri, 21 Dec 2007 18:06:38 -0700
Message-ID: <20071222010537.15576.31788.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prompted by Yuri's RAID6 acceleration implementation [1], and Haavard's
DMA-slave interface [2], this series cleans up the async_tx api and prepares
it for these new features.  The most invasive change is the removal of
the tx_set_src and tx_set_dest methods in patch 2/4, drivers now receive
all necessary operation information at 'prep' time.

Still on the to do list:
* Pull the mpc85xx driver from -mm and integrate these api changes
* Apply Haavard's dma-test-client [3].  Look into extending it for
  other operations and async_tx channel switching testing
* Teach async_tx about drivers that do not support channel switching

This series is based on 2.6.24-rc6.

Dan Williams (4):
      async_tx: kill ASYNC_TX_ASSUME_COHERENT
      async_tx: kill tx_set_src and tx_set_dest methods
      async_tx: replace 'int_en' with operation preparation flags
      async_tx: allow architecture specific async_tx_find_channel implementations

 crypto/async_tx/async_memcpy.c         |   38 ++++-----
 crypto/async_tx/async_memset.c         |   28 +++---
 crypto/async_tx/async_tx.c             |    6 +-
 crypto/async_tx/async_xor.c            |  120 +++++++++++++++++------------
 drivers/dma/Kconfig                    |    1 +
 drivers/dma/dmaengine.c                |   49 +++++++-----
 drivers/dma/ioat_dma.c                 |   43 ++++------
 drivers/dma/iop-adma.c                 |  136 ++++++++++++--------------------
 include/asm-arm/arch-iop13xx/adma.h    |   18 +++--
 include/asm-arm/hardware/iop3xx-adma.h |   30 ++++---
 include/linux/async_tx.h               |   13 ++-
 include/linux/dmaengine.h              |   29 ++++---
 12 files changed, 253 insertions(+), 258 deletions(-)

--
Dan

[1] http://marc.info/?l=linux-raid&m=119676789912370&w=2
[2] http://marc.info/?l=linux-kernel&m=119582072930013&w=2
[3] http://marc.info/?l=linux-kernel&m=119583211214496&w=2
