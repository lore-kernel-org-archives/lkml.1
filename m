Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbYBEURU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbYBEURU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYBEURK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:17:10 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1540 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845AbYBEURI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:17:08 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Date: Tue, 5 Feb 2008 13:12:46 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802050003.32591.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802051013110.9374@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802051013110.9374@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051312.47074.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 11:15:12 am Linus Torvalds wrote:
> 
> On Tue, 5 Feb 2008, Bjorn Helgaas wrote:
> > > 
> > >  - PnP/ACPI resource allocation *after* it, but before driver loading 
> > >    (which wll cause new resources to be allocated). This could be 
> > >    fs_initcall, or whatever (that's what things like "acpi_event_init" 
> > >    already do).
> > 
> > If we put the PNP system driver here, we can easily do a quirk that
> > ignores PNP resources that overlap PCI resources.
> 
> No, you don't need any quirks: you just do an "insert_resource()" and 
> ignore the error return. If the (bogus) PnP resource clashes with the 
> (correct) hardware PCI resource, the insert will simply fail. No quirks 
> needed.
> 
> >						  But it's kind of
> > ugly to have the ACPI PCI root driver early and other PNP drivers
> > later because they're basically similar animals.
> 
> No they are not.
> 
> If one does just device enumeration, and the other does resource 
> registrations, then they ARE NOT similar animals at all. Don't claim that 
> they are.

Whoa, easy :-)  I just meant they're similar in that we discover PCI
root bridges and other PNP devices by traversing the ACPI namespace,
so unless we make special arrangements, we bind drivers to them at
roughly the same time.

I'll play with your insert_resource() idea and see if I can figure
something out.

Bjorn
