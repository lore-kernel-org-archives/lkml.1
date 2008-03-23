Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbYCWHcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbYCWHcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 03:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYCWHcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 03:32:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbYCWHcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 03:32:05 -0400
Message-ID: <47E60773.2040409@redhat.com>
Date: Sun, 23 Mar 2008 03:32:03 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about C language.
References: <38b2ab8a0803210846p2f9b92adr951fe7fa0444de63@mail.gmail.com> <47E60702.30302@redhat.com>
In-Reply-To: <47E60702.30302@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Francis Moreau wrote:
>> Hello,
>>
>> I know it's a bit out of topic but this is something I need to clarify 
>> for
>> writing a Linux driver... hope you don't mind.
>>
>> In my driver I have a global variable that controls a loop such as:
>>
>> int my_condition;
>>
>> void change_my_condition(int new)
>> {
>>     my_condition = new;
>> }
>>
>> int foo(void)
>> {
>>     /* irqs are disabled */
>>     my_condition = 1;
>>     do {
>>         ....
>>         local_irq_enable();
>>         cpu_sleep();
>>         local_irq_disable();
>>
>>    } while (my_condition);
>>
>> }
>>
>> This variable is modified by an interrupt handler define in another file
>> by using 'change_my_condition' function.
>>
>> By reading the ISO C99 specification, I _think_ that I needn't any
>> kind of barrier
>> or even use the volatile type qualifier for my_condition variable to 
>> make a true
>> access to 'my_condition' in the controlling expression of the while, 
>> but I'm not
>> sure.
>>
>> Coud anybody confirm ?
>>
>> Thanks,
> 
> Even volatile may be insufficient with some architecture/compiler 
> combinations.  You should use explicit barriers wherever you need them, 
> or Bad Things will happen.
> 
> -- Chris
> 

Oops, forgot to mention, you should use atomic_t, to avoid aliasing 
problems, and ALSO use explicit barriers wherever you need them.

-- Chris
