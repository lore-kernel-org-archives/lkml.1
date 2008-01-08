Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYAHSGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYAHSGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYAHSFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:05:53 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:46916 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbYAHSFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:05:52 -0500
X-IronPort-AV: E=Sophos;i="4.24,258,1196668800"; 
   d="scan'208";a="18500209"
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akepner@sgi.com, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_* routines
X-Message-Flag: Warning: May contain useful information
References: <20080108023222.GP23661@sgi.com>
	<1199809628.3534.34.camel@localhost.localdomain>
	<ada63y4kycs.fsf@cisco.com>
	<1199814853.3534.39.camel@localhost.localdomain>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 08 Jan 2008 10:05:44 -0800
In-Reply-To: <1199814853.3534.39.camel@localhost.localdomain> (James Bottomley's message of "Tue, 08 Jan 2008 11:54:13 -0600")
Message-ID: <adawsqkjipz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jan 2008 18:05:44.0854 (UTC) FILETIME=[16B6DB60:01C85221]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I think the case before us that Arthur is dealing with is a
 > > counterexample for this: there's nothing bus-specific about it all.
 > > The issue is related to reordering of DMAs within the Altix system
 > > fabric, after they've left the PCI world.  This issue would be present
 > > no matter what kind of host bridge you hook up to the system fabric,
 > > be it PCI-X, PCIe, ISA, MCA or whatever.

 > But it is: for performance reasons, the Altix boxes have a rather non
 > standard PCI bridge implementation that gives relaxed ordering on the
 > PCI bus.

I don't think this is accurate. As I understand things, the reordering
happens within the Altix system interconnect -- nothing to do with the
PCI bridge hanging off this fabric.  It is "platform" behavior and I
think is properly handled within the dma_ API, which exists to
abstract platforms.

 > This behaviour was later standardised to some degree in PCIe,
 > so you could argue they actually have an altix specific PCI bus (PCIa
 > anyone?).  Regardless, other manufacturers are probably going to demand
 > something equivalent to this based on the PCIe standard, so we should be
 > ready for it, hence the desire for the bus specific attributes.

But:
 a) The Altix has PCI-X, not PCIe, so having something PCIe-specific
    is not a solution for this case; and
 b) the PCIe behavior is opt-in, in the sense that you have to
    specifically ask for looser ordering, while the Altix is loosely
    ordered unless you ask for this "flush" property.  So I don't
    think the same attribute will work for both cases.

 - R.
