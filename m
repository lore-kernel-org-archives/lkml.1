Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbZCSRCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbZCSRCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZCSRCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:02:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbZCSRCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:02:04 -0400
Date: Thu, 19 Mar 2009 18:01:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] cpumask: remove cpumask allocation from idle_balance
Message-ID: <20090319170130.GA29683@elte.hu>
References: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com> <alpine.DEB.2.00.0903182225450.31583@gandalf.stny.rr.com> <200903191522.21045.rusty@rustcorp.com.au> <200903192310.52314.rusty@rustcorp.com.au> <20090319132426.GA27017@elte.hu> <20090319162942.GA21672@elte.hu> <49C278F2.1000600@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C278F2.1000600@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>   
>>>> This time for sure,
>>>>       
>>> not so sure:
>>>
>>> [    4.303068] =============================================================================
>>> [    4.303332] BUG idr_layer_cache: Redzone overwritten
>>> [    4.303332] -----------------------------------------------------------------------------
>>> [    4.303332] [    4.303332] INFO: 
>>> 0xffff88003f838958-0xffff88003f83895f. First byte 0xa1 instead of 
>>> 0xbb
>>> [    4.303332] INFO: Allocated in 0xffff88003f9b94b0 age=4294878587 cpu=2 pid=0
>>> [    4.303332] INFO: Freed in 0xffff88003f8389f0 age=18446744073709463001 cpu=4294967295 pid=0
>>> [    4.303332] INFO: Slab 0xffffe200015d5340 objects=13 used=10 fp=0xffff88003f838738 flags=0x40000000000020c3
>>> [    4.303332] INFO: Object 0xffff88003f838738 @offset=1848 fp=0x(null)
>>>     
>>
>> hm, i'm seeing this even with the cpus4096 bits removed.
>>
>> It _seems_ to trigger when i add these two commits:
>>
>>   71ff49d: x86: with the last user gone, remove set_pte_present
>>   b40c757: x86/32: no need to use set_pte_present in set_pte_vaddr
>>
>> but i'm not completely sure it's related, i tried a bisection and it  
>> showed heisenbug properties.
>>
>> Might have come from upstream, that saw some IDR changes recently.
>>   
>
> Seems very unlikely; those patches only touch 32-bit only code, 
> and this looks like a 64-bit crash.

yes - that's why i think it's a Heisenbug.

	Ingo
