Return-Path: <linux-kernel-owner+w=401wt.eu-S1763421AbZFLL37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763421AbZFLL37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760190AbZFLL3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:29:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752AbZFLL3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:29:40 -0400
Date: Fri, 12 Jun 2009 13:29:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/paravirt: clean up paravirt.h and optimise FPU
	context switch
Message-ID: <20090612112933.GA14930@elte.hu>
References: <1244748040-27185-1-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244748040-27185-1-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> This series:
>  - splits asm/paravirt.h into paravirt.h and paravirt_types.h
>  - splits out the context switch core of math_state_restore into __math_state_restore
>  - rearranges 32 and 64 bit context switch to be the same and to properly
>    batch FPU context switches when running paravirtualized
> 
> There should be no performance side-effects of these changes.  They amount
> to a small rearrangement of the existing code (and bringing the 64-bit
> code a bit closer to 32-bit, countering some genetic drift).
> 
> I think these are probably safe to go into this merge window, but I
> don't think I've posted these before, so I understand if you're hesitant
> (I've had them applied locally for some time with no ill-effects).
> The paravirt cleanup is pure movement between headers, so I don't think
> there's much risk there at all.
> 
>  arch/x86/include/asm/i387.h           |    1 +
>  arch/x86/include/asm/paravirt.h       |  711 +--------------------------------
>  arch/x86/include/asm/paravirt_types.h |  720 +++++++++++++++++++++++++++++++++
>  arch/x86/kernel/process_32.c          |   27 +-
>  arch/x86/kernel/process_64.c          |   33 +-
>  arch/x86/kernel/traps.c               |   33 +-
>  6 files changed, 782 insertions(+), 743 deletions(-)

Looks nice!

I havent checked all headers but do we now use the principle that we 
only include paravirt_types.h into other headers - and paravirt.h 
only into .c code that makes use of methods?

I'll try to find some time to pull + test + push it - it might miss 
the merge window, no promises.

	Ingo
