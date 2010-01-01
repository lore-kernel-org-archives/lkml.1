Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864Ab0AAVmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab0AAVmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 16:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502Ab0AAVmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 16:42:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab0AAVmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 16:42:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH] PCI / PM: Use per-device D3 delays
Date: Fri, 1 Jan 2010 22:42:28 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
References: <20100101170729.GA22252@rhlx01.hs-esslingen.de> <201001011955.27407.rjw@sisk.pl> <20100101201235.GA31960@rhlx01.hs-esslingen.de>
In-Reply-To: <20100101201235.GA31960@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001012242.28322.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 January 2010, Andreas Mohr wrote:
> Hi,
> 
> On Fri, Jan 01, 2010 at 07:55:27PM +0100, Rafael J. Wysocki wrote:
> > On Friday 01 January 2010, Andreas Mohr wrote:
> > > Hi,
> > > 
> > > While the bug report mentions "So it's just quirky hardware.",
> > > the implementation of your patch makes it seem like this delay attribute is
> > > totally "norm"al behaviour - I'm missing some more aggressive wording.
> > 
> > That's because it works both ways (please look at the changelog).
> 
> Ah, ok.
> 
> > I know of a few devices that don't need the PCI-prescribed 10 ms wait when
> > going from D3 to D0 and their drivers may use the d3_delay field to actually
> > set a _shorter_ delay.
> 
> Then why is the value lower-bounded by pci_pm_d3_delay
> (which, puzzlingly, was initialized to PCI_PM_D3_WAIT and thus 10
> before, which the patch now removes!),

That's because dev->d3_delay is initialized to PCI_PM_D3_WAIT for all devices.

> in pci_dev_d3_sleep()? (and pci_pm_d3_delay is being quirked in
> drivers/pci/quirks.c only, to 120)

Exactly because pci_pm_d3_delay is only necessary for some quirky chipsets
that require longer delays for _all_ devices (note that this cannot be handled
at the driver level).  So, we use dev->d3_delay (that the driver gave us),
unless the chipset is known to be quirky and requires a longer delay for
all devices (the driver has no chance to know about that).

Rafael
