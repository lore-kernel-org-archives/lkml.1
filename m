Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbXKDPaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbXKDPaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 10:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbXKDP34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 10:29:56 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42067 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755920AbXKDP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 10:29:55 -0500
Date: Sun, 4 Nov 2007 16:29:30 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, sam@ravnborg.org, thomas@archlinux.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
Message-ID: <20071104152930.GL12045@stusta.de>
References: <20071103121149.GA22149@uranus.ravnborg.org> <20071104020217.GJ12045@stusta.de> <20071104100429.GA12311@elte.hu> <20071104.023133.241080055.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071104.023133.241080055.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 02:31:33AM -0800, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 4 Nov 2007 11:04:29 +0100
> 
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > I also have CFLAGS set on some computers in my environments since for 
> > > packages using GNU autoconf that's the correct way to set the compiler 
> > > flags.
> > > 
> > > The kernel already sets all flags correctly, and a user wanting to 
> > > change the flags for the kernel is an exception with very special 
> > > needs (I'd even claim so special that he could simply edit the 
> > > Makefile...).
>  ...
> > At minimum the extra CFLAGS needs to be put into the .config - but 
> > that's not a too nice solution either. How about just adding an 
> > extra-CFLAGS option to .config and perhaps a 'make configpickupCFLAGS' 
> > pass for anyone who wants to propagate the environment CFLAGS into the 
> > kernel build.
> 
> I totally disagree.
> 
> People can't have it both ways.  CFLAGS has global meaning in every
> Makefile based build tree, it's not an "autoconf" thing.  This is well
> established practice, and I think it's a good thing the kernel does it
> now too.

Makefiles do normally not pick such variables from the environment.

> If people set something like CFLAGS in their environment, they must
> understand what that means, and it means that universally it will
> influence your Makefile based builds.  Yes, this means all of them and
> even potentially the kernel build.
> 
> I definitely think the new kbuild CFLAGS behavior is just fine.  I
> would never ever set CFLAGS globally in my environment and expect sane
> things to happen.
> 
> If people do stupid things in their environment without being willing
> to accept all of the consequences, that isn't a reason to not provide
> this feature in kbuild.
> 
> Do you even understand that taking this out of kbuild will just push
> the problem one level of indirection away?  Say this stupid CFLAGS
> setting creaps into someone's gcc bootstrap, and that gcc miscompiles
> the kernel.  You will have fun debugging that too, but I'm sad to say
> you won't be able to pass the blame to kbuild on that one 8-/
> 
> It's just more proof that setting CFLAGS globally in your environment
> is just plain stupid and asking for trouble.
> 
> Don't do it.

I'm not seeing what's stupid about this.

I had for years CFLAGS="-O2 -mcpu=v8" set in the environment on a
machine where I compiled virtually all software (including gcc), and 
different similar settings on other machines, without running into any 
problems.

I also doubt it's wanted that the kernel picks up the -I/-L/-R flags
I have set in some environments where many libraries are installed in 
non-standard places.

Altogether:
- normally, Makefiles don't pick environment variables
- most open source software uses GNU autoconf
- GNU autoconf does pick environment variables
- GNU autoconf documents to set *FLAGS in the environment
- the kernel has different needs regarding the *FLAGS than userspace
- automatically using the *FLAGS people have set in their environment
  for userspace software in the kernel will cause problems
- the kernel should have already picked the optimal *FLAGS for you,
  and wanting different flags in the kernel is something quite exotic

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

