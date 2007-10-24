Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbXJXEDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbXJXEDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbXJXEDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:03:13 -0400
Received: from gw.goop.org ([64.81.55.164]:42855 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbXJXEDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:03:12 -0400
Message-ID: <471EC3FE.8060907@goop.org>
Date: Tue, 23 Oct 2007 21:03:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: [PATCH 1/12] X86: fix !CONFIG_SMP warning in processor.c
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
In-Reply-To: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Fix !CONFIG_SMP warning:
>
> arch/x86/kernel/acpi/processor.c: In function ‘arch_acpi_processor_init_pdc’:
> arch/x86/kernel/acpi/processor.c:65: warning: unused variable ‘cpu’
>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
> Ideally this warning should be hidden inside a wrapper or somesuch, to
> camouflage the unneeded argument in !SMP case.
>
> diff --git a/arch/x86/kernel/acpi/processor.c b/arch/x86/kernel/acpi/processor.c
> index 2ed0a4c..45e262a 100644
> --- a/arch/x86/kernel/acpi/processor.c
> +++ b/arch/x86/kernel/acpi/processor.c
> @@ -62,7 +62,9 @@ static void init_intel_pdc(struct acpi_processor *pr, struct cpuinfo_x86 *c)
>  /* Initialize _PDC data based on the CPU vendor */
>  void arch_acpi_processor_init_pdc(struct acpi_processor *pr)
>  {
> +#ifdef CONFIG_SMP
>  	unsigned int cpu = pr->id;
> +#endif
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
>   

Surely just replace cpu with pr->id?  That's the only use.

    J
