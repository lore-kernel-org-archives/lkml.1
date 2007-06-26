Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbXFZArZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbXFZArZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 20:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXFZArK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 20:47:10 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:51925 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbXFZArF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 20:47:05 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, Kristian H?gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <46805196.8070407@s5r6.in-berlin.de>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
	 <1182797325.1689.14.camel@hinata.boston.redhat.com>
	 <20070625211551.GA29390@elte.hu>  <46805196.8070407@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 20:46:55 -0400
Message-Id: <1182818815.5493.229.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 01:36 +0200, Stefan Richter wrote:

> I can't speak for Kristian, nor do I have test equipment for isochronous
> applications, but I know that there are people out there which do data
> acquisition on as many FireWire buses as they can stuff boards into
> their boxes.  There are also FireWire cards with 2 or 4 controllers per
> board; and each controller can receive or transmit on several channels.
> 
> Depending on the buffering scheme, there may be one (?) interrupt per
> channel and isochronopus cycle.  Or an interrupt when the buffer is
> full.  Some application programmers use large buffers; others want small
> buffers.  An isochronous cycle is 125us.
> 
> Asynchronous I/O can even produce much higher interrupt rates.  I think
> IP over 1394 might indeed cause interrupt rates that are moderately
> higher than 1/125us during normal traffic.  SBP-2 ( = 1394 storage) is
> not as much affected because the bulk of data is transferred without
> interrupts.  So I suppose some eth1394 bandwidth tests with this patch
> series might make sense... alas I'm short of spare time.  (Would be
> interesting to see whether the old ohci1394 driver is blown to bits with
> the patch series; it's an old driver with who-knows what assumptions in
> there.)

Hi, any testing of the patches would be much appreciated. I don't have
access to any boxes that might have problems with running tasklets as
work queues. So if you know others with this equipment, and can pass the
patches off to them. It will hopefully help us know if this patch helps,
hurts, or just doesn't make a difference.

> 
> > Workqueue priority can be set, and your handler should 
> > probably be SCHED_FIFO.
> 
> Does this cooperate nicely with a SCHED_FIFO thread of a userspace data
> acquisition program or audio server or the like?

Well, if you put the prio of the work queue higher, it won't be any
different than a tasklet. A tasklet runs at an even higher priority than
any thread on the system.

-- Steve


