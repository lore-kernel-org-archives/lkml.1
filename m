Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab0BMXOz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 18:14:55 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58261 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0BMXOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 18:14:54 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>
	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 13 Feb 2010 15:14:45 -0800
In-Reply-To: <4B772A54.1000000@kernel.org> (Yinghai Lu's message of "Sat\, 13 Feb 2010 14\:40\:20 -0800")
Message-ID: <m16360ohi2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 02/13/2010 04:04 AM, Eric W. Biederman wrote:
>>>  
>>>  #ifdef CONFIG_X86_LOCAL_APIC
>>> Index: linux-2.6/arch/x86/lguest/boot.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/lguest/boot.c
>>> +++ linux-2.6/arch/x86/lguest/boot.c
>>> @@ -819,7 +819,7 @@ static void __init lguest_init_IRQ(void)
>>>  
>>>  	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
>>>  		/* Some systems map "vectors" to interrupts weirdly.  Not us! */
>>> -		__get_cpu_var(vector_irq)[i] = i - FIRST_EXTERNAL_VECTOR;
>>> +		__get_cpu_var(vector_desc)[i] = irq_to_desc(i - FIRST_EXTERNAL_VECTOR);
>>>  		if (i != SYSCALL_VECTOR)
>>>  			set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
>>>  	}
>> 
>> YH It appears that irq_to_desc_alloc_node has not been called yet
>> so the setting of vector_desc needs to move to lguest_setup_irq.
>
> lguest is using sparseirq?

Apparently.  The last commit in that region of code moved some of the
work (irq_to_desc_alloc_node) into lguest_setup_irq because kmalloc
would not work that early.

Certainly the long term direction is to figure out how to enable
sparseirq unconditionally on x86.

Eric
