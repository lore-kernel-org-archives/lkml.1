Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbXF2O0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbXF2O0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbXF2OZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:25:56 -0400
Received: from mail.screens.ru ([213.234.233.54]:40200 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759008AbXF2OZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:25:55 -0400
Date: Fri, 29 Jun 2007 18:26:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070629142617.GA341@tv-sign.ru>
References: <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <Pine.LNX.4.58.0706290919350.8866@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0706290919350.8866@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Steven Rostedt wrote:
> 
> On Fri, 29 Jun 2007, Alexey Kuznetsov wrote:
> >
> > static void measure_workqueue(void)
> > {
> > 	int i;
> > 	int cnt = 0;
> > 	unsigned long start;
> > 	DECLARE_WORK(test, do_test_wq, 0);
> > 	struct workqueue_struct * wq;
> >
> > 	start = jiffies;
> >
> > 	wq = create_workqueue("testq");

Also, create_workqueue() is very costly. The last 2 lines should be
reverted.

Oleg.

