Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZKCQIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZKCQIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZKCQIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:08:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbZKCQIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:08:16 -0500
Date: Tue, 3 Nov 2009 17:07:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <Ian.Campbell@citrix.com>, Tejun Heo <tj@kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Correct nr_processes() when CPUs have been unplugged
Message-ID: <20091103160734.GA21362@elte.hu>
References: <1257243074.23110.779.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257243074.23110.779.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ian Campbell <Ian.Campbell@citrix.com> wrote:

> I'm not 100% convinced that the per_cpu regions remain valid for 
> offline CPUs, although my testing suggests that they do. If not then I 
> think the correct solution would be to aggregate the process_count for 
> a given CPU into a global base value in cpu_down().

Sidenote: percpu areas currently are kept allocated on x86.

That might change in the future though, especially with virtual systems 
where the possible range of CPUs can be very high - without us 
necessarily wanting to pay the percpu area allocation price for it. I.e. 
dynamic deallocation of percpu areas is something that could happen in 
the future.

> This bug appears to pre-date the transition to git and it looks like 
> it may even have been present in linux-2.6.0-test7-bk3 since it looks 
> like the code Rusty patched in http://lwn.net/Articles/64773/ was 
> already wrong.

Nice one. I'm wondering why it was not discovered for such a long time. 
That count can go out of sync easily, and we frequently offline cpus 
during suspend/resume, and /proc lookup failures will be noticed in 
general. How come nobody ran into this? And i'm wondering how you have 
run into this - running cpu hotplug stress-tests with Xen guests - or 
via pure code review?

	Ingo
