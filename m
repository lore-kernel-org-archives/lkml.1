Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683Ab0B0THF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 14:07:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030653Ab0B0THC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 14:07:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next requirements
Date: Sat, 27 Feb 2010 20:07:42 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rjw; KDE/4.3.5; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
References: <20100211195614.886724710@sbs-t61.sc.intel.com> <201002271323.14402.rjw@sisk.pl> <20100227124710.GA21164@elte.hu>
In-Reply-To: <20100227124710.GA21164@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002272007.43042.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 February 2010, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > > Lets see.  Over the last 60 days, I have reported 37 build errors.  Of 
> > > > these, 16 were reported against x86, 14 against ppc, 7 against other 
> > > > archs.
> > > 
> > > So only 43% of them were even relevant on the platform that 95+% of the 
> > > Linux testers use? Seems to support the points i made.
> > 
> > Well, I hope you don't mean that because the majority of bug reporters (vs 
> > testers, the number of whom is unknown to me at least) use x86, we are free 
> > to break the other architectures. ;-)
> 
> It means exactly that: just like we 'can' break compilation with gcc296, 
> ancient versions of binutils, odd bootloaders, can break the boot via odd 
> hardware, etc. When someone uses that architectures then the 'easy' bugfixes 
> will actually flow in very quickly and without much fuss

Then I don't understand what the problem with getting them in at the linux-next
stage is.  They are necessary anyway, so we'll need to add them sooner or
later and IMO the sooner the better.

Apart from this, that cross-build issues aren't always "easy" and sometimes
they take quite some time and engineering effort to resolve.  IMO that's better
done at the linux-next stage than during a merge window.

> - and without burdening developers to consider cases they have no good ways
> to test.  Why should rare architectures be more important than those other
> rare forms of Linux usage?

Because the Linus' tree is supposed to build on those architectures.  As long
as that's the case, linux-next should build on them too.

> In fact those rare ways of building and booting the kernel i mentioned are 
> probably used _more_ than half of the architectures that linux-next 
> build-tests ...

I don't know and you don't know either.  That's just pure speculation and
therefore meaningless.

> So yes, of course _all_ bugs need fixing if there's enough capacity, but the 
> process in general should be healthy, low-overhead and shouldnt concentrate on 
> an irrelevant portion of Linux usage in such a prominent way.
> 
> Or, if it does, it should _first_ cover the other, much more burning areas of 
> testing interest. All the while our _real_ bugreports are often rotting on 
> bugzilla.kernel.org ...

All right.  There are two _separate_ questions to ask IMO:

(1) Do we need the kind of community service that Stephen has been doing?

(2) Do we need more testing of linux-next and if so, who's task should that be?

I think you agree that the aswer to (1) is "yes, we do".  So _someone_ has to
do it and I'm very grateful to Stephen for taking care of it.

[Thanks, Stephen!]

Now, the part of this service is to check that the resulting tree will actually
build in all conditions it's supposed to build in, if possible, or the whole
merging exercise wouldn't have much practical meaning.  Stephen has been
doing just that and IMO to a good result.

To some extent, though, that's a matter of defining in what conditions the
kernel is supposed to build in, but I think for linux-next these conditions
should be the same as for the Linus' tree, for the simple reason that
linux-next is supposed to be a "future snapshot" of it.   So linux-next should
build on all architectures that the future Linus' tree is supposed to build on.
Even on "exotic" ones.

[IMO that's actually important, because such corner cases tend to reveal
runtime bugs we wouldn't have been aware of otherwise.  Now, in the majority
of cases a casual tester will be discouraged by the kernel not compiling for
him while he might have found a "real" bug otherwise.]

Now, as far as (2) and is concerned, I think the answer here is also "yes, we
do", but that's not a part of the Stephen's job.

Thanks,
Rafael
