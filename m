Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbZC3Qqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbZC3Qqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZC3QqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:46:20 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:17666 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZC3QqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:46:20 -0400
Date: Mon, 30 Mar 2009 10:45:42 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/3] PCI: pci_slot: grab refcount on slot's bus
Message-ID: <20090330164542.GC30433@ldl.fc.hp.com>
References: <20090329165352.29073.5159.stgit@bob.kio> <20090329165454.29073.1180.stgit@bob.kio> <49D02DAD.2040607@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D02DAD.2040607@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
> > diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
> > index cd1f446..c7ad9f2 100644
> > --- a/drivers/acpi/pci_slot.c
> > +++ b/drivers/acpi/pci_slot.c
> > @@ -63,6 +63,7 @@ struct acpi_pci_slot {
> >  	acpi_handle root_handle;	/* handle of the root bridge */
> >  	struct pci_slot *pci_slot;	/* corresponding pci_slot */
> >  	struct list_head list;		/* node in the list of slots */
> > +	struct pci_bus *bus;		/* bus the slot is on */
> >  };
> 
> I don't think we need an additional 'bus' field in the struct
> acpi_pci_slot. At the register_slot(), we already know the
> address of struct pci_bus. At the acpi_pci_slot_remove(), I
> think we can get the address of struct pci_bus as follows.
> 
> 		if (slot->root_handle == handle) {
> 			struct pci_bus *pbus = slot->pci_slot->bus;
> 			list_del(&slot->list);
> 			pci_destroy_slot(slot->pci_slot);
> 			put_device(&pbus->dev);
> 			kfree(slot);
> 		}

Ok, that is a little cleaner, I'll do it your way.

Thanks for the review.

/ac

