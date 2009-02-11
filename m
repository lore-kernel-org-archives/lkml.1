Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbZBKRZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbZBKRZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZBKRZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:25:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbZBKRZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:25:00 -0500
Date: Wed, 11 Feb 2009 18:24:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -v4] futex: fix reference leak
Message-ID: <20090211172428.GA23119@elte.hu>
References: <1234200538.16083.52.camel@pc1117.cambridge.arm.com> <1234203975.5951.143.camel@laptop> <1234205595.4286.223.camel@localhost.localdomain> <1234205874.5951.151.camel@laptop> <20090211122849.GD16535@elte.hu> <1234366605.23438.179.camel@twins> <20090211154952.GB24408@elte.hu> <1234367802.23438.183.camel@twins> <20090211162618.GC32301@elte.hu> <1234372210.23438.192.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234372210.23438.192.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: futex: fix reference leak
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Catalin noticed that (38d47c1b7075: futex: rely on get_user_pages() for
> shared futexes) caused an mm_struct leak.
> 
> Some tracing with the function graph tracer quickly pointed out that
> futex_wait() has exit paths with unbalanced reference counts.
> 
> This regression was discovered by kmemleak.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Tested-by: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
> Tested-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  kernel/futex.c |   53 ++++++++++++++++++++++++++++-------------------------
>  1 files changed, 28 insertions(+), 25 deletions(-)

Applied to tip:core/urgent, thanks guys!

	Ingo
