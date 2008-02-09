Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYBIK2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYBIK2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 05:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYBIK2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 05:28:15 -0500
Received: from www.tglx.de ([62.245.132.106]:34884 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYBIK2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 05:28:14 -0500
Date: Sat, 9 Feb 2008 11:28:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] Only do century BCD conversion when we know the
 RTC is BCD
In-Reply-To: <20080208114.066167427@suse.de>
Message-ID: <alpine.LFD.1.00.0802091108170.3145@apollo.tec.linutronix.de>
References: <20080208114.066167427@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Andi Kleen wrote:

> 
> Minor logic fix. The century change was previously always BCD,
> even when the CMOS data would report itself not being BCD.

Where was it previously always BCD ?

The code flow is taken 1:1 from the original x8664 code. Just the
BCD_TO_BIN code has been made conditional for i386, which is not
chanining the logic at all, because RTC_ALWAYS_BCD is always true on
x8664.

While your change does not do any harm due to BCD_TO_BIN(0) = 0, it
is just not fixing anything.

Thanks,
	tglx
 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/kernel/rtc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/arch/x86/kernel/rtc.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/rtc.c
> +++ linux/arch/x86/kernel/rtc.c
> @@ -130,10 +130,10 @@ unsigned long mach_get_cmos_time(void)
>  		BCD_TO_BIN(day);
>  		BCD_TO_BIN(mon);
>  		BCD_TO_BIN(year);
> +		BCD_TO_BIN(century);
>  	}
>  
>  	if (century) {
> -		BCD_TO_BIN(century);
>  		year += century * 100;
>  		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
>  	} else {
> 
