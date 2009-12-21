Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbZLUGoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbZLUGoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 01:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZLUGoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 01:44:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60513 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbZLUGoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 01:44:07 -0500
Date: Mon, 21 Dec 2009 07:43:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Fix lockdep warning in global_clock()
Message-ID: <20091221064356.GA2378@elte.hu>
References: <4B2F1543.8020300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2F1543.8020300@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

>  # echo 1 > events/enable
>  # echo global > trace_clock
> 
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:3162 check_flags+0xb2/0x190()
> ...
> ---[ end trace 3f86734a89416623 ]---
> possible reason: unannotated irqs-on.
> ...
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_clock.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
> index 84a3a7b..11563c9 100644
> --- a/kernel/trace/trace_clock.c
> +++ b/kernel/trace/trace_clock.c
> @@ -83,7 +83,7 @@ u64 notrace trace_clock_global(void)
>  	int this_cpu;
>  	u64 now;
>  
> -	raw_local_irq_save(flags);
> +	local_irq_save(flags);

Hm, wont this cause problems when we trace inside lockdep? Have you tried the 
lockdep events - do they still work?

	Ingo
