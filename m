Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbZDAW61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbZDAW61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbZDAW6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:58:16 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45336 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbZDAW6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:58:15 -0400
Date: Wed, 1 Apr 2009 16:57:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, grundler@parisc-linux.org,
       takata@linux-m32r.org, benh@kernel.crashing.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, heiko.carstens@de.ibm.com,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the default percpu allocator
Message-ID: <20090401225754.GN8014@parisc-linux.org>
References: <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401223241.GA28168@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 12:32:41AM +0200, Ingo Molnar wrote:
> And free_percpu(NULL) does this:
> 
> void free_percpu(void *ptr)
> {
>         void *addr = __pcpu_ptr_to_addr(ptr);
>         struct pcpu_chunk *chunk;
>         unsigned long flags;
>         int off;
> 
>         if (!ptr)
>                 return;

Why don't we rewrite this as:

-	void *addr = __pcpu_ptr_to_addr(ptr);
+	void *addr;
...
	if (!ptr)
		return;
	addr = __pcpu_ptr_to_addr(ptr);

if kfree(NULL) is really that important, we should avoid doing this
extra work, not just rely on the variable being cache-hot.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
