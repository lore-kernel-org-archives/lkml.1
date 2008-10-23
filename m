Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYJWQZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYJWQZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbYJWQZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:25:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYJWQZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:25:38 -0400
Date: Thu, 23 Oct 2008 12:05:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 08/13 v2] ftrace: do not trace init sections
In-Reply-To: <49008A9B.8040905@siemens.com>
Message-ID: <alpine.DEB.1.10.0810231202310.1765@gandalf.stny.rr.com>
References: <20081022212721.167005680@goodmis.org> <20081022213552.440512191@goodmis.org> <49005CD0.2070807@siemens.com> <alpine.DEB.1.10.0810230732100.31839@gandalf.stny.rr.com> <49008A9B.8040905@siemens.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Oct 2008, Jan Kiszka wrote:
> 
> >From my POV - I'm using mcount tracing for a few years now -, the thing
> about this is gaining a complete overview of what happens at function
> level, which code paths were taken (at that level). Each bit of
> information you (have to) drop can harm here, even more if they come in
> larger chunks like in this case.

Then you should be happy :-)

I removed the notrace to those sections. Although there is already a
notrace on the __init. We probably should remove it. The recordmcount.pl
does not add tracing to these functions. If you want tracing of these 
functions, you will need to use the static ftrace tracer (!DYNAMIC_FTRACE)

> 
> I don't know if this feature is already considered for / part of
> mainline, but oops backtraces based on mcount instrumentation used to be
> quite helpful for me to understand the wider context of several faults.
> The more you have to mask out of this picture, the harder it gets to
> match the trace to your model of the kernel activities. At least you
> have to know more in advance about the limitation of the tracer...

The ftrace buffer can be dumped out on oops. I'm not sure if it is always 
on. If it is, I need to make it default off and add a command line and 
sysctl to turn it on. Otherwise, we will have people complaining about the 
extra output to the console on oops.

-- Steve

