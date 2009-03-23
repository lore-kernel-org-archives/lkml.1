Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZCWEgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZCWEgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 00:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZCWEgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 00:36:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZCWEgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 00:36:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/utrace
Cc: utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] utrace core
In-Reply-To: Andrew Morton's message of  Saturday, 21 March 2009 01:49:09 -0700 <20090321014909.6b654f55.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com>
	<20090321014140.AA4F5FC3AB@magilla.sf.frob.com>
	<20090321014909.6b654f55.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090323043520.0B447FC3AB@magilla.sf.frob.com>
Date: Sun, 22 Mar 2009 21:35:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd be interested in seeing a bit of discussion regarding the overall value
> of utrace - it has been quite a while since it floated past.

Me too!

> I assume that redoing ptrace to be a client of utrace _will_ happen, and
> that this is merely a cleanup exercise with no new user-visible features?

Yes.  It's my expectation that Oleg and I will do that clean-up in
several small stages, in the not-too-distant future.  I think more of
that work has to do with making the ptrace data structures clean and
sane than with utrace details.

> The "prototype utrace-ftrace interface" seems to be more a cool toy rather
> than a serious new kernel feature (yes?)

I don't personally have any experience with either Frank's utrace-ftrace
widget or with using any ftrace-based things to debug user programs.
I would guess it is more of a demonstration than a tool people will be
using in the long run.

> If so, what are the new killer utrace clients which would justify all these
> changes?

I hope I can leave those examples to the people who will write them.
utrace will be a failure if it only serves to underlie the things I want
to implement or can think up.  My intent is to open up this area of new
feature generation to the people who are killer hackers, but have been
daunted or turned off by the prospect of becoming killer ptrace innards
hackers.  (Only Oleg seems to have taken to that opportunity, or perhaps
he expected to wind up doing it as little as I did.)

> Also, is it still the case that RH are shipping utrace?  If so, for what
> reasons and what benefits are users seeing from it?

Fedora Rawhide has this current code, yes.  The people trying to
develop new features using utrace certainly like having it there.
(There really truly are people who like to build novel kernel modules
without compiling their own kernels from scratch.)  I won't try to
speak for them or their users.

> And I recall that there were real problems wiring up the Feb 2007 version
> of utrace to the ARM architecture.  Have those issues been resolved?  Are
> any problems expected for any architectures?

That was a misimpression.  There were never real problems for ARM,
only misunderstandings.  I'm sure the way I tried to stage the changes
at that time contributed to those misunderstandings arising as they
did.  Since then, all the arch requirements have been distilled into
the HAVE_ARCH_TRACEHOOK set that is already merged for several
architectures.  It is in the hands of each arch maintainer to update
their code to meet the HAVE_ARCH_TRACEHOOK requirements (I'm glad to
give advice when asked), and there is no porting work that is actually
specific to utrace itself.  (You just can't turn it on without
HAVE_ARCH_TRACEHOOK.)  Of course it is never all that unlikely that
some bits of the generic code will get some new tweaks brought to
light by making it work with a particular arch.  To my knowledge, the
strangest arch for cleaning up any of this stuff has always been ia64,
and sparc second; those arch maintainers have already done the
HAVE_ARCH_TRACEHOOK work.


Thanks,
Roland
