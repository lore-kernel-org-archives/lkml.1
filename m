Return-Path: <linux-kernel-owner+w=401wt.eu-S1751584AbZJTJUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbZJTJUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 05:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZJTJUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 05:20:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:57006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZJTJUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 05:20:06 -0400
Subject: Re: pref record question
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Mike Galbraith <efault@gmx.de>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20091020060043.GB8550@elte.hu>
References: <4ADC9C2A.5020707@klingt.org> <1256012810.17774.17.camel@laptop>
	 <20091020060043.GB8550@elte.hu>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 11:19:50 +0200
Message-Id: <1256030390.17774.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 08:00 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2009-10-19 at 19:04 +0200, Tim Blechmann wrote:
> >
> > > i am trying to do some profiling with perf (2.6.31.4). while 
> > > thread-level profiling works fine, i haven't been able to record 
> > > profiling data of a whole process (i.e. main thread + child 
> > > threads). from my understanding, this should be enabled by running 
> > > 'perf record -i' on the main thread. this does only collect the data 
> > > from the main thread, though.
> > > 
> > > is this an issue with perf or with my understanding of perf?
> > 
> > -i will only inherit the counters on new fork()/clone() calls, so an 
> > existing process/task tree will not automagically get the counters.
> 
> Looks like something very much worth fixing.

Well, maybe.

There's two ways to go about this, either iterate the tasks in userspace
and attach a counter to each one (repeat until there's no new ones
left).

Or add a new flag in perf_event_attr to iterate the tasks on attach in
an atomic manner.

We cannot simply extend the current attach behaviour as that would make
it impossible to attach to a single thread in a thread group.

Also, if you extend the interface, it would make sense to allow
automatically attaching to a process group, not only a thread group,
etc.



