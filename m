Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbZDHJ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbZDHJ4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762599AbZDHJ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:56:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37907 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026AbZDHJ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:56:32 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [6/28] x86: MCE: Add machine check exception count in /proc/interrupts
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
	<20090407150747.21C711D046E@basil.firstfloor.org>
	<49DC2F5D.1010401@jp.fujitsu.com>
Date: Wed, 08 Apr 2009 11:56:26 +0200
In-Reply-To: <49DC2F5D.1010401@jp.fujitsu.com> (Hidetoshi Seto's message of "Wed, 08 Apr 2009 14:00:13 +0900")
Message-ID: <87iqlfa2ph.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:

> Andi Kleen wrote:
>> @@ -96,6 +97,12 @@
>>  	seq_printf(p, "  Threshold APIC interrupts\n");
>>  # endif
>>  #endif
>> +#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
>> +	seq_printf(p, "%*s: ", prec, "MCE");
>> +	for_each_online_cpu(j)
>> +		seq_printf(p, "%10u ", per_cpu(mce_exception_count, j));
>> +	seq_printf(p, "  Machine check exceptions\n");
>> +#endif
>>  	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
>>  #if defined(CONFIG_X86_IO_APIC)
>>  	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
>
> How about unifying ifdefs?

I did it this way because these are only temporary until the 32bit<->64bit merge
patch goes in too. So next patch would be to change it to X86_NEW_MCE and
then when the old 32bit machine check code is finally dropped one or two
releases later to just X86_MCE

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
