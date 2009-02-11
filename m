Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZBKIgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZBKIgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbZBKIgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:36:41 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:26472 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZBKIgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:36:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RfB677hCH5/Veur9H4JPo9t9ylymnzRA4qjJxx6BHeNevQ7GpunF35AYJT7TUwtn18
         t9QPqhrGfYyRZfdHehZWPQ3hvc7ZTq10AaTkJ2Xo5l5NGqn8sLYBAygNp3lTA+lxsrje
         oV0RelrXI9i3wDnkNIa/vzVa2XlVxlAGLDPzY=
MIME-Version: 1.0
In-Reply-To: <bf56957d176c279175464f385f3eb03d65819328.1234296039.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
	 <bf56957d176c279175464f385f3eb03d65819328.1234296039.git.jeremy.fitzhardinge@citrix.com>
Date: Wed, 11 Feb 2009 00:36:38 -0800
X-Google-Sender-Auth: 2ce9a39efb6d72fd
Message-ID: <86802c440902110036n4e0b2a55udee3e0d31e93f6e5@mail.gmail.com>
Subject: Re: [PATCH] xen: expose enable_IO_APIC for 32-bit
From: Yinghai Lu <yinghai@kernel.org>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 12:05 PM, Ian Campbell <ian.campbell@citrix.com> wrote:
> enable_IO_APIC() is defined for both 32- and 64-bit x86, so it should
> be declared for both.
>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/include/asm/hw_irq.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> index 1b82781..370e1c8 100644
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -65,9 +65,7 @@ extern void disable_IO_APIC(void);
>  extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
>  extern void setup_ioapic_dest(void);
>
> -#ifdef CONFIG_X86_64
>  extern void enable_IO_APIC(void);
> -#endif
>
>  /* Statistics */
>  extern atomic_t irq_err_count;
> --
> 1.6.0.6
>
> --

wonder if we should call enable_IO_APIC in 32bit like 64bit...
should be ok.

YH
