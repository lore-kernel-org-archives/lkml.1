Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZBZBlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZBZBlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 20:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZBZBli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 20:41:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49002 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZBZBlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 20:41:37 -0500
Date: Wed, 25 Feb 2009 20:41:33 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       Dominique Toupin <dominique.toupin@ericsson.com>
Subject: Re: [PATCH] new irq tracer
In-Reply-To: <20090225231325.GB21928@Krystal>
Message-ID: <alpine.DEB.2.00.0902252040210.12697@gandalf.stny.rr.com>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com> <20090225165747.GC3123@redhat.com> <20090225173412.GA14269@Krystal> <alpine.DEB.2.00.0902251250110.12697@gandalf.stny.rr.com>
 <20090225221210.GA20133@Krystal> <20090225222001.GC5838@nowhere> <20090225231325.GB21928@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Feb 2009, Mathieu Desnoyers wrote:
> > > > 
> > > > Then use the function_graph tracer.
> > > > 
> > > 
> > > Sadly, the function tracer cannot be enabled on production systems.
> > > Therefore it's not a usable solution in the context where I need this.
> > > 
> > > Mathieu
> > 
> > 
> > Why?
> > If this is about the interrupt latency caused by stop_machine, I still don't understand.
> > This latency happens before the tracing (function filter which use patching), not during
> > tracing.
> > 
> 
> Given this scenario :
> 
> A telecommunication system runs, but the client notices something wrong.
> They call their service provider. The provider enables tracing
> _remotely_ on the _production system_ while it's _active in the field_.
> 
> Bam, those few milliseconds interrupt latencies become unacceptable.
> 
> Hopefully this scenario makes the use-case clearer. The problem is not
> that interrupt latencies would occur while tracing is on, but rather
> that it would happen on a running production system when switching
> tracing on. This is what is totally unacceptable for this use-case.
> 
> For more details about such requirements, I'm CCing Dominique Toupin
> from Ericsson who I'm sure would be happy to give more details about
> this if needed.

Hmm, so this system in the field is running Linux with the Real-Time 
Patch?  Because if it isn't it will suffer from millisecond latencies in 
normal operation.

-- Steve

