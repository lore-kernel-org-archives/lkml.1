Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbYJTHeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbYJTHeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYJTHem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:34:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYJTHem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:34:42 -0400
Date: Mon, 20 Oct 2008 09:34:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kmemcheck: (finally) use 4k pages for identity mapping
Message-ID: <20081020073428.GB20461@elte.hu>
References: <20081019172041.GA3258@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081019172041.GA3258@localhost.localdomain>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> >From 760932c8607b736504a134ed6feec25e90e089ac Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sun, 19 Oct 2008 15:28:04 +0200
> Subject: [PATCH] kmemcheck: (finally) use 4k pages for identity mapping
> 
> At last I found the right hooks for doing this properly. DEBUG_PAGEALLOC
> has the exact same requirement: Kernel pages must be mapped with 4k
> physical pages (since that's the size of pages returned by the page
> allocator).
> 
> Now we finally get rid of the need to do set_memory_4k() or try to work
> around TLB flushing from interrupt context. Yay!
> 
> Has been tested on both 32- and 64-bit on a P4 and a Dual Core.
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  arch/x86/kernel/cpu/common.c      |    7 -------
>  arch/x86/mm/init_32.c             |    2 +-
>  arch/x86/mm/init_64.c             |    2 +-
>  arch/x86/mm/kmemcheck/kmemcheck.c |    4 ----
>  mm/kmemcheck.c                    |    8 --------
>  5 files changed, 2 insertions(+), 21 deletions(-)

nice! Pulled into tip/kmemcheck-v2, thanks Vegard.

	Ingo
