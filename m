Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbXKDSIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbXKDSIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXKDSI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:08:27 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49971 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbXKDSI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:08:26 -0500
Date: Sun, 4 Nov 2007 19:10:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, thomas@archlinux.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
Message-ID: <20071104181003.GB18771@uranus.ravnborg.org>
References: <20071103121149.GA22149@uranus.ravnborg.org> <20071104020217.GJ12045@stusta.de> <20071104100429.GA12311@elte.hu> <20071104.023133.241080055.davem@davemloft.net> <20071104152930.GL12045@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071104152930.GL12045@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > If people set something like CFLAGS in their environment, they must
> > understand what that means, and it means that universally it will
> > influence your Makefile based builds.  Yes, this means all of them and
> > even potentially the kernel build.
> > 
> > I definitely think the new kbuild CFLAGS behavior is just fine.  I
> > would never ever set CFLAGS globally in my environment and expect sane
> > things to happen.
> > 
> > If people do stupid things in their environment without being willing
> > to accept all of the consequences, that isn't a reason to not provide
> > this feature in kbuild.
> > 
> > Do you even understand that taking this out of kbuild will just push
> > the problem one level of indirection away?  Say this stupid CFLAGS
> > setting creaps into someone's gcc bootstrap, and that gcc miscompiles
> > the kernel.  You will have fun debugging that too, but I'm sad to say
> > you won't be able to pass the blame to kbuild on that one 8-/
> > 
> > It's just more proof that setting CFLAGS globally in your environment
> > is just plain stupid and asking for trouble.
> > 
> > Don't do it.
> 
> I'm not seeing what's stupid about this.
> 
> I had for years CFLAGS="-O2 -mcpu=v8" set in the environment on a
> machine where I compiled virtually all software (including gcc), and 
> different similar settings on other machines, without running into any 
> problems.
> 
> I also doubt it's wanted that the kernel picks up the -I/-L/-R flags
> I have set in some environments where many libraries are installed in 
> non-standard places.

I fully agree with David that people should realize that setting some
well-known variable can affect quite a lot.
But I also see that people use this for pure userspace issues.
So I will shortly submit a patch to Linus that uses KCFLAGS &
friends and warn if a value is picked up.

	Sam
