Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbXCYM1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbXCYM1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXCYM1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:27:35 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4821 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbXCYM1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:27:34 -0400
Message-ID: <46066AAA.5050202@shadowen.org>
Date: Sun, 25 Mar 2007 13:27:22 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: debug rsdl 0.33
References: <20070319205623.299d0378.akpm@linux-foundation.org> <4603C7EC.6030906@shadowen.org> <200703240845.30484.kernel@kolivas.org> <200703241026.57143.kernel@kolivas.org>
In-Reply-To: <200703241026.57143.kernel@kolivas.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Saturday 24 March 2007 08:45, Con Kolivas wrote:
>> On Friday 23 March 2007 23:28, Andy Whitcroft wrote:
>>> Andy Whitcroft wrote:
>>>> Con Kolivas wrote:
>>>>> On Friday 23 March 2007 05:17, Andy Whitcroft wrote:
>>>>>> Ok, I have yet a third x86_64 machine is is blowing up with the
>>>>>> latest 2.6.21-rc4-mm1+hotfixes+rsdl-0.32 but working with
>>>>>> 2.6.21-rc4-mm1+hotfixes-RSDL.  I have results on various hotfix
>>>>>> levels so I have just fired off a set of tests across the affected
>>>>>> machines on that latest hotfix stack plus the RSDL backout and the
>>>>>> results should be in in the next hour or two.
>>>>>>
>>>>>> I think there is a strong correlation between RSDL and these hangs.
>>>>>> Any suggestions as to the next step.
>>>>> Found a nasty in requeue_task
>>>>> +	if (list_empty(old_array->queue + old_prio))
>>>>> +		__clear_bit(old_prio, p->array->prio_bitmap);
>>>>>
>>>>> see anything wrong there? I do :P
>>>>>
>>>>> I'll queue that up with the other changes pending and hopefully that
>>>>> will fix your bug.
>>>> Tests queued with your rdsl-0.33 patch (I am assuming its in there).
>>>> Will let you know how it looks.
>>> Hmmm, this is good for the original machine (as was 0.32) but not for
>>> either of the other two.  I am seeing panics as below on those two.
>> This machine seems most sensitive to it (first column):
>> elm3b6
>> amd64
>> newisys
>> 4cpu
>> config: amd64
>>
>> Can you throw this debugging patch at it please? The console output might
>> be very helpful. On top of sched-rsdl-0.33 thanks!
> 
> Better yet this one which checks the expired array as well and after 
> pull_task.
> 
> If anyone's getting a bug they think might be due to rsdl please try this (on 
> rsdl 0.33).

Ok, new round of tests across the sensitive machines with 0.33 plus the
above debug patch are in the queue.  Will let you know how they pan out.

The tests with -rc4 + 0.33 are also in.  Failing there also.  Both out
of __sched_text_start, so I'd guess the same cause and the schedular is
fingered.

-apw
