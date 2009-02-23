Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZBWRbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZBWRbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZBWRbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:31:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43195 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbZBWRbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:31:34 -0500
Date: Mon, 23 Feb 2009 12:31:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
In-Reply-To: <20090223171032.GA2566@redhat.com>
Message-ID: <alpine.DEB.2.00.0902231228420.18221@gandalf.stny.rr.com>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <1235302980.4632.8.camel@laptop> <y0mocwuptbc.fsf@ton.toronto.redhat.com> <1235304876.4632.10.camel@laptop> <20090222122424.GA9951@redhat.com>
 <1235387487.4645.28.camel@laptop> <20090223154404.GA30147@redhat.com> <1235406159.4645.366.camel@laptop> <20090223171032.GA2566@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 Feb 2009, Frank Ch. Eigler wrote:
> 
> > Furthermore, trace_mark() exposes that crap like an ABI, now suppose
> > some distro goes and declares that stable for some daft reason,
> > imagine the poor sod having to fix something littered with
> > trace_mark().
> 
> The impression that this is somehow different with tracepoints is
> mistaken.  Tracepoints are *exactly* as "ABI-like" as markers.
> 

I disagree with this point. markers are text strings that will eventually 
appear to userspace. trace points need translation. A trace point can be 
modified at any time and should never mess up user apps.

You may have a hook to a trace point that provides user apps a text based 
output. If the trace point changes, this hook may break. But the tracer 
maintainer of that hook will be responsible for that change, not the 
maintainer of the code the tracepoint existed in.

-- Steve

