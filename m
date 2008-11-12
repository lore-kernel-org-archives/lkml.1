Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYKLOW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYKLOW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 09:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYKLOWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 09:22:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57177 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYKLOWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 09:22:48 -0500
Subject: Re: [PATCH] x86 - Make CONFIG_OLPC dependent on CONFIG_MGEODE_LX
From: Jeremy Katz <katzj@redhat.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Ingo Molnar <mingo@elte.hu>, Takashi Iwai <tiwai@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
In-Reply-To: <20081109201710.4c490f04@debxo>
References: <s5h3ahyqwmn.wl%tiwai@suse.de> <20081111125402.GB14989@elte.hu>
	 <s5hzlk6pea6.wl%tiwai@suse.de> <20081111135306.GA32709@elte.hu>
	 <s5hwsfapdoj.wl%tiwai@suse.de> <20081111140406.GA3244@elte.hu>
	 <20081109201710.4c490f04@debxo>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 08:54:10 -0500
Message-Id: <1226498050.12791.45.camel@aglarond.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-09 at 20:17 -0800, Andres Salomon wrote:
> On Tue, 11 Nov 2008 15:04:06 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Takashi Iwai <tiwai@suse.de> wrote:
> > 
> > > At Tue, 11 Nov 2008 14:53:06 +0100,
> > > Ingo Molnar wrote:
> > > > 
> > > > 
> > > > * Takashi Iwai <tiwai@suse.de> wrote:
> > > > 
> > > > > At Tue, 11 Nov 2008 13:54:02 +0100,
> > > > > Ingo Molnar wrote:
> > > > > > 
> > > > > > 
> > > > > > * Takashi Iwai <tiwai@suse.de> wrote:
> > > > > > 
> > > > > > > The OLPC-specpfic codes require geode_gpio_*() functions
> > > > > > > although these functions are defined only with
> > > > > > > CONFIG_MGEODE_LX=y. Add a proper dependency to fix build
> > > > > > > errors.
> > > > > > > 
> > > > > > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > > > > 
> > > > > > hm, could you please send a .config that shows the build
> > > > > > errors?
> > > > > 
> > > > > Here it is.  It's for today's linux-next.
> > > > 
> > > > hm, which tree did that build failure in linux-next originate
> > > > from? Your config builds fine here with the latest x86 tree.
> > > 
> > > Ah, sorry, forgot to mention that the build error comes from the
> > > latest ALSA code.  It contains an OLPC-specific code that is enabled
> > > via CONFIG_OLPC like:
> > > 
> > > 	snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
> > > 
> > > where this includes geode_gpio_*() calls.
> > > 
> > > Of course, I can add an if in Makefile or create a new Kconfig, but 
> > > since asm/olpc.h itself includes asm/geode.h and contains 
> > > geode_gpio*() calls, it would be a proper fix to make CONFIG_OLPC 
> > > dependent on geode.
> > 
> > ah, okay, agreed - i was worried whether this is something affecting 
> > v2.6.28 or slipping through our testing before commits hit linux-next.
> > 
> > I've queued up your fix in tip/x86/kconfig, thanks Takashi!
>
> This works for now (though it's probably going to anger some people who
> are trying to make generic distro kernels), 

It's not about angering, it's about causing regressions in
functionality.  Doing this will completely break the ability to run
generic distros on the OLPC hardware without a special kernel.  Which
has been something that a lot of work has gone on upstream to avoid for
all sorts of cases (VMI, Xen, SMP, ...).  

> but what we really need to
> do is to make geode_gpio* defined even when we're not specifically
> building with MGEODE_LX.  I'm not sure how best to do that, but the
> answer probably includes using the generic x86 gpio api.

This probably needs to be done as a precondition for getting the alsa
changes merged or the alsa changes need to have the bits which depend on
geode_gpio ripped out until it can be done.  Or those parts
conditionalized.  Drivers should not depend on what cpu type you're
building for...

Jeremy

