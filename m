Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbXFXRGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbXFXRGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 13:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXFXRGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 13:06:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43539 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751739AbXFXRGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 13:06:24 -0400
Date: Sun, 24 Jun 2007 19:05:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RC][PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks
Message-ID: <20070624170514.GA21757@elf.ucw.cz>
References: <200706221647.50509.rjw@sisk.pl> <20070622210750.GA4267@ucw.cz> <200706222347.55717.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706222347.55717.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Special thanks to Uli Luckas <u.luckas@road.de> for reviewing the previous
> > > versions of this patch and for very useful comments.
> > ...
> > > Reviewed-by: Pavel Machek <pavel@ucw.cz>
> > 
> > Eh, not sure this header is worth anything. Sometimes I'm lazy and
> > stop when I see first problem.
> > 
> > >  	switch (action) {
> > >  	case PM_HIBERNATION_PREPARE:
> > >  	case PM_SUSPEND_PREPARE:
> > >  		usermodehelper_disabled = 1;
> > > -		return NOTIFY_OK;
> > > +		retval = wait_event_timeout(running_helpers_waitq,
> > > +					atomic_read(&running_helpers) == 0,
> > 
> > Are you sure here? What happens when atomic variable changes between
> > the atomic_read and the function call?
> 
> Er, this is a macro. :-)
> 
> In fact we rely only on atomic_read(&running_helpers) being still zero after
> helper_finished() has woken us up, but I think that's acceptable.
> 
> IOW, if the wait_event_timeout() returns with retval different from zero, this
> means that atomic_read(&running_helpers) returned zero at one point after
> we'd set usermodehelper_disabled, which is enough.  OTOH, if it doesn't

Ok, can you write short comment explaining that? /* We have set
usermodehelper_disabled, so any new usermode helpers are not a problem
*/.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
