Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbZKIHrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbZKIHrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZKIHrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:47:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZKIHrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:47:21 -0500
Date: Mon, 9 Nov 2009 08:47:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
Subject: Re: [PATCH] extend print_fatal_signals for reached RLIMIT_SIGPENDING
Message-ID: <20091109074707.GE453@elte.hu>
References: <4AF6E7E2.9080406@miraclelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF6E7E2.9080406@miraclelinux.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Naohiro Ooiwa <nooiwa@miraclelinux.com> wrote:

> When the system has too many timers or too many aggregate
> queued signals, the EAGAIN error is returned to application
> from kernel, including timer_create().
> It means that exceeded limit of pending signals at all.
> But we can't imagine it.
> 
> This patch show the message when reached limit of pending signals
> and enabled print_fatal_signals.
> If you see this message and your system behaved unexpectedly,
> you can run following command.
>    # ulimit -i unlimited
> 
> With help from Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>.
> 
> 
> Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> ---
>  Documentation/kernel-parameters.txt |   11 +++++++++--
>  kernel/signal.c                     |   21 ++++++++++++++++++---
>  2 files changed, 27 insertions(+), 5 deletions(-)

Thanks, i've applied your patch to tip:core/signal, for v2.6.33 merge 
(if it passes all tests).

I made a few (very small) changes, see the -tip commit notification 
email in this thread with the final commit:

 - Extended the functions so that we can print which precise signal got 
   dropped - app writers will likely want to know that

 - Changed the message to:

        task/1234: reached RLIMIT_SIGPENDING, dropping signal

   which is slightly more informative.

 - Cleaned up small cleanliness details in surrounding code that caught 
   my eyes.

 - Changed a few variable and function names to be a tiny bit more 
   expressive.

 - Pushed the print_fatal_printks check into the new utility function 
   (print_dropped_signal()), to not clutter __sigqueue_alloc() 
   needlessly.

 - Clarified the commit log message a bit, gave sample output of the new 
   behavior.

Thanks,

	Ingo
