Return-Path: <linux-kernel-owner+w=401wt.eu-S1030283AbXEBGOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbXEBGOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030664AbXEBGOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:14:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:61430 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030283AbXEBGOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:14:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,477,1170662400"; 
   d="scan'208";a="240422824"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 00/16] raid acceleration and asynchronous offload api for
	2.6.22
To: neilb@suse.de, akpm@linux-foundation.org, christopher.leech@intel.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Date: Tue, 01 May 2007 23:14:40 -0700
Message-ID: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am pleased to release this latest spin of the raid acceleration
patches for merge consideration.  This release aims to address all
pending review items including MD bug fixes and async_tx api changes
from Neil, and concerns on channel management from Chris and others.

Data integrity tests using home grown scripts and 'iozone -V' are
passing.  I am open to suggestions for additional testing criteria.  I
have also verified that git bisect is not broken by this set.

The short log below highlights the most recent changes.  The patches
will be sent as a reply to this message, and they are also available via
git:

	git pull git://lost.foo-projects.org/~dwillia2/git/iop md-accel-linus

Additional comments and feedback welcome.

Thanks,
Dan

--
01/16: dmaengine: add base support for the async_tx api
	* convert channel capabilities to a 'cpumask_t like' bitmap
02/16: dmaengine: move channel management to the client
	* this patch is new to this series
03/16: ARM: Add drivers/dma to arch/arm/Kconfig
04/16: dmaengine: add the async_tx api
	* remove the per operation type list, and distribute operation
	  capabilities evenly amongst the available channels
	* simplify async_tx_find_channel to optimize the fast path
05/16: md: add raid5_run_ops and support routines
	* explicitly handle the 2-disk raid5 case (xor becomes memcpy)
	* fix race between async engines and bi_end_io call for reads,
	  Neil Brown
	* remove unnecessary spin_lock from ops_complete_biofill
	* remove test_and_set/test_and_clear BUG_ONs, Neil Brown
	* remove explicit interrupt handling, Neil Brown
06/16: md: use raid5_run_ops for stripe cache operations
07/16: md: move write operations to raid5_run_ops
	* remove test_and_set/test_and_clear BUG_ONs, Neil Brown
08/16: md: move raid5 compute block operations to raid5_run_ops
	* remove the req_compute BUG_ON
09/16: md: move raid5 parity checks to raid5_run_ops
	* remove test_and_set/test_and_clear BUG_ONs, Neil Brown
10/16: md: satisfy raid5 read requests via raid5_run_ops
	* cleanup to_read and to_fill accounting
	* do not fail reads that have reached the cache
11/16: md: use async_tx and raid5_run_ops for raid5 expansion operations
12/16: md: move raid5 io requests to raid5_run_ops
13/16: md: remove raid5 compute_block and compute_parity5
14/16: dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
	* fix locking bug in iop_adma_alloc_chan_resources, Benjamin
	  Herrenschmidt
	* convert capabilities over to dma_cap_mask_t
15/16: iop13xx: Surface the iop13xx adma units to the iop-adma driver
16/16: iop3xx: Surface the iop3xx DMA and AAU units to the iop-adma driver

(previous release: http://marc.info/?l=linux-raid&m=117463257423193&w=2)
