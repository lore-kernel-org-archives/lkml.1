Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbYDUNeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbYDUNeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932920AbYDUN1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:27:36 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60007 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588AbYDUN1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:27:34 -0400
Date: Mon, 21 Apr 2008 16:27:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       hpa@zytor.com, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080421132705.GG6011@cs181133002.pp.htv.fi>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080421120054.GA6788@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 02:00:54PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > I shouldn't send bug reports at 3 in the morning...
> > 
> > Attached is the .config for both Voyager build errors I reported.
> 
> thanks, the three patches below should fix it.
>...
> 	Ingo
>...
> --- linux-x86.q.orig/arch/x86/kernel/setup.c
> +++ linux-x86.q/arch/x86/kernel/setup.c
> @@ -21,8 +21,10 @@ EXPORT_SYMBOL(boot_cpu_physical_apicid);
>  DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
>  EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
>  
> +#ifndef CONFIG_X86_VOYAGER
>  /* Bitmask of physically existing CPUs */
>  physid_mask_t phys_cpu_present_map;
> +#endif
>...

Alexey noted that phys_cpu_present_map for Voyager and !Voyager also 
have different types and suggested to make the Voyager one static 
instead (additional renaming of the Voyager one also makes sense).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

