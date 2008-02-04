Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYBDSSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYBDSSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbYBDSSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:18:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbYBDSSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:18:36 -0500
Date: Mon, 4 Feb 2008 10:18:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-Reply-To: <200802041039.36100.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.1.00.0802041014410.3034@hp.linux-foundation.org>
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <47A2644B.4000905@shaw.ca> <alpine.LFD.1.00.0802011149160.3198@www.l.google.com> <200802041039.36100.bjorn.helgaas@hp.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 Feb 2008, Bjorn Helgaas wrote:
> 
> I think the problem here is that the PCI BAR is bigger and spans the
> region reported by ACPI:

Ok, then it doesn't help that it's not busy.

In that case, the only real fix is to simply do the ACPI reservations 
*after* PCI probing. Which is what it should have done to begin with.

> We can easily add more BIOSes to the PNP quirk.

No. Don't add quirks just because the basic ordering is shit.

> I really don't want to use the earlier quirk that scanned PCI devices
> from a PNP quirk.  I think that's just wrong because PNP (which
> conceptually includes ACPI) is what tells us about PCI root bridges.

So? Do the bridge listing separately from resource marking. Why tie the 
two together? They have absolutely *nothing* to do with each other.

The fact is, scanning devices should happen first. And AFTER the device 
tree is scanned, we can then safely add all the special resources that 
don't show up as normal devices.

			Linus
