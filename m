Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbYFYCmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbYFYCmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 22:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYFYCl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 22:41:58 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:39057 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYFYCl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 22:41:57 -0400
Date: Tue, 24 Jun 2008 22:41:27 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
In-reply-to: <20080624114139.GC21890@elte.hu>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Message-id: <alpine.LFD.1.10.0806242240050.3014@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080620135639.GA5073@damson.getinternet.no>
 <alpine.LFD.1.10.0806201458500.3027@localhost.localdomain>
 <19f34abd0806201340t502ce471n578dd2498a5f1992@mail.gmail.com>
 <19f34abd0806201427h740ca3e7gc2f01c7e34616fd4@mail.gmail.com>
 <19f34abd0806210119o64a1c9ban78710651a01530cf@mail.gmail.com>
 <20080624114139.GC21890@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Ingo Molnar wrote:

> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
> > On Fri, Jun 20, 2008 at 11:27 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > > So I guess this function, pnpbios_init() needs the check as well. In
> > > fact, it has this:
> > >
> > > #ifdef CONFIG_PNPACPI
> > >        if (!acpi_disabled && !pnpacpi_disabled) {
> > >                pnpbios_disabled = 1;
> > >                printk(KERN_INFO "PnPBIOS: Disabled by ACPI PNP\n");
> > >                return -ENODEV;
> > >        }
> > > #endif                          /* CONFIG_ACPI */
> > >
> > > ...I guess that should be changed to say if (acpi_disabled ||
> > > pnpacpi_disabled)? Or... I don't understand the purpose of the
> > > original test. But it seems to be there since the beginning of time
> > > (or, well, v2.6.12-rc2).
> > 
> > Nope. I found the introduction of the change in the historical git repository:
> > 
> > commit 4723ebe898a32262ed49fe677897ccea47e72ff4
> > Author: Adam Belay <ambx1@neo.rr.com>
> > Date:   Sun Oct 24 15:07:32 2004 -0400
> > 
> >     [PNPBIOS] disable if ACPI is active
> > 
> >     As further ACPI pnp functionaility is implemented it is no longer
> >     safe to run ACPI and PNPBIOS concurrently.
> > 
> >     We therefore take the following approach:
> >     - attempt to enable ACPI support
> >     - if ACPI fails (blacklist etc.) enable pnpbios support
> >     - if ACPI support is not compiled in the kernel enable pnpbios support
> > 
> >     Signed-off-by: Adam Belay <ambx1@neo.rr.com>
> > 
> > and now I understand the purpose of the check; pnpbios does not depend 
> > on ACPI; ACPI/pnpacpi is incompatible with pnpbios.
> 
> wow, rather old bug - i guess lockdep made it more visible.

No, that commit was not a bug, it was correct, and still is,
for pnpACPI and pnpBIOS must be mutually exclusive.

The thing that changed was the RTC specific code.

-Len
