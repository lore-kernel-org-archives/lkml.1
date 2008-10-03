Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYJCQ0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYJCQ0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYJCQ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:26:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42230 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbYJCQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:26:40 -0400
Date: Fri, 3 Oct 2008 12:26:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] x86 Topology cpu_to_node parameter check
In-Reply-To: <20081003155605.GC1607@Krystal>
Message-ID: <alpine.DEB.1.10.0810031223060.26504@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu>
 <20081002090517.GA8708@elte.hu> <20081002093835.GA17699@elte.hu> <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com> <20081003045607.GA5940@Krystal> <alpine.DEB.1.10.0810030117280.26504@gandalf.stny.rr.com> <20081003155605.GC1607@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Oct 2008, Mathieu Desnoyers wrote:
> 
> That's how I did it first, but then I looked at asm-generic/topology.h
> and have seen it uses #defines. Should we change them too ?
> 

The old way of doing this is with defines. But all new code should be 
static inline functions when feasible. This way we can get typechecking 
on the parameters even when the configuration is disabled.

Even if the rest of the file uses defines, the new code should be
static inlines. Eventually, even the old defines will be converted.

-- Steve

