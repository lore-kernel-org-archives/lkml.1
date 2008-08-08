Return-Path: <linux-kernel-owner+w=401wt.eu-S1761170AbYHHUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761170AbYHHUwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbYHHUwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:52:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760356AbYHHUwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:52:11 -0400
Date: Fri, 8 Aug 2008 13:46:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, rostedt@goodmis.org
Subject: Re: [PATCH] printk: robustify printk
Message-Id: <20080808134657.fe439e56.akpm@linux-foundation.org>
In-Reply-To: <1218227859.29098.24.camel@lappy.programming.kicks-ass.net>
References: <1218202249.8625.106.camel@twins>
	<alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
	<1218215454.8625.133.camel@twins>
	<alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	<1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	<alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	<1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
	<20080808121428.646a8b3c.akpm@linux-foundation.org>
	<1218223269.29098.12.camel@lappy.programming.kicks-ass.net>
	<20080808123747.0db1c5dd.akpm@linux-foundation.org>
	<20080808203241.GH6760@linux.vnet.ibm.com>
	<1218227859.29098.24.camel@lappy.programming.kicks-ass.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Aug 2008 22:37:39 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2008-08-08 at 13:32 -0700, Paul E. McKenney wrote:
> 
> > How about if I instead add comments warning people not to put printk()
> > in the relevant RCU-implementation code?  That way I can be not only lazy,
> > but cowardly as well!  ;-)
> 
> Well, it does spoil the party a little, we are now trading one deadlock
> for another :-/
> 

Yup.  We could just as easily put those comments into the scheduler
wakeup code.

Why are we fixing this, btw?  The problem has been there forever and
people who hack the wakeup code could/should know about it anyway.  All
they need to do is to disable klogd during development.  Did the
problem recently become worse for some reason?

