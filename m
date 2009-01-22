Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZAVBsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZAVBsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 20:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbZAVBsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 20:48:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbZAVBsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 20:48:02 -0500
Date: Wed, 21 Jan 2009 20:48:00 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Avi Kivity <avi@redhat.com>
cc: Kevin Shanahan <kmshanah@ucwb.org.au>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
In-Reply-To: <49773848.4080409@redhat.com>
Message-ID: <alpine.DEB.1.10.0901212044450.1737@gandalf.stny.rr.com>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>  <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>  <1232410363.4768.21.camel@kulgan.wumi.org.au>  <20090120113546.GA26571@elte.hu>  <1232455343.4895.4.camel@kulgan.wumi.org.au>  <20090120125652.GA1457@elte.hu>
 <20090120130714.GA11048@elte.hu>  <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>  <49760E2D.2060109@redhat.com>  <1232547932.4895.119.camel@kulgan.wumi.org.au>  <49773275.3020203@redhat.com> <1232549502.4895.124.camel@kulgan.wumi.org.au>
 <49773848.4080409@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 21 Jan 2009, Avi Kivity wrote:

> Kevin Shanahan wrote:
> > > > --- hermes-old.wumi.org.au ping statistics ---
> > > > 900 packets transmitted, 900 received, 0% packet loss, time 899326ms
> > > > rtt min/avg/max/mdev = 0.093/0.157/3.611/0.117 ms
> > > > 
> > > > So, a _huge_ difference. But what does it mean?
> > > >       
> > > It means, a scheduling problem.  Can you run the latency tracer (which
> > > only works with realtime priority), so we can tell if it is (a) kvm
> > > failing to wake up the vcpu properly or (b) the scheduler delaying the
> > > vcpu from running.
> > >     
> > 
> > Sorry, but are you sure that's going to be useful?
> > 
> > If it only works on realtime threads and I'm not seeing the problem when
> > running kvm with realtime priority, is this going to tell you what you
> > want to know?
> > 
> > Not trying to be difficult, but that just didn't make sense to me.
> >   
> 
> You're right, wasn't thinking properly.
> 
> This is a tough one.  I'll see if I can think of something.  Ingo, any ideas?

I fixed up the wakeup latency tracer to work with all tasks (as well as 
other fixes). You can checkout the following:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

  branch: tip/devel

compile with CONFIG_FUNCTION_TRACER and CONFIG_SCHED_TRACER and just

echo 0 > /debug/tracing/tracing_enabled
echo wakeup > /debug/tracing/current_tracer

echo 1 > /debug/tracing/tracing_enabled
run your test
echo 0 > /debug/tracing/tracing_enabled

and then look at /debug/tracing/latency_trace

-- Steve

