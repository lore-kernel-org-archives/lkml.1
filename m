Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbXFZW0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbXFZW0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbXFZW0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:26:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53719 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757372AbXFZW0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:26:06 -0400
Date: Tue, 26 Jun 2007 10:48:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks (rev. 2)
Message-ID: <20070626084854.GA4594@elf.ucw.cz>
References: <200706252352.24137.rjw@sisk.pl> <20070625215527.GE2051@elf.ucw.cz> <200706260027.02396.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706260027.02396.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > [I hope the ACKs still apply.]
> > 
> > Uhuh, not 100% sure.
> > 
> > > +static int usermodehelper_disabled;
> > > +
> > 
> > 
> > ...
> > 
> > >  	case PM_HIBERNATION_PREPARE:
> > >  	case PM_SUSPEND_PREPARE:
> > >  		usermodehelper_disabled = 1;
> > > -		return NOTIFY_OK;
> > > +		smp_mb();
> > 
> > usermodehelper_disabled should be atomic variable, too, so we don't
> > have to play these ugly tricks by hand? This should not be
> > performance-critical, right?
> 
> Well, I think we'd need to add the barriers anyway.
> 
> The problem, as far as I understand it, is that the instructions can get
> reordered if there are no barriers in there.

Are you sure?  I thought atomic variables have barrirers built-in.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
