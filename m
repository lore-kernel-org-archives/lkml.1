Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZAWMgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZAWMgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 07:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZAWMgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 07:36:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:39933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbZAWMgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 07:36:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IXH2dGKDOUFFDUZZRyt9t/m7wf3LTX8RySutXdrL8hCo9/T1GoY9UMEGLS5xGUvMDt
         pb/bBMo2UqbS+Zu/Cn9c5oSBS5rL8J2hRexEEBX8rrYQ7uWEIBs1pIBraPInlCWDRI5g
         7rj0dQ01cA62cfFgmBG1XqZv0MHENNMm3k9zc=
MIME-Version: 1.0
In-Reply-To: <20090123110500.GA12684@redhat.com>
References: <20090117215110.GA3300@redhat.com>
	 <20090118023211.GA14539@redhat.com>
	 <20090120203131.GA20985@cmpxchg.org>
	 <20090121143602.GA16584@redhat.com>
	 <20090121213813.GB23270@cmpxchg.org>
	 <20090122202550.GA5726@redhat.com>
	 <b647ffbd0901221626o5e654682t147625fa3e19976f@mail.gmail.com>
	 <20090123004702.GA18362@redhat.com>
	 <b647ffbd0901230207u642e24cdg98700aa68ed1aa33@mail.gmail.com>
	 <20090123110500.GA12684@redhat.com>
Date: Fri, 23 Jan 2009 13:36:33 +0100
Message-ID: <b647ffbd0901230436x3408203bw10834d013beab16c@mail.gmail.com>
Subject: Re: [RFC v4] wait: prevent waiter starvation in __wait_on_bit_lock
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/23 Oleg Nesterov <oleg@redhat.com>:
> On 01/23, Dmitry Adamushko wrote:
>>
>> 2009/1/23 Oleg Nesterov <oleg@redhat.com>:
>> > On 01/23, Dmitry Adamushko wrote:
>> >>
>> >> In short, wq->lock is a sync. mechanism in this case. The scheme is as follows:
>> >>
>> >> our side:
>> >>
>> >> [ finish_wait() ]
>> >>
>> >> lock(wq->lock);
>> >
>> > But we can skip lock(wq->lock), afaics.
>> >
>> > Without rmb(), test_bit() can be re-ordered with list_empty_careful()
>> > in finish_wait() and even with __set_task_state(TASK_RUNNING).
>>
>> But taking into account the constraints of this special case, namely
>> (1), we can't skip lock(wq->lock).
>>
>> (1) "the next contender is us"
>>
>> In this particular situation, we are only interested in the case when
>> we were woken up by __wake_up_bit().
>
> Yes,
>
>> that means we are _on_ the 'wq' list when we do finish_wait() -> we do
>> take the 'wq->lock'.
>
> Hmm. No?
>
> We are doing exclusive wait, and we use autoremove_wake_function().
> If we were woken, we are removed from ->task_list.

Argh, right, somehow I've made wrong assumptions on the wake-up part :-/


>
> Oleg.
>

-- 
Best regards,
Dmitry Adamushko
