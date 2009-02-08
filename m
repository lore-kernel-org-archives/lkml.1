Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZBHNX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZBHNX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 08:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZBHNXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 08:23:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38313 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbZBHNXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 08:23:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 1/3] PCI PM: Do not disable and enable bridges during suspend-resume
Date: Sun, 8 Feb 2009 14:23:08 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200902012229.27517.rjw@sisk.pl> <200902071448.13877.rjw@sisk.pl> <20090208091157.GD8040@elf.ucw.cz>
In-Reply-To: <20090208091157.GD8040@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902081423.08991.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Pavel Machek wrote:
> Hi!
> 
> > > > their standard config spaces are restored.  Fix this by not attempting
> > > > to disable bridges during suspend and enable them during resume.
> > > ...
> > > > @@ -428,16 +428,18 @@ static int pci_pm_default_resume(struct 
> > > >  {
> > > >  	pci_fixup_device(pci_fixup_resume, pci_dev);
> > > >  
> > > > -	if (!pci_is_bridge(pci_dev))
> > > > -		pci_enable_wake(pci_dev, PCI_D0, false);
> > > > +	if (pci_is_bridge(pci_dev))
> > > > +		return 0;
> > > >  
> > > > +	pci_enable_wake(pci_dev, PCI_D0, false);
> > > >  	return pci_pm_reenable_device(pci_dev);
> > > >  }
> > > 
> > > Are you sure? This goes from doing reenable_device to not doing it for
> > > bridges, seemingly contradicting changelog?
> > 
> > Can you explain what you mean, please?
> 
> It looks to me like the patch does not match the changelog.
> 
> Changelog says "enable bridge during resume", but code does return 0
> if it seems bridge.

Ah, I see.  The changelog was supposed to mean that the bridges would not
be disabled during suspend and also would not be enabled during resume
(which shouldn't be necessary, since they would be automatically enabled
as a result of restoring their configuration registers).

Thanks,
Rafael


> 									Pavel


-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
