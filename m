Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbYBDUNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbYBDUNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbYBDUNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:13:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:64427 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758163AbYBDUNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:13:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,304,1199692800"; 
   d="scan'208";a="375047570"
Subject: [GIT PULL] async_tx update for 2.6.25
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Shannon Nelson <shannon.nelson@intel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Feb 2008 13:02:50 -0700
Message-Id: <1202155370.27672.3.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-7.fc7) 
X-OriginalArrivalTime: 04 Feb 2008 20:02:51.0235 (UTC) FILETIME=[EBEAC330:01C86768]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

	git://lost.foo-projects.org/~dwillia2/git/iop async-tx-for-linus

to receive:

Dan Williams (5):
      async_tx: fix compile breakage, mark do_async_xor __always_inline
      async_tx: kill ASYNC_TX_ASSUME_COHERENT
      async_tx: kill tx_set_src and tx_set_dest methods
      async_tx: replace 'int_en' with operation preparation flags
      async_tx: allow architecture specific async_tx_find_channel implementations

Denis Cheng (2):
      async_tx: use LIST_HEAD instead of LIST_HEAD_INIT
      iop-adma: use LIST_HEAD instead of LIST_HEAD_INIT

 crypto/async_tx/async_memcpy.c         |   38 ++++-----
 crypto/async_tx/async_memset.c         |   28 +++---
 crypto/async_tx/async_tx.c             |    9 +-
 crypto/async_tx/async_xor.c            |  124 +++++++++++++++++-----------
 drivers/dma/Kconfig                    |    1 +
 drivers/dma/dmaengine.c                |   49 +++++++-----
 drivers/dma/ioat_dma.c                 |   43 ++++------
 drivers/dma/iop-adma.c                 |  138 ++++++++++++--------------------
 include/asm-arm/arch-iop13xx/adma.h    |   18 +++--
 include/asm-arm/hardware/iop3xx-adma.h |   30 ++++---
 include/linux/async_tx.h               |   13 ++-
 include/linux/dmaengine.h              |   29 ++++---
 12 files changed, 259 insertions(+), 261 deletions(-)

The series is a general cleanup to the async_tx-api for 2.6.25.  The
most significant change 'async_tx: kill tx_set_src and tx_set_dest
methods' removes the need to perform extra indirect calls when preparing
a descriptor.  However, in order to keep the same stack footprint,
async_xor now polls for engine resources rather than simply punting to
cpu-xor.

The code was sent out for review in December [1], and has received an
Acked-by from Shannon@Intel for the parts that touch ioat_dma.
Haavard@Atmel has supplied a Reviewed-by for the pieces he felt
comfortable judging the correctness.

Regards,
Dan

[1] http://lkml.org/lkml/2007/12/21/277

