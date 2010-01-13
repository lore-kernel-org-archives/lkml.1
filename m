Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678Ab0AMO7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0AMO7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599Ab0AMO7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:59:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab0AMO7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:59:48 -0500
Message-ID: <4B4DDFD3.5050700@redhat.com>
Date: Wed, 13 Jan 2010 08:59:31 -0600
From: David Milburn <dmilburn@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20081113)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
       Seth Heasley <seth.heasley@intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel
 Cougar Point DeviceIDs
References: <201001121700.18234.seth.heasley@intel.com> <4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
In-Reply-To: <4B4DAA68.60608@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> On 01/12/2010 11:40 PM, Robert Hancock wrote:
>> On 01/12/2010 07:00 PM, Seth Heasley wrote:
>>> This patch adds the Intel Cougar Point (PCH) SATA AHCI and RAID
>>> Controller DeviceIDs.
>>>
>>> Signed-off-by: Seth Heasley<seth.heasley@intel.com>
>>>
>>> --- linux-2.6.32.3/drivers/ata/ahci.c.orig 2010-01-06
>>> 15:07:45.000000000 -0800
>>> +++ linux-2.6.32.3/drivers/ata/ahci.c 2010-01-07 13:55:23.000000000 
>>> -0800
>>> @@ -560,6 +560,12 @@
>>> { PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
>>> { PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
>>> { PCI_VDEVICE(INTEL, 0x3b2f), board_ahci }, /* PCH AHCI */
>>> + { PCI_VDEVICE(INTEL, 0x1c02), board_ahci }, /* CPT AHCI */
>>> + { PCI_VDEVICE(INTEL, 0x1c03), board_ahci }, /* CPT AHCI */
>>> + { PCI_VDEVICE(INTEL, 0x1c04), board_ahci }, /* CPT RAID */
>>> + { PCI_VDEVICE(INTEL, 0x1c05), board_ahci }, /* CPT RAID */
>>> + { PCI_VDEVICE(INTEL, 0x1c06), board_ahci }, /* CPT RAID */
>>> + { PCI_VDEVICE(INTEL, 0x1c07), board_ahci }, /* CPT RAID */
>>>
>>> /* JMicron 360/1/3/5/6, match class to avoid IDE function */
>>> { PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>>
>> The RAID mode entries would be needed if the device indicates RAID class
>> in that mode, but in plain AHCI mode it should indicate SATA AHCI class
>> which will get picked up by this catch-all so those entries shouldn't be
>> needed:
>>
>> /* Generic, PCI class code for AHCI */
>> { PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>> PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
>>
>> Likely a lot of the existing specific PCI IDs could be removed from the
>> driver because of this (many likely predate the addition of the
>> class-based catch-all). The only reason to need a specific entry if the
>> device uses AHCI class is if it needs special handling or workarounds,
>> which isn't the case here.
> 
> Well, two lines of thinking here:
> 
> * some of lines of Intel chips do not separate AHCI into a separate PCI 
> ID rather legacy IDE interface.  When an AHCI interface exists and 
> AHCI/IDE share the same PCI ID, we default to using AHCI.  Thus, some of 
> those PCI ID matches in ahci.c's PCI table may not get caught by the 
> generic PCI class match at the end of the table.
> 
> * the cost carrying redundant PCI IDs seems low, harmless, and 
> potentially helpful.

It is helpful for the specific device IDs to show up in "modinfo ahci" and
modules.pcimap.

David

> 
> Comments welcome, though...
> 
>     Jeff
> 
> 
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

