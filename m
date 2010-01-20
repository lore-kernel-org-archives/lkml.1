Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551Ab0ATJoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab0ATJoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521Ab0ATJoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:44:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab0ATJoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:44:05 -0500
Message-ID: <4B56D027.3010808@redhat.com>
Date: Wed, 20 Jan 2010 11:43:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <1263740593.557.20967.camel@twins>	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>	 <4B545146.3080001@redhat.com>	 <20100118124419.GC1628@linux.vnet.ibm.com>	 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>	 <4B5459CA.9060603@redhat.com>  <4B545ACF.40203@cs.helsinki.fi>	 <1263852957.2266.38.camel@localhost.localdomain>	 <4B556855.6040800@redhat.com> <1263923265.4998.28.camel@localhost.localdomain>
In-Reply-To: <1263923265.4998.28.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 07:47 PM, Jim Keniston wrote:
>
>> This is still with a kernel entry, yes?
>>      
> Yes, this involves setting a breakpoint and trapping into the kernel
> when it's hit.  The 6-7x figure is with the current 2-trap approach
> (breakpoint, single-step).  Boosting could presumably make that more
> like 12-14x.
>    

A trap is IIRC ~1000 cycles, we can reduce this to ~50 (totally 
negligible from the executed code's point of view).

>> Do you have plans for a variant
>> that's completely in userspace?
>>      
> I don't know of any such plans, but I'd be interested to read more of
> your thoughts here.  As I understand it, you've suggested replacing the
> probed instruction with a jump into an instrumentation vma (the XOL
> area, or something similar).  Masami has demonstrated -- through his
> djprobes enhancement to kprobes -- that this can be done for many x86
> instructions.
>
> What does the code in the jumped-to vma do?

1. Write a trace entry into shared memory, trap into the kernel on overflow.
2. Trap if a condition is satisfied (fast watchpoint implementation).

> Is the instrumentation code
> that corresponds to the uprobe handlers encoded in an ad hoc .so?
>    

Looks like a good idea, but it doesn't matter much to me.

-- 
error compiling committee.c: too many arguments to function

