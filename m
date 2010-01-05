Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905Ab0AEWU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0AEWU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485Ab0AEWU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:20:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:55400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab0AEWUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:20:55 -0500
Message-ID: <4B43BAEB.7070308@kernel.org>
Date: Tue, 05 Jan 2010 14:19:23 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Anders Eriksson <aeriksson@fastmail.fm>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Memory probing fails after 2.6.30 (bisected)
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org> <86802c441001051102j547f10bga2b40fbaee9cf623@mail.gmail.com> <20100105211522.57A3E33C5F5@tippex.mynet.homeunix.org>
In-Reply-To: <20100105211522.57A3E33C5F5@tippex.mynet.homeunix.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 01:15 PM, Anders Eriksson wrote:
> 
> yinghai@kernel.org said:
>> whole boot log with debug with boot command line?
>>
>>> I can produce a pic of the dmesg for the fingered commit of needed.
>> boot that with earlyprintk=vga please. 
> 
> I managed to pull this one from the failing boot.
> Does it help?
> 
> Linux version 2.6.30-rc2-00450-g8ecee46 (root@korven) (gcc version 4.3.2 (Gentoo 4.3.2-r3 p1.6, pie-10.1.5) ) #21 SMP Tue Jan 5 10:45:52 CET 2010
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   NSC Geode by NSC
>   Cyrix CyrixInstead
>   Centaur CentaurHauls
>   Transmeta GenuineTMx86
>   Transmeta TransmetaCPU
>   UMC UMC UMC UMC
> BIOS-provided physical RAM map:
>  BIOS-88: 0000000000000000 - 000000000009f000 (usable)
>  BIOS-88: 0000000000100000 - 0000000001000000 (usable)

can you try to revert some e820 detect patch?

bca23db: x86, setup: revert ACPI 3 E820 extended attributes support
df7699c: x86, setup: "glove box" BIOS interrupts in the core boot code
cd67059: x86, setup: guard against pre-ACPI 3 e820 code not updating %ecx
c549e71: x86, setup: ACPI 3, BIOS workaround for E820-probing code
32ec7fd: x86, setup: preemptively save/restore edi and ebp around INT 15 E820
01522df: x86, setup: mark %esi as clobbered in E820 BIOS call
1b72691: x86: fix build warnings in real mode code
c3965bd: x86 boot: proper use of ARRAY_SIZE instead of repeated E820MAX constant
cf9b111: x86: remove pointless comments
829157b: x86: handle BIOSes which terminate e820 with CF=1 and no SMAP
96ae6ea: i386: move boot
4ee5b10: [x86 setup] Correct the SMAP check for INT 0x15, AX=0xe820
2efa33f: [x86 setup] Handle case of improperly terminated E820 chain
449f2ab: Memory probing support for the new x86 setup code
