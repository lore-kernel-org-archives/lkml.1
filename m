Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbYBESPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbYBESPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYBESPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:15:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42000 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353AbYBESPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:15:34 -0500
Date: Tue, 5 Feb 2008 10:15:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-Reply-To: <200802050003.32591.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.1.00.0802051013110.9374@woody.linux-foundation.org>
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802041341.37313.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802041300170.3034@hp.linux-foundation.org> <200802050003.32591.bjorn.helgaas@hp.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Feb 2008, Bjorn Helgaas wrote:
> > 
> >  - PnP/ACPI resource allocation *after* it, but before driver loading 
> >    (which wll cause new resources to be allocated). This could be 
> >    fs_initcall, or whatever (that's what things like "acpi_event_init" 
> >    already do).
> 
> If we put the PNP system driver here, we can easily do a quirk that
> ignores PNP resources that overlap PCI resources.

No, you don't need any quirks: you just do an "insert_resource()" and 
ignore the error return. If the (bogus) PnP resource clashes with the 
(correct) hardware PCI resource, the insert will simply fail. No quirks 
needed.

>						  But it's kind of
> ugly to have the ACPI PCI root driver early and other PNP drivers
> later because they're basically similar animals.

No they are not.

If one does just device enumeration, and the other does resource 
registrations, then they ARE NOT similar animals at all. Don't claim that 
they are.

			Linus
