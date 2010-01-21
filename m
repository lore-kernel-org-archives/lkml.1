Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581Ab0AUROr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0AUROr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948Ab0AUROr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:14:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46560 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab0AUROq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:14:46 -0500
Date: Thu, 21 Jan 2010 18:14:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: clean up rwsem type system
Message-ID: <20100121171437.GA16994@elte.hu>
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain>
 <4B4D1865.5000107@zytor.com>
 <alpine.LFD.2.00.1001121659220.17145@localhost.localdomain>
 <alpine.LFD.2.00.1001121708100.17145@localhost.localdomain>
 <alpine.LFD.2.00.1001121755220.17145@localhost.localdomain>
 <alpine.LFD.2.00.1001121810410.17145@localhost.localdomain>
 <4B4EC1A5.4010701@zytor.com>
 <20100117060517.GA26525@elte.hu>
 <alpine.LFD.2.00.1001171023440.13231@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001171023440.13231@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, 17 Jan 2010, Ingo Molnar wrote:
> > 
> > FYI, -tip testing found that these changes break the UML build:
> > 
> > kernel/built-in.o: In function `__up_read':
> > /home/mingo/tip/arch/x86/include/asm/rwsem.h:192: undefined reference to `call_rwsem_wake'
> > kernel/built-in.o: In function `__up_write':
> > /home/mingo/tip/arch/x86/include/asm/rwsem.h:210: undefined reference to `call_rwsem_wake'
> > kernel/built-in.o: In function `__downgrade_write':
> > /home/mingo/tip/arch/x86/include/asm/rwsem.h:228: undefined reference to `call_rwsem_downgrade_wake'
> > kernel/built-in.o: In function `__down_read':
> > /home/mingo/tip/arch/x86/include/asm/rwsem.h:112: undefined reference to `call_rwsem_down_read_failed'
> > kernel/built-in.o: In function `__down_write_nested':
> > /home/mingo/tip/arch/x86/include/asm/rwsem.h:154: undefined reference to `call_rwsem_down_write_failed'
> > collect2: ld returned 1 exit status
> 
> I think something like this should fix it.

That did the trick - thanks!

	Ingo
