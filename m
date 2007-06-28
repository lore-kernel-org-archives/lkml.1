Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbXF1Pyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbXF1Pyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbXF1Pym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:54:42 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:58467 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbXF1Pym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:54:42 -0400
Date: Thu, 28 Jun 2007 11:54:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
In-Reply-To: <20070628143850.GA11780@ms2.inr.ac.ru>
Message-ID: <Pine.LNX.4.58.0706281146460.22479@gandalf.stny.rr.com>
References: <20070622040014.234651401@goodmis.org>
 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
 <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
 <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org>
 <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 28 Jun 2007, Alexey Kuznetsov wrote:
> > the context-switch argument i'll believe if i see numbers. You'll
> > probably need in excess of tens of thousands of irqs/sec to even be able
> > to measure its overhead. (workqueues are driven by nice kernel threads
> > so there's no TLB overhead, etc.)
>
> It was authors of the patch who were supposed to give some numbers,
> at least one or two, just to prove the concept. :-)

The problem is that we don't have the hardware that uses tasklets in
critical ways. My original patch series had a debug print in every
function (tasklet_schedule and friends).   I got a few scattered prints on
all my boxes but no flooding of prints. So I can't show that this will
hurt, because on my boxes it does not.

>
> You could set realtime prioriry by default, not a poor nice -5.
> If some network adapters were killed just because I run some task
> with nice --22, it would be just ridiculous.

This is my fault to the patch series. I compelety forgot to up the prio.
My next series will include a change where the tasklet work queue will run
at something like prio FIFO 98 (or maybe 99?)

This is a bit embarrassing that I forgot to do this, since I'm a
real-time developer ;-)

-- Steve

