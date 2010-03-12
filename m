Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab0CLUBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:01:16 -0500
Received: from mail-pz0-f200.google.com ([209.85.222.200]:64452 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab0CLUBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:01:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BiOoy/AWikMMxKCrFbEs4gjlY3mUh2qZLEDBqGF8F2yZKWhTmzXw1ASExVOnV3rRYt
         k+rnghuVtzBH9BWmAzHeKXAzb5omdqlot67KLho8Nn4EsexVagfxNc7doJUuq+gHd7Ja
         Y/jOaVxHiIlC2xvpXxQ6ZwRsKL8VVz1gYTnf8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>
	 <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>
	 <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>
	 <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan>
	 <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>
	 <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan>
Date: Fri, 12 Mar 2010 12:01:11 -0800
X-Google-Sender-Auth: eadef8b014d53574
Message-ID: <86802c441003121201y4c946fecrda5463b056f1ba58@mail.gmail.com>
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous 
	reboots [full dmesg]
From: Yinghai Lu <yinghai@kernel.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 5:10 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>>
>>> Problem persists.
>>>
>>> Others seem to have similar issues:
>>> http://lkml.org/lkml/2010/1/9/157
>>>
>>> Some boards not compatible it appears..
>>>
>>> Justin.
>>>
>>>
>>
>> Even with all boards removed:
>> [    0.133537] pci 0000:00:00.0: address space collision: [mem
>> 0xe0000000-0xffffffff 64bit] already in use
>>
>> 00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual slot
>> PCI-e_GFX and HT3 K8 part
>>
>>
>
> Hi,
>
> Here is a full dmesg with PCI debugging enabled:
>
> Of interest:
> [    0.133515] pci 0000:00:00.0: BAR 3: reserving [mem 0xe0000000-0xffffffff
> flags 0x120204] (d=0, p=0)
> [    0.133518] pci 0000:00:00.0: address space collision: [mem
> 0xe0000000-0xffffffff 64bit] already in use
> [    0.133522] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff
> 64bit]
>
> --
>
> [    0.000000] Linux version 2.6.33 (root@server) (gcc version 4.3.3 (Debian
> 4.3.3-14) ) #9 SMP Fri Mar 12 08:05:50 EST 2010
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled:
> [    0.097716] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
> 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.097721] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> [    0.097724] PCI: Using MMCONFIG for extended config space
> [    0.097726] PCI: Using configuration type 1 for base access
> [    0.112158] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.112211] pci_root PNP0A03:00: ignoring host bridge windows from ACPI;
> boot with "pci=use_crs" to use them
> [    0.112346] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
> (ignored)
> [    0.112348] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
> (ignored)
> [    0.112351] pci_root PNP0A03:00: host bridge window [mem
> 0x000a0000-0x000bffff] (ignored)
> [    0.112353] pci_root PNP0A03:00: host bridge window [mem
> 0x000c0000-0x000dffff] (ignored)
> [    0.112355] pci_root PNP0A03:00: host bridge window [mem
> 0x40000000-0xfed0ffff] (ignored)
> [    0.112356] pci_bus 0000:00: scanning bus
...
> [    0.112379] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]

> [    0.133510] PCI: pci_cache_line_size set to 64 bytes
> [    0.133515] pci 0000:00:00.0: BAR 3: reserving [mem 0xe0000000-0xffffffff
> flags 0x120204] (d=0, p=0)
> [    0.133518] pci 0000:00:00.0: address space collision: [mem
> 0xe0000000-0xffffffff 64bit] already in use
> [    0.133522] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff
> 64bit]
> [    0.137020] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.172034] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
> [    0.172035] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]

looks like the silicon report wrong size in that BAR3

YH
