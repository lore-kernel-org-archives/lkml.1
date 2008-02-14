Return-Path: <linux-kernel-owner+w=401wt.eu-S1764767AbYBNUGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764767AbYBNUGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757115AbYBNUGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:06:21 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:14454 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbYBNUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:06:20 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Date: Thu, 14 Feb 2008 13:07:58 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802141151.40396.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802141141470.6110@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802141141470.6110@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802141307.59120.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008 12:42:52 pm Linus Torvalds wrote:
> 
> On Thu, 14 Feb 2008, Bjorn Helgaas wrote:
> > 
> > Sorry for the delay.  I did work on this, but I don't see how this
> > can work.  pcibios_init() marks its reservations as not busy, so the
> > subsequent PNP request doesn't fail, even if it clashes.
> 
> It *shouldn't* fail.
> 
> Things should fail only when two different drivers have requested the same 
> region. NOT when something tells the system that a region _exists_.

The sound driver doesn't fail because two different drivers have
requested the same region; it fails because PNP told us a region
exists, and the sound region crosses the edge of the PNP region.

You wrote earlier that:

> On Tue, 5 Feb 2008, Bjorn Helgaas wrote:
> > >  - PnP/ACPI resource allocation *after* it, but before driver
> > > loading (which wll cause new resources to be allocated). This
> > > could be fs_initcall, or whatever (that's what things like
> > > "acpi_event_init" already do).
> >
> > If we put the PNP system driver here, we can easily do a quirk
> > that ignores PNP resources that overlap PCI resources.
>
> No, you don't need any quirks: you just do an "insert_resource()"
> and ignore the error return. If the (bogus) PnP resource clashes
> with the (correct) hardware PCI resource, the insert will simply
> fail. No quirks needed.

I thought you were suggesting here that the PNP system driver would
do an insert_resource(), and it would fail if it clashed with the
PCI resource.

Can you be more explicit about how you think I should fix this?

Bjorn
