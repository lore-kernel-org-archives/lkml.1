Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbXGPUof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbXGPUof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762828AbXGPUoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:44:19 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:63709 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762708AbXGPUoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:44:18 -0400
Date: Mon, 16 Jul 2007 16:44:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 1/8] Convert the RCU tasklet into a softirq
In-Reply-To: <alpine.LFD.0.999.0707161322440.20061@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0707161638460.18244@gandalf.stny.rr.com>
References: <20070627193633.025544061@goodmis.org> <20070627194327.241131609@goodmis.org>
 <20070716201251.GB12458@linux.vnet.ibm.com>
 <alpine.LFD.0.999.0707161322440.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 16 Jul 2007, Linus Torvalds wrote:

>
> Btw, are there any numbers on this? Is this whole thing actually
> noticeable?

Besides the obvious removal of code?

The old way actually made an effort to create per_cpu tasklets!  So that
the tasklets *can* run simultaneously, making it in essense a softirq.
Since tasklets are implemented by the softirq, with a lot of code to make
a tasklet function run only on one CPU at a time, and it can run on any
CPU.  By converting the rcu tasklet (which had work to make it act like a
softirq) to just be a softirq, we removed all the extra overhead of a
tasklet.

But to answer your question.  No, I didn't take any actual measurements.
The changes just seemed obvious to me (and others).

-- Steve

