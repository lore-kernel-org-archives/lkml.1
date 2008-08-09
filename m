Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYHIHPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYHIHPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 03:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYHIHO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 03:14:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:34321 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYHIHO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 03:14:58 -0400
Subject: Re: LTTng finds abnormally long APIC interrupt handler : 58.2 ms
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca
In-Reply-To: <20080808231126.GA23766@Krystal>
References: <20080805182007.GA4631@Krystal>
	 <alpine.DEB.1.10.0808051523370.28170@gandalf.stny.rr.com>
	 <20080807160907.GA11255@Krystal>
	 <alpine.DEB.1.10.0808071314320.20931@gandalf.stny.rr.com>
	 <20080808231126.GA23766@Krystal>
Content-Type: text/plain
Date: Sat, 09 Aug 2008 09:14:25 +0200
Message-Id: <1218266065.29098.36.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 19:11 -0400, Mathieu Desnoyers wrote:

> The basic question that arises from this trace is : is it normal for
> find_usage_backwards to be called ~8500 times during a spinlock ?

Yes and no - its O(n^2) graph walking. That said, David Miller did a
cool patch that reduces the graph walk by not doing the same subgraph
over and over again. Look at this series:

  http://lkml.org/lkml/2008/8/4/175

Andrew picked all that up - so it should be in the next -mm.

It also contains a new scheduler run-queue annotation which should
greatly reduce the chain length, adding to even more benefit.

