Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbZAKG1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbZAKG1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 01:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZAKG0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 01:26:22 -0500
Received: from sh.osrg.net ([192.16.179.4]:45347 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZAKG0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 01:26:19 -0500
Date: Sun, 11 Jan 2009 15:25:46 +0900
To: joro@8bytes.org
Cc: mchan@broadcom.com, iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/16] DMA-API debugging facility v2
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090109223747.GE9466@8bytes.org>
References: <1231536264.10384.11.camel@HP1>
	<20090109223327.GD9466@8bytes.org>
	<20090109223747.GE9466@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090111150526N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 23:37:47 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> On Fri, Jan 09, 2009 at 11:33:27PM +0100, Joerg Roedel wrote:
> > > This was triggered during pci_unmap_page() -> dma_unmap_single() where
> > > check_unmap() did not find the entry.
> > > 
> > > The original mapping was done in bnx2 using pci_map_page().  I did not
> > > see how the debug entry was added to the hash during the call to
> > > pci_map_page() -> dma_map_page().  Did I miss something?
> > 
> > dma_map_page() results in dma_map_single() -> debug_map_single() call on
> > x86. This way the entry would be added. Maybe the error from a double
> > free?
> 
> Ah, it only calls ops->map_single. Thanks for pointing that out. I will
> add a call to debug_map_single to dma_map_page too. So the error above
> may be a false positive.

Then you will find that the interface of debug_map_single is wrong.
You can't use cpu address here. I explained this to you before:

http://marc.info/?t=123116736500005&r=1&w=2
