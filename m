Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab0BDTc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:32:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355Ab0BDTcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:32:54 -0500
Date: Thu, 4 Feb 2010 20:32:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204193232.GD6665@elte.hu>
References: <20100204071705.GA28403@elte.hu>
 <20100204164859.GA17878@srcf.ucam.org>
 <20100204170826.GA16397@elte.hu>
 <20100204173602.GA19855@srcf.ucam.org>
 <20100204175445.GB27361@elte.hu>
 <20100204175928.GA20595@srcf.ucam.org>
 <20100204181218.GA6175@elte.hu>
 <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
 <20100204190649.GB6665@elte.hu>
 <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Deucher <alexdeucher@gmail.com> wrote:

> On Thu, Feb 4, 2010 at 2:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Alex Deucher <alexdeucher@gmail.com> wrote:
> >
> >> On Thu, Feb 4, 2010 at 1:12 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> >
> >> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >> >
> >> >> On Thu, Feb 04, 2010 at 06:54:45PM +0100, Ingo Molnar wrote:
> >> >>
> >> >> > But you could claim that it's not a regression because 1) technically the
> >> >> > code got introduced in drivers/staging/, and staging drivers are not on
> >> >> > the regression list 2) the Kconfig value is default-off so it can only
> >> >> > harm those who got lured by a new Kconfig value popping up in -rc7 in a
> >> >> > well working driver they already have enabled.
> >> >> >
> >> >> > So the moving of driver functionality from drivers/staging/ to drivers/
> >> >> > is a grey area it appears. Wouldnt it have been better to do this in the
> >> >> > next merge window, as all other drivers do? It's not new hardware
> >> >> > enablement either, it's feature enablement for an existing driver.
> >> >>
> >> >> The reason the option was in staging (as has been mentioned before) was
> >> >> because the ABI wasn't felt to be stable enough. Upstream is now willing to
> >> >> commit to that stability, so now seems as good a time to move it as any.
> >> >> There's no code change and there's no default configuration change, so I
> >> >> really can't see any way that it can be classed as a regression.
> >> >
> >> > But that argument in essence renders the regression policy meaningless for
> >> > such code: just about any new driver feature under the sun could be shaped as
> >> > a Kconfig option, introduced via a drivers/staging Kconfig entry, and then
> >> > activated via a twoliner commit in a later -rc.
> >> >
> >> > IMHO the point of tracking regressions is to reduce the bugginess of the
> >> > kernel and thus to help users, not to give ground for legalistic arguments.
> >> >
> >> > There _are_ common-sense exceptions from the regression rules, such as the
> >> > introduction of a new piece of hardware that was previously unsupported
> >> > (hence there's no expectation of stability) - but the tweaking of an
> >> > existing, widely used driver (even if the new opion is default-off) hardly
> >> > seems to qualify for that.
> >> >
> >>
> >> This is a completely new driver. ?It's only part of the existing drm for
> >> compatibility reasons. ?It requires an entirely different graphics stack
> >> above it and works very differently from the old drm stack.
> >
> > Will the user know? IMHO what matters in the end is user expectation.
> >
> > Lets walk through what a current kernel tester of the drm/radeon driver sees
> > when he types 'make oldconfig' after installing the (to-be-released) .33-rc7
> > kernel. Firstly, the user with a brand-new distro already has this enabled:
> >
> > ?CONFIG_DRM_RADEON=y
> >
> > and knows the driver, and it performs adequately. Then in -rc7 he gets a new
> > option:
> >
> > ?ATI Radeon (DRM_RADEON) [Y/n/?] y
> > ? ?Enable modesetting on radeon by default (DRM_RADEON_KMS) [N/y/?] (NEW)
> >
> > The user might easily go: "Hey this is a driver i already have, and there's a
> > new sub-option for this well-working driver. Sure, enable it, these kernel
> > folks know what they are doing and i rarely see any crashes past -rc2
> > kernels."
> >
> > Does this new option tell him what you just told me, that:
> >
> > ?> This is a completely new driver. ?It's only part of the existing drm for
> > ?> compatibility reasons. ?It requires an entirely different graphics stack
> > ?> above it and works very differently from the old drm stack.
> >
> > ?
> >
> > it doesnt. Even if he types '?', it tells:
> >
> > ?CONFIG_DRM_RADEON_KMS:
> >
> > ?Choose this option if you want kernel modesetting enabled by default,
> > ?and you have a new enough userspace to support this. Running old
> > ?userspaces with this enabled will cause pain.
> >
> > The user will likely go "cool I have a fresh distro with recent Xorg, lets
> > try it".
> >
> 
> And if it crashes, he'll report a bug and we'll fix it.

Nobody has reacted to my related boot hang bugreport yet - and it's detailed 
and fully reproducible (so i can test any proposed fixes as well in short 
order). I.e. my limited testing has triggered two separate bugs in the same 
driver - and this will show up in -rc7.

It might be all OK and no-one else will see trouble. Or past patterns might 
repeat themselves and i might simply be an early bird for trouble to come.

My (oft repeated) point is that adding new sub-features to existing drivers 
is not what we do in late -rc's: there's simply not enough time to shake out 
bugs/regressions in them.

We introduce new functionality to existing drivers in the merge window - in 
the two weeks following a stable kernel's release.

In late -rc's we only try to fix regressions. Sometimes we make exceptions 
for pragmatic reasons, but then we are straightforward about those reasons 
and try to warn users about our zeal to help them with cool, new, 
not-to-be-missed GPU functionality ;-)

Thanks,

	Ingo
