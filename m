Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYBIKjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYBIKjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 05:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYBIKjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 05:39:25 -0500
Received: from www.tglx.de ([62.245.132.106]:59001 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYBIKjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 05:39:24 -0500
Date: Sat, 9 Feb 2008 11:39:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/3] Enable ACPI extended century handling for 32bit
 too
In-Reply-To: <20080208121455.228C31B41BB@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802091136380.3145@apollo.tec.linutronix.de>
References: <20080208114.066167427@suse.de> <20080208121455.228C31B41BB@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Andi Kleen wrote:

> 
> Not that it matters much, see comment in the code.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/kernel/rtc.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux/arch/x86/kernel/rtc.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/rtc.c
> +++ linux/arch/x86/kernel/rtc.c
> @@ -112,12 +112,13 @@ unsigned long mach_get_cmos_time(void)
>  	mon = CMOS_READ(RTC_MONTH);
>  	year = CMOS_READ(RTC_YEAR);
>  
> -#if defined(CONFIG_ACPI) && defined(CONFIG_X86_64)
> -	/* CHECKME: Is this really 64bit only ??? */
> +	/*
> +	 * On 32bit not strictly needed because the world ends in 2038
> +	 * and the code can handle that with the 2 digit heuristics.
> +	 */
>  	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
>  	    acpi_gbl_FADT.century)
>  		century = CMOS_READ(acpi_gbl_FADT.century);

How does this compile with CONFIG_ACPI=n ?

Thanks,
	tglx
