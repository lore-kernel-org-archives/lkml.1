Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYI3WEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYI3WEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYI3WE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:04:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYI3WE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:04:27 -0400
Message-ID: <48E2A234.5030809@zytor.com>
Date: Tue, 30 Sep 2008 15:03:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: mtrr_cleanup update command line and doc mtrrcleanup_debug
References: <1222812086-15774-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1222812086-15774-1-git-send-email-yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: H. Peter Anvin <hpa@zytor.com>

I'll add it to tip:x86/mtrr in a bit.

	-hpa


Yinghai Lu wrote:
> change enable_mtrr_cleanup to mtrrcleanup, disable_mtrr_cleanup to nomtrrcleanup.
> so doc mtrrcleanup_debug.
> 
> and change MTRR_SANITIZER to def_bool y
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  Documentation/kernel-parameters.txt |    7 +++++--
>  arch/x86/Kconfig                    |    6 +++---
>  arch/x86/kernel/cpu/mtrr/main.c     |    6 +++---
>  3 files changed, 11 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6/Documentation/kernel-parameters.txt
> @@ -614,12 +614,15 @@ and is between 256 and 4096 characters.
>  			See drivers/char/README.epca and
>  			Documentation/digiepca.txt.
>  
> -	disable_mtrr_cleanup [X86]
> -	enable_mtrr_cleanup [X86]
> +	nomtrrcleanup [X86]
> +	mtrrcleanup [X86]
>  			The kernel tries to adjust MTRR layout from continuous
>  			to discrete, to make X server driver able to add WB
>  			entry later. This parameter enables/disables that.
>  
> +	mtrrcleanup_debug [X86]
> +			print out more debug info for mtrr cleanup.
> +
>  	mtrr_chunk_size=nn[KMG] [X86]
>  			used for mtrr cleanup. It is largest continous chunk
>  			that could hold holes aka. UC entries.
> Index: linux-2.6/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig
> +++ linux-2.6/arch/x86/Kconfig
> @@ -1243,18 +1243,18 @@ config MTRR
>  	  See <file:Documentation/x86/mtrr.txt> for more information.
>  
>  config MTRR_SANITIZER
> -	bool
> +	def_bool y
>  	prompt "MTRR cleanup support"
>  	depends on MTRR
>  	help
>  	  Convert MTRR layout from continuous to discrete, so X drivers can
>  	  add writeback entries.
>  
> -	  Can be disabled with disable_mtrr_cleanup on the kernel command line.
> +	  Can be disabled with nomtrrcleanup on the kernel command line.
>  	  The largest mtrr entry size for a continous block can be set with
>  	  mtrr_chunk_size.
>  
> -	  If unsure, say N.
> +	  If unsure, say Y.
>  
>  config MTRR_SANITIZER_ENABLE_DEFAULT
>  	int "MTRR cleanup enable value (0-1)"
> Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
> +++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
> @@ -826,7 +826,7 @@ static int __init disable_mtrr_cleanup_s
>  		enable_mtrr_cleanup = 0;
>  	return 0;
>  }
> -early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);
> +early_param("nomtrrcleanup", disable_mtrr_cleanup_setup);
>  
>  static int __init enable_mtrr_cleanup_setup(char *str)
>  {
> @@ -834,14 +834,14 @@ static int __init enable_mtrr_cleanup_se
>  		enable_mtrr_cleanup = 1;
>  	return 0;
>  }
> -early_param("enable_mtrr_cleanup", enable_mtrr_cleanup_setup);
> +early_param("mtrrcleanup", enable_mtrr_cleanup_setup);
>  
>  static int __init mtrr_cleanup_debug_setup(char *str)
>  {
>  	debug_print = 1;
>  	return 0;
>  }
> -early_param("mtrr_cleanup_debug", mtrr_cleanup_debug_setup);
> +early_param("mtrrcleanup_debug", mtrr_cleanup_debug_setup);
>  
>  struct var_mtrr_state {
>  	unsigned long	range_startk;
