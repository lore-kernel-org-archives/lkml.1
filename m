Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbZATMif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbZATMif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZATMiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:38:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42313 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbZATMiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:38:24 -0500
Message-ID: <4975C586.8090605@redhat.com>
Date: Tue, 20 Jan 2009 14:37:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Kevin Shanahan <kmshanah@ucwb.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kevin Shanahan <kmshanah@flexo.wumi.org.au>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera> <1232410363.4768.21.camel@kulgan.wumi.org.au> <20090120113546.GA26571@elte.hu>
In-Reply-To: <20090120113546.GA26571@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kevin Shanahan <kmshanah@ucwb.org.au> wrote:
>
>   
>> On Mon, 2009-01-19 at 22:45 +0100, Rafael J. Wysocki wrote:
>>     
>>> This message has been generated automatically as a part of a report
>>> of regressions introduced between 2.6.27 and 2.6.28.
>>>
>>> The following bug entry is on the current list of known regressions
>>> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
>>> be listed and let me know (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
>>> Subject		: KVM guests stalling on 2.6.28 (bisected)
>>> Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
>>> Date		: 2009-01-17 03:37 (3 days old)
>>>       
>> Yes, please keep this on the list.
>>     
>
> This only seems to occur under KVM, right? I.e. you tested it with -no-kvm 
> and the problem went away, correct?
>
> This suggests some sort of KVM-specific problem. Scheduler latencies in 
> the seconds that occur under normal load situations are noticed and 
> reported quickly - and there are no such open regressions currently.
>
>   

Not necessarily.  -no-kvm runs with only one thread, compared to kvm 
that runs with 1 + nr_cpus threads.

> Avi, can you reproduce these latencies? 

No.

> A possibly theory would be some 
> sort of guest wakeup problem/race triggered by a shift in 
> preemption/scheduling patterns. Or something related to preempt-notifiers 
> (which KVM is using). A genuine scheduler bug is in the cards too, but the 
> KVM-only angle of this bug gives it a low probability.
>   

Can we trace task wakeups somehow? (latency between wakeup and actually 
running).

-- 
error compiling committee.c: too many arguments to function

