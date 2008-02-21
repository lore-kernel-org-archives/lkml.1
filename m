Return-Path: <linux-kernel-owner+w=401wt.eu-S934335AbYBUAPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335AbYBUAPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932092AbYBUAOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:14:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33249 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933517AbYBUAOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:14:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 01:13:04 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>, Alexey Starikovskiy <aystarik@gmail.com>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802210035.14058.rjw@sisk.pl> <alpine.LFD.1.00.0802201548000.7833@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802201548000.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210113.05733.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Linus Torvalds wrote:
> 
> On Thu, 21 Feb 2008, Rafael J. Wysocki wrote:
> > 
> > In fact we have acpi_pci_choose_state() that tells the driver which power
> > state to put the device into in ->suspend().  If that is used, the device ends
> > up in the state expected by to BIOS for S4.
> 
> First off, nobody should *ever* use that directly anyway.

Yes, sorry.

> Secondly, the one that people should use ("pci_choose_state()") doesn't 
> actually do what you claim it does. It does all kinds of wrong things, and 
> doesn't even take the target state into account at all. So look again.

Well, if platform_pci_choose_state() is defined, pci_choose_state() returns
its result and on ACPI systems that points to acpi_pci_choose_state(), so in
fact it does what I said (apart from the error path). 

> > No.  Again, if there are devices that wake us up from S4, but not from S5,
> > they need to be handled differently in the *enter S4* case (hibernation) and
> > in the *enter S5* case (powering off the system).
> 
> And again, what does this have to do with (the example I used) the 
> graphics hardware? Answer: nothing. The example I gave you we simply DO 
> THE WRONG THING FOR.
> 
> Same thing for things like USB devices - where pci_choose_state() doesn't 
> work to begin with. Why do we call "suspend()" on such a thing when we 
> don't want to suspend it? We shouldn't. We should call "freeze/unfreeze" 
> (which are no-ops) and then finally perhaps "poweroff", and that final 
> stage might want to spin things down or similar.

I'm already convinced, really. :-)

Thanks,
Rafael
