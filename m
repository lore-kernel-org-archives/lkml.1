Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0BEMvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 07:51:15 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:58017
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753019Ab0BEMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 07:51:13 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zzab9bh1432R98dNzz1202hzzz32i87h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXDD0Y-02-6KP-02
X-M-MSG: 
Date: Fri, 5 Feb 2010 13:51:00 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Print AMD virtualization features in /proc/cpuinfo
Message-ID: <20100205125059.GA16236@amd.com>
References: <1260792521-15212-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1260792521-15212-1-git-send-email-joerg.roedel@amd.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 Feb 2010 12:51:00.0287 (UTC) FILETIME=[DE2ADCF0:01CAA661]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are there any problems with this patch or was it just forgotten :-)
Please let me know.

	Joerg

On Mon, Dec 14, 2009 at 01:08:41PM +0100, Joerg Roedel wrote:
> This patch adds code to cpu initialization path to detect
> the extended virtualization features of AMD cpus to show
> them in /proc/cpuinfo.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/include/asm/cpufeature.h          |    4 ++++
>  arch/x86/kernel/cpu/addon_cpuid_features.c |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 613700f..7dbc1c2 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -167,6 +167,10 @@
>  #define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
>  #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
>  #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
> +#define X86_FEATURE_NPT		(8*32+5)  /* AMD Nested Page Table support */
> +#define X86_FEATURE_LBRV	(8*32+6)  /* AMD LBR Virtualization support */
> +#define X86_FEATURE_SVML	(8*32+7)  /* "svm_lock" AMD SVM locking MSR */
> +#define X86_FEATURE_NRIPS	(8*32+8)  /* "nrip_save" AMD SVM next_rip save */
>  
>  #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
>  
> diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
> index 468489b..97ad79c 100644
> --- a/arch/x86/kernel/cpu/addon_cpuid_features.c
> +++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
> @@ -32,6 +32,10 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
>  	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
>  		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
>  		{ X86_FEATURE_ARAT, CR_EAX, 2, 0x00000006 },
> +		{ X86_FEATURE_NPT,   CR_EDX, 0, 0x8000000a },
> +		{ X86_FEATURE_LBRV,  CR_EDX, 1, 0x8000000a },
> +		{ X86_FEATURE_SVML,  CR_EDX, 2, 0x8000000a },
> +		{ X86_FEATURE_NRIPS, CR_EDX, 3, 0x8000000a },
>  		{ 0, 0, 0, 0 }
>  	};
>  
> -- 
> 1.6.5.4
> 

