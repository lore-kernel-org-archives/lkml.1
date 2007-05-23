Return-Path: <linux-kernel-owner+w=401wt.eu-S1762940AbXEWA5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762940AbXEWA5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbXEWA4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:56:54 -0400
Received: from outbound-mail-44.bluehost.com ([69.89.18.13]:35097 "HELO
	outbound-mail-44.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756000AbXEWA4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:56:54 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Tue, 22 May 2007 17:56:44 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705221738.09571.jbarnes@virtuousgeek.org> <465390A1.1020307@shaw.ca>
In-Reply-To: <465390A1.1020307@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221756.45221.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 22, 2007, Robert Hancock wrote:
> Jesse Barnes wrote:
> > On Tuesday, May 22, 2007, Robert Hancock wrote:
> >> Eww. I don't see where we disable the decode at all while we probe
> >> the BARs on the device. That seems like a bad thing, especially with
> >> the way we probe 64-bit BARs (do the low 32 bits first and then the
> >> high 32 bits). This means the base address effectively gets set to
> >> 0xfffffff0 momentarily, which might cause some issues.
> >
> > I'm a bit shocked that things work as well as they do without the
> > disabling...
> >
> >> I'd try adding some code inside pci_setup_device
> >> (drivers/pci/probe.c) to disable PCI_COMMAND_IO and
> >> PCI_COMMAND_MEMORY on the device when probing devices with the
> >> standard header type and then restoring the previous command bits
> >> afterwards, and see what effect that has. It'll be interesting if it
> >> does, since obviously it seems to work as it is with non-MMCONFIG
> >> access methods. Maybe the base address being set like that interferes
> >> with MMCONFIG access itself somehow?
> >
> > I tried that, and it seems to get past probing the graphics device at
> > least, but it hangs a bit later.  It could be that the enable/disable
> > I added wasn't correct though, I didn't check to see which one I
> > should disable in the command word, which may be a problem (just
> > disabled them both every probe).  I'll try again with more precise
> > enable/disable semantics.
>
> It'd be interesting to see at what access it ran into trouble next, at
> least if it's consistent. Could be that some device doesn't like having
> the decode disabled..

I think it actually gets through the probing but hangs elsewhere, but I'll 
have to test again to be sure.

Jesse
