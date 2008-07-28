Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbYG1Ruu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbYG1Ruu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYG1Run
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:50:43 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35230 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750838AbYG1Rum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:50:42 -0400
Message-ID: <488E06F0.4070404@sgi.com>
Date: Mon, 28 Jul 2008 10:50:40 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] cpus4096 fixes
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au>
In-Reply-To: <200807281042.12860.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 28 July 2008 06:15:26 Linus Torvalds wrote:
>> On Sun, 27 Jul 2008, Ingo Molnar wrote:
>>> Please pull the latest cpus4096-fixes git tree from:
>> No. Not without explanations.
>>
>> Quite frankly, this "fix" looks like a huge stinking pile of sh*t.
>>
>> I can't follow that thread on lkml.org (horrible web interface with
>> hard-to-follow threading), and I'm too lazy to bother to look in my lkml
>> email archives, but whoever said
>>
>>   "The simple version is just a static array of [NR_CPUS] cpumask_t's."
>>
>> and then implemented this piece of shit is a complete and utter moron.
> 
> How awesome, Linus is talking about me!
> 
> Your idea is clever, thanks.  This patch was a bandaid to save us from the 
> unbearably fugly "cpumask_of_cpu_ptr_declare(cpu_mask)".  I was going to rip 
> this code out as soon as possible, but with your trick we should keep it.
> 
> The 4k CPU patches have been sliding in without review up until now.  We need 
> a serious think about how to handle cpumask_t that doesn't fit on the stack.  
> 
> Hey, since Mike put his Signed-off-by above mine and didn't put a From line 
> when he took my patch, WFT am I taking responsibility? :)
> 
> Rusty.

Sorry, I didn't know that was the protocol.  And yes, the clever idea of
compacting the memory is a good one (wish I would have thought of it... ;-)
But, and it's a big but, if you really have 4096 cpus present (not NR_CPUS,
but nr_cpu_ids), then 2MB is pretty much chump change.

But I'll redo the patch again.  And look for more space saving areas.  As
for the goal of these patches, it was to lessen the impact as much as possible
on smaller systems so that the distros can set the default NR_CPUS=4096 in
their binary (validated, certified, licensable) kernels.  This is a huge
priority to our customers.  Please keep telling me where I'm going wrong at
this.

Thanks for the comments and feedback.
Mike
