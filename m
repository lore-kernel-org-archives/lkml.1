Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbXFVO30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbXFVO30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbXFVO3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:29:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54639 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbXFVO3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:29:17 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
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
In-Reply-To: <20070622040014.234651401@goodmis.org>
References: <20070622040014.234651401@goodmis.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 22 Jun 2007 07:25:09 -0700
Message-Id: <1182522309.2672.11.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The most part, tasklets today are not used for time critical functions.
> Running tasklets in thread context is not harmful to performance of
> the overall system. 

That is a bold statement...

> But running them in interrupt context is, since
> they increase the overall latency for high priority tasks.


.... since by moving this to process context you do add latency between
the hardirq and the tasklet, and I can see that having performance
impact easily.


