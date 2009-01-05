Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZAENRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZAENRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZAENQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:16:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZAENQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:16:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [RFC][PATCH 2/10] PCI PM: Add suspend counterpart of pci_reenable_device
Date: Mon, 5 Jan 2009 14:17:34 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200812190049.34343.rjw@sisk.pl> <200812302337.10257.rjw@sisk.pl> <20090105104946.GE27199@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20090105104946.GE27199@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051417.35080.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009, Pavel Machek wrote:
> Hi!
> 
> > PCI devices without drivers are not disabled during suspend and
> > hibernation, but they are enabled during resume, with the help of
> > pci_reenable_device(), so there is an unbalanced execution of
> > pcibios_enable_device() in the resume code path.
> > 
> > To correct this introduce function pci_disable_enabled_device()
> > that will disable the argument device, if it is enabled when the
> > function is being run, without updating the device's pci_dev
> > structure and use it in the suspend code path to balance the
> > pci_reenable_device() executed during resume.
> 
> > +/**
> > + * pci_disable_enabled_device - Disable device without updating enable_cnt
> > + * @dev: PCI device to disable
> > + *
> > + * NOTE: This function is a backend of PCI power management routines and is
> > + * not supposed to be called drivers.
> 
> "by drivers"?

Yes, thanks.

> > @@ -441,7 +455,10 @@ static int pci_pm_suspend(struct device 
> >  		}
> >  	} else if (pci_has_legacy_pm_support(pci_dev)) {
> >  		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
> > +	} else {
> > +		pci_default_pm_suspend_early(pci_dev);
> >  	}
> > +
> >  	pci_fixup_device(pci_fixup_suspend, pci_dev);
> >  
> >  	return error;
> 
> So tre fixup runs on the disabled device?

Yes, but the device's config space is still available at this point.
 
> Acked-by: Pavel Machek <Pavel@suse.cz>

Thanks,
Rafael
