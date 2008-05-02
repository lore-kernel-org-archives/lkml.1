Return-Path: <linux-kernel-owner+w=401wt.eu-S935219AbYEBN4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935219AbYEBN4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934567AbYEBN4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:56:37 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60658 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934255AbYEBN4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:56:36 -0400
Date: Fri, 2 May 2008 15:57:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Chris Knadle <Chris.Knadle@coredump.us>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, venkatesh.pallipadi@intel.com,
       davem@davemloft.net, trini@kernel.crashing.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080502135708.GA22929@uranus.ravnborg.org>
References: <20080501235558.GA20637@orac.ofobscurity.com> <200805021055.10602.alistair@devzero.co.uk> <20080502104348.GC20741@uranus.ravnborg.org> <200805021248.56797.alistair@devzero.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805021248.56797.alistair@devzero.co.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 12:48:55PM +0100, Alistair John Strachan wrote:
> On Friday 02 May 2008 11:43:48 Sam Ravnborg wrote:
> [snip]
> > > > > It's __GNUC_PATCHLEVEL__, I believe.
> > > > >
> > > > > So yes, we can distinguish 4.1.2 (good, and very common) from
> > > > > 4.1.{0,1} (bad, and rather uncommon).
> > > > > And yes, considering that 4.1.1 (and even more so 4.1.0) should be
> > > > > rare to begin with, I think it's better to just not support it.
> > > > >
> > > > >			Linus
> > > >
> > > >    Unfortunately Debian Stable (i.e. Etch), which is relatively popular
> > > > for server use, is still using 4.1.1  :-(  (The current gcc package is
> > > > gcc-4.1.1-21)
> > > >
> > > >    I have not looked to see if Debian Stable's gcc-4.1.1-21 has been
> > > > patched for the currently discussed __weak bug.
> > >
> > > I checked and it has been patched in 4.1.1-21. This would make checking
> > > for 4.1.1 via __GNUC_PATCHLEVEL__ potentially invalid, as patched distro
> > > compilers may (and in this case do) have this fixed.
> >
> > Is it possible to cook up a small sample file we could build as part
> > of the kernel build. If it fails => error out.
> > If someone comes up with the code I shall try to integrate it
> > in the build system.
> 
> The GCC PR has a test case for this regression which might be usable.
> 
> http://gcc.gnu.org/viewcvs/branches/gcc-4_1-branch/gcc/testsuite/gcc.dg/tree-ssa/pr27781.c?view=markup&pathrev=114852

OK, can anyone confirm that this fails to build which a
buggy gcc:


void __attribute__((weak)) func(void)
{
    /* no code */
}

int main()
{
    func();
    return 0;
}



	Sam
