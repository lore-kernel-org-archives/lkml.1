Return-Path: <linux-kernel-owner+w=401wt.eu-S965865AbXFHGmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965865AbXFHGmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 02:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757255AbXFHGmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 02:42:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757168AbXFHGmY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 02:42:24 -0400
Date: Thu, 7 Jun 2007 23:41:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?Qmr2cm4=?= Steinbrink <B.Steinbrink@gmx.de>
Cc: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ak@suse.de
Subject: Re: [PATCH] Fix interchanged parameters to
 release_{evntsel,perfctr}_nmi
Message-Id: <20070607234153.09c32b49.akpm@linux-foundation.org>
In-Reply-To: <20070608060244.GA2369@atjola.homenet>
References: <465C2225.2000100@googlemail.com>
	<20070603150246.5151dda6@laptop.hypervisor.org>
	<20070608060244.GA2369@atjola.homenet>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 08:02:44 +0200 Björn Steinbrink <B.Steinbrink@gmx.de> wrote:

> Fix interchanged parameters to release_{evntsel,perfctr}_nmi.
> 
> Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
> ---
> diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
> index 2b04c8f..e490ac2 100644
> --- a/arch/i386/kernel/cpu/perfctr-watchdog.c
> +++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
> @@ -276,8 +276,8 @@ static int single_msr_reserve(void)
>  
>  static void single_msr_unreserve(void)
>  {
> -	release_evntsel_nmi(wd_ops->perfctr);
> -	release_perfctr_nmi(wd_ops->evntsel);
> +	release_evntsel_nmi(wd_ops->evntsel);
> +	release_perfctr_nmi(wd_ops->perfctr);
>  }
>  
>  static void single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
> @@ -475,10 +475,10 @@ static void p4_unreserve(void)
>  {
>  #ifdef CONFIG_SMP
>  	if (smp_num_siblings > 1)
> -		release_evntsel_nmi(MSR_P4_IQ_PERFCTR1);
> +		release_perfctr_nmi(MSR_P4_IQ_PERFCTR1);
>  #endif
> -	release_evntsel_nmi(MSR_P4_IQ_PERFCTR0);
> -	release_perfctr_nmi(MSR_P4_CRU_ESCR0);
> +	release_evntsel_nmi(MSR_P4_CRU_ESCR0);
> +	release_perfctr_nmi(MSR_P4_IQ_PERFCTR0);
>  }
>  
>  static void p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)

Half of this (the first hunk) has been in Andi's tree for a day or two.

I shall drop Andi's patch,  queue this one up and shall send this off to Linus if
nothing else happens in the next couple of days.
