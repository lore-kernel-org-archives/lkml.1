Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZJZU2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZJZU2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZJZU2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:28:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40838 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464AbZJZU2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:28:34 -0400
Date: Mon, 26 Oct 2009 21:28:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Cc: roland@redhat.com, akpm@linux-foundation.org, oleg@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, h-shimamoto@ct.jp.nec.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
Message-ID: <20091026202808.GA7107@elte.hu>
References: <4AE1804A.2050404@miraclelinux.com> <20091023114600.GG5886@elte.hu> <4AE2A6A1.1070904@miraclelinux.com> <4AE2C151.8070006@miraclelinux.com> <20091024085848.GA23215@elte.hu> <4AE57745.8080701@miraclelinux.com> <20091026113800.GA9503@elte.hu> <4AE5D0B2.2050706@miraclelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE5D0B2.2050706@miraclelinux.com>
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


* Naohiro Ooiwa <nooiwa@miraclelinux.com> wrote:

> Hi Ingo,
> 
> Now that you mention it, I think so, too.
> I update my patch.
> 
> How is the following patch.
> Could you please review it.
> 
> Thanks you.
> Naohiro Ooiwa
> 
> 
> 
> Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
> ---
>  Documentation/kernel-parameters.txt |    9 ++++++++-
>  kernel/signal.c                     |   16 +++++++++++++---
>  2 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt
> index 9107b38..01c2723 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2032,8 +2032,15 @@ and is between 256 and 4096 characters. It is
> defined in the file
> 
>  	print-fatal-signals=
>  			[KNL] debug: print fatal signals
> +			If you would like to know what the cause of a coredump
> +			by signal number, if your working system may have
> +			too many POSIX.1 timers, and when during the system
> +			test,you may as well to enable this parameter.
>  			print-fatal-signals=1: print segfault info to
> -			the kernel console.
> +			the kernel console, and print caution that reached the
> +			limit of pending signals to the kernel console.
> +			When printed the caution messages, you can try
> +			"ulimit -i unlimited".
>  			default: off.
> 

Here's a slightly improved version of the text:

 	print-fatal-signals=
 			[KNL] debug: print fatal signals

			If enabled, warn about various signal handling 
			related application anomalies: too many signals, 
			too many POSIX.1 timers, fatal signals causing a 
			coredump - etc.

			If you hit the warning due to signal overflow, 
			you might want to try "ulimit -i unlimited".

			default: off.

> +int print_fatal_signals;

i'd suggest __read_mostly.

Plus please move variables to the top of the file. (i know this comes 
from the previous code but we can improve it while we are touching it)

With these things addressed it looks good to me:

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
