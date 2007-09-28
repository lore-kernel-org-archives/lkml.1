Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbXI1BKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbXI1BKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 21:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbXI1BK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 21:10:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51795 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753650AbXI1BKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 21:10:25 -0400
From: akepner@sgi.com
Date: Thu, 27 Sep 2007 18:09:26 -0700
To: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       RolandDreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] allow drivers to flush in-flight DMA v2
Message-ID: <20070928010926.GM30013@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Altix, DMA may be reordered between a device and host memory. 
This reordering can happen in the NUMA interconnect, and it usually 
results in correct operation and improved performance. In some 
situations it may be necessary to explicitly synchronize DMA from 
the device.

This patchset allows a memory region to be mapped with a "dmabarrier". 
Writes to the memory region will cause in-flight DMA to be flushed, 
providing a mechanism to order DMA from a device.

There are 4 patches in this patchset:

  [1/4] dma: add dma_flags_set_dmabarrier() to dma interface
  [2/4] dma: redefine dma_flags_set_dmabarrier() for sn-ia64
  [3/4] dma: document dma_flags_set_dmabarrier()
  [4/4] mthca: allow setting "dmabarrier" on user-allocated memory

-- 
Arthur

