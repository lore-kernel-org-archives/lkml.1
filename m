Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbYBGTIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbYBGTIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759760AbYBGTII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:08:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:20368 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759296AbYBGTIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:08:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LzISZ0q0hO5GQqhZ89kB49eqf2VsdimguAUb7z/YFc1DquFQdprS4vMGkljxixUl/CGv/48Qq4UxvCz7eim8DHyjhHw3bZmtqpqOECisrbVs3oydyJbNckywDjqVve0UDBlhJOe5PcKe5F5iJOR44rLq54TlmXjCGJujI0Ina94=
Message-ID: <6101e8c40802071108i4e66be5r4e9a6e77421beaae@mail.gmail.com>
Date: Thu, 7 Feb 2008 20:08:04 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] Use global TLB flushes in MTRR code
Cc: mingo@elte.hu, davej@codemonkey.org.uk, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080207190241.GA9449@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080207190241.GA9449@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and old-stable (eg 2.6.22)?

On 2/7/08, Andi Kleen <andi@firstfloor.org> wrote:
> [probably stable material too]
>
> Use global TLB flushes in MTRR code
>
> Obviously kernel mappings should be flushed here too.
>
> Signed-off-by: Andi Kleen <ak@suse.de>
>
> ---
>  arch/x86/kernel/cpu/mtrr/generic.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux/arch/x86/kernel/cpu/mtrr/generic.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/cpu/mtrr/generic.c
> +++ linux/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -356,7 +356,7 @@ static void prepare_set(void) __acquires
>  	}
>
>  	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
> -	__flush_tlb();
> +	__flush_tlb_all();
>
>  	/*  Save MTRR state */
>  	rdmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
> @@ -368,7 +368,7 @@ static void prepare_set(void) __acquires
>  static void post_set(void) __releases(set_atomicity_lock)
>  {
>  	/*  Flush TLBs (no need to flush caches - they are disabled)  */
> -	__flush_tlb();
> +	__flush_tlb_all();
>
>  	/* Intel (P6) standard MTRRs */
>  	mtrr_wrmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
