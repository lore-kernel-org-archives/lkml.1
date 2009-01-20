Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbZATO7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbZATO7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbZATO7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:59:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64569 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbZATO7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:59:05 -0500
Date: Tue, 20 Jan 2009 09:59:01 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Kevin Shanahan <kmshanah@ucwb.org.au>, Avi Kivity <avi@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kevin Shanahan <kmshanah@flexo.wumi.org.au>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
In-Reply-To: <20090120130714.GA11048@elte.hu>
Message-ID: <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera> <1232410363.4768.21.camel@kulgan.wumi.org.au> <20090120113546.GA26571@elte.hu> <1232455343.4895.4.camel@kulgan.wumi.org.au> <20090120125652.GA1457@elte.hu>
 <20090120130714.GA11048@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Jan 2009, Ingo Molnar wrote:
> Another test would be to build the scheduler latency tracer into your 
> kernel:
> 
>     CONFIG_SCHED_TRACER=y
> 
> And enable it via:
> 
>     echo wakeup > /debug/tracing/current_tracer
> 
> and you should be seeing the worst-case scheduling latency traces in 
> /debug/tracing/trace, and the largest observed latency will be in 
> /debug/tracing/tracing_max_latency [in microseconds].

Note, the wakeup latency only tests realtime threads, since other threads
can have other issues for wakeup. I could change the wakeup tracer as
wakeup_rt, and make a new "wakeup" that tests all threads, but it may
be difficult to get something accurate.

-- Steve
