Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYGNH2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYGNH2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbYGNH2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:28:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbYGNH2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:28:04 -0400
Date: Mon, 14 Jul 2008 09:27:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Joe Jin <joe.jin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, greg.marsden@oracle.com,
       tao.ma@oracle.com, linux-kernel@vger.kernel.org, stable@kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] x86_64: reserve crashkernel bootmem before reserve
	dma32 bootmem
Message-ID: <20080714072722.GB19116@elte.hu>
References: <20080710123446.GA1595@joejin-pc.cn.oracle.com> <86802c440807101032h6fc6cf16l829e4932477f43b3@mail.gmail.com> <86802c440807140014y6f0b67e7r6414b686fdbaf012@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807140014y6f0b67e7r6414b686fdbaf012@mail.gmail.com>
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

* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Thu, Jul 10, 2008 at 10:32 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Thu, Jul 10, 2008 at 5:34 AM, Joe Jin <joe.jin@oracle.com> wrote:
> >> Before reserve_crashkernel, dma32_reserve_bootmem would reserve 128M memory.
> >> this cuased crashkernel end address must less than 64M or start address must
> >> more than 192M except crashkernel memory reserved before dma32 memory reserved.
> >>
> >> This patch against 2.6.26-rc9
> >>
> >> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> >> ---
> >>  setup_64.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> --- linux-2.6.26-rc9/arch/x86/kernel/setup_64.c.orig    2008-07-10 16:34:12.000000000 +0800
> >> +++ linux-2.6.26-rc9/arch/x86/kernel/setup_64.c 2008-07-10 16:35:00.000000000 +0800
> >> @@ -444,8 +444,6 @@ void __init setup_arch(char **cmdline_p)
> >>        contig_initmem_init(0, end_pfn);
> >>  #endif
> >>
> >> -       dma32_reserve_bootmem();
> >> -
> >>  #ifdef CONFIG_ACPI_SLEEP
> >>        /*
> >>         * Reserve low memory region for sleep support.
> >> @@ -486,6 +484,8 @@ void __init setup_arch(char **cmdline_p)
> >>  #endif
> >>        reserve_crashkernel();
> >>
> >> +       dma32_reserve_bootmem();
> >> +
> >>        reserve_ibft_region();
> >>
> >>        paging_init();
> >
> > Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >
> 
> Ingo,
> 
> it seems you missed this patch..., it should get into 
> 2.6.26..stable..too

no, i didnt miss it - but it was too late for v2.6.26 and it was in a 
common x86 codepath and the code in -tip there is very different. The 
fix is a proper candidate for v2.6.26.1 though - stable team Cc:-ed.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
