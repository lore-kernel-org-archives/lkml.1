Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbYGQXVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbYGQXVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759967AbYGQXVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:21:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:4465 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758061AbYGQXVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:21:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,206,1215414000"; 
   d="scan'208";a="21774578"
Subject: [git pull] async-tx/dmaengine update for 2.6.27
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Wei <wei.zhang@freescale.com>, Saeed Bishara <saeed@marvell.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 16:21:01 -0700
Message-Id: <1216336861.18579.32.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

to receive:

Dan Williams (4):
      async_tx: fix async_memset compile error
      dmaengine: remove arch dependency from DMADEVICES
      dmaengine: track the number of clients using a channel
      dmaengine: add DMA_COMPL_SKIP_{SRC,DEST}_UNMAP flags to control dma unmap

Haavard Skinnemoen (5):
      dmaengine: Couple DMA channels to their physical DMA device
      dmatest: Simple DMA memcpy test client
      dmaengine: Add dma_client parameter to device_alloc_chan_resources
      dmaengine: Add slave DMA interface
      dmaengine: Driver for the Synopsys DesignWare DMA controller

Kay Sievers (1):
      iop-adma: fix platform driver hotplug/coldplug

Li Yang (1):
      fsldma: fix incorrect exit path for initialization

Saeed Bishara (1):
      dmaengine: DMA engine driver for Marvell XOR engine

 arch/avr32/mach-at32ap/at32ap700x.c        |   27 +-
 crypto/async_tx/async_memset.c             |    2 +-
 drivers/dma/Kconfig                        |   37 +-
 drivers/dma/Makefile                       |    3 +
 drivers/dma/dmaengine.c                    |   35 +-
 drivers/dma/dmatest.c                      |  444 +++++++++
 drivers/dma/dw_dmac.c                      | 1122 +++++++++++++++++++++++
 drivers/dma/dw_dmac_regs.h                 |  225 +++++
 drivers/dma/fsldma.c                       |   38 +-
 drivers/dma/ioat_dma.c                     |   53 +-
 drivers/dma/iop-adma.c                     |   38 +-
 drivers/dma/mv_xor.c                       | 1375 ++++++++++++++++++++++++++++
 drivers/dma/mv_xor.h                       |  183 ++++
 include/asm-arm/plat-orion/mv_xor.h        |   28 +
 include/asm-avr32/arch-at32ap/at32ap700x.h |   16 +
 include/linux/dmaengine.h                  |   61 ++-
 include/linux/dw_dmac.h                    |   62 ++
 17 files changed, 3662 insertions(+), 87 deletions(-)
 create mode 100644 drivers/dma/dmatest.c
 create mode 100644 drivers/dma/dw_dmac.c
 create mode 100644 drivers/dma/dw_dmac_regs.h
 create mode 100644 drivers/dma/mv_xor.c
 create mode 100644 drivers/dma/mv_xor.h
 create mode 100644 include/asm-arm/plat-orion/mv_xor.h
 create mode 100644 include/linux/dw_dmac.h

This update brings two new drivers, an expansion of the dmaengine
infrastructure to enable device-to-memory dma, as well as a mechanism
for exclusive client-channel associations.  Also notable for developers
is the addition of the dmatest client for dmaengine driver validation.

One api extension was made to allow intelligent clients more control
over dma-unmapping.  There is a follow on patch brewing to use this
capability to fix a case where xor buffers are unmapped too early.  It
is not an urgent concern since the only xor offload engine drivers in
mainline are for configurations where dma-unmap is a nop.

Regards,
Dan

