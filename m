Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbYLGACb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbYLGACb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 19:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYLGACV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 19:02:21 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4760 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753454AbYLGACU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 19:02:20 -0500
Date: Sat, 6 Dec 2008 19:02:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend
 and resume
In-Reply-To: <200812062236.44111.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0812061858160.16554-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:

> > Rafael, I'd be happy to help with fixing up the USB PCI PM code.  At
> > this point I'm not sure exactly what's needed, though.  For instance,
> > is there any compelling reason to switch over to the new dev_pm_ops
> > approach?
> 
> Certainly not at the moment.  There will be a reason some time after .29.
> 
> That said, it apparently is possible to clean up the resume callbacks of PCI
> USB controllers, as mentioned here: http://lkml.org/lkml/2008/12/6/38
> 
> > And what should the correct sequence of calls be?
> 
> Well, that's something I'm not exactly sure about myself.  Surely it seems
> reasonable to call pci_restore_state() with interrupts disabled and do the rest
> of resume after that.  Also, I think that the core could execute things like
> pci_enable_device() during resume and pci_set_power_state()/pci_enable_wake()
> on suspend so that the drivers didn't have to.  This way we could reduce code
> duplication quite a bit.

Do you plan to change the PCI core to do these things any time soon?  
Wouldn't that require changing a whole bunch of PCI drivers too?  I
tend to agree that having the core take care of these choreographed
activities would be good -- it would leave less room for drivers to
make mistakes.

So for now maybe it would be best just to rearrange the existing calls
in USB, and wait for the core changes before doing anything more
ambitious.

> However, I'm not quite sure about the freeing and requesting IRQs during
> suspend and resume.  Many drivers do that, many others don't.  Still,
> apparently some drivers don't work correctly after resume if this is not done.
> So, if that should generally be done, I also think that moving it to the core
> might be a good idea.

For USB this doesn't matter; we don't free the IRQs during suspend.

Alan Stern

