Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXI1XPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXI1XPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbXI1XPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:15:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61176 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbXI1XPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:15:09 -0400
Message-ID: <46FD8907.6000304@oracle.com>
Date: Fri, 28 Sep 2007 16:06:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Maarten Bressers <mbres@gentoo.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: On Fri, 28 Sep 2007 14:48:53 -0700
References: <20070928224945.3E6D36519C@smtp.gentoo.org>
In-Reply-To: <20070928224945.3E6D36519C@smtp.gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten Bressers wrote:
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Fri, 28 Sep 2007 20:56:30 +0000 (UTC) Maarten Bressers wrote:
>>
>>> This (trivial) patch fixes two compiler warnings for 2.6.23-rc8 on x86_64,
>>> use of deprecated function pci_find_device() and a section mismatch.
>>> Build log and .config file included.

>>> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
>>> index c6e79d0..0eb7e9e 100644
>>> --- a/drivers/pci/search.c
>>> +++ b/drivers/pci/search.c
>>> @@ -96,7 +96,7 @@ pci_find_slot(unsigned int bus, unsigned int devfn)
>>>  {
>>>  	struct pci_dev *dev = NULL;
>>>  
>>> -	while ((dev = pci_find_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
>>> +	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
>>>  		if (dev->bus->number == bus && dev->devfn == devfn)
>>>  			return dev;
>>>  	}
>>> @@ -434,8 +434,6 @@ int pci_dev_present(const struct pci_device_id *ids)
>>>  EXPORT_SYMBOL(pci_dev_present);
>>>  EXPORT_SYMBOL(pci_find_present);
>>>  
>>> -EXPORT_SYMBOL(pci_find_device);
>>> -EXPORT_SYMBOL(pci_find_slot);
>> There are still about 30 and 14 respetively users of pci_find_devic()
>> and pci_find_slot() in 2.6.23-rc8.  Will you be fixing them?
>>
> I'm attaching a patch here that I think will clean up all uses of 
> pci_find_device(), except one in drivers/net/skfp/drvfbi.c:1248. I'm not 
> sure what to make of that one, do you have any suggestions?
> 
> Is this patch what you had in mind, Randy? Any comments are appreciated.

It's more than a simple s/pci_find_device/pci_get_device/g patch.

pci_find_device() didn't use any reference counting, but pci_get_device()
does.  Then when the resource use is finished, it must be released
properly.

>>>  /* For boot time work */
>>>  EXPORT_SYMBOL(pci_find_bus);
>>>  EXPORT_SYMBOL(pci_find_next_bus);
>> ---

-- 
~Randy
Phaedrus says that Quality is about caring.

