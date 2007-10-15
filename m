Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbXJOPCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbXJOPCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXJOPCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:02:40 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:57213 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143AbXJOPCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:02:39 -0400
Date: Mon, 15 Oct 2007 17:02:37 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] arch/i386/kernel/smpboot.c:setup_trampoline() must be __cpuinit
Message-ID: <20071015150237.GA19610@janus>
References: <20070709184200.GA2496@janus> <20070709194540.GJ3492@stusta.de> <20070709194853.GA3601@janus> <20070710000552.GM3492@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710000552.GM3492@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 02:05:52AM +0200, Adrian Bunk wrote:
> This patch fixes the following section mismatch reported by
> Frank van Maarseveen:
> 
> <--  snip  -->
> 
> ...
>   MODPOST vmlinux
> WARNING: arch/i386/kernel/built-in.o(.text+0xf201): Section mismatch: reference to .init.data:trampoline_end (between 'setup_trampoline' and 'cpu_coregroup_map')
> WARNING: arch/i386/kernel/built-in.o(.text+0xf207): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
> WARNING: arch/i386/kernel/built-in.o(.text+0xf21a): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
> @stable:
> Harmless but annoying warnings present when building an i386 SMP kernel 
> with CONFIG_HOTPLUG_CPU=n and gcc < 4.0 .
> 
> --- linux-2.6.22-rc6-mm1/arch/i386/kernel/smpboot.c.old	2007-07-10 01:26:07.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/arch/i386/kernel/smpboot.c	2007-07-10 01:26:18.000000000 +0200
> @@ -117,7 +117,7 @@
>   * has made sure it's suitably aligned.
>   */
>  
> -static unsigned long __devinit setup_trampoline(void)
> +static unsigned long __cpuinit setup_trampoline(void)
>  {
>  	memcpy(trampoline_base, trampoline_data, trampoline_end - trampoline_data);
>  	return virt_to_phys(trampoline_base);
> 

This one hasn't been merged yet.

-- 
Frank
