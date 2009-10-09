Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbZJIXEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbZJIXEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZJIXEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:04:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847AbZJIXEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:04:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH 3/4] PCI / ACPI PM: Platform support for PCI PME wake-up (rev. 2)
Date: Sat, 10 Oct 2009 01:05:08 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <200910090051.50932.rjw@sisk.pl> <200910090054.18693.rjw@sisk.pl> <20091009112320.GA23990@srcf.ucam.org>
In-Reply-To: <20091009112320.GA23990@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910100105.08356.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 October 2009, Matthew Garrett wrote:
> On Fri, Oct 09, 2009 at 12:54:18AM +0200, Rafael J. Wysocki wrote:
> 
> > Unfortunately, the subset of PCI devices that have GPEs associated
> > with them is quite limited and the other devices have to rely on
> > the GPEs associated with their upstream bridges and, possibly, the
> > root bridge to generate ACPI wake-up events in response to PMEs from
> > them.  Moreover, ACPI devices tend to share wake-up GPEs, in which
> > cases it makes sense to install an ACPI notify handler for only one
> > of them and "bind" the other devices to it.  Furthermore, ACPI-based
> > PCI hotplug also uses ACPI notify handlers that in general may
> > conflict with the PM notify handlers, unless this issue is
> > specifically taken care of.
> 
> I'm not sure this approach is correct - for instance, from a Dell 
> system:
> 
>         Method (_L0D, 0, NotSerialized)
>         {
>             Store (SMI (0xC6, 0x00), Local0)
>             If (And (Local0, 0x01))
>             {
>                 Notify (\_SB.PCI0.AZAL, 0x02)
>             }
> 
>             If (And (Local0, 0x02))
>             {
>                 Notify (\_SB.PCI0.EHCI, 0x02)
>             }
> 
>             If (And (Local0, 0x04))
>             {
>                 Notify (\_SB.PCI0.EHC2, 0x02)
>             }
>         }
> 
> All these devices share a GPE, but registering only one notify handler 
> would result in us missing the notification in some cases.

Ok, I see.  The notification may be device-specific, although if we receive
one, we'll need to check all devices sharing the GPE anyway.

I think that's not going to be difficult to take into account, but I won't be
able to work on this until after the KS.

> I also suspect that this should wait until the GPE rework is done.

It certainly is better if the GPE rework is done first, although I'm not sure
it's strictly necessary.  At least I don't see why exactly at the moment.

Thanks,
Rafael
