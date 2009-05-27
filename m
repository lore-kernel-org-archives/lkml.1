Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbZE0Rz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbZE0Rz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764157AbZE0Rue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:50:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763924AbZE0Rud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:50:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Chris Friesen <cfriesen@nortel.com>, LKML <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: linux missing support for _POSIX_THREAD_CPUTIME?
In-Reply-To: Thomas Gleixner's message of  Wednesday, 27 May 2009 18:56:15 +0200 <alpine.LFD.2.00.0905271855290.3397@localhost.localdomain>
References: <4A1D6E71.90602@nortel.com>
	<alpine.LFD.2.00.0905271855290.3397@localhost.localdomain>
X-Zippy-Says: Is this TERMINAL fun?
Message-Id: <20090527174954.085AAFC36B@magilla.sf.frob.com>
Date: Wed, 27 May 2009 10:49:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> POSIX defines optional support for clock ID values obtained by invoking
> pthread_getcpuclockid().  When passed to clock_gettime(), this allows
> the caller to request the CPU-time clock of an arbitrary thread within
> the same process as the caller.
> 
> It appears that linux doesn't support this functionality--is that
> correct?  Is there any plan to enable this?

glibc does implement pthread_getcpuclockid using the kernel support for it.
It uses MAKE_THREAD_CPUCLOCK(tid, CPUCLOCK_SCHED) (see linux/posix-timers.h).

> Is there any current way to obtain the runtime of a particular thread
> without knowing its tid (since the thread_id to tid mapping is known
> only to glibc)?

You need a tid to construct the clock ID with MAKE_THREAD_CPUCLOCK().
The pthread_getcpuclockid function exists to do this for you when you are
using pthreads.  If you are not using pthreads, then certainly you have to
figure out what a thread's tid is yourself.


Thanks,
Roland
