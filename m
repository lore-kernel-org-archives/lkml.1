Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbZB0HXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbZB0HXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZB0HXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:23:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56788 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZB0HXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:23:31 -0500
Subject: Re: [PATCH] new irq tracer
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dominique Toupin <dominique.toupin@ericsson.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net
In-Reply-To: <20090227121053.152B.A69D9226@jp.fujitsu.com>
References: <alpine.DEB.2.00.0902252040210.12697@gandalf.stny.rr.com>
	 <806EF3041844884CAC68E1E16026AB8905CE58DA@ecamlmw720.eamcs.ericsson.se>
	 <20090227121053.152B.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 08:23:14 +0100
Message-Id: <1235719394.4948.1261.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 12:14 +0900, KOSAKI Motohiro wrote:
> > > > Given this scenario :
> > > > 
> > > > A telecommunication system runs, but the client notices 
> > > something wrong.
> > > > They call their service provider. The provider enables tracing 
> > > > _remotely_ on the _production system_ while it's _active in 
> > > the field_.
> > > > 
> > > > Bam, those few milliseconds interrupt latencies become unacceptable.
> > > > 
> > > > Hopefully this scenario makes the use-case clearer. The 
> > > problem is not 
> > > > that interrupt latencies would occur while tracing is on, 
> > > but rather 
> > > > that it would happen on a running production system when switching 
> > > > tracing on. This is what is totally unacceptable for this use-case.
> > > > 
> > > > For more details about such requirements, I'm CCing 
> > > Dominique Toupin 
> > > > from Ericsson who I'm sure would be happy to give more 
> > > details about 
> > > > this if needed.
> > > 
> > > Hmm, so this system in the field is running Linux with the 
> > > Real-Time Patch?  Because if it isn't it will suffer from 
> > > millisecond latencies in normal operation.
> >
> > In many cases we don't use Linux real-time, we have many systems that
> > are soft-real-time an non real-time Linux is good enough.
> >  
> 
> Agreed, rt-patch seems off topics. we discuss to mainline kernel.

Exactly, hence you should not worry about ms irq-off latencies, since
mainline is happy to generate those for you, regardless of
function-trace.

The only way to complain about those is if your base system is better
than that, and currently only preempt-rt provides that.

So unless you're on preempt-rt, complaining about ms-order irq latencies
just isn't a valid argument.

