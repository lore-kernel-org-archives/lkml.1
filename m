Return-Path: <linux-kernel-owner+w=401wt.eu-S932747AbZJNKiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbZJNKiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 06:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932667AbZJNKiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 06:38:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562AbZJNKiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 06:38:04 -0400
Message-ID: <4AD5A9CC.4070907@redhat.com>
Date: Wed, 14 Oct 2009 19:37:00 +0900
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH RFC] sched: add notifier for process migration
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop>	 <4ACFBC98.4070701@goop.org> <1255158863.7866.25.camel@twins>	 <4AD04E50.7060001@redhat.com> <1255166662.7866.28.camel@twins>	 <4AD055B3.8070705@goop.org> <1255169528.7521.3.camel@laptop>	 <4AD4F02C.9060203@goop.org>  <20091014070508.GI784@elte.hu> <1255512370.8392.373.camel@twins>
In-Reply-To: <1255512370.8392.373.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2009 06:26 PM, Peter Zijlstra wrote:
>> We already have one event notifier there - look at the
>> perf_swcounter_event() callback. Why add a second one for essentially
>> the same thing?
>>
>> We should only put a single callback there - a tracepoint defined via
>> TRACE_EVENT() - and any secondary users can register a callback to the
>> tracepoint itself.
>>
>> There's many similar places in the kernel - with notifier chains and
>> also with a need to get tracepoints there. The fastest (and most
>> consistent) solution is to add just a single event callback facility.
>>      
> But that would basically mandate tracepoints to be always enabled, do we
> want to go there?
>
> I don't think the overhead of tracepoints is understood well enough,
> Jason you poked at that, do you have anything solid on that?
>
> Also, I can imagine the embedded people to not want that.
>
> I really like perf and tracepoints to not become co-dependent until
> tracepoint become mandatory for all configurations.
>    

It would be cleanest to have both pvclock and tracepoints select 
migration notifiers, defaulting to off.  Similarly both perf and kvm 
should use preemption notifiers (they do the same thing - switch 
per-task values into and out of cpu registers).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

