Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbYD3I4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbYD3I4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbYD3I43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:56:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:47816 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753960AbYD3I42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:56:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/NokcR4azN5mS73uWRGBLE6EmTWbcpNZr7o0mrO6
	MmROD2r6aLMiZS
Subject: Re: [patch, -git] drivers/media build fix for modular builds
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, mchehab@infradead.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1209544951.15609.3.camel@marge.simson.net>
References: <20080429185009.716c3284@gaivota>
	 <20080430074807.GA11224@elte.hu>
	 <20080430.005212.46815036.davem@davemloft.net>
	 <20080430081345.GA16519@elte.hu>
	 <1209544030.30990.2.camel@marge.simson.net>
	 <1209544951.15609.3.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 10:56:24 +0200
Message-Id: <1209545784.31419.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 10:42 +0200, Mike Galbraith wrote:
> On Wed, 2008-04-30 at 10:27 +0200, Mike Galbraith wrote:
> > On Wed, 2008-04-30 at 10:13 +0200, Ingo Molnar wrote:
> > > * David Miller <davem@davemloft.net> wrote:
> > > 
> > > > From: Ingo Molnar <mingo@elte.hu>
> > > > Date: Wed, 30 Apr 2008 09:48:07 +0200
> > > > 
> > > > > 
> > > > > fix allmodconfig build bug introduced in latest -git by commit 
> > > > > 7c91f0624a9 ("V4L/DVB(7767): Move tuners to common/tuners"):
> > > > > 
> > > > >   LD      kernel/built-in.o
> > > > >   LD      drivers/built-in.o
> > > > >   ld: drivers/media/built-in.o: No such file: No such file or directory
> > > > > 
> > > > > which happens if all media drivers are modular:
> > > > 
> > > > I was seeing this too, as I think was Stephen Rothwell.
> > > 
> > > i think any build which has the media drivers only as modules will 
> > > trigger it, so it's rather widespread. My fix has held up fine for 10 
> > > randconfigs so far so it should do the trick.
> > 
> > You also have to make clean after today's pull or...
> > 
> > Kernel: arch/x86/boot/bzImage is ready  (#3)
> > ERROR: "tea5761_attach" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "microtune_attach" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "simple_tuner_attach" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tda9887_attach" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "xc5000_attach" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "xc2028_attach" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tda829x_probe" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tda829x_attach" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tea5767_attach" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "xc2028_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > ERROR: "simple_tuner_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > ERROR: "tda827x_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> 
> Hm, so I thought.  Error is constant.  Going back to .yesterday.

Turning CONFIG_MEDIA_ATTACH on fixed it.  I must have switched it somehow before.


