Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbZJ3Tz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbZJ3Tz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbZJ3Tzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:55:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbZJ3Tzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:55:55 -0400
Message-ID: <4AEB44B0.7020005@redhat.com>
Date: Fri, 30 Oct 2009 15:55:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       fweisbec@gmail.com
Subject: Re: [PATCH] kprobes: Sanitize struct kretprobe_instance allocations
References: <20091030135310.GA22230@in.ibm.com>
In-Reply-To: <20091030135310.GA22230@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> From: Ananth N Mavinakayanahalli<ananth@in.ibm.com>
>
> For as long as kretprobes have existed, we've allocated NR_CPUS
> instances of kretprobe_instance structures. With the default value of
> CONFIG_NR_CPUS increasing on certain architectures, we are potentially
> wasting kernel memory.
>
> See http://sourceware.org/bugzilla/show_bug.cgi?id=10839#c3 for more
> details.
>
> Use a saner num_possible_cpus() instead of NR_CPUS for allocation.
>
> Signed-off-by: Ananth N Mavinakayanahalli<ananth@in.ibm.com>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thanks!

> ---
>   kernel/kprobes.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.32-rc5/kernel/kprobes.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/kernel/kprobes.c
> +++ linux-2.6.32-rc5/kernel/kprobes.c
> @@ -1014,9 +1014,9 @@ int __kprobes register_kretprobe(struct
>   	/* Pre-allocate memory for max kretprobe instances */
>   	if (rp->maxactive<= 0) {
>   #ifdef CONFIG_PREEMPT
> -		rp->maxactive = max(10, 2 * NR_CPUS);
> +		rp->maxactive = max(10, 2 * num_possible_cpus());
>   #else
> -		rp->maxactive = NR_CPUS;
> +		rp->maxactive = num_possible_cpus();
>   #endif
>   	}
>   	spin_lock_init(&rp->lock);

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

