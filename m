Return-Path: <linux-kernel-owner+w=401wt.eu-S937183AbXGMWl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937183AbXGMWl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933120AbXGMWlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:41:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:21613 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760370AbXGMWlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:41:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,538,1175497200"; 
   d="scan'208";a="250164145"
Message-ID: <4697FFA9.7020803@intel.com>
Date: Fri, 13 Jul 2007 15:41:45 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: William Montgomery <william@opinicus.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com> <4697E24A.4030609@intel.com> <4697FD19.6030005@opinicus.com>
In-Reply-To: <4697FD19.6030005@opinicus.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2007 22:41:46.0145 (UTC) FILETIME=[FE121110:01C7C59E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Montgomery wrote:
> Thanks for responding.  I am very interested to find the source of this 
> problem.
> 
> Kok, Auke wrote:
> 
>> William Montgomery wrote:
>>
>>> In an earlier post to the list I described a hard lockup condition
>>> that occurs on linux kernels 2.4.22, 2.6.13, and 2.6.17 when using
>>> a 4 port 10/100 fast ethernet card.  The lockup is easily repeatable
>>> and occurs on 2 out of 3 computers.
>>>
>>> Further testing has revealed that the lockup can be prevented on all
>>> computers by making sure the card is installed on the primary PCI bus.
>>> If the card is installed in a slot on the secondary PCI bus (behind a
>>> PCI to PCI bridge) the lockup occurs.
>>
>> sounds like int-A/B/C/D routing issues
> 
> The strange thing is that all the ports on the card work fine for a few 
> minutes, then when some condition (as yet unknown) occurs the system 
> locks up hard.  I am currently using a PCI bus analyzer to capture bus 
> activity just prior to the lockup to try and find out what leads up to 
> this condition.

are you running any form of irqbalance, either in-kernel (bad) or the userspace 
(better) one?

>>> Are there any PCI tuning registers that I can tweak to get around
>>> this problem?  Any changes I could make to the e100 driver to fix this?
>>
>> this issue might be resolvable by quirking the bridgee chips and 
>> adjusting any APIC where needed. Unfortunately I don't know much about 
>> this but it's physically not possible from the e100 driver. The 
>> special (non-intel) card that has these 4 ports onboard contains a 
>> bridge chip itself which explains the issues. Even a BIOS issue could 
>> be the cause here.
> 
> I am aware of the bridge chip on the card but not sure what you mean 
> when you say this explains the issues?  I sure would like to figure out 
> a way around this.

irq routing in linux may not be the same as in windows. I have no idea how to 
compare them either (dmesg will show the linux setup, but I don't know how to 
retreive this info under linux).

> The PCI info follows:
>   00:00.0 Host bridge: Intel Corp. 82845G/GL[Brookdale-G]/GE/PE DRAM 
> Controller/Host-Hub Interface (rev 03)
>   00:02.0 VGA compatible controller: Intel Corp. 
> 82845G/GL[Brookdale-G]/GE Chipset Integrated Graphics Device (rev 03)
>   00:1d.0 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #1 (rev 02)
>   00:1d.1 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #2 (rev 02)
>   00:1d.2 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #3 (rev 02)
>   00:1d.7 USB Controller: Intel Corp. 82801DB (ICH4) USB2 EHCI 
> Controller (rev 02)
>   00:1e.0 PCI bridge: Intel Corp. 82801BA/CA/DB/EB/ER Hub interface to 
> PCI Bridge (rev 82)
>   00:1f.0 ISA bridge: Intel Corp. 82801DB (ICH4) LPC Bridge (rev 02)
>   00:1f.1 IDE interface: Intel Corp. 82801DB (ICH4) Ultra ATA 100 
> Storage Controller (rev 02)
>   00:1f.3 SMBus: Intel Corp. 82801DB/DBM (ICH4) SMBus Controller (rev 02)
>   01:08.0 Ethernet controller: Intel Corp. 82801BD PRO/100 VE (CNR) 
> Ethernet Controller (rev 82)
>   01:0c.0 PCI bridge: Pericom Semiconductor: Unknown device 8150 (rev 02)
>   02:06.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge 
> (non-transparent mode) (rev 15)
>   03:04.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
> (rev 08)
>   03:05.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
> (rev 08)
>   03:06.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
> (rev 08)
>   03:07.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
> (rev 08)
> 
>> Perhaps the linuxfirmwarekit will reveal more information. In any 
>> case, fixing this in software would be a gigantic effort.
>>
> I will look into that on Monday and report what I find.  It seems like 
> it is premature to say how much effort the fix will take since the 
> problem is not yet known?  At least not known to me yet.  I would just 
> like to find out what parameters on the bridge/bridges might affect this 
> problem and how to modify them.

I personally have no idea and am not knowledgeable enough on this issue, sorry :)

Auke

> 
>> Auke
>>
