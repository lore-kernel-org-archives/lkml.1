Return-Path: <linux-kernel-owner+w=401wt.eu-S1161441AbXDXHGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161441AbXDXHGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161674AbXDXHGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:06:00 -0400
Received: from sumo.dreamhost.com ([66.33.216.29]:34485 "EHLO
	sumo.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161441AbXDXHF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:05:59 -0400
Message-ID: <462DAC06.9040309@dawes.za.net>
Date: Tue, 24 Apr 2007 09:04:38 +0200
From: Rogan Dawes <lists@dawes.za.net>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Peter Williams <pwil3058@bigpond.net.au>,
       ck list <ck@vds.kolivas.org>, Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
References: <20070420140457.GA14017@elte.hu>	<200704220155.20856.kernel@kolivas.org>	<20070421160008.GA28783@elte.hu>	<200704220959.34978.kernel@kolivas.org>	<87647oblx5.fsf@pps.jussieu.fr>	<alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>	<20070423013429.GB25162@wotan.suse.de>	<alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org>	<20070423191143.GA16849@elte.hu>	<alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org> <20070423203317.GA26668@elte.hu>
In-Reply-To: <20070423203317.GA26668@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> static void
> yield_task_fair(struct rq *rq, struct task_struct *p, struct task_struct *p_to)
> {
>         struct rb_node *curr, *next, *first;
>         struct task_struct *p_next;
> 
>         /*
>          * yield-to support: if we are on the same runqueue then
>          * give half of our wait_runtime (if it's positive) to the other task:
>          */
>         if (p_to && p->wait_runtime > 0) {
>                 p->wait_runtime >>= 1;
>                 p_to->wait_runtime += p->wait_runtime;
>         }
> 
> the above is the basic expression of: "charge a positive bank balance". 
> 

[..]

> [note, due to the nanoseconds unit there's no rounding loss to worry 
> about.]

Surely if you divide 5 nanoseconds by 2, you'll get a rounding loss?

> 	Ingo

Rogan
