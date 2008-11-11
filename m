Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbYKKOFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbYKKOFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbYKKOEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:04:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50862 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735AbYKKOEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:04:23 -0500
Date: Tue, 11 Nov 2008 15:04:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 - Make CONFIG_OLPC dependent on CONFIG_MGEODE_LX
Message-ID: <20081111140406.GA3244@elte.hu>
References: <s5h3ahyqwmn.wl%tiwai@suse.de> <20081111125402.GB14989@elte.hu> <s5hzlk6pea6.wl%tiwai@suse.de> <20081111135306.GA32709@elte.hu> <s5hwsfapdoj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hwsfapdoj.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Takashi Iwai <tiwai@suse.de> wrote:

> At Tue, 11 Nov 2008 14:53:06 +0100,
> Ingo Molnar wrote:
> > 
> > 
> > * Takashi Iwai <tiwai@suse.de> wrote:
> > 
> > > At Tue, 11 Nov 2008 13:54:02 +0100,
> > > Ingo Molnar wrote:
> > > > 
> > > > 
> > > > * Takashi Iwai <tiwai@suse.de> wrote:
> > > > 
> > > > > The OLPC-specpfic codes require geode_gpio_*() functions although
> > > > > these functions are defined only with CONFIG_MGEODE_LX=y.
> > > > > Add a proper dependency to fix build errors.
> > > > > 
> > > > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > > 
> > > > hm, could you please send a .config that shows the build errors?
> > > 
> > > Here it is.  It's for today's linux-next.
> > 
> > hm, which tree did that build failure in linux-next originate from? 
> > Your config builds fine here with the latest x86 tree.
> 
> Ah, sorry, forgot to mention that the build error comes from the
> latest ALSA code.  It contains an OLPC-specific code that is enabled
> via CONFIG_OLPC like:
> 
> 	snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
> 
> where this includes geode_gpio_*() calls.
> 
> Of course, I can add an if in Makefile or create a new Kconfig, but 
> since asm/olpc.h itself includes asm/geode.h and contains 
> geode_gpio*() calls, it would be a proper fix to make CONFIG_OLPC 
> dependent on geode.

ah, okay, agreed - i was worried whether this is something affecting 
v2.6.28 or slipping through our testing before commits hit linux-next.

I've queued up your fix in tip/x86/kconfig, thanks Takashi!

	Ingo
