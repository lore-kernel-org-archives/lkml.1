Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbXFZAw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbXFZAw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 20:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXFZAwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 20:52:49 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:46759 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXFZAwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 20:52:49 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru, Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <10203.1182816012@lwn.net>
References: <10203.1182816012@lwn.net>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 20:52:34 -0400
Message-Id: <1182819154.5493.234.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 18:00 -0600, Jonathan Corbet wrote:
> A couple of days ago I said:
> 
> > The cafe_ccic (OLPC) camera driver uses a tasklet to move frames out of
> > the DMA buffers in the streaming I/O path....
> > 
> > Obviously some testing is called for here.  I will make an attempt to do
> > that testing
> 
> I've done that testing - I have an OLPC B3 unit running V2 of the
> tasklet->workqueue patch, and all seems well.  30 FPS to the display and
> no dropped frames.  The tasklets/0 process is running 3-5% CPU, in case
> that's interesting.  For whatever reason, I see about 3% *more* idle
> time when running just mplayer than I did without the patch.
> 
> Consider my minor qualms withdrawn, there doesn't seem to be any trouble
> in this area.

Jon, thanks a lot!

This is great news. I wonder if converting tasklets to work queues also
helps with other softirqs.  Before, softirqs could not preempt a
tasklet, since tasklets run as a softirq. With tasklets as work queues,
what's left as a softirq can now preempt tasklets. Perhaps this can even
help with performance.

-- Steve
  

