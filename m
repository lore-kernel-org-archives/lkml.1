Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbXH0WGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbXH0WGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXH0WGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:06:09 -0400
Received: from colo.lackof.org ([198.49.126.79]:59936 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbXH0WGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:06:07 -0400
Date: Mon, 27 Aug 2007 16:05:48 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: akepner@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de, James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] pci: let devices flush DMA to host memory
Message-ID: <20070827220548.GB22484@colo.lackof.org>
References: <20070824180232.GP5592@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824180232.GP5592@sgi.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 11:02:32AM -0700, akepner@sgi.com wrote:
> 
> On Altix, DMA may be reordered within the NUMA interconnect. 
> This can be a problem with Infiniband, where DMA to Completion 
> Queues can race with data DMA. This patchset allows a driver 
> to associate a memory region with a "dmaflush" attribute, so 
> that writes to the memory region flush in-flight DMA, preventing 
> the CQ/data race.

FYI to linux-pci folks
This patch had previous discussion on LKML:
    http://lkml.org/lkml/2007/8/17/336

James Bottomley at one point obliquely referred to
my OLS2003 paper: "DMA Hints on ia64/PARISC"

After reading the thread, my take is we need a more elegant way for a
device driver to handle registration of DMA regions allocated by user
space. The API would "make this page/region act like dma_alloc_coherent()".
That implies strong ordering between CPU and DMA to/from the device.
Maybe the code is the right thing and I want a name that makes
sense in the context of current DMA API.

On IRC, willy suggested an mmap() flag and that sounds reasonable too
though I don't know if it's feasible. 

hth,
grant

> There are three patches in this set:
> 
> 	[1/3]: add pci_dma_flags_set_dmaflush() to pci interface
> 	[2/3]: redefine pci_dma_flags_set_dmaflush() for sn-ia64
> 	[3/3]: document pci_dma_flags_set_dmaflush()
> 
> And there would be additional patches to IB drivers to make use 
> of the interface, of course. 
> 
> -- 
> Arthur
