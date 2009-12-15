Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbZLOBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbZLOBWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbZLOBWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:22:19 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:59608 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbZLOBWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:22:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vsgx8ZAXDFH4aURh3etUrALh/alJYt81mGewnu+nDH1S9H1QY6axoaFlxB8pmhyWyv
         WC8zCLi2KytfwTlzOKXI9qsuwTYCP6j8TjpItZqNBOyjyINX/PLLMtNo5/wFlJmFkXXg
         OXKesZtNmx4SNXtgKB2r9IJz7PkVwgxBmwbhc=
Message-ID: <4B26E4C7.8040100@gmail.com>
Date: Mon, 14 Dec 2009 19:22:15 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Tvrtko Ursulin <tvrtko@ursulin.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Are these MTRR settings correct?
References: <200912130807.44905.tvrtko@ursulin.net> <200912141934.10628.tvrtko@ursulin.net> <4B26965C.6020203@kernel.org> <200912142016.53160.tvrtko@ursulin.net> <4B269F92.1050909@kernel.org>
In-Reply-To: <4B269F92.1050909@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 02:26 PM, Yinghai Lu wrote:
> Tvrtko Ursulin wrote:
>> On Monday 14 Dec 2009 19:47:40 Yinghai Lu wrote:
>>> Tvrtko Ursulin wrote:
>>>> On Monday 14 Dec 2009 11:25:58 Yinghai Lu wrote:
>>>>>>> something wrong, we should not check that with e820 or acpi resource
>>>>>>> in that case. please check
>>>>>>>
>>>>>>> {PATCH] x86/pci: don't check mmconf again if it is from MSR with amd
>>>>>>> faml0h
>>>>>>>
>>>>>>> for AMD Fam10h, it we read mmconf from MSR early, we should just trust
>>>>>>> it because we check it and correct it already.
>>>>>>>
>>>>>>> so skip the reject check there.
>>>>>> [path snipped]
>>>>>>
>>>>>> Do you want me to test with this patch and that pci=.. option active
>>>>>> and post dmesg? Or without the pci=... option?
>>>>> with this patch and pci=... and post dmesg...
>>>> Here you go:
>>> ...
>>>
>>>> [    0.250041] node 0 link 0: io port [1000, ffffff]
>>>> [    0.250043] TOM: 00000000e0000000 aka 3584M
>>>> [    0.250044] Fam 10h mmconf [e0000000, efffffff]
>>>> [    0.250046] node 0 link 0: mmio [a0000, bffff]
>>>> [    0.250048] node 0 link 0: mmio [e0000000, efffffff] ==>  none
>>>> [    0.250050] node 0 link 0: mmio [f0000000, fe7fffff]
>>>> [    0.250051] node 0 link 0: mmio [fe800000, fe9fffff]
>>>> [    0.250053] node 0 link 0: mmio [fea00000, ffefffff]
>>>> [    0.250054] TOM2: 0000000120000000 aka 4608M
>>>> [    0.250056] bus: [00,07] on node 0 link 0
>>>> [    0.250057] bus: 00 index 0 io port: [0, ffff]
>>>> [    0.250058] bus: 00 index 1 mmio: [a0000, bffff]
>>>> [    0.250060] bus: 00 index 2 mmio: [f0000000, ffffffff]
>>>> [    0.250061] bus: 00 index 3 mmio: [120000000, fcffffffff]
>>>> [    0.250068] ACPI: bus type pci registered
>>>> [    0.250091] PCI: Found AMD Family 10h NB with MMCONFIG support.
>>>> [    0.254793] PCI: Using MMCONFIG at e0000000 - efffffff
>>>> [    0.254795] PCI: Using configuration type 1 for base access
>>> ...
>>>
>>> thanks, mmconf works on your system.
>>
>> So I should keep using both your patch and pci=check_enable_amd_mmconf option?
>>
>
> I will push the driver to Jesse.
>
> but you need to have pci=check_enable_amd_mmconf, unless we add one DMI entry for your kind of system.

Something else isn't quite right. It looks like MMCONFIG area should be 
reserved:

[    0.308434] system 00:0c: iomem range 0xe0000000-0xefffffff has been 
reserved

but the code didn't seem to detect that. In fact there doesn't seem to 
be any output about whether it was or wasn't reserved, which from the 
code it seems there should be.

Maybe because of that ACPI method execution error?


