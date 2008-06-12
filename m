Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYFLWLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYFLWLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYFLWK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:10:58 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:46821 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524AbYFLWK5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:10:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0FADQ2UUhMQW1O/2dsb2JhbACBW61S
Date: Thu, 12 Jun 2008 18:10:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
Message-ID: <20080612221055.GA8142@Krystal>
References: <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins> <20080612155332.GA16658@redhat.com> <48514BE3.3000506@redhat.com> <20080612164318.GB17814@redhat.com> <1213289778.31518.132.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1213289778.31518.132.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:08:24 up 8 days,  2:49,  3 users,  load average: 1.35, 0.83,
	0.68
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2008-06-12 at 12:43 -0400, Frank Ch. Eigler wrote:
> 
> > This is another reason why markers are a nice solution.  They allow
> > passing of actual useful values: not just the %p pointers but the most
> > interesting derived values (e.g., prev->pid). 
> 
> Useful to whoem? stap isn't the holy grail of tracing and certainly not
> the only consumer of trace points, so restricting the information to
> just what stap needs is actually making trace points less useful.
> 

LTTng also currently relies on the markers identifying useful data and
ideally won't contain any tracepoint-specific code to extract subfields
from structures.

By the way, a point that should be clarified is that putting a 
"prev->pid" field in a marker does not make this variable live unless
the marker is activated. When disabled, the marker site jumps over the
stack setup, including any pointer dereference.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
