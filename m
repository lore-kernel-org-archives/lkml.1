Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbZDRHf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbZDRHf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZDRHft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:35:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41566 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbZDRHft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:35:49 -0400
Date: Sat, 18 Apr 2009 09:35:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
Message-ID: <20090418073510.GI7678@elte.hu>
References: <1239979901.23397.4638.camel@laptop> <alpine.DEB.1.10.0904171100510.21575@qirst.com> <20090417153520.GA29968@elte.hu> <alpine.DEB.1.10.0904171142050.13734@qirst.com> <1239985426.23397.4757.camel@laptop> <20090417164918.GK8253@elte.hu> <alpine.DEB.1.10.0904171335490.28603@qirst.com> <1239991892.23397.4905.camel@laptop> <alpine.DEB.1.10.0904171410540.28536@qirst.com> <49E90F9D.5010308@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E90F9D.5010308@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Friesen <cfriesen@nortel.com> wrote:

> Christoph Lameter wrote:
>
>> The latencytest code simulates a busy processor (no system calls, all
>> memory is prefaulted). For some reasons Linux is increasingly taking time
>> away from such processes (that intentionally run uncontended on a
>> dedicated processor). This causes regressions so that current upstream is
>> not usable for these applications.
>>
>> It would be best for these applications if the processor would be 
>> left undisturbed. There is likely not much that the OS needs to 
>> do on a busy processor if there are no competing threads and if 
>> there is no I/O taking place.
>
> Peter/Ingo, could ftrace be used to determine where time is being 
> spent in the kernel with suitable accuracy?  (This may be a dumb 
> question, I haven't played with ftrace much.)

Yes, both ftrace and perfcounters can be used to directly trace or 
sample any overhead/delay - no matter how sporadic it might be.

> Given that we're talking about tens of usecs of duration, 
> statistical sampling may not work all that well.

Peter did rather convincing perfcounters profiles. Of course, if 
only maximum latencies are concerned, tracing works better. But 
mainline is pretty inadequate for that purpose anyway - there's a 
whole PREEMPT_RT world with many stories to tell there ;-)

	Ingo
