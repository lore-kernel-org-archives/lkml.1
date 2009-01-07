Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbZAGVvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbZAGVvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZAGVus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:50:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbZAGVuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:50:46 -0500
Date: Wed, 7 Jan 2009 22:50:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Roland McGrath <roland@redhat.com>, Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090107215033.GC16555@elte.hu>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <20090107205816.GC4597@elte.hu> <alpine.DEB.1.10.0901071259210.17115@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901071259210.17115@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> On Wed, 7 Jan 2009, Ingo Molnar wrote:
> 
> > 
> > * Roland McGrath <roland@redhat.com> wrote:
> > 
> > > New syscall should have gone to linux-api, I think.
> > > 
> > > Do we really need another one for this?  How about using signalfd plus 
> > > setting the child's exit_signal to a queuing (SIGRTMIN+n) signal instead 
> > > of SIGCHLD?  It's slightly more magical for the userland process to know 
> > > to do that (fork -> clone SIGRTMIN).  But compared to adding a syscall 
> > > we don't really have to add, maybe better.
> > 
> > hm, i think it's cleaner conceptually than trying to wrap this into 
> > signalfd. Since we already have:
> > 
> >   #define __NR_signalfd           321
> >   #define __NR_timerfd_create     322
> >   #define __NR_timerfd_settime    325
> >   #define __NR_timerfd_gettime    326
> >   #define __NR_signalfd4          327
> > 
> > is one more really such an issue?
> 
> And what did eventfd do to you? :)

:)

> I partially agree with Roland (and I stated this during Casey's first 
> post), this can be achieved in a not too troublesome way already. A new 
> dedicated interface is easier for the challenged userspace coder, but I 
> dunno if it's worth the new code (although it does have little 
> footprint). Both ways are fine from my POV.

i think we should be defensive and generous and do a clean separate 
syscall for this - we have a pretty bad track record in syscall interface 
cleanliness, today's borderline hack is tomorrow's limitation causing 
headaches. We never know what that extra flexibility that will buy us in 
the future.

	Ingo
