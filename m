Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYKGK43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYKGK43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 05:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYKGK4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 05:56:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45822 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbYKGK4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 05:56:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081107053349.861709786@polymtl.ca>
References: <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Fri, 07 Nov 2008 10:55:12 +0000
Message-ID: <25257.1226055312@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Assume the time source is a global clock which insures that time will never
> *ever* go backward. Use a smp_rmb() to make sure the cnt_lo value is read before
> __m_cnt_hi.

If you have an smp_rmb(), then don't you need an smp_wmb()/smp_mb() to match
it to make it work?  And is your assumption valid that smp_rmb() will affect
memory vs the I/O access to read the clock?  There's no requirement that
cnt_lo will have been read from an MMIO location at all.

David
