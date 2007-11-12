Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbXKLRGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbXKLRGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbXKLRGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:06:46 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:41214 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbXKLRGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:06:45 -0500
Date: Mon, 12 Nov 2007 17:06:31 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Adam Belay <ambx1@neo.rr.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] [PATCH] PNP: request ioport and iomem resources used by
 active devices
In-Reply-To: <200711070915.35743.bjorn.helgaas@hp.com>
Message-ID: <Pine.LNX.4.64N.0711121700070.30102@blysk.ds.pg.gda.pl>
References: <200710291525.31475.bjorn.helgaas@hp.com>
 <Pine.LNX.4.64N.0711071252500.14970@blysk.ds.pg.gda.pl>
 <200711070915.35743.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Bjorn Helgaas wrote:

> There will undoubtedly be errors in what the firmware reports.  But if
> firmware tells us about some non PC/AT device, we should believe it at
> least enough to avoid placing some other device on top of it.
> 
> If we have PNPBIOS or ACPI, the built-in stuff reserved in
> request_standard_resources() should be superfluous.  In theory.
> But I doubt there's any benefit in skipping request_standard_resources().
> Possibly it could be done *after* the PNP reservations, so the
> hierarchy would make more sense, but I don't know if even that
> is worth the trouble.

 In practice it is resources above 0x00ff that really matter here as using 
the motherboard range for device allocation is unsafe anyway (the whole 
range may be actively decoded by the south bridge).  So whatever is 
reported between 0x0000 and 0x00ff is mostly informational; with some 
protection against driver bugs perhaps (that assuming they have got error 
handling right for reservations).  I second it is not worth the hassle.

  Maciej
