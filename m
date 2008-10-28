Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYJ1UJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYJ1UJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYJ1UJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:09:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17306 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbYJ1UJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:09:31 -0400
Date: Tue, 28 Oct 2008 13:05:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-stable@vger.kernel.org,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Stanislav Brabec <utx@penguin.cz>,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@opfer-online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: Re: [Patch 2.6.27] fix booting on Sharp Zaurus c3000
Message-Id: <20081028130504.fea9708c.randy.dunlap@oracle.com>
In-Reply-To: <20081028182424.GA16452@elf.ucw.cz>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz>
	<20081015101747.GB28824@atrey.karlin.mff.cuni.cz>
	<20081015113923.GA21756@flint.arm.linux.org.uk>
	<200810250001.04835.rjw@sisk.pl>
	<20081026184108.GB1847@ucw.cz>
	<20081027092512.9327b690.randy.dunlap@oracle.com>
	<20081028182424.GA16452@elf.ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 19:24:25 +0100 Pavel Machek wrote:

> Hi!
> 
> > > > > > Thanks for the effort, but it looks like it did not make it, right?
> > > > > 
> > > > > Correct - Linus was unpredictable and released 2.6.27 that evening,
> > > > > four days early giving me no time to push the fix to him.
> > > > > 
> > > > > However, it's gone in as part of the first ARM merge, so should be in
> > > > > -rc1.
> > > > 
> > > > Is it in -stable?  if not, is it considered as -stable material?
> > > 
> > > Yes, I guess it should go to stable.
> > > 
> > > commit 69fc7eed5f56bce15b239e5110de2575a6970df4
> > > Author: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > Date:   Thu Oct 9 16:58:13 2008 +0100
> > > 
> > >     [ARM] 5300/1: fixup spitz reset during boot
> > >     
> > >     Some machines don't have the pullup/down on their reset
> > >     pin, so configuring the reset generating pin as input makes
> > >     them reset immediately. Fix that by making reset pin direction
> > >     configurable.
> > >     
> > > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > > 
> > > diff --git a/arch/arm/mach-pxa/include/mach/reset.h b/arch/arm/mach-pxa/include/mach/reset.h
> > > index 9489a48..7b8842c 100644
> > > --- a/arch/arm/mach-pxa/include/mach/reset.h
> > > +++ b/arch/arm/mach-pxa/include/mach/reset.h
> > > @@ -10,9 +10,12 @@
> > >  extern unsigned int reset_status;
> > >  extern void clear_reset_status(unsigned int mask);
> > >  
> > > -/*
> > > - * register GPIO as reset generator
> > > +/**
> > > + * init_gpio_reset() - register GPIO as reset generator
> > > + *
> > > + * @gpio - gpio nr
> > > + * @output - set gpio as out/low instead of input during normal work
> > 
> > Use colon (':') after function parameters, not hyphen/dash.
> 
> Okay, sorry about that. If I promise to fix that in mainline, will you
> let me apply the -stable patch?

Sure, but it's really up to GregKH and cdub.

> ...I believe this one should go in. Documentation problem is not that
> bad, and it fixes booting. 
> 
> Alternatively, I can submit fixed patch, but it will be in trivial way
> different from what is currently in mainline... which is okay for this
> I guess.
> 
> Greg, will you take the patch as-is, or can you simply replace - with
> : or do you want me to submit new one?
> 									Pavel

---
~Randy
