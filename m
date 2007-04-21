Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXDUJiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXDUJiO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 05:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbXDUJiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 05:38:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51580 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754531AbXDUJiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 05:38:14 -0400
Date: Sat, 21 Apr 2007 11:37:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, vatsa@in.ibm.com, paulmck@us.ibm.com
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Message-ID: <20070421093723.GA2090@elf.ucw.cz>
References: <20070419120131.GB13435@in.ibm.com> <20070419120419.GB17069@in.ibm.com> <20070419143133.a6c82ef8.akpm@linux-foundation.org> <20070420104647.GA11290@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420104647.GA11290@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Of course, running try_to_freeze() in kthread_stop() would be very wrong,
> > so we'd actually need to do it in callers, preferably via a new
> > kthread_stop_freezeable() wrapper.
> > 
> Well, even then we'll need to ensure that a thread would not call
> kthread_stop_freezeable() with any locks held. That would mean more
> audits :)

I'll take audits over 200 new lines of code ;-). (And it should be
reasonably simple to audit; person doing kthread_stop() ->
ktrhread_stop_freezeable() should look after locks).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
