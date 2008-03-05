Return-Path: <linux-kernel-owner+w=401wt.eu-S934882AbYCEATW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbYCEATW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYCEATE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:19:04 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:24750 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYCEATD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:19:03 -0500
Date: Tue, 4 Mar 2008 17:19:00 -0700
From: Alex Chiang <achiang@hp.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/4] Remove path attribute from sgi_hotplug
Message-ID: <20080305001900.GI3694@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Prarit Bhargava <prarit@redhat.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
	warthog19@eaglescrag.net, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, kristen.c.accardi@intel.com, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	linux-acpi@vger.kernel.org
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080229002640.GB21420@ldl.fc.hp.com> <200803031048.20762.jbarnes@virtuousgeek.org> <47CC4948.7020307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CC4948.7020307@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Prarit Bhargava <prarit@redhat.com>:
>
>>> -	bss_hotplug_slot->name = kmalloc(SN_SLOT_NAME_SIZE, GFP_KERNEL);
>>> -	if (!bss_hotplug_slot->name) {
>>> -		kfree(bss_hotplug_slot->private);
>>> -		return -ENOMEM;
>>> -	}
>>> +	bss_hotplug_slot->name = slot->physical_path;
>>>
>>>  	slot->device_num = device;
>>>  	slot->pci_bus = pci_bus;
>>> -	sprintf(bss_hotplug_slot->name, "%04x:%02x:%02x",
>>> -		pci_domain_nr(pci_bus),
>>> -		((u16)pcibus_info->pbi_buscommon.bs_persist_busnum),
>>> -		device + 1);
>>>
>>>     
>>   
> Ugh ... it has been a while since I've looked at or owned this code ;) -- 
> but I do seem to recall that on SGI boxes the slot's name was different 
> from the physical path of the device (ie, what was stamped on the back of 
> the PCI hotplug chassis was different from Linux' PCI name) -- OTOH, I 
> haven't recently looked at what slot->physical_path has been initialized 
> to, so they might now be one-and-the-same ....

Nope, you are right -- slot->name is quite different from
slot->physical_path.

I'm going to remove this patch from my series since it will
definitely break SGI.

Jesse, Prarit, thanks for the good catch.

/ac

