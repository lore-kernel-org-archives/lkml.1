Return-Path: <linux-kernel-owner+w=401wt.eu-S1762597AbYCCXQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762597AbYCCXQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYCCXQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:16:16 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59685 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYCCXQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:16:15 -0500
Date: Tue, 4 Mar 2008 00:16:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: linux-pm@lists.linux-foundation.org,
       Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH RFC] introduce pm_call() macro to get rid of
	most #ifdef CONFIG_PM
Message-ID: <20080303231643.GL13869@elf.ucw.cz>
References: <20080302234308.GA10116@zarina> <20080303141818.GE12606@elf.ucw.cz> <200803031456.38406.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803031456.38406.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > > +/* avoid `defined but not used' warning */
> > > +#define pm_call(x) ((x) - 1 ? NULL : NULL)
> > > +#endif /* CONFIG_PM */
> > > +
> > 
> > This is evil.
> 
> Ugly, yes.  It might merit some casts too.
> 
> 
> > Maybe your gcc is smart enough to optimize this away, 
> > but I'm not sure mine is.
> 
> It'll be a constant expression; it certainly ought to be.

Well, we have just fooler compiler to think that x is used, and now we
want it to realize that x is unused and compile it out?

Maybe it is smart enough, but...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
