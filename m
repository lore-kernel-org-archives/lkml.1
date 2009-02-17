Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZBQJrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZBQJrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZBQJrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:47:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45208 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZBQJrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:47:14 -0500
Date: Tue, 17 Feb 2009 10:46:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Damien Wyart <damien.wyart@free.fr>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090217094657.GA1845@elte.hu>
References: <20090216095059.GL6182@elte.hu> <87hc2u61e9.fsf@free.fr> <20090216122632.GA3158@elte.hu> <87ljs6pmao.fsf@free.fr> <20090216132151.GA17996@elte.hu> <20090216160613.GA6785@linux.vnet.ibm.com> <20090216185616.GB6785@linux.vnet.ibm.com> <20090216200923.GA28938@elte.hu> <20090216223944.GF6785@linux.vnet.ibm.com> <20090216225108.GA15904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216225108.GA15904@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Mon, Feb 16, 2009 at 02:39:44PM -0800, Paul E. McKenney wrote:
> > On Mon, Feb 16, 2009 at 09:09:23PM +0100, Ingo Molnar wrote:
> > > 
> > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > Here the calls to rcu_process_callbacks() are only 75 
> > > > microseconds apart, so that this function is consuming more 
> > > > than 10% of a CPU.  The strange thing is that I don't see a 
> > > > raise_softirq() in between, though perhaps it gets inlined or 
> > > > something that makes it invisible to ftrace.
> > > 
> > > look at the latest trace please, that has even the most inline 
> > > raise-softirq method instrumented, so all the raising is 
> > > visible.
> > 
> > Ah, my apologies!  This time looking at:
> > 
> > http://damien.wyart.free.fr/ksoftirqd_pb/trace_tip_2009.02.16_ksoftirqd_pb_abstime_proc.txt.gz
> > 
> > 
> >   799.521187 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.521371 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.521555 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.521738 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.521934 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.522068 |   1)  ksoftir-2324  |               |                rcu_check_callbacks() {
> >   799.522208 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.522392 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.522575 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.522759 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.522956 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.523074 |   1)  ksoftir-2324  |               |                  rcu_check_callbacks() {
> >   799.523214 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.523397 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.523579 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.523762 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.523960 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.524079 |   1)  ksoftir-2324  |               |                  rcu_check_callbacks() {
> >   799.524220 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.524403 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.524587 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> >   799.524770 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > [ . . . ]
> > 
> > Yikes!!!
> > 
> > Why is rcu_check_callbacks() being invoked so often?  It should be called
> > but once per jiffy, and here it is called no less than 22 times in about
> > 3.5 milliseconds, meaning one call every 160 microseconds or so.
> 
> BTW, the other question I have is "why do we need to call 
> rcu_pending() and rcu_check_callbacks() from the idle loop of 
> 32-bit x86, especially given that no other architecture does 
> this?".  Don't get me wrong, it would be good to get rcutree's 
> rcu_pending() to avoid spuriously saying that 
> rcu_check_callbacks() should be invoked, so I would still like 
> the trace with my patch, but...

There's no strong reason - we've been back and forth about RCU 
in the dynticks code. Mind sending a test patch for Damien to 
try?

	Ingo
