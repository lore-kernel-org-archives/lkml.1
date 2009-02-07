Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZBGNtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZBGNtO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 08:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZBGNs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 08:48:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35309 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZBGNs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 08:48:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 1/3] PCI PM: Do not disable and enable bridges during suspend-resume
Date: Sat, 7 Feb 2009 14:48:13 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200902012229.27517.rjw@sisk.pl> <200902012231.17933.rjw@sisk.pl> <20090207094720.GA1507@ucw.cz>
In-Reply-To: <20090207094720.GA1507@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071448.13877.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 February 2009, Pavel Machek wrote:
> Hi!
> 
> > their standard config spaces are restored.  Fix this by not attempting
> > to disable bridges during suspend and enable them during resume.
> 
> ...
> 
> > Index: linux-2.6/drivers/pci/pci-driver.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/pci-driver.c
> > +++ linux-2.6/drivers/pci/pci-driver.c
> > @@ -428,16 +428,18 @@ static int pci_pm_default_resume(struct 
> >  {
> >  	pci_fixup_device(pci_fixup_resume, pci_dev);
> >  
> > -	if (!pci_is_bridge(pci_dev))
> > -		pci_enable_wake(pci_dev, PCI_D0, false);
> > +	if (pci_is_bridge(pci_dev))
> > +		return 0;
> >  
> > +	pci_enable_wake(pci_dev, PCI_D0, false);
> >  	return pci_pm_reenable_device(pci_dev);
> >  }
> 
> Are you sure? This goes from doing reenable_device to not doing it for
> bridges, seemingly contradicting changelog?

Can you explain what you mean, please?

Thanks,
Rafael
