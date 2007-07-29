Return-Path: <linux-kernel-owner+w=401wt.eu-S935810AbXG2UY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935810AbXG2UY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934689AbXG2UYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:24:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45331 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934610AbXG2UYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:24:46 -0400
Date: Sun, 29 Jul 2007 22:24:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Satyam Sharma <satyam@infradead.org>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, ck@vds.kolivas.org,
       Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Message-ID: <20070729202422.GA21894@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707291256.32769.Martin@lichtvoll.de> <20070729174239.GA20399@uranus.ravnborg.org> <200707292023.36555.Martin@lichtvoll.de> <alpine.LFD.0.999.0707300008230.30928@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707300008230.30928@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Satyam Sharma <satyam@infradead.org> wrote:

> > > So whats wrong then?
> > > 
> > > Ingo decides to do a better scheduler - to some extent inspired by 
> > > Con's work. And after 48 hours he publish first version that 
> > > _anyone_ can see and comment on. Whats wrong with that?
> > >
> > > Did you expect some lengthy discussion before the coding phase 
> > > started or what?
> > >
> > > Just trying to understand what you are arguing about.
> > 
> > If I tried to rewrite a kernel subsystem - should I ever happen to 
> > dig that deep into kernel matters - while I actually know that 
> > someone already spent countless hours on exactly rewriting the exact 
> > same subsystem, I think I would have told that other developer about 
> > it as soon as I started coding on it. And if it just was a
> > 
> > "Hi Con,
> > 
> > I reconsidered the scheduling ideas again you brought to the Linux 
> > kernel world. Instead of using your scheduler tough I like to try to 
> > write a new one with fairness in mind, cause I think this, this and 
> > this can be improved upon.
> > 
> > I would like to hear your ideas about that as soon as possible and 
> > would like you to contribute your ideas and also code, where you see 
> > hit. You can find the git / bazaar / whatever repository where I do 
> > my developments at: someurl.
> > 
> > Regards, Ingo"
> 
> Sending out the code (and early enough, 48 hours /is/ early enough) 
> *is* the normal (and good) way to do exactly the communication you 
> described above, IMHO.

yeah. And note that the time from the "ok, this approach might work" 
point to releasing CFS was even less than the original ~62 hours of CFS 
development.

I dont typically write code because i'm particularly "convinced" about 
an idea or because i "believe in" an idea, i mostly write code to 
_check_ whether an idea is worth advancing or not. Writing code is my 
form of "thinking", and releasing patches is my form of telling others 
about my "thoughts". I might have guesses about how well something will 
work out in practice (and i'd certainly be a fool to go out coding 
blindly), but surprises happen almost always, both in positive and in 
negative direction, and even with relatively simple patches.

CFS started out as an experiment to simplify the scheduler, to clean up 
the after-effects of a better-desktop-scheduling patch Mike Galbraith 
sent me. Had anyone told me at that time that i'd end up writing a new 
scheduler i'd have laughed at the suggestion and i'd have pointed to the 
large number of pending patches of mine in forms of the -rt tree, the 
syslet/threadlet code and other stuff that needs fixing a lot more 
urgent than the task scheduler.

During that cleanup work did i realize how a policy-modularized 
scheduler would allow the bridging of the seemingly unreconcilable 
friction between the O(1) data structures that things like RT scheduling 
needs and the binary tree that "fair share scheduling" concepts dictate. 
(most of the complexity in kernel code like the scheduler derives from 
complexity in data structures, so you start writing code by thinking 
about your data structures.)

And the time from the point where i thought "ok, this fair-share thing 
behaves pretty well and it certainly looks simpler than the current 
code" to the announcement on lkml was more on the order of hours than 
days - much of the 62 hours were spent on ripping out the old code and 
on getting the new design up and running.

There was simply no code in existence before CFS which has proven the 
code simplicity/design virtues of 'fair scheduling' - SD was more of an 
argument _against_ it than for it. I think maybe even Con might have 
been surprised by that simplicity: in his first lkml reaction to CFS he 
also wrote that he finds the CFS code "beautiful":

  http://lkml.org/lkml/2007/4/14/199

and my reply to Con's mail:

  http://lkml.org/lkml/2007/4/15/64

still addresses a good number of points raised in this thread i think.

	Ingo
