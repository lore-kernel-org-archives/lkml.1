Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYFNKio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYFNKio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYFNKie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:38:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51501 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYFNKid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:38:33 -0400
Date: Sat, 14 Jun 2008 12:38:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Lior Dotan <liodot@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [Bug 10866] /dev/rtc was missing until I disabled
	CONFIG_RTC_CLASS
Message-ID: <20080614103800.GA5349@elte.hu>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <200806131343.41213.david-b@pacbell.net> <20080613210257.GA529@elte.hu> <200806131538.54254.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806131538.54254.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* David Brownell <david-b@pacbell.net> wrote:

> On Friday 13 June 2008, Ingo Molnar wrote:
> > 
> > 	 Smooth migration via "make oldconfig" 
> > is a must, otherwise we'd lose testers and users.
> 
> Yes, but "smooth" doesn't mean there's never a need to cope with 
> kernel updates by running "xconfig" (or whatever).

you are arguing against the facts - just look at the report - /dev/rtc 
broke and that shouldnt have happened and should be fixed. No amount of 
talking you do here will produce a working config.

> In my own experience, several times a year I need to go back and patch 
> up a mess that "oldconfig" made.  Things drop out, things get added 
> ... it's the things that get *added* without even a by-your-leave 
> which often seem hardest to fix.

i have hit 1400 kernel bugs in the past 6 months alone on my 
testsystems. That does not mean kernel bugs are the norm and it does not 
entitle me to ignore kernel bugs in the future?

> The only thing that causes the least hiccup is someone who was for a 
> while using a bogus (and non-default) configuration.

uhm, there's no such thing as a "bogus configuration". The Kconfig rules 
for RTC (authored by you too) allowed it. If it "makes no sense" it's 
because you coded it so - deal with it, it's not hard. But instead of 
solving it (it is trivial) you are trying to push the blame to the user 
- and that is rather lame to do.

> Given a bogus configuration, how should it be fixed? [...]

this is not rocket science. The solution is to turn on the fine RTC 
code, if the old config option is enabled too. I.e. be more careful 
about compatibility. It's still possible to solve this problem and allow 
the RTC code to be compiled out completely.

and note that you are hurting users who tried out _your_ RTC code (which 
was default off in the past) previously. Yes, while experimenting with 
your code they might have created the "wrong" mix of config options but 
that's not a problem - this isnt some esoteric embedded platform where 
only real men are allowed to configure the kernel and who are left out 
in the cold if they mess up - this is Linux where we encourage (and beg) 
actual user to test our kernels. So please show some basic respect 
towards them and dont arbitrarily declare configs "broken" that were 
working in the past.

	Ingo
