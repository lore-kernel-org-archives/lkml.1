Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbYJKOsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbYJKOsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbYJKOsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:48:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51638 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755807AbYJKOsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:48:30 -0400
Date: Sat, 11 Oct 2008 15:48:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
Message-ID: <20081011134803.GA1483@ucw.cz>
References: <20081009190405.13A253CB@kernel> <20081009190406.1B257119@kernel> <20081009194350.GA31214@us.ibm.com> <1223585671.11830.40.camel@nimitz> <20081010084614.GA319@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010084614.GA319@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Hmm, I don't know too much about aio, but is it possible to succeed with
> > > io_getevents if we didn't first do a submit?  It looks like the contexts
> > > are looked up out of current->mm, so I don't think we need this call
> > > here.
> > > 
> > > Otherwise, this is neat.
> > 
> > Good question.  I know nothing, either. :)
> > 
> > My thought was that any process *trying* to do aio stuff of any kind 
> > is going to be really confused if it gets checkpointed.  Or, it might 
> > try to submit an aio right after it checks the list of them.  I 
> > thought it best to be cautious and say, if you screw with aio, no 
> > checkpointing for you!
> 
> as long as there's total transparency and the transition from CR-capable 
> to CR-disabled state is absolutely safe and race-free, that should be 
> fine.
> 
> I expect users to quickly cause enough pressure to reduce the NOCR areas 
> of the kernel significantly ;-)
> 
> In the long run, could we expect a (experimental) version of hibernation 
> that would just use this checkpointing facility to hibernate? That would 
> be way cool for users and for testing: we could do transparent kernel 
> upgrades/downgrades via this form of hibernation, between CR-compatible 
> kernels (!).

Well, if we could do that, I guess we could also use CR to 'hibernate'
your desktop then continue on your notebook. And yes that sounds cool.

> Pie in the sky for sure, but way cool: it could propel Linux kernel 
> testing to completely new areas - new kernels could be tried 
> non-intrusively. (as long as a new kernel does not corrupt the CR data 
> structures - so some good consistency and redundancy checking would be 
> nice in the format!)

Well, for simple apps, it should not be that hard...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
