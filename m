Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbZDRRCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbZDRRCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 13:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZDRRCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 13:02:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:35674 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbZDRRCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 13:02:15 -0400
Message-ID: <49EA0786.1090503@kernel.org>
Date: Sat, 18 Apr 2009 10:01:58 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] pci: don't assume pref memio are 64bit -v2
References: <49E992C2.4010707@kernel.org> <49E99303.50004@kernel.org> <20090418091509.GM7678@elte.hu>
In-Reply-To: <20090418091509.GM7678@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> one system with 4g installed ( there is 1g hole)
>>
>> when 4G installed.
>> BIOS put ACPI etc need the hole
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
>> [    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000e3000 - 0000000000100000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffa0000 (usable)
>> [    0.000000]  BIOS-e820: 00000000bffa0000 - 00000000bffae000 (ACPI data)
>> [    0.000000]  BIOS-e820: 00000000bffae000 - 00000000bfff0000 (ACPI NVS)
>> [    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
>> so in kernel resource will be reserved for 0xbffa0000 - 0xbfff0000 for ACPI
>> 0x100000 -  0xbffa0000 for RAM...
> 
> btw., sidenote, it would be nice to enhance the e820 table printout 
> with size and hole info as well. I did this manually yesterday in 
> another mail:
> 
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)       0.639 MB RAM
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)     0.001 MB
>                                                 [ hole ]       0.250 MB
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)     0.125 MB
>  BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)    1004.5   MB RAM
>  BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)     0.7   MB
>  BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)      16.3   MB RAM
>  BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)     0.3   MB
>  BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)       0.15  MB RAM
>  BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data     0.07  MB
>  BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)       0.004 MB RAM
>                                                 [ hole ]       1.0   MB
>                                                 [ hole ]    3072.0   MB
> 
> it would be extremely useful to have that in the printout, to see 
> the physical address space layout at a glance. Small holes are easy 
> to miss, and e820 entry sizes are hard to judge at a glance.
> 
> To make this fit well, i'd suggest to drop the 'BIOS-e820: ' prefix 
> - it's redundant.

will look at it. and should be another patch for x86.

YH
