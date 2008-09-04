Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYIDTlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYIDTlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbYIDTlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:41:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36456 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYIDTlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:41:45 -0400
Date: Thu, 4 Sep 2008 21:41:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: order functions in cpu/common.c and
	cpu/common_64.c
Message-ID: <20080904194127.GA2542@elte.hu>
References: <1220331936-15100-1-git-send-email-yhlu.kernel@gmail.com> <20080904191205.GC24990@elte.hu> <20080904193733.GA25136@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904193733.GA25136@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> hm, something in your patch series is early-crashing tip/master with 
> this config:
> 
>  http://redhat.com/~mingo/misc/config-Thu_Sep__4_21_23_20_CEST_2008.bad
> 
> the early-RIP is 0xffffffff804365b0:
> 
> ffffffff8043656a <proc_bus_pci_release>:
> 
> ffffffff804365b0:       be d0 00 00 00          mov    $0xd0,%esi
> ffffffff804365b5:       e8 ad 28 e7 ff          callq  ffffffff802a8e67 <kmem_cache_alloc>
> 
> fault 0xd, general protection fault. Given that it's an immediate 
> constant load, something really serious happened.

ah, that's _another_ -tip testbox that broke at the same time, with a 
different kernel image. The RIP that corresponds to this box is 
0xffffffff80420470:

ffffffff8042045b <strnlen>:
ffffffff8042045b:       55                      push   %rbp

ffffffff80420470:       80 38 00                cmpb   $0x0,(%rax)


which could be consistent with the printk messup ...

> i've pushed out the broken tree into tip/tmp.master.broken (havent 
> updated tip/master with the breakage). I've removed the broken printk 
> in kernel/resource.c that Andrew found, see commit 06e44f6af324 - so 
> that's not the cause.

i've double checked that 06e44f6af324 is applied. I'll bisect this.

	Ingo
