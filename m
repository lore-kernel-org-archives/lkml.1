Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYJWMxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYJWMxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYJWMxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:53:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59804 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753008AbYJWMxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:53:40 -0400
Message-ID: <49007410.8090700@sgi.com>
Date: Thu, 23 Oct 2008 05:54:40 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu>
In-Reply-To: <20081023120322.GC25132@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> [Resubmit: cleanup and rebase on latest tip/master.]
>>
>> Redesign cpumask API to explicitly declare struct cpumask pointers to 
>> the cpumask_* operators and add functions to make it easier to support 
>> struct cpumask pointers on the stack.
>>
>> This patchset supplies the infrastructure going forward to implement 
>> this new struct cpumask API.  Many more patches (currently 58) have 
>> been written and tested to verify the functionality of this API.  
>> These will be submitted as soon as they are thoroughly tested.
>>
>> Compiled and tested on x86_64.
>>
>> Based on tip/master @ v2.6.27-6973-ga90cd11
> 
> okay, i've picked up these patches into tip/cpus4096-v2 and started 
> testing them.
> 
Thanks!

> I fixed the From: line oddities - please holler if they are wrong 
> anywhere, we can still rebase this.

I found two of them and had resubmitted them, but perhaps that didn't take
either?

> 
> Note, i've merged this to _after_ the huge arch/x86/include/asm/ headers 
> move which we sent a pull request for earlier today - this will simplify 
> logistics.
> 
> ( I also fixed up a handful of obvious style problems in various places
>   - please be more careful about comment structure, whitespaces, etc. -
>   they just distract from general review and hurt the merits of your
>   patches. )

I ran all the patches through checkpatches, the only complaints were
about unavoidable items (like we had to use NR_CPUS or we had to introduce
two new typedefs).  Everything else was error and warning free...?

> 
> I also added "Impact:" lines to every commit - a one-line summary of the 
> expected outcome of the change. (Please double-check those impact lines 
> - if you see anything odd it means that i missed some detail in the 
> commit - that will need to be fixed if it happens.)

Ok, thanks!  I'll check them out.
> 
> I've just completed the first basic step of testing: i did 68 kernel 
> builds to test bisectability: all 34 commit point builds fine on both 
> 64-bit and 32-bit as well. (This took some time as almost every commit 
> touches cpumask.h, forcing a full kernel rebuild.)

Yes, my regression build for allyesconfig took about 11 hours.
> 
> 	Ingo

Thanks!
Mike

