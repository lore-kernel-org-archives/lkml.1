Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbZIRX1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbZIRX1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 19:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZIRX1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 19:27:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbZIRX1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 19:27:47 -0400
Date: Sat, 19 Sep 2009 01:22:15 +0200
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
Message-ID: <20090918232215.GA25517@redhat.com>
References: <20090901145526.GA31317@redhat.com> <20090901165235.GA9105@redhat.com> <m13a76xnbw.fsf@fess.ebiederm.org> <20090902091340.GA5173@redhat.com> <20090904073749.GB20598@elte.hu> <20090918163241.GA8556@desktop> <20090918185425.GA16620@redhat.com> <alpine.LFD.2.01.0909181217270.4950@localhost.localdomain> <20090918211218.GA19351@redhat.com> <alpine.LFD.2.01.0909181504400.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909181504400.4950@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Linus Torvalds wrote:
>
> As to why pid == 0 wouldn't work, I don't know, but I'll take your word
> for it.

Say, admin wants to renice kthreadd or change its affinity. And we can't
show kthread in /proc if its pid is 0.

This can be changed afaics, we can even remove pidmap_init()->set_bit(0) so
that the first copy_process()->alloc_pid() will create the pid with nr == 0.
We don't care about unhashed init_struct_pid which also has nr == 0.

But I don't think this would be good, currently the code can safely assume
that the valid pid can't be 0. For example, find_process_by_pid(0) returns
current.

Oleg.

