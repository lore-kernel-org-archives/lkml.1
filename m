Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZABKWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZABKWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZABKVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:21:55 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35909 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZABKVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:21:54 -0500
Date: Fri, 2 Jan 2009 11:21:52 +0100
From: Andreas Mohr <andi@lisas.de>
To: Sriram V <vshrirama@gmail.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
Message-ID: <20090102102152.GA26603@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>   I am using linux-2.6.27.  I am testing power management after
> booting out of a SD/MMC card.
>   My root file system is on a SD card.
> 
>   I am issuing the following command to suspend
> 
>       $ echo -n mem > /sys/power/state
>  What happens is, The kernel hangs and it does not come out of suspend.
>  even after i press keypad/generate serial input data.


> Has anyone tried this before?
> 
> Am i missing something here?

I don't think you're missing much, and you're definitely not alone.

There have been long threads on mobile phone and netbook related forums about issues
with seemingly "any slightly advanced use whatsoever" of partitions on SD cards.

IMHO in this strongly increasingly netbook- and mobile phone-enabled world it's
a bloody shame that:
- we have a hanging suspend/resume on an SD rootfs (often the only way of
  achieving serious Linux use on a mobile phone!)
- we lose partition mounts due to full device re-probing instead of re-using the
  same minor device ID after resume
- installing a swap partition on an SD card and then resuming can easily
  go as far as __even completely corrupting__ the entire SD card partitioning
  plus first partition (corrupts first 1kB of the card: both table and partition)
  People then immediately resort to a non-helpful "Don't Do This, Ever" reply
  (using swap partition on SD and suspend, see http://dev.laptop.org/ticket/6532#comment:10),
  but to this I'd say:
  News Flash, if this can theoretically be made to work at all using software
  (i.e. there are no VM-related _hard_ blockers to such an operation
  of using swap itself on a non-fixed SD slot), then this should goddamn be made
  to work practically on Linux, _somehow_, since on SSD netbooks this is
  the most natural thing to do to avoid wear of the builtin device.

CC'd Pierre Ossman since he might know more valuable details of some of those
problems. And CC'd Linus directly since, IMHO, some of these grave problems are
full BLOCKERS and should be fully investigated now given the general direction
that the hardware market is strongly going into.

We simply cannot afford being this terrible in this space.

Related URLs about such issues:
http://dev.laptop.org/ticket/6532 (note: marked FIXED,
but that's only an unhelpful local fix, not of the underlying issues)
https://kerneltrap.org/mailarchive/linux-kernel/2007/7/19/118682
http://wiki.laptop.org/go/OLPC_SW_ECO_-_SD_CARD_CORRUPTION
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=504391
http://forum.eeeuser.com/viewtopic.php?pid=472151
http://www.olpcnews.com/forum/index.php?topic=2842.0;wap2
https://dev.openwrt.org/browser/trunk/target/linux/s3c24xx/patches-2.6.24/1144-config-add-back-MMC_UNSAFE_RESUME.patch.patch?rev=13613
http://www.olpcnews.com/software/sugar/wanted_software_testers.html
https://bugs.launchpad.net/moblin-kernel/+bug/193177
http://www.gossamer-threads.com/lists/linux/kernel/984970

A possibly helpful clue might be provided by a similar CardBus incident,
http://marc.info/?l=linux-wireless&m=122539058601588&w=4

I think that CONFIG_MMC_UNSAFE_RESUME referenced by some of the URLs above
is indeed unsafe and one should try to find a proper solution for this issue
by doing some kind of active media re-identification
(media management via media IDs or so) upon resume.
Plus, in general such a hard CONFIG_ switch is entire unsuitable for the
device flexibility one would take for granted these days.

Any thoughts, anyone?
(I'm affected by both
hangs during resume when using SD
and corruption when using swap, depending on which kernel version or
setup I happen to be using on my A110L)

IOW, I have stopped using both(!) SD slots on my device altogether
(a nice 16GB card wasted), that's how bad the combined effect
of these issues was for me.
And there are multiple other examples of users in the URLs above where they have
entirely given up on this due to the existing problems.


(or, slightly reworded: I think it's high time for some kernel God to buy a measly
netbook or some such instead of 16-core mainframes to get a feeling for the
amount of issues that one hits there)

This reply admittedly is a hodge-podge of references to existing reports,
but this is just because I think that it's about time that these media management issues
ought to be investigated massively (e.g. by dedicating someone for a 24/7 job
until these things are fixed the proper way - Linux Foundation?).

Thanks,

Andreas Mohr
