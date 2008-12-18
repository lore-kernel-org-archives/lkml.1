Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752799AbYLRUtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYLRUtp (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYLRUtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:49:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55330 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYLRUte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:49:34 -0500
Subject: Re: linux-next: Tree for December 17 (Radeon DRM BUG)
From: Dave Airlie <airlied@redhat.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Kevin Winchester <kjwinchester@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200812182000.41727.bzolnier@gmail.com>
References: <20081217232536.0b18f4a7.sfr@canb.auug.org.au>
	 <494995D7.6090009@gmail.com>
	 <21d7e9970812172247t3d67e6f0waffa99587e2e024b@mail.gmail.com>
	 <200812182000.41727.bzolnier@gmail.com>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 06:49:15 +1000
Message-Id: <1229633355.5650.4.camel@optimus>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 20:00 +0100, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 18 December 2008, Dave Airlie wrote:
> > On Thu, Dec 18, 2008 at 10:14 AM, Kevin Winchester
> > <kjwinchester@gmail.com> wrote:
> > > Stephen Rothwell wrote:
> > >>
> > >> Hi all,
> > >>
> > >>
> > >
> > > I get the following BUG in the radeon drm code with today's linux-next when
> > > I run "startx".  I have not built or tested linux-next in a while, but the
> > > problem definitely does not occur in mainline.
> 
> [...]
> 
> This reminds me that drm tree in linux-next still results in BSOD (Black
> Screen Of Death) on starting X for me (as reported on Saturday [1]).
> 
> Actually there is more to it as I discovered that my custom X radeon driver
> (which is xorg-x11-drv-ati-6.9.0-61.fc10.i386 with "radeon: no need for this
> anymore" from radeon-gem-cs change reverted, please see [2] for my previous
> monologue) works fine while following stock driver versions:
> 
> 	xorg-x11-drv-ati-6.8.0-19.fc9.i386
> 	xorg-x11-drv-ati-6.9.0-61.fc10.i386
> 	xorg-x11-drv-ati-6.9.0-62.fc10.i386
> 
> result in BSOD.  OTOH they all work with next-20081128 (modulo hangs with
> fc10 ones when "radeon: no need for this anymore" change is not reverted).
> 
> [ BTW xorg-x11-drv-ati-6.9.0-62.fc10.i386 still causes hangs when used with
>   non-Fedora kernels and Fedora/kms kernel still has performance problems ]
> 
> IOW there are a lot of compatibility issues in recent drm/radeon changes.
> 
> Dave, could you please start looking into these problems?  I'm sure that we
> all want recent drm changes + kms in 2.6.29 but given tight schedule and the
> way things are looking right now I'm quite sceptical...
> 
> [1] http://lkml.org/lkml/2008/12/13/76
> [2] http://lkml.org/lkml/2008/12/13/77
> 

Bart,

please file bugs in RH bugzilla for Fedora issues. Fedora is shipping
drivers that aren't upstream, and I'm attempting to resolve the issues
as they arise. However not having a bug to track stuff in means it just
goes far enough out of my inbox that I forget about it.

The revert isn't a fix for -ati, and I haven't seen any reports of
performance problems with profiles attached in my bugzilla.

I'm booting drm-next on more various radeon hw today to see what I can
reproduce, most of the kms changes for 2.6.29 are nothing to do with
radeon at all, we are only upstreaming KMS for Intel hw, so I'm not sure
what the sceptical bit is about. Its much more likely this is
multi-master changes before KMS that are interacting badly.


Dave.


> Thanks,
> Bart

