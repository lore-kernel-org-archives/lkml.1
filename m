Return-Path: <linux-kernel-owner+w=401wt.eu-S934605AbXHGNmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbXHGNmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXHGNmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:42:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928AbXHGNmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:42:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Joonwoo Park" <joonwpark81@gmail.com>
Subject: Re: [PATCH] kexec: fix pci device initialization fail after kexec (2.6.23-rc2). (Related to e1000 doesn't resume properly from standby)
Date: Tue, 7 Aug 2007 15:51:20 +0200
User-Agent: KMail/1.9.5
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Simon Arlott" <simon@fire.lp0.eu>, "Pavel Machek" <pavel@ucw.cz>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       linux-pm@lists.linux-foundation.org, linux-pci@atrey.karlin.mff.cuni.cz,
       David Brownell <david-b@pacbell.net>
References: <b25c3fa70708060642w1b3a326q792a81fdaa3036c5@mail.gmail.com> <200708062048.37160.rjw@sisk.pl> <b25c3fa70708062130v5176fa9fu4b9300e6a313cf2f@mail.gmail.com>
In-Reply-To: <b25c3fa70708062130v5176fa9fu4b9300e6a313cf2f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708071551.21264.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 7 August 2007 06:30, Joonwoo Park wrote:
> 2007/8/7, Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday, 6 August 2007 17:50, Joonwoo Park wrote:
> > > 2007/8/6, Rafael J. Wysocki <rjw@sisk.pl>:
> > > > On Monday, 6 August 2007 15:42, Joonwoo Park wrote:
> > > > > Hi.
> > > > > I think that the pci_set_power_state() has bug.
> > > > > The specification says that some delays is required.
> > > >
> > > > And they are in place, AFAICS (from drivers/pci/pci.c):
> > > >
> > > >        /* Mandatory power management transition delays */
> > > >        /* see PCI PM 1.1 5.6.1 table 18 */
> > > >        if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
> > > >                msleep(pci_pm_d3_delay);
> > > >        else if (state == PCI_D2 || dev->current_state == PCI_D2)
> > > >                udelay(200);
> > > >
> > >
> > > The problem is occurred when state is 'PCI_D0', so those codes can't cover it.
> > > But pci pm specification 5.4.1 says that when programmed to D0 the
> > > equivalent of a warm reset, delay for the duration of the D3hot to D0
> > > Uninitialized state
> > > transition (10ms) to pci signal drivers remain disabled is required.
> >
> > Section 5.4.1 of PCI PM 1.1. spec is about D3_hot.  Specifically, it says
> > that if a device in D3_hot is programmed to D0, it performs the equivalent of
> > a warm reset.  IOW, this is supposed to happen if the current state is D3_hot
> > and the targed state is D0, which is covered by the code snippet above.
> 
> IMHO, it is seems to the spec says just *programmed  to D0* not
> *programmed from D3hot to D0*.

But the title of the section is "Software Accessible D3 (D3hot)", isn't it?

And the first paragraph of the section is

"Functions in D3hot must respond to configuration space accesses as long as
power and clock are supplied so that they can be returned to D0 by software."

If this doesn't imply D3hot to D0 transition being discussed in the next
paragraph, then I don't know what it's there for.

> Actually, I got current_state UNKNOWN and state PCI_D0 after kexec's
> start new kernel with dual port 82546EB fiber ethernet card.

IMO, pci_set_power_state() is correct and your problem is related to something
else.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
