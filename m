Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbYKGVXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbYKGVXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYKGVXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:23:09 -0500
Received: from relais.videotron.ca ([24.201.245.36]:51751 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbYKGVXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:23:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 07 Nov 2008 16:22:59 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: David Howells <dhowells@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
In-reply-to: <20081107205528.GA2654@Krystal>
Message-id: <alpine.LFD.2.00.0811071614470.13034@xanadu.home>
References: <20081107053349.861709786@polymtl.ca>
 <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com>
 <20081107170902.GD22134@Krystal>
 <alpine.LFD.2.00.0811071522270.13034@xanadu.home>
 <20081107205528.GA2654@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Mathieu Desnoyers wrote:

> First off, read hw cnt low _is_ an uncached memory read (this is the
> mmio read). __m_cnt_hi is a cached read, and therefore can be delayed if
> the cache-line is busy. And we have no control on how much time can pass
> between the two reads given the CPU may stall waiting for a cache-line.
> 
> So the scenario above happens if CPU A have __m_cnt_hi in its cacheline,
> but for come reason CPU B have to defer the cacheline read of __m_cnt_hi
> due to heavy cacheline traffic and decides to proceed to mmio read
> before the cacheline has been brought to the CPU because "hey, there is
> no data dependency between those two reads !".

OK that makes sense.


Nicolas
