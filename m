Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbXCENDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbXCENDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933450AbXCENDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:03:09 -0500
Received: from il.qumranet.com ([82.166.9.18]:57162 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933449AbXCENDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:03:08 -0500
Message-ID: <45EC1472.3070208@qumranet.com>
Date: Mon, 05 Mar 2007 15:00:34 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu> <45EC0EB7.7080300@qumranet.com> <20070305124024.GA19338@elte.hu>
In-Reply-To: <20070305124024.GA19338@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>>> -#ifdef CONFIG_PARAVIRT
>>> -unsigned int __read_mostly vdso_enabled = 0;
>>> -#else
>>> unsigned int __read_mostly vdso_enabled = 1;
>>> -#endif
>>>       
>
>   
>> Can't paravirt patch the syscall instruction like it does the rest of 
>> the kernel?
>>     
>
> we want to keep the guest as simple and unmodified as possible. And all 
> this #ifdef jungle /will/ bite back. Especially if the change goes in 
> with zero explanation like it did:
>
>     [PATCH] paravirt: Disable vdso by default when CONFIG_PARAVIRT is enabled
>
>     They don't work together and this way even glibc still works.
>
> i rather want an experimental feature (CONFIG_PARAVIRT) broken on some 
> hypervisors for a bit than an entire body of guest OSs getting used to 
> the "you dont have to deal with this VDSO annoyance by default" quirk 
> forever ...
>   

Sure, I agree with this patch.  I'm talking about an alternate solution 
so Xen can work with the vdso instead of #ifdefing away the kernel.

> but yes, i agree that the hypervisor should have the ability to patch 
> the syscall instruction of both the hypervisor interface and of the VDSO 
> interface. But this wasnt implemented like that, and the #ifdef quirk 
> just /prevents/ a sane solution like that from ever getting done the 
> right way.
>   

Rusty, shouldn't this be a one-liner?  No need to involve the hypervisor 
here; the guest can s/syscall/int 80/ on its vdso page like it patches 
cli and its ilk.

-- 
error compiling committee.c: too many arguments to function

