Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZLUOlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZLUOlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbZLUOlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:41:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZLUOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:41:12 -0500
Subject: Re: [PATCH] tracing: Fix lockdep warning in global_clock()
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B2F2588.8070501@cn.fujitsu.com>
References: <4B2F1543.8020300@cn.fujitsu.com>
	 <20091221064356.GA2378@elte.hu>  <4B2F2588.8070501@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 15:40:27 +0100
Message-ID: <1261406427.4314.155.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 15:36 +0800, Li Zefan wrote:

> +++ b/kernel/sched_clock.c
> @@ -250,9 +250,9 @@ unsigned long long cpu_clock(int cpu)
>         unsigned long long clock;
>         unsigned long flags;
> 
> -       raw_local_irq_save(flags);
> +       local_irq_save(flags);
>         clock = sched_clock_cpu(cpu);
> -       raw_local_irq_restore(flags);
> +       local_irq_restore(flags);
> 
>         return clock;
>  }
> ===============================================
> 
> I guess it's still true that lower level functions can take locks?

No, I removed the locks from cpu_clock a while back.

