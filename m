Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYKKSQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYKKSQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYKKSQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:16:22 -0500
Received: from mail.queued.net ([207.210.101.209]:1646 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbYKKSQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:16:21 -0500
Date: Sun, 9 Nov 2008 20:17:10 -0800
From: Andres Salomon <dilinger@queued.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Takashi Iwai <tiwai@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org, Jeremy Katz <katzj@redhat.com>
Subject: Re: [PATCH] x86 - Make CONFIG_OLPC dependent on CONFIG_MGEODE_LX
Message-ID: <20081109201710.4c490f04@debxo>
In-Reply-To: <20081111140406.GA3244@elte.hu>
References: <s5h3ahyqwmn.wl%tiwai@suse.de>
	<20081111125402.GB14989@elte.hu>
	<s5hzlk6pea6.wl%tiwai@suse.de>
	<20081111135306.GA32709@elte.hu>
	<s5hwsfapdoj.wl%tiwai@suse.de>
	<20081111140406.GA3244@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 15:04:06 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Takashi Iwai <tiwai@suse.de> wrote:
> 
> > At Tue, 11 Nov 2008 14:53:06 +0100,
> > Ingo Molnar wrote:
> > > 
> > > 
> > > * Takashi Iwai <tiwai@suse.de> wrote:
> > > 
> > > > At Tue, 11 Nov 2008 13:54:02 +0100,
> > > > Ingo Molnar wrote:
> > > > > 
> > > > > 
> > > > > * Takashi Iwai <tiwai@suse.de> wrote:
> > > > > 
> > > > > > The OLPC-specpfic codes require geode_gpio_*() functions
> > > > > > although these functions are defined only with
> > > > > > CONFIG_MGEODE_LX=y. Add a proper dependency to fix build
> > > > > > errors.
> > > > > > 
> > > > > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > > > 
> > > > > hm, could you please send a .config that shows the build
> > > > > errors?
> > > > 
> > > > Here it is.  It's for today's linux-next.
> > > 
> > > hm, which tree did that build failure in linux-next originate
> > > from? Your config builds fine here with the latest x86 tree.
> > 
> > Ah, sorry, forgot to mention that the build error comes from the
> > latest ALSA code.  It contains an OLPC-specific code that is enabled
> > via CONFIG_OLPC like:
> > 
> > 	snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
> > 
> > where this includes geode_gpio_*() calls.
> > 
> > Of course, I can add an if in Makefile or create a new Kconfig, but 
> > since asm/olpc.h itself includes asm/geode.h and contains 
> > geode_gpio*() calls, it would be a proper fix to make CONFIG_OLPC 
> > dependent on geode.
> 
> ah, okay, agreed - i was worried whether this is something affecting 
> v2.6.28 or slipping through our testing before commits hit linux-next.
> 
> I've queued up your fix in tip/x86/kconfig, thanks Takashi!
> 
> 	Ingo


This works for now (though it's probably going to anger some people who
are trying to make generic distro kernels), but what we really need to
do is to make geode_gpio* defined even when we're not specifically
building with MGEODE_LX.  I'm not sure how best to do that, but the
answer probably includes using the generic x86 gpio api.
