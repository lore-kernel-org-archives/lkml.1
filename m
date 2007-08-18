Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbXHRA2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbXHRA2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 20:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbXHRA2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 20:28:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40604 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757442AbXHRA2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 20:28:22 -0400
From: akepner@sgi.com
Date: Fri, 17 Aug 2007 17:27:27 -0700
To: linux-kernel@vger.kernel.org
Cc: jes@sgi.com, rdreier@cisco.com
Subject: [PATCH 0/3] allow drivers to flush in-flight DMA
Message-ID: <20070818002727.GS1813@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Altix supports "posted DMA", so that DMA may complete out 
of order. In some cases it's necessary for a driver to 
ensure that in-flight DMA has been flushed to memory for 
correct operation.

In particular this can be a problem with Infiniband, where 
writes to Completion Queues can race with DMA of data.

The following patchset addresses this problem by allowing a 
memory region to be mapped with a "barrier" attribute. (On 
Altix, writes to memory regions with the barrier attribute 
have the side effect that in-flight DMA gets flushed to host 
memory.)

There are three patches in this set:

[1/3] dma: introduce no-op stub "dma_flags_set_dmaflush"
[2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
[3/3] dma: use dma_flags_set_dmaflush in ib_umem_get 
      (mthca only, for now)

-- 
Arthur

