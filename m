Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbXK0OIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbXK0OIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 09:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbXK0OIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 09:08:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36354 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbXK0OIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 09:08:05 -0500
Date: Tue, 27 Nov 2007 15:08:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Schwab <schwab@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] timer_list should use signed numbers for relative times
Message-ID: <20071127140843.GA14570@elf.ucw.cz>
References: <20071127124405.GA3943@elf.ucw.cz> <jeaboz4zfj.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jeaboz4zfj.fsf@sykes.suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > Relative times are signed by nature, and timers can (briefly) have
> > expires in past. Print them as negative numbers.
> >
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> >
> > diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
> > index 12c5f4c..7f6eaa9 100644
> > --- a/kernel/time/timer_list.c
> > +++ b/kernel/time/timer_list.c
> > @@ -65,7 +65,7 @@ #ifdef CONFIG_TIMER_STATS
> >  	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
> >  #endif
> >  	SEQ_printf(m, "\n");
> > -	SEQ_printf(m, " # expires at %Lu nsecs [in %Lu nsecs]\n",
> > +	SEQ_printf(m, " # expires at %Lu nsecs [in %Ld nsecs]\n",
> >  		(unsigned long long)ktime_to_ns(timer->expires),
> >  		(unsigned long long)(ktime_to_ns(timer->expires) - now));
> 
> Perhaps change the cast as well.

Well, that seems to be absolute time, so %Lu makes some sense...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
