Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZAaAkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZAaAkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbZAaAjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:39:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39077 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642AbZAaAjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:39:33 -0500
Date: Sat, 31 Jan 2009 01:39:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Martin Hicks <mort@sgi.com>, tglx@linutronix.de, mingo@redhat.com,
       heukelum@mailshack.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: push old stack address on irqstack for unwinder
Message-ID: <20090131003921.GA13709@elte.hu>
References: <20090130165053.GE7872@alcatraz.americas.sgi.com> <49838F39.6060603@zytor.com> <49839CC8.7060502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49839CC8.7060502@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> H. Peter Anvin wrote:
>> Martin Hicks wrote:
>>> Hi,
>>>
>>> KDB was using this information.  Could this be pushed towards 2.6.29  
>>> please?
>>>
>>> This re-adds the old stack pointer to the top of the irqstack to help
>>> with unwinding.  It was removed in commit  
>>> d99015b1abbad743aa049b439c1e1dede6d0fa49
>>> as part of the save_args out-of-line work.
>>>
>>
>> This bothers me... why should we add even a single instruction to what  
>> is arguably the single hottest path in the kernel to support an  
>> out-of-tree debugger, especially if kgdb (which is in-tree) doesn't 
>> need it?
>>
>> What does kgdb do differently (or is kgdb broken too)?
>>
>
> Thinking about it some more, I think this makes sense under
>
> #ifdef CONFIG_FRAME_POINTER
>
> ... since if we're not building with frame pointers, this is pretty  
> pointless, and if we are, we're adding these all over the place anyway.
>
> Does this work for you?  Let me know and I'll get it in if so.

Would be nice to have an #ifdef-less primitive for this - something like:

	pushq_frame %rbp

and a matching:

	popq_frame %rbp

for those cases that need it (this one doesnt as we dont pop out of the 
stack).

	Ingo
