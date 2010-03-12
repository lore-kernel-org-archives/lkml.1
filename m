Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab0CLVoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:44:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:51382 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab0CLVoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:44:06 -0500
Message-ID: <4B9AB574.70800@kernel.org>
Date: Fri, 12 Mar 2010 13:43:16 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous
  reboots [full dmesg]
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan>  <86802c441003121201y4c946fecrda5463b056f1ba58@mail.gmail.com>  <alpine.DEB.2.00.1003121502160.6929@p34.internal.lan> <86802c441003121227j77edc017vd83b2ab866ec79d8@mail.gmail.com> <alpine.DEB.2.00.1003121532300.6929@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003121532300.6929@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 12:34 PM, Justin Piszcz wrote:
> 
> 
> On Fri, 12 Mar 2010, Yinghai Lu wrote:
> 
>> On Fri, Mar 12, 2010 at 12:02 PM, Justin Piszcz
>> <jpiszcz@lucidpixels.com> wrote:
>>>
>>>
>>> On Fri, 12 Mar 2010, Yinghai Lu wrote:
>>>
>>>> On Fri, Mar 12, 2010 at 5:10 AM, Justin Piszcz
>>>> <jpiszcz@lucidpixels.com>
>>>> wrote:
>>>>>
>>>>> [    0.112379] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff
>>>>> 64bit]
>>>>
>>>>> [    0.133510] PCI: pci_cache_line_size set to 64 bytes
>>>>> [    0.133515] pci 0000:00:00.0: BAR 3: reserving [mem
>>>>> 0xe0000000-0xffffffff
>>>>> flags 0x120204] (d=0, p=0)
>>>>> [    0.133518] pci 0000:00:00.0: address space collision: [mem
>>>>> 0xe0000000-0xffffffff 64bit] already in use
>>>>> [    0.133522] pci 0000:00:00.0: can't reserve [mem
>>>>> 0xe0000000-0xffffffff
>>>>> 64bit]
>>>>> [    0.137020] system 00:09: [mem 0xe0000000-0xefffffff] has been
>>>>> reserved
>>>>> [    0.172034] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
>>>>> [    0.172035] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
>>>>
>>>> looks like the silicon report wrong size in that BAR3
>>>>
>>>> YH
>>>
>>> Hi,
>>>
>>> Is there anyway to work around this?  Or is it a bad motherboard?
>>>
>>
>> maybe one new BIOS could hide that register
> Hi,
> 
> It is using the latest F8c BIOS:
> http://www.gigabyte.us/Products/Motherboard/Products_Overview.aspx?ProductID=3007
> 
> 
> Other (earlier) bios' have been tested, that did not help either.
> 
> Is there anyway to to the kernel not to touch that range of memory?
> 0xe0000000-0xffffffff?

kernel doesn't touch that BAR. just set the res start to 0, but later it doesn't try to get one for it. because pci 00:00.0 is one hostbridge.

YH

