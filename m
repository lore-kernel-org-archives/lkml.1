Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYLHO3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYLHO3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYLHO32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:29:28 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60643 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751945AbYLHO31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:29:27 -0500
Message-ID: <493D2F4D.3090702@sgi.com>
Date: Mon, 08 Dec 2008 06:29:33 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Avi Kivity <avi@redhat.com>, kvm-devel <kvm@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kvm: use cpumask_var_t for cpus_hardware_enabled
References: <200812072125.45757.rusty@rustcorp.com.au> <200812081635.35166.rusty@rustcorp.com.au> <493CED04.6020209@redhat.com> <200812082220.42790.rusty@rustcorp.com.au>
In-Reply-To: <200812082220.42790.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 08 December 2008 20:16:44 Avi Kivity wrote:
>> Rusty Russell wrote:
>>>> This isn't on stack, so it isn't buying us anything.
>>>>     
>>> It's the CONFIG_NR_CPUS=4096 but nr_cpu_ids=4 case which we win using
>>> dynamic allocation.  Gotta love distribution kernels.
>>>
>>>   
>> What does it buy? 4096/8 = 512 bytes statically allocated?
> 
> It adds up, and 4096 seems to be only the start of the insanityH^H^Hfun.

The real win though is when cpumask_size represents the actual size of the
cpumask (based on # of possible cpus) instead of the pre-configured size
of NR_CPUS.  So for 99.9% of the systems (having 64 or fewer cpus), the
savings will be 504 bytes not allocated.

> 
>>> Not quite.  If !CONFIG_CPUMASK_OFFSTACK, cpumask_var_t == cpumask_t[1].
>>> Blame Linus :)
>>>   
>> Hm, is there a C trick which will error out when allocating something on 
>> the stack, but work when allocating statically?  I can think of 
>> something to do the reverse, but that doesn't help.
> 
> We also need to prevent assignment, eg:
> 
> 	*foo = *bar;
> 
> Because when we allocate them, we'll cut them to size.
> 
> Cheers,
> Rusty.

