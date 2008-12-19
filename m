Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYLSXby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYLSXby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYLSXbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:31:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbYLSXbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:31:40 -0500
Date: Sat, 20 Dec 2008 00:31:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix lguest used_vectors breakage -v2
Message-ID: <20081219233115.GB17984@elte.hu>
References: <494B8790.4060801@kernel.org> <20081219222349.GA10954@elte.hu> <494C2D00.1060403@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494C2D00.1060403@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: fix lguest, clean up
> 
> 32-bit lguest used used_vectors to record vectors, but that model of
> allocating vectors changed and got broken, after we changed vector
> allocation to a per_cpu array.
> 
> Try enable that for 64bit, and the array is used for all vectors that
> are not managed by vector_irq per_cpu array.
> 
> Also kill system_vectors[], that is now a duplication of the
> used_vectors bitmap.
> 
> [ merged in cpus4096 due to io_apic.c cpumask changes. ]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> ---
>  arch/x86/include/asm/desc.h           |   10 ++++------
>  arch/x86/include/asm/irq.h            |    1 +
>  arch/x86/kernel/apic.c                |    2 --
>  arch/x86/kernel/io_apic.c             |    9 +++------
>  arch/x86/kernel/irqinit_32.c          |   16 +++++++++++++++-
>  arch/x86/kernel/irqinit_64.c          |   13 +++++++++++++
>  arch/x86/kernel/traps.c               |   12 +++++++-----
>  drivers/lguest/interrupts_and_traps.c |   13 +++++++++----
>  8 files changed, 52 insertions(+), 24 deletions(-)

applied, thanks Yinghai!

	Ingo
