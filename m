Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZHYGpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZHYGpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZHYGpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:45:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50588 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216AbZHYGpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:45:06 -0400
Date: Tue, 25 Aug 2009 08:44:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] timekeeping: Fix up read_persistent_clock()
	breakage on sh.
Message-ID: <20090825064458.GC14286@elte.hu>
References: <20090824223239.GB20832@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824223239.GB20832@linux-sh.org>
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


* Paul Mundt <lethal@linux-sh.org> wrote:

> The recent commit "timekeeping: Increase granularity of
> read_persistent_clock()" introduced read_persistent_clock() rework which
> inadvertently broke the sh conversion:
> 
> 	arch/sh/kernel/time.c:45: error: passing argument 1 of 'rtc_sh_get_time' from incompatible pointer type
> 	distcc[13470] ERROR: compile arch/sh/kernel/time.c on sprygo/32 failed
> 	make[2]: *** [arch/sh/kernel/time.o] Error 1
> 
> This trivial fix gets it working again.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> 
> ---
> 
>  arch/sh/kernel/time.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied, thanks Paul!

I'm wondering, why did my cross-build of the SH defconfig in the 
timer tree not catch this? All i get (and got) are these warnings:

/home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c: In function 'cpg_clk_init':
/home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c:242: warning: 'arch_init_clk_ops' is deprecated (declared at /home/mingo/tip/arch/sh/include/asm/clock.h:58)
/home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c: In function 'arch_clk_init':
/home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c:256: warning: 'cpg_clk_init' is deprecated (declared at /home/mingo/tip/arch/sh/kernel/cpu/clock-cpg.c:237)

and time.o built without errors or warnings:

  CC      arch/sh/kernel/time.o

	Ingo
