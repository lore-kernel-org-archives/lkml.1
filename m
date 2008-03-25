Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbYCYDcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbYCYDcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 23:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbYCYDbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 23:31:37 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:37478 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbYCYDbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 23:31:36 -0400
Date: Mon, 24 Mar 2008 21:31:35 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 15/16] PCI slot: Trivial cleanups for slot.c (Not for
	mainline!)
Message-ID: <20080325033135.GD26434@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E3390A.7030308@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E3390A.7030308@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Some trivial cleanups for drivers/pci/slot.c.

Thanks, merged.

/ac

> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/pci/slot.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.25-rc6/drivers/pci/slot.c
> ===================================================================
> --- linux-2.6.25-rc6.orig/drivers/pci/slot.c
> +++ linux-2.6.25-rc6/drivers/pci/slot.c
> @@ -132,19 +132,16 @@ EXPORT_SYMBOL_GPL(pci_destroy_slot);
>  
>  static int pci_slot_init(void)
>  {
> -	int result = 0;
>  	struct kset *pci_bus_kset;
>  
>  	pci_bus_kset = bus_get_kset(&pci_bus_type);
> -
>  	pci_slots_kset = kset_create_and_add("slots", NULL,
>  						&pci_bus_kset->kobj);
>  	if (!pci_slots_kset) {
> -		result = -ENOMEM;
> -		printk(KERN_ERR "PCI: Slot initialization failure (%d)\n",
> -			result);
> +		printk(KERN_ERR "PCI: Slot initialization failure\n");
> +		return -ENOMEM;
>  	}
> -	return result;
> +	return 0;
>  }
>  
>  subsys_initcall(pci_slot_init);
> 
> 
