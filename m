Return-Path: <linux-kernel-owner+w=401wt.eu-S1765101AbXEUTLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765101AbXEUTLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbXEUTKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:10:55 -0400
Received: from outbound-mail-26.bluehost.com ([69.89.17.191]:57243 "HELO
	outbound-mail-26.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756895AbXEUTKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:10:55 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Mon, 21 May 2007 12:10:44 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705021654.23730.jbarnes@virtuousgeek.org> <200705041406.59584.jesse.barnes@intel.com>
In-Reply-To: <200705041406.59584.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211210.44616.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > What happens if you take out the chipset register detection, does
> > > the MCFG table give you the same result? Wonder if they're doing
> > > something funny with start/end bus values or something in their
> > > table. There's some code in my patch that prints out the important
> > > data from the MCFG table, can you tell me what that shows with the
> > > chipset detection taken out?

I can't see how any MCFG based accesses could work on this box, but I
don't know why.  According to the boot log (with our code patched in
but disabled after checking the ACPI reserved status), the space is fine:

...
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
pciexbar lo: 0xf0000003
pciexbar hi: 0x00000000
Enabled MCFG space at 0x00000000f0000000, size 134217728
PCI: Found Intel Corporation G965 Express Memory Controller Hub with MMCONFIG support.
PCI: MCFG configuration 0: base 00000000f0000000 segment 0 buses 0 - 127
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: Not using MMCONFIG. <-- due to the 'goto reject' after
                             if (is_acpi_reserved) { ... }
PM: Adding info for acpi:acpi_system:00
PM: Adding info for acpi:button_power:00
...

Same thing happens if I disable the chipset specific code and just use
the ACPI stuff you added.

If I leave it enabled, several config cycles work fine, but the box
eventually hangs after probing 24 devices or so.  I don't see anything
else mapped into this space, and the MTRRs seem ok, so either there's
something hidden in this memory range or there's another chipset register
that needs poking to fully enable this space properly.

Sysrq doesn't seem to work, and I don't see any events in my machine log,
so figuring out exactly why it's hanging is a bit difficult.

Any ideas on what to try next?  I'll see if I can get some more details
from our BIOS folks and do yet another pass over the documentation to see
if there's something I'm missing.

Thanks,
Jesse
