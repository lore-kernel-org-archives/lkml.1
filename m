Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195Ab0A3SWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0A3SWC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:22:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836Ab0A3SWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:22:01 -0500
Received: from smtp-out.google.com ([216.239.33.17]:36709 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0A3SWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:22:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=QCOEkMfex50yG2SAVT1pheuLc2FasADYnaKCgWQicBZNSrmIGD6lQJnqf5kIZZDqP
	PArUe2F6xP2PyBUI2juxQ==
MIME-Version: 1.0
In-Reply-To: <1264841799.24455.66.camel@laptop>
References: <4b588464.1818d00a.4456.383b@mx.google.com>
	 <1264192074.4283.1602.camel@laptop>
	 <7c86c4471001250912l47aa53dfw2c056e3a4733271e@mail.gmail.com>
	 <1264440342.4283.1936.camel@laptop>
	 <7c86c4471001250948t2c1b06ebx2e70f30f45c81aad@mail.gmail.com>
	 <1264442381.4283.1944.camel@laptop>
	 <bd4cb8901001291508w421898c2u8e8e7de32b030e67@mail.gmail.com>
	 <1264841799.24455.66.camel@laptop>
Date: Sat, 30 Jan 2010 19:21:55 +0100
Message-ID: <bd4cb8901001301021r6bc2c720i2be574e9a7ccdb1c@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v6 
	incremental)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will resubmit a patch on Monday. Same thing for AMD NB events.


On Sat, Jan 30, 2010 at 9:56 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2010-01-30 at 00:08 +0100, Stephane Eranian wrote:
>> I think there is a problem with this following code:
>>
>> void hw_perf_enable(void)
>>                 for (i = 0; i < cpuc->n_events; i++) {
>>
>>                         event = cpuc->event_list[i];
>>                         hwc = &event->hw;
>>
>>                         if (hwc->idx == -1 || hwc->idx == cpuc->assign[i])
>>                                 continue;
>>
>> Here you are looking for events which are moving. I think the 2nd
>> part of the if is not good enough. It is not because hwc->idx is
>> identical to the assignment, that you can assume the event was
>> already there. It may have been there in the past, then scheduled
>> out and replaced at idx by another event. When it comes back,
>> it gets its spot back, but it needs to be reprogrammed.
>>
>> That is why in v6 incremental, I have added last_cpu, last_tag
>> to have a stronger checks and match_prev_assignment().
>>
>> Somehow it is missing in the series you've committed unless
>> I am missing something.
>
> Right, that went missing because I was assuming that was for the
> optimization of reducing to one loop. And since I didn't see that one
> loop version work I left that part out.
>
> (The risk of doing more than one thing in one patch)
>
> Still, shouldn't be hard to correct, I'll look at doing a patch for this
> on monday, unless you beat me to it :-)
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
