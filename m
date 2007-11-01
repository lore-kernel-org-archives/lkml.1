Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbXKAWbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbXKAWbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbXKAWbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:31:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17117 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXKAWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r1mokAS593LNyjFsnC3MUCvzWp9hJF4OOVCEuUCPWVGhV9/6BTSc+69jucVyKQGmSx0bS8VriDVQxKgKa4bqHXaGIyHUYoawFPhDbxG4EjPAlsvTpTU5niYSoLjkV+AmYtIXByb/f3PcVCEEe0a1IBHhXjBC5RkBa3EHyWRm8wM=
Message-ID: <86802c440711011531u5a8a4872r3b4c33e5fd0fd0c9@mail.gmail.com>
Date: Thu, 1 Nov 2007 15:31:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + x86-show-cpuinfo-only-for-online-cpus.patch added to -mm tree
Cc: mm-commits@vger.kernel.org, andreas.herrmann3@amd.com, gcosta@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, travis@sgi.com
In-Reply-To: <20071101193932.8A44D432BDC@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071101193932.8A44D432BDC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 1, 2007 12:39 PM,  <akpm@linux-foundation.org> wrote:
>
> The patch titled
>      x86: show cpuinfo only for online CPUs
> has been added to the -mm tree.  Its filename is
>      x86-show-cpuinfo-only-for-online-cpus.patch
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
>
> ------------------------------------------------------
> Subject: x86: show cpuinfo only for online CPUs
> From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
>
> Fix regressions introduced with 92cb7612aee39642d109b8d935ad265e602c0563.
>
> It can happen that cpuinfo is displayed for CPUs that are not online or
> even worse for CPUs not present at all. As an example, following was
> shown for a "second" CPU of a single core K8 variant:
>
>     processor       : 0
>     vendor_id       : unknown
>     cpu family      : 0
>     model           : 0
>     model name      : unknown
>     stepping        : 0
>     cache size      : 0 KB
>     fpu             : yes
>     fpu_exception   : yes
>     cpuid level     : 0
>     wp              : yes
>     flags           :
>     bogomips        : 0.00
>     clflush size    : 0
>     cache_alignment : 0
>     address sizes   : 0 bits physical, 0 bits virtual
>     power management:
>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> Cc: Glauber de Oliveira Costa <gcosta@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mike Travis <travis@sgi.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/x86/kernel/cpu/proc.c |    8 +++-----
>  arch/x86/kernel/setup_64.c |    8 +++-----
>  2 files changed, 6 insertions(+), 10 deletions(-)
>
...
> diff -puN arch/x86/kernel/setup_64.c~x86-show-cpuinfo-only-for-online-cpus arch/x86/kernel/setup_64.c
> --- a/arch/x86/kernel/setup_64.c~x86-show-cpuinfo-only-for-online-cpus
> +++ a/arch/x86/kernel/setup_64.c
> @@ -1131,8 +1131,6 @@ static int show_cpuinfo(struct seq_file
>
>
>  #ifdef CONFIG_SMP
> -       if (!cpu_online(c->cpu_index))
> -               return 0;
>         cpu = c->cpu_index;
>  #endif

wonder if could change

>       if (!cpu_online(c->cpu_index))
>               return 0;

==>

>       if (c->cpu_index >= NR_CPUS)
>               return 0;

and add another entry for every cpu
online : 1 when it is enabled
or online : 0 when it is disabled by /sys/devices/system/cpuX/online.

YH
