Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbYDSGic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbYDSGic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 02:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYDSGiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 02:38:10 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:22711 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYDSGiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 02:38:09 -0400
Date: Sat, 19 Apr 2008 00:38:07 -0600
From: Alex Chiang <achiang@hp.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
Message-ID: <20080419063807.GB12987@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
	linux-kernel@vger.kernel.org
References: <20080404180518.GA12642@ldl.fc.hp.com> <1207340371.5916.23.camel@badari-desktop> <20080404224227.GA31436@ldl.fc.hp.com> <1207352128.5916.26.camel@badari-desktop> <20080407234255.GA22514@ldl.fc.hp.com> <20080416031712.GB3333@ldl.fc.hp.com> <1208331916.6958.270.camel@pasglop> <20080416171127.GA18290@ldl.fc.hp.com> <20080416130343.a82702f0.akpm@linux-foundation.org> <1208384185.6958.304.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208384153.6958.302.camel@pasglop> <1208384185.6958.304.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

* Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> 
> > The basic idea, which I keep botching on pSeries, is that when we
> > make a call to pci_hp_register, we now need to pass it:
> > 
> > pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
> > 
> > I am having trouble figuring out the slot_nr argument. Basically,
> > I want to get the devfn of the slot we're looking at.
> 
> I haven't looked in details yet, but I can already tell that things on
> pSeries aren't that simple because we don't necessarily know in advance
> about "slots"...
>
> When you add a physical PCI device to a partition, things can range from:
> 
>  - A device gets added to an existing bridge (ie. slot)
>  - A whole P2P brigde gets added with that device below it (that's a slot too)
>  - A whole PCI host bridge gets added with that device below it (or with
>    a P2P bridge below it and the device below that).
> 
> In the later case, it's hard to have any concept of slot since you don't
> know anything about the host bridge before it gets added to your partition :-)
> 
> So I'm not sure how much we can use of your slot infrastructure, I'll have
> to look, I suspect it can cover some cases but not all of them.

*poke*

Any update on this?

Anything I can do to help?

> On Wed, 2008-04-16 at 13:03 -0700, Andrew Morton wrote:
> > 
> > fwiw, http://userweb.kernel.org/~akpm/bh.gz (agains -rc9) contains all
> > of
> > -mm up to and including
> > pci-hotplug-acpi-pci-slot-detection-driver.patch
> > and is suitable for review/repair/etc.
> 
> Ok, I'll use that.

Thanks,

/ac

