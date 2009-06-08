Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZFHNG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZFHNG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZFHNGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:06:21 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:60523 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbZFHNGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:06:21 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH 2/2] CPUFREQ: Mark e_powersaver driver as EXPERIMENTAL and DANGEROUS
Date: Mon, 8 Jun 2009 08:06:18 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <20090608102936.GQ4106@prithivi.gnumonks.org>
In-Reply-To: <20090608102936.GQ4106@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906080806.21048.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 8 2009, Harald Welte wrote:
> The e_powersaver driver for VIA's C7 CPU's needs to be marked as
> DANGEROUS as it configures the CPU to power states that are out
> of specification.
> 

I'll put this and your acpi proposal into a test build today - -
If my machine survives, I'll post the build for others to try.

The current build posted (-09159) does not have *either* control
included, leaving the machine running at silicon "#reset" conditions.
Slow - but safe.

Mike
> According to Centaur, all systems with C7 and Nano CPU's support
> the ACPI p-state method.  Thus, the acpi-cpufreq driver should
> be used instead.
> 
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> ---
>  arch/x86/kernel/cpu/cpufreq/Kconfig |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig b/arch/x86/kernel/cpu/cpufreq/Kconfig
> index 52c8398..f138c6c 100644
> --- a/arch/x86/kernel/cpu/cpufreq/Kconfig
> +++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
> @@ -220,11 +220,14 @@ config X86_LONGHAUL
>  	  If in doubt, say N.
>  
>  config X86_E_POWERSAVER
> -	tristate "VIA C7 Enhanced PowerSaver"
> +	tristate "VIA C7 Enhanced PowerSaver (DANGEROUS)"
>  	select CPU_FREQ_TABLE
> -	depends on X86_32
> +	depends on X86_32 && EXPERIMENTAL
>  	help
> -	  This adds the CPUFreq driver for VIA C7 processors.
> +	  This adds the CPUFreq driver for VIA C7 processors.  However, this driver
> +	  does not have any safeguards to prevent operating the CPU out of spec
> +	  and is thus considered dangerous.  Please use the regular ACPI cpufreq
> +	  driver, enabled by CONFIG_X86_ACPI_CPUFREQ.
>  
>  	  If in doubt, say N.
>  


