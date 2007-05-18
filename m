Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbXERPUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbXERPUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXERPUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:20:30 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:22143 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbXERPU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uQIlGUzIm9bpx11rSmLXLe6E0zOkMASkMhUuKyvTo9AMl6uATdYCBbuLwlrAkA5m6dEWUJtet0utVSBfyEF4LR/lFZW6QXmVlyOeN8rWwqMuB6lPRcsfKTHOP7GmF3FCxsah1FBvisi2IftrDr+Hdptj3OpEYtl/5VltZtfBxu4=
Message-ID: <fc94aae90705180820n5265c1e8rf80698f090308c34@mail.gmail.com>
Date: Fri, 18 May 2007 16:20:27 +0100
From: "Michael Lothian" <mike@fireburn.co.uk>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v13
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Con Kolivas" <kernel@kolivas.org>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070517174533.GA538@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070517174533.GA538@elte.hu>
X-Google-Sender-Auth: b8e537368e5f9ead
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just thought I'd let you know that CFS is working on the PS3


neutrino boot # dmesg
Using PS3 machine description
Page orders: linear mapping = 24, virtual = 12, io = 12
Starting Linux PPC64 #1 SMP Fri May 18 09:26:38 UTC 2007
-----------------------------------------------------
ppc64_pft_size                = 0x14
physicalMemorySize            = 0x8000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0x0000000000000000
htab_hash_mask                = 0x1fff
-----------------------------------------------------
Linux version 2.6.22-rc1-cfs-v13 (root@localhost) (gcc version 4.1.1
(Gentoo 4.1.1-r3)) #1 SMP Fri May 18 09:26:38 UTC 2007

It feels more responsive but I shall do more testing and see if there
are any real benefits

On 17/05/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> i'm pleased to announce release -v13 of the CFS scheduler patchset.
>
> The CFS patch against v2.6.22-rc1, v2.6.21.1 or v2.6.20.10 can be
> downloaded from the usual place:
>
>      http://people.redhat.com/mingo/cfs-scheduler/
>
> -v13 is a fixes-only release. It fixes a smaller accounting bug, so if
> you saw small lags during desktop use under certain workloads then
> please re-check that workload under -v13 too. It also tweaks SMP
> load-balancing a bit. (Note: the load-balancing artifact reported by
> Peter Williams is not a CFS-specific problem and he reproduced it in
> v2.6.21 too. Nevertheless -v13 should be less prone to such artifacts.)
>
> I know about no open CFS regression at the moment, so please re-test
> -v13 and if you still see any problem please re-report it. Thanks!
>
> Changes since -v12:
>
>  - small tweak: made the "fork flow" of reniced tasks zero-sum
>
>  - debugging update: /proc/<PID>/sched is now seqfile based and echoing
>    0 to it clears the maximum-tracking counters.
>
>  - more debugging counters
>
>  - small rounding fix to make the statistical average of rounding errors
>    zero
>
>  - scale both the runtime limit and the granularity on SMP too, and make
>    it dependent on HZ
>
>  - misc cleanups
>
> As usual, any sort of feedback, bugreport, fix and suggestion is more
> than welcome,
>
>         Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
