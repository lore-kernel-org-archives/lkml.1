Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557Ab0AIWGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0AIWGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 17:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367Ab0AIWGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 17:06:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55386 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab0AIWGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 17:06:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH] i915: Always register as a PCI driver (was: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o KMS)
Date: Sat, 9 Jan 2010 23:07:03 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Anholt <eric@anholt.net>, Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
References: <201001090045.33784.rjw@sisk.pl> <201001091435.56157.rjw@sisk.pl> <21d7e9971001091341j313e6274vd883c0d5301b2586@mail.gmail.com>
In-Reply-To: <21d7e9971001091341j313e6274vd883c0d5301b2586@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001092307.04077.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 January 2010, Dave Airlie wrote:
> On Sat, Jan 9, 2010 at 11:35 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday 09 January 2010, Jesse Barnes wrote:
> >> On Fri, 8 Jan 2010 16:50:57 -0800 (PST)
> >> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >>
> >> >
> >> >
> >> > On Sat, 9 Jan 2010, Rafael J. Wysocki wrote:
> >> > >
> >> > > Which is functionally equivalent to my patch, because
> >> > > i915_suspend/resume() won't be called by drm_class_suspend/resume()
> >> > > in the KMS case anyway.
> >> >
> >> > Ahh, right you are - that class suspend function does a check for
> >> > DRIVER_MODESET, and only does the suspend/resume if it's not a
> >> > MODESET driver.
> >> >
> >> > Ok, so I withdraw my objections to your original patch - it's
> >> > confusing, but that's just because DRM is such a horrible mess with
> >> > subtle things.
> >>
> >> Yeah the non-KMS paths just suck.
> >>
> >> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> >>
> >> Though hopefully you can get the PCI driver registration working w/o
> >> too much trouble; that would be even better.
> >
> > Actually, I have a working patch, with one tiny detail I'm not sure of.
> >
> > Namely, I need to call pci_set_drvdata(pdev, dev) unconditionally in drm_stub.c
> > for the things to work, but I _think_ it won't hurt even if we're not going to
> > use the pdev's private data.
> >
> > The benefit of this is having just one code path for suspend/resume instead of
> > two different code paths depending on whether the driver is using the KMS or
> > not, which is well worth it IMO.
> >
> > The patch is appended.
> 
> NAK
> 
> for the reasons I explained in the previous email. This conflicts with systems
> where intelfb and intel drm are used together, this is something that ppl do use
> prior to KMS happening.
> 
> We just need to document in the headers why the hooks are needed,
> and maybe a bit of patch review to make sure nobody removes them again.

OK, so my original patch is the right one in that case.

Rafael
