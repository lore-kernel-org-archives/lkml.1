Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbXKKUtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbXKKUtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 15:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXKKUtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 15:49:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:51598 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbXKKUtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 15:49:31 -0500
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on
	POWER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tony@bakeyournoodle.com, paulus@samba.org, dino@in.ibm.com,
       tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com, antonb@us.ibm.com
In-Reply-To: <Pine.LNX.4.58.0711110943510.12853@gandalf.stny.rr.com>
References: <20071109181028.GA26800@linux.vnet.ibm.com>
	 <1194641524.21340.14.camel@pasglop>
	 <20071109220717.GJ8826@linux.vnet.ibm.com>
	 <1194753541.21340.26.camel@pasglop>
	 <Pine.LNX.4.58.0711110943510.12853@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 12 Nov 2007 07:48:45 +1100
Message-Id: <1194814125.6510.14.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-11-11 at 09:45 -0500, Steven Rostedt wrote:
> > Well, I suppose the patch could go in, maybe with some ifdef's
> around
> > the bits in _switch_to, there's little point in doing that on non-rt
> > kernels.
> 
> As Nick Piggin already stated, and I'll even state it for the RT
> kernel,
> we do not allow preemption in switch_to. So it is safe to remove those
> "preempt_disable" bits from the patch

Sure, I know that, I'm not talking about that, I'm talking about the
added code that flush pending batches & save the batch state, since on
non-rt kernel, this is not useful (the batch is only ever active within
a spinlocked section, which cannot be preempted on non-rt).

Ben.
 

