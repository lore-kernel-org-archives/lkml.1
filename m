Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZKJJcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZKJJcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZKJJcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:32:04 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41878 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZKJJcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:32:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oxxfekaKFIYBmdx0fxvNNJ8dhfmW7VgzceS4EDnJJ4et6sASs6W3MsnNHIoVFOuWAP
         h/wsWhW0vsdMhSPwns4Ksap2Ws8la8Loe2GTvxuBBR2ZO5zluGVZbtFtgqHbD/12I01d
         Sj4CByutkSOabWf+jhdoqijeZLlY7KW1DTg0U=
Date: Tue, 10 Nov 2009 10:32:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/4] perf/core: Split up pinned and non pinned
	processing
Message-ID: <20091110093207.GA5255@nowhere>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com> <1257711206-12243-4-git-send-email-fweisbec@gmail.com> <20091110051141.GD7897@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110051141.GD7897@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 06:11:41AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Split up pinned and non-pinned events processing in two helpers
> > so that it's more flexible to handle them seperately.
> 
> > +static void
> > +__perf_event_sched_in_volatile(struct perf_event_context *ctx,
> > +			       struct perf_cpu_context *cpuctx, int cpu)
> 
> Small naming suggestion: 'volatile' is a C keyword and rarely used 
> outside of that context in the kernel, which makes this function name a 
> bit confusing.
> 
> So instead of pinned/volatile, a pinned/flexible naming would be more 
> readable, i.e. __perf_event_sched_in_flexible() or so.


Right, also that makes it consistent with the hw-breakpoint constraints
naming.

 
> Also, most of the static functions in kernel/perf_event.c could lose 
> their perf_event_ prefix - we already know it's a perf thing, right? 
> That will shorten quite a few function names there.
> 
> These functions would turn into __sched_in_pinned()/__sched_in_flexible().
> 
> Agreed?


Totally.

I'll prepare a new iteration, thanks!

