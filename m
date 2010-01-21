Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430Ab0AUVzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0AUVzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865Ab0AUVzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:55:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:56656 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0AUVza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:55:30 -0500
Message-ID: <4B58CCF4.8070008@kernel.org>
Date: Thu, 21 Jan 2010 13:53:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 9/9] pci: set PCI_PREF_RANGE_TYPE_64 in	pci_bridge_check_ranges
References: <1264054456-12694-1-git-send-email-yinghai@kernel.org> <1264054456-12694-10-git-send-email-yinghai@kernel.org> <20100121213226.GI17684@ldl.fc.hp.com>
In-Reply-To: <20100121213226.GI17684@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 01:32 PM, Alex Chiang wrote:
> * Yinghai Lu <yinghai@kernel.org>:
>> make pci_bridge_check_ranges() to store the
>> PCI_PREF_RANGE_TYPE_64 in addition to IORESOURCE_MEM_64. just
>> like pci_read_bridge_bases()
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/setup-bus.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index a9c4f9e..8fafe73 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -359,8 +359,11 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
>>  	}
>>  	if (pmem) {
>>  		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
>> -		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
>> +		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) ==
>> +		    PCI_PREF_RANGE_TYPE_64) {
>>  			b_res[2].flags |= IORESOURCE_MEM_64;
>> +			b_res[2].flags |= PCI_PREF_RANGE_TYPE_64;
here set PCI_PREF_RANGE_TYPE_64 too.
>> +		}
>>  	}
> 
> My copy of pci_read_bridge_bases() in jbarnes's linux-next tree
> doesn't do anything like that.
> 
>  284 void __devinit pci_read_bridge_bases(struct pci_bus *child)
>  285 {
>  ...
>  369         if (base <= limit) {
>  370                 res->flags = (mem_base_lo & PCI_PREF_RANGE_TYPE_MASK) |
>  371                                          IORESOURCE_MEM | IORESOURCE_PREFETCH;
so it could save PCI_PREF_RANGE_TYPE_64 here.
>  372                 if (res->flags & PCI_PREF_RANGE_TYPE_64)
>  373                         res->flags |= IORESOURCE_MEM_64;
>  374                 res->start = base;
>  375                 res->end = limit + 0xfffff;
>  376                 dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
>  377         }

YH
