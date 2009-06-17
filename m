Return-Path: <linux-kernel-owner+w=401wt.eu-S933690AbZFQOLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690AbZFQOLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbZFQOLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:11:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:40405 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbZFQOLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:11:12 -0400
Cc: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Message-Id: <A731338A-E954-46D9-8BF7-6E74C797209C@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
In-Reply-To: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software counters on 32-bit powerpc
Date: Wed, 17 Jun 2009 09:10:49 -0500
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 17, 2009, at 6:50 AM, Paul Mackerras wrote:

> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/ 
> platforms/Kconfig.cputype
> index cca6b4f..dd9f3ec 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -1,7 +1,7 @@
> config PPC64
> 	bool "64-bit kernel"
> 	default n
> -	select HAVE_PERF_COUNTERS
> +	select PPC_HAVE_PMU_SUPPORT
> 	help
> 	  This option selects whether a 32-bit or a 64-bit kernel
> 	  will be built.
> @@ -243,6 +243,15 @@ config VIRT_CPU_ACCOUNTING
>
> 	  If in doubt, say Y here.
>
> +config PPC_HAVE_PMU_SUPPORT
> +       bool

what does this mean?

> +
> +config PPC_PERF_CTRS
> +       def_bool y
> +       depends on PERF_COUNTERS && PPC_HAVE_PMU_SUPPORT
> +       help
> +         This enables the powerpc-specific perf_counter back-end.

Can we distinguish between the two different architected perf counters  
programming models to start with.  Maybe something like:

PPC_BOOK3S_PERF_CTRS and PPC_BOOK3E_PERF_CTRS (or  
PPC_SERVER_PERF_CTRS / PPC_EMB_PERF_CTRS)


>
> +
> config SMP
> 	depends on PPC_STD_MMU || FSL_BOOKE
> 	bool "Symmetric multi-processing support"
> -- 
> 1.6.0.4
>

