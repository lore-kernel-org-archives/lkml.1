Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXKMLlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXKMLlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXKMLlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:41:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:47955 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbXKMLlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:41:44 -0500
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on
	POWER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       dino@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       antonb@us.ibm.com, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1194948338.6983.20.camel@twins>
References: <20071109181028.GA26800@linux.vnet.ibm.com>
	 <1194641524.21340.14.camel@pasglop>
	 <20071109220717.GJ8826@linux.vnet.ibm.com>
	 <1194753541.21340.26.camel@pasglop>
	 <Pine.LNX.4.58.0711110943510.12853@gandalf.stny.rr.com>
	 <1194814125.6510.14.camel@pasglop>
	 <20071112191526.GC11113@linux.vnet.ibm.com>
	 <1194901925.18185.65.camel@pasglop>  <1194945032.6983.11.camel@twins>
	 <1194948338.6983.20.camel@twins>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 22:09:02 +1100
Message-Id: <1194952142.18185.104.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-13 at 11:05 +0100, Peter Zijlstra wrote:
> Looking at the code:
> 
> /* radix tree not lockless safe ! we use a brlock-type mecanism
>  * for now, until we can use a lockless radix tree
>  */
> static void irq_radix_wrlock(unsigned long *flags)
> 
> The RCU radix tree stuffs have gone upstream long ago.
> 
> Anyway, it seems its the generic irq stuff that uses raw_spinlock_t
> and
> disables IRQs, so there isn't much we can do from the ARCH level I'm
> afraid :-(
> 
> Ingo, any sane ideas?

As discussed on IRC< there are a couple of other related issues, though
part of them go away if I can get rid of the brlock I have in there
thanks to the new RCU based radix tree.

I'll give that some thoughts and come back to you tomorrow or thursday
hopefully with a patch.

Cheers,
Ben.


