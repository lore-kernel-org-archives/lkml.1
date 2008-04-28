Return-Path: <linux-kernel-owner+w=401wt.eu-S968131AbYD1XFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968131AbYD1XFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966963AbYD1Wjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:39:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:11191 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967083AbYD1Wjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:39:37 -0400
Date: Mon, 28 Apr 2008 15:36:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: yhlu.kernel@gmail.com
Cc: Yinghai Lu <yhlu.kernel.send@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 layout v5
Message-Id: <20080428153617.bcd4e301.randy.dunlap@oracle.com>
In-Reply-To: <200804281505.05764.yhlu.kernel@gmail.com>
References: <200804272337.40130.yhlu.kernel@gmail.com>
	<200804281244.56938.yhlu.kernel@gmail.com>
	<200804281316.14168.yhlu.kernel@gmail.com>
	<200804281505.05764.yhlu.kernel@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 15:05:05 -0700 Yinghai Lu wrote:

> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6/Documentation/kernel-parameters.txt
> @@ -595,6 +595,16 @@ and is between 256 and 4096 characters. 
>  			See drivers/char/README.epca and
>  			Documentation/digiepca.txt.
>  
> +	disable_mtrr_cleanup [X86]
> +	enable_mtrr_cleanup [X86]
> +			The kernel try to adjust MTRR layout from continuous

                                   tries

> +			to discrete, to make x server driver could add WB entry

                                             X server driver able to add WB entry

> +			later. This parameter enable/disable that.

                                              enables/disables

> +
> +	mtrr_chunk_size=nn[KMG] [X86]
> +			used for mtrr cleanup. It is largest continous chunk
> +			that could hold holes aka. UC entries.
> +
>  	disable_mtrr_trim [X86, Intel and AMD only]
>  			By default the kernel will trim any uncacheable
>  			memory out of your available memory pool based on
> Index: linux-2.6/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig
> +++ linux-2.6/arch/x86/Kconfig
> @@ -1035,6 +1035,32 @@ config MTRR
>  
>  	  See <file:Documentation/mtrr.txt> for more information.
>  
> +config MTRR_SANITIZER
> +	def_bool y
> +	prompt "MTRR cleanup support"
> +	depends on MTRR
> +	help
> +	  Convert MTRR layout from continuous to discrete, so some X driver
> +	  could add WB entries.
> +
> +	  Say N here if you see bootup problems (boot crash, boot hang,
> +	  spontaneous reboots).
> +
> +	  could be disabled with disable_mtrr_cleanup. also mtrr_chunk_size

          Could                                        Also

> +	  could be used to send largest mtrr entry size for continuous block
> +	  to hold holes (aka. UC entries)
> +
> +	  If unsure, say Y.
> +
> +config MTRR_SANITIZER_ENABLE_DEFAULT
> +	bool
> +	prompt "MTRR cleanup enable default"

	prompt "Enable MTRR cleanup"
or
	prompt "Enable MTRR cleanup by default"

> +	depends on MTRR_SANITIZER
> +	help
> +	  Enable mtrr cleanup by default

                                 default.

> +
> +	  If unsure, say Y.
> +
>  config X86_PAT
>  	bool
>  	prompt "x86 PAT support"

---
~Randy
