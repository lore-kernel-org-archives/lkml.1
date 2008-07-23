Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYGWSyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYGWSyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYGWSx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:53:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:6732 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbYGWSx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:53:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,239,1215414000"; 
   d="scan'208";a="318413754"
Subject: [git pull] async-tx/dmaengine update for 2.6.27 (resend)
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Saeed Bishara <saeed@marvell.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Jul 2008 11:53:55 -0700
Message-Id: <1216839235.25658.24.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
X-OriginalArrivalTime: 23 Jul 2008 18:53:55.0836 (UTC) FILETIME=[754073C0:01C8ECF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git for-linus

...to receive:

The following changes since commit 0a2ce2ffc358da96792d514c1024b72c52be9cc1:
  David Howells (1):
        Fix FRV minimum slab/kmalloc alignment

Dan Williams (12):
      async_tx: fix async_memset compile error
      dmaengine: remove arch dependency from DMADEVICES
      dmaengine: track the number of clients using a channel
      dmaengine: add DMA_COMPL_SKIP_{SRC,DEST}_UNMAP flags to control dma unmap
      async_tx: ensure the xor destination buffer remains dma-mapped
      async_tx: fix handling of the "out of descriptor" condition in async_xor
      async_tx: export async_tx_quiesce
      async_tx: remove depend_tx from async_tx_sync_epilog
      async_tx: make async_tx_test_ack a boolean routine
      iop_adma: directly reclaim descriptors on allocation failure
      iop_adma: document how to calculate the minimum descriptor pool size
      iop_adma: cleanup iop_chan_xor_slot_count

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

Li Zefan (1):
      async_tx: list_for_each_entry_rcu() cleanup

Maciej Sosnowski (3):
      I/OAT: Add watchdog/reset functionality to ioatdma
      I/OAT: tcp_dma_copybreak default value dependent on I/OAT version
      I/OAT: I/OAT version 3.0 support

Saeed Bishara (1):
      dmaengine: DMA engine driver for Marvell XOR engine

 arch/avr32/mach-at32ap/at32ap700x.c        |   27 +-
 crypto/async_tx/async_memcpy.c             |   12 +-
 crypto/async_tx/async_memset.c             |   12 +-
 crypto/async_tx/async_tx.c                 |   33 +-
 crypto/async_tx/async_xor.c                |  262 +++---
 drivers/dca/dca-core.c                     |  131 +++-
 drivers/dca/dca-sysfs.c                    |    3 +-
 drivers/dma/Kconfig                        |   37 +-
 drivers/dma/Makefile                       |    3 +
 drivers/dma/dmaengine.c                    |   35 +-
 drivers/dma/dmatest.c                      |  444 +++++++++
 drivers/dma/dw_dmac.c                      | 1122 +++++++++++++++++++++++
 drivers/dma/dw_dmac_regs.h                 |  225 +++++
 drivers/dma/fsldma.c                       |   38 +-
 drivers/dma/ioat.c                         |   15 +
 drivers/dma/ioat_dca.c                     |  244 +++++-
 drivers/dma/ioat_dma.c                     |  402 ++++++++-
 drivers/dma/ioatdma.h                      |   28 +-
 drivers/dma/ioatdma_hw.h                   |    1 +
 drivers/dma/ioatdma_registers.h            |   20 +
 drivers/dma/iop-adma.c                     |   53 +-
 drivers/dma/mv_xor.c                       | 1375 ++++++++++++++++++++++++++++
 drivers/dma/mv_xor.h                       |  183 ++++
 include/asm-arm/arch-iop13xx/adma.h        |   18 +-
 include/asm-arm/hardware/iop3xx-adma.h     |    4 +-
 include/asm-arm/plat-orion/mv_xor.h        |   28 +
 include/asm-avr32/arch-at32ap/at32ap700x.h |   16 +
 include/linux/async_tx.h                   |   11 +-
 include/linux/dca.h                        |    7 +-
 include/linux/dmaengine.h                  |   69 ++-
 include/linux/dw_dmac.h                    |   62 ++
 include/linux/pci_ids.h                    |    8 +
 net/core/user_dma.c                        |    1 +
 33 files changed, 4590 insertions(+), 339 deletions(-)
 create mode 100644 drivers/dma/dmatest.c
 create mode 100644 drivers/dma/dw_dmac.c
 create mode 100644 drivers/dma/dw_dmac_regs.h
 create mode 100644 drivers/dma/mv_xor.c
 create mode 100644 drivers/dma/mv_xor.h
 create mode 100644 include/asm-arm/plat-orion/mv_xor.h
 create mode 100644 include/linux/dw_dmac.h

Some additional commits [1] have been appended to this tree since the
initial pull request [2].  The new commits are either simple cleanups
(iop-adma), fixes confirmed to address known issues (xor-unmap,
xor-out-of-descriptors, ioat-watchdog), or new hardware support
(ioat-v3).  Here is the description from the previous request: 

> This update brings two new drivers, an expansion of the dmaengine
> infrastructure to enable device-to-memory dma, as well as a mechanism
> for exclusive client-channel associations.  Also notable for developers
> is the addition of the dmatest client for dmaengine driver validation.
> 
> One api extension was made to allow intelligent clients more control
> over dma-unmapping.  There is a follow on patch brewing to use this
> capability to fix a case where xor buffers are unmapped too early.  It
> is not an urgent concern since the only xor offload engine drivers in
> mainline are for configurations where dma-unmap is a nop.

Thanks,
Dan

[1]
Dan Williams (8):
      async_tx: ensure the xor destination buffer remains dma-mapped
      async_tx: fix handling of the "out of descriptor" condition in async_xor
      async_tx: export async_tx_quiesce
      async_tx: remove depend_tx from async_tx_sync_epilog
      async_tx: make async_tx_test_ack a boolean routine
      iop_adma: directly reclaim descriptors on allocation failure
      iop_adma: document how to calculate the minimum descriptor pool size
      iop_adma: cleanup iop_chan_xor_slot_count

Li Zefan (1):
      async_tx: list_for_each_entry_rcu() cleanup

Maciej Sosnowski (3):
      I/OAT: Add watchdog/reset functionality to ioatdma
      I/OAT: tcp_dma_copybreak default value dependent on I/OAT version
      I/OAT: I/OAT version 3.0 support

[2] http://marc.info/?l=linux-kernel&m=121633721126732&w=2
