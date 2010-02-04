Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab0BDHtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:49:11 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:40581 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab0BDHtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:49:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VdHGNwzHXp7zzqP0SUOvvZKyf0coX93ZIS2N7Ozmv1SCpjKTtQknE2qi7bhfx/fSUG
         p5ja8bnunJrLMQ1ovk/BwC6w1E8CFes8pCDcWgVpLLFHddnkXuEN4BqcGBOEImeW7Wh+
         56nnIDxNlU4GMNSAossRwf4O58JewYCxwnurc=
MIME-Version: 1.0
In-Reply-To: <20100204073643.GA31291@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
	 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
	 <20100202081727.GA6788@elte.hu>
	 <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
	 <20100202154656.GD27314@elte.hu>
	 <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
	 <20100204062619.GA29154@elte.hu>
	 <21d7e9971002032239l5238f1fy33cafbd1ecc4b2bb@mail.gmail.com>
	 <20100204073643.GA31291@elte.hu>
Date: Thu, 4 Feb 2010 17:49:03 +1000
Message-ID: <21d7e9971002032349j3b06e6b7m6e662351a14c4698@mail.gmail.com>
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off 
	switch out of staging."
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 5:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Airlie <airlied@gmail.com> wrote:
>
>> >> On Wed, Feb 3, 2010 at 1:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >> >
>> >> > * Dave Airlie <airlied@gmail.com> wrote:
>> >> >
>> >> >> On Tue, Feb 2, 2010 at 6:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >> >> >
>> >> >> > * Dave Airlie <airlied@linux.ie> wrote:
>> >> >> >
>> >> >> >> > Hi Linus,
>> >> >> >> >
>> >> >> >> > Please pull the 'drm-linus' branch from
>> >> >> >> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>> >> >> >> >
>> >> >> >>
>> >> >> >> I've also added an oops fix I seem to lose off my radar to this tree.
>> >> >> >>
>> >> >> >> commit 17aafccab4352b422aa01fa6ebf82daff693a5b3
>> >> >> >> Author: Michel D??nzer <daenzer@vmware.com>
>> >> >> >> Date: ? Fri Jan 22 09:20:00 2010 +0100
>> >> >> >>
>> >> >> >> ? ? drm/radeon/kms: Fix oops after radeon_cs_parser_init() failure.
>> >> >> >
>> >> >>
>> >> >> Wierd this suggests something else is wrong on that machine can you get me
>> >> >> the whole dmesg? I'm guessing some iommu or swiotlb issue.
>> >> >
>> >> > This box has no known hardware or software problems, just this week it booted
>> >> > in excess of 1000 kernels so i'd exclude that angle for now.
>> >> >
>> >> > I have bisected the crash back to the DRM tree and the crash went away with
>> >> > the Kconfig revert i applied - and it got fixed by Jerome's patch. I posted
>> >> > my config and i posted the relevant boot log as well. Find below the full
>> >> > bootlog as well with vanilla -git (ab65832) and the config. (i dont think it
>> >> > matters)
>> >> >
>> >> >> I've asked Jerome to fix the oops, but really anyone with an old .config
>> >> >> won't get hit by this, and we've booted this on quite a lot of machines at
>> >> >> this point.
>> >> >
>> >> > I dont see the commit in yesterday's linux-next. It has very fresh
>> >> > timestamps:
>> >> >
>> >> > ?commit f71d0187987e691516cd10c2702f002c0e2f0edc
>> >> > ?Author: ? ? Dave Airlie <airlied@redhat.com>
>> >> > ?AuthorDate: Mon Feb 1 11:35:47 2010 +1000
>> >> > ?Commit: ? ? Dave Airlie <airlied@redhat.com>
>> >> > ?CommitDate: Mon Feb 1 11:35:47 2010 +1000
>> >> >
>> >> > What kind of widespread testing could this commit have gotten in the less
>> >> > than 24 hours before it hit mainline?
>> >> >
>> >>
>> >> Its shipping in a major distro by default, its planned to be shipped in an
>> >> even more major distro. Its been boot tested on 1000s of machines by 1000s
>> >> of ppl.
>> >
>> > Well but that's not the precise tree you sent to Linus, is it?
>>
>> It pretty much is. If I could blame your crash on any of the recent patches
>> I would but its something new and unfun. [...]
>
> You dont seem to realize the plain and simple fact that the bug (and some
> other bug) was obscure before because this particular KMS aspect of the
> radeon driver was in drivers/staging/, and it became more prominent via this
> post-rc6 commit:
>
>  | From f71d0187987e691516cd10c2702f002c0e2f0edc Mon Sep 17 00:00:00 2001
>  | From: Dave Airlie <airlied@redhat.com>
>  | Date: Mon, 1 Feb 2010 11:35:47 +1000
>  | Subject: [PATCH] drm/radeon/kms: move radeon KMS on/off switch out of staging.
>  |
>  | We are happy enough that the KMS driver is stable enough for enough people
>  | for the kms enable/disable to leave staging. Distros can now contemplate
>  | turning this on.
>  |
>  | Signed-off-by: Dave Airlie <airlied@redhat.com>
>  | ---
>  |  drivers/gpu/drm/Kconfig |    2 ++
>  |  drivers/staging/Kconfig |    2 --
>  |  2 files changed, 2 insertions(+), 2 deletions(-)
>
> I never claimed (and still dont claim) that the bug is 'new' per se, so why
> do you keep beating down on that straw man argument? I said it in my very
> first mail that this bug got brought upon us by the Kconfig commit above:
>
>> > It's the moving of radeom KMS out of staging after -rc6 that causes it,
>> > because it brought it into the scope of my testing:
>> >
>> >   f71d018: drm/radeon/kms: move radeon KMS on/off switch out of staging.
>> >
>> > So at least on this box it's clearly not ready for mainline enablement
>> > yet.
>
> I dont mind reporting bugs and testing patches (as i did), all i said is that
> from a QA angle it's somewhat late to do that in -rc7. (It's not even a
> completely new driver either, which people would know to stay away from -
> it's a new config option of an existing driver, so i'd expect many people to
> turn it on when they see it in the oldconfig - even though it's default-off.)
>
> You made the bug more prominent by moving it into the driver proper, after
> -rc6, and while i dont mind reporting and working on bugs, your constant
> denial is somewhat counter-productive, as (beyond the waste of time on these
> emails) it suggests that we might see repeat incidents of this kind in the
> future.
>
> Anyway, with two bugs in a row this commit is clearly too problematic for me
> so i have reverted f71d018 from -tip.
>

I haven't denied anything, I'm merely stating one bug on one machine isn't
the end of the known world.

the Kconfig clearly states you need to review your userspace to use this code,
so if people are turning things on blindly they are going to get problems. This
is true for all KMS drivers and will remain true. allytesconfig isn't something
that anyone runs in a non-test configuration. The only place you can get the
correct userspace is via a distro like F12 or Ubuntu in which case you've
already booted their kernel and not seen the problems, or have built all
the userspace anyways.

Jerome's patch fixes the oops part of the problem doesn't it? I'll be
pushing that out as soon
as I get some time to review it and fix the warning you saw. Look x86 has
broken a lot more shit at later rc times so please step down from that
high horse
please already.

Dave.
