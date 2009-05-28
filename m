Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbZE1IeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbZE1IeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZE1Idv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:33:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44322 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbZE1Idu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:33:50 -0400
Date: Thu, 28 May 2009 10:33:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] perf_counter/x86: Remove masking and unmasking of
	LVT error register.
Message-ID: <20090528083340.GA7530@elte.hu>
References: <20090528071655.GA21039@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528071655.GA21039@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> Masking and unmasking of LVT error register become unnecessary as 
> NMI mode will be used all the time.
> 
> Signed-off-by: Yong Wang <yong.y.wang@intel.com>
> 
> ---
>  perf_counter.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index 2eeaa99..444bcf2 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -865,22 +865,16 @@ void set_perf_counter_pending(void)
>  
>  void perf_counters_lapic_init(int nmi)
>  {
> -	u32 apic_val;
> -
>  	if (!x86_pmu_initialized())
>  		return;
>  
>  	/*
>  	 * Enable the performance counter vector in the APIC LVT:
>  	 */
> -	apic_val = apic_read(APIC_LVTERR);
> -
> -	apic_write(APIC_LVTERR, apic_val | APIC_LVT_MASKED);
>  	if (nmi)
>  		apic_write(APIC_LVTPC, APIC_DM_NMI);
>  	else
>  		apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
> -	apic_write(APIC_LVTERR, apic_val);
>  }

i'd suggest to remove the 'nmi' parameter as well to this function. 
(and any other dynamic flags that deal with nmi/irq distinctions)

	Ingo
