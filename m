Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbYFMVEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbYFMVEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 17:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYFMVEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 17:04:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbYFMVDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 17:03:49 -0400
Date: Fri, 13 Jun 2008 23:02:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Lior Dotan <liodot@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [Bug 10866] /dev/rtc was missing until I disabled
	CONFIG_RTC_CLASS
Message-ID: <20080613210257.GA529@elte.hu>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <20080613193302.GA1716@cs181133002.pp.htv.fi> <a5bf86a80806131255w704745d7mc109c13669ac9c68@mail.gmail.com> <200806131343.41213.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806131343.41213.david-b@pacbell.net>
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

> On Friday 13 June 2008, Lior Dotan wrote:
> > I don't know if it helps you to decide but the way I got to this
> > configuration is by copying my working 2.6.25 .config file and running
> > make oldconfig. I think this scenario is common when upgrading to a
> > newer version so you should make sure it doesn't generate an invalid
> > configuration.
> 
> It doesn't!  "No /dev/rtc" is a perfectly valid config. [...]

The bug scenario is rather simple: /dev/rtc existed with that config in 
prior kernels and now, after "make oldconfig" it does not exist, it's a 
plain regression and must be fixed.

> And it's not uncommon that new kernels require config tweaks.

that's wrong - 'make oldconfig' must work smoothly and in an expected 
way.

If you argue that the new kernel should come up with a non-existent 
/dev/rtc, then you are wrong and you go against established regression 
handling policies of the kernel. Smooth migration via "make oldconfig" 
is a must, otherwise we'd lose testers and users.

The old /dev/rtc might indeed have been unbelievably "bad" in various 
ways and you dont even want to think about that code now, but it's your 
code now that is used so you might as well think about the other 98% of 
users who used the old /dev/rtc with old kernels. (not because they 
wanted to use bad code, but because simply that was the default)

	Ingo
