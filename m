Return-Path: <linux-kernel-owner+w=401wt.eu-S1764010AbXGNAzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764010AbXGNAzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 20:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759631AbXGNAzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 20:55:13 -0400
Received: from opinicus.com ([24.73.193.242]:48340 "EHLO thing2.opinicus.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759554AbXGNAzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 20:55:12 -0400
Message-ID: <46981EBE.9080105@opinicus.com>
Date: Fri, 13 Jul 2007 20:54:22 -0400
From: William Montgomery <william@opinicus.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com> <4697E24A.4030609@intel.com> <4697FD19.6030005@opinicus.com> <4697FFA9.7020803@intel.com>
In-Reply-To: <4697FFA9.7020803@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:

> William Montgomery wrote:
>
>> Thanks for responding.  I am very interested to find the source of 
>> this problem.
>>
>> Kok, Auke wrote:
>>
>>> William Montgomery wrote:
>>>
>>>> In an earlier post to the list I described a hard lockup condition
>>>> that occurs on linux kernels 2.4.22, 2.6.13, and 2.6.17 when using
>>>> a 4 port 10/100 fast ethernet card.  The lockup is easily repeatable
>>>> and occurs on 2 out of 3 computers.
>>>>
>>>> Further testing has revealed that the lockup can be prevented on all
>>>> computers by making sure the card is installed on the primary PCI bus.
>>>> If the card is installed in a slot on the secondary PCI bus (behind a
>>>> PCI to PCI bridge) the lockup occurs.
>>>
>>>
>>> sounds like int-A/B/C/D routing issues
>>
>>
>> The strange thing is that all the ports on the card work fine for a 
>> few minutes, then when some condition (as yet unknown) occurs the 
>> system locks up hard.  I am currently using a PCI bus analyzer to 
>> capture bus activity just prior to the lockup to try and find out 
>> what leads up to this condition.
>
>
> are you running any form of irqbalance, either in-kernel (bad) or the 
> userspace (better) one?

No.  This is a Pentium 4 - single core, 2.8GHz.

>
>>>> Are there any PCI tuning registers that I can tweak to get around
>>>> this problem?  Any changes I could make to the e100 driver to fix 
>>>> this?
>>>
>>>
>>> this issue might be resolvable by quirking the bridgee chips and 
>>> adjusting any APIC where needed. Unfortunately I don't know much 
>>> about this but it's physically not possible from the e100 driver. 
>>> The special (non-intel) card that has these 4 ports onboard contains 
>>> a bridge chip itself which explains the issues. Even a BIOS issue 
>>> could be the cause here.
>>
>>
>> I am aware of the bridge chip on the card but not sure what you mean 
>> when you say this explains the issues?  I sure would like to figure 
>> out a way around this.
>
>
> irq routing in linux may not be the same as in windows. I have no idea 
> how to compare them either (dmesg will show the linux setup, but I 
> don't know how to retreive this info under linux).

Not sure how windows applies here; I only use Linux.  The main data 
point so far is that the card works fine when on the primary PCI bus but 
locks up hard after a few minutes when installed in a slot behind a PCI 
to PCI bridge.  I can provide the dmesg info on Monday.

