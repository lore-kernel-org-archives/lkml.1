Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0BDGjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 01:39:42 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:63664 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0BDGjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 01:39:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wZTN6CwEuiBUMAbqhZiHtrWkbKADyNNTDwrdi98Y6apHcNtapwmMOidzG4nV4JKtSQ
         Cg0eriIMJeCtV/5ll5DU6e1MYFUY0xLEEH/ubobqUOwGAAak0dq4Od8Y2xO3OVSoj1tg
         e/FjlTRbgUyWdSCwpm6meIB/Raq9u5YZbR7kA=
MIME-Version: 1.0
In-Reply-To: <20100204062619.GA29154@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
	 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
	 <20100202081727.GA6788@elte.hu>
	 <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
	 <20100202154656.GD27314@elte.hu>
	 <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
	 <20100204062619.GA29154@elte.hu>
Date: Thu, 4 Feb 2010 16:39:40 +1000
Message-ID: <21d7e9971002032239l5238f1fy33cafbd1ecc4b2bb@mail.gmail.com>
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off 
	switch out of staging."
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Wed, Feb 3, 2010 at 1:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Dave Airlie <airlied@gmail.com> wrote:
>> >
>> >> On Tue, Feb 2, 2010 at 6:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >> >
>> >> > * Dave Airlie <airlied@linux.ie> wrote:
>> >> >
>> >> >> > Hi Linus,
>> >> >> >
>> >> >> > Please pull the 'drm-linus' branch from
>> >> >> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>> >> >> >
>> >> >>
>> >> >> I've also added an oops fix I seem to lose off my radar to this tree.
>> >> >>
>> >> >> commit 17aafccab4352b422aa01fa6ebf82daff693a5b3
>> >> >> Author: Michel D??nzer <daenzer@vmware.com>
>> >> >> Date: ? Fri Jan 22 09:20:00 2010 +0100
>> >> >>
>> >> >> ? ? drm/radeon/kms: Fix oops after radeon_cs_parser_init() failure.
>> >> >
>> >>
>> >> Wierd this suggests something else is wrong on that machine can you get me
>> >> the whole dmesg? I'm guessing some iommu or swiotlb issue.
>> >
>> > This box has no known hardware or software problems, just this week it booted
>> > in excess of 1000 kernels so i'd exclude that angle for now.
>> >
>> > I have bisected the crash back to the DRM tree and the crash went away with
>> > the Kconfig revert i applied - and it got fixed by Jerome's patch. I posted
>> > my config and i posted the relevant boot log as well. Find below the full
>> > bootlog as well with vanilla -git (ab65832) and the config. (i dont think it
>> > matters)
>> >
>> >> I've asked Jerome to fix the oops, but really anyone with an old .config
>> >> won't get hit by this, and we've booted this on quite a lot of machines at
>> >> this point.
>> >
>> > I dont see the commit in yesterday's linux-next. It has very fresh
>> > timestamps:
>> >
>> > ?commit f71d0187987e691516cd10c2702f002c0e2f0edc
>> > ?Author: ? ? Dave Airlie <airlied@redhat.com>
>> > ?AuthorDate: Mon Feb 1 11:35:47 2010 +1000
>> > ?Commit: ? ? Dave Airlie <airlied@redhat.com>
>> > ?CommitDate: Mon Feb 1 11:35:47 2010 +1000
>> >
>> > What kind of widespread testing could this commit have gotten in the less
>> > than 24 hours before it hit mainline?
>> >
>>
>> Its shipping in a major distro by default, its planned to be shipped in an
>> even more major distro. Its been boot tested on 1000s of machines by 1000s
>> of ppl.
>
> Well but that's not the precise tree you sent to Linus, is it?

It pretty much is. If I could blame your crash on any of the recent
patches I would
but its something new and unfun. Most of the fixes in the Linus tree
are directly
from fixes to Fedora/Ubuntu bug reports.

even after reviewing the dmesg I can't see why its failing on that system,

If you could build 2.6.32 on that machine with the staging flag
enabled and see if
it works it would at least tell us if it is something in recent times
or just something
thats always been there.

Unless some other option in make allyesconfig is conflicting and we've never hit
it before. Fedora is close to allyesconfig but not pathalogical like
allyesconfig is.

Dave.
