Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbYFZOSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbYFZOSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYFZOSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:18:04 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:45943 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbYFZOSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:18:03 -0400
Date: Thu, 26 Jun 2008 17:15:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 4/6] dmaengine: Make DMA Engine menu visible for
	AVR32 users
Message-ID: <20080626141552.GB30954@cs181140183.pp.htv.fi>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com> <1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com> <1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com> <1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com> <1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 03:23:21PM +0200, Haavard Skinnemoen wrote:
> This makes the DMA Engine menu visible on AVR32 by adding AVR32 to the
> (growing) list of architectures DMADEVICES depends on. Though I'd prefer
> to remove that whole "depends" line entirely...
> 
> The DMADEVICES menu used to be available for all architectures, but at
> some point, we started building a huge dependency list with all the
> architectures that might have support for this kind of hardware.
> 
> According to Dan Williams:
> 
> > Adrian had concerns about users enabling NET_DMA when the hardware
> > capability is relatively rare.
> 
> which seems very strange as long as (PCI && X86) is enough to enable
> this menu. In other words, the vast majority of users will see the menu
> even though the hardware is rare.
> 
> Also, all DMA clients depend on DMA_ENGINE being set. This symbol is
> selected by each DMA Engine driver, so users can't select a DMA client
> without selecting a specific DMA Engine driver first.
>...

That discussion is mixing two different things I suggested besides other 
things before the Kconfig file was added [1]:
- have DMA_ENGINE select'ed when a device gets enabled by the user,
  and not be an independent option
- switch to menuconfig and don't offer an empty kconfig menu

There seems to be no disagreement about the former (which could 
otherwise easily lead to users mistakenly enabling NET_DMA).

The latter is more a cosmetical kconfig UI thing, and I already said
back then that it "could be dropped if it would become a problem" [2].

So if you want to remove the architecture dependency from the DMADEVICES 
menu that's OK with me.

cu
Adrian

[1] http://lkml.org/lkml/2007/7/26/15
[2] http://lkml.org/lkml/2007/8/9/537

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

