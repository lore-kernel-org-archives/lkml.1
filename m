Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbZCaPDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbZCaPDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761602AbZCaPDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:03:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36197 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761546AbZCaPDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:03:20 -0400
Date: Tue, 31 Mar 2009 16:57:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Peter Lojkin <ia6432@inbox.ru>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, stable@kernel.org
Subject: Re: [stable] [PATCH 1/2] posix-timers: fix RLIMIT_CPU && fork()
Message-ID: <20090331145750.GB4792@redhat.com>
References: <20090327000607.GA10104@redhat.com> <20090331030133.GH3264@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331030133.GH3264@hera.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Chris Wright wrote:
>
> * Oleg Nesterov (oleg@redhat.com) wrote:
> > See http://bugzilla.kernel.org/show_bug.cgi?id=12911
> >
> > copy_signal() copies signal->rlim, but RLIMIT_CPU is "lost". Because
> > posix_cpu_timers_init_group() sets cputime_expires.prof_exp = 0 and thus
> > fastpath_timer_check() returns false unless we have other expired cpu timers.
> >
> > Change copy_signal() to set cputime_expires.prof_exp if we have RLIMIT_CPU.
> > Also, set cputimer.running = 1 in that case. This is not strictly necessary,
> > but imho makes sense.
>
> For -stable should this be instead of 37bebc70d7ad4144c571d74500db3bb26ec0c0eb?

Yes, sorry for confusion.

The commit above was targeted for 2.6.29, it is not optimal. When/if
"[PATCH 1/2] posix-timers: fix RLIMIT_CPU && fork()" will be merged, I'll sent
the "revert" patch.

see http://marc.info/?t=123783777600004

Oleg.

