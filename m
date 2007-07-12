Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbXGLJRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbXGLJRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbXGLJRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:17:06 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:64678 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbXGLJRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:17:03 -0400
Date: Thu, 12 Jul 2007 12:17:00 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@osdl.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jon Mason <jdmason@gmail.com>
Subject: Re: [PATCH 1/1] x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata
Message-ID: <20070712091700.GL4189@rhun.haifa.ibm.com>
References: <20070711134514.GA4789@rhun.haifa.ibm.com> <1184203051.2693.3.camel@laptopd505.fenrus.org> <20070712091029.GH4189@rhun.haifa.ibm.com> <1184231585.2720.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184231585.2720.8.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 05:13:05PM +0800, Arjan van de Ven wrote:

> > > I very much start to dislike the untyped "sysdata"... I much
> > > rather have separate fields for the different uses (like a IOMMU
> > > field) that aren't going to share ever. Possibly even typed, but
> > > for IOMMU that may be tricky....
> > 
> > Could you elaborate on what you mean here?
> > 
> > If you mean instead of hanging a pci_sysdata off of struct
> > pci_bus, hang a 'void *iommu' and an 'int node' directly off of
> > the pci_bus,
> 
> yes that is what I mean.
> 
> > that looks like a lot of churn (most architecture use sysdata as
> > an opaque pointer to an arch specific structure) and bloat (you
> > would
> 
> it's only a few bytes per pci device/bus. not all that bad for
> having something which involves splitting a shared pointer into
> logical users.
> 
> (and heck, if you really really are worried we could make it a union
> for some of them, although that defeats the "split is safer"
> benefit)

It's not just bloat and code churn, I also don't like teaching every
architecture about every other architecture's use of sysdata, which is
inherently architecture specific. I think the benefits of modularity
here outweigh the benefits of a little type safety.

Cheers,
Muli
