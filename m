Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbZBXNCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbZBXNCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbZBXNBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:01:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59775 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbZBXNBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:01:50 -0500
Date: Tue, 24 Feb 2009 08:01:13 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090224130113.GA6749@redhat.com>
References: <20090220172241.GF24538@elte.hu> <1235302980.4632.8.camel@laptop> <y0mocwuptbc.fsf@ton.toronto.redhat.com> <1235304876.4632.10.camel@laptop> <20090222122424.GA9951@redhat.com> <1235387487.4645.28.camel@laptop> <20090223154404.GA30147@redhat.com> <1235406159.4645.366.camel@laptop> <20090223171032.GA2566@redhat.com> <20090223172302.GB29344@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223172302.GB29344@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> > The impression that this is somehow different with tracepoints 
> > is mistaken.  Tracepoints are *exactly* as "ABI-like" as 
> > markers.
> 
> they arent. To the kernel they look like function calls, with no 
> ABI properties at all. They can and will change without notice.

Markers also "look like" function calls because they are - the
callbacks just happen to take a format string and varargs.  What did
you think they were?


srostedt argues that separating the tracepoint from its rendering is
necessary to free the instrumentation site from backward-compatibility
stagnation.  

But consider - it has been manifold stated that tracepoints are not
welcome in the tree without a "tracer" (hand-written glue), so the
same person ends up writing both.  Since they are tightly coupled.  a
change on one will affect the other.  A moved tracepoint will produce
events at different times; a lost tracepoint parameter will lose data
at trace rendering time.  The tracing engine can only pretend to
produce the same data by guessing.

Similarly, if a marker site were to change, and if someone deemed the
old trace data important to preserve, a hand-written marker callback
function could replace a generic one, The new one could make the same
heuristic adaptation.

Try working out some examples.  You'll probably see how similar they
really turn out, with respect to the hypothetical "preserve ABI" idea.

- FChE
