Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYLFSau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYLFSau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 13:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYLFSal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 13:30:41 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4632 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751464AbYLFSak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 13:30:40 -0500
Date: Sat, 6 Dec 2008 13:30:37 -0500 (EST)
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
In-Reply-To: <200812061843.59495.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:

> On Saturday, 6 of December 2008, Linus Torvalds wrote:
> > 
> > On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > > 
> > > USB doesn't use that for PCI suspend-resume, it uses it for suspend-resume of
> > > USB devices behind the controller.
> > 
> > Oh, in that case there are no PCI users of this at all, and what the PCI 
> > driver does is immaterial ;)
> > 
> > > But then we will save the device's registers in the "sleeping" state. 
> > 
> > No no. The rule would be that a PCI driver - if it uses the new 
> > infrastructure, which apparently nobody does _as_ a PCI driver - simply 
> > would never do the whole "pci_set_power_state(PCI_D3hot)" etc crud AT ALL.
> 
> Now _that_ sounds good. :-)
> 
> > So a PCI driver would only do higher-level stuff in its suspend/resume 
> > code. For example, a USB host controller would initiate the USB bus level 
> > stuff, and likely just stop the controller (not suspend it - just stop 
> > it).
> 
> I like this idea very much.

Rafael, I'd be happy to help with fixing up the USB PCI PM code.  At
this point I'm not sure exactly what's needed, though.  For instance,
is there any compelling reason to switch over to the new dev_pm_ops
approach?  And what should the correct sequence of calls be?

Alan Stern

