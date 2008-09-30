Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYI3MHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYI3MHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYI3MGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:06:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYI3MGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:06:52 -0400
Date: Tue, 30 Sep 2008 08:06:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/6] Unified trace buffer
In-Reply-To: <20080930094516.GA1276@elte.hu>
Message-ID: <alpine.DEB.1.10.0809300805140.30533@gandalf.stny.rr.com>
References: <20080930030236.230994826@goodmis.org> <20080930030652.100327014@goodmis.org> <20080930094516.GA1276@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +void ring_buffer_lock(struct ring_buffer *buffer, unsigned long *flags)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	int cpu;
> > +
> > +	local_irq_save(*flags);
> > +
> > +	for_each_buffer_cpu(buffer, cpu) {
> > +		cpu_buffer = buffer->buffers[cpu];
> > +		spin_lock(&cpu_buffer->lock);
> > +	}
> > +}
> 
> hm, that's rather unintelligent and needs to be fixed.

hm, why?  It is ordered locking based on the cpu value. This is exactly 
what ftrace did as well.  The unlock even goes backwards max_cpu to 0.

But version 2 of this code will drop both ring_buffer_lock and unlock, but 
that will come later.

-- Steve

