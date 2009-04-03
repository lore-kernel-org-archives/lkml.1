Return-Path: <linux-kernel-owner+w=401wt.eu-S1763851AbZDCNlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763851AbZDCNlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759403AbZDCNkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:40:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39157 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbZDCNkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:40:51 -0400
Message-ID: <49D611BD.4000101@redhat.com>
Date: Fri, 03 Apr 2009 16:40:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu>	 <49D5F80B.7000305@redhat.com> <20090403121202.GI31399@elte.hu>	 <49D5FE42.5080100@redhat.com> <20090403122654.GA19451@elte.hu> <19f34abd0904030616v56d66a11u7ee6054502f2922@mail.gmail.com>
In-Reply-To: <19f34abd0904030616v56d66a11u7ee6054502f2922@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> For the record, kmemcheck requirements for an instruction decoder are these:
>
> For any instruction with memory operands, we need to know which are
> the operands (so for movl %eax, (%ebx) we need to combine the
> instruction with a struct pt_regs to get the actual address
> dereferenced, i.e. the contents of %ebx), and their sizes (for movzbl,
> the source operand is 8 bits, destination operand is 32 bits). For
> things like movsb, we need to be able to get both %esi and %edi.
>
>   

The kvm emulator does all of this.

> mmiotrace additionally needs to know what the actual values
> read/written were, for instructions that read/write to memory (again,
> combined with a struct pt_regs).
>   

And this.

> Maybe this doesn't really say much, since this is what a generic
> instruction decoder would be able to do anyway. But kmemcheck and
> mmiotrace both have very special-purpose decoders. I don't really know
> what other decoders look like, but what I would wish for is this: Some
> macros for iterating the operands, where each operand has a type (e.g.
> input (for reads), output (for writes), target (for jumps), immediate
> address, immediate value, etc.), a size (in bits), and a way to
> evaluate the operand. So eval(op, regs) for op=%eax, it will return
> regs->eax; for op=4(%eax), it will return regs->eax + 4; for op=4 it
> will return 4, etc.
>   

You can do something like this by executing the instruction and 
observing what memory is touches through the callbacks.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

