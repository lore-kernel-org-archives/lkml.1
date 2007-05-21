Return-Path: <linux-kernel-owner+w=401wt.eu-S1765547AbXEUUHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765547AbXEUUHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759115AbXEUUH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:07:27 -0400
Received: from outbound-mail-70.bluehost.com ([69.89.21.30]:51190 "HELO
	outbound-mail-70.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758815AbXEUUH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:07:26 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Mon, 21 May 2007 13:07:14 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705211210.44616.jbarnes@virtuousgeek.org> <4651F26C.7010405@shaw.ca>
In-Reply-To: <4651F26C.7010405@shaw.ca>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2253
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705211307.14868.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007, Robert Hancock wrote:
> > If I leave it enabled, several config cycles work fine, but the box
> > eventually hangs after probing 24 devices or so.  I don't see anything
> > else mapped into this space, and the MTRRs seem ok, so either there's
> > something hidden in this memory range or there's another chipset
> > register that needs poking to fully enable this space properly.
> >
> > Sysrq doesn't seem to work, and I don't see any events in my machine
> > log, so figuring out exactly why it's hanging is a bit difficult.
> >
> > Any ideas on what to try next?  I'll see if I can get some more
> > details from our BIOS folks and do yet another pass over the
> > documentation to see if there's something I'm missing.
>
> Can you find out which config access (bus, device, function, address) is
> the one that hangs the box? I assume that either the corresponding
> address in the MCFG table is problematic (i.e. has something else mapped
> over it), or maybe that device just doesn't like being probed with MCFG
> somehow.

Yeah, I've got that data... just a sec while I make sure it's 
reproducable...

Aha, I hadn't decoded the devfn before, looks like it's dying on an access 
to the graphics device (bus 0, slot 2, device 0):

...
pci_mmcfg_read: 0, 0, 0x10, 0x18, 4 = 0xc000000c
pci_mmcfg_read: 0, 0, 0x10, 0x18, 4 = <hang>
...

Offset 0x18 into the graphics config space should be the graphics memory 
range address, and 0xc000000c is the correct value.  But for some reason 
it hangs on the second access.

It hangs here everytime.

Jesse
