Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZHUR44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZHUR44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbZHUR4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:56:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754934AbZHUR4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:56:55 -0400
Date: Fri, 21 Aug 2009 10:48:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, catalin.marinas@arm.com,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com, fweisbec@gmail.com,
       stable@kernel.org, srostedt@redhat.com, tglx@linutronix.de
Subject: Re: [tip:tracing/urgent] tracing: Fix too large stack usage in
 do_one_initcall()
Message-Id: <20090821104820.60948082.akpm@linux-foundation.org>
In-Reply-To: <20090821111450.GA32037@elte.hu>
References: <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org>
	<20090821111450.GA32037@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 13:14:50 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> ...
>
> btw., it will just take two more features like kmemleak to trigger 
> hard to debug stack overflows again on 32-bit. We are right at the 
> edge and this situation is not really fixable in a reliable way 
> anymore.
> 
> So i think we should be more drastic and solve the real problem: we 
> should drop 4K stacks and 8K combo-stacks on 32-bit, and go 
> exclusively to 8K split stacks on 32-bit.

We seem to have overrun an 8k stack in
http://bugzilla.kernel.org/show_bug.cgi?id=14029

Do we have a max-stack-depth tracer widget btw?

> I.e. the stack size will be 'unified' too between 64-bit and 32-bit 
> to a certain degree: process stacks will be 8K on both 64-bit and 
> 32-bit x86, IRQ stacks will be separate. (on 64-bit we also have the 
> IST stacks for certain exceptions that further isolates things)
> 
> This will simplify the 32-bit situation quite a bit and removes a 
> contentious config option and makes the kernel more robust in 
> general. 8K combo stacks are not safe due to irq nesting and 4K 
> isolated stacks are not enough. 8K isolated stacks is the way to go.
> 
> Opinions?

I wouldn't lose any sleep over it.

I bet it would be sufficient to have 4k interrupt stacks though.

My main concern would be maintenance.  Over time we'll chew more and
more stack space and eventually we'll get into trouble again.  What
means do we have for holding the line at 8k, and even improving things?


