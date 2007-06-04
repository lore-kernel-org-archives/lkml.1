Return-Path: <linux-kernel-owner+w=401wt.eu-S1761015AbXFDTLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015AbXFDTLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759982AbXFDTKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:10:54 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:50381 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759764AbXFDTKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:10:53 -0400
Date: Mon, 4 Jun 2007 15:10:52 -0400
To: Tom Moore <tmoore@spatial.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 4Gb ram not showing up
Message-ID: <20070604191052.GD10008@csclub.uwaterloo.ca>
References: <46642C60.209@spatial.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46642C60.209@spatial.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 11:14:40AM -0400, Tom Moore wrote:
> I am having some difficulty trying to get my 4Gb of ram recognized by 
> the system.  I have tried googling around to get some information on how 
> to do this configuration, but I have come up dry.  I suspect that the 
> reason that there is not much info on how to set things up is because 
> usually it just works.  However, on my system I don't think it is.
> 
> By the way, I am not subscribed to this mailing list, so could you 
> please CC me any replies.
> 
> The basics are that I have an Athlon 64 X2 Dual core, 4Gb ram, ASUS 
> M2N-MX motherboard.  The bios has a configuration item for MTRR mapping, 
> with options for CONTINUOUS and DISCRETE.  I have selected CONTINUOUS, 
> which explicitly describes the PCI hole as non-cacheable.  The other 
> option leaves the PCI hole undescribed.
> 
> My config has selected
> CONFIG_HIGHMEM4G=y

That supports of to 4GB memory space.

> free -m reports the following....
>             total       used       free     shared    buffers     cached
> Mem:          2906       2794        112          0        275         31
> -/+ buffers/cache:       2487        419
> Swap:         4996        366       4630
> 
> 
> /proc/mtrr contains the following....
> 
> reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1

Your memory map however has 3GB at address 0 and 1GB at address 4GB (so
memory is places at address 0 - 3GB and 4-5GB.  The addresses from 3 to
4GB are reserved for PCI).

If you run a 64bit kernel you will see it all, or you can use a kernel
configured for 64GB memory space.

> Relevant bootup messages include these....
> Jun  3 13:50:52 fawkes Linux version 2.6.20-gentoo-r8 (root@fawkes) (gcc 
> version 4.1.1 (Gentoo 4.1.1-r3)) #6 SMP Tue May 15 10:18:59 EDT 2007
> Jun  3 13:50:52 fawkes BIOS-provided physical RAM map:
> Jun  3 13:50:52 fawkes sanitize start
> Jun  3 13:50:52 fawkes sanitize end
> Jun  3 13:50:52 fawkes copy_e820_map() start: 0000000000000000 size: 
> 000000000009fc00 end: 000000000009fc00 type: 1
> Jun  3 13:50:52 fawkes copy_e820_map() type is E820_RAM
> Jun  3 13:50:52 fawkes copy_e820_map() start: 000000000009fc00 size: 
> 0000000000000400 end: 00000000000a0000 type: 2
> Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000000e0000 size: 
> 0000000000020000 end: 0000000000100000 type: 2
> Jun  3 13:50:52 fawkes copy_e820_map() start: 0000000000100000 size: 
> 00000000b7ec0000 end: 00000000b7fc0000 type: 1
> Jun  3 13:50:52 fawkes copy_e820_map() type is E820_RAM
> Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000b7fc0000 size: 
> 000000000000e000 end: 00000000b7fce000 type: 3
> Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000b7fce000 size: 
> 0000000000022000 end: 00000000b7ff0000 type: 4
> Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000b7ff0000 size: 
> 0000000000010000 end: 00000000b8000000 type: 2
> Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000fec00000 size: 
> 0000000000001000 end: 00000000fec01000 type: 2
> Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000fee00000 size: 
> 0000000000100000 end: 00000000fef00000 type: 2
> Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000ff780000 size: 
> 0000000000880000 end: 0000000100000000 type: 2
> Jun  3 13:50:52 fawkes copy_e820_map() start: 0000000100000000 size: 
> 0000000040000000 end: 0000000140000000 type: 1
> Jun  3 13:50:52 fawkes copy_e820_map() type is E820_RAM
> Jun  3 13:50:52 fawkes BIOS-e820: 0000000000000000 - 000000000009fc00 
> (usable)
> Jun  3 13:50:52 fawkes BIOS-e820: 000000000009fc00 - 00000000000a0000 
> (reserved)
> Jun  3 13:50:52 fawkes BIOS-e820: 00000000000e0000 - 0000000000100000 
> (reserved)
> Jun  3 13:50:52 fawkes BIOS-e820: 0000000000100000 - 00000000b7fc0000 
> (usable)
> Jun  3 13:50:52 fawkes BIOS-e820: 00000000b7fc0000 - 00000000b7fce000 
> (ACPI data)
> Jun  3 13:50:52 fawkes BIOS-e820: 00000000b7fce000 - 00000000b7ff0000 
> (ACPI NVS)
> Jun  3 13:50:52 fawkes BIOS-e820: 00000000b7ff0000 - 00000000b8000000 
> (reserved)
> Jun  3 13:50:52 fawkes BIOS-e820: 00000000fec00000 - 00000000fec01000 
> (reserved)
> Jun  3 13:50:52 fawkes BIOS-e820: 00000000fee00000 - 00000000fef00000 
> (reserved)
> Jun  3 13:50:52 fawkes BIOS-e820: 00000000ff780000 - 0000000100000000 
> (reserved)
> Jun  3 13:50:52 fawkes BIOS-e820: 0000000100000000 - 0000000140000000 
> (usable)
> Jun  3 13:50:52 fawkes Warning only 4GB will be used.
> Jun  3 13:50:52 fawkes Use a PAE enabled kernel.

Oh look, it even tells you right there that you have to use a PAE (>4GB
for 32bit machines) kernel to get all your ram.

--
Len Sorensen
