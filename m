Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYHWUPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYHWUPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYHWUPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:15:42 -0400
Received: from mga05.intel.com ([192.55.52.89]:47773 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753759AbYHWUPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:15:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,260,1217833200"; 
   d="scan'208";a="373120082"
Message-ID: <48B06FE6.8060404@linux.intel.com>
Date: Sat, 23 Aug 2008 13:15:34 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
>> The following bug entry is on the current list of known regressions
>> from 2.6.26.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11342
>> Subject		: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
>> Submitter	: Alan D. Brunelle <Alan.Brunelle@hp.com>
>> Date		: 2008-08-13 23:03 (11 days old)
>> References	: http://marc.info/?l=linux-kernel&m=121866876027629&w=4
>> Handled-By	: Andrew Morton <akpm@linux-foundation.org>
> 
> This one makes no sense. It's triggering a BUG_ON(in_interrupt()), but 
> then the call chain shows that there is no interrupt going on.
> 
> Also, the bisection is senseless - there's a trivial change wrt 
> "do_one_initcall()" that got merged, but everything else is trivial about 
> lguest and has nothing to do with the whole CPU-init thing. But if it was 
> that initcall one, then "git bisect" woul have pointed to it, not the 
> merge. And the merge itself had no conflicts or anything else going on..
> 
> The fact that it came and went later also implies that it's probably just 
> some timing-dependent thing or some subtle memory corruption, making the 
> bisection result even less likely to be exact.
> 
> But I'm adding Arjan and Rusty to the Cc, because that merge was takign 
> Rusty's branch, and the "do_one_initcall()" is Arjan's commit. Since 
> undoing that merge apparently does fix it, I'm wondering if something 
> there just does end up triggering the problem.
> 
> The do_one_commit() thing _is_ in the path of sys_init_module(), so it 
> _is_ at least somewhat relevant from an oops standpoint. 
> 
> One thing the "do_one_commit()" thing does is to put more pressure on the 
> stack due to that whole buffer for the printk's going on.

but it's 64 bit.. with 8Kb stack and separate irq stacks. I'd be surprised if we blow that this easily.
the trace is a tad long with a long ACPI call chain.

Wonder what gcc is in use?
(newer ones tend to be a ton better... but maybe Alex is using a really old one)
