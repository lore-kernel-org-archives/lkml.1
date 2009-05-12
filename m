Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZELLFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZELLFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZELLFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:05:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:32124 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZELLFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NvIzkfAqZJAx0VzmilSUmPShCqvt0B9fkEqlGGfv4zyMyEnZV3mkUqys4BoNDD3p5+
         h9/fVnf8af5K2H5T8KUZcB2KvKaxK7eolHoVCchodj6h+UWFtUNHTvNKwZ8udyRLg7Bv
         KHPb295uB0gckr7TJneHR1De83DXLE+cs9Yg0=
MIME-Version: 1.0
In-Reply-To: <20090512094210.GD32292@elte.hu>
References: <1242117459.31161.11.camel@centos51>
	 <1242119738.11251.322.camel@twins> <20090512094210.GD32292@elte.hu>
Date: Tue, 12 May 2009 20:05:06 +0900
Message-ID: <49b7c2350905120405w3591a92bj265dff000929a928@mail.gmail.com>
Subject: Re: [PATCH]sched: fix typo in sched-rt-group.txt file
From: GeunSik Lim <leemgs1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       tglx <tglx@linutronix.de>, williams <williams@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/12 Ingo Molnar <mingo@elte.hu>:
>
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> On Tue, 2009-05-12 at 17:37 +0900, GeunSik Lim wrote:
>> >
>> >
>> > Dear Ingo,
>> >
>> > I found typo about the range of static priority ( = realtime priority )
>> > in "./Documentation/scheduler/sched-rt-group.txt" file.
>> >
>> > If I don't understand static priority levels, Correct me.
>>
>> Right, that 'confusion' stems from the fact that our in-kernel priority
>> lists do consider all 140 priorities.
>>
>> The patch looks good though.
>>
>> > commit d6af702008117ca489a2f5476239d1688a517e98
>> > Author: GeunSik,Lim <leemgs1@gmail.com>
>> > Date:   Tue May 12 17:20:32 2009 +0900
>> >
>> >     sched: fix typo in sched-rt-group.txt file
>> >
>> >     Fix typo about static priority's range.
>> >      Kernel Space priority: 0   to 99   --> User Space RT priority 99 to 0
>> >      Kernel Space priority: 100 to 139  --> User Space nice -20 to 19
>> >
>> >     Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
>> >
>> > diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
>> > index 5ba4d3f..1537146 100644
>> > --- a/Documentation/scheduler/sched-rt-group.txt
>> > +++ b/Documentation/scheduler/sched-rt-group.txt
>> > @@ -169,7 +169,7 @@ get their allocated time.
>> >
>> >  Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
>> >  the biggest challenge as the current linux PI infrastructure is geared towards
>> > -the limited static priority levels 0-139. With deadline scheduling you need to
>> > +the limited static priority levels 0-99. With deadline scheduling you need to
>
> SCHED_FIFO goes from 1 to 99. So it's either 0-98 or 1-99. From
> sched_setscheduler(2):
>
>       Processes scheduled under one of  the  real-time  policies  (SCHED_FIFO,
>       SCHED_RR) have a sched_priority value in the range 1 (low) to 99 (high).
>
>        Ingo
>

Thank you for explanation about userspace rt priority's range like
sched_setscheduler(2).

Processes scheduled with SCHED_OTHER (or SCHED_BATCH) must be assigned
the static priority 0.  Processes scheduled under SCHED_FIFO (or
SCHED_RR) can have a static priority in the range 1 to 99.

So, I think that the below summary is right.
* Kernel Space priority: 0(high) to 99(low) --> User Space RT priority
99(high) to 0(low)

Is it incorrect?


-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
