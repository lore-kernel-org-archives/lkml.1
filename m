Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZIKVan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZIKVan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZIKVak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:30:40 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11317 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbZIKVak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:30:40 -0400
Date: Fri, 11 Sep 2009 23:30:42 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/fpu for v2.6.32
In-Reply-To: <20090911194432.GA29736@elte.hu>
Message-ID: <alpine.LNX.2.00.0909112318190.31018@swampdragon.chaosbits.net>
References: <20090911194432.GA29736@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

First of all, I want to say that I have no real objections to the patch 
what-so-ever. The following is merely to satisfy my own personal 
curiosity - and I'm sure you have better things to do than satisfy my 
curiosity, so if you want to ignore me; feel free :-)

On Fri, 11 Sep 2009, Ingo Molnar wrote:

[...]
> +	bool preload_fpu;
>  
>  	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
>  
> -	__unlazy_fpu(prev_p);
> +	/*
> +	 * If the task has used fpu the last 5 timeslices, just do a full
> +	 * restore of the math state immediately to avoid the trap; the
> +	 * chances of needing FPU soon are obviously high now
> +	 */
> +	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
>  
> +	__unlazy_fpu(prev_p);
>  
[...]
> +	 * If the task has used fpu the last 5 timeslices, just do a full
> +	 * restore of the math state immediately to avoid the trap; the
> +	 * chances of needing FPU soon are obviously high now
> +	 */
> +	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
>  

I'm wondering about two things:

1) Where did that magic constant "5" come from?
Is there some fundamental thing about CPU's, cache layout, scheduling, 
benchmarks or something else that I just don't know that makes 5 the magic 
"right number"?  Why not 2, 3, 9 or 42?

2) Instead of writing that constant "5" multiple places, wouldn't it be 
nicer to use a  '#define FPU_RESTORE_TIMESLICES 5'  or  'static const 
unsigned int FPU_RESTORE_TIMESLICES = 5;'  instead?
Personally I hate magic numbers that are used in more than one location. 
I'd much rather have a constant with a sane name defined once (with a 
comment explaining it) and then see the name used in multiple places.


That's all.  :)


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

