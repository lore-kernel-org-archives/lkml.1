Return-Path: <linux-kernel-owner+w=401wt.eu-S1763700AbXFAThU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763700AbXFAThU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762517AbXFAThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:37:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53209 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762520AbXFAThF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:37:05 -0400
Date: Fri, 1 Jun 2007 21:37:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, andrew.vasquez@qlogic.com
Subject: Re: [PATCH] quiet down swiotlb warnings
Message-ID: <20070601193703.GI7217@one.firstfloor.org>
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de> <20070601181225.GA16460@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601181225.GA16460@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 07:12:25PM +0100, Christoph Hellwig wrote:
> On Fri, Jun 01, 2007 at 09:01:45PM +0200, Andi Kleen wrote:
> > Bad idea imho. swiotlb mappings should always lead to printk by default
> > because it is pretty dangerous.
> > 
> > One possible solution for this I could think of would be to define a
> > new pci_map_sg_couldfail() or similar that doesn't warn and use a weak
> > fallback just calling pci_map_sg on other IOMMU implementations. 
> 
> pci_map_sg is defined to be failing when running out of ressources, which
> is perfectly fine.  We don't printk on kmalloc failures either (actually

Actually we do as you point out.

> in some cases which is highly annoying and leads people to stick a
> __GFP_NOWARN into various places)

An pci_map_sg failing typically leads to an IO error and we've
always printk'ed those. Otherwise people will wonder why they
get EIO.

-Andi
