Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYL0LJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYL0LJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 06:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYL0LJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 06:09:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33994 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYL0LJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 06:09:28 -0500
Date: Sat, 27 Dec 2008 12:09:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH 2/3] x86-64: Unify x86_*_percpu() functions.
Message-ID: <20081227110909.GA15377@elte.hu>
References: <1230052506-5041-1-git-send-email-brgerst@gmail.com> <1230052506-5041-2-git-send-email-brgerst@gmail.com> <49560B87.8090407@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49560B87.8090407@goop.org>
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

> Brian Gerst wrote:
>> Merge the 32-bit and 64-bit versions of these functions.  Unlike 32-bit,
>> the segment base is the current cpu's PDA instead of the offset from the
>> original per-cpu area.  This is because GCC hardcodes the stackprotector
>> canary at %gs:40.  Since the assembler is incapable of relocating against
>> multiple symbols, the code ends up looking like:
>>
>> 	movq $per_cpu__var, reg
>> 	subq $per_cpu__pda, reg
>> 	movq %gs:(reg), reg
>>
>> This is still atomic since the offset is a constant (just calculated at
>> runtime) and not dependant on the cpu number.
>>   
>
> Yeah, it's a real pity we can't convince the linker to do this simple 
> computation as a single %gs:ADDR addressing mode.  On the other hand, if 
> the compiler can reuse the computation of %reg 2-3 times, then the 
> generated code could well end up being denser.

There's a nice project for linker hackers?

I'd like to see some kernel image size measurements done on x86 defconfig 
to see how much real impact this has on code density. Unless the impact is 
horribly unacceptable, removing ~200 lines of weird x86-specific APIs is a 
definitive plus.

	Ingo
