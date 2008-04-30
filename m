Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbYD3JZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbYD3JZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYD3JZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:25:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56506 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYD3JZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:25:33 -0400
Date: Wed, 30 Apr 2008 11:26:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       mchehab@infradead.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch, -git] drivers/media build fix for modular builds
Message-ID: <20080430092606.GB31644@uranus.ravnborg.org>
References: <20080429185009.716c3284@gaivota> <20080430074807.GA11224@elte.hu> <20080430.005212.46815036.davem@davemloft.net> <20080430081345.GA16519@elte.hu> <1209544030.30990.2.camel@marge.simson.net> <1209544951.15609.3.camel@marge.simson.net> <1209545784.31419.2.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209545784.31419.2.camel@marge.simson.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 10:56:24AM +0200, Mike Galbraith wrote:
> 
> On Wed, 2008-04-30 at 10:42 +0200, Mike Galbraith wrote:
> > On Wed, 2008-04-30 at 10:27 +0200, Mike Galbraith wrote:
> > > On Wed, 2008-04-30 at 10:13 +0200, Ingo Molnar wrote:
> > > > * David Miller <davem@davemloft.net> wrote:
> > > > 
> > > > > From: Ingo Molnar <mingo@elte.hu>
> > > > > Date: Wed, 30 Apr 2008 09:48:07 +0200
> > > > > 
> > > > > > 
> > > > > > fix allmodconfig build bug introduced in latest -git by commit 
> > > > > > 7c91f0624a9 ("V4L/DVB(7767): Move tuners to common/tuners"):
> > > > > > 
> > > > > >   LD      kernel/built-in.o
> > > > > >   LD      drivers/built-in.o
> > > > > >   ld: drivers/media/built-in.o: No such file: No such file or directory
> > > > > > 
> > > > > > which happens if all media drivers are modular:
> > > > > 
> > > > > I was seeing this too, as I think was Stephen Rothwell.
> > > > 
> > > > i think any build which has the media drivers only as modules will 
> > > > trigger it, so it's rather widespread. My fix has held up fine for 10 
> > > > randconfigs so far so it should do the trick.
> > > 
> > > You also have to make clean after today's pull or...
> > > 
> > > Kernel: arch/x86/boot/bzImage is ready  (#3)
> > > ERROR: "tea5761_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "microtune_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "simple_tuner_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tda9887_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "xc5000_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "xc2028_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tda829x_probe" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tda829x_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tea5767_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "xc2028_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > > ERROR: "simple_tuner_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > > ERROR: "tda827x_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > 
> > Hm, so I thought.  Error is constant.  Going back to .yesterday.
> 
> Turning CONFIG_MEDIA_ATTACH on fixed it.  I must have switched it somehow before.

So you did not have to do a make clean to make it build?
If make clean is needed then we have an issue in kbuild.

	Sam
