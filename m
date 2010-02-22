Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab0BVJMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 04:12:15 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:19355 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0BVJML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 04:12:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wh04ECg0RA/t155rympMaqTFD0wNWm60KvrrKtR4UOFVO8cXxUjeyKltjTmZ3aUSOI
         Sr9oK/pARJLIK/1tp7PxHn+nCT3PZHqpRCk+biINKlrVqLzFtIrDqRQDqfQO9SZ9/4DQ
         aRJrU8e2seT6GIjieRoMgewnqDNqruVUcAChM=
MIME-Version: 1.0
In-Reply-To: <1266829490.5609.0.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
	 <1266749023.5468.1.camel@jlt3.sipsolutions.net>
	 <7b6bb4a51002210255t5ceaeb84r1438461085446385@mail.gmail.com>
	 <7b6bb4a51002210312o2a1d070aneb54c107aeab6952@mail.gmail.com>
	 <1266750881.10419.1.camel@jlt3.sipsolutions.net>
	 <1266751349.10419.2.camel@jlt3.sipsolutions.net>
	 <2375c9f91002220034m1beec51co7385a1cdbbcce7d2@mail.gmail.com>
	 <1266829490.5609.0.camel@jlt3.sipsolutions.net>
Date: Mon, 22 Feb 2010 17:12:10 +0800
Message-ID: <2375c9f91002220112q351044a4ycf4ee7dc2630c16d@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 5:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-02-22 at 16:34 +0800, Américo Wang wrote:
>> On Sun, Feb 21, 2010 at 7:22 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Sun, 2010-02-21 at 12:14 +0100, Johannes Berg wrote:
>> >
>> >>         printk("got cpu\n");
>> >>         for_each_online_cpu(i) {
>> >>                 sm_work = per_cpu_ptr(stop_machine_work,
>> i);
>> >>                 INIT_WORK(sm_work, stop_cpu);
>> >>                 queue_work_on(i, stop_machine_wq, sm_work);
>> >>         }
>> >>         /* This will release the thread on our CPU. */
>> >>         put_cpu();
>> >>         printk("put cpu\n");
>> >
>> > As odd as that may be, it hangs in put_cpu() here.
>> >
>>
>> Hmm, does adding synchronize_sched() in _cpu_down() help?
>
> No luck.
>

Ok, thanks.

Since it hangs in put_cpu() which is just preempt_enable(), so I began
to suspect if we need a synchronize_sched(), or some barrier perhaps.
I am not sure at all.

Before other experts look at this, I think doing a bisect would be very
useful.

Again, thanks for your testing!
