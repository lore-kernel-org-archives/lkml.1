Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbYKKWdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbYKKWdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYKKWcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:32:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbYKKWco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:32:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081111182759.GA8052@Krystal>
References: <20081111182759.GA8052@Krystal> <20081109064855.GA23782@Krystal> <alpine.LFD.2.00.0811090827160.13034@xanadu.home> <20081109162250.GB10181@Krystal> <alpine.LFD.2.00.0811092304300.13034@xanadu.home> <20081109204256.89ab7925.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101627510.13034@xanadu.home> <20081110135850.0d620f3c.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101811130.13034@xanadu.home> <20081110152221.64948d23.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101917450.13034@xanadu.home> 
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: dhowells@redhat.com, Nicolas Pitre <nico@cam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, rmk+lkml@arm.linux.org.uk, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] convert cnt32_to_63 to inline
Date: Tue, 11 Nov 2008 22:31:42 +0000
Message-ID: <8896.1226442702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> @@ -52,18 +57,22 @@ unsigned long long sched_clock(void)
> ...
> +	preempt_disable_notrace();

Please, no!  sched_clock() is called with preemption or interrupts disabled
everywhere except from some debugging code (lock tracing IIRC).  If you need
to insert this preemption disablement somewhere, please insert it there.  At
least then sched_clock() will be called consistently.

David
