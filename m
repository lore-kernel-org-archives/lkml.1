Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbXIYX7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbXIYX7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXIYX7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:59:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60252 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751118AbXIYX7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:59:44 -0400
From: akepner@sgi.com
Date: Tue, 25 Sep 2007 16:58:43 -0700
To: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] allow drivers to flush in-flight DMA
Message-ID: <20070925235843.GK30013@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This is a followup to http://lkml.org/lkml/2007/8/24/280

Despite Grant's desire for a more elegant solution, there's 
not much new here. I moved the API change from pci.h to 
dma-mapping.h and removed the pci_ prefix from the name. 

Problem Description
-------------------
On Altix, DMA may be reordered within the NUMA interconnect.
This can be a problem with Infiniband, where DMA to Completion Queues 
allocated in user-space can race with data DMA. This patchset allows 
a driver to associate a user-space memory region with a "dmaflush" 
attribute, so that writes to the memory region flush in-flight DMA, 
preventing the CQ/data race.

There are four patches in this set:

  [1/4] dma: add dma_flags_set_dmaflush() to dma interface
  [2/4] dma: redefine dma_flags_set_dmaflush() for sn-ia64
  [3/4] dma: document dma_flags_set_dmaflush()
  [4/4] mthca: allow setting "dmaflush" attribute on user-allocated memory

