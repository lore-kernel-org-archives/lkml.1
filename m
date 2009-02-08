Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbZBHJMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbZBHJMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 04:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZBHJMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 04:12:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34252 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZBHJMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 04:12:30 -0500
Date: Sun, 8 Feb 2009 10:11:57 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PCI PM: Do not disable and enable bridges during
	suspend-resume
Message-ID: <20090208091157.GD8040@elf.ucw.cz>
References: <200902012229.27517.rjw@sisk.pl> <200902012231.17933.rjw@sisk.pl> <20090207094720.GA1507@ucw.cz> <200902071448.13877.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902071448.13877.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > their standard config spaces are restored.  Fix this by not attempting
> > > to disable bridges during suspend and enable them during resume.
> > ...
> > > @@ -428,16 +428,18 @@ static int pci_pm_default_resume(struct 
> > >  {
> > >  	pci_fixup_device(pci_fixup_resume, pci_dev);
> > >  
> > > -	if (!pci_is_bridge(pci_dev))
> > > -		pci_enable_wake(pci_dev, PCI_D0, false);
> > > +	if (pci_is_bridge(pci_dev))
> > > +		return 0;
> > >  
> > > +	pci_enable_wake(pci_dev, PCI_D0, false);
> > >  	return pci_pm_reenable_device(pci_dev);
> > >  }
> > 
> > Are you sure? This goes from doing reenable_device to not doing it for
> > bridges, seemingly contradicting changelog?
> 
> Can you explain what you mean, please?

It looks to me like the patch does not match the changelog.

Changelog says "enable bridge during resume", but code does return 0
if it seems bridge.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
