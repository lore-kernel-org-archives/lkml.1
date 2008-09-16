Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYIPRrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYIPRrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYIPRrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:47:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:60514 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbYIPRrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:47:41 -0400
Message-ID: <48CFF150.8070400@colorfullife.com>
Date: Tue, 16 Sep 2008 19:48:00 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <48CFE466.8010200@colorfullife.com> <20080916173012.GC6717@linux.vnet.ibm.com>
In-Reply-To: <20080916173012.GC6717@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>   
>> That means an O(NR_CPUS) loop with disabled local interrupts :-(
>> Is that correct?
>>     
>
> With the definition of "O()" being the worst-case execution time, yes.
> But this worst case could only happen when the system was mostly idle,
> in which case the added overhead should not be too horribly bad.
No: "was mostly running cpu_idle()". A cpu_idle() cpu could execute lots 
of irqs and softirqs.
So the worst case would be a system with 1 cpu/node for reserved for irq 
handling.
The "idle" cpu would be always in no_hz mode, even though it might be 
100% busy handling irqs.
The remaning cpus might be 100% busy handling user space.

And every quiescent state will end up in that O(NR_CPUS) loop.

--
    Manfred
