Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYETFtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYETFtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 01:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYETFta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 01:49:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:38471 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYETFt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 01:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LrHZbI+Sapuv4GNe4OEgbykc2EZ0tDXhJDma0AFCMlsJlVsTumVRl1XwSD0hj3H6UJtxzVC02ml1GTQIs8vx/eMtdLmT7Bn9QCWeyw0dAcDrhH+ltPsNF+3wHsVrhp85QEeCi1ShU9yvTeJsAdFUKRq2Nyp/1i1+42M2qobQ2Og=
Message-ID: <86802c440805192249y77e78918u8392f5a43331365@mail.gmail.com>
Date: Mon, 19 May 2008 22:49:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Dave Jones" <davej@redhat.com>
Subject: Re: [X86] Add recent Centaur CPUs to PAT whitelist
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       hpa@zytor.com
In-Reply-To: <200805200409.m4K49V3G024332@gelk.kernelslacker.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805200409.m4K49V3G024332@gelk.kernelslacker.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 9:09 PM, Dave Jones <davej@redhat.com> wrote:
> From conversation with Centaur engineers, both the newer generations
> of the VIA C7, and their future CPUs support PAT, with no known errata.
>
> Signed-off-by: Dave Jones <davej@redhat.com>
>
> diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
> index c2e1ce3..638a3a6 100644
> --- a/arch/x86/kernel/cpu/addon_cpuid_features.c
> +++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
> @@ -62,6 +81,10 @@ void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
>                if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
>                        return;
>                break;
> +       case X86_VENDOR_CENTAUR:
> +               if ((c->x86 > 6) || (c->x86 == 6 && c->x86_model >= 10))
> +                       set_cpu_cap(c, X86_FEATURE_PAT);
> +               break;
>        }
>
>        pat_disable(cpu_has_pat ?

you may need to return early...

> +       case X86_VENDOR_CENTAUR:
> +               if ((c->x86 > 6) || (c->x86 == 6 && c->x86_model >= 10)) {
> +                       set_cpu_cap(c, X86_FEATURE_PAT); /* may not need, if cpuid already has that set */
> +                       return;
> +               }
> +               break;

YH
