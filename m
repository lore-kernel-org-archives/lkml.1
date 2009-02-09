Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZBIJjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZBIJjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZBIJj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:39:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39298 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbZBIJj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:39:27 -0500
Date: Mon, 9 Feb 2009 10:39:26 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PCI PM: Do not disable and enable bridges during suspend-resume
Message-ID: <20090209093926.GA4358@atrey.karlin.mff.cuni.cz>
References: <200902012229.27517.rjw@sisk.pl> <200902071448.13877.rjw@sisk.pl> <20090208091157.GD8040@elf.ucw.cz> <200902081423.08991.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902081423.08991.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sunday 08 February 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > > > their standard config spaces are restored.  Fix this by not attempting
> > > > > to disable bridges during suspend and enable them during resume.
> > > > ...
> > > > > @@ -428,16 +428,18 @@ static int pci_pm_default_resume(struct 
> > > > >  {
> > > > >  	pci_fixup_device(pci_fixup_resume, pci_dev);
> > > > >  
> > > > > -	if (!pci_is_bridge(pci_dev))
> > > > > -		pci_enable_wake(pci_dev, PCI_D0, false);
> > > > > +	if (pci_is_bridge(pci_dev))
> > > > > +		return 0;
> > > > >  
> > > > > +	pci_enable_wake(pci_dev, PCI_D0, false);
> > > > >  	return pci_pm_reenable_device(pci_dev);
> > > > >  }
> > > > 
> > > > Are you sure? This goes from doing reenable_device to not doing it for
> > > > bridges, seemingly contradicting changelog?
> > > 
> > > Can you explain what you mean, please?
> > 
> > It looks to me like the patch does not match the changelog.
> > 
> > Changelog says "enable bridge during resume", but code does return 0
> > if it seems bridge.
> 
> Ah, I see.  The changelog was supposed to mean that the bridges would not
> be disabled during suspend and also would not be enabled during resume
> (which shouldn't be necessary, since they would be automatically enabled
> as a result of restoring their configuration registers).

You can add my acked-by: when you resubmit with fixed
changelog... :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
