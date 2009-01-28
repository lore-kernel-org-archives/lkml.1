Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZA1O0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZA1O0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZA1O0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 09:26:38 -0500
Received: from relay2.sgi.com ([192.48.179.30]:52991 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbZA1O0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:26:37 -0500
Date: Wed, 28 Jan 2009 08:26:35 -0600
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 01/14] Add definitions of x86_64 GRU MMRs.
Message-ID: <20090128142634.GA27540@sgi.com>
References: <20090122174917.563627000@sgi.com> <20090122175025.475956000@sgi.com> <20090128013527.005648cc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128013527.005648cc.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 01:35:27AM -0800, Andrew Morton wrote:
> On Thu, 22 Jan 2009 11:49:18 -0600 steiner@sgi.com wrote:
> 
> > Add definitions for x86_64 GRU MMRs.
> 
> Breaks x86_32:
> 
> arch/x86/include/asm/uv/uv_mmrs.h:409: error: width of 'real_time_cmpb' exceeds its type
> arch/x86/include/asm/uv/uv_mmrs.h:425: error: width of 'real_time_cmpc' exceeds its type
> arch/x86/include/asm/uv/uv_mmrs.h:441: error: width of 'real_time_cmpd' exceeds its type
> arch/x86/include/asm/uv/uv_mmrs.h:491: error: width of 'address' exceeds its type
> <etc>
> 
> due to stuff flike
> 
> 	unsigned long	real_time_cmpb : 56;  /* RW */
> 
> 
> this:
> 
> --- a/arch/x86/kernel/io_apic.c~a
> +++ a/arch/x86/kernel/io_apic.c
> @@ -59,8 +59,11 @@
>  #include <asm/setup.h>
>  #include <asm/irq_remapping.h>
>  #include <asm/hpet.h>
> +
> +#ifdef CONFIG_X86_64
>  #include <asm/uv/uv_hub.h>
>  #include <asm/uv/uv_irq.h>
> +#endif
>  
>  #include <mach_ipi.h>
>  #include <mach_apic.h>
> _
> 
> seems sufficient, but perhaps it'd be better if it was done within the
> header?

There is no reason that any of the UV definitions should be needed for 32-bit
platforms. I'll find the best way to avoid them....


--- jack
