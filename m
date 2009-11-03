Return-Path: <linux-kernel-owner+w=401wt.eu-S1751650AbZKCPF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbZKCPF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZKCPF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:05:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZKCPF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:05:57 -0500
Message-ID: <4AF04644.1000502@redhat.com>
Date: Tue, 03 Nov 2009 10:03:32 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH]: use spin_lock_irqsave in try_one_irq()
References: <20091103134342.24414.82986.sendpatchset@prarit.bos.redhat.com> <2674af740911030658m76b702cfxb67723984286c4bb@mail.gmail.com>
In-Reply-To: <2674af740911030658m76b702cfxb67723984286c4bb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yong Zhang wrote:
>> This happens because the &desc->lock is taken with spin_lock_irqsave and
>> just a spin_lock.  In the try_one_irq(), this lock really should be a
>> spin_lock_irqsave().
>>
>>     
>
> Cc'ed Ingo and Thomas.
>
> The reason is that try_one_irq() is called both from hardirq context and softirq
> context. And by default the timer handler poll_all_shared_irqs() is
> called with irq enabled.
> Then the two usage will cause inconsistent.
>
> So I think the following patch is also workable to you.
>   

Ah, okay.  I will retest and get back to you ...

P.
