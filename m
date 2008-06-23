Return-Path: <linux-kernel-owner+w=401wt.eu-S1764104AbYFWU2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764104AbYFWU2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYFWU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:27:42 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:21872 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYFWU1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TM2HjsoronXpdXrJ0DOE/7gSLR224s/pYanHwkTJT7ZRR+JkP7xaz/ZaZGWKZC3HET
         bbk2AaGFHW7hkXI897KqcWAFSLd+mEgGvK76INfIPNFiUeXc8bPW4h3Uy7wcLadY81+1
         JjNzv6lpMArJe+3FaGaREL322LaJCBreC+zDg=
Message-ID: <86802c440806231327u74d67b59je7f5b42ae1e2b49d@mail.gmail.com>
Date: Mon, 23 Jun 2008 13:27:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: cleanup using max_low_pfn for 32 bit
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080623202235.GA14743@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806180215.53755.yhlu.kernel@gmail.com>
	 <200806220245.39289.yhlu.kernel@gmail.com>
	 <200806220246.58958.yhlu.kernel@gmail.com>
	 <200806230305.30944.yhlu.kernel@gmail.com>
	 <20080623195616.GA3670@elte.hu> <20080623202235.GA14743@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 1:22 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>>       x86: clean up using max_low_pfn on 32-bit
>
> this one needed the small fix below.
>
>        Ingo
>
> ----------->
> commit 749cffb6c81f6637bbd054a4db246196eaa69ccc
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon Jun 23 22:19:22 2008 +0200
>
>    x86: build fix
>
>    fix:
>
>    arch/x86/kernel/setup_32.c:409: error: 'enable_local_apic' undeclared (first use in this function)
>    arch/x86/kernel/setup_32.c:409: error: (Each undeclared identifier is reported only once
>    arch/x86/kernel/setup_32.c:409: error: for each function it appears in.)
>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
> index b42f570..1e67037 100644
> --- a/arch/x86/kernel/setup_32.c
> +++ b/arch/x86/kernel/setup_32.c
> @@ -406,7 +406,9 @@ void __init setup_arch(char **cmdline_p)
>        parse_early_param();
>
>        if (acpi_mps_check()){
> +#ifdef CONFIG_X86_LOCAL_APIC
>                enable_local_apic = -1;
> +#endif
>                clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
>        }

need to merge enable_local_apic (32bit) and disable_apic (64 bit).

YH
