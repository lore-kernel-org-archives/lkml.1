Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbXF0Buq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbXF0Buq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 21:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbXF0Buh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 21:50:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:23857 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbXF0Buf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 21:50:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,465,1175497200"; 
   d="scan'208";a="261537288"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 00/19] md raid acceleration and the async_tx api
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net,
       christopher.leech@intel.com, shannon.nelson@intel.com,
       herbert@gondor.apana.org.au, jeff@garzik.org
Date: Tue, 26 Jun 2007 18:50:34 -0700
Message-ID: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Per Andrew's suggestion this is the md raid5 acceleration patch set
updated with more thorough changelogs to lower the barrier to entry for
reviewers.  To get started with the code I would suggest the following
order:
[md-accel PATCH 01/19] dmaengine: refactor dmaengine around dma_async_tx_descriptor
[md-accel PATCH 04/19] async_tx: add the async_tx api
[md-accel PATCH 07/19] md: raid5_run_ops - run stripe operations outside sh->lock
[md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines

The patch set can be broken down into three main categories:
1/ API (async_tx: patches 1 - 4)
2/ implementation (md changes: patches 5 - 15)
3/ driver (iop-adma: patches 16 - 19)

I have worked with Neil to get approval of the category 2 changes.
However for the category 1 and 3 changes there was no obvious
merge-path/maintainer to work through.  I have thus far extrapolated
Neil's comments about 2 out to 1 and 3, Jeff gave some direction on a
early revision about the scalability of the API, and the patch set has
picked up various fixes and suggestions from being in -mm for a few
releases.  Please help me ensure that this code is ready for Linus to
pull for 2.6.23.

	git://lost.foo-projects.org/~dwillia2/git/iop md-accel-linus

Dan Williams (19):
      dmaengine: refactor dmaengine around dma_async_tx_descriptor
      dmaengine: make clients responsible for managing channels
      xor: make 'xor_blocks' a library routine for use with async_tx
      async_tx: add the async_tx api
      raid5: refactor handle_stripe5 and handle_stripe6 (v2)
      raid5: replace custom debug PRINTKs with standard pr_debug
      md: raid5_run_ops - run stripe operations outside sh->lock
      md: common infrastructure for running operations with raid5_run_ops
      md: handle_stripe5 - add request/completion logic for async write ops
      md: handle_stripe5 - add request/completion logic for async compute ops
      md: handle_stripe5 - add request/completion logic for async check ops
      md: handle_stripe5 - add request/completion logic for async read ops
      md: handle_stripe5 - add request/completion logic for async expand ops
      md: handle_stripe5 - request io processing in raid5_run_ops
      md: remove raid5 compute_block and compute_parity5
      dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
      iop13xx: surface the iop13xx adma units to the iop-adma driver
      iop3xx: surface the iop3xx DMA and AAU units to the iop-adma driver
      ARM: Add drivers/dma to arch/arm/Kconfig

Administrivia:
This patch set contains three new patches compared to the previous
release they are:
[md-accel PATCH 03/19] xor: make 'xor_blocks' a library routine for use with async_tx
[md-accel PATCH 05/19] raid5: refactor handle_stripe5 and handle_stripe6 (v2) 
[md-accel PATCH 06/19] raid5: replace custom debug PRINTKs with standard pr_debug

net/core/dev.c is touched by the following:
[md-accel PATCH 02/19] dmaengine: make clients responsible for managing channels
