Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbXF2Wf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbXF2Wf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 18:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXF2WfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 18:35:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47372 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753143AbXF2WfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 18:35:12 -0400
Date: Sat, 30 Jun 2007 00:35:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Rafael Wysocki <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Message-ID: <20070629223505.GB6732@elf.ucw.cz>
References: <200706192118.23706.nigel@nigel.suspend2.net> <20070628142532.GC5339@ucw.cz> <200706290827.13024.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706290827.13024.nigel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >  ALIGN
> > >  	.align	4096
> > > @@ -31,6 +46,11 @@ wakeup_code:
> > >  	movw	%cs, %ax
> > >  	movw	%ax, %ds					# Make ds:0 point to wakeup_start
> > >  	movw	%ax, %ss
> > > +
> > > +	testl   $1, beep_flags - wakeup_code
> > > +	jz      1f
> > > +	BEEP
> > > +1:
> > 
> > Can we rename/reuse existing flag variable?
> 
> Sorry, but I can't resist the opportunity to say "Send a patch!" :)
> 
> Seriously, though, I'd prefer not to. If we rename that acpi video flags 
> variable (I assume this is what you're thinking of), we only create cause for 
> confusion. A variable should for debugging or for controlling quirks, not for 
> both at the same time.

Cause for confusion? We are currently using 2 bits of that variable,
and we want to add one more bit. I seriously doubt that can confuse
anyone.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
