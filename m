Return-Path: <linux-kernel-owner+w=401wt.eu-S965063AbXH0Uub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063AbXH0Uub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbXH0UuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:50:24 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49328 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758280AbXH0UuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:50:23 -0400
Date: Mon, 27 Aug 2007 21:49:35 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       kbuild-devel@lists.sourceforge.net
Subject: Re: CONFIG_HOTPLUG_CPU: kconfig bug?
In-Reply-To: <20070827172654.GA21871@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0708272143150.29594@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0708271525400.21853@blonde.wat.veritas.com>
 <20070827172654.GA21871@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Sam Ravnborg wrote:
> On Mon, Aug 27, 2007 at 03:54:49PM +0100, Hugh Dickins wrote:
> > Hi Roman,
> > 
> > I've noticed an oddity with CONFIG_HOTPLUG_CPU in 2.6.23-rc:
> > make oldconfig seems to turn it on even when nothing wants it,
> > increasing kernel size by about 10k; but if you then edit the
> > line out of .config and make oldconfig again, it correctly
> > offers the choice and lets it be turned off after all.
> > 
> > (I've not actually tried make anything_else_config.)
> > 
> > Attached is a 2.6.23-rc1 i386 SMP .config, CONFIG_HOTPLUG_CPU
> > not set, with which it should be easy to reproduce the issue: just
> > make oldconfig in an -rc2 or current kernel tree (being sure to
> > choose N for SUSPEND and HIBERNATION: those rightly select it).
> 
> I tried to reproduce this with no luck:
> 
> $ mv hugh .config 
> $ make 
> scripts/kconfig/conf -s arch/i386/Kconfig
> *
> * Restart config...
> *
> *
> * Power management options (ACPI, APM)
> *
> Power Management support (PM) [Y/n/?] y
>   Legacy Power Management API (DEPRECATED) (PM_LEGACY) [N/y/?] n
>   Power Management Debug Support (PM_DEBUG) [N/y/?] n
> Suspend to RAM and standby (SUSPEND) [Y/n/?] (NEW) n              <= I selected 'n'
> Hibernation (aka 'suspend to disk') (HIBERNATION) [N/y/?] (NEW) n <= I selected 'n'
> *
> * Fusion MPT device support
> *
> Fusion MPT ScsiHost drivers for SPI (FUSION_SPI) [Y/n/m/?] y
> Fusion MPT ScsiHost drivers for FC (FUSION_FC) [N/m/y/?] n
> Fusion MPT ScsiHost drivers for SAS (FUSION_SAS) [N/m/y/?] n
> Maximum number of scatter gather entries (16 - 128) (FUSION_MAX_SGE) [128] 128
> Fusion MPT misc device (ioctl) driver (FUSION_CTL) [N/m/y/?] n
> Fusion MPT logging facility (FUSION_LOGGING) [N/y/?] (NEW) 
> #
> # configuration written to .config
> #
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
> make: *** [_all] Interrupt
> 
> $ grep HOTPLUG_CPU .config
> # CONFIG_HOTPLUG_CPU is not set
> 
> If you let kbuild do a silentoldconfig then I expect
> it to be set due to SUSPEND being set.
> 
> If you can still reproduce it could you then explan the
> exect stepts to do so.
> 
> PS. I used latest -linus as of yesterday.

Interesting, thanks a lot for trying.  Doing it your way (saying
"make" without a preparatory "make oldconfig") gives me the same
result as you, CONFIG_HOTPLUG_CPU is not set.  But doing it my way
("make oldconfig" as I indicated) gives me CONFIG_HOTPLUG_CPU=y as
before - please try an explicit "make oldconfig" and I expect
you'll find the same.

Hugh
