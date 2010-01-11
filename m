Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313Ab0AKUWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0AKUWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254Ab0AKUV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:21:59 -0500
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:36766 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754215Ab0AKUV6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:21:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BOHLy5pzT3rK49i3NS+ubbDU5gm6Ks730khH3VrA9GLXMGF+9HKEGupmBBJkTrtKCefcO24rjnVmb+OOOO9gF1ER/LtuSkTnuOLrFwJ/DcIPeU41c+VMLEaxwIZrMJU9;
Date: Mon, 11 Jan 2010 12:22:01 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jerome Glisse <glisse@freedesktop.org>, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
  KMS
Message-ID: <20100111122201.153352d6@jbarnes-piketon>
In-Reply-To: <21d7e9971001111212h1ded5292l94d514c6f5a47cd4@mail.gmail.com>
References: <201001090045.33784.rjw@sisk.pl>
	<alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
	<alpine.DEB.2.00.1001090214220.21286@skynet.skynet.ie>
	<20100108185041.7aae6c01@jbarnes-piketon>
	<20100109120141.GA4319@localhost.localdomain>
	<alpine.LFD.2.00.1001091012080.7821@localhost.localdomain>
	<21d7e9971001091332v23ac0e28m1b1890cd667aacb8@mail.gmail.com>
	<20100111083825.4c2bb7b3@jbarnes-piketon>
	<21d7e9971001111212h1ded5292l94d514c6f5a47cd4@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 06:12:37 +1000
Dave Airlie <airlied@gmail.com> wrote:

> On Tue, Jan 12, 2010 at 2:38 AM, Jesse Barnes
> <jbarnes@virtuousgeek.org> wrote:
> > On Sun, 10 Jan 2010 07:32:30 +1000
> > Dave Airlie <airlied@gmail.com> wrote:
> >> I'm in the 2-3 years at a minimum, with at least one kernel with no
> >> serious regressions in Intel KMS, which we haven't gotten close to
> >> yet. I'm not even sure the Intel guys are taking stable seriously
> >> enough yet. So far I don't think there is one kernel release (even
> >> stable) that works on all Intel chipsets without
> >> backporting patches. 2.6.32 needs the changes to remove the messed
> >> up render clock hacks which should really have been reverted a lot
> >> earlier since we had a lot of regression reports. The number of
> >> users using powersave=0 to get anything approaching useable is
> >> growing etc.
> >
> > But you could apply that argument to the existing DRM code (not just
> > Intel) as well; lots of things are broken or unimplemented and never
> > get fixed.  I'd say the right metric isn't whether regressions are
> > introduced (usually due to new features) but whether the driver is
> > better than the old userspace code.  For Intel at least, I think
> > we're already there.  The quality of the kernel driver is higher
> > and it has many more features than the userspace implementation
> > ever did.  That's just my subjective opinion, but I've done a *lot*
> > of work on our bugs both in userspace and in the kernel, so I think
> > it's an accurate statement.
> 
> The problem is at any single point in time I'm not sure a kms kernel
> exists that works across all the Intel hw, which from a distro POV is
> a real pain in the ass, a regression gets fixed on one piece of hw
> just as another on a different piece gets introduced.
> 
> I'd really like if Intel devs could either slow it down and do more
> testing before pushing to Linus, or be a lot quicker with the reverts
> when stuff is identified. The main thing is the render reclocking
> lately, thats been a nightmare and as far as I can see 2.6.32.3 still
> has all the issues,

Yeah, it may have been better to just revert that early on, but some
users really wanted the power saving features too, so it wasn't totally
clear cut (btw stable has a revert patch queued up now that fixes things
for several people).

> > It doesn't have to happen anytime soon, I was just thinking that
> > removing the old, pre-KMS code would make it easier to avoid
> > introducing regressions since we'd have one less config (a bit one
> > atthat) to worry about.
> 
> Maybe in 3-4 years.

Ouch, it just went from 2-3 to 3-4.  But really the other drm drivers
have to get converted anyway before we can really start killing code.

-- 
Jesse Barnes, Intel Open Source Technology Center
