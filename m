Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbZFFJho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbZFFJho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZFFJhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:37:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:34591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbZFFJhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:37:36 -0400
Message-ID: <4A2A38B9.7030809@kernel.org>
Date: Sat, 06 Jun 2009 02:36:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <4A2A356B.6090102@redhat.com>
In-Reply-To: <4A2A356B.6090102@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Rusty Russell wrote:
>> On Fri, 5 Jun 2009 03:26:57 pm Yinghai Lu wrote:
>>  
>>> Rusty Russell wrote:
>>>    
>>>> On Fri, 5 Jun 2009 06:31:31 am Yinghai Lu wrote:
>>>>      
>>>>> avoid suprise when MAXSMP is enabled
>>>>>
>>>>> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
>>>>>         
>>>> I understand the temptation, but two questions arise:
>>>> 1) Shouldn't we actually audit to see if any of these are currently
>>>> problems,
>>>>       
>>> those are defined as static cpumask_var_t, and if MAXSMP is not used,
>>> they
>>> are cleared already
>>>     
>>
>> OK, here's what I've got in my tree.  Ingo, I think this should go in the
>> current -rc to avoid nasty bugs.
>>
>> BTW, the original alloc_cpumask_var did zero; that was dropped after
>> arguments
>> over efficiency and fitting with other interfaces, but I clearly had
>> the old
>> semantics in my head for a while.
>>
>>   
> 
> Using __GFP_ZERO is equivalent to using memset() instead of
> cpumask_clear().  It's better to call cpumask_clear() or provide an API
> to alloc+clear.
> 
> Further, what about the non-MAXSMP case:
> 
> 
>    static inline bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
>    {
>            return true;
>    }
> 
> 
> We explicity clear on MAXSMP and rely on static initialization for the
> non-MAXSMP, laying a neat trap for anyone who makes the variable
> non-static.  Let's be less subtle that that.

or have zalloc_cpumask_var() ?

YH
