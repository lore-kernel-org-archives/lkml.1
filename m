Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbYECTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbYECTP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYECTPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:15:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51538 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbYECTPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:15:15 -0400
Date: Sat, 3 May 2008 21:14:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080503191445.GF5292@elte.hu>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501115923.GX29330@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@stusta.de> wrote:

> On Thu, May 01, 2008 at 04:52:34AM +0200, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > I would really appreciate it if you could send the error message 
> > > and the .config but not quick kconfig patches that are often wrong 
> > > and that you try to push through the maintainers as you tried 
> > > here.
> > 
> > hey, sorry about invading your turf of trivial patches ;) I dont see 
> > it as a problem that the thought process and the initial patch is 
> > incomplete and ad-hoc. My preference is to work with people out in 
> > the open, even on trivial issues. Dmitry is a capable maintainer who 
> > understands his code very well and he'll resist me if i'm full of 
> > it. Just like i resisted you when you were full of it. That's what 
> > maintainers do, their job is to know their code.
> > 
> > And, occasionally, as in this case, i might end up being faced with 
> > a bug in the code i maintain ;)
> 
> You completely miss my point.
> 
> You wrongly (and loudly) blamed Dmitry for something you broke 
> yourself.

i didnt. Read what i wrote:

|| no, you are wrong, read the current Kconfig rules again. If the user 
|| can create a .config that does not build, it is driver breakage. It 
|| always was, and has been in the past 15 years.
||
|| Kconfig might be extended to make dependencies easier to manage for 
|| developers but until that is implemented you have to craft your 
|| driver's dependencies with the current tools in a way that doesnt 
|| break the build.

and that's exactly what happens with Roman's patch: a Kconfig subsystem 
design bug (its inability to properly propagate the dependencies of 
select's) is worked around in the driver space: by the LEDS_CORE driver 
config introduction and no user-visible.

Roman's patch is obviously cleaner than my hack (i just fixed a single 
instantiation of the problem, while he changed the LEDS driver 
dependency structure), but it's still a workaround for a Kconfig 
subsystem bug and the same problem could reoccur elsewhere. It could hit 
anytime dual dependencies are introduced in a driver accidentally.

As Sam said it, fixing that Kconfig design bug would be "nice" - but 
unfortunately the Kconfig subsystem is not actively developed anymore. 
Would you like to volunteer for that? It would be a _very_ useful 
contribution. One such fix could avoid hundreds or even thousands of 
trivial problems in the future - it could avoid having to make hundreds 
or thousands of trivial patches in the future.

	Ingo
