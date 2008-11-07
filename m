Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYKGXhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYKGXhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbYKGX3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:29:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55867 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377AbYKGX3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:29:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081107171703.GE22134@Krystal>
References: <20081107171703.GE22134@Krystal> <20081107164758.GB22134@Krystal> <20081107003816.9b0f947a.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> <8481.1226077497@redhat.com> 
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Pitre <nico@cam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Fri, 07 Nov 2008 23:27:59 +0000
Message-ID: <9302.1226100479@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Yes. Do you think the synchronization of the cycles counters is
> _perfect_ across CPUs so that there is no possible way whatsoever that
> two cycle counter values appear to go backward between CPUs ? (also
> taking in account delays in __m_cnt_hi write-back...)

Given there's currently only one CPU allowed, yes, I think it's perfect:-)

It's something to re-evaluate should Panasonic decide to do SMP.

> If we expect the only correct use-case to be with readl(), I don't see
> the problem with added synchronization.

It might be expensive if you don't actually want to call readl().  But that's
on a par with using funky instructions to read the TSC, I guess.

David
