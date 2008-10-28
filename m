Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYJ1GpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYJ1GpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 02:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYJ1Go5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 02:44:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYJ1Go4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 02:44:56 -0400
Date: Mon, 27 Oct 2008 23:42:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-stable@vger.kernel.org, Russell King <rmk+lkml@arm.linux.org.uk>,
       Stanislav Brabec <utx@penguin.cz>,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@opfer-online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: Re: [Patch 2.6.27] fix booting on Sharp Zaurus c3000
Message-Id: <20081027234246.ea5e3b8e.akpm@linux-foundation.org>
In-Reply-To: <20081027092512.9327b690.randy.dunlap@oracle.com>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz>
	<20081015101747.GB28824@atrey.karlin.mff.cuni.cz>
	<20081015113923.GA21756@flint.arm.linux.org.uk>
	<200810250001.04835.rjw@sisk.pl>
	<20081026184108.GB1847@ucw.cz>
	<20081027092512.9327b690.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 09:25:12 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Sun, 26 Oct 2008 19:41:09 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > Hi!
> > 
> > > > > Thanks for the effort, but it looks like it did not make it, right?
> > > > 
> > > > Correct - Linus was unpredictable and released 2.6.27 that evening,
> > > > four days early giving me no time to push the fix to him.
> > > > 
> > > > However, it's gone in as part of the first ARM merge, so should be in
> > > > -rc1.
> > > 
> > > Is it in -stable?  if not, is it considered as -stable material?
> > 
> > Yes, I guess it should go to stable.
> > 
> > commit 69fc7eed5f56bce15b239e5110de2575a6970df4
> > Author: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > Date:   Thu Oct 9 16:58:13 2008 +0100
> > 
> >     [ARM] 5300/1: fixup spitz reset during boot
> >     
> >     Some machines don't have the pullup/down on their reset
> >     pin, so configuring the reset generating pin as input makes
> >     them reset immediately. Fix that by making reset pin direction
> >     configurable.
> >     
> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > diff --git a/arch/arm/mach-pxa/include/mach/reset.h b/arch/arm/mach-pxa/include/mach/reset.h
> > index 9489a48..7b8842c 100644
> > --- a/arch/arm/mach-pxa/include/mach/reset.h
> > +++ b/arch/arm/mach-pxa/include/mach/reset.h

Somebody applied this.

> > @@ -10,9 +10,12 @@
> >  extern unsigned int reset_status;
> >  extern void clear_reset_status(unsigned int mask);
> >  
> > -/*
> > - * register GPIO as reset generator
> > +/**
> > + * init_gpio_reset() - register GPIO as reset generator
> > + *
> > + * @gpio - gpio nr
> > + * @output - set gpio as out/low instead of input during normal work
> 
> Use colon (':') after function parameters, not hyphen/dash.

Without doing that.

