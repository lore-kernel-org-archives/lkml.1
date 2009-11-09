Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZKIHIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZKIHIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZKIHIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:08:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34490 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZKIHIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:08:52 -0500
Date: Mon, 9 Nov 2009 08:08:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: under bios control, restore AP's APIC_LVTTHMR to
 the BSP value
Message-ID: <20091109070844.GA453@elte.hu>
References: <20091109042134.GA9169@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109042134.GA9169@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> Changes since v2:
> Incorporate Ingo's comments to get BSP's thermal init value in a
> 'boot-CPU-only' function.

> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index e09f0e2..2323771 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1002,6 +1002,7 @@ void __init setup_arch(char **cmdline_p)
>  
>  	init_apic_mappings();
>  	ioapic_init_mappings();
> +	get_bsp_lvtthmr_init();
>  
>  	/* need to wait for io_apic is mapped */
>  	probe_nr_irqs_gsi();

Ok - it's almost good in this form - it would be nice to name the new 
function something more generic, like mcheck_intel_therm_init(), and 
call it from arch/x86/kernel/cpu/mcheck/mce.c's mcheck_init() function.

Thanks,

	Ingo
