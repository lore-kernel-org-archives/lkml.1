Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYINNSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYINNSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 09:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYINNSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 09:18:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbYINNSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 09:18:34 -0400
Date: Sun, 14 Sep 2008 15:18:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Raz <raziebe@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       carlos@strangeworlds.co.uk, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Paalanen <pq@iki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: Subject: [PATCH] linux-acpi: smp_alternatives sleeping in
	spinlock
Message-ID: <20080914131818.GA30643@elte.hu>
References: <5d96567b0809130652i7bc86cbfv6cdc103f595e1e11@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0809130652i7bc86cbfv6cdc103f595e1e11@mail.gmail.com>
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


* Raz <raziebe@gmail.com> wrote:

> From: Raz Ben Yehuda <raziebe@gmail.com>
> 
> When booting a kernel with PREEMPT_ENABLE and SLAB_DEBUG, unplugging a 
> processor results in BUG in slab.

could you please post that BUG? (and which version of the kernel you 
have tried, and exactly what you did to trigger this bug)

note that the conversion to a sleeping lock:

> -static DEFINE_SPINLOCK(smp_alt);
> +static __DECLARE_SEMAPHORE_GENERIC(smp_alt_lock, 1);

is already done correctly in the latest upstream kernel, see this 
commit:

 # 2f1dafe: x86: fix SMP alternatives: use mutex instead of spinlock

the better solution is to use a mutex, not a semaphore. This fix is part 
of the v2.6.26 kernel.

	Ingo
