Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbXCQRcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbXCQRcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 13:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXCQRcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 13:32:18 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3956 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbXCQRcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 13:32:17 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [ck] Re: is RSDL an "unfair" scheduler too?
Date: Sat, 17 Mar 2007 10:31:43 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEFPCFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-reply-to: <200703171323.44517.jos@mijnkamer.nl>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 17 Mar 2007 09:31:59 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 17 Mar 2007 09:32:01 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org]On Behalf Of jos poortvliet
> Sent: Saturday, March 17, 2007 5:24 AM
> To: ck@vds.kolivas.org
> Cc: Con Kolivas; Ingo Molnar; Al Boldi; Mike Galbraith;
> linux-kernel@vger.kernel.org; Nicholas Miell; Linus Torvalds; Andrew
> Morton
> Subject: Re: [ck] Re: is RSDL an "unfair" scheduler too?
>
>
> Op Saturday 17 March 2007, schreef Con Kolivas:
> > On Saturday 17 March 2007 22:49, Ingo Molnar wrote:
> > > * Con Kolivas <kernel@kolivas.org> wrote:
> > > > Despite the claims to the contrary, RSDL does not have _less_
> > > > heuristics, it does not have _any_. It's purely entitlement based.
> > >
> > > RSDL still has heuristics very much, but this time it's hardcoded into
> > > the design! Let me demonstrate this via a simple experiment.
> > >
> > > in the vanilla scheduler, the heuristics are ontop of a fairly basic
> > > (and fast) scheduler, they are plain visible and thus 'optional'. In
> > > RSDL, the heuristics are still present but more hidden and more
> > > engrained into the design.
> > >
> > > But it's easy to demonstrate this under RSDL: consider the
> following two
> > > scenarios, which implement precisely the same fundamental computing
> > > workload (everything running on the same, default nice 0 level):
> > >
> > > 1) a single task runs almost all the time and sleeps about 1
> msec every
> > >    100 msecs.
> > >
> > >    [ run "while N=1; do N=1; done &" under bash to create such a
> > >      workload. ]
> > >
> > > 2) tasks are in a 'ring' where each runs for 100 msec, sleeps for 1
> > >    msec and passes the 'token' around to the next task in the
> ring. (in
> > >    essence every task will sleep 9900 msecs before getting
> another run)
> > >
> > >    [ run http://redhat.com/~mingo/scheduler-patches/ring-test.c to
> > >      create this workload. If the 100 tasks default is too
> much for you
> > >      then you can run "./ring-test 10" - that will show
> similar effects.
> > >    ]

> Well, re-reading his post, he has a point - one WOULD expect each
> of these 2
> tasks to have an equal share of CPU, and if RSDL doesn't
> currently take this
> pipe-thing into account, it might need some fixing. call it
> heuristics or not
> (after all, how could one NOT say a scheduler uses heuristics of
> some kind?).

I can't get myself to expect that no matter how hard I try. The scheduler
is, by design, fair to *tasks*. So why would one expect two different
approaches that do the same thing, but with different numbers of tasks, to
each get the same amount of CPU if they compete with each other? One would
expect the approach that uses the most tasks to get more CPU.

DS


