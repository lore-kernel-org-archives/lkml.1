Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbYFJVUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbYFJVUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbYFJVTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:19:51 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:19772 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbYFJVTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:19:50 -0400
Date: Tue, 10 Jun 2008 15:19:47 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4, v14] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080610211947.GI25295@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	kristen.c.accardi@intel.com, greg@kroah.com, lenb@kernel.org,
	pbadari@us.ibm.com, linux-pci@vger.kernel.org,
	pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080604200829.GC379@ldl.fc.hp.com> <484DEF46.7080106@jp.fujitsu.com> <484DF11A.7000306@jp.fujitsu.com> <200806101224.19455.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806101224.19455.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Monday, June 09, 2008 8:12 pm Kenji Kaneshige wrote:
> > >  drivers/pci/hotplug/pci_hotplug_core.c |   16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > >
> > > Index: 20080610/drivers/pci/hotplug/pci_hotplug_core.c
> > > ===================================================================
> > > --- 20080610.orig/drivers/pci/hotplug/pci_hotplug_core.c
> > > +++ 20080610/drivers/pci/hotplug/pci_hotplug_core.c
> > > @@ -555,6 +555,7 @@ int pci_hp_register(struct hotplug_slot
> > >  {
> > >  	int result;
> > >  	struct pci_slot *pci_slot;
> > > +	struct hotplug_slot *tmp;
> > >
> > >  	if (slot == NULL)
> > >  		return -ENODEV;
> > > @@ -567,6 +568,21 @@ int pci_hp_register(struct hotplug_slot
> > >  	}
> > >
> > >  	/*
> > > +	 * Prevent registering multiple hotplug slots with the same name.
> > > +	 */
> > > +	spin_lock(&pci_hotplug_slot_list_lock);
> > > +	list_for_each_entry(tmp, &pci_hotplug_slot_list, slot_list) {
> > > +		pci_slot = tmp->pci_slot;
> > > +		if (pci_slot->bus == bus && pci_slot->number == slot_nr)
> > > +			continue;
> > > +		if (!strcmp(tmp->name, slot->name)) {
> > > +			spin_unlock(&pci_hotplug_slot_list_lock);
> > > +			return -EEXIST;
> > > +		}
> > > +	}
> > > +	spin_unlock(&pci_hotplug_slot_list_lock);
> > > +
> > > +	/*
> > >  	 * No problems if we call this interface from both ACPI_PCI_SLOT
> > >  	 * driver and call it here again. If we've already created the
> > >  	 * pci_slot, the interface will simply bump the refcount.
> >
> > Please note that I made this patch against linux-next with your
> > latest three patches applied.
> 
> I looked this over and it seems like it's already handled in Alex's latest 
> patchset (v15); can you take a look and make sure, Kenji-san (see Alex's 
> latest mail to you too).

I am about to send out a v16, which is based off of Jesse's
pci-2.6 tree, linux-next branch.

It would be good to verify that latest patchset.

Thanks,

/ac

> I just need acks from you and Kristen before pushing this...
> 
> Thanks,
> Jesse
> 
