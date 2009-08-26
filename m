Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbZHZQYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbZHZQYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZHZQYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:24:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:29361 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZHZQYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MZX6wpVxJLsa8ueN7qDa/b7MhDHlwGUrpyeGYQJ3ICTXvhyUyOzBT1mwjQavCC9WIP
         oNnGEpkXiaUeHBrgGN5DLepwJbAQTTbsQNkKL27VBsIu0nSS5Ca/kEhGlBu/Q+W33RX5
         wNLRRThcZitLkHyfBeltSKfFK8w7sGOpKAUDc=
Date: Wed, 26 Aug 2009 18:24:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, lethal@linux-sh.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, tglx@linutronix.de,
       hpa@zytor.com
Subject: Re: [PATCH 2/4] Add NR_syscalls for x86_64
Message-ID: <20090826162412.GA6759@nowhere>
References: <cover.1251146512.git.jbaron@redhat.com> <233dfaa6fadd5aa2fa7ac8511ed9ab98a5f2619c.1251146513.git.jbaron@redhat.com> <20090824221447.GA5124@nowhere> <alpine.DEB.2.00.0908241843450.32241@gandalf.stny.rr.com> <20090825134005.GB2656@redhat.com> <20090825184734.GE2656@redhat.com> <alpine.DEB.2.00.0908252223310.28127@gandalf.stny.rr.com> <20090826135854.GA2658@redhat.com> <alpine.DEB.2.00.0908261038250.23885@gandalf.stny.rr.com> <20090826160910.GB2658@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826160910.GB2658@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 12:09:10PM -0400, Jason Baron wrote:
> doesn't quite work, b/c the top of asm-offsets_64.c has a bunch of
> includes, such as:  <linux/sched.h>, which in turn include unistd.h at
> a point in time where asm/asm-offests.h does not exist.
> 
> However, a much simpler version of the previous patch I posted does do
> the trick, below. I hope this version is more palatable?
> 
> thanks,
> 
> -Jason
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>


Ah yeah, looks good!


> 
> diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
> index 900e161..b9f3c60 100644
> --- a/arch/x86/include/asm/unistd_64.h
> +++ b/arch/x86/include/asm/unistd_64.h
> @@ -688,6 +688,12 @@ __SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
>  #endif	/* __NO_STUBS */
>  
>  #ifdef __KERNEL__
> +
> +#ifndef COMPILE_OFFSETS
> +#include <asm/asm-offsets.h>
> +#define NR_syscalls (__NR_syscall_max + 1)
> +#endif
> +
>  /*
>   * "Conditional" syscalls
>   *
> diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
> index 898ecc4..4a6aeed 100644
> --- a/arch/x86/kernel/asm-offsets_64.c
> +++ b/arch/x86/kernel/asm-offsets_64.c
> @@ -3,6 +3,7 @@
>   * This code generates raw asm output which is post-processed to extract
>   * and format the required data.
>   */
> +#define COMPILE_OFFSETS
>  
>  #include <linux/crypto.h>
>  #include <linux/sched.h> 


