Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590Ab0A0Ign@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab0A0Ign (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953Ab0A0Igm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:36:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab0A0Igl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:36:41 -0500
Message-ID: <4B5FFADB.5090209@redhat.com>
Date: Wed, 27 Jan 2010 10:35:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>, ananth@in.ibm.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <20100118124419.GC1628@linux.vnet.ibm.com> <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com> <4B5459CA.9060603@redhat.com> <4B545ACF.40203@cs.helsinki.fi> <1263852957.2266.38.camel@localhost.localdomain> <4B556855.6040800@redhat.com> <1263923265.4998.28.camel@localhost.localdomain> <4B56D027.3010808@redhat.com> <1263981472.4283.843.camel@laptop> <4B56F588.2060109@redhat.com> <20100127082440.GA16640@elte.hu>
In-Reply-To: <20100127082440.GA16640@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 10:24 AM, Ingo Molnar wrote:
>
>
>>> Not to mention that that process could wreck the trace data rendering it
>>> utterly unreliable.
>>>        
>> It could, but it also might not.  Are we going to deny high performance
>> tracing to users just because it doesn't work in all cases?
>>      
> Tracing and monitoring is foremost about being able to trust the instrument,
> then about performance and usability. That's one of the big things about
> ftrace and perf.
>
> By proposing 'user space tracing' you are missing two big aspects:
>
>   - That self-contained, kernel-driven tracing can be replicated in user-space.
>     It cannot. Sharing and global state is much harder to maintain reliably,
>     but the bigger problem is that user-space can stomp on its own tracing
>     state and can make it unreliable. Tracing is often used to figure out bugs,
>     and tracers will be trusted less if they can stomp on themselves.
>
>   - That somehow it's much faster and that this edge matters. It isnt and it
>     doesnt matter. The few places that need very very fast tracing wont use any
>     of these facilities - it will use something specialized.
>
> So you are creating a solution for special cases that dont need it, and you
> are also ignoring prime qualities of a good tracing framework.
>    

I see it exactly the opposite.  Only a very small minority of cases will 
have such severe memory corruption that tracing will fall apart because 
of random writes to memory; especially on 64-bit where the address space 
is sparse.  On the other hand, knowing that the cost is a few dozen 
cycles rather than a thousand or so means that you can trace production 
servers running full loads without worrying about whether tracing will 
affect whatever it is you're trying to observe.

I'm not against slow reliable tracing, but we shouldn't ignore the need 
for speed.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

