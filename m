Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXHXSDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXHXSDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763130AbXHXSDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:03:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60746 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762440AbXHXSDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:03:35 -0400
From: akepner@sgi.com
Date: Fri, 24 Aug 2007 11:02:32 -0700
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Cc: gregkh@suse.de, James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 0/3] pci: let devices flush DMA to host memory
Message-ID: <20070824180232.GP5592@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Altix, DMA may be reordered within the NUMA interconnect. 
This can be a problem with Infiniband, where DMA to Completion 
Queues can race with data DMA. This patchset allows a driver 
to associate a memory region with a "dmaflush" attribute, so 
that writes to the memory region flush in-flight DMA, preventing 
the CQ/data race.

There are three patches in this set:

	[1/3]: add pci_dma_flags_set_dmaflush() to pci interface
	[2/3]: redefine pci_dma_flags_set_dmaflush() for sn-ia64
	[3/3]: document pci_dma_flags_set_dmaflush()

And there would be additional patches to IB drivers to make use 
of the interface, of course. 

-- 
Arthur

