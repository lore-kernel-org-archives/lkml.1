Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYDUFAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYDUFAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 01:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYDUFAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 01:00:42 -0400
Received: from colo.lackof.org ([198.49.126.79]:37196 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYDUFAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 01:00:41 -0400
Date: Sun, 20 Apr 2008 23:00:29 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-parisc@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.25 on parisc - CPU 1 is stuck
Message-ID: <20080421050029.GC15080@colo.lackof.org>
References: <20080420231818.GA2162@ska.dandreoli.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080420231818.GA2162@ska.dandreoli.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 01:18:18AM +0200, Domenico Andreoli wrote:
> Hi,
> 
>   as soon as I booted my dual PA8600 with 2.6.25 I got 1 CPU less. The
> only other kernel I successfully used on that box is Debian's 2.6.22-3.

Sorry, I can't reproduce this on my j6000.

But there are some differences:
1) I'm using gcc 4.2
2) I'm testing 32-bit kernels.
3) j6k has 2GB of RAM (ie no RAM mapped above 4GB).
4) config file might be different in additional ways.

I'll kick off a 64-bit build and test that as well.


> Debian never built 2.6.23 for parisc, 2.6.24 was still hanging last
> time I checked it, 2.6.25 did not even build until recent -rc. So I am
> not in the best position to bisect.

Given 32-bit works, we might be able to figure this out w/o bisect.

...
> Linux version 2.6.25-02519-g3925e6f (cavok@ska) (gcc version 4.1.3 20080308 (prerelease) (Debian 4.1.2-21)) #4 SMP Sun Apr 20 04:53:48
...
> model 9000/785/J5600
> Total Memory: 3840 MB

Is this really 4GB with IO Hole?
The memory behind the IO Hole should be visible at a phys addr above 4GB.

...
> Found devices:
> 1. Astro BC Runway Port at 0xfffffffffed00000 [10] { 12, 0x0, 0x582, 0x0000b }
> 2. Elroy PCI Bridge at 0xfffffffffed30000 [10/0] { 13, 0x0, 0x782, 0x0000a }
> 3. Elroy PCI Bridge at 0xfffffffffed32000 [10/1] { 13, 0x0, 0x782, 0x0000a }
> 4. Elroy PCI Bridge at 0xfffffffffed34000 [10/2] { 13, 0x0, 0x782, 0x0000a }
> 5. Elroy PCI Bridge at 0xfffffffffed38000 [10/4] { 13, 0x0, 0x782, 0x0000a }
> 6. Elroy PCI Bridge at 0xfffffffffed3c000 [10/6] { 13, 0x0, 0x782, 0x0000a }
> 7. Forte W+ 2w at 0xfffffffffffa0000 [32] { 0, 0x0, 0x5d1, 0x00004 }
> 8. Forte W+ 2w at 0xfffffffffffa2000 [34] { 0, 0x0, 0x5d1, 0x00004 }
> 9. Memory at 0xfffffffffed10200 [49] { 1, 0x0, 0x09e, 0x00009 }
> Enabling regular chassis codes support v0.05
> Releasing cpu 1 now, hpa=fffffffffffa2000
> SMP: CPU:1 is stuck.

BTW, I'm not sure this is a kernel problem. Do older kernels still work?

> CPU(s): 2 x PA8600 (PCX-W+) at 552.000000 MHz
> Setting cache flush threshold to f84c0 (1 CPUs online)
...

FWIW, here's the equivalent output for the kernel I just booted on j6k:

Linux version 2.6.25gcc42 (grundler@j6k) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 SMP Sat Apr 19 16:56:57 PDT 2008
...
model 9000/785/J6000
Total Memory: 2048 MB
...
Found devices:
1. Astro BC Runway Port at 0xfed00000 [10] { 12, 0x0, 0x582, 0x0000b }
2. Elroy PCI Bridge at 0xfed30000 [10/0] { 13, 0x0, 0x782, 0x0000a }
3. Elroy PCI Bridge at 0xfed34000 [10/2] { 13, 0x0, 0x782, 0x0000a }
4. Elroy PCI Bridge at 0xfed38000 [10/4] { 13, 0x0, 0x782, 0x0000a }
5. Elroy PCI Bridge at 0xfed3c000 [10/6] { 13, 0x0, 0x782, 0x0000a }
6. Duet W+ at 0xfffa0000 [32] { 0, 0x0, 0x5d4, 0x00004 }
7. Duet W+ at 0xfffa2000 [34] { 0, 0x0, 0x5d4, 0x00004 }
8. Memory at 0xfed10200 [49] { 1, 0x0, 0x00a, 0x00009 }
Enabling regular chassis codes support v0.05
Releasing cpu 1 now, hpa=fffa2000
FP[1] enabled: Rev 1 Model 16
CPU(s): 2 x PA8600 (PCX-W+) at 552.000000 MHz
Whole cache flush 240696 cycles, flushing 3936256 bytes 584013 cycles
Setting cache flush threshold to 1140 (2 CPUs online)
...

hth,
grant
