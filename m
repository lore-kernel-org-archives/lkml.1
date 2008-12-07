Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYLGNPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYLGNPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 08:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYLGNPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 08:15:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33648 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbYLGNO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 08:14:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sun, 7 Dec 2008 14:14:12 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0812061858160.16554-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0812061858160.16554-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071414.13143.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 7 of December 2008, Alan Stern wrote:
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> 
> > > Rafael, I'd be happy to help with fixing up the USB PCI PM code.  At
> > > this point I'm not sure exactly what's needed, though.  For instance,
> > > is there any compelling reason to switch over to the new dev_pm_ops
> > > approach?
> > 
> > Certainly not at the moment.  There will be a reason some time after .29.
> > 
> > That said, it apparently is possible to clean up the resume callbacks of PCI
> > USB controllers, as mentioned here: http://lkml.org/lkml/2008/12/6/38
> > 
> > > And what should the correct sequence of calls be?
> > 
> > Well, that's something I'm not exactly sure about myself.  Surely it seems
> > reasonable to call pci_restore_state() with interrupts disabled and do the rest
> > of resume after that.  Also, I think that the core could execute things like
> > pci_enable_device() during resume and pci_set_power_state()/pci_enable_wake()
> > on suspend so that the drivers didn't have to.  This way we could reduce code
> > duplication quite a bit.
> 
> Do you plan to change the PCI core to do these things any time soon?  

I'm going to do that after the patches from this series are merged.

> Wouldn't that require changing a whole bunch of PCI drivers too?

Only those that start to use the new framework before this happens
(which probably is only MMC at this point).

> I tend to agree that having the core take care of these choreographed
> activities would be good -- it would leave less room for drivers to
> make mistakes.
> 
> So for now maybe it would be best just to rearrange the existing calls
> in USB, and wait for the core changes before doing anything more
> ambitious.

Sounds good.

Thanks,
Rafael
