Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbZAOTTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbZAOTTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 14:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZAOTT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 14:19:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:3262 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZAOTT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 14:19:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-gmailtapped-by:x-gmailtapped;
	b=kcFZXNw4pWPOVv9BG0TWpRrNxtIDSIalDaC/GAHP6DDZdH9zBTvxC4irxLOMwis0S
	DPGtwmUnMM5ECW+4zNBfQ==
Date: Thu, 15 Jan 2009 06:04:55 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, mbligh@google.com,
       thockin@google.com, akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] softlockup: detect bottom-half lockups
Message-ID: <20090115140454.GH4722@google.com>
References: <20090114070447.GA25222@google.com> <20090114080640.GA19116@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114080640.GA19116@elte.hu>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.25.146.75
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stumbled upon ftrace tracepoints while writing this patch. Should
make life a lot easier for debugging latency issues.

bhlockup should complement ftrace. Once you've found that there's a
problem, tracing can be a big help in debugging. But assertions are
nice for finding problems you didn't know exist.

Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mandeep Singh Baines <msb@google.com> wrote:
> 
> > The feature should be useful to real-time developers and developers of 
> > network and other high-performance drivers.
> 
> hm, did you know about the ftrace latency tracers:
> 
>  config IRQSOFF_TRACER
>          bool "Interrupts-off Latency Tracer"
> 
>  config PREEMPT_TRACER
>          bool "Preemption-off Latency Tracer"
> 
>  config SCHED_TRACER
>          bool "Scheduling Latency Tracer"
> 
> PREEMPT_TRACER would have shown you that softirqs-off section very nicely. 
> 
> (And if you also enable the function tracer then not just the latency 
> endpoint is shown, but also all the function calls that happened in the 
> critical section.)
> 
> 	Ingo
