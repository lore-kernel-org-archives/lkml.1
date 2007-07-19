Return-Path: <linux-kernel-owner+w=401wt.eu-S933276AbXGSUbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbXGSUbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbXGSUbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:31:12 -0400
Received: from gw.goop.org ([64.81.55.164]:53595 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260AbXGSUbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:31:11 -0400
Message-ID: <469FC9D4.5070604@goop.org>
Date: Thu, 19 Jul 2007 13:30:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, jbeulich@novell.com,
       "S. P. Prasanna" <prasanna@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: new text patching for review
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal>	<200707191546.08919.ak@suse.de> <20070719173502.GB12955@Krystal> <p73d4yow0ys.fsf@bingen.suse.de>
In-Reply-To: <p73d4yow0ys.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
>   
>> I see that IRQs are disabled in alternative_instructions(), but it does
>> not protect against NMIs, which could come at a very inappropriate
>> moment. MCE and SMIs would potentially cause the same kind of trouble.
>>
>> So unless you can guarantee that any code from NMI handler won't call
>> basic things such as get_cycles() (nor MCE, nor SMIs), you can't insure
>> it won't execute an illegal instruction. Also, the option of temporarily
>> disabling the NMI for the duration of the update simply adds unwanted
>> latency to the NMI handler which could be unacceptable in some setups.
>>     
>
> Ok it's a fair point.  But how would you address it ?
>
> Even if we IPIed the other CPUs NMIs or MCEs could still happen.
>
> BTW Jeremy, have you ever considered that problem with paravirt ops
> patching? 
>   

I remember Zach was thinking about it when he was thinking of making vmi
a kernel module, but I don't think we discussed it with respect to the
current patching mechanism.  Though he did discover that at one point
alternative_instructions() was being run with interrupts enabled, which
caused surprisingly few problems...

But, yeah, it seems like it could be a problem.

> - smp lock patching only ever changes a single byte (lock prefix) of
> a single instruction
> - kprobes only ever change a single byte
>
> For the immediate value patching it also cannot happen because
> you'll never modify multiple instructions and all immediate values
> can be changed atomically. 
>   

Are misaligned/cross-cache-line updates atomic?

    J
