Return-Path: <linux-kernel-owner+w=401wt.eu-S936885AbXJSTzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936885AbXJSTzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933618AbXJSTzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:55:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56783 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763953AbXJSTzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:55:41 -0400
Message-ID: <47190BB1.6080804@garzik.org>
Date: Fri, 19 Oct 2007 15:55:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Remove 'irq' argument from all irq handlers
References: <20071019075443.GA6407@havoc.gtf.org> <alpine.LFD.0.9999.0710191649120.22770@localhost.localdomain> <m1bqavgdbf.fsf@ebiederm.dsl.xmission.com> <20071019190721.GA1514@elte.hu> <m1wstigan8.fsf@ebiederm.dsl.xmission.com> <alpine.LFD.0.9999.0710192139590.22770@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710192139590.22770@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 19 Oct 2007, Eric W. Biederman wrote:
>> Ingo Molnar <mingo@elte.hu> writes:
>>
>>> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>
>>>>> thanks for doing this.
>>>> Yes.  keeping this alive is good.
>>>>
>>>> The practical question is how do we make this change without breaking 
>>>> the drivers that use their irq argument.
>>> the get_irq_regs() approach worked out really well. We should do a 
>>> get_irq_nr() and be done with it?
>> The problem are some drivers today pass in 0 for their irq number
>> to flag that they are calling the interrupt handler in a polling
>> mode (not from interrupt context?) so the same logic doesn't quite apply.
>>
>> Do what you suggest would likely break those drivers.
> 
> How many of them do we have ? This is a wilful abuse of the API, so
> its not a big damage if they break.

I would prefer to simply clean up the drivers such that 
get_irqfunc_irq() and set_irqfunc_irq() are not needed.

One of the many reasons why I'm explicitly not pushing it upstream yet :)

	Jeff



