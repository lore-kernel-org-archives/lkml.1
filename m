Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYFUGIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYFUGIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 02:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYFUGIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 02:08:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48756 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbYFUGIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 02:08:09 -0400
Date: Sat, 21 Jun 2008 08:06:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, benh@kernel.crashing.org,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
	abstraction
Message-ID: <20080621060635.GA26422@elte.hu>
References: <20080619115832.GM15228@elte.hu> <alpine.LFD.1.10.0806190928100.2907@woody.linux-foundation.org> <20080619164708.GA32190@elte.hu> <20080620101028.GA23664@elte.hu> <485BFFC4.3070902@goop.org> <alpine.LFD.1.10.0806201211560.3167@woody.linux-foundation.org> <20080620195620.GA20183@elte.hu> <alpine.LFD.1.10.0806201302350.3167@woody.linux-foundation.org> <485C1000.8020806@goop.org> <485C117E.8070706@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485C117E.8070706@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Jeremy Fitzhardinge wrote:
>> Linus Torvalds wrote:
>>   
>>> On Fri, 20 Jun 2008, Ingo Molnar wrote:
>>>       
>>>> okay - Jeremy, could you try the fix below? (or tip/master, i just  
>>>> pushed this out)
>>>>           
>>> Actually, don't try that one.
>>>
>>> It needs to be a _byte_ registers, so "ir" was wrong. You need "iq".
>>>       
>>
>> Doesn't work, unfortunately:
>> {standard input}:20511: Error: Incorrect register `%eax' used with `b'  
>> suffix
>>
>>         lock; orb %eax,1(%rdi)  # tmp64,
>>   
>
> This does work:
>
>                asm volatile(LOCK_PREFIX "orb %1,%0"
>                        : CONST_MASK_ADDR(nr, addr)
>                        : "iq" ((u8)CONST_MASK(nr))
>                        : "memory");
>
> (ie, explicitly casting the mask to u8)

ok, i've pushed out the fix with this.

	Ingo
