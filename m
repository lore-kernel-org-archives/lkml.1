Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbXJXEFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbXJXEFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXJXEFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:05:36 -0400
Received: from gw.goop.org ([64.81.55.164]:36704 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbXJXEFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:05:35 -0400
Message-ID: <471EC48E.2080506@goop.org>
Date: Tue, 23 Oct 2007 21:05:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: [PATCH 2/12] X86: fix nvidia HPET warning
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223635.24CE01F81A1@havoc.gtf.org>
In-Reply-To: <20071023223635.24CE01F81A1@havoc.gtf.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> arch/x86/kernel/early-quirks.c:40: warning: ‘nvidia_hpet_check’ defined but not used
>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index dc34acb..639e632 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -35,12 +35,14 @@ static void __init via_bugs(void)
>  }
>  
>  #ifdef CONFIG_ACPI
> +#ifdef CONFIG_X86_IO_APIC
>   

Why not #if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)?  Saves
a line and a layer of #if(def).

>  
>  static int __init nvidia_hpet_check(struct acpi_table_header *header)
>  {
>  	return 0;
>  }
> -#endif
> +#endif /* CONFIG_X86_IO_APIC */
> +#endif /* CONFIG_ACPI */
>  

    J
