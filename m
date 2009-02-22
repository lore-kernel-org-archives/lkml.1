Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbZBVWk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbZBVWk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZBVWku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:40:50 -0500
Received: from smtp5.welho.com ([213.243.153.39]:51596 "EHLO smtp5.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbZBVWkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:40:49 -0500
Date: Mon, 23 Feb 2009 00:42:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 1/2] PM: Split up sysdev_[suspend|resume] from
	device_power_[down|up]
Message-ID: <20090222224242.GD4485@localhost.pp.htv.fi>
References: <200902221837.49396.rjw@sisk.pl> <200902221838.51548.rjw@sisk.pl> <20090222205654.GC4485@localhost.pp.htv.fi> <alpine.LFD.2.00.0902221306090.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902221306090.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 01:07:28PM -0800, Linus Torvalds wrote:
> 
> 
> On Sun, 22 Feb 2009, Adrian Bunk wrote:
> > ...
> >   MODPOST 2586 modules
> > ERROR: "sysdev_resume" [arch/x86/kernel/apm.ko] undefined!
> > ERROR: "sysdev_suspend" [arch/x86/kernel/apm.ko] undefined!
> > make[2]: *** [__modpost] Error 1
> 
> Ahh. device_power_[down|up] were EXPORT_SYMBOL_GPL, so now that we've 
> split them, so must sysdev_[suspend|resume] be.
> 
> Does this fix it?


Thanks, works fine.


> 		Linus
> ---
>  drivers/base/sys.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/sys.c b/drivers/base/sys.c
> index c98c31e..ef2055e 100644
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -432,6 +432,7 @@ aux_driver:
>  	}
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(sysdev_suspend);
>  
>  
>  /**
> @@ -463,6 +464,7 @@ int sysdev_resume(void)
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(sysdev_resume);
>  
>  
>  int __init system_bus_init(void)

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

