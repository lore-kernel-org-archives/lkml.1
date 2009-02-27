Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbZB0DgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbZB0DgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZB0DgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:36:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53416 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbZB0DgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:36:05 -0500
Date: Thu, 26 Feb 2009 22:36:01 -0500 (EST)
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
Message-ID: <alpine.DEB.2.00.0902262230130.19122@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0902252040210.12697@gandalf.stny.rr.com> <806EF3041844884CAC68E1E16026AB8905CE58DA@ecamlmw720.eamcs.ericsson.se> <20090227121053.152B.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Feb 2009, KOSAKI Motohiro wrote:
> >
> > In many cases we don't use Linux real-time, we have many systems that
> > are soft-real-time an non real-time Linux is good enough.
> >  
> 
> Agreed, rt-patch seems off topics. we discuss to mainline kernel.

The reason I brought up the rt-patch is that Mathieu is concerned about 
the small latency that happens when we run stop_machine to switch the nops 
to pointers to trace functions. This latency can be a couple of millisecs, 
but I can easily make a normal kernel suffer a couple of millisec latency 
by simply running hackbench (as a normal user).

The point being, I think Mathieu's point about the latency of enabling the 
function tracer is frivolous. It is a one time shot that happens when the 
sysadmin purposely enables the function tracing.  If this is unacceptable, 
then the system had better be running the rt patch because it will be 
hitting this unacceptable latency in normal operation.

-- Steve

