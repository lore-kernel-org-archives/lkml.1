Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbXFYRHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbXFYRHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbXFYRGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:06:53 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:64293 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbXFYRGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:06:52 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru, Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <467FF23B.30509@imap.cc>
References: <10876.1182698167@lwn.net>  <467FF23B.30509@imap.cc>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 13:06:43 -0400
Message-Id: <1182791203.5493.161.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 18:50 +0200, Tilman Schmidt wrote:

> The Siemens Gigaset ISDN base driver uses tasklets in its isochronous
> data paths. These will be scheduled for each completion of an isochronous
> URB, or every 8 msec for each of the four isochronous pipes if both B
> channels are connected. The driver uses three URBs for each pipe, always
> maintaining two in flight while processing the third one. So the tasklet
> has to run within 16 ms from being scheduled in order to avoid packet
> loss (in the receive path) or data underrun (in the transmit path).
> 
> Does that qualify as performance sensitive for the purpose of this
> discussion?

Actually, no.  16ms, even 8ms is an incredible amount of time. Unless
you have a thread that is running at a higher priority than the thread
that handles the work queue performing the task, you would have no
problems making that deadline.  If you did miss the deadline without
having ridiculously high prio tasks, I would think that you would miss
your deadline with tasklets as well. Unless the large latency has to do
with preempt_disable, but that large of a latency would be IMHO a bug.

-- Steve
 

