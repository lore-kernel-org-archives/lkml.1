Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbXDNRGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbXDNRGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXDNRGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:06:04 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:58566 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXDNRGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:06:03 -0400
Date: Sat, 14 Apr 2007 20:04:51 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com, sfr@canb.auug.org.au
Subject: Re: {Spam?} [PATCH] Remove all traces of legacy power management.
Message-ID: <20070414180451.GA4525@linux-mips.org>
References: <Pine.LNX.4.64.0704141125410.15722@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704141125410.15722@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 12:49:54PM -0400, Robert P. J. Day wrote:
> Date:	Sat, 14 Apr 2007 12:49:54 -0400 (EDT)
> From:	"Robert P. J. Day" <rpjday@mindspring.com>
> To:	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> cc:	dhowells@redhat.com, Ralf Baechle <ralf@linux-mips.org>,
> 	sfr@canb.auug.org.au
> Subject: {Spam?} [PATCH] Remove all traces of legacy power management.
> Content-Type: TEXT/PLAIN; charset=US-ASCII
> 
> 
> Remove everything related to legacy power management.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

> diff --git a/arch/mips/au1000/common/power.c b/arch/mips/au1000/common/power.c
> index 3901e8e..f3685d6 100644
> --- a/arch/mips/au1000/common/power.c
> +++ b/arch/mips/au1000/common/power.c
> @@ -278,13 +278,11 @@ static int pm_do_sleep(ctl_table * ctl, int write, struct file *file,
>  		p = buf;
>  		sleep_ticks = simple_strtoul(p, &p, 0);
>  #endif
> -		retval = pm_send_all(PM_SUSPEND, (void *) 2);
> 
>  		if (retval)
>  			return retval;
> 
>  		au_sleep();
> -		retval = pm_send_all(PM_RESUME, (void *) 0);
>  	}
>  	return retval;
>  }
> @@ -297,12 +295,10 @@ static int pm_do_suspend(ctl_table * ctl, int write, struct file *file,
>  	if (!write) {
>  		*len = 0;
>  	} else {
> -		retval = pm_send_all(PM_SUSPEND, (void *) 2);
>  		if (retval)
>  			return retval;
>  		suspend_mode = 1;
> 
> -		retval = pm_send_all(PM_RESUME, (void *) 0);
>  	}
>  	return retval;
>  }

Both segments leave the variable retval as zero initialized and only used
for the return value ...  I'm not sure what these functions actually
should do - but after your patches they have essentially become glorified
nops.

  Ralf
