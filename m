Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbXCCIVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbXCCIVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 03:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXCCIVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 03:21:47 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:3806 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbXCCIVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 03:21:46 -0500
Message-ID: <45E93012.4000100@qumranet.com>
Date: Sat, 03 Mar 2007 10:21:38 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>,
       git@vger.kernel.org
Subject: Re: [patch] KVM: T60 resume fix
References: <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu> <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org> <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu> <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu>
In-Reply-To: <20070302102216.GA13575@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2007 08:21:45.0612 (UTC) FILETIME=[FB3A94C0:01C75D6C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Subject: [patch] KVM: T60 resume fix
> From: Ingo Molnar <mingo@elte.hu>
>
> my T60 laptop does not resume correctly due to KVM attempting to send an 
> IPI to a CPU that might be down (or not up yet). (Doing so also triggers 
> the send_IPI_mask_bitmask() warning in arch/i386/kernel/smp.c, line 
> 732.)
>
> with this fix applied my laptop does not hang during resume.
>
> [ KVM will have to disable/enable virtualization on the CPU itself that
>   goes down / comes up, not via an IPI sent from the requesting CPU. ]
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/kvm/kvm_main.c |    6 ------
>  1 file changed, 6 deletions(-)
>
> Index: linux/drivers/kvm/kvm_main.c
> ===================================================================
> --- linux.orig/drivers/kvm/kvm_main.c
> +++ linux/drivers/kvm/kvm_main.c
> @@ -2083,12 +2083,6 @@ static int kvm_cpu_hotplug(struct notifi
>  	case CPU_DEAD:
>  	case CPU_UP_CANCELED:
>  		decache_vcpus_on_cpu(cpu);
> -		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
> -					 NULL, 0, 1);
> -		break;
> -	case CPU_UP_PREPARE:
> -		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
> -					 NULL, 0, 1);
>  		break;
>  	}
>  	return NOTIFY_OK;
>   

That is already CPU_ONLINE in my tree (and in the pull request sent to 
Linus a couple of days ago).



-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

