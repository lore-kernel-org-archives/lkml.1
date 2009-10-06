Return-Path: <linux-kernel-owner+w=401wt.eu-S933362AbZJFVbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362AbZJFVbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbZJFVbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:31:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57361 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078AbZJFVbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:31:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH 3/4] PCI / ACPI PM: Platform support for PCI PME wake-up
Date: Tue, 6 Oct 2009 23:32:32 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shaohua.li@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <200909132320.05077.rjw@sisk.pl> <200909210226.10671.rjw@sisk.pl> <20091006103213.1803cb65@jbarnes-g45>
In-Reply-To: <20091006103213.1803cb65@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910062332.32132.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009, Jesse Barnes wrote:
> On Mon, 21 Sep 2009 02:26:10 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Monday 14 September 2009, Matthew Garrett wrote:
> > > On Mon, Sep 14, 2009 at 12:53:05AM +0200, Rafael J. Wysocki wrote:
> > > > On Monday 14 September 2009, Matthew Garrett wrote:
> > > > > On Sun, Sep 13, 2009 at 11:24:03PM +0200, Rafael J. Wysocki
> > > > > wrote:
> > > > > > +	} else if (!dev->wakeup.flags.run_wake) {
> > > > > > +		acpi_set_gpe_type(dev->wakeup.gpe_device,
> > > > > > +
> > > > > > dev->wakeup.gpe_number,
> > > > > > +					ACPI_GPE_TYPE_WAKE);
> > > > > 
> > > > > Is this going to work for cases where we have multiple devices
> > > > > attached to the same GPE? The common one is EHCI, where both
> > > > > EHCI HCDs will be one a single GPE. If we wake one, that'll
> > > > > then disable the GPE for the other. Further wakeup events will
> > > > > then be lost.
> > > > 
> > > > You're right, I overlooked that.  Some kind of refcounting is
> > > > needed here.
> > > 
> > > I've sent patches to implement this at the GPE level, which also
> > > change the API for requesting them. I'm waiting on feedback from
> > > Bob Moore.
> > 
> > In the meantime I realized there's one more thing we need to take
> > care of. Namely, if a wake-up GPE is shared between multiple devices,
> > it need not be necessary to install notify handlers for all of them.
> > For example, if one of these devices is the root bridge, we will walk
> > all of the hierarchy under it looking for devices that have PME set,
> > so we need not install notify handlers for any devices that share the
> > wake-up GPE with the root bridge.  Similarly, there's no need to
> > install a notify handler for a device that shares the wake-up GPE
> > with a bridge (non-root) it is under.
> > 
> > Taking that into account I have prepared another version of the
> > @subject patch which is appended below.  It also takes the PM vs
> > hotplug issue into account.  The idea is pretty straightforward,
> > everything should be clear from the changelog and the comments within
> > the patch.
> > 
> 
> What's the latest on this set?  Is this the final version?  Anyone have
> issues with this version?

This was the last one I sent, haven't received any feedback whatever.

Perhaps I'll send the entire patchset as is again for completness?

Thanks,
Rafael
