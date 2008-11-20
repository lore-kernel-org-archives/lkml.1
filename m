Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYKTCuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYKTCuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 21:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYKTCuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 21:50:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:29660 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYKTCuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 21:50:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,637,1220252400"; 
   d="scan'208";a="79168332"
From: "Yang, Sheng" <sheng.yang@intel.com>
Organization: Intel Opensource Technology Center
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH] x86: add REQUIRED_MASK8
Date: Thu, 20 Nov 2008 10:47:01 +0800
User-Agent: KMail/1.10.3 (Linux/2.6.27-7-generic; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "trivial@kernel.org" <trivial@kernel.org>
References: <491DEB90.9010509@simon.arlott.org.uk>
In-Reply-To: <491DEB90.9010509@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201047.01533.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 November 2008 05:20:16 Simon Arlott wrote:
> commit e38e05a85828dac23540cd007df5f20985388afc increased NCAPINTS to 9
> but didn't add REQUIRED_MASK8 resulting in the following sparse warnings:
>
> arch/x86/boot/cpustr.h:311:5: warning: undefined preprocessor identifier
> 'REQUIRED_MASK8' arch/x86/boot/cpustr.h:314:5: warning: undefined
> preprocessor identifier 'REQUIRED_MASK8' arch/x86/boot/cpustr.h:317:5:
> warning: undefined preprocessor identifier 'REQUIRED_MASK8'
> arch/x86/boot/cpustr.h:320:5: warning: undefined preprocessor identifier
> 'REQUIRED_MASK8' arch/x86/boot/cpustr.h:323:5: warning: undefined
> preprocessor identifier 'REQUIRED_MASK8'

Thanks for the fixing! :)
>
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> Cc: Sheng Yang <sheng.yang@intel.com>

Reviewed-by: Sheng Yang <sheng.yang@intel.com>

-- 
regards
Yang, Sheng

> ---
>  arch/x86/boot/cpucheck.c                 |    1 +
>  arch/x86/include/asm/cpufeature.h        |    3 ++-
>  arch/x86/include/asm/required-features.h |    1 +
>  3 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
> index 4d3ff03..41559bf 100644
> --- a/arch/x86/boot/cpucheck.c
> +++ b/arch/x86/boot/cpucheck.c
> @@ -44,6 +44,7 @@ static const u32 req_flags[NCAPINTS] =
>  	0, /* REQUIRED_MASK5 not implemented in this file */
>  	REQUIRED_MASK6,
>  	0, /* REQUIRED_MASK7 not implemented in this file */
> +	0 /* REQUIRED_MASK8 not implemented in this file */
>  };
>
>  #define A32(a, b, c, d) (((d) << 24)+((c) << 16)+((b) << 8)+(a))
> diff --git a/arch/x86/include/asm/cpufeature.h
> b/arch/x86/include/asm/cpufeature.h index cfdf8c2..9761800 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -178,7 +178,8 @@ extern const char * const x86_power_flags[32];
>  	   (((bit)>>5)==4 && (1UL<<((bit)&31) & REQUIRED_MASK4)) ||	\
>  	   (((bit)>>5)==5 && (1UL<<((bit)&31) & REQUIRED_MASK5)) ||	\
>  	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
> -	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) )	\
> +	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) ||	\
> +	   (((bit)>>5)==8 && (1UL<<((bit)&31) & REQUIRED_MASK8)) )	\
>  	  ? 1 :								\
>  	 test_cpu_cap(c, bit))
>
> diff --git a/arch/x86/include/asm/required-features.h
> b/arch/x86/include/asm/required-features.h index d5cd6c5..0baa45d 100644
> --- a/arch/x86/include/asm/required-features.h
> +++ b/arch/x86/include/asm/required-features.h
> @@ -78,5 +78,6 @@
>  #define REQUIRED_MASK5	0
>  #define REQUIRED_MASK6	0
>  #define REQUIRED_MASK7	0
> +#define REQUIRED_MASK8	0
>
>  #endif /* _ASM_X86_REQUIRED_FEATURES_H */
> --
> 1.6.0.3

