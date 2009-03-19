Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbZCSQzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbZCSQzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZCSQzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:55:20 -0400
Received: from gw.goop.org ([64.81.55.164]:55786 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbZCSQzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:55:19 -0400
Message-ID: <49C278F2.1000600@goop.org>
Date: Thu, 19 Mar 2009 09:55:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] cpumask: remove cpumask allocation from idle_balance
References: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com> <alpine.DEB.2.00.0903182225450.31583@gandalf.stny.rr.com> <200903191522.21045.rusty@rustcorp.com.au> <200903192310.52314.rusty@rustcorp.com.au> <20090319132426.GA27017@elte.hu> <20090319162942.GA21672@elte.hu>
In-Reply-To: <20090319162942.GA21672@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>>> This time for sure,
>>>       
>> not so sure:
>>
>> [    4.303068] =============================================================================
>> [    4.303332] BUG idr_layer_cache: Redzone overwritten
>> [    4.303332] -----------------------------------------------------------------------------
>> [    4.303332] 
>> [    4.303332] INFO: 0xffff88003f838958-0xffff88003f83895f. First byte 0xa1 instead of 0xbb
>> [    4.303332] INFO: Allocated in 0xffff88003f9b94b0 age=4294878587 cpu=2 pid=0
>> [    4.303332] INFO: Freed in 0xffff88003f8389f0 age=18446744073709463001 cpu=4294967295 pid=0
>> [    4.303332] INFO: Slab 0xffffe200015d5340 objects=13 used=10 fp=0xffff88003f838738 flags=0x40000000000020c3
>> [    4.303332] INFO: Object 0xffff88003f838738 @offset=1848 fp=0x(null)
>>     
>
> hm, i'm seeing this even with the cpus4096 bits removed.
>
> It _seems_ to trigger when i add these two commits:
>
>   71ff49d: x86: with the last user gone, remove set_pte_present
>   b40c757: x86/32: no need to use set_pte_present in set_pte_vaddr
>
> but i'm not completely sure it's related, i tried a bisection and it 
> showed heisenbug properties.
>
> Might have come from upstream, that saw some IDR changes recently.
>   

Seems very unlikely; those patches only touch 32-bit only code, and this 
looks like a 64-bit crash.

    J
