Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYKGJ31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYKGJ31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYKGJ3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:29:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYKGJ3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:29:12 -0500
Date: Fri, 7 Nov 2008 10:29:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081107092902.GB7787@elte.hu>
References: <20081107003021.GA18666@google.com> <20081107004824.GA28780@x200.localdomain> <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <20081107084943.GA16147@x200.localdomain> <20081107085352.GA27245@elte.hu> <20081107090304.GA30540@elte.hu> <20081107011659.98d3788a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107011659.98d3788a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 7 Nov 2008 10:03:04 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > task running on this CPU:
> > 
> >  # cat /proc/self/stack
> >  [<ffffffff80216f79>] save_stack_trace_tsk+0x26/0x44
> >  [<ffffffff802f59a5>] proc_pid_stack+0x6e/0xd3
> >  [<ffffffff802f6da3>] proc_info_read+0x68/0xba
> >  [<ffffffff802b2f17>] vfs_read+0xa9/0xe3
> >  [<ffffffff802b301f>] sys_read+0x4c/0x73
> >  [<ffffffff8020c23b>] system_call_fastpath+0x16/0x1b
> >  [<ffffffffffffffff>] 0xffffffffffffffff
> 
> So we provide a means by which process A can sample process B's 
> instruction pointer?  Even if it's in random.c or crypto code?  
> There's a little project for someone.

yes - like "echo p > /proc/sysrq-trigger" and sysrq-t. Although unlike 
sysrq-p, the IP itself isnt printed, just the stack trace - but 
there's indeed a correlation.

> I guess the 0400 mode on that file will suffice...

correct, 0400 is used already in the present patch:

 phoenix:~> cat /proc/1/stack
 cat: /proc/1/stack: Permission denied

but that is _not_ enough, it should be narrowed even more, to the 
boundaries that i pointed out in my first review feedback mail, and 
which is not implemented yet:

 1) only root should be allowed to do this - i.e. file needs to be 
    root-owned.

 2) there also needs to be a .config entry for folks to be able to
    turn it off altogether - just like folks can turn off sysrq-t 
    dumping via the .config.

	Ingo
