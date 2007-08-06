Return-Path: <linux-kernel-owner+w=401wt.eu-S1764325AbXHFLHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764325AbXHFLHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXHFLGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:06:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49323 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762778AbXHFLGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:06:48 -0400
Date: Mon, 6 Aug 2007 12:26:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [linux-pm] Re: [Resend][PATCH] PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION (updated)
Message-ID: <20070806102659.GB1875@elf.ucw.cz>
References: <200708051906.22865.rjw@sisk.pl> <20070806090713.GC15329@atrey.karlin.mff.cuni.cz> <1186392591.28655.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186392591.28655.35.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-08-06 11:29:51, Johannes Berg wrote:
> On Mon, 2007-08-06 at 11:07 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > +config SUSPEND_UP_POSSIBLE
> > > +	bool
> > > +	depends on (X86 && !X86_VOYAGER) || (PPC32 && PPC_MPC52xx) \
> > > +		   || (PPC64 && (PPC_PSERIES || PPC_PMAC)) || ARM || BLACKFIN \
> > > +		   || MIPS || SUPERH || FRV
> > > +	depends on !SMP
> > > +	default y
> > 
> > I guess I'd rather left SUSPEND_UP_POSSIBLE to allways y (as it always
> > was), and let architectures that can't handle it  not return "mem"
> > from list of valid states...
> 
> Yeah, that's the utterly broken interface we used to have. Until I fixed
> it to have no valid states until architectures implement suspend_ops.
> Still, I disagree, why bother with compiling code that can't ever be
> used?

Well, so that it does not bitrot? This is few bytes, I'd say, and I
believe we have too many config options already. I do not think
suspend_ops code is big enough to warrant separate config
option... just disable CONFIG_PM or something.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
