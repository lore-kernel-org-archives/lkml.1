Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbYLHJt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbYLHJt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYLHJtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:49:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56177 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYLHJts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:49:48 -0500
Message-ID: <493CEDC5.1080004@redhat.com>
Date: Mon, 08 Dec 2008 11:49:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/2] kvm: use modern cpumask primitives, no cpumask_t
 on stack
References: <200812072125.14416.rusty@rustcorp.com.au> <493BF144.9080106@redhat.com> <493BF648.6060504@redhat.com> <200812081638.07526.rusty@rustcorp.com.au>
In-Reply-To: <200812081638.07526.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> Btw, for the general case, instead of forcing everyone to duplicate, how 
>> about:
>>
>> cpumask_var_t cpus;
>>
>> with_cpumask(cpus) {
>>    ... code to populate cpus
>>    smp_call_function_some(...);
>> } end_with_cpumask(cpus);
>>
>> Where with_cpumask() allocates cpus, and uses a mutex + static fallback 
>> on failure.
>>     
>
> I'd prefer not to hide deadlocks that way :(
>
> I'll re-battle with that code to neaten it.  There are only a few places
> which have these kind of issues.
>
>   

cpuvar_get_maybe_mutex_lock(...);
...
cpuvar_put_maybe_mutex_unlock(...);

?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

