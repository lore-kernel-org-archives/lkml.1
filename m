Return-Path: <linux-kernel-owner+w=401wt.eu-S933122AbXFEPcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbXFEPcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbXFEPci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:32:38 -0400
Received: from waste.org ([66.93.16.53]:43073 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbXFEPch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:32:37 -0400
Date: Tue, 5 Jun 2007 10:32:21 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com
Subject: Re: [PATCH 3/6] lguest suppress IDE probing
Message-ID: <20070605153221.GV11115@waste.org>
References: <1181055308.14054.36.camel@localhost.localdomain> <1181055396.14054.38.camel@localhost.localdomain> <1181055483.14054.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181055483.14054.40.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 12:58:03AM +1000, Rusty Russell wrote:
> The IDE probe is the slowest part of boot: by suppressing it we cut
> boot from from 3 seconds to half a second.
> 
> AFAICT, the commandline is the easiest way to suppress the probing.

Switching to libata accomplishes the same and isn't quite as ugly. I'd
just drop this patch and put a note about it in lguest.txt, as libata
seems to be the fashionable thing to do these days.

> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/lguest/lguest.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> ===================================================================
> --- a/drivers/lguest/lguest.c
> +++ b/drivers/lguest/lguest.c
> @@ -605,6 +605,12 @@ __init void lguest_init(void *boot)
>  	acpi_disabled = 1;
>  	acpi_ht = 0;
>  #endif
> +#ifdef CONFIG_BLK_DEV_IDE
> +	/* Saves three seconds off boot time. */
> +	strcat(boot_command_line,
> +	       " ide0=noprobe ide1=noprobe ide2=noprobe"
> +	       " ide3=noprobe ide4=noprobe ide5=noprobe");
> +#endif
>  
>  	add_preferred_console("hvc", 0, NULL);
>  
> 

-- 
Mathematics is the supreme nostalgia of our time.
