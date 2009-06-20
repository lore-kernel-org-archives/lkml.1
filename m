Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZFTRnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZFTRnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 13:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZFTRnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 13:43:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43768 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbZFTRng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 13:43:36 -0400
Date: Sat, 20 Jun 2009 19:43:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip RESEND] x86: perf_counter fix
	L1-data-Cache-Store-Referencees for AMD
Message-ID: <20090620174328.GA2422@elte.hu>
References: <1245331731.3215.3.camel@localhost.localdomain> <1245484165.3102.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245484165.3102.6.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Fix AMD's Data Cache Refills from System event.
> 
> By this patch :
> 
> ./tools/perf/perf stat -e l1d -e l1d-misses -e l1d-write -e l1d-prefetch -e l1d-prefetch-miss -e l1i -e l1i-misses -e l1i-prefetch -e l2 -e l2-misses -e l2-write -e dtlb -e dtlb-misses -e itlb -e itlb-misses -e bpu -e bpu-misses ls /dev/ > /dev/null
> 
>  Performance counter stats for 'ls /dev/':
> 
>         2499484  L1-data-Cache-Load-Referencees  (scaled from 3.97%)
>           70347  L1-data-Cache-Load-Misses  (scaled from 7.30%)
>            9360  L1-data-Cache-Store-Referencees  (scaled from 8.64%)
>           32804  L1-data-Cache-Prefetch-Referencees  (scaled from 17.72%)
>            7693  L1-data-Cache-Prefetch-Misses  (scaled from 22.97%)
>         2180945  L1-instruction-Cache-Load-Referencees  (scaled from 28.48%)
>           14518  L1-instruction-Cache-Load-Misses  (scaled from 35.00%)
>            2405  L1-instruction-Cache-Prefetch-Referencees  (scaled from 34.89%)
>           71387  L2-Cache-Load-Referencees  (scaled from 34.94%)
>           18732  L2-Cache-Load-Misses  (scaled from 34.92%)
>           79918  L2-Cache-Store-Referencees  (scaled from 36.02%)
>         1295294  Data-TLB-Cache-Load-Referencees  (scaled from 35.99%)
>           30896  Data-TLB-Cache-Load-Misses  (scaled from 33.36%)
>         1222030  Instruction-TLB-Cache-Load-Referencees  (scaled from 29.46%)
>             357  Instruction-TLB-Cache-Load-Misses  (scaled from 20.46%)
>          530888  Branch-Cache-Load-Referencees  (scaled from 11.48%)
>            8638  Branch-Cache-Load-Misses  (scaled from 5.09%)
> 
>     0.011295149  seconds time elapsed.
> 
> Earlier it always shows value 0.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index ce1ae3f..37facc5 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -401,7 +401,7 @@ static const u64 amd_hw_cache_event_ids
>  		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
>  	},
>  	[ C(OP_WRITE) ] = {
> -		[ C(RESULT_ACCESS) ] = 0x0042, /* Data Cache Refills from L2 */
> +		[ C(RESULT_ACCESS) ] = 0x0142, /* Data Cache Refills :system */
>  		[ C(RESULT_MISS)   ] = 0,
>  	},
>  	[ C(OP_PREFETCH) ] = {

Applied to tip:perfcounters/urgent, thanks Jaswinder!

	Ingo
