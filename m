Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYKGLAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYKGLAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYKGLAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:00:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45898 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbYKGLAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:00:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081106220530.5b0e3a96.akpm@linux-foundation.org>
References: <20081106220530.5b0e3a96.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Fri, 07 Nov 2008 10:59:28 +0000
Message-ID: <25275.1226055568@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> I mean, the darned thing is called from sched_clock(), which can be
> concurrently called on separate CPUs and which can be called from
> interrupt context (with an arbitrary nesting level!) while it was running
> in process context.
> 
> Who let that thing into Linux?

Having crawled all over it, and argued with Nicolas and Panasonic about it, I
think it's safe in sched_clock(), provided sched_clock() never gets preempted -
which appears to be the case.

David
