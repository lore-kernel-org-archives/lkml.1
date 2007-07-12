Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbXGLJKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbXGLJKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759310AbXGLJKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:10:37 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:52462 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbXGLJKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:10:33 -0400
Date: Thu, 12 Jul 2007 12:10:29 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@osdl.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jon Mason <jdmason@gmail.com>
Subject: Re: [PATCH 1/1] x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata
Message-ID: <20070712091029.GH4189@rhun.haifa.ibm.com>
References: <20070711134514.GA4789@rhun.haifa.ibm.com> <1184203051.2693.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184203051.2693.3.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 09:17:31AM +0800, Arjan van de Ven wrote:
> On Wed, 2007-07-11 at 16:45 +0300, Muli Ben-Yehuda wrote:
> > Andi, please consider applying for 2.6.23. Applies on top of the
> > Calgary update I just sent out ("Calgary: more updates for 2.6.23").
> > 
> > This patch introduces struct pci_sysdata to x86 and x86-64, and
> > converts the existing two users (NUMA, Calgary) to use it.
> > 
> > This lays the groundwork for having other users of sysdata, such as
> > the PCI domains work.
> > 
> > The Calgary bits are tested, the NUMA bits just look ok.
> 
> I very much start to dislike the untyped "sysdata"... I much rather
> have separate fields for the different uses (like a IOMMU field)
> that aren't going to share ever. Possibly even typed, but for IOMMU
> that may be tricky....

Could you elaborate on what you mean here?

If you mean instead of hanging a pci_sysdata off of struct pci_bus,
hang a 'void *iommu' and an 'int node' directly off of the pci_bus,
that looks like a lot of churn (most architecture use sysdata as an
opaque pointer to an arch specific structure) and bloat (you would
need to hang off pci_bus everything that is in every arch's use of
sysdata!) for very little type safety.

Cheers,
Muli
