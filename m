Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbYB0EcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbYB0EcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYB0EcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:32:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:17767 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYB0EcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:32:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kuhoy/39cNfX35Mtv2bhhUP3JguxultdVAU31tSO8v6MBd015WqnjYLZVv87dWfN6qHQFpTGobOdQBVSOpK06Mp6ySKPEYNdYpx1E5fOr1g5t1CN8Rvx/S93D0AXGMzZOZUY22C281xtLkMB6266KO6LtaI8M4in/QAhM81Smnw=
Date: Wed, 27 Feb 2008 12:38:16 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: randy.dunlap@oracle.com, davej@codemonkey.org.uk, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] preset_lpj and loops_per_jiffy initialize adjust
Message-ID: <20080227043816.GA2883@darkstar.te-china.tietoenator.com>
References: <20080227031818.GA2754@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227031818.GA2754@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 11:18:18AM +0800, Dave Young wrote:
> Make preset_lpj static.

This will make the boot_delay build fail, these two patches should
become one patch indeed, please ignore.

I will send the new patch again after a while.

> Give preset lpj value to loops_per_jiffy in lpj_setup.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> 
> ---
> init/calibrate.c |    6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -upr linux/init/calibrate.c linux.new/init/calibrate.c
> --- linux/init/calibrate.c	2008-02-27 10:54:15.000000000 +0800
> +++ linux.new/init/calibrate.c	2008-02-27 10:54:26.000000000 +0800
> @@ -9,10 +9,11 @@
>  #include <linux/init.h>
>  #include <linux/timex.h>
>  
> -unsigned long preset_lpj;
> +static unsigned long preset_lpj;
>  static int __init lpj_setup(char *str)
>  {
> -	preset_lpj = simple_strtoul(str,NULL,0);
> +	loops_per_jiffy = simple_strtoul(str, NULL, 0);
> +	preset_lpj = 1;
>  	return 1;
>  }
>  
> @@ -117,7 +118,6 @@ void __cpuinit calibrate_delay(void)
>  	int lps_precision = LPS_PREC;
>  
>  	if (preset_lpj) {
> -		loops_per_jiffy = preset_lpj;
>  		printk("Calibrating delay loop (skipped)... "
>  			"%lu.%02lu BogoMIPS preset\n",
>  			loops_per_jiffy/(500000/HZ),
