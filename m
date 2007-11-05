Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbXKESus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbXKESus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXKESul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:50:41 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45959 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951AbXKESuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:50:40 -0500
Date: Mon, 5 Nov 2007 13:50:40 -0500
To: "J.A. Magall?n" <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Opteron box and 4Gb memory
Message-ID: <20071105185040.GF27646@csclub.uwaterloo.ca>
References: <20071025230904.03d5f46a@werewolf> <47211172.9070606@zytor.com> <20071105001847.546565c4@werewolf> <20071105181046.GE27646@csclub.uwaterloo.ca> <20071105194521.5fc0ec71@werewolf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105194521.5fc0ec71@werewolf>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 07:45:21PM +0100, J.A. Magall?n wrote:
> Well, problem solved...
> 
> I'm going to kill all pc assemblers in the world... Someone should teach them
> to learn mauals before assembling anything but a power chord.
> 
> The memory was not paired, so the motherboard was not interleaving the access.
> With no inter-node but with inter-module interleaving, and a couple 1Gb sticks
> for each processor now I get something like:
> 
> cicely:~/bn> bn
> 	name: cicely.cps.unizar.es
> 	arch: x86-64
> 	proc: 4 x x86_64 @ 2200 MHz
> 	ram:  3555 Mb
> 	os:   unx, Linux, 2.6.23.1-desktop-1mdv
> 	cc:   gcc-4.3.0
> vector size   : 8 x 1024 x 1024
> allocation:     0.02 ms
> int scl add: ..........   60.56 ms,  138.52 Mips   |   62.96 Mips  /GHz
> int scl mul: ..........   59.34 ms,  141.36 Mips   |   64.26 Mips  /GHz
> flt scl add: ..........   59.01 ms,  142.16 Mflops |   64.62 Mflops/GHz
> flt vec add: ..........   14.79 ms,  567.06 Mflops |  257.75 Mflops/GHz
> flt scl mul: ..........   59.02 ms,  142.12 Mflops |   64.60 Mflops/GHz
> flt vec mul: ..........   14.82 ms,  566.19 Mflops |  257.36 Mflops/GHz
> total:       5019.86 ms
> 
> Much better, but not like the other opteron box.
> 
> My processors are higher than Rev E0, because the BIOS does not let me choose
> the 'software' hole. If I activate the 'hardware hole', I see al the memory
> I can:
> 
> cicely:~/bn> free
>              total       used       free     shared    buffers     cached
> Mem:       3640628     214496    3426132          0      21240      84184
> -/+ buffers/cache:     109072    3531556
> Swap:      4200988          0    4200988
> 
> 3.64 Gb. The rest is eaten by the graphics card, as I could read in the
> AMD site. Don't know if mem=4096 to boot the kernel would help, even if it
> is possible (don't think so, as it looks like a BIOS mis-feature).
> The ram is DDR 400.

The video card is stealing 300MB of ram?  What for?  What does the mtrr
and e820 map look like with the hardware hole enabled?

> Anyways, can I trust what dmidecode says ? I installed the ram as the board
> manual said in banks 1A+1B (not 2A+2B) for each processor, but this program
> says this:
> 
> BANK0   64Mb            BANK4   64Mb
> BANK1   64Mb            BANK5   64Mb
> BANK2 1024Mb            BANK6 1024Mb
> BANK3 1024Mb            BANK7 1024Mb
> 
> I would always have thought that BANK0 would be slot 1A in first processor,
> but it looks like not...
> And where do the 64 Mb blocks come from ?

Well if you ahve 4 sticks of 1GB, then I would hope they are installed
as a pair for each CPU so that both CPUs can have dual channel ram
directly connected.

I have no idea where the 64Mb comes from.

--
Len Sorensen
