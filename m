Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZCXSbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZCXSbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZCXSbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:31:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51950 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbZCXSbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:31:00 -0400
Date: Tue, 24 Mar 2009 19:26:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, ia6432@inbox.ru, roland@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:timers/urgent] posix timers: fix RLIMIT_CPU && fork()
Message-ID: <20090324182651.GA13408@redhat.com>
References: <20090323193411.GA17514@redhat.com> <tip-37bebc70d7ad4144c571d74500db3bb26ec0c0eb@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-37bebc70d7ad4144c571d74500db3bb26ec0c0eb@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Oleg Nesterov wrote:
>
> Commit-ID:  37bebc70d7ad4144c571d74500db3bb26ec0c0eb
> Gitweb:     http://git.kernel.org/tip/37bebc70d7ad4144c571d74500db3bb26ec0c0eb
> Author:     Oleg Nesterov <oleg@redhat.com>
> AuthorDate: Mon, 23 Mar 2009 20:34:11 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 23 Mar 2009 20:43:35 +0100
>
> posix timers: fix RLIMIT_CPU && fork()
>
> See http://bugzilla.kernel.org/show_bug.cgi?id=12911
>
> copy_signal() copies signal->rlim, but RLIMIT_CPU is "lost". Because
> posix_cpu_timers_init_group() sets cputime_expires.prof_exp = 0 and thus
> fastpath_timer_check() returns false unless we have other cpu timers.
>
> This is the minimal fix for 2.6.29 (tested) and 2.6.28. The patch is not
> optimal,

Ingo, please drop this patch, it is very suboptimal.

My intent was to make the obviously correct patch for 2.6.29, but since
it was already released I'll send another one.

And,

> we need further cleanups here. With this patch update_rlimit_cpu()
> is not really needed, but I don't think it should be removed.
>
> The proper fix (I think) is:
>
> 	- set_process_cpu_timer() should just start the cputimer->running
> 	  logic (it does), no need to change cputime_expires.xxx_exp

I am stupid, of course we should set cputime_expires.xxx_exp to avoid
the slow path in run_posix_cpu_timers().

Oleg.

