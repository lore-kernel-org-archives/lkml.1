Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZCEK1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZCEK1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZCEK1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:27:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbZCEK1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:27:01 -0500
Date: Thu, 5 Mar 2009 11:26:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 4/3 v7] SGI RTC: fix uv_time for UP
Message-ID: <20090305102651.GA32407@elte.hu>
References: <20090304185413.GA24385@sgi.com> <20090304194658.GA18096@elte.hu> <20090304204522.GA25430@sgi.com> <20090304205833.GB3527@elte.hu> <20090304220246.GC6288@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304220246.GC6288@sgi.com>
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


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> Fix non-smp build of uv_time.c.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> ---
> 
> This time against tip/x86/uv
> 
>  arch/x86/kernel/uv_time.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.tip-uv/arch/x86/kernel/uv_time.c
> ===================================================================
> --- linux-2.6.tip-uv.orig/arch/x86/kernel/uv_time.c	2009-03-04 15:52:10.000000000 -0600
> +++ linux-2.6.tip-uv/arch/x86/kernel/uv_time.c	2009-03-04 15:58:48.000000000 -0600
> @@ -20,6 +20,9 @@
>   */
>  #include <linux/clockchips.h>
>  
> +#include <asm/apic.h>
> +#include <asm/cpu.h>
> +
>  #include <asm/uv/uv_mmrs.h>
>  #include <asm/uv/uv_hub.h>
>  #include <asm/uv/bios.h>

Btw: trivia: have you ever thought about why the include files 
sections looks like that and why i modified your original patch? 
Have a look at arch/x86/mm/fault.c.

Anyway, i fixed up your patch.

	Ingo
