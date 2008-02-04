Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYBDRie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYBDRie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbYBDRi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:38:26 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:25007 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbYBDRiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:38:25 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Date: Mon, 4 Feb 2008 10:39:35 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <47A2644B.4000905@shaw.ca> <alpine.LFD.1.00.0802011149160.3198@www.l.google.com>
In-Reply-To: <alpine.LFD.1.00.0802011149160.3198@www.l.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802041039.36100.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008 05:50:13 pm Linus Torvalds wrote:
> On Thu, 31 Jan 2008, Robert Hancock wrote:
> > 
> > I think so. There was one objection that it introduced a dependency on pnpacpi
> > loading after PCI bus enumeration, though.
> > 
> > Linus also suggested that pnpacpi could be marking the resources as "present
> > but unused" so that drivers can request those regions but we still prevent
> > dynamically assigning resources into them.
> 
> I _think_ that's what ACPI used to do before switching over to the PnPACPI 
> thing, so I do think that "present but not reserved" approach is not just 
> the right one, but also the (historically) tested one.

The reservation happens in drivers/pnp/system.c, and it does mark the
region as "not busy."

I think the problem here is that the PCI BAR is bigger and spans the
region reported by ACPI:

[   22.906654] system 00:08: iomem range 0xfebfa000-0xfebfac00 has been reserved
[   31.133141] PCI: Unable to reserve mem region #1:4000@febf8000 for device 0000:00:1b.0

We can easily add more BIOSes to the PNP quirk.

I really don't want to use the earlier quirk that scanned PCI devices
from a PNP quirk.  I think that's just wrong because PNP (which
conceptually includes ACPI) is what tells us about PCI root bridges.

Bjorn
