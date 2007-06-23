Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXFWLJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXFWLJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbXFWLJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:09:33 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:17016 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbXFWLJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:09:32 -0400
Date: Sat, 23 Jun 2007 04:09:28 -0700
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART in shutdown
Message-ID: <20070623110928.GF4441@rhun.cust.hotspot.t-mobile.com>
References: <200706221219.16243.yinghai.lu@sun.com> <200706221934.59966.yinghai.lu@sun.com> <20070623103947.GA4441@rhun.cust.hotspot.t-mobile.com> <200706231259.17946.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706231259.17946.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 12:59:17PM +0200, Andi Kleen wrote:
> 
> > I'm going to need exactly the same hook fro Calgary, as well Intel for
> > VT-d, and AMD for their upcoming IOMMU, etc. How about we do
> > 
> > struct iommu_ops {
> >   struct dma_ops {
> >     ...
> >   }
> >   void (*shutdown)(void);
> > }
> > 
> > And then pci_iommu_shutdown() becomes
> > 
> > if (iommu_ops->shutdown)
> >   iommu_ops->shutdown();
> 
> I think it's cleaner if everybody registers their own shutdown
> handler in sysfs Don't see any value in going through a generic
> layer because there is no shared code.

Going through the shared layer makes it obvious to new IOMMU
implementers that they will need to implement a shutdown hook and
takes roughly the same ammount of work. I think that's a net win.

Cheers,
Muli
