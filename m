Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbXKHSIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbXKHSIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760451AbXKHSIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:08:31 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55404 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760662AbXKHSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:08:30 -0500
Date: Thu, 8 Nov 2007 13:08:30 -0500
To: "J.A. Magall?n" <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Opteron box and 4Gb memory
Message-ID: <20071108180830.GG27646@csclub.uwaterloo.ca>
References: <20071025230904.03d5f46a@werewolf> <47211172.9070606@zytor.com> <20071105001847.546565c4@werewolf> <20071105181046.GE27646@csclub.uwaterloo.ca> <20071105194521.5fc0ec71@werewolf> <20071105185040.GF27646@csclub.uwaterloo.ca> <20071106000319.5887a6de@werewolf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106000319.5887a6de@werewolf>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 12:03:19AM +0100, J.A. Magall?n wrote:
> (correction, this was not AMD website but SuperMicro's)
> 
> I just said the same... Board is a SuperMicro H8DCE. From the FAQ section
> at supermicro:
> 
> Question
> I have an H8DCE motherboard with 4 x 1GB DIMMS installed but the amount of memory displayed in the BIOS is 3.865GB and in 64-bit XP is 3.76GB. I have the hardware memory hole option enabled in BIOS (rev 1.1a). How I can get the board to count the full 4GB of memory?
> 
> Answer
> The total available size depends on the PCI-e card you are using; some high-end cards may occupy more memory. For example, with a Quadro FX4500 on the H8DCE with the memory hole enabled, 4GB memory will show up as 3728MB in BIOS and 3.64GB in Windows. For some low-end PCI-e VGA cards, it may show up as 4048MB in BIOS.
> 
> Why ? Who knows...
> Chipset is all nVidia. I have a GeForce 8800GTX with 768 Mb. It eats up
> 400Mb.
> 
> This are my settings:
> 
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000009ffd0000 (usable)
>  BIOS-e820: 000000009ffd0000 - 000000009ffde000 (ACPI data)
>  BIOS-e820: 000000009ffde000 - 00000000a0000000 (ACPI NVS)
>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000147000000 (usable)
> 
> cicely:~# cat /proc/mtrr
> reg00: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> reg01: base=0x140000000 (5120MB), size=  64MB: write-back, count=1
> reg02: base=0x144000000 (5184MB), size=  32MB: write-back, count=1
> reg03: base=0x146000000 (5216MB), size=  16MB: write-back, count=1
> reg04: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg05: base=0x80000000 (2048MB), size= 512MB: write-back, count=1
> 
> This is with BIOS set for MTRR=Discrete.
> With MTRR=Continuous, the mtrr's are simpler, a full range and a non-usable
> hole. Which is better for Linux ? Many separate usable zones or one big zone
> and an un-usable hole ?

Seems odd if they can't just map memory as:
2GB at 0
512MB at 2GB
1GB at 4GB
512MB at 5GB

Or for that matter:
2GB at 0
2GB at 4GB
Why can't they do things as simple as that?  If you have a 64bit OS that
would be perfectly fine.

It appears they have 
2GB at 0
512MB at 2GB
1GB at 4GB
64MB at 5GB
32MB at 5GB+64MB
16MB at 5GB+64MB+32MB

Where did they map the rest of the ram?  All I can think there is that
they messed up.  Of course some think that having as much ram for XP
32bit as possible is more important than sane systems, so they will map
more in the first 4GB where XP32 can use it, and then due to alignments
and rounding of the mapping they can't get all the remaining ram mapped
above 4GB.

--
Len Sorensen
