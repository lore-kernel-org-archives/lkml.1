Return-Path: <linux-kernel-owner+w=401wt.eu-S1030417AbXDJWW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030417AbXDJWW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030383AbXDJWW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:22:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43920 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030417AbXDJWWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:22:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/2] Allow percpu variables to be page-aligned
References: <461BC4B8.40902@goop.org>
Date: Tue, 10 Apr 2007 16:22:12 -0600
In-Reply-To: <461BC4B8.40902@goop.org> (Jeremy Fitzhardinge's message of "Tue,
	10 Apr 2007 10:09:12 -0700")
Message-ID: <m16483yinf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Let's allow page-alignment in general for per-cpu data (wanted by Xen, and
> Ingo suggested KVM as well).
>
> Because larger alignments can use more room, we increase the max per-cpu
> memory to 64k rather than 32k: it's getting a little tight.

The second paragraph of the comment is dated.  You are not changing the per-cpu 
memory size at all now.

The code itself looks sane.

Although we should probably fail the module load if the requested alignment
is to great, but that is just picking nits, and is no worse than what we
do today.

Eric

> ===================================================================
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -346,10 +346,10 @@ static void *percpu_modalloc(unsigned lo
>  	unsigned int i;
>  	void *ptr;
>  
> -	if (align > SMP_CACHE_BYTES) {
> -		printk(KERN_WARNING "%s: per-cpu alignment %li > %i\n",
> -		       name, align, SMP_CACHE_BYTES);
> -		align = SMP_CACHE_BYTES;
> +	if (align > PAGE_SIZE) {
> +		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
> +		       name, align, PAGE_SIZE);
> +		align = PAGE_SIZE;
>  	}
>  
>  	ptr = __per_cpu_start;
