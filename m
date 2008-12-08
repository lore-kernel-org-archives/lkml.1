Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbYLHJqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbYLHJqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYLHJqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:46:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39115 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYLHJqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:46:37 -0500
Message-ID: <493CED04.6020209@redhat.com>
Date: Mon, 08 Dec 2008 11:46:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 2/2] kvm: use cpumask_var_t for cpus_hardware_enabled
References: <200812072125.45757.rusty@rustcorp.com.au> <493BF206.4070007@redhat.com> <200812081635.35166.rusty@rustcorp.com.au>
In-Reply-To: <200812081635.35166.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> This isn't on stack, so it isn't buying us anything.
>>     
>
> It's the CONFIG_NR_CPUS=4096 but nr_cpu_ids=4 case which we win using
> dynamic allocation.  Gotta love distribution kernels.
>
>   

What does it buy? 4096/8 = 512 bytes statically allocated?

I understand passing things as pointers, but allocating everything 
dynamically is unCish.

>> Is the plan to drop cpumask_t?
>>     
>
> Yes.  And undefine 'struct cpumask' if CONFIG_CPUMASK_OFFSTACK.  That
> will stop assignment and on-stack declarations for all but the most
> determined.
>
>   
>> If so, we're penalizing non-stack users 
>> by forcing them to go through another pointer (and cacheline).
>>     
>
> Not quite.  If !CONFIG_CPUMASK_OFFSTACK, cpumask_var_t == cpumask_t[1].
> Blame Linus :)
>   

Hm, is there a C trick which will error out when allocating something on 
the stack, but work when allocating statically?  I can think of 
something to do the reverse, but that doesn't help.

Maybe a weak or visibility attribute?  These don't make sense on 
function locals.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

