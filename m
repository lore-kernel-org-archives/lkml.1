Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYLHNr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYLHNr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYLHNrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:47:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53679 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYLHNrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:47:48 -0500
Date: Mon, 8 Dec 2008 14:47:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-graph-tracer: signal interrupts
	entry/exit points on outpout
Message-ID: <20081208134736.GD29965@elte.hu>
References: <493C7058.4060709@gmail.com> <1228717172.23742.1.camel@twins> <c62985530812080538p3802f329vf6e12695d734f16d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812080538p3802f329vf6e12695d734f16d@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/12/8 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Mon, 2008-12-08 at 01:54 +0100, Frederic Weisbecker wrote:
> >> Impact: provide interrupt detection on output
> >>
> >> Suggested by Ingo.
> >> If a hardirq is raised, we want it to be signaled on output, so this patch
> >> adds two arrows on the output to find entry and exit points of a hardirq.
> >>
> >> Unfortunately, there are many interrupt entrypoints and these can be differents
> >> from one arch to another.
> >>
> >> The approach here is one of the easiest, but doesn't shine by its scalability:
> >> we have an array of the interrupt entrypoints names that we compare with the
> >> symbol of the current traced function, if it matches, we draw the arrow.
> >>
> >> Ie:
> >>
> >>  1)               |                                unlock_buffer() {
> >>  1)               |                                  wake_up_bit() {
> >>  1)               |                                    bit_waitqueue() {
> >>  1)   0.872 us    |                                      __phys_addr();
> >>  1)   2.722 us    |                                    }
> >>  1)               |                                    __wake_up_bit() {
> >>  1)              ==>                                   __wake_up_bit() {
> >>  1)               |                                      do_IRQ() {
> >
> > Would be much nicer, the current proposal is lost when grepping and adds
> > a weird visual break in the output.
> 
> 
> Ok, I will apply it like this in the V2.
> Thanks!

note that since the IRQ marker always comes on an entry record, there's 
space in the usecs field for something like:

  1)   2.722 us    |                                    }
  1)               |                                    __wake_up_bit() {
  1)  [IRQ#123]   ==>                                   __wake_up_bit() {

right?

	Ingo
