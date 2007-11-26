Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbXKZUyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbXKZUyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbXKZUyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:54:12 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45929 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923AbXKZUyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:54:10 -0500
Subject: Re: [PATCH] x86_64: not set boot cpu in cpu_online_map at
	smp_prepare_boot_cpu
From: Zachary Amsden <zach@vmware.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200711260038.41710.yinghai.lu@sun.com>
References: <200711260038.41710.yinghai.lu@sun.com>
Content-Type: text/plain
Date: Mon, 26 Nov 2007 12:57:46 -0800
Message-Id: <1196110666.6352.309.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-26 at 00:38 -0800, Yinghai Lu wrote:
> [PATCH] x86_64: not set boot cpu in cpu_online_map at smp_prepare_boot_cpu
> 
> in init/main.c boot_cpu_init() does that before
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
> index 500670c..966d124 100644
> --- a/arch/x86/kernel/smpboot_64.c
> +++ b/arch/x86/kernel/smpboot_64.c
> @@ -912,7 +912,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>  void __init smp_prepare_boot_cpu(void)
>  {
>  	int me = smp_processor_id();
> -	cpu_set(me, cpu_online_map);
> +	/* already set me in cpu_online_map in boot_cpu_init() */
>  	cpu_set(me, cpu_callout_map);
>  	per_cpu(cpu_state, me) = CPU_ONLINE;
>  }


This ordering can be tricky wrt CPU hotplug.  Are you sure you are not
breaking CPU hotplug?  AFAIK, x86_64 has that right and the 32-bit code
had it wrong.

Zach

