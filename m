Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXHFVnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXHFVnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXHFVnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:43:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:55769 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbXHFVnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:43:45 -0400
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit
	DMA	mapping"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olaf Hering <olh@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Robert Hancock <hancockr@shaw.ca>, linuxppc-dev@ozlabs.org,
       stable@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070806115804.GA1734@suse.de>
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
	 <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de>
	 <1186272926.938.8.camel@localhost.localdomain>
	 <46B5824B.1000103@s5r6.in-berlin.de>  <20070806115804.GA1734@suse.de>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 07:43:17 +1000
Message-Id: <1186436597.938.71.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 13:58 +0200, Olaf Hering wrote:
> On Sun, Aug 05, Stefan Richter wrote:
> 
> > Benjamin Herrenschmidt wrote:
> > >>> If setting 32-bit DMA mask fails on ppc64, that sounds like a problem
> > >>> with the DMA implementation on that architecture. There are enough cards
> > >>> out there that only support 32-bit DMA that this really needs to work..
> > >> Yes, could the PPC folks please have a look at it?  Thanks.
> > > 
> > > Smells like we may have a bug there. No worries though, all current PPC
> > > machines have an iommu that will not give out addresses above 32 bits
> > > anyway, but I'll double check what's up.
> > > 
> > > Do you see something in dmesg when that happens ?
> > 
> > There was nothing in Olaf's report, except for trouble in sbp2 _after_
> > the failure.  http://lkml.org/lkml/2007/8/1/344  (I don't have a PMac.)
> 
> sbp2util_remove_command_orb_pool() does not check for lu->hi being NULL.
> 
> dev->dma_mask is NULL too, thats why dma_direct_dma_supported() returns
> false, and dma_set_mask() will return -EIO.

Strange... PCI devices should never have a NULL dma mask. I wonder how
we get there... 

Ben.


