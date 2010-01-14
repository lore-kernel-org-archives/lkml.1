Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930Ab0ANPz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0ANPz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810Ab0ANPzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:55:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:57879 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab0ANPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:55:24 -0500
Message-ID: <4B4F3D1F.5000100@windriver.com>
Date: Thu, 14 Jan 2010 09:49:51 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next: manual merge of the tip tree with the kgdb tree
References: <20100114161302.285ebe27.sfr@canb.auug.org.au> <20100114092600.GA13503@elte.hu>  <4B4F31D4.1000707@windriver.com> <1263482452.28171.3853.camel@gandalf.stny.rr.com>
In-Reply-To: <1263482452.28171.3853.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2010 15:49:57.0201 (UTC) FILETIME=[38C76C10:01CA9531]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
>> Steven Rostedt wrote:
>>
>>     
>>>> On Tue, 2010-01-05 at 23:57 -0600, Jason Wessel wrote:
>>>>         
>>>   
>>>       
>>>>>> Here is another try at adding a dump function for kdb.  I had to
>>>>>> changes some of the static -> global scope in kernel/trace/trace.c in
>>>>>> order to be able to reference other semi-private via "trace.h".
>>>>>>             
>>>>     
>>>>
>>>> Actually, could you write access functions instead. If we make these
>>>> items global in scope, then others will just start accessing them
>>>> directly. I've had this issue before because others have tried to make
>>>> the global_trace visible by all. But that variable may disappear and
>>>> break all that use it.
>>>>
>>>>         
>>>   
>>>       
>> Thanks for the insight.
>>
>> Here is v3.
>>
>> I added a function called trace_init_global_iter().  I'll rename it if
>> you like.  I also changed the ftrace_dump() to make use of it as well
>> so we are more likely to see an issue when it changes if there are
>> more consumers of the function.
>>
>> The other question it brings up is if you want a helper function for
>> the atomic_inc / atomic_dec of the tracing cpus.  That would move that
>> for_each_tracing_cpu macro back into trace.c.
>>     
>
>
> I think the point Ingo is making, is that the changes to the
> kernel/trace directory would best go through the tip tree. This will
> ensure that this change does not have any undesirable effects to other
> parts of tracing that is being worked on.
>
> There's always an issue with having one subsystem depend on changes in
> another subsystem. What I did in the past when PPC needed changes to the
> trace directory, was that I made the changes in the trace code directly
> against Linus's tree in a separate branch. Then the two git repo's (PPC
> and tip) could pull that change in. Which ever one went first to Linus
> would get the required change without causing duplicates.
>
> But since this is the last patch in the series, perhaps it can just go
> directly into tip?
>
>   

It depends if you agree with the changes or not and if this patch is now
in a "ready for merge" state.

The patch is completely self contained and could be merged before or
after the kdb/kgdb change set.  If it is merged into tip or a sub
branch, I just need to know the location of preference.

Some of the kms changes have the same problem as this patch, and they
too might move outside the public kernel debugger git tree.

Thanks,
Jason.
