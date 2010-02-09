Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0BIL1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 06:27:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0BIL1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 06:27:50 -0500
Date: Tue, 9 Feb 2010 12:27:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Salman Qazi <sqazi@google.com>
Cc: Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Race in ptrace.
Message-ID: <20100209112700.GA4258@redhat.com>
References: <20100208221632.A7D6F9B33B@bumblebee1.mtv.corp.google.com> <20100208143231.6d804590.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208143231.6d804590.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salman Qazi wrote:
>
> A race in ptrace was pointed to us by a fellow Google engineer, Tavis
> Ormandy.  The race involves interaction between a tracer, a tracee and
> an antagonist.  The tracer is tracing the tracee with PTRACE_SYSCALL and
> waits on the tracee.  In the mean time, an antagonist blasts the tracee
> with SIGCONTs.

Could you please explain how did observe this race? Do you have a
test-case, or could you explain how we can reproduce it?

Because,

> It turns out that a SIGCONT wakes up the
> tracee in kernel mode,

SIGCONT must not wake up a TASK_TRACED task.


Yes, there are some know problems with SIGCONT && ptrace, but I don't
see anthing related to the described problem.

Thanks,

Oleg.

