Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab0CLVwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:52:42 -0500
Received: from lucidpixels.com ([75.144.35.66]:38927 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab0CLVwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:52:40 -0500
Date: Fri, 12 Mar 2010 16:52:39 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Yinghai Lu <yinghai@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: 2.6.34-rc1: pci 0000:00:00.0: address space collision / spontaenous
  reboots [now 2.6.34-rc1]
In-Reply-To: <4B9AB717.3050608@kernel.org>
Message-ID: <alpine.DEB.2.00.1003121651460.6929@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan> 
 <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan>  <86802c441003121201y4c946fecrda5463b056f1ba58@mail.gmail.com>  <alpine.DEB.2.00.1003121502160.6929@p34.internal.lan>
 <86802c441003121227j77edc017vd83b2ab866ec79d8@mail.gmail.com> <alpine.DEB.2.00.1003121532300.6929@p34.internal.lan> <alpine.DEB.2.00.1003121538110.6929@p34.internal.lan> <alpine.DEB.2.00.1003121622470.6929@p34.internal.lan> <4B9AB717.3050608@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Mar 2010, Yinghai Lu wrote:

> On 03/12/2010 01:30 PM, Justin Piszcz wrote:
>>
>>
>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>
>>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>>
>>
>> # Disable Bootmem code (NO_BOOTMEM) [Y/n/?] (NEW)
>>
>> I see this new option ^
>>
>> Ok, booting 2.6.34-rc1:
>>
>> [    0.132248] PCI: pci_cache_line_size set to 64 bytes
>> [    0.132248] pci 0000:00:00.0: BAR 3: reserving [mem
>> 0xe0000000-0xffffffff flags 0x120204] (d=0, p=0)
>> [    0.132248] pci 0000:00:00.0: no compatible bridge window for [mem
>> 0xe0000000-0xffffffff 64bit]
>> [    0.132248] pci 0000:00:00.0: can't reserve [mem
>> 0xe0000000-0xffffffff 64bit]
>>
>> Full dmesg:
>> http://home.comcast.net/~jpiszcz/20100312/dmesg-2.6.34-rc1.txt
>>
> [    0.097651] node 0 link 0: io port [b000, ffff]
> [    0.097654] TOM: 0000000040000000 aka 1024M
> [    0.097657] Fam 10h mmconf [e0000000, e00fffff]
> [    0.097659] node 0 link 0: mmio [a0000, bffff]
> [    0.097661] node 0 link 0: mmio [40000000, dfffffff]
> [    0.097663] node 0 link 0: mmio [f0000000, fe02ffff]
> [    0.097665] node 0 link 0: mmio [e0000000, e04fffff] ==> [e0100000, e04fffff]
> [    0.097668] bus: [00, 04] on node 0 link 0
> [    0.097670] bus: 00 index 0 [io  0x0000-0xffff]
> [    0.097672] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
> [    0.097674] bus: 00 index 2 [mem 0x40000000-0xdfffffff]
> [    0.097676] bus: 00 index 3 [mem 0xe0500000-0xffffffff]
> [    0.097677] bus: 00 index 4 [mem 0xe0100000-0xe04fffff]
>
> that looks like setting MMCONFIG through ATI chipset.
>
> and cpu northbridge set 1M for accessing 1M...
>
> BIOS really should only use northbridge MSR to set that to cover bus [0, 255]
>
> and just disable the ATI pci 00:00.0 BAR3

Ok, so the BIOS is broken, is there a pci= option to workaround this in
the interim, or does a quirk need to be implemented?

Justin.

