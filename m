Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbXJCCoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbXJCCoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbXJCCoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:44:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50616 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753551AbXJCCoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:44:38 -0400
From: akepner@sgi.com
Date: Tue, 2 Oct 2007 19:43:38 -0700
To: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       RolandDreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] allow drivers to flush in-flight DMA v3
Message-ID: <20071003024338.GE26752@sgi.com>
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

There are 5 patches in this patchset:

  [1/5] dma: add dma_flags_set_attr() to dma interface
  [2/5] dma: redefine dma_flags_set_attr() for sn-ia64
  [3/5] dma: document dma_flags_set_attr()
  [4/5] infiniband: add "dmabarrier" argument to ib_umem_get()
  [5/5] mthca: allow setting "dmabarrier" on user-allocated memory

-- 
Arthur

