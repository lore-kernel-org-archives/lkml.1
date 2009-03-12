Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZCLAuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZCLAuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZCLAuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:50:06 -0400
Received: from main.gmane.org ([80.91.229.2]:32782 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbZCLAuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:50:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Piet Delaney <pdelaney@tensilica.com>
Subject: Re: [patch 0/8] xtensa: s6000 & s6105
Date: Wed, 11 Mar 2009 17:44:45 -0700
Message-ID: <49B85AFD.1050200@tensilica.com>
References: <E1Lh1cN-0005rH-9t@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Johannes Weiner <jw@emlix.com>, Cord Seele <cs@emlix.com>,
       Oskar Schirmer <os@emlix.com>, Daniel Gloeckner <dg@emlix.com>,
       Piet Delaney <piet@tensilica.com>, Marc Gauthier <marc@tensilica.com>,
       Maxim Grigoriev <maxim@tensilica.com>,
       Dan Nicolaescu <dann@tensilica.com>, Chris Zankel <chris@zankel.net>,
       Bill Huffman <huffman@tensilica.com>, Ross Morley <ross@tensilica.com>
X-Gmane-NNTP-Posting-Host: hq2.tensilica.com
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
In-Reply-To: <E1Lh1cN-0005rH-9t@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Hi,
> 
> here is the core series of our s6000 port.
> 
> First comes the nommu patch.  Right now we use CONFIG_MMU for
> everything that separates the S6000 from existing ports, memorywise.
> This is a lot easier and can still be broken up by newer ports when
> they have requirements with finer granularity.  Furthermore, we have
> only this one nommu box here, so we couldn't test an MMU architecture
> and therefor not say for sure we didn't break anything ;)

Perhaps you have a pointer to a git repository with your changes
that I can clone from.

I can make sure the LX60 and LX200 didn't break. We have a
number of bug fixes and new support for SMP and a new MMU
that we expect to ready for prime time soon. I'd prefer to
use git to test your changes and doing the merge.

How about I add accounts for you, Oskar, and Daniel and
we use the repo(s) as a staging site to test each other's changes
before passing them upstream to Christian and Linus.

It you don't have an external Git repository you could just
ftp a copy and we can add it easily.

-piet


> 
> Then comes the core variant stuff.  We are the first variant that
> needs to ship code files, so there is a prereq patch that allows that.
> 
> The inclusion of the GPIO driver is a bit arbitrary.  It was the only
> one left after stripping out all real peripheral support because we
> initially used GPIO in platform_setup().  I send it now to have an
> example on variant-specific code and conceptual improvements can then
> be excercised on it.
> 
> The platform patch is fairly trivial.  One more requirement is that
> our platform can define the kernel text offset.  We can not use a
> fixed virtual address (nommu, remember? ;)) but have to provide a
> physical one that is within bounds of our actual RAM.
> 
> The diffstat looks a bit overwhelming, but note that most of it is the
> defconfig, the tensilica core definitions and address definitions
> where the core has registers mapped.
> 
>         Hannes
> 
>  arch/xtensa/Kconfig                                |   15 +
>  arch/xtensa/Makefile                               |    5 +
>  arch/xtensa/configs/s6105_defconfig                |  530 ++++++++++++++++++++
>  arch/xtensa/include/asm/cacheflush.h               |   10 +-
>  arch/xtensa/include/asm/dma.h                      |    3 +-
>  arch/xtensa/include/asm/gpio.h                     |   56 ++
>  arch/xtensa/include/asm/io.h                       |    9 +-
>  arch/xtensa/include/asm/irq.h                      |    7 +
>  arch/xtensa/include/asm/mmu.h                      |    5 +
>  arch/xtensa/include/asm/mmu_context.h              |    5 +
>  arch/xtensa/include/asm/nommu.h                    |    3 +
>  arch/xtensa/include/asm/nommu_context.h            |   25 +
>  arch/xtensa/include/asm/page.h                     |    9 +-
>  arch/xtensa/include/asm/pgtable.h                  |   13 +-
>  arch/xtensa/include/asm/processor.h                |    6 +
>  arch/xtensa/kernel/entry.S                         |    3 +-
>  arch/xtensa/kernel/head.S                          |    3 +-
>  arch/xtensa/kernel/irq.c                           |   14 +
>  arch/xtensa/kernel/setup.c                         |    7 +
>  arch/xtensa/kernel/traps.c                         |    2 +
>  arch/xtensa/kernel/vectors.S                       |    4 +
>  arch/xtensa/kernel/vmlinux.lds.S                   |    3 +
>  arch/xtensa/mm/Makefile                            |    3 +-
>  arch/xtensa/mm/init.c                              |   62 +---
>  arch/xtensa/mm/misc.S                              |    2 +
>  arch/xtensa/mm/mmu.c                               |   70 +++
>  arch/xtensa/platforms/s6105/Makefile               |    3 +
>  arch/xtensa/platforms/s6105/device.c               |   67 +++
>  .../xtensa/platforms/s6105/include/platform/gpio.h |   27 +
>  .../platforms/s6105/include/platform/hardware.h    |   11 +
>  .../platforms/s6105/include/platform/serial.h      |    8 +
>  arch/xtensa/platforms/s6105/setup.c                |   61 +++
>  arch/xtensa/variants/dc232b/Makefile               |    1 +
>  arch/xtensa/variants/fsf/Makefile                  |    1 +
>  arch/xtensa/variants/s6000/Makefile                |    3 +
>  arch/xtensa/variants/s6000/gpio.c                  |   71 +++
>  arch/xtensa/variants/s6000/include/variant/core.h  |  431 ++++++++++++++++
>  .../variants/s6000/include/variant/hardware.h      |  259 ++++++++++
>  arch/xtensa/variants/s6000/include/variant/irq.h   |    9 +
>  .../variants/s6000/include/variant/tie-asm.h       |  304 +++++++++++
>  arch/xtensa/variants/s6000/include/variant/tie.h   |  191 +++++++
>  arch/xtensa/variants/s6000/irq.c                   |   74 +++
>  42 files changed, 2320 insertions(+), 75 deletions(-)
> 

