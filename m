Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZAEKt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZAEKt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZAEKtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:49:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40871 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZAEKtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:49:49 -0500
Date: Mon, 5 Jan 2009 11:49:47 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/10] PCI PM: Add suspend counterpart of pci_reenable_device
Message-ID: <20090105104946.GE27199@atrey.karlin.mff.cuni.cz>
References: <200812190049.34343.rjw@sisk.pl> <200812281607.28007.rjw@sisk.pl> <200812302333.45560.rjw@sisk.pl> <200812302337.10257.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812302337.10257.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> PCI devices without drivers are not disabled during suspend and
> hibernation, but they are enabled during resume, with the help of
> pci_reenable_device(), so there is an unbalanced execution of
> pcibios_enable_device() in the resume code path.
> 
> To correct this introduce function pci_disable_enabled_device()
> that will disable the argument device, if it is enabled when the
> function is being run, without updating the device's pci_dev
> structure and use it in the suspend code path to balance the
> pci_reenable_device() executed during resume.

> +/**
> + * pci_disable_enabled_device - Disable device without updating enable_cnt
> + * @dev: PCI device to disable
> + *
> + * NOTE: This function is a backend of PCI power management routines and is
> + * not supposed to be called drivers.

"by drivers"?

> @@ -441,7 +455,10 @@ static int pci_pm_suspend(struct device 
>  		}
>  	} else if (pci_has_legacy_pm_support(pci_dev)) {
>  		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
> +	} else {
> +		pci_default_pm_suspend_early(pci_dev);
>  	}
> +
>  	pci_fixup_device(pci_fixup_suspend, pci_dev);
>  
>  	return error;

So tre fixup runs on the disabled device?

Acked-by: Pavel Machek <Pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
