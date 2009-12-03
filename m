Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZLCKtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZLCKtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZLCKtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:49:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49866 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516AbZLCKtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:49:14 -0500
Date: Thu, 3 Dec 2009 11:49:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: slightly shorten __ticket_spin_trylock() (v2)
Message-ID: <20091203104906.GC7628@elte.hu>
References: <4B179A6D0200007800023542@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B179A6D0200007800023542@vpn.id2.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> Since the callers generally expect a boolean value, there's no need to
> zero-extend the outcome of the comparison. It just requires that all
> of x86' trylock implementations have their return type changed
> accordingly.
> 
> Don't use bool for the return type though - this is being frowned on
> and presently doesn't work with the pv-ops patching macros.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> ---
>  arch/x86/include/asm/paravirt.h       |    4 ++--
>  arch/x86/include/asm/paravirt_types.h |    2 +-
>  arch/x86/include/asm/spinlock.h       |   12 +++++-------
>  arch/x86/xen/spinlock.c               |    2 +-
>  4 files changed, 9 insertions(+), 11 deletions(-)

Looks much cleaner - and should give us pretty much the same savings as 
the previous patch, right? (if not, do you have a size comparison?)

	Ingo
