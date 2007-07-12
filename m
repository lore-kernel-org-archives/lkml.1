Return-Path: <linux-kernel-owner+w=401wt.eu-S934146AbXGLTtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146AbXGLTtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbXGLTtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:49:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2508 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756361AbXGLTtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:49:15 -0400
Date: Thu, 12 Jul 2007 15:13:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Paul Mackerras <paulus@samba.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>,
       Miklos Szeredi <miklos@szeredi.hu>, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070712151308.GA5139@ucw.cz>
References: <20070703211227.GA28758@srcf.ucam.org> <E1I666o-0006wu-00@dorka.pomaz.szeredi.hu> <200707041703.21808.oliver@neukum.org> <200707041717.05149.rjw@sisk.pl> <18060.15209.274437.471074@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18060.15209.274437.471074@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > They will not trigger 100% of the time, but sporadically and generally at
> > random.
> > 
> > At least the freezer problems are reproducible. ;-)
> 
> Our experience with powermacs has been that it isn't actually all that
> hard to get it right for the drivers you care about.

So... will you fix input and usb? Their maintainers seem to prefer
simplicity of frozen system.

Also, can you write down rules for drivers to follow?

Like... 'if you get a request after system suspend started, you may
not kmalloc(GFP_KERNEL)'

 - because disk driver may be already suspended

- hmm, what happens if disk driver _is_ suspended? Let's say I'm v4l
driver on cpu1. Someone may talk to me _while_ disk driver is being
suspended... and if I'm after disk driver in pci order, I may only
learn about suspend _after_ I do the wrong kmalloc.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
