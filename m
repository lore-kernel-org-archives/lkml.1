Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZI3Tk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZI3Tk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZI3Tk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:40:56 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62357 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZI3Tky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=BPcz1UdSiq/xmGZphLY16NtOWc7BAh83/w3aeMsNv865yVLptLlIKDTukg1oL+c43z
         vF3C0MNl9fUiMBD+ish9CFahBv/ZftR6Pf+2P14ybLhzVsfZG2mmyj85rf6EXfMoAISn
         KPFGGjQkuFsLEiai3n9e/NYgFQ/+eb9E0cDLU=
Date: Wed, 30 Sep 2009 21:40:49 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>, torvalds@osdl.org
Subject: Re: x86: mce: Please revert
 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20090930194049.GA17712@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Borislav Petkov <borislav.petkov@amd.com>, torvalds@osdl.org
References: <20090930140904.GA6150@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090930140904.GA6150@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 04:09:04PM +0200, Andi Kleen wrote:
> 
> Can someone please revert this incorrect commit that's in mainline
> now? 
> 
> Obviously kernels compiled with AMD support can still run on non
> AMD systems, so messages like this can never be removed at compile time.
> 
> -andi
> 
> Commit 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
> Author: Borislav Petkov <borislav.petkov@amd.com>
> Date:   Tue Jul 28 14:47:10 2009 +0200
> 
>     x86, mce: do not compile mcelog message on AMD
>     
>     Now that decoding is done in-kernel, suppress mcelog message part.
>     
>     CC: Andi Kleen <andi@firstfloor.org>
>     Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index b82866f..9bfe9d2 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -222,7 +222,10 @@ static void print_mce_head(void)
>  static void print_mce_tail(void)
>  {
>         printk(KERN_EMERG "This is not a software problem!\n"
> -              "Run through mcelog --ascii to decode and contact your hardware vendor\n");
> +#if (!defined(CONFIG_EDAC) || !defined(CONFIG_CPU_SUP_AMD))

how about

	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
		pr_emerg("Run through mcelog --ascii to decode and contact your	hardware vendor\n");

instead?

> +              "Run through mcelog --ascii to decode and contact your hardware vendor\n"
> +#endif
> +              );
>  }
>  
>  #define PANIC_TIMEOUT 5 /* 5 seconds */

-- 
Regards/Gruss,
    Boris.
