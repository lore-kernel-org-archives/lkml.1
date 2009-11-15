Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZKOIFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZKOIFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZKOIFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:05:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32910 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbZKOIFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:05:18 -0500
Date: Sun, 15 Nov 2009 09:05:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] cpu_early_init() breakage
Message-ID: <20091115080514.GA15432@elte.hu>
References: <1258202602.6380.3.camel@marge.simson.net>
 <1258203973.6380.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258203973.6380.8.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> Bah, missed quilt refresh after fixing my own typo :)
> 
> 0388423 typo caused loss of vendor data even with CONFIG_PROCESSOR_SELECT.
> 
> [    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
> [    0.000000] CPU: Your system may be unstable.
> [    0.044003] MCE: unknown CPU type - not enabling MCE support.
> ...
> [    0.437241] Brought up 4 CPUs
> [    0.440002] Total of 4 processors activated (19139.97 BogoMIPS).
> [    0.448021] CPU0 attaching sched-domain:
> [    0.448024]  domain 0: span 0-3 level MC
> [    0.448026]   groups: 0 1 2 3
> [    0.448031] CPU1 attaching sched-domain:
> [    0.448033]  domain 0: span 0-3 level MC
> [    0.448035]   groups: 1 2 3 0
> [    0.448039] CPU2 attaching sched-domain:
> [    0.448041]  domain 0: span 0-3 level MC
> [    0.448043]   groups: 2 3 0 1
> [    0.448047] CPU3 attaching sched-domain:
> [    0.448048]  domain 0: span 0-3 level MC
> [    0.448050]   groups: 3 0 1 2
> 
> x86: Fix typo in 0388423 "Minimise printk spew from per-vendor init code"
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Dave Jones <davej@redhat.com>
> LKML-Reference: <new-submission>
> 
> ---
>  arch/x86/kernel/cpu/common.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/cpu/common.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/common.c
> +++ linux-2.6/arch/x86/kernel/cpu/common.c
> @@ -651,11 +651,12 @@ static void __init early_identify_cpu(st
>  
>  void __init early_cpu_init(void)
>  {
> -#ifdef PROCESSOR_SELECT
>  	const struct cpu_dev *const *cdev;
>  	int count = 0;
>  
> +#ifdef CONFIG_PROCESSOR_SELECT
>  	printk(KERN_INFO "KERNEL supported cpus:\n");
> +#endif
>  	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
>  		const struct cpu_dev *cpudev = *cdev;
>  		unsigned int j;
> @@ -665,14 +666,15 @@ void __init early_cpu_init(void)
>  		cpu_devs[count] = cpudev;
>  		count++;
>  
> +#ifdef CONFIG_PROCESSOR_SELECT
>  		for (j = 0; j < 2; j++) {
>  			if (!cpudev->c_ident[j])
>  				continue;
>  			printk(KERN_INFO "  %s %s\n", cpudev->c_vendor,
>  				cpudev->c_ident[j]);
>  		}
> -	}
>  #endif

i did the same fix yesterday - could you check latest -tip whether it 
works for you too?

Thanks,

	Ingo
