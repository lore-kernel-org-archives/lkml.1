Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZLHIh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZLHIh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZLHIhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:37:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:38930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbZLHIhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:37:23 -0500
Message-ID: <4B1E105E.7030208@kernel.org>
Date: Tue, 08 Dec 2009 17:37:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: percpu/tip tree build failure
References: <20091208182515.bb6dda4a.sfr@canb.auug.org.au> <20091208080509.GD4989@nowhere> <20091208082436.GA12761@elte.hu>
In-Reply-To: <20091208082436.GA12761@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2009 05:24 PM, Ingo Molnar wrote:
>> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> I have applied it - but really, the new percpu namespace changes headed 
> towards upstream are quite a nuisance IMO. The 3-4 (trivial to solve) 
> breakages i've seen so far affecting code i maintain give us an 
> estimation about the ongoing maintainence cost - which wont be high but 
> not zero either.
> 
> The change that was forced here:
> 
>  -static DEFINE_PER_CPU(unsigned int, task_bp_pinned[HBP_NUM]);
>  +static DEFINE_PER_CPU(unsigned int, nr_task_bp_pinned[HBP_NUM]);
> 
> Is it really an improvement to the old code?
>
> Dunno.

In each specific conflict, I don't think it would be an apparent
improvement but overall I do believe it's headed the right way.  Well,
or, at the very least, I don't see any other viable solution and
you're probably the most strongly affected by the change.  Sorry about
the inconveniences.

I'm waiting for ack for a m68k change before pushing out percpu tree.
I'm not completely determined but I think I'll keep dropping per_cpu__
prefix and sparse annotation in linux-next for one more cycle as
sparse annotation cleanup pass hasn't been done yet.  Once new devel
cycle begins, it might be a good idea to pull in percpu changes into
one of the tip trees so that these nuisances can be detected during
development?

Thanks.

-- 
tejun
