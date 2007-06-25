Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbXFYXjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbXFYXjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 19:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXFYXj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 19:39:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54287 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbXFYXj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 19:39:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46805196.8070407@s5r6.in-berlin.de>
Date: Tue, 26 Jun 2007 01:36:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Kristian H?gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <1182797325.1689.14.camel@hinata.boston.redhat.com> <20070625211551.GA29390@elte.hu>
In-Reply-To: <20070625211551.GA29390@elte.hu>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> regarding workqueues - would it be possible for you to test Steve's 
> patch and get us performance numbers? Do you have any test with tons of 
> tasklet activity that would definitely show the performance impact of 
> workqueues?

I can't speak for Kristian, nor do I have test equipment for isochronous
applications, but I know that there are people out there which do data
acquisition on as many FireWire buses as they can stuff boards into
their boxes.  There are also FireWire cards with 2 or 4 controllers per
board; and each controller can receive or transmit on several channels.

Depending on the buffering scheme, there may be one (?) interrupt per
channel and isochronopus cycle.  Or an interrupt when the buffer is
full.  Some application programmers use large buffers; others want small
buffers.  An isochronous cycle is 125us.

Asynchronous I/O can even produce much higher interrupt rates.  I think
IP over 1394 might indeed cause interrupt rates that are moderately
higher than 1/125us during normal traffic.  SBP-2 ( = 1394 storage) is
not as much affected because the bulk of data is transferred without
interrupts.  So I suppose some eth1394 bandwidth tests with this patch
series might make sense... alas I'm short of spare time.  (Would be
interesting to see whether the old ohci1394 driver is blown to bits with
the patch series; it's an old driver with who-knows what assumptions in
there.)

> Workqueue priority can be set, and your handler should 
> probably be SCHED_FIFO.

Does this cooperate nicely with a SCHED_FIFO thread of a userspace data
acquisition program or audio server or the like?
-- 
Stefan Richter
-=====-=-=== -==- ==-=-
http://arcgraph.de/sr/
