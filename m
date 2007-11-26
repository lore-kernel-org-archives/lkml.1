Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbXKZWcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbXKZWcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbXKZWcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:32:48 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43444 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755543AbXKZWcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:32:48 -0500
Subject: Re: [PATCH] x86_64: not set boot cpu in cpu_online_map at
	smp_prepare_boot_cpu
From: Zachary Amsden <zach@vmware.com>
To: Yinghai.Lu@Sun.COM
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <474B4373.9060802@sun.com>
References: <200711260038.41710.yinghai.lu@sun.com>
	 <1196110666.6352.309.camel@bodhitayantram.eng.vmware.com>
	 <474B4373.9060802@sun.com>
Content-Type: text/plain
Date: Mon, 26 Nov 2007 14:36:24 -0800
Message-Id: <1196116584.6352.314.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-26 at 14:06 -0800, Yinghai Lu wrote:

> >> diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
> >> index 500670c..966d124 100644
> >> --- a/arch/x86/kernel/smpboot_64.c
> >> +++ b/arch/x86/kernel/smpboot_64.c
> >> @@ -912,7 +912,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> >>  void __init smp_prepare_boot_cpu(void)
> >>  {
> >>  	int me = smp_processor_id();
> >> -	cpu_set(me, cpu_online_map);
> >> +	/* already set me in cpu_online_map in boot_cpu_init() */
> >>  	cpu_set(me, cpu_callout_map);
> >>  	per_cpu(cpu_state, me) = CPU_ONLINE;
> >>  }
> > 
> > 
> > This ordering can be tricky wrt CPU hotplug.  Are you sure you are not
> > breaking CPU hotplug?  AFAIK, x86_64 has that right and the 32-bit code
> > had it wrong.
> 
> 
> CPU hot plug path will call smp_prepare_boot_cpu?
> it is using __init instead of __cpuinit?

No, but moving the place where cpu is moved into online map might break
hotplug.  In any case, I don't see anything wrong with your change now
that I look closer.

Zach

