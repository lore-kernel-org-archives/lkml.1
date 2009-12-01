Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZLAQQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZLAQQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZLAQQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:16:24 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36384 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbZLAQQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:16:22 -0500
Message-ID: <4B15414A.9040405@us.ibm.com>
Date: Tue, 01 Dec 2009 08:16:10 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] Futex fault injection
References: <20091201141642.398e7b7d@sripathi> <20091201103351.GA6685@elte.hu> <1259664883.1697.28.camel@laptop> <20091201125537.GA23382@elte.hu>
In-Reply-To: <20091201125537.GA23382@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Tue, 2009-12-01 at 11:33 +0100, Ingo Molnar wrote:
>>> * Sripathi Kodi <sripathik@in.ibm.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> This patch set adds fault injection for futex subsystem. It adds 
>>>> faults at places where reading/writing from user space can return 
>>>> EFAULT. This will be useful in testing any significant change to futex 
>>>> subsystem.
>>> Instead of this unacceptably ugly and special-purpose debugfs 
>>> interface, please extend perf events to allow event injection. Some 
>>> other places in the kernel (which deal with rare events) want/need 
>>> this capability too.
>> Thing is, he's using the 'normal' fault injection code to do this, I 
>> see no objection to doing that.
> 
> Yes - but its impact to the futex code is butt-ugly. That some facility 
> is in the kernel does not mean it gets a free pass to be applied 
> everywhere and anywhere.

I don't think the "butt-ugly" argument is enough to reject the patch. 
It's a fairly subjective metric and I don't think the proposed solution 
results in "pretty" code either. In fact the super long function names 
and multi-line conditionals are arguably "ugly" (maybe not "butt-ugly" 
though). :-)

However, the arguments are solid and I understand wanting to introduce a 
new feature in a particular way. Has there been any work done on perf 
event injection up to this point or would this be a completely new perf 
feature?

--
Darren

> 
> An example of that would be tracepoints - there's no free pass to add 
> tracepoints in new places and some maintainers elect to use different 
> facilities. (or reject all current facilities)
> 
>> If you want to redo the fault injection subsystem, then that's another 
>> story, but then we need to convert all of its users over.
> 
> What i want to see is sane code in futex.c. If we add hooks/callbacks 
> i'd like it to be a complete solution helping a lot of usecases not some 
> limited approach helping testability only.
> 
> Thanks,
> 
> 	Ingo


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
