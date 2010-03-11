Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab0CKUqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:46:16 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55454 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab0CKUqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:46:15 -0500
Message-ID: <4B99568D.30608@linux.vnet.ibm.com>
Date: Thu, 11 Mar 2010 12:46:05 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic
 event names to "perf stat"
References: <4B8F1B58.5000702@linux.vnet.ibm.com> <4B8FFE55.5070008@linux.vnet.ibm.com> <20100311124608.GG31354@elte.hu> <4B993AAF.9050507@linux.vnet.ibm.com> <20100311191441.GA7593@elte.hu>
In-Reply-To: <20100311191441.GA7593@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/11/2010 11:14 AM, Ingo Molnar wrote:
>
> * Corey Ashford<cjashfor@linux.vnet.ibm.com>  wrote:
[snip]
>> I'm not sure how that would work.  The issue I am trying to solve
>> here is that Power arch chips have a large number of very
>> hardware-specific events that are not generalizable.  Many of these
>> events not only have names, but other user-configurable bits as well
>> that select or narrow the scope of which exact events are recorded.
>> This issue is dealt with nicely in libpfm4, as it has mechanisms for
>> parsing event names and attributes (aka modifiers or unit masks),
>> and then produces a usable config field for the perf_events_attr
>> struct.
>>
>> Should I take it from the above that you are completely against the
>> idea of using an external library for hardware-specific event and
>> attribute naming?
>
> Could you give a few relevant examples of events in question, and the kind of
> configurability/attributes they have on Power?

Here are a few examples for the Power A2 processor.  I've distorted the names 
because PMU architecture isn't publicly released yet.

PM_DE_PMC_9:hrd_mask=0xff:hrd=0x22:pma_mask=0x3fff:pma=0x1b2d:culling_mode=3
PM_EX_0x03:lane=2:vlane=1
PM_OWE_ENG_MAC_FULL:usu=3

Note that the attribute fields shown above are fitted into the config field of 
the perf_event_attr struct.

>
> Thanks,
>
> 	Ingo

Regards,

- Corey

