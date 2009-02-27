Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbZB0DaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbZB0DaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZB0DaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:30:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZB0DaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:30:01 -0500
Date: Thu, 26 Feb 2009 22:29:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Dominique Toupin <dominique.toupin@ericsson.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net
Subject: Re: [PATCH] new irq tracer
In-Reply-To: <20090227121053.152B.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0902262223550.19122@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0902252040210.12697@gandalf.stny.rr.com> <806EF3041844884CAC68E1E16026AB8905CE58DA@ecamlmw720.eamcs.ericsson.se> <20090227121053.152B.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Feb 2009, KOSAKI Motohiro wrote:
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
> 
> Steven, I sitll think nobody use ftrace on production system now yet.
> Do you know actual production user?

First lets separate out "ftrace" and the function tracer. ftrace is the 
infrastructure that has schedule tracing, event tracing and lots and lots 
of other kinds of tracing.

The "stop_machine" talked about in this thread is specific for 
dynamic_ftrace (which is used for the function and graph tracers).

Your question about "production user" is a little unfair, since function 
tracing did not appear till 2.6.28. (I'm ignoring 2.6.27, since the
version of the function tracer there had a notorious bug).

No distribution is shipping a production 2.6.28 AFIAK. Which means, I do 
not know of any production use of the function tracer. I have already 
recommended that people enable the function tracer if they are using 
2.6.28 in a production environment. Given some time, when 2.6.28 is more 
in use, my answer would probably be "Yes, I do know it is used in a 
production environment".

-- Steve

