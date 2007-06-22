Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbXFVN61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbXFVN61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbXFVN6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:58:19 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:39285 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbXFVN6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:58:18 -0400
Subject: Re: [RFC PATCH 2/6] Split out tasklets from softirq.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
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
In-Reply-To: <961aa3350706220645i21ca51b6m82a5189c21fdf5c5@mail.gmail.com>
References: <20070622040014.234651401@goodmis.org>
	 <20070622040136.783692883@goodmis.org>
	 <961aa3350706220645i21ca51b6m82a5189c21fdf5c5@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 09:58:12 -0400
Message-Id: <1182520692.5493.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 22:45 +0900, Akinobu Mita wrote:
> 2007/6/22, Steven Rostedt <rostedt@goodmis.org>:
> 
> > +static inline void tasklet_unlock_wait(struct tasklet_struct *t)
> > +{
> > +       while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
> > +}
> 
> BTW, can we use cpu_relax() instead of barrier() in this busy-wait loop?
> 

Probably, but not in this patch series.  That's part of the code I'm
trying to remove ;-)

-- Steve


