Return-Path: <linux-kernel-owner+w=401wt.eu-S1031954AbXFHTpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031954AbXFHTpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031801AbXFHToa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:44:30 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:39135 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031793AbXFHTo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:44:28 -0400
Subject: Re: [PATCH RT] convert RCU Preempt tasklet into softirq.
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <20070608193655.GA18399@linux.vnet.ibm.com>
References: <1181180051.18444.31.camel@localhost.localdomain>
	 <20070607041411.GB1783@linux.vnet.ibm.com>
	 <1181226138.18444.54.camel@localhost.localdomain>
	 <20070607161754.GA11941@linux.vnet.ibm.com>
	 <1181240819.10408.14.camel@localhost.localdomain>
	 <20070607210247.GA9390@linux.vnet.ibm.com>
	 <1181316428.10408.30.camel@localhost.localdomain>
	 <20070608193655.GA18399@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 15:43:48 -0400
Message-Id: <1181331828.10408.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 12:36 -0700, Paul E. McKenney wrote:
> On Fri, Jun 08, 2007 at 11:27:08AM -0400, Steven Rostedt wrote:

> > The first time I compiled it, I forgot the ';' and got a warning there.
> > But the warning also included "declaring structure softirq_action in
> > prototype", so I fixed both the ';' and added the struct. I can try
> > compile without it. But I also know that adding #include <interrupt.h>
> > in rcupreempt.h caused issues too.
> 
> If I leave out both the "struct softirq_action" and the
> rcu_process_callbacks() declaration,, it compiles for me.
> 
> So I guess the rcu_process_callbacks() should be declared static...

OK, I can update the patch to reflect that. Remember, I didn't learn
anything from doing this patch, so I have no idea why
rcu_procell_callbacks was global. I was just keeping to the norm. :-)

Actually, I'll make a separate patch for this change. This is a
different issue.

-- Steve


