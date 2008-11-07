Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYKGX4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYKGX4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYKGX4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:56:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39938 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbYKGX4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:56:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0811071513180.13034@xanadu.home>
References: <alpine.LFD.2.00.0811071513180.13034@xanadu.home> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <25298.1226055815@redhat.com> <20081107165112.GC22134@Krystal>
To: Nicolas Pitre <nico@cam.org>
Cc: dhowells@redhat.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Fri, 07 Nov 2008 23:55:05 +0000
Message-ID: <9500.1226102105@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nico@cam.org> wrote:

> I explained several times already why I disagree.  Preemption is not a 
> problem unless you're preempted away for long enough, or IOW if your 
> counter is too fast.

That's my point.  Say a nice -19 process gets preempted... what guarantees
that it will resume within, the time it takes the counter to wrap?  Even if
the preempting process goes back to sleep, in that time a bunch of other
processes could have woken up and could starve it for a long period of time.

David
