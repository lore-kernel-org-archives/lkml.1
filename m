Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0BVPfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:35:32 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:44789 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955Ab0BVPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:35:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABctgktGGOLY/2dsb2JhbACbC3S7ZIJNgh4EgxWCfQ
Date: Mon, 22 Feb 2010 10:35:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: ltt-dev@lists.casi.polymtl.ca, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: error: 'subbuf_idx' undeclared after enabling
	CONFIG_LTT_RELAY_LOCKED=y
Message-ID: <20100222153526.GA29856@Krystal>
References: <f5a7b3811002220601k3525f733jb046cfe3ee69963a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <f5a7b3811002220601k3525f733jb046cfe3ee69963a@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:31:51 up 67 days, 23:50,  5 users,  load average: 0.16, 0.14,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* naresh kamboju (naresh.kernel@gmail.com) wrote:
> Hi,
> 
> I have noticed below error after enabling CONFIG_LTT_RELAY_LOCKED=y

Hi Naresh,

A few LTTng versions after the one you are working on, I flagged
LTT_RELAY_LOCKED and LTT_RELAY_IRQOFF as "CONFIG_BROKEN", because I did
not want to go through the trouble of duplicating the changes I did to
the lockless ring buffer to the two other flavors. I recommend using the
lockless ring buffer anyway.

So I recommend that you simply do the same with your old LTTng version
and flag LTT_RELAY_LOCKED and LTT_RELAY_IRQOFF as "CONFIG_BROKEN", as I
don't see the point in spending time on these at the moment.

Thanks,

Mathieu

> 
>   CC      ltt/ltt-relay-locked.o
> In file included from ltt/ltt-relay-locked.c:56:
> ltt/ltt-relay-locked.h: In function 'ltt_check_deliver':
> ltt/ltt-relay-locked.h:167:  (first use in this function)
> ltt/ltt-relay-locked.h:167: error: (Each undeclared identifier is
> reported only once
> ltt/ltt-relay-locked.h:167: error: for each function it appears in.)
> 
> After my work around I have found error is caused from the
> lttng-relay-locked-writer-use-noref-flag.patch
> 
> Below patch will fix the compilation issues.
> Please review this patch.
> 
> ---
>  ltt/ltt-relay-locked.h |    2  1 +     1 -     0 !
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/ltt/ltt-relay-locked.h
> ===================================================================
> --- a/ltt/ltt-relay-locked.h
> +++ b/ltt/ltt-relay-locked.h
> @@ -164,7 +164,7 @@ static __inline__ void ltt_check_deliver
>                  */
>                 ltt_set_noref_flag(rchan, buf, idx);
>  #ifdef CONFIG_LTT_VMCORE
> -               ltt_buf->commit_seq[subbuf_idx] = commit_count;
> +               ltt_buf->commit_seq[idx] = commit_count;
>  #endif
>                 ltt_buf->wakeup_readers = 1;
>         }
> 
> For your information LTTng configuration. dotconfig
> 
> 
> CONFIG_LTT=y
> CONFIG_LTT_FILTER=m
> CONFIG_HAVE_LTT_DUMP_TABLES=y
> CONFIG_LTT_RELAY_ALLOC=y
> # CONFIG_LTT_RELAY_LOCKLESS is not set
> # CONFIG_LTT_RELAY_IRQOFF is not set
> CONFIG_LTT_RELAY_LOCKED=y
> CONFIG_LTT_SERIALIZE=y
> CONFIG_LTT_FAST_SERIALIZE=y
> CONFIG_LTT_TRACEPROBES=m
> CONFIG_LTT_TRACE_CONTROL=y
> CONFIG_LTT_TRACER=y
> CONFIG_LTT_ALIGNMENT=y
> CONFIG_LTT_CHECK_ARCH_EFFICIENT_UNALIGNED_ACCESS=y
> # CONFIG_LTT_DEBUG_EVENT_SIZE is not set
> CONFIG_LTT_USERSPACE_EVENT=m
> CONFIG_LTT_VMCORE=y
> CONFIG_LTT_STATEDUMP=m
> CONFIG_LTT_KPROBES=m
> 
> Please review the patch and provide your comments.
> 
> Kernel: 2.6.29-RT
> Lttng: 0.158
> ARCH: ARM
> 
> Best regards
> Naresh Kamboju
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
