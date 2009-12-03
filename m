Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbZLCIBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbZLCIBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZLCIBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:01:33 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:59172 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZLCIBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:01:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NqwsIa+xo+szBbr4OjqtdQyt9IrPQt+4LChGlA+rXtFAWNy+8l+tINXZDVdEL6WhHH
         4u3CjBtkQ2ZBzzIWe6F4GBD/HkJdPnIMjKQ8zRl+dJwOnIHeKUwIl49sIYTGtxRKUpC3
         +4hJOkfdnNjnBW/xC3kdgoI9VoDTARByZF+Hg=
MIME-Version: 1.0
In-Reply-To: <b647ffbd0912022357w640bea4embe42f2a83b54220d@mail.gmail.com>
References: <563a732e0912022249y1e831c6cv7f2d5d376b8a5f63@mail.gmail.com>
	 <b647ffbd0912022357w640bea4embe42f2a83b54220d@mail.gmail.com>
Date: Thu, 3 Dec 2009 16:01:38 +0800
Message-ID: <563a732e0912030001p11a9388o5efd836912e0cad9@mail.gmail.com>
Subject: Re: Should we use preempt_disable() in sleep_on_common()?
From: liu pf <kernelfans@gmail.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 3, 2009 at 3:57 PM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
> 2009/12/3 liu pf <kernelfans@gmail.com>:
>> Hi:
>>
>> I am puzzled with the following scenario. Could anyone enlighten me?
>>
>> Thanks
>> pfliu
>>
>>
>> static long __sched
>> sleep_on_common(wait_queue_head_t *q, int state, long timeout)
>> {
>>    unsigned long flags;
>>    wait_queue_t wait;
>>
>>    init_waitqueue_entry(&wait, current);
>>
>>    __set_current_state(state);
>>
>>    ==========>suppose that after task A  set state=TASK_INTERRUPTIBLE
>> , it is preempted by task B.
>>
>>    spin_lock_irqsave(&q->lock, flags);
>> ...............................................................
>> }
>>
>> asmlinkage void __sched schedule(void)
>> {
>> .......................................................................................................
>>    if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>>        if (unlikely(signal_pending_state(prev->state, prev)))
>>            prev->state = TASK_RUNNING;
>>        else
>>            deactivate_task(rq, prev, 1);
>>       =============>This will remove task A from rq, but there are no
>> wait queue referring to A, so we lose A.
>>        switch_count = &prev->nvcsw;
>>    }
>
> In this case, (preempt_count() & PREEMPT_ACTIVE) == 1(see
> preempt_schedule_irq() and other use-cases of PREEMPT_ACTIVE) so we
> don't  enter this block.
>
> i.e. a preempted task stays on its queue (with state != TASK_RUNNING
> but that doesn't really matter).
>
>
> -- Dmitry
>


Thank you very much
