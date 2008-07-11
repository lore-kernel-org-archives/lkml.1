Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYGKC3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYGKC3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 22:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYGKC3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 22:29:09 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35806 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751671AbYGKC3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 22:29:08 -0400
Message-ID: <4876C572.3070803@sgi.com>
Date: Thu, 10 Jul 2008 19:29:06 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
       andi@firstfloor.org, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 19/26] x64, x2apic/intr-remap: introcude self IPI to genapic
 routines
References: <20080710181634.764954000@linux-os.sc.intel.com>	<20080710182238.631011000@linux-os.sc.intel.com> <m1mykpfh56.fsf@frodo.ebiederm.org>
In-Reply-To: <m1mykpfh56.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> Index: tree-x86/include/asm-x86/hw_irq.h
>> ===================================================================
>> --- tree-x86.orig/include/asm-x86/hw_irq.h 2008-07-10 09:51:45.000000000 -0700
>> +++ tree-x86/include/asm-x86/hw_irq.h	2008-07-10 09:52:24.000000000 -0700
>> @@ -73,7 +73,9 @@
>>  #endif
>>  
>>  /* IPI functions */
>> +#ifdef CONFIG_X86_32
>>  extern void send_IPI_self(int vector);
>> +#endif
>>  extern void send_IPI(int dest, int vector);
> 
> Cute undoing unification.
> 
> Eric

On a similar subject I would really like to change the send_IPI_mask to pass a
pointer to the cpumask_t arg:

        void (*send_IPI_mask)(cpumask_t mask, int vector);


This bloats the stack by 512 bytes and seemingly is called by some fairly
nested routines.  Any opinions?

Thanks,
Mike
