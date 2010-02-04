Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab0BDUdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:33:50 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:59866 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933156Ab0BDUds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:33:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bdp+rpUtYMxWIJeowdXna3eQdz4P8JGPrFP+cBesyHUCnZeAMMtPSI8NGWtvASQCllvYoqV1xAEp5ys11SjZZ02nCWE11BqLnNJCABVAyGEczqMNJyKbdQTze8VxGGtW;
Date: Thu, 4 Feb 2010 12:33:00 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alex Deucher <alexdeucher@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204123300.7497429b@jbarnes-piketon>
In-Reply-To: <20100204202254.GA24716@elte.hu>
References: <20100204170826.GA16397@elte.hu>
	<20100204173602.GA19855@srcf.ucam.org>
	<20100204175445.GB27361@elte.hu>
	<20100204175928.GA20595@srcf.ucam.org>
	<20100204181218.GA6175@elte.hu>
	<a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
	<20100204190649.GB6665@elte.hu>
	<a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
	<20100204193232.GD6665@elte.hu>
	<20100204115316.69beee75@jbarnes-piketon>
	<20100204202254.GA24716@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 21:22:54 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> > This is the .config issue right?  It doesn't sound like the bug is
> > new, you're just seeing now it because of the way you run tests.
> > It shouldn't affect any more or fewer users than it did before, and
> > reverting the "move radeon KMS out of staging" won't fix the bug at
> > all or prevent anyone from seeing it.  People using KMS will still
> > use KMS and people without it won't, [...]
> 
> I think you are missing my point. My point is very simple: existing
> non-KMS users of CONFIG_DRM_RADON=y (a pre-existing driver) might
> turn on the new sub-feature (CONFIG_DRM_RADEON_KMS=y), in the
> expectation that this is a safe addition to his currently
> well-working driver.

Oh I thought it was you who was missing the point, thus my
explanation. :)

Enabling KMS support is documented in Kconfig and doesn't default to
'y', so I don't know how valid your concern is, even though I
understand it.

> ( I have to confess i do that all the time for drivers that work well
> for me, and if it pops up in a late -rc i sure expect it to be safe
> to enable. I dont even read the help text most of the time - if the
> single-line summary sounds useful i enable it. Especially if the
> Kconfig help entry says it's safe with a new distro, it's not
> CONFIG_EXPERIMENTAL, it's not marked CONFIG_BROKEN, it's not in
> CONFIG_STAGING, etc. )
> 
> That action might hang or crash his kernel, and if that user then
> reports:
> 
>   " Hey, -rc7 just hung on me after enabling this new .config option
> it offered for the radeon driver i am using, please add this to the
> list of regressions. "
> 
> is this really the right kind of reply:
> 
>  " Since we moved it from drivers/staging/ to drivers/ this hang you
> are seeing is technically not a regression, we might or might not fix
> it. "
> 
> ?
> 
> I doubt the user would be overly enthusiastic about that kind of
> reply ;-)

Whether or not it's a regression is mostly irrelevant, it's a real bug
and the radeon guys are working on fixing it.  I really don't think
they'll be flooded with reports of this issue with the removal of the
staging dependency, but that's just my guess.

> Guys, you should really _think_ about it a minute and realize what
> the purpose of a regression policy is.

Everyone understands it, but really:
  - this is *not* a driver regression, the code is the same, you just
    don't need to enable staging to get it anymore
  - using allyesconfig or enabling non-default options requires thought
    and preferably reading the Kconfig text, so making this option more
    available should be generally safe (that doesn't mean it's bug free
    as you've discovered though).

> It's not to be a PITA to subsystem maintainers, it's not an annoyance
> just to keep you from doing cool stuff. It's not something which you
> should try to lawyer your way out of via an as narrow interpretation
> as you can.

I'm certainly not trying to split hairs here, I just think you're
overreacting to this issue by labeling it a regression and implying
that the commit should be reverted.

> A regression policy is something that generally helps the quality of
> Linux, so it's worth interpreting broadly and generously in spirit
> not just in letter. If there's a single most prominent complaint i
> hear about the upstream kernel is that it breaks too often. (right
> after 'it doesnt support my graphics hardware' - so i sure can relate
> to the pragmatic reasons of pushing KMS strongly!)

No one's going to say we shouldn't shoot for high quality, but hiding
things under a config option doesn't fix regressions, and making config
options easier to enable doesn't introduce them, this is still
ultimately a .config issue, not a new code regression.

But we've made too big a deal of this already; my interest in this bug
is purely academic.  I think it should be solved, and preferably not by
hiding the config option again, since that's totally irrelevant to the
real issue.

-- 
Jesse Barnes, Intel Open Source Technology Center
