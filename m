Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbYEDFgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbYEDFgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 01:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYEDFgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 01:36:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39602 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbYEDFgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 01:36:07 -0400
Date: Sun, 4 May 2008 07:36:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       linux-next@vger.kernel.org
Subject: Re: Strange linux-next build error
Message-ID: <20080504053639.GA14517@uranus.ravnborg.org>
References: <200805030121.39831.dhazelton@enter.net> <200805031825.50914.dhazelton@enter.net> <20080503224018.GB18344@elte.hu> <200805032137.09302.dhazelton@enter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805032137.09302.dhazelton@enter.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 09:37:07PM -0400, Daniel Hazelton wrote:
> On Saturday 03 May 2008 18:40:18 Ingo Molnar wrote:
> > * Daniel Hazelton <dhazelton@enter.net> wrote:
> > > > Can you try to do a:
> > > > make V=1 and post the output a few screen fulls before and until
> > > > the bug triggers.
> > > > They I will see if I can work out what is happening.
> > > >
> > > > Thanks,
> > > > 	Sam
> > >
> > > I've been unable to trigger it with "make V=1 bzImage" - does the
> > > verbosity change, somehow, the default number of makes that get run ?
> > >
> > > If it does, I could try adding -j2 or similar to see if that causes it
> > > to trigger.
> >
> > try something like:
> >
> >    make -j2 V=1 bzImage >log.txt 2>&1
> >
> > and see whether the error shows up in log.txt. Console output caused by
> > the increased verbosity (especially if it's a slower console like an
> > xterm) can hide build races.
> >
> > 	Ingo
> 
> And this appears to have been a false alarm. For the tests I did a clean pull 
> of the tree and started the build. When I kept *NOT* getting a build error on 
> the clean tree I started checking permissions and, while the files that this 
> error was happening for (and the containing directory) all had good 
> permissions, the correct ownerand all that - so I didn't look deeper. On 
> doing a deeper look it seems that there were some files and directories that 
> belonged to "root" and had 0644 for permissions.
> 
> After doing "make mrproper" and the reconfiguration I reset the owner/group on 
> the entire tree of files to be non-root and the build (at -j4) has finished 
> without a problem.
> 
> Sorry about that.

But this makes sense. We have/had a problem where we always rebuilded
wakeup.lds. So if you by accident have done "make bzImage" as root this
file would have been generated and thus belonging to root.
x86.git has the fix for this so we no longer do the wakeup.lds rebuild
for each kernel build and I expect it to hit both -next and -lins soon.

And I am very happy to nail down why - because having to much unexplained
issues with the build system will decrease the trust in it. And there I
do not want to go with kbuild - it helps no one.

Thanks for your feedback!

	Sam
