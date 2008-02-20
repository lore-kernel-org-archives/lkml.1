Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbYBTThV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbYBTThV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYBTThB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:37:01 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:43732 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbYBTThA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:37:00 -0500
Date: Wed, 20 Feb 2008 20:37:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Gordon Farquharson <gordonfarquharson@gmail.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com, stefano.brivio@polimi.it,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       viro@ftp.linux.org.uk
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Message-ID: <20080220193709.GD21139@uranus.ravnborg.org>
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802191141.26952.mb@bu3sch.de> <97a0a9ac0802191644x693cd34cq6b167756df9c65f4@mail.gmail.com> <200802201544.05192.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802201544.05192.mb@bu3sch.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 03:44:04PM +0100, Michael Buesch wrote:
> On Wednesday 20 February 2008 01:44:38 Gordon Farquharson wrote:
> > Hi Michael
> > 
> > On Feb 19, 2008 3:41 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > 
> > > > [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7492d4a416d68ab4bd254b36ffcc4e0138daa8ff
> > > >
> > >
> > > That doesn't cause me to magically sign off this sort of patches, too.
> > > The sanity check is clearly broken in file2alias.c, as it checks something
> > > from the target kernel against the host environment it is compiled on.
> > > That doesn't make any sense at all.
> > 
> > I think that you make some good points, but I'm at a loss as to how to
> > fix the problem. Do you have any suggestions?
> 
> Remove the broken sanity check, if it's not possible the check there.
The check is valid for > 99% of the kernel builds as
cross compile builds are not that typical.
And the check is there for the sake of modutils.

The details I do not remember.
So we have a few possiblities:

1) Remove the consistency check and try to deal with the
rare cases where it fails and spend many hours investigating
before we realise it is difference in layout of data.

2) Pad a few structures with a few bytes so this consitency
check works even in cross build environments.

3) Detect that we are doing cross builds and skip the check
in this case.

Option 1) is the worst of the three as that can cost
of many hours bug-hunting.
Option 3) may seem optimal but I do not like to add more
complexity to this part of the build. And really I do not
know a reliable way to detech when we do cross builds anyway.

Leaving us with option 2) that is simple, strighforward and harmless.

	Sam
