Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbYARFLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbYARFLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYARFK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:10:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58997 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYARFK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:10:57 -0500
Message-ID: <47903376.9050204@zytor.com>
Date: Fri, 18 Jan 2008 00:04:54 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make clflush a required feature on x86_64
References: <20080118045921.GB974@phobos.i.cabal.ca>
In-Reply-To: <20080118045921.GB974@phobos.i.cabal.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> Hopefully nobody will be stupid enough to implement a cpu without
> it. Frankly, it seems safe enough given we already require SSE2.
> 
> This means the compiler can optimise away "if (!cpu_has_clflush)"
> blocks.
> 
> Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
> ---
>  include/asm-x86/cpufeature_64.h     |    3 +++
>  include/asm-x86/required-features.h |    4 +++-
>  2 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-x86/cpufeature_64.h b/include/asm-x86/cpufeature_64.h
> index e18496b..ef11d27 100644
> --- a/include/asm-x86/cpufeature_64.h
> +++ b/include/asm-x86/cpufeature_64.h
> @@ -18,6 +18,9 @@
>  #undef  cpu_has_mp
>  #define cpu_has_mp             1 /* XXX */
>  
> +#undef	cpu_has_clflush
> +#define	cpu_has_clflush        1
> +
>  #undef  cpu_has_k6_mtrr
>  #define cpu_has_k6_mtrr        0

Unnecessary.  These overrides are only needed for the anticases (known 
to be zero) or for some special hacks.

Stuff that have proper CPUID bits get these defined as constants via the 
  REQUIRED_MASK macros.

	-hpa
