Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbZJIHLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbZJIHLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbZJIHLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:11:51 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:53025 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbZJIHLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:11:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zwh2rM4KvmDL3icnid3auRZI4o/JwUUGUD+bApLC12FGgj13lJtj3T/qOakZmS8xHM
         JV6AGqi3V6I25+dRwGygvvB3u751NoZtuVTo4B6ye8UVbWOxi7hMT2GmrWtIDcmG57he
         rhDhPvl7ckPVBuqZ2FHlKzNCzfEcj0c8tbYmw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910090849400.9428@localhost.localdomain>
References: <a5b3ea7b0910082242s6ce8275dr7f962ce526e55cd2@mail.gmail.com>
	 <a5b3ea7b0910082250o659d4fd3l8f319fd6bde24f3d@mail.gmail.com>
	 <alpine.LFD.2.00.0910090849400.9428@localhost.localdomain>
Date: Fri, 9 Oct 2009 15:11:14 +0800
Message-ID: <a5b3ea7b0910090011k7558faf2p4de252875587291e@mail.gmail.com>
Subject: Re: the select system call's implementation may have some bug in 
	preempt kernel mode
From: wu Jianfeng <stormplayer@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, but that does not cause the task to be scheduled out for ever.

I don't know why ???
the process state is TASK_INTERRUPTIBLE, and was scheduled out.

if no one wake up it or any signals received, it will sleep for ever.
The process does't entered any file's wait queue at that point, so I
am sure no one will wake up it.

Am i right?


2009/10/9 Thomas Gleixner <tglx@linutronix.de>:
> On Fri, 9 Oct 2009, wu Jianfeng wrote:
>> A process may sleep for ever when he call select system call.
>> In detail, if the process was scheduled out just at the point it set
>> its state to TASK_INTERRUPTIBLE.
>>
>> The events that may cause the process to be scheduled out is(in
>> preempt kernel) :
>> 1) time interrupt and the process's time slice is exhausted.
>> 2) an interrupt accured, and wake up another process with high priority.
>
> Right, but that does not cause the task to be scheduled out for ever.
>
>>               set_current_state(TASK_INTERRUPTIBLE);   ######## here set the
>> interrupt to  TASK_INTERRUPTIBLE state
>>
>>                ########### if the process was schedued out here, it
>> will can never been waken up .
>>                ########### Because the process wasn't attached to any
>> file's waitqueue at this point yet
>
> When the task is scheduled out at that point, it is not
> deactivated. It is preempted, which means it stays on the run queue
> despite of the TASK_INTERRUPTIBLE state and is scheduled back in later
> on.
>
> Thanks,
>
>        tglx
>
