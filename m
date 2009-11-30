Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbZK3O2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbZK3O2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZK3O2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:28:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48316 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbZK3O2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:28:31 -0500
Date: Mon, 30 Nov 2009 12:28:14 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
       "Stefan Lippers-Hollmann" <s.L-H@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 2.6.32] V4L/DVB updates
Message-ID: <20091130122814.204b409b@pedra>
In-Reply-To: <20091130120332.1512e0c6@pedra>
References: <4B103CE1.8050303@redhat.com>
	<200911272240.02930.s.L-H@gmx.de>
	<200911280357.58116.hverkuil@xs4all.nl>
	<20091130120332.1512e0c6@pedra>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 30 Nov 2009 12:03:32 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Sat, 28 Nov 2009 03:57:58 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Friday 27 November 2009 22:40:01 Stefan Lippers-Hollmann wrote:
> > > Hi
> > > 
> > > On Friday 27 November 2009, Mauro Carvalho Chehab wrote:
> > > > Hi Linus,
> > > > 
> > > > Please pull from:
> > > >         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus
> > > > 
> > > > For the following drivers and building fixes:
> > > > 
> > > >    - radio-gemtek-pci: fix double mutex_lock
> > > >    - v4l: add more missing linux/sched.h includes
> > > >    - soc-camera: properly initialise the device object when reusing
> > > >    - soc-camera: sh_mobile_ceu_camera: call pm_runtime_disable
> > > >    - em28xx: fix Reddo DVB-C USB TV Box GPIO
> > > >    - davinci: remove stray duplicate config pointer
> > > >    - SMS_SIANO_MDTV should depend on HAS_DMA
> > > >    - cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)
> > > >    - sh_mobile_ceu_camera: fix compile warning
> > > >    - Fix wrong parameter order in memset
> > > [...]
> > > 
> > > Please consider cherry picking the following two patches from Hans 
> > > Verkuil [1]:
> > > - add the missing s2250-loader.h

I'm not finding the above patch. I remember I got one patch at the go7007
conversion series to V4L2 that were removing this patch that didn't exist
upstream. I had to manually fix the patch to apply at my linux-next tree.

The patches I actually merged from hans v4l-dvb-staging (after the tree rebase)
were:

changeset:   13455:0eb2e476ac2a
parent:      13372:8bff7e6c44d4
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Mon Nov 16 19:07:42 2009 +0100
summary:     go7007: Add struct v4l2_device.

changeset:   13456:f6f0c5647657
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Mon Nov 16 19:13:51 2009 +0100
summary:     s2250: Change module structure

changeset:   13457:701aead61759
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Mon Nov 16 19:15:07 2009 +0100
summary:     s2250: subdev conversion

changeset:   13458:2ca6a9dc112b
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Mon Nov 16 19:16:00 2009 +0100
summary:     go7007: subdev conversion

changeset:   13459:28dc36f9dfdc
parent:      13454:0ba581813fde
parent:      13458:2ca6a9dc112b
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Tue Nov 24 14:45:53 2009 -0200
summary:     merge: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-staging

Unfortunately, the original tree were already removed.

I suspect that hans didn't merge that patch on the latest version of
v4l-dvb-stating tree.

> > > - s2250 mutex patch

This one were merged on my tree:
	http://linuxtv.org/hg/v4l-dvb/rev/8bff7e6c44d4

However, I suspect that just applying it won't solve the compilation breakage.

> > 
> > Good catch. Mauro, can you please add these two as well for 2.6.32? I'm sure
> > I marked these two as high-prio patches. This staging driver is actively
> > being used and developed so this regression should be fixed.
> 
> There were a merge problem when applying those patches at -git. As this is a
> staging driver, I opted to just move all patches to linux-next, as there were
> no mention on the patch subject mentioned that they are, in fact, fixes.
> 
> I'll see what can we do to solve the s2250 compilation breakage.
> 
> As Linus didn't merge from this pull request yet, I'll work on a fix, based
> on one of the Stefan suggestions, preferably backporting the patches.
> 




Cheers,
Mauro
