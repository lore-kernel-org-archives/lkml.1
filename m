Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZBDMlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZBDMlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZBDMlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:41:16 -0500
Received: from mx2.compro.net ([216.54.166.4]:27482 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZBDMlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:41:15 -0500
X-IronPort-AV: E=Sophos;i="4.37,378,1231131600"; 
   d="scan'208";a="3351143"
Message-ID: <49898CE8.1030605@compro.net>
Date: Wed, 04 Feb 2009 07:41:12 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: APIC: enable workaround on AMD Fam10h CPUs
References: <20090203172200.GA3955@aftab>
In-Reply-To: <20090203172200.GA3955@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Tue, 3 Feb 2009 16:24:22 +0100
> Subject: [PATCH] APIC: enable workaround on AMD Fam10h CPUs
> 
> Impact: fix to enable APIC for AMD Fam10h on chipsets with a missing/b0rked
> 	ACPI MP table (MADT)
> 
> Booting a 32bit kernel on an AMD Fam10h CPU running on chipsets with
> missing/b0rked MP table leads to a hang pretty early in the boot process
> due to the APIC not being initialized. Fix that by falling back to the
> default APIC base address in 32bit code, as it is done in the 64bit
> codepath.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/apic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
> index 4b6df24..115449f 100644
> --- a/arch/x86/kernel/apic.c
> +++ b/arch/x86/kernel/apic.c
> @@ -1436,7 +1436,7 @@ static int __init detect_init_APIC(void)
>  	switch (boot_cpu_data.x86_vendor) {
>  	case X86_VENDOR_AMD:
>  		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model > 1) ||
> -		    (boot_cpu_data.x86 == 15))
> +		    (boot_cpu_data.x86 >= 15))
>  			break;
>  		goto no_apic;
>  	case X86_VENDOR_INTEL:

Hi Borislav,

Could this have anything to do with my Phenom-II problem that you've been so kind
to help me with?

Thanks
Mark
