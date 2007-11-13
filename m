Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbXKMKX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbXKMKX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbXKMKXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:23:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:49435 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbXKMKXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:23:18 -0500
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on
	POWER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       dino@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       antonb@us.ibm.com, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1194945032.6983.11.camel@twins>
References: <20071109181028.GA26800@linux.vnet.ibm.com>
	 <1194641524.21340.14.camel@pasglop>
	 <20071109220717.GJ8826@linux.vnet.ibm.com>
	 <1194753541.21340.26.camel@pasglop>
	 <Pine.LNX.4.58.0711110943510.12853@gandalf.stny.rr.com>
	 <1194814125.6510.14.camel@pasglop>
	 <20071112191526.GC11113@linux.vnet.ibm.com>
	 <1194901925.18185.65.camel@pasglop>  <1194945032.6983.11.camel@twins>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 20:43:46 +1100
Message-Id: <1194947026.18185.95.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-13 at 10:10 +0100, Peter Zijlstra wrote:
> 
> Correct, -rt can't allocate -anything- when preemption if off. That is
> the cost for having the allocators itself preemptable.
> 
> Even radix_tree_preload() will not work as its functionality was based
> on preempt disable to limit access to a global (per cpu) object
> reserve.
> But maybe something similar could be done with a local reserve by
> using
> struct radix_tree_context to pass it along.
> 
> I'll see if I can come up with anything like that, that is, if that
> would suffice?

For that specific problem, as long as the radix tree can be made to work
while non-preemptible, I'm fine :-)

I'm still worried by other cases where things expect GFP_ATOMIC to work
at any time.

Ben.


