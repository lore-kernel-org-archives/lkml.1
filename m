Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbZBGJvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbZBGJvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 04:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZBGJvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 04:51:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41856 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZBGJvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 04:51:35 -0500
Date: Sat, 7 Feb 2009 10:50:42 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PCI PM: Do not disable and enable bridges during
	suspend-resume
Message-ID: <20090207094720.GA1507@ucw.cz>
References: <200902012229.27517.rjw@sisk.pl> <200902012231.17933.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902012231.17933.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> their standard config spaces are restored.  Fix this by not attempting
> to disable bridges during suspend and enable them during resume.

...

> Index: linux-2.6/drivers/pci/pci-driver.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-driver.c
> +++ linux-2.6/drivers/pci/pci-driver.c
> @@ -428,16 +428,18 @@ static int pci_pm_default_resume(struct 
>  {
>  	pci_fixup_device(pci_fixup_resume, pci_dev);
>  
> -	if (!pci_is_bridge(pci_dev))
> -		pci_enable_wake(pci_dev, PCI_D0, false);
> +	if (pci_is_bridge(pci_dev))
> +		return 0;
>  
> +	pci_enable_wake(pci_dev, PCI_D0, false);
>  	return pci_pm_reenable_device(pci_dev);
>  }

Are you sure? This goes from doing reenable_device to not doing it for
bridges, seemingly contradicting changelog?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
