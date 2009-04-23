Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZDWI3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZDWI3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZDWI3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:29:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbZDWI33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:29:29 -0400
Date: Thu, 23 Apr 2009 10:28:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
Message-ID: <20090423082810.GE599@elte.hu>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <20090422114750.GA14202@nowhere> <alpine.DEB.2.00.0904220943280.24310@gandalf.stny.rr.com> <20090422171047.GA5975@nowhere> <49EF5138.3030408@goop.org> <alpine.DEB.2.00.0904221321410.24310@gandalf.stny.rr.com> <alpine.DEB.2.00.0904221731240.24310@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904221731240.24310@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 22 Apr 2009, Steven Rostedt wrote:
> 
> > 
> > On Wed, 22 Apr 2009, Jeremy Fitzhardinge wrote:
> > 
> > > > 
> > > >    
> > > > > Do you have CONFIG_PARAVIRT on?  When I disabled it, I have yet to
> > > > > reproduce the bug. But I've only rebooted a few times. I'm going to
> > > > > continue to reboot to see if I can trigger it.
> > > > >     
> > > > 
> > > > 
> > > > Yes it is enabled.
> > > > 
> > > > 
> > > > 
> > > >   
> > > > > I'm thinking that the paravirt alternative code may have clobbered a
> > > > > register in either the enable or disabling of interrupts. This might cause
> > > > > a strange value to go into the hardirqs_enabled flag.
> > > > >     
> > > > 
> > > > 
> > > > 
> > > > Ok I will try it without PARAVIRT and tell you if I can reproduce it.
> > > >   
> > > 
> > > Interesting.  What code is generated for native_irq_enable/disable?
> > 
> > Note, when I take my standard config and enable PARAVIRT and LOCKDEP it 
> > still boots up fine. It may be a combination of some configs :-/
> > 
> > I'm currently doing a "config bisect" to find out what configs are needed.
> 
> I just finished the config bisect, and it came down to 
> CONFIG_DEBUG_PAGEALLOC (set is bad, not set is good). I'm sure 
> this is not the only config that is at issue. It is probably a 
> combination of configs
> :-/
> 
> I'll try others to see if things change.

It could also be the timing of an incoming IRQ to hit a particular 
race window. PAGEALLOC might trigger the right kind of delays to 
make it trigger.

	Ingo
