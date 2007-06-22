Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbXFVOmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbXFVOmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbXFVOmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:42:18 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:46068 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbXFVOmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:42:17 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <1182522309.2672.11.camel@laptopd505.fenrus.org>
References: <20070622040014.234651401@goodmis.org>
	 <1182522309.2672.11.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 10:42:10 -0400
Message-Id: <1182523330.5493.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 07:25 -0700, Arjan van de Ven wrote:
> > The most part, tasklets today are not used for time critical functions.
> > Running tasklets in thread context is not harmful to performance of
> > the overall system. 
> 
> That is a bold statement...
> 
> > But running them in interrupt context is, since
> > they increase the overall latency for high priority tasks.
> 
> 
> .... since by moving this to process context you do add latency between
> the hardirq and the tasklet, and I can see that having performance
> impact easily.

This is stated on the assumption that pretty much all performance
critical tasklets have been removed (although Christoph just mentioned
megaraid_sas, but after I made this statement).

We've been running tasklets as threads in the -rt kernel for some time
now, and that hasn't bothered us.

The problem with tasklets is that they still don't provide guaranteed
performance. They can still be pushed off to ksoftirqd on a busy system.
But having *all* tasklets as they are today, keeps them at a higher
priority then any process in the system.

-- Steve


