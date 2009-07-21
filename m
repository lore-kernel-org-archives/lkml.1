Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZGUHL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZGUHL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZGUHL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:11:56 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:33219 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbZGUHLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JHp3cLUo+Jhy+OubIUx/W61BsX4ikqpwSjDwgcZ9AGWBMPjXU/f/5r4HpeuBc3ni9P
         x8Dm+NPXuQnh2jtY7GyPCi5hFF1q/7f2BtEjxZ4mqjhjY1zYyKUd+KZ8HtlfdmCS5Rft
         GMcYyCrN9krV8Q7ZDdc7pE+XFuPN5bdVqeOrg=
MIME-Version: 1.0
In-Reply-To: <1248111535.15751.9339.camel@twins>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
	 <1248111535.15751.9339.camel@twins>
Date: Tue, 21 Jul 2009 09:11:53 +0200
Message-ID: <c62985530907210011m786f8f24g3f0de7560312cf07@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware 
	breakpoints
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/20, Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Mon, 2009-07-20 at 13:08 -0400, Frederic Weisbecker wrote:
>> This adds the support for kernel hardware breakpoints in perfcounter.
>> It is added as a new type of software counter and can be defined by
>> using the counter number 5 and by passsing the address of the
>> breakpoint to set through the config attribute.
>
>
>> +void bp_perf_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
>> +{
>> +	unsigned long target = hw_breakpoint_addr(bp);
>> +
>> +	struct perf_sample_data data = {
>> +		.regs = regs,
>> +		.addr = instruction_pointer(regs),
>> +	};
>> +
>> +	do_perf_swcounter_event(PERF_TYPE_BREAKPOINT, target, 1, 0, &data);
>> +}
>
> .addr would be an associated data address, like for pagefaults and
> cache-misses have, its not the RIP of the faulting ins.

Ah ok, then I'll set the actual data memory address that is breakpointed.

Thanks.
