Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYAHRy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYAHRy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYAHRyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:54:21 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41670 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695AbYAHRyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:54:20 -0500
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_*
	routines
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: akepner@sgi.com, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <ada63y4kycs.fsf@cisco.com>
References: <20080108023222.GP23661@sgi.com>
	 <1199809628.3534.34.camel@localhost.localdomain>
	 <ada63y4kycs.fsf@cisco.com>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 11:54:13 -0600
Message-Id: <1199814853.3534.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-08 at 09:42 -0800, Roland Dreier wrote:
> > I'm already on record saying I don't think attributes in the generic
>  > code is the right approach.  All of the attributes I can see adding are
>  > bus specific (even to the extent that PCIe ones wouldn't apply to PCI
>  > for instance).
> 
> I think the case before us that Arthur is dealing with is a
> counterexample for this: there's nothing bus-specific about it all.
> The issue is related to reordering of DMAs within the Altix system
> fabric, after they've left the PCI world.  This issue would be present
> no matter what kind of host bridge you hook up to the system fabric,
> be it PCI-X, PCIe, ISA, MCA or whatever.

But it is: for performance reasons, the Altix boxes have a rather non
standard PCI bridge implementation that gives relaxed ordering on the
PCI bus.  This behaviour was later standardised to some degree in PCIe,
so you could argue they actually have an altix specific PCI bus (PCIa
anyone?).  Regardless, other manufacturers are probably going to demand
something equivalent to this based on the PCIe standard, so we should be
ready for it, hence the desire for the bus specific attributes.

James


