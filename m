Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYDLPgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYDLPgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYDLPgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:36:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4106 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753181AbYDLPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:36:33 -0400
Date: Sat, 12 Apr 2008 11:36:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: Re: [linux-pm] s2ram: warn when interrupts should be disabled but
 are not
In-Reply-To: <20080412095311.GA1729@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0804121135350.10697-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Pavel Machek wrote:

> ---
> commit fc3bccaf69e6c05464e7154369639bd5c96ccdc1
> tree bf960093ddb840242a00b4ec456ec79472b1c2ad
> parent 308e9d5309f378209e931f63f729806ec0a4d9f1
> author Pavel <pavel@amd.ucw.cz> Sat, 12 Apr 2008 11:52:05 +0200
> committer Pavel <pavel@amd.ucw.cz> Sat, 12 Apr 2008 11:52:05 +0200
> 
>  drivers/ata/ahci.c |    2 +-
>  drivers/base/sys.c |    3 +++
>  2 files changed, 4 insertions(+), 1 deletions(-)

What happened to the drivers/ata/ahci.c part of the patch?

> diff --git a/drivers/base/sys.c b/drivers/base/sys.c
> index 8e13fd9..e214467 100644
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -22,6 +22,7 @@ #include <linux/string.h>
>  #include <linux/pm.h>
>  #include <linux/device.h>
>  #include <linux/mutex.h>
> +#include <linux/hardirq.h>
>  
>  #include "base.h"
>  
> @@ -367,6 +368,7 @@ int sysdev_suspend(pm_message_t state)
>  			/* Call auxillary drivers first */
>  			list_for_each_entry(drv, &cls->drivers, entry) {
>  				if (drv->suspend) {
> +					WARN_ON(!irqs_disabled());
>  					ret = drv->suspend(sysdev, state);
>  					if (ret)
>  						goto aux_driver;
> @@ -442,6 +444,7 @@ int sysdev_resume(void)
>  		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
>  			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
>  
> +			WARN_ON(!irqs_disabled());
>  			__sysdev_resume(sysdev);
>  		}
>  	}

Alan Stern

