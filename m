Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZCOKOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZCOKOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZCOKON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:14:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45449 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbZCOKON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:14:13 -0400
Message-ID: <49BCD4C9.3050806@redhat.com>
Date: Sun, 15 Mar 2009 12:13:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Kevin Shanahan <kmshanah@ucwb.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera> <qm8_cedJGaP.A.-NH.CPCvJB@chimera> <1237107837.27699.27.camel@kulgan.wumi.org.au> <49BCC7C8.2020503@redhat.com> <20090315094807.GB21169@elte.hu> <49BCD0E9.9000305@redhat.com> <20090315100329.GA23577@elte.hu>
In-Reply-To: <20090315100329.GA23577@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> A specific question for now is how can I identify long latency 
>> within qemu here?  As far as I can tell all qemu latencies in 
>> trace6.txt are sub 100ms, which, while long, don't explain the 
>> guest stalling for many seconds.
>>     
>
> Exactly - that in turn means that there's no scheduler latency 
> on the host/native kernel side - in turn it must be a KVM 
> related latency. (If there was any host side scheduler wakeup or 
> other type of latency we'd see it in the trace.)
>   

But if there's a missing wakeup (which is the likeliest candidate for 
the bug) then we would have seen high latencies, no?

Can you explain what the patch in question (14800984706) does?  Maybe 
that will give us a clue.

> The most useful trace would be a specific set of trace_printk() 
> calls (available on the latest tracing tree), coupled with a 
> hyper_trace_printk() which injects a trace entry from the guest 
> side into the host kernel trace buffer. (== that would mean a 
> hypercall that does a trace_printk().)

Yes, that would provide all the information.  Not sure if I would be up 
to decoding it, though.

-- 
error compiling committee.c: too many arguments to function

