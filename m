Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYI3CJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYI3CJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 22:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYI3CJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 22:09:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52882 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYI3CJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 22:09:01 -0400
Message-ID: <48E189BF.4020907@jp.fujitsu.com>
Date: Tue, 30 Sep 2008 11:06:55 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v3 02/14] PCI: prevent duplicate slot names
References: <20080923163753.12628.98683.stgit@bob.kio> <20080923164523.12628.69510.stgit@bob.kio> <48E09936.2030905@jp.fujitsu.com>
In-Reply-To: <48E09936.2030905@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems my previous e-mail was not sent properly. So resending it.

Thanks,
Kenji Kaneshige

Kenji Kaneshige wrote:
> Hi Alex-san,
> 
> Here is one comment, though I have not finished reviewing/testing
> your patches yet (sorry for the delay).
> 
> Alex Chiang wrote:
> 
> (snip.)
> 
>> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c 
>> b/drivers/pci/hotplug/pci_hotplug_core.c
>> index 3e37d63..46802dc 100644
>> --- a/drivers/pci/hotplug/pci_hotplug_core.c
>> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
>> @@ -570,39 +570,32 @@ int pci_hp_register(struct hotplug_slot *slot, 
>> struct pci_bus *bus, int slot_nr,
>>          return -EINVAL;
>>      }
>>  
>> -    /* Check if we have already registered a slot with the same name. */
>> -    if (get_slot_from_name(name))
>> -        return -EEXIST;
>> -
>>      /*
>> -     * No problems if we call this interface from both ACPI_PCI_SLOT
>> -     * driver and call it here again. If we've already created the
>> -     * pci_slot, the interface will simply bump the refcount.
>> +     * Look for existing slot. If we find it, and it was created by a
>> +     * slot detection driver (ie, doesn't have a ->hotplug()) then we
>> +     * allow the hotplug driver calling us to rename the slot if 
>> desired.
>> +     *
>> +     * Otherwise, create the slot and carry on with life.
>>       */
>> -    pci_slot = pci_create_slot(bus, slot_nr, name);
>> -    if (IS_ERR(pci_slot))
>> -        return PTR_ERR(pci_slot);
>> -
>> -    if (pci_slot->hotplug) {
>> -        dbg("%s: already claimed\n", __func__);
>> -        pci_destroy_slot(pci_slot);
>> -        return -EBUSY;
>> +    pci_slot = pci_get_pci_slot(bus, slot_nr);
> 
> The pci_get_pci_slot() function refers pci_bus->slots list, so it
> should be called with pci_bus_sem semaphore held as pci_create_slot()
> does, or pci_bus_sem semaphore should be held by pci_get_pci_slot()
> itself.
> 
> Thanks,
> Kenji Kaneshige
> 


