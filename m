Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYBXE1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYBXE1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYBXE1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:27:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707AbYBXE1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:27:00 -0500
Date: Sat, 23 Feb 2008 23:26:51 -0500
From: Rik van Riel <riel@redhat.com>
To: "J.C. Pizarro" <jcpiza@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please, put 64-bit counter per task and incr.by.one each ctxt
 switch.
Message-ID: <20080223232651.41dffa72@bree.surriel.com>
In-Reply-To: <998d0e4a0802232008w5c6566f0se15ab749ec6f1ceb@mail.gmail.com>
References: <998d0e4a0802231908h37978d07wa5379d5c01b2c2ee@mail.gmail.com>
	<20080223221750.429cf0d9@bree.surriel.com>
	<998d0e4a0802232008w5c6566f0se15ab749ec6f1ceb@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 05:08:46 +0100
"J.C. Pizarro" <jcpiza@gmail.com> wrote:

OK, one last reply on the (overly optimistic?) assumption that you are not a troll.

> +++ linux-2.6_git-20080224/include/linux/sched.h        2008-02-24
> 04:50:18.000000000 +0100
> @@ -1007,6 +1007,12 @@
>         struct hlist_head preempt_notifiers;
>  #endif
> 
> +       unsigned long long ctxt_switch_counts; /* 64-bit switches' count */
> +       /* ToDo:
> +        *  To implement a poller/clock for CPU-scheduler that only reads
> +        *   these counts of context switches of the runqueue's tasks.
> +        *  No problem if this poller/clock is not implemented. */

So you're introducing a statistic, but have not yet written any code
that uses it?

> +       p->ctxt_switch_counts = 0ULL; /* task's 64-bit counter inited 0 */

Because we can all read C, there is no need to tell people in comments
what the code does.  Comments are there to explain why the code does
things, if an explanation is needed.

> >  > I will explain your later why of it.
> >
> >
> > ... and explain exactly why the kernel needs this extra code.
> 
> One reason: for the objective of gain interactivity, it's an issue that
>  CFS fair scheduler lacks it.

Your patch does not actually help interactivity, because all it does
is add an irq spinlock in a hot path (bad idea) and a counter which
nothing reads.

-- 
All rights reversed.
