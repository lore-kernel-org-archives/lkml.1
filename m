Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZC2Q0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZC2Q0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZC2Q0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:26:08 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39976 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZC2Q0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:26:07 -0400
Date: Sun, 29 Mar 2009 18:26:01 +0200
From: Andreas Mohr <andi@lisas.de>
To: Pavel Machek <pavel@suse.cz>
Cc: Andreas Mohr <andi@lisas.de>, Sriram V <vshrirama@gmail.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
Message-ID: <20090329162601.GA649@rhlx01.hs-esslingen.de>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com> <20090102102152.GA26603@rhlx01.hs-esslingen.de> <20090102172407.GD1555@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102172407.GD1555@ucw.cz>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 02, 2009 at 06:24:13PM +0100, Pavel Machek wrote:
> > IMHO in this strongly increasingly netbook- and mobile phone-enabled world it's
> > a bloody shame that:
> ...
> > - installing a swap partition on an SD card and then resuming can easily
> >   go as far as __even completely corrupting__ the entire SD card partitioning
> >   plus first partition (corrupts first 1kB of the card: both table and partition)
> >   People then immediately resort to a non-helpful "Don't Do This, Ever" reply
> >   (using swap partition on SD and suspend, see http://dev.laptop.org/ticket/6532#comment:10),
> >   but to this I'd say:
> >   News Flash, if this can theoretically be made to work at all using software
> >   (i.e. there are no VM-related _hard_ blockers to such an operation
> >   of using swap itself on a non-fixed SD slot), then this should goddamn be made
> >   to work practically on Linux, _somehow_, since on SSD netbooks this is
> >   the most natural thing to do to avoid wear of the builtin device.
> 
> I'd like to help with this one... can you reproduce this?

Replying now since I'd like to give a status update:

I'm currently running a 2.6.29-rc8 with CONFIG_MMC_UNSAFE_RESUME enabled,
and an external SD card mount (ext2) _does_ survive resume properly
(most likely without this option it would still corrupt the partition
after resume).
Not sure whether use of the swap partition on this card is troublefree during
resume, though... (not seen much use so far, and no issues yet either)

However while UNSAFE_RESUME does work, obviously it's not a good idea
at all to have the Kconfig option described as:

config MMC_UNSAFE_RESUME
        bool "Allow unsafe resume (DANGEROUS)"
        help
          If you say Y here, the MMC layer will assume that all cards
          stayed in their respective slots during the suspend. The
          normal behaviour is to remove them at suspend and
          redetecting them at resume. Breaking this assumption will
          in most cases result in data corruption.

          This option is usually just for embedded systems which use
          a MMC/SD card for rootfs. Most people should say N here.


since in such a use case it's obviously dangerous to _not_ have
this option enabled.

Or, in other words (as I have written before), media management should
get smarter to not need this option at all.

The least that should be done now is to drastically change this Kconfig
description (mention that _both_ settings can be dangerous, and help
people decide which one to use), to reflect current knowledge.
I'd be willing to submit a patch... (--> Pierre, right?)


[[ JFYI:

I'm very relieved to see those severe SSD bio performance problems
being addressed currently (Fengguang et al).

2.6.29-rc8 is too rough otherwise:
still i915 issues: x.org crash every ~ half-dozen resumes;
some ath5k weirdness (a suspected ath5k oops when doing rfkill, ...).
Plus e100 non-MII variants still not supported in 2.6.29 (let's see
how many complaints we get ;).

Going to install 2.6.29.1 (the one with network dropout fixed) once it appears.

]]

Thanks,

Andreas Mohr
