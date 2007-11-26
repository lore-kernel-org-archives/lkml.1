Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbXKZWBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbXKZWBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbXKZWBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:01:33 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37297 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXKZWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:01:32 -0500
Date: Mon, 26 Nov 2007 14:06:43 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_64: not set boot cpu in cpu_online_map at
	smp_prepare_boot_cpu
In-reply-to: <1196110666.6352.309.camel@bodhitayantram.eng.vmware.com>
To: Zachary Amsden <zach@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <474B4373.9060802@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <200711260038.41710.yinghai.lu@sun.com>
 <1196110666.6352.309.camel@bodhitayantram.eng.vmware.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On Mon, 2007-11-26 at 00:38 -0800, Yinghai Lu wrote:
>> [PATCH] x86_64: not set boot cpu in cpu_online_map at smp_prepare_boot_cpu
>>
>> in init/main.c boot_cpu_init() does that before
>>
>> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
>>
>> diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
>> index 500670c..966d124 100644
>> --- a/arch/x86/kernel/smpboot_64.c
>> +++ b/arch/x86/kernel/smpboot_64.c
>> @@ -912,7 +912,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>>  void __init smp_prepare_boot_cpu(void)
>>  {
>>  	int me = smp_processor_id();
>> -	cpu_set(me, cpu_online_map);
>> +	/* already set me in cpu_online_map in boot_cpu_init() */
>>  	cpu_set(me, cpu_callout_map);
>>  	per_cpu(cpu_state, me) = CPU_ONLINE;
>>  }
> 
> 
> This ordering can be tricky wrt CPU hotplug.  Are you sure you are not
> breaking CPU hotplug?  AFAIK, x86_64 has that right and the 32-bit code
> had it wrong.


CPU hot plug path will call smp_prepare_boot_cpu?
it is using __init instead of __cpuinit?

YH
