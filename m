Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZEKPl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZEKPl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZEKPlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:41:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35384 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbZEKPlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:41:14 -0400
Message-ID: <4A084701.1090900@redhat.com>
Date: Mon, 11 May 2009 18:40:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Roedel, Joerg" <Joerg.Roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu> <4A083539.407@redhat.com> <20090511143320.GE6175@elte.hu> <4A083B69.6010702@redhat.com> <20090511145903.GB737@elte.hu> <4A08405E.3070709@redhat.com> <20090511151823.GC9492@elte.hu> <4A084426.2080604@redhat.com> <6453C3CB8E2B3646B0D020C1126132730362094B@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C1126132730362094B@sausexmb4.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Langsdorf, Mark wrote:
>> The Linux spinlock is
>>
>>              "1:\t"
>>              "cmpl %0, %2\n\t"
>>              "je 2f\n\t"
>>              "rep ; nop\n\t"
>>              "movzwl %1, %2\n\t"
>>              /* don't need lfence here, because loads are in-order */
>>              "jmp 1b\n"
>>
>> 5 instructions, maybe 2-3 cycles, not counting any special rep nop 
>> overhead.  Mark, any idea what the spin time is?
>>     
>
> If I'm understanding the question right, the contested
> spin locks are being held for 5K to 10K iterations of PAUSE.
> So 10K to 30K cycles if your estimate of the spinlock
> cycle time is correct.  
>   

My estimate is not very reliable.  Can you measure this?

btw, I'd expect you'd get much more significant improvement on Windows.  
Booting 16-vcpu Windows 2008 x64 took forever on my dual core host, and 
my guess is spinlock contention.  Of course you'd need a working yield, 
as Ingo said schedule() does very little.

-- 
error compiling committee.c: too many arguments to function

