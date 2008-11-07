Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYKGRLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYKGRLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 12:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYKGRLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 12:11:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57685 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYKGRLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 12:11:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081107082926.ee3e1efe.akpm@linux-foundation.org>
References: <20081107082926.ee3e1efe.akpm@linux-foundation.org> <20081107075003.fa93ccf4.akpm@linux-foundation.org> <20081107003816.9b0f947a.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> <alpine.LFD.2.00.0811070952150.13034@xanadu.home> <8189.1226074915@redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Nicolas Pitre <nico@cam.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Fri, 07 Nov 2008 17:10:00 +0000
Message-ID: <8509.1226077800@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton <akpm@linux-foundation.org> wrote:

> I'd expect it to behave in the same way as it would if the function was
> implemented out-of-line.
> 
> But it occurs to me that the modrobe-doesnt-work thing would happen if
> the function _is_ inlined anyway, so we won't be doing that.
> 
> Whatever.  Killing this many puppies because gcc may do something so
> bizarrely wrong isn't justifiable.

With gcc, you get one instance of the static variable from inside a static
(inline or outofline) function per .o file that invokes it, and these do not
merge even though they're common symbols.  I asked around and the opinion
seems to be that this is correct C.  I suppose it's the equivalent of cutting
and pasting a function between several files - why should the compiler assume
it's the same function in each?

David
