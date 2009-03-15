Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbZCOKEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbZCOKEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZCOKEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:04:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36351 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZCOKEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:04:07 -0400
Date: Sun, 15 Mar 2009 11:03:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Kevin Shanahan <kmshanah@ucwb.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090315100329.GA23577@elte.hu>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera> <qm8_cedJGaP.A.-NH.CPCvJB@chimera> <1237107837.27699.27.camel@kulgan.wumi.org.au> <49BCC7C8.2020503@redhat.com> <20090315094807.GB21169@elte.hu> <49BCD0E9.9000305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BCD0E9.9000305@redhat.com>
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

> Ingo Molnar wrote:
>>> I've looked at the traces but lack the skill to make any sense out of 
>>> them.
>>>     
>>
>> Do you have specific questions about them that we could answer?
>>   
>
> A general question: what's going on?  I guess this will only 
> be answered by me getting my hands dirty and understanding how 
> ftrace works and how the output maps to what's happening.  
> I'll look at the docs for a while.
>
> A specific question for now is how can I identify long latency 
> within qemu here?  As far as I can tell all qemu latencies in 
> trace6.txt are sub 100ms, which, while long, don't explain the 
> guest stalling for many seconds.

Exactly - that in turn means that there's no scheduler latency 
on the host/native kernel side - in turn it must be a KVM 
related latency. (If there was any host side scheduler wakeup or 
other type of latency we'd see it in the trace.)

The most useful trace would be a specific set of trace_printk() 
calls (available on the latest tracing tree), coupled with a 
hyper_trace_printk() which injects a trace entry from the guest 
side into the host kernel trace buffer. (== that would mean a 
hypercall that does a trace_printk().)

	Ingo
