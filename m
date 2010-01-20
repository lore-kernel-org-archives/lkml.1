Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087Ab0ATMXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0ATMXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942Ab0ATMXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:23:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0ATMXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:23:06 -0500
Message-ID: <4B56F588.2060109@redhat.com>
Date: Wed, 20 Jan 2010 14:22:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jim Keniston <jkenisto@us.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <1263740593.557.20967.camel@twins>	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>	 <4B545146.3080001@redhat.com>	 <20100118124419.GC1628@linux.vnet.ibm.com>	 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>	 <4B5459CA.9060603@redhat.com>  <4B545ACF.40203@cs.helsinki.fi>	 <1263852957.2266.38.camel@localhost.localdomain>	 <4B556855.6040800@redhat.com>	 <1263923265.4998.28.camel@localhost.localdomain>	 <4B56D027.3010808@redhat.com> <1263981472.4283.843.camel@laptop>
In-Reply-To: <1263981472.4283.843.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 11:57 AM, Peter Zijlstra wrote:
> On Wed, 2010-01-20 at 11:43 +0200, Avi Kivity wrote:
>    
>> 1. Write a trace entry into shared memory, trap into the kernel on overflow.
>> 2. Trap if a condition is satisfied (fast watchpoint implementation).
>>      
> So now you want to consume more of a process' address space to store
> trace data as well?

Yes.  I know I'm bad.

> Not to mention that that process could wreck the
> trace data rendering it utterly unreliable.
>    

It could, but it also might not.  Are we going to deny high performance 
tracing to users just because it doesn't work in all cases?

Note this applies to any kind of monitoring or debugging technology.  A 
process can be influenced by the debugger and render any debug info you 
get out of it unreliable.  One non-timing example is a process using a 
checksum of its text as an input to some algorithm.

-- 
error compiling committee.c: too many arguments to function

