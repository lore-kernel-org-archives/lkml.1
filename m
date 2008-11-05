Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYKENB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYKENB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYKENBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:01:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYKENBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:01:20 -0500
Date: Wed, 5 Nov 2008 14:01:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: sys_sched_yield keeps locked irq before call of schedule()
Message-ID: <20081105130113.GB29548@elte.hu>
References: <c4e36d110811050457m36346fe1m63ffbb143f684637@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110811050457m36346fe1m63ffbb143f684637@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:

> Hi
> 
> With recent 2.6.28-rc3 kernel I've noticed that schedule() is 
> sometime being called with locked IRQ
> 
> Call Trace:
>  [<ffffffff81334592>] _spin_lock_irq+0x92/0xa0
>  [<ffffffff8133126b>] schedule+0x13b/0x4cb
>  [<ffffffff81013c10>] ? native_sched_clock+0x70/0xa0
>  [<ffffffff81040930>] ? sys_sched_yield+0x0/0x80
>  [<ffffffff810409a5>] sys_sched_yield+0x75/0x80
>  [<ffffffff8100c6bb>] system_call_fastpath+0x16/0x1b

is this some special warning you added? The stock kernel certainly 
does not emit this warning.

> Which is a result of the function sys_sched_yield() that calls 
> schedule() while it keeps irq.
> 
> Is it correct to call the function schedule() which 'usually' 
> expects irq being unlocked and do some 'lenghty' operations (i.e. 
> debug statistics) which do not need to keep irq locked for such a 
> long time?

the debug statistics are all fast and we disable interrupts straight 
away when entering the schedule().

	Ingo
