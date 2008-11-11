Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYKKNUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYKKNUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYKKNU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:20:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44781 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbYKKNU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:20:26 -0500
Date: Tue, 11 Nov 2008 14:20:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081111132018.GI14989@elte.hu>
References: <20081107003021.GA18666@google.com> <20081107004824.GA28780@x200.localdomain> <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <20081107084943.GA16147@x200.localdomain> <20081107085352.GA27245@elte.hu> <20081107090304.GA30540@elte.hu> <20081111122531.GA5836@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111122531.GA5836@joi>
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


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> On Fri, Nov 07, 2008 at 10:03:04AM +0100, Ingo Molnar wrote:
> > 
> > btw., the feature works beautifully:
> > 
> > task sleeping/blocked:
> > 
> >  # cat /proc/1/stack
> >  [<ffffffff802bfe75>] do_select+0x51a/0x582
> >  [<ffffffff802c0059>] core_sys_select+0x17c/0x218
> >  [<ffffffff802c0344>] sys_select+0x99/0xc1
> >  [<ffffffff8020c23b>] system_call_fastpath+0x16/0x1b
> >  [<ffffffffffffffff>] 0xffffffffffffffff
> > 
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
> > 
> > task running on another CPU in user-space:
> > 
> >  # cat /proc/18579/stack
> >  [<ffffffffffffffff>] 0xffffffffffffffff
> 
> so this file provides view of _kernel_ stack only?
> shouldn't it be named kernel-stack then?

it prints the kernel stack right now, but i'd not restrict it to the 
kernel stack conceptually: i think we could eventually expand it to 
print the user-space portion of the stack as well. (in the case when 
user-space is built with frame pointers) We've got code for that in 
the kernel already. It would be an easy one-stop-shop for full-range.

	Ingo
