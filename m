Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYKZCvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYKZCvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYKZCvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:51:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbYKZCvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:51:17 -0500
Date: Wed, 26 Nov 2008 03:51:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com, akpm@linux-foundation.org
Subject: Re: [PATCH] random: add a way to get some random bits into the
	entropy pools early on
Message-ID: <20081126025101.GD31342@elte.hu>
References: <20081125132600.5112fb24@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125132600.5112fb24@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> >From 5b3b09ac82316c2d4000460d586ebe59303c12c2 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Tue, 25 Nov 2008 11:41:37 -0800
> Subject: [PATCH] random: add a way to get some random bits into the entropy pools early on
> 
> currently the entropy pool gets seeded on the module_init() level, but there
> is at least one consumer of random bits (the oops ID that is printed as part
> of the oops).
> As a result of this, kerneloops.org is seeing a lot of oopses that all share
> the same 'random' number; which used to get filed away as "duplicate".
> 
> This patch adds a function to the random driver so that various pieces of
> the kernel can add random bits (but not entropy!) to the pool, to avoid
> this dupicate ID problem.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/x86/kernel/apic.c |    7 +++++++
>  drivers/char/random.c  |   29 +++++++++++++++++++++++++++++
>  include/linux/random.h |    3 +++
>  kernel/panic.c         |    1 +
>  4 files changed, 40 insertions(+), 0 deletions(-)

good catch ...

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
