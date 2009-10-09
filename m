Return-Path: <linux-kernel-owner+w=401wt.eu-S1760503AbZJIJYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbZJIJYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760494AbZJIJYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:24:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35861 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760492AbZJIJYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:24:44 -0400
Date: Fri, 9 Oct 2009 11:23:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [regressions] Re: kbuild: save ARCH & CROSS_COMPILE when
	building a kernel
Message-ID: <20091009092352.GA7381@elte.hu>
References: <20091003103441.GA10874@elte.hu> <1255078731.17055.39.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255078731.17055.39.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2009-10-03 at 12:34 +0200, Ingo Molnar wrote:
> > 
> > that arch-cache thing introduced in:
> > 
> >  5755433: kbuild: save ARCH & CROSS_COMPILE when building a kernel
> > 
> > isnt working very well in my experience.
> 
> Its breaking things for me too. When I build a .config using distcc 
> and cross compilers on my build farm, and then try a make install on 
> another machine which doesn't have either it utterly shits itself.
> 
> Please revert this.

I'm hitting problems with this several times a day.

I'm used to switching from 32-bit to 64-bit x86 kernels and now i have 
to via the extra 'make mrproper' and that's quite annoying as i already 
tell kbuild that i want a 64-bit config via:

  make ARCH=x86_64 defconfig

Why the extra forced step?

Also, there's things that need even more steps: i often take a config 
that triggers a breakage on 32-bit and change it to 64-bit via 'make 
oldconfig' - to see whether the bug is bitness invariant. I have to do 
something like:

  mv .config .config.tmp
  make mrproper
  mv .config.tmp .config
  make ARCH=x86_64 oldconfig

This doesnt look right at all.

	Ingo
