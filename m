Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbZCaDCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbZCaDCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 23:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbZCaDCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 23:02:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:33706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbZCaDCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 23:02:07 -0400
Date: Tue, 31 Mar 2009 03:01:33 +0000
From: Chris Wright <chrisw@sous-sol.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Peter Lojkin <ia6432@inbox.ru>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, stable@kernel.org
Subject: Re: [stable] [PATCH 1/2] posix-timers: fix RLIMIT_CPU && fork()
Message-ID: <20090331030133.GH3264@hera.kernel.org>
References: <20090327000607.GA10104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327000607.GA10104@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 31 Mar 2009 03:01:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov (oleg@redhat.com) wrote:
> See http://bugzilla.kernel.org/show_bug.cgi?id=12911
> 
> copy_signal() copies signal->rlim, but RLIMIT_CPU is "lost". Because
> posix_cpu_timers_init_group() sets cputime_expires.prof_exp = 0 and thus
> fastpath_timer_check() returns false unless we have other expired cpu timers.
> 
> Change copy_signal() to set cputime_expires.prof_exp if we have RLIMIT_CPU.
> Also, set cputimer.running = 1 in that case. This is not strictly necessary,
> but imho makes sense.

For -stable should this be instead of 37bebc70d7ad4144c571d74500db3bb26ec0c0eb?

thanks,
-chris
