Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbYEBKn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbYEBKn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759422AbYEBKnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:43:18 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49236 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759219AbYEBKnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:43:17 -0400
Date: Fri, 2 May 2008 12:43:48 +0200
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
Message-ID: <20080502104348.GC20741@uranus.ravnborg.org>
References: <20080501235558.GA20637@orac.ofobscurity.com> <200805021055.10602.alistair@devzero.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805021055.10602.alistair@devzero.co.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 10:55:09AM +0100, Alistair John Strachan wrote:
> Hi Chris,
> 
> (I fixed the corrupted CC and Reply-to: address from your email.)
> 
> On Friday 02 May 2008 00:55:58 Chris Knadle wrote:
> > On Thu, 1 May 2008, Linus Torvalds wrote:
> > > On Thu, 1 May 2008, Andrew Morton wrote:
> > > > > I see only the following choices:
> > > > > - remove __weak and replace all current usages
> > > > > - move all __weak functions into own files, and ensure that also
> > > > > happens for future usages
> > > > > - #error for gcc 4.1.{0,1}
> > > >
> > > > Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?
> > >
> > > It's __GNUC_PATCHLEVEL__, I believe.
> > >
> > > So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1}
> > > (bad, and rather uncommon).
> > > And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare
> > > to begin with, I think it's better to just not support it.
> > >
> > >			Linus
> >
> >    Unfortunately Debian Stable (i.e. Etch), which is relatively popular for
> > server use, is still using 4.1.1  :-(  (The current gcc package is
> > gcc-4.1.1-21)
> >
> >    I have not looked to see if Debian Stable's gcc-4.1.1-21 has been
> > patched for the currently discussed __weak bug.
> 
> I checked and it has been patched in 4.1.1-21. This would make checking for 
> 4.1.1 via __GNUC_PATCHLEVEL__ potentially invalid, as patched distro 
> compilers may (and in this case do) have this fixed.

Is it possible to cook up a small sample file we could build as part
of the kernel build. If it fails => error out.
If someone comes up with the code I shall try to integrate it
in the build system.

	Sam
