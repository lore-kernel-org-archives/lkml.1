Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYDYKjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYDYKjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYDYKjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:39:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60819 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYDYKjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:39:04 -0400
Date: Fri, 25 Apr 2008 12:39:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paul Walmsley <paul@pwsan.com>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, tony@atomide.com,
       David Brownell <david-b@pacbell.net>, hiroshi.DOYU@nokia.com
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Message-ID: <20080425103942.GC14903@elf.ucw.cz>
References: <20080420082925.GA32739@doriath.ww600.siemens.net> <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com> <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com> <alpine.DEB.1.00.0804250221040.14755@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0804250221040.14755@utopia.booyaka.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >   If the latter, your patchset will presumably
> > >   need a higher standard of review, since once it is integrated, any
> > >   changes will affect several architectures, rather than simply one.
> > [...]
> > I've reviewed the code for most linux/clk.h implementations in the
> > kernel. The OMAP code was... a bit scary for me. I don't have any deep
> > knowledge of this platform, and there were lots of structures, lots of
> > structs embedding struct clk, etc.
> > Tell me please, what do you need, that can't be done with this framework?
> 
> I wouldn't pretend to have a comprehensive list at this point.  But from a 
> brief look, your clk_round_rate() and clk_set_rate() implementations will 
> not work for the present OMAP clock tree.  In OMAP, many parent clocks do 
> not have the same rate as their children.
> 
> But that is not really the main issue.  Ultimately, as long as your 
> implementation remains completely optional, and any public interfaces 
> (like debugfs/sysfs interfaces) are coordinated with other clock interface 
> implementors, I personally have no issues with your code going into the 
> tree somewhere.  With the possible exception of the clk_functions code, 
> clocklib looks pretty clean to me, and a good exemplar of a clock 
> interface implementation.
> 
> However: if the ultimate goal is to make your implementation normative, 
> then I concur with Russell, and I would recommend against merging.  
> Assumptions that you make in clocklib may not work well for future chips.  
> Changing clocklib will affect many architectures.  For example, perhaps 
> someone may wish to implement clocks as an actual in-memory tree rather 
> than a list.  Or perhaps someone may need to handle clock usecounting 
> differently, for situations when multiple clocks might share the same 
> enable/disable code, but with different parents.

WTF? There are currently around 10 copies of clock code in the tree,
every one slightly different. If this can help us get rid of all that
crap, that's a GOOD THING, normative or not.

> I am concerned that having any implementation as an implicit standard in 
> the tree would increase the risk that, over time, internal implementation 
> assumptions will be considered normative.  This could easily cause more 
> pain in the future for maintainers than it would be worth. 

_Of course_  new implementations should try to use existing
framework. And _of course_, if you have some special requirements, you
are still free to create your own version...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
