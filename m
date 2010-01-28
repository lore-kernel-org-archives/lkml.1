Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219Ab0A1Qe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0A1Qe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 11:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050Ab0A1Qe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 11:34:27 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:31603 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab0A1Qe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 11:34:26 -0500
Date: Thu, 28 Jan 2010 08:33:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: linux-next: Tree for January 18 (pci + pm)
Message-Id: <20100128083322.34679625.randy.dunlap@oracle.com>
In-Reply-To: <201001200004.07654.rjw@sisk.pl>
References: <20100118195743.b45f119e.sfr@canb.auug.org.au>
	<20100118154424.d54c0e3e.randy.dunlap@oracle.com>
	<201001200004.07654.rjw@sisk.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B61BC59.0128:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 00:04:07 +0100 Rafael J. Wysocki wrote:

> On Tuesday 19 January 2010, Randy Dunlap wrote:
> > On Mon, 18 Jan 2010 19:57:43 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20100114:
> > 
> > 
> > drivers/pci/pci-driver.c: In function 'pci_pm_runtime_resume':
> > drivers/pci/pci-driver.c:991: error: implicit declaration of function 'pci_pm_default_resume_early'
> > drivers/pci/pci-driver.c: At top level:
> > drivers/pci/pci-driver.c:1027: error: 'pci_pm_prepare' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1028: error: 'pci_pm_complete' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1029: error: 'pci_pm_suspend' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1030: error: 'pci_pm_resume' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1031: error: 'pci_pm_freeze' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1032: error: 'pci_pm_thaw' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1033: error: 'pci_pm_poweroff' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1034: error: 'pci_pm_restore' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1035: error: 'pci_pm_suspend_noirq' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1036: error: 'pci_pm_resume_noirq' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1037: error: 'pci_pm_freeze_noirq' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1038: error: 'pci_pm_thaw_noirq' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1039: error: 'pci_pm_poweroff_noirq' undeclared here (not in a function)
> > drivers/pci/pci-driver.c:1040: error: 'pci_pm_restore_noirq' undeclared here (not in a function)
> > 
> > 
> > partial config:
> > 
> > CONFIG_PM=y
> > # CONFIG_PM_DEBUG is not set
> > # CONFIG_SUSPEND is not set
> > # CONFIG_HIBERNATION is not set
> > CONFIG_PM_RUNTIME=y
> > CONFIG_PM_OPS=y
> > 
> > 
> > Full config is attached.
> 
> Ah, too many ifdefs.
> 
> Thanks, the patch below fixes that for me.
> 
> Rafael

Rafael, Jesse:

We still need this patch in linux-next (20100128).
Thanks.


> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PCI / PM: Fix compilation for set CONFIG_PM_RUNTIME and CONFIG_PM_SLEEP unset
> 
> Fix failure to compile drivers/pci/pci-driver.c for CONFIG_PM_RUNTIME
> set and CONFIG_PM_SLEEP is unset, introduced by the PCI run-time
> power management patches.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/pci/pci-driver.c |   61 +++++++++++++++++++++++++++--------------------
>  1 file changed, 36 insertions(+), 25 deletions(-)
> 
> Index: linux-2.6/drivers/pci/pci-driver.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-driver.c
> +++ linux-2.6/drivers/pci/pci-driver.c
> @@ -405,6 +405,35 @@ static void pci_device_shutdown(struct d
>  	pci_msix_shutdown(pci_dev);
>  }
>  
> +#ifdef CONFIG_PM_OPS
> +
> +/* Auxiliary functions used for system resume and run-time resume. */
> +
> +/**
> + * pci_restore_standard_config - restore standard config registers of PCI device
> + * @pci_dev: PCI device to handle
> + */
> +static int pci_restore_standard_config(struct pci_dev *pci_dev)
> +{
> +	pci_update_current_state(pci_dev, PCI_UNKNOWN);
> +
> +	if (pci_dev->current_state != PCI_D0) {
> +		int error = pci_set_power_state(pci_dev, PCI_D0);
> +		if (error)
> +			return error;
> +	}
> +
> +	return pci_restore_state(pci_dev);
> +}
> +
> +static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
> +{
> +	pci_restore_standard_config(pci_dev);
> +	pci_fixup_device(pci_fixup_resume_early, pci_dev);
> +}
> +
> +#endif
> +
>  #ifdef CONFIG_PM_SLEEP
>  
>  /*
> @@ -521,29 +550,6 @@ static int pci_legacy_resume(struct devi
>  
>  /* Auxiliary functions used by the new power management framework */
>  
> -/**
> - * pci_restore_standard_config - restore standard config registers of PCI device
> - * @pci_dev: PCI device to handle
> - */
> -static int pci_restore_standard_config(struct pci_dev *pci_dev)
> -{
> -	pci_update_current_state(pci_dev, PCI_UNKNOWN);
> -
> -	if (pci_dev->current_state != PCI_D0) {
> -		int error = pci_set_power_state(pci_dev, PCI_D0);
> -		if (error)
> -			return error;
> -	}
> -
> -	return pci_restore_state(pci_dev);
> -}
> -
> -static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
> -{
> -	pci_restore_standard_config(pci_dev);
> -	pci_fixup_device(pci_fixup_resume_early, pci_dev);
> -}
> -
>  static void pci_pm_default_resume(struct pci_dev *pci_dev)
>  {
>  	pci_fixup_device(pci_fixup_resume, pci_dev);
> @@ -607,6 +613,13 @@ static void pci_pm_complete(struct devic
>  		drv->pm->complete(dev);
>  }
>  
> +#else /* !CONFIG_PM_SLEEP */
> +
> +#define pci_pm_prepare	NULL
> +#define pci_pm_complete	NULL
> +
> +#endif /* !CONFIG_PM_SLEEP */
> +
>  #ifdef CONFIG_SUSPEND
>  
>  static int pci_pm_suspend(struct device *dev)
> @@ -943,8 +956,6 @@ static int pci_pm_restore(struct device 
>  
>  #endif /* !CONFIG_HIBERNATION */
>  
> -#endif /* !CONFIG_PM_SLEEP */
> -
>  #ifdef CONFIG_PM_RUNTIME
>  
>  static int pci_pm_runtime_suspend(struct device *dev)


---
~Randy
