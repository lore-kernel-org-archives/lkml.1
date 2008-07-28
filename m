Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYG1Sd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYG1Sd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYG1SdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:33:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42197 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750870AbYG1SdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:33:17 -0400
Message-ID: <488E10E8.8070504@sgi.com>
Date: Mon, 28 Jul 2008 11:33:12 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hugh Dickins <hugh@veritas.com>, Jack Steiner <steiner@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86_64: Optimize percpu accesses
References: <20080725211117.586723000@polaris-admin.engr.sgi.com> <20080726123819.GC20713@elte.hu>
In-Reply-To: <20080726123819.GC20713@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> This patchset provides the following:
>>
>>   * x86_64: Cleanup setup_percpu by fixing some minor potential
>>     problems as well as add some debugging aids.
>>
>>   * x86_64: Rebase per cpu variables to zero
>>
>>     Rebase per cpu variables to zero in preparation for the following
>>     patch to fold the pda into the per cpu area.
>>
>>   * x86_64: Fold pda into per cpu area
>>
>>     Declare the pda as a per cpu variable. This will allow the per cpu
>>     variables to be accessible on the x86_64 using %gs as the base of
>>     the percpu areas for each cpu:
>>
>> 	%gs:per_cpu_xxxx
>>
>>   * x86_64: Reference zero-based percpu variables offset from gs
>>
>>     Actually implement the above operation for __get_cpu_var() and
>>     __put_cpu_var().  Since this is now a single instruction, we
>>     can remove the non-preemptible versions of x86_read_percpu()
>>     and x86_write_percpu().
>>
>> Note that the following changes are NOT in this patchset as the plan now
>> seems to be that the common (to x86) variables that are in the pda should
>> be made individual per cpu variables, leaving only the stack canary in place.
>>
>>   * x86_64: Replace cpu_pda ops with percpu ops
>>   * x86_64: Replace xxx_pda() operations with x86_xxx_percpu().
>>   * x86_64: Remove xxx_pda() operations
>>   * x86_64: Remove cpu_pda() macro
>>
>> Based on linux-2.6.tip/master.
> 
> i've added these patches to tip/x86/percpu-zerobased, but not yet merged 
> into tip/master. I've made it -git based - does this patchset have any 
> functional dependencies on other patches?
> 
> 	Ingo

I think the other patches have been in place for a while.  This was actually
patch 3 of about 20 that finalized with the CPU_ALLOC changes.  In my tree
the 2 prior to this one are:

	b3a0cb456d848e10b2f7b371ba05e44f1384520a
	Subject: Zero based percpu: Infrastructure to rebase the per cpu area to zero
	
	d3794979a8a80c222ce9d016a6dfc4bed36965d0
	Subject: x86: Extend percpu ops to 64 bit

Thanks,
Mike
