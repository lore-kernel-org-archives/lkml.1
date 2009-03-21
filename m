Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZCUQhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZCUQhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZCUQg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:36:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54967 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZCUQgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:36:55 -0400
Date: Sat, 21 Mar 2009 17:36:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: apic/io_apic fix compilation warning
Message-ID: <20090321163642.GI11183@elte.hu>
References: <1237630967.2409.1.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1237630967.2409.1.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hello Ingo,
> 
> Is this fix looks OK to you:
> 
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Sat, 21 Mar 2009 15:41:17 +0530
> Subject: [PATCH] x86: apic/io_apic fix compilation warning
> 
> Fix:
>  arch/x86/kernel/apic/io_apic.c:1431: warning: ‘msi_ir_chip’ defined but not used
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index d882c03..3ca7838 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1428,7 +1428,6 @@ void __setup_vector_irq(int cpu)
>  
>  static struct irq_chip ioapic_chip;
>  static struct irq_chip ir_ioapic_chip;
> -static struct irq_chip msi_ir_chip;
>  
>  #define IOAPIC_AUTO     -1
>  #define IOAPIC_EDGE     0
> @@ -3402,6 +3401,8 @@ static struct irq_chip msi_ir_chip = {
>  #endif
>  	.retrigger	= ioapic_retrigger_irq,
>  };
> +#else
> +static struct irq_chip msi_ir_chip;
>  #endif

hm, i think it would be cleaner to remove the CONFIG_INTR_REMAP 
define altogether and define msi_ir_chip all the time. (and make 
sure this build fine even in the !INTR_REMAP case)

	Ingo
