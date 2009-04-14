Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbZDNNrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbZDNNrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZDNNrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:47:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZDNNrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:47:00 -0400
Date: Tue, 14 Apr 2009 15:46:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are less
	or more then expected
Message-ID: <20090414134655.GD27163@elte.hu>
References: <1239711444.3079.13.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239711444.3079.13.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

> This will prepare the report to update cpu_debug
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/include/asm/cpu_debug.h |    1 +
>  arch/x86/kernel/cpu/cpu_debug.c  |   12 ++++++++++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
> index 2228020..b64da5d 100644
> --- a/arch/x86/include/asm/cpu_debug.h
> +++ b/arch/x86/include/asm/cpu_debug.h
> @@ -187,6 +187,7 @@ enum cpu_processor_bit {
>  #define	CPU_ALL			(CPU_INTEL_ALL | CPU_AMD_ALL)
>  
>  #define MAX_CPU_FILES		512
> +#define MIN_CPU_FILES		10
>  
>  struct cpu_private {
>  	unsigned		cpu;
> diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
> index 46e29ab..1c3ebd4 100644
> --- a/arch/x86/kernel/cpu/cpu_debug.c
> +++ b/arch/x86/kernel/cpu/cpu_debug.c
> @@ -838,6 +838,14 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
>  	return err;
>  }
>  
> +/* Send Report to maintainer if files are less or more then expected */ 
> +static void send_report(int files, struct cpuinfo_x86 *cpui)
> +{
> +	pr_info("Please report \"cpu_debug files %d for %x:%x:%x:%x\" to"
> +		" jaswinderrajput@gmail.com\n", files, cpui->x86_vendor,
> +		cpui->x86, cpui->x86_model, cpui->x86_mask);

i'd rather see this reported to linux-kernel@vger.kernel.org, plus 
please use a WARN_ONCE() instead of a pr_info(). Hitting this is a 
bug we want to fix.

	Ingo
