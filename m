Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYK2T7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYK2T7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYK2T7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:59:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYK2T7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:59:23 -0500
Date: Sat, 29 Nov 2008 20:58:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, lguest@ozlabs.org,
       jeremy@xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64, i386: interrupt dispatch
	changes
Message-ID: <20081129195836.GA27836@elte.hu>
References: <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <1226243805.27361.1283784629@webmail.messagingengine.com> <49178E89.2000307@zytor.com> <492DC13F.8020009@redhat.com> <492DE3EF.8060507@zytor.com> <492E72D7.9060201@redhat.com> <20081128204809.GA17920@mailshack.com> <20081129154516.GA26579@mailshack.com> <49318871.8010501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49318871.8010501@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Alexander van Heukelum wrote:
>> I now did the benchmarks for the same -rc6 with hpa's 4-byte stubs
>> too. Same machine. It's significantly better than the other two
>> options in terms of speed. It takes about 7% less cpu to handle
>> the interrupts. (0.64% cpu instead of 0.69%.) I have to run now,
>> I'll let interpreting the histogram to someone else ;).
>>   
>
> This is noise. 0.05% cpu on a 1GHz machine servicing 1000 interrupt/sec 
> boils down to 500 cycles/interrupt.  These changes shouldn't amount to 
> so much (and I doubt you have 1000 interrupts/sec with a single disk)..
>
> I'm sorry, but the whole effort is misguided, in my opinion.  If you 
> want to optimize, try reducing the number of interrupts that occur 
> rather than saving a few cycles in the interrupt path.

the goal was not to optimize those workloads - the goal was to (try to) 
validate those irq trampoline changes / cleanups. We went with hpa's 
changes in the end which compresses the trampolines - that reduces the 
$icache footprint which is hard to measure but a very real concern on 
real workloads.

	Ingo
