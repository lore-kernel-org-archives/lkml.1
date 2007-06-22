Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbXFVLZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbXFVLZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbXFVLZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:25:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbXFVLZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:25:03 -0400
Date: Fri, 22 Jun 2007 13:23:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622112335.GC23139@elte.hu>
References: <20070622040014.234651401@goodmis.org> <20070622070948.GA21291@infradead.org> <20070622075135.GA11695@elte.hu> <20070622075304.GA22682@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622075304.GA22682@infradead.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> > which actual in-kernel tasklets do you have in mind? I'm not aware 
> > of any in performance critical code. (now that both the RCU and the 
> > sched tasklet has been fixed.)
> 
> the one in megaraid_sas for example is in a performance-critical path 
> and was put in quite recently.

ah, i thought core kernel. I took a look, and i doubt that doing the 
megaraid SAS thing over a kernel thread would show up on the radar. If 
it does then it should probably be done in its separate per-CPU 
workqueue anyway, not in a globally scheduled thing like a tasklet. 
Tasklets just dont scale.

	Ingo
