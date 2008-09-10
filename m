Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbYIJHAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbYIJHAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 03:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYIJHA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 03:00:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35521 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYIJHA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 03:00:29 -0400
Date: Wed, 10 Sep 2008 09:00:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: heukelum@fastmail.fm, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] i386: handle all exceptions with interrupts off
	initially
Message-ID: <20080910070014.GB31059@elte.hu>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm> <48C73EB8.8020405@zytor.com> <20080910055337.GA9765@elte.hu> <48C76243.5010206@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C76243.5010206@zytor.com>
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

> Ingo Molnar wrote:
>>
>> the entry paths here are really short (we enable irqs almost 
>> immediately) so it's a non-issue in terms of worst-case latencies.
>>
>>> In other words, it's not something we want to do "just because", but 
>>> to the extent that it provides real benefit, it makes sense.
>>
>> this is historically pretty fragile code so bringing the 32-bit and 
>> 64-bit variants more in line sounds like a good reason to me. For 
>> example we had various long-living irq state annotation bugs (the 
>> combination of kprobes and lockdep, etc.) that remained unfixed 
>> partly due to this assymetry.
>
> Agreed completely.  I certainly didn't mean to come across sounding 
> negative.

great - i'll check which topic this fits in best. I suspect it will get 
its own topic - but there could be interactions as traps*.c is a central 
(and hence popular) file - here are the currently pending changes in 
-tip:

db4b0f1: kmemcheck: implement REP MOVS/STOS emulation
48e2bd5: x86: coding style fixes to arch/x86/kernel/traps_64.c
c9c3ddd: x86_64: remove empty lines from stack traces/oopses
4df9e51: x86: coding style fixes to arch/x86/kernel/traps_64.c
b359e8a: x86, xsave: context switch support using xsave/xrstor
dc1e35c: x86, xsave: enable xsave/xrstor on cpus with xsave support
862849a: x86: add hooks for kmemcheck on x86_64
787ecfa: x86: add hooks for kmemcheck
afdb702: x86: __show_registers() and __show_regs() API unification
0d84b78: x86 NMI-safe INT3 and Page Fault

we'll see.

	Ingo
