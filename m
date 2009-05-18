Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZERBui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZERBui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 21:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZERBu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 21:50:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:33935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbZERBu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 21:50:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,208,1241420400"; 
   d="scan'208";a="516403684"
Date: Mon, 18 May 2009 09:50:26 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
       Karsten Mehrhoff <kawime@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "stable@kernel.org" <stable@kernel.org>, Dave Airlie <airlied@linux.ie>
Subject: Re: PROBLEM: 2.6.29.2 - AGP doesn't work anymore on my nforce2
Message-ID: <20090518015026.GA15692@sli10-desk.sh.intel.com>
References: <op.us6ywl2jgp7xae@127.0.0.1> <20090430175927.a89f1cd3.akpm@linux-foundation.org> <1241179733.2606.1.camel@localhost.localdomain> <55bc079c-5c3d-465a-be28-0e38c0b48b14@rrsmsx603.amr.corp.intel.com> <20090504014151.GA22872@sli10-desk.sh.intel.com> <op.utd626zcgp7xae@127.0.0.1> <1241449660.24202.1041.camel@thor.local> <op.uteygpgpgp7xae@127.0.0.1> <1241455252.29445.49.camel@thor.local> <20090516164420.3319334c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090516164420.3319334c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 07:44:20AM +0800, Andrew Morton wrote:
> On Mon, 04 May 2009 18:40:52 +0200 Michel D__nzer <michel@daenzer.net> wrote:
> 
> > On Mon, 2009-05-04 at 18:23 +0200, Karsten Mehrhoff wrote:
> > > On Mon, 04 May 2009 17:07:40 +0200, Michel D__nzer wrote:
> > > > On Mon, 2009-05-04 at 08:31 +0200, Karsten Mehrhoff wrote:
> > > >> On Mon, 04 May 2009 03:41:51 +0200, Shaohua Li wrote:
> > > >>> On Fri, May 01, 2009 at 09:22:19PM +0800, kawime@gmx.de wrote:
> > > >>>>> On Thu, 2009-04-30 at 17:59 -0700, Andrew Morton wrote:
> > > >>>>>> On Thu, 30 Apr 2009 10:51:47 +0200
> > > >>>>>> Karsten Mehrhoff wrote:
> > > >>>>>>
> > > >>>>>>> [1.]
> > > >>>>>>> PROBLEM: No more agp card functionality with the patch 2.6.29.2 of
> > > >>>>>> 'a/drivers/char/agp/generic.c'
> > > >>>>>>>
> > > >>>>>>> [2.]
> > > >>>>>>> I compiled the kernel 2.6.29.2 with my .config of 2.6.29.1 and run
> > > >>>>>> into problems with the speed of my ATI RADEON 9600 (rv350)
> > > >>>>>>>
> > > >>>>>>
> > > >>>>>
> > > >>>>> Is your problem speed issue ? ie just a slowdown ? Or does AGP stop
> > > >>>>> working with this patch ? Slowdown is expected from this patch but
> > > >>>>> it should hurt too much.
> > > >>>>>
> > > >>>>
> > > >>>>                        2.6.29.1  | 2.6.29.2
> > > >>>>                         --------  |  --------
> > > >>>> glxgears             ~ 2900 FPS  |  ~ 75 FPS
> > > >>>> glxgears -fullscreen ~  500 FPS  |  ~ 11 FPS
> > > >>> Does this patch alone give so huge slowdown? From my little knowledge,
> > > >>> xserver
> > > >>> does agp pages allocation only at startup.
> > > >>
> > > >> I only reverted this patch in the source file  
> > > >> (/drivers/char/agp/generic.c) and got back my old speed on 2.6.29.2.
> > > >
> > > > Is the DRI enabled in both cases? Compare the Xorg.0.log file and the
> > > > output of
> > > >
> > > > dmesg|grep -e agp -e drm
> > > >
> > > 
> > > 
> > > *********************************
> > > 2.6.29.2 (original) 
> > > *********************************
> > > 
> > > $ dmesg|grep -e agp -e drm
> > > $ dmesg|grep agp
> > > [    0.861997] Linux agpgart interface v0.103
> > > [   10.893793] agpgart: Detected NVIDIA nForce2 chipset
> > > [   10.939070] agpgart-nvidia 0000:00:00.0: AGP aperture is 64M @ 0xe0000000
> > 
> > No drm lines?
> > 
> > 
> > > $ glxinfo | grep direct
> > > direct rendering: Yes
> > 
> > This is not a sufficient test anymore since swrast_dri.so is direct
> > rendering but not hardware accelerated. Something like
> > 
> > glxinfo|grep render
> > 
> > can be used to verify both direct rendering and hardware acceleration
> > (the latter but not the former is also possible with AIGLX).
> > 
> > 
> > > (EE) RADEON(0): [agp] AGP failed to initialize. Disabling the DRI.
> > 
> > [...]
> > 
> > > For me it seems that agp failed to initialize because of the patch.
> > 
> > Indeed.
> > 
> 
> Guys, can we rev this up again please?
> 
> AFAICT we have two problems and at least one of them is in 2.6.29.x and
> is presumably headed into 2.6.30 as well.
the slowdown Karsten saw is because dri is disabled. I can't image why zero
page will cause such issue. please double check if this is really caused by
59de2bebabc5027f93df999d59cc65df591c3e6e.

Thanks,
Shaohua
