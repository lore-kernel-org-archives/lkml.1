Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbYCUUBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbYCUUBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYCUUBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:01:36 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:15003 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYCUUBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:01:35 -0400
Date: Fri, 21 Mar 2008 14:01:33 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/16][BUG] PCI slot: Remove compiler warnings (Not for
	mainline!)
Message-ID: <20080321200133.GM17292@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E33635.5080908@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E33635.5080908@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Remove following compiler warnings.

Merged, thanks.

/ac

> 
> drivers/pci/slot.c: In function 'pci_create_slot':
> drivers/pci/slot.c:146: warning: format '%d' expects type 'int', but argument 4 has type 'atomic_t'
> drivers/pci/slot.c: In function 'pci_destroy_slot':
> drivers/pci/slot.c:198: warning: format '%d' expects type 'int', but argument 4 has type 'atomic_t'
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/pci/slot.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.25-rc6/drivers/pci/slot.c
> ===================================================================
> --- linux-2.6.25-rc6.orig/drivers/pci/slot.c
> +++ linux-2.6.25-rc6/drivers/pci/slot.c
> @@ -142,8 +142,8 @@ struct pci_slot *pci_create_slot(struct 
>  		if (slot->number == slot_nr) {
>  			kobject_get(&slot->kobj);
>  			dbg("%s: bumped refcount to %d on %x:%d\n",
> -				__func__, slot->kobj.kref.refcount,
> -				parent->number, slot_nr);
> +			    __func__, atomic_read(&slot->kobj.kref.refcount),
> +			    parent->number, slot_nr);
>  			goto out;
>  		}
>  	}
> @@ -196,7 +196,8 @@ int pci_destroy_slot(struct pci_slot *sl
>  	up_write(&pci_bus_sem);
>  
>  	dbg("%s: decreased refcount to %d on %x:%d\n", __func__,
> -		slot->kobj.kref.refcount, slot->bus->number, slot->number);
> +	    atomic_read(&slot->kobj.kref.refcount), slot->bus->number,
> +	    slot->number);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(pci_destroy_slot);
> 
> 
