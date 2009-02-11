Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZBKKfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZBKKfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZBKKfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:35:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57183 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZBKKfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:35:23 -0500
Date: Wed, 11 Feb 2009 11:34:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, hpa@zytor.com, jeremy@goop.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH x86#core/percpu] x86: fix x86_32 stack protector bugs
Message-ID: <20090211103456.GK20518@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-12-git-send-email-tj@kernel.org> <73c1f2160902100725w2503d693v5a3d1ae93ada75de@mail.gmail.com> <49919FA2.9050309@kernel.org> <49927EB4.3050507@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49927EB4.3050507@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Impact: fix x86_32 stack protector
> 
> Brian Gerst found out that %gs was being initialized to stack_canary
> instead of stack_canary - 20, which basically gave the same canary
> value for all threads.  Fixing this also exposed the following bugs.
> 
> * cpu_idle() didn't call boot_init_stack_canary()
> 
> * stack canary switching in switch_to() was being done too late making
>   the initial run of a new thread use the old stack canary value.
> 
> Fix all of them and while at it update comment in cpu_idle() about
> calling boot_init_stack_canary().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Brian Gerst <brgerst@gmail.com>
> ---
>  arch/x86/include/asm/stackprotector.h |    2 +-
>  arch/x86/include/asm/system.h         |    8 +++-----
>  arch/x86/kernel/head_32.S             |    1 +
>  arch/x86/kernel/process_32.c          |   10 ++++++++++
>  arch/x86/kernel/process_64.c          |   11 +++++------
>  5 files changed, 20 insertions(+), 12 deletions(-)

Applied to tip:core/percpu, thanks guys!

I never got around to finding his bug in practice as the latest bits of 
tip:core/percpu are not in tip/master at the moment, due to that 64-bit
build failure.

	Ingo
