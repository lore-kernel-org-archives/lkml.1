Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYHTC1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYHTC1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 22:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYHTC1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 22:27:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47897 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYHTC12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 22:27:28 -0400
Message-ID: <48AB80A3.5090201@jp.fujitsu.com>
Date: Wed, 20 Aug 2008 11:25:39 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH 04/13] PCI: acpiphp: remove 'name' parameter
References: <20080816235504.5461.20733.stgit@blender.achiang> <200808171059.50802.eike-kernel@sf-tec.de> <20080819183908.GD18842@ldl.fc.hp.com> <200808191440.05930.jbarnes@virtuousgeek.org> <20080819235026.GG18842@ldl.fc.hp.com>
In-Reply-To: <20080819235026.GG18842@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Jesse Barnes <jbarnes@virtuousgeek.org>:
>> On Tuesday, August 19, 2008 11:39 am Alex Chiang wrote:
>>> * Rolf Eike Beer <eike-kernel@sf-tec.de>:
>>>> Alex Chiang wrote:
>>>>> +static inline const char *slot_name(struct slot *slot)
>>>>> +{
>>>>> +	return hotplug_slot_name(slot->hotplug_slot);
>>>>> +}
>>>>> +
>>>>>  /*
>>>>>   * struct acpiphp_bridge - PCI bridge information
>>>>>   *
>>>> I don't see a point in this function. Why not call hotplug_slot_name()
>>>> directly?
>>> You're correct that we don't exactly need it in acpiphp. However,
>>> it is a useful helper function for some of the other drivers, and
>>> I thought it would be better to keep consistency if possible.
>>>
>>> Also, it helps later on, when trying to stay below the 80 column
>>> limit. :)
>> If they're all identical, maybe we should pull this up into a
>> common function (with a short name :).  That can be a
>> subsequent cleanup though.
> 
> Ok, I'll save this for next time. Or someone else can have the
> git glory. ;)
> 
>>>>> @@ -84,7 +87,6 @@ static struct hotplug_slot_ops acpi_hotplug_slot_ops
>>>>> = { .get_adapter_status	= get_adapter_status,
>>>>>  };
>>>>>
>>>>> -
>>>>>  /**
>>>>>   * acpiphp_register_attention - set attention LED callback
>>>>>   * @info: must be completely filled with LED callbacks
>>>> Fuzz.
>>> Yes, it's fuzz, but my practice has been to clean up* source files
>>> during the course of making actual, functional changes. Better
>>> than sending a mostly-useless whitespace patchbomb, IMO.
>>>
>>> * Note that "clean up" here means "reasonable cleanup" that
>>>   doesn't detract from reading the rest of the patch.
>> Yeah the main reason for separating whitespace changes from
>> real ones is to avoid making the patch hard to read in case a
>> problem crops up.  Killing an extra newline doesn't make things
>> harder to read, imo, so it's fine with me if you keep it
>> (though if you *do* end up doing a cleanup patch later you
>> could save it for that).
> 
> I'll keep the 'kill the newline' here but drop the kerneldoc
> stuff. As you point out, kerneldoc will take either */ or **/.
> 
>>>>>  	acpiphp_slot->slot = slot;
>>>>> -	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
>>>>> +	memset(name, 0, SLOT_NAME_SIZE);
>>>>> +	snprintf(name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);
>>>> The memset() is not needed at all. And the sizeof is IMHO a good idea
>>>> anyway as it allows to get rid of the define.
>>> Hm, don't need a memset? I won't have garbage on the stack?
>>> </n00b>
>> Yeah, but you'll overwrite it with snprintf anyway, so the memset is 
>> redundant.
> 
> Ok. I went through and removed the superfluous memsets, and
> changed instances of snprintf() to scnprintf().
> 
>>> On the other hand, keeping the #define is important, because
>>> again, that's the established convention of the PCI hotplug
>>> drivers.
>>>
>>> Thanks for the review.
>> Going from the define to sizeof() everywhere could be another
>> cleanup, but I don't have strong feelings about that.
> 
> Ok, saving these for next time too.
> 
> I'll hold off from sending v2 until I hear comments from
> Kenji-san, so if he has any suggestions, I can incorporate them
> all in v2.
> 

Hi Alex-san, and all,

I'm sorry for my delay. I had been on vacation on these days.
I'll review your patches as soon as possible.

Thanks,
Kenji Kaneshige



