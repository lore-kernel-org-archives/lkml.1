Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZIRVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZIRVVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 17:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZIRVVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 17:21:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbZIRVVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 17:21:37 -0400
Date: Fri, 18 Sep 2009 23:15:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fei <at.wufei@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, arjan@infradead.org,
       jeremy@goop.org, mschmidt@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/1] kthreads: simplify !kthreadd_task logic, kill
	kthreadd_task_init_done
Message-ID: <20090918211534.GB19351@redhat.com>
References: <20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com> <20090901165235.GA9105@redhat.com> <m13a76xnbw.fsf@fess.ebiederm.org> <20090902091340.GA5173@redhat.com> <20090904073749.GB20598@elte.hu> <20090918163241.GA8556@desktop> <20090918185425.GA16620@redhat.com> <alpine.LFD.2.01.0909181217270.4950@localhost.localdomain> <20090918211218.GA19351@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918211218.GA19351@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Oleg Nesterov wrote:
>
> But personally I still can't understand what happens. If we were
> preempted somewhere before "kthreadd_task = find_task_by_pid_ns()"
> initialization, then schedule_debug() should complain? rest_init()
> runs under preempt_disable().

Ah. CONFIG_PREEMPT_VOLUNTARY means !CONFIG_PREEMPT, and Ingo mentioned
that SMP is disabled, this also means lock_kernel() is noop.

Oleg.

