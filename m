Return-Path: <linux-kernel-owner+w=401wt.eu-S965846AbXCLNsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965846AbXCLNsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965848AbXCLNsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:48:23 -0400
Received: from thunk.org ([69.25.196.29]:52032 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965846AbXCLNsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:48:22 -0400
Date: Mon, 12 Mar 2007 09:48:06 -0400
From: Theodore Tso <tytso@mit.edu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070312134806.GE4372@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
	Mike Galbraith <efault@gmx.de>,
	linux kernel mailing list <linux-kernel@vger.kernel.org>,
	ck list <ck@vds.kolivas.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <1173697024.8014.19.camel@Homer.simpson.net> <20070312110833.GA12835@elte.hu> <200703122223.07048.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703122223.07048.kernel@kolivas.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 10:23:06PM +1100, Con Kolivas wrote:
> > > > We are getting good interactive response with a fair scheduler yet
> > > > you seem intent on overloading it to find fault with it.
> > >
> > > I'm not trying to find fault, I'm TESTING AND REPORTING.  Was.
> >
> > Con, could you please take Mike's report of this regression seriously
> > and address it? Thanks,
> 
> Sure. 
> 
> Mike the cpu is being proportioned out perfectly according to fairness as I 
> mentioned in the prior email, yet X is getting the lower latency scheduling. 
> I'm not sure within the bounds of fairness what more would you have happen 
> to your liking with this test case?

Con,

	I think what we're discovering is that a "fair scheduler" is
not going to cut it.  After all, running X and ripping CD's and MP3
encoding them is not exactly an esoteric use case.  And like it or
not, "nice" defaults to 4.

	I suspect Mike is right; the only way to deal with this
regression is some scheduler hints from the desktop subsystem (i.e., X
and friends).  Yes, X is broken, it's horrible, yadda, yadda, yadda.
It's also what everyone is using, and it's a fact of life.  Just like
we occasionally have had to work around ISA braindamage, and x86
architecture braindamage, and ACPI braindamage all inflicted on us by
Intel.  This is just life, and sometimes the clean, elegant solution
is not enough.

	Regards,

						- Ted

P.S.  The other solution that might perhaps work is that we need to
change the meaning of what the nice value does.  If we consider "nice"
to be the scheduler hint (from the other direction), then maybe any
niced process should only run a very tiny amount if there are any
non-nice processes ready to run, and that the relative nice values are
used when two niced processes are competing for the CPU.....
