Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbYCUEJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbYCUEJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbYCUEJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:09:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38679 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYCUEJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:09:02 -0400
Message-ID: <47E33472.1000602@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:07:14 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/3, v10] PCI, ACPI: Physical PCI slot objects
References: <20080318210539.GA30421@ldl.fc.hp.com>
In-Reply-To: <20080318210539.GA30421@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san, Greg-san,

I've reviewed and tested the latest version of Alex's "introduce
pci_slot" series with DMI table entry for Fujitsu PRIMEQUEST added
on our PRIMEQUEST server that has both SHPC and PCI-Ex based hotplug
slots. And I confirmed invalid slot ('1023') problem was solved
and slot names were overridden with hotplug drivers as we want.
But on the other hand, I found some bugs and some codes need to
be changed. So I would like Alex-san to fix those. I made patches
for each of those. Could you consider adding or merging my patches
to your patch series? My patches are as follows. Please see the
header of each patch for details. Those are on top of your three
patches.

- [PATCH  1/16][BUG] Export kobject_rename for pci_hotplug_core (Not for mainline!)
- [PATCH  2/16] ACPI pci_slot: Fix dmi table for Fujitsu PRIMEQUEST (Not for mainline!)
- [PATCH  3/16][BUG] ACPI pci_slot: Fix _STA evaluation (Not for mainline!)
- [PATCH  4/16][BUG] PCI slot: Add missing semaphore for slot release (Not for mainline!)
- [PATCH  5/16] PCI slot: Use list_head for pci slot list (Not for mainline!)
- [PATCH  6/16][BUG] ACPI pci_slot: Fix slot removal path (Not for mainline!)
- [PATCH  7/16][BUG] PCI slot: Remove compiler warnings (Not for mainline!)
- [PATCH  8/16][BUG] PCI slot: Fix invalid memory access (Not for mainline!)
- [PATCH  9/16] PCI slot: Remove unused slot member from pci_dev (Not for mainline!)
- [PATCH 10/16] PCI slot: Replace dbg with pr_debug (Not for mainline!)
- [PATCH 11/16] PCI slot: Remove useless release handler (Not for mainline!)
- [PATCH 12/16] PCI slot: Use .default_attrs for address file (Not for mainline!)
- [PATCH 13/16] PCI slot: Fix return value of pci_create_slot() (Not for mainline!)
- [PATCH 14/16] PCI slot: Change return value of pci_destroy_slot() (Not for mainline!)
- [PATCH 15/16] PCI slot: Trivial cleanups for slot.c (Not for mainline!)
- [PATCH 16/16][BUG] PCI hotplug core: add missing lock for hotplug slot list (Not for mainline!)

BTW, I've posted other patches to fix the slot name of shpchp/pciehp
to pcihpd-discuss mailing-list. Please see it also.

Thanks,
Kenji Kaneshige




Alex Chiang wrote:
> Hi Greg, Kenji-san,
> 
> This is v10 of my "introduce pci_slot" series, to be considered
> for inclusion in linux-next to get more test exposure and shake
> out the bugs.
> 
> * Greg KH <gregkh@suse.de>:
>> Can you work with Kenji to get his approval on this before I
>> add this to the tree?  It sounds like there are still some
>> outstanding issues getting this to work properly on his
>> hardware.  It needs to work without relying on a module not
>> being loaded, as the distros are never going to go for that
>> kind of solution.
> 
> New in v10 is the addition of a DMI list to do the right thing on
> Fujitsu hardware, and does not rely on "don't load the module" to
> get the correct behavior.
> 
> Also, v10 should fix the "pci_slot module changes the sysfs name"
> issue that Kenji-san was seeing.
> 
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> Alex-san, could you send me the updated patches? I'll Ack the
>> patch after adding Fujitsu firmware versions to the DMI list
>> and testing it.
> 
> Thanks, I'd like to know if the naming issue is fixed for you as
> well.
> 
> cheers,
> 
> /ac
> 
> 
> 


