Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbZFHUDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbZFHUDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZFHUDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:03:31 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:41932 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbZFHUDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:03:30 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur CPUs
Date: Mon, 8 Jun 2009 15:03:28 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906060856.15016.lkml@morethan.org> <20090608102754.GP4106@prithivi.gnumonks.org>
In-Reply-To: <20090608102754.GP4106@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081503.30488.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 8 2009, Harald Welte wrote:
> The VIA/Centaur C7, C7-M and Nano CPU's all support ACPI based cpu p-states
> using a MSR interface.  The Linux driver just never made use of it, since in
> addition to the check for the EST flag it also checked if the vendor is Intel.
> 
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> ---
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 208ecf6..ee03585 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -90,7 +90,8 @@ static int check_est_cpu(unsigned int cpuid)
>  {
>  	struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
>  
> -	if (cpu->x86_vendor != X86_VENDOR_INTEL ||
> +	if ((cpu->x86_vendor != X86_VENDOR_INTEL &&
> +	     cpu->x86_vendor != X86_VENDOR_CENTAUR) ||
>  	    !cpu_has(cpu, X86_FEATURE_EST))
>  		return 0;
>  

For my own internal testing, based on subsequent posts, I simplified
that to:

static int check_est_cpu(unsigned int cpuid)
{
        struct cpuinfo_x86 *cpu = &cpu_data(cpuid);

        if (!cpu_has(cpu, X86_FEATURE_EST))
                return 0;

        return 1;
}

Have not done anything (yet) to deal with the adaptive controller,
**which is safe to (not) do on my test system because I know it isn't enabled**

Note: This machine is known to run common, proprietary operating systems,
so I am also assuming its BIOS ACPI is complete enough.

Note 2: Don't try this unless you have a machine to waste.  ;)

Mike
