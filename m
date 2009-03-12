Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZCLOoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZCLOoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZCLOoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:44:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:18728 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZCLOop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZNfVHCWc+NWORBgokdscsDq57belyyZa1XUxvWLt9J+lHmCWgkNGXv4f4sikCUzchZ
         sT6uJeR5v1K0FkRwMDb1m0/WfW+h8BCOZU94K2M3JVo1rDpIxzkMuWrj6FGnOSv6rOfk
         Cm8Aa4jL2nmV+i6PDP9IYOKY8UxbJ0dgvjV+8=
Message-ID: <49B91FD7.3030204@gmail.com>
Date: Thu, 12 Mar 2009 08:44:39 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: protagora27 protagora27 <protagora27@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci express bar over 4gb
References: <5b9cce670903110628p45248032u50dc253ed18b6e46@mail.gmail.com>	 <49B850F7.90401@gmail.com> <5b9cce670903120205yfd0cc5cp203059299877124@mail.gmail.com>
In-Reply-To: <5b9cce670903120205yfd0cc5cp203059299877124@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

protagora27 protagora27 wrote:
> 2009/3/12 Robert Hancock <hancockrwd@gmail.com>:
>> protagora27 protagora27 wrote:
>>> Hello Folks,
>>>
>>> I have intel desktop board dx48bt2. I'm developing sw under linux
>>> 2.6.24  x86_64  for a pci express card ( pci express 2.0 compliant).
>>> I have to setup pci bar over 4 gb but bios uses value e0000000 as base
>>> address for pcie boards.
>>> I have seen that pciexbar is a register ( x48 chipset)  that decides
>>> where pcie boards are mapped inside memory map.
> But if  I see /proc/iomem:
> 
> 00000000-0009bfff : System RAM
> 0009c000-0009ffff : reserved
> 000c0000-000dffff : pnp 00:01
> 000e0000-000fffff : reserved
> 00100000-ce8fdfff : System RAM
>   00200000-0046f0b4 : Kernel code
>   0046f0b5-005b939f : Kernel data
>   00631000-006ba8c7 : Kernel bss
> ce8fe000-ce982fff : ACPI Non-volatile Storage
> ce983000-cfaf0fff : System RAM
> cfaf1000-cfaf2fff : reserved
> cfaf3000-cfb8afff : System RAM
> cfb8b000-cfbe0fff : ACPI Non-volatile Storage
> cfbe1000-cfbe6fff : System RAM
> cfbe7000-cfbf1fff : ACPI Tables
> cfbf2000-cfbf2fff : System RAM
> cfbf3000-cfbfefff : ACPI Tables
> cfbff000-cfbfffff : System RAM
> cfc00000-cfffffff : reserved
> d0000000-dfffffff : PCI Bus #01
>   d0000000-dfffffff : 0000:01:00.0
> e0000000-e1ffffff : PCI Bus #01
>   e0000000-e0ffffff : 0000:01:00.0
>   e1000000-e1ffffff : 0000:01:00.0
> e2000000-e20fffff : PCI Bus #05
>   e2000000-e2003fff : 0000:05:03.0
>   e2004000-e20047ff : 0000:05:03.0
>     e2004000-e20047ff : ohci1394
> e2100000-e21fffff : PCI Bus #04
>   e2100000-e21003ff : 0000:04:00.0
> e2200000-e22fffff : PCI Bus #02
>   e2200000-e2200fff : 0000:02:00.0
>     e2200000-e2200fff : ycrypto
> e2300000-e231ffff : 0000:00:19.0
>   e2300000-e231ffff : e1000e
> e2320000-e2323fff : 0000:00:1b.0
>   e2320000-e2323fff : ICH HD audio
> e2324000-e2324fff : 0000:00:19.0
>   e2324000-e2324fff : e1000e
> e2325000-e23257ff : 0000:00:1f.2
>   e2325000-e23257ff : ahci
> e2325800-e2325bff : 0000:00:1d.7
>   e2325800-e2325bff : ehci_hcd
> e2325c00-e2325fff : 0000:00:1a.7
>   e2325c00-e2325fff : ehci_hcd
> e2326000-e23260ff : 0000:00:1f.3
> e2400000-e24fffff : PCI Bus #03
> f0000000-f7ffffff : reserved

This f0000000-f7ffffff is likely where PCIEXBAR is pointing to for your 
MMCONFIG aperture.

> feb00000-feb03fff : pnp 00:01
> fec00000-fec00fff : IOAPIC 0
> fed13000-fed13fff : pnp 00:01
> fed14000-fed17fff : pnp 00:01
> fed18000-fed18fff : pnp 00:01
> fed19000-fed19fff : pnp 00:01
> fed1c000-fed1ffff : pnp 00:01
> fed20000-fed3ffff : pnp 00:01
> fed45000-fed99fff : pnp 00:01
> fee00000-fee00fff : Local APIC
> ffe00000-ffffffff : reserved
> 100000000-22fffffff : System RAM
> 
> pcie devices are mapped from 0xe0000000 that is  default value of pciexbar.
> 
> However can i change bars addressess of my pcie card so i can map  it
> over 4 gb ?

Not too sure on that one, honestly. You could modify the BAR addresses 
to do that, but you'd also have to change the kernel's idea of where 
they are as well..

> 
> Thanks
> 
> Luca
> 
> 
> 
> 
>> No, the PCIEXBAR register controls where the MMCONFIG aperture is mapped in
>> memory. (It's a rather unfortunate name, I think, as it doesn't really have
>> anything to do with PCI Express other than that you need to use MMCONFIG to
>> access PCI Express extended configuration space).
>>
>>> My goal is rewriting pcibar 0 e pcibar 1 with a value above 4gb. Maybe
>>>  I have  to rewrite pciexbar and then rewrite pci bar in my board.
>>> Questions:
>>> 1) can I rewrite  pciexbar  and where ?
>>> 2) can i rewrite pcibar 0 and 1 with a value over 4 gb
>>> 3) If i change bar 0 and bar 1 after linux startup have i to use
>>> hotplugging ?
>>>
>>> Thanks
>>>
>>> Luca
>>

