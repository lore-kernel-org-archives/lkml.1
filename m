Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbZAWKEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbZAWKEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758381AbZAWKEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:04:42 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:18655 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbZAWKEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:04:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=in2tfzfMhfLZ3zsAfexsZBnj7nSKjZW7kOwTVLfsrHifhS5kNfO7p2ZfYWXWMzbnEq
         SW0uLJpEtvJjQYKc+6YNC/5Uii26FO/KD3GUjDqH6QX2oMQ7M1Yyku8thtm1vfLqd8eT
         CRmrfJyMg1jmx9Kk1iD5oli0AiBpiwhh6a2qM=
MIME-Version: 1.0
In-Reply-To: <20090123092306.GB29820@elte.hu>
References: <20090122083457.GC7438@elte.hu> <20090122195513.GA22146@google.com>
	 <1fe6c7900901221921m586b129dwf8c3446f897b57f0@mail.gmail.com>
	 <20090123092306.GB29820@elte.hu>
Date: Fri, 23 Jan 2009 11:04:39 +0100
Message-ID: <c62985530901230204i3880c3f8xbebdb6844f35addf@mail.gmail.com>
Subject: Re: [PATCH v3] softlockup: remove hung_task_check_count
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/23 Ingo Molnar <mingo@elte.hu>:
>
> * Mandeep Baines <msb@google.com> wrote:
>
>> On Thu, Jan 22, 2009 at 11:55 AM, Mandeep Singh Baines <msb@google.com> wrote:
>> >
>> > The unlock and lock could be removed and only compiled in if PREEMPT.
>> > If the number of tasks isn't bound, the lock might be held too long.
>> >
>>
>> This is incorrect. The adding the lock and unlock will not make the
>> system more pre-emptive. To be more pre-emptive you'd want to check
>> need_resched() as often as possible.
>>
>> > It would be kinda funny if hung_task caused a softlockup.
>> >
>>
>> Again. This is incorrect. Rescheduling if need_resched() will prevent
>> softlockup.
>>
>> Not sure what I was thinking this morning;)
>>
>> However, I am happy with the patch. To give writers a chance, the lock
>> should held for bounded time. Holding the lock in khungtask (which is
>> running at low scheduler priority) could potentially be delaying
>> important work. The longer the lock is held, the bigger the priority
>> inversion problem.
>
> not sure i like the whole idea of removing the max iterations check. In
> theory if there's a _ton_ of tasks, we could spend a lot of time looping
> there. So it always looked prudent to limit it somewhat.
>
>        Ingo
>

Which means we can loose several of them. Would it hurt to iterate as
much as possible along the task list,
keeping some care about writers starvation and latency?
BTW I thought about the slow work framework, but I can't retrieve
it....  But this thread has already a slow priority.

Would it be interesting to provide a way for rwlocks to know if there
is writer waiting for the lock?
