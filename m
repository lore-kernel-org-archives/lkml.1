Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYG3CwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYG3CwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759376AbYG3Cqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:46:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59979 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322AbYG3Cqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:46:34 -0400
Message-ID: <488FD59B.4080302@jp.fujitsu.com>
Date: Wed, 30 Jul 2008 11:44:43 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Kristen Accardi <kristen.c.accardi@intel.com>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807280916.44664.jbarnes@virtuousgeek.org> <488E83E9.6030108@jp.fujitsu.com> <200807290814.33098.jbarnes@virtuousgeek.org>
In-Reply-To: <200807290814.33098.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, July 28, 2008 7:43 pm Kenji Kaneshige wrote:
>>> Your systems don't have _RMV methods for the hotpluggable PCIe slots in
>>> the DSDT?  That's a shame; the Windows docs I found on PCIe hotplug
>>> seemed to indicate that _RMV and _OSC (under Vista) were used to detect
>>> whether a given slot was hot pluggable (I just googled for "windows pcie
>>> hotplug" or something) so I was hoping that would be a reliable method...
>>>  Any other ideas?  I'll go see if I can dig up some ExpressCard info.
>> My systems don't have _RMV methods for the hot pluggable PCIe slots in the
>> DSDT, but I don't think that's a shame. I suppose that the document you are
>> referring describes how Windows handles ExpressCard slots. In my
>> understanding, Hot Plug Surprise bit in the Slot Capabilities register is
>> set to 1b on ExpressCard slots, and I believe that ACPI _RVM method is for
>> the device that only supports surprise-style removal. I think this is why
>> your system implements _RMV method for slots.
> 
> Yeah, that may be.  The document wasn't very clear; I was hoping that 
> something simple would be available.
> 
>> On the other hand, hot pluggable slots on my servers are *not* ExpressCard
>> slots, and all of them have Power Controller instead of surprise-style
>> removal (Hot Plug Surprise bit in the Slot Capabilities register is set to
>> 0b). So I believe there is no reason to implement _RMV methods for the hot
>> pluggable PCIe slots on my systems.
>>
>> Here is an idea. How about using _RMV method to determine whether a given
>> slot is actually hot pluggable when Hot Plug Surprise bit in the Slot
>> Capabilities register is set to 1b on the slot? This is based on a little
>> rough assumption that all PCIe slots that support surprise-style removal
>> have _RMV method, though. Does this work for you?
> 
> It's worth a try.  We need *some* sort of better method to detect hot 
> pluggable slots...

OK. I'll try to make a patch.

According to PCI Express and PCI firmware spec, I think Hot Plug Capable
bit in the Slot Capabilities register and ACPI _OSC are enough to detect
hot pluggable slots. But I might be missing something especially about
ExpressCard, or BIOS is just broken...

Thanks,
Kenji Kaneshige


