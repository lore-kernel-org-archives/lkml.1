Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYK1JvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYK1JvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYK1JvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:51:07 -0500
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:45888 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYK1JvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:51:06 -0500
Date: Fri, 28 Nov 2008 01:51:04 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: "Darrick J. Wong" <djwong@us.ibm.com>
cc: Alex Chiang <achiang@hp.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the	device
In-Reply-To: <20081127015205.GG6539@plum>
Message-ID: <Pine.LNX.4.58.0811280145290.24816@shell4.speakeasy.net>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum>
 <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum>
 <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net>
 <20081126225535.GA27936@ldl.fc.hp.com> <20081127015205.GG6539@plum>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Darrick J. Wong wrote:
> On Wed, Nov 26, 2008 at 03:55:35PM -0700, Alex Chiang wrote:
> > > Maybe it's different on powerpc then?  My pseudo-hotplugable device is also
> > > the only thing connected to the PCI-E host bus controller.  At boot the
> > > controller is empty and so I think some code to enable its BARs gets
> > > skipped.  But without the pci_enable_device(), I get this:
> > >
> > > 01:00.0 Signal processing controller: Freescale Semiconductor Inc Aurora Nexus Trace Interface
> > >         Flags: fast devsel, IRQ 255
> > >         Memory at 40000000 (64-bit, prefetchable) [disabled] [size=4K]
>                            Are you referring to this? ^^^^^^^^^^
>
> Without seeing the raw dump of the PCI config space, it looks to me like
> the memory space enable bit of the PCICMD register is unset.  Probably
> the device driver should call pci_enable_device() at init time, though I
> suppose you did say earlier that there is no driver.

Yes, that's it.  It seems like since the BARs are normally enabled after a
device is scanned at boot time that they should also be enabled when a
device is found by a fakephp rescan.  So I thought it seemed reasonable to
put pci_enable_device() in fakephp.
