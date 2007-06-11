Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbXFKTYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbXFKTYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXFKTYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:24:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:8456 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbXFKTYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:24:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="237917370"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch-mm 21/23] x86-64 block irq balancing for timer
Date: Mon, 11 Jun 2007 12:24:33 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F50101D663@scsmsx415.amr.corp.intel.com>
In-Reply-To: <1181492960.2809.1.camel@laptopd505.fenrus.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch-mm 21/23] x86-64 block irq balancing for timer
Thread-Index: AcerfLacDccDJpYyR+6c0IkTm12NjQAAJujg
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       "Chris Wright" <chrisw@sous-sol.org>
X-OriginalArrivalTime: 11 Jun 2007 19:24:34.0057 (UTC) FILETIME=[2460B790:01C7AC5E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This just makes x86_64 behave like i386 which sets the flag today.

With tick-broadcast, even though we handle timer tick happening
anywhere, it will be nice if timer always goes to CPU 0 and we then
broadcast to any other CPUs. This is not a must have patch from my
perspective. But, we should make i386 and x86_64 same. So, we need to
change either one.

Thanks,
Venki

>-----Original Message-----
>From: Arjan van de Ven [mailto:arjan@infradead.org] 
>Sent: Sunday, June 10, 2007 9:29 AM
>To: Thomas Gleixner
>Cc: LKML; Andrew Morton; Ingo Molnar; Andi Kleen; Pallipadi, 
>Venkatesh; Chris Wright
>Subject: Re: [patch-mm 21/23] x86-64 block irq balancing for timer
>
>this isn't needed actually.. the userspace irq balancer won't balance
>irq 0 anyway, and if the sysadmin has a REAL good reason to move this
>himself... then why shouldn't we let him?
>
>
>
>On Sun, 2007-06-10 at 09:44 +0000, Thomas Gleixner wrote:
>> plain text document attachment
>> (x86-64-clockevents-irq-balancing.patch)
>> From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
>> 
>> Disable irq balancing on IRQ0.
>> 
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Andi Kleen <ak@suse.de>
>> 
>> ---
>>  arch/x86_64/kernel/time.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> Index: linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c
>> ===================================================================
>> --- linux-2.6.22-rc4-mm.orig/arch/x86_64/kernel/time.c	
>2007-06-10 10:44:39.000000000 +0200
>> +++ linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c	
>2007-06-10 10:44:40.000000000 +0200
>> @@ -255,7 +255,7 @@ static unsigned int __init tsc_calibrate
>>  
>>  static struct irqaction irq0 = {
>>  	.handler	= timer_interrupt,
>> -	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
>> +	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | 
>IRQF_NOBALANCING,
>>  	.mask		= CPU_MASK_NONE,
>>  	.name		= "timer"
>>  };
>
>-- 
>if you want to mail me at work (you don't), use arjan (at) 
>linux.intel.com
>Test the interaction between Linux and your BIOS via 
>http://www.linuxfirmwarekit.org
>
