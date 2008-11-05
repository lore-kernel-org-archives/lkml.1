Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYKERJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYKERJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYKERIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:08:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43432 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbYKERIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:08:52 -0500
Date: Wed, 5 Nov 2008 18:08:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: bug: ftrace & lockdep badness
Message-ID: <20081105170836.GA8317@elte.hu>
References: <20081105123714.GA23504@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811051054430.11900@gandalf.stny.rr.com> <20081105163052.GA28884@elte.hu> <alpine.DEB.1.10.0811051143420.11900@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811051143420.11900@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 5 Nov 2008, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > This is the type of problems we deal with when we have the tracer 
> > > tracing lockdep code at the same time the lockdep code is checking 
> > > the tracer.
> > 
> > ok ... you are right, i guess we need to go back to raw locks after 
> > all?
> 
> I do like the fact that lockdep checks it too. But there's times 
> that we can not do that.
> 
> Perhaps we can do something in between.
> 
> Make a rb_spin_lock macro inside ring_buffer.c that can be either a 
> spin_lock or a raw_spin_lock.  There are some tracers that must have 
> this as a raw (function trace, irqsoff and preemptoff), but the rest 
> should be fine. We can make it where the rb_spin_lock is a raw lock 
> when any of those three tracers are configured, and make it into a 
> normal lock when they are not.
> 
> This way we can still test the integrity of the ring_buffer for 
> other tracers. We just need to be careful when we are using function 
> tracing or irqs/preempt off tracing. But we need to be careful with 
> those anyway.

i'd rather we not complicate this anymore and just go for raw locks 
unconditionally - or no raw locks unconditionally.

	Ingo
