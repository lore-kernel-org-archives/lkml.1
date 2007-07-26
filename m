Return-Path: <linux-kernel-owner+w=401wt.eu-S1765458AbXGZPSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765458AbXGZPSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbXGZPRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:17:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757965AbXGZPRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:17:54 -0400
Message-ID: <46A8BAEC.9070507@redhat.com>
Date: Thu, 26 Jul 2007 12:17:00 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Organization: Red Hat Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ankita Garg <ankita@in.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       linux@bohmer.net, LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com>	<1184615557.2698.3.camel@laptopd505.fenrus.org>	<20070726072858.GC13061@in.ibm.com> <20070726133138.GA30559@Krystal> <y0mps2f1asz.fsf@ton.toronto.redhat.com>
In-Reply-To: <y0mps2f1asz.fsf@ton.toronto.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
>
>   
>> [...]
>> The problem is also in _stp_print_flush, not *only* in relay code:
>> void _stp_print_flush (void)
>> ...
>>                 spin_lock(&_stp_print_lock);
>>                 ...
>>                 spin_unlock(&_stp_print_lock);
>>
>> Those will turn into mutexes with -rt.
>>     
>
> Indeed, plus systemtap-generated locking code uses rwlocks,
> local_irq_save/restore or preempt_disable, in various places.  Could
> someone point to a place that spells out what would be more
> appropriate way of ensuring atomicity while being compatible with -rt?
>   

https://ols2006.108.redhat.com/2007/Reprints/rostedt-Reprint.pdf

And his slides too, haven't checked if they are already only at the OLS 
site.

- Arnaldo
