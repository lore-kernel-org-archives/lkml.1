Return-Path: <linux-kernel-owner+w=401wt.eu-S934692AbXEUTj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934692AbXEUTj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933388AbXEUT0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:26:50 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:59802 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765803AbXEUT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:26:49 -0400
Date: Mon, 21 May 2007 13:26:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-reply-to: <200705211210.44616.jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Message-id: <4651F26C.7010405@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4635510D.4060103@shaw.ca>
 <200705021654.23730.jbarnes@virtuousgeek.org>
 <200705041406.59584.jesse.barnes@intel.com>
 <200705211210.44616.jbarnes@virtuousgeek.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
>>>> What happens if you take out the chipset register detection, does
>>>> the MCFG table give you the same result? Wonder if they're doing
>>>> something funny with start/end bus values or something in their
>>>> table. There's some code in my patch that prints out the important
>>>> data from the MCFG table, can you tell me what that shows with the
>>>> chipset detection taken out?
> 
> I can't see how any MCFG based accesses could work on this box, but I
> don't know why.  According to the boot log (with our code patched in
> but disabled after checking the ACPI reserved status), the space is fine:
> 
> ...
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> pciexbar lo: 0xf0000003
> pciexbar hi: 0x00000000
> Enabled MCFG space at 0x00000000f0000000, size 134217728
> PCI: Found Intel Corporation G965 Express Memory Controller Hub with MMCONFIG support.
> PCI: MCFG configuration 0: base 00000000f0000000 segment 0 buses 0 - 127
> PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
> PCI: Not using MMCONFIG. <-- due to the 'goto reject' after
>                              if (is_acpi_reserved) { ... }
> PM: Adding info for acpi:acpi_system:00
> PM: Adding info for acpi:button_power:00
> ...
> 
> Same thing happens if I disable the chipset specific code and just use
> the ACPI stuff you added.
> 
> If I leave it enabled, several config cycles work fine, but the box
> eventually hangs after probing 24 devices or so.  I don't see anything
> else mapped into this space, and the MTRRs seem ok, so either there's
> something hidden in this memory range or there's another chipset register
> that needs poking to fully enable this space properly.
> 
> Sysrq doesn't seem to work, and I don't see any events in my machine log,
> so figuring out exactly why it's hanging is a bit difficult.
> 
> Any ideas on what to try next?  I'll see if I can get some more details
> from our BIOS folks and do yet another pass over the documentation to see
> if there's something I'm missing.

Can you find out which config access (bus, device, function, address) is 
the one that hangs the box? I assume that either the corresponding 
address in the MCFG table is problematic (i.e. has something else mapped 
over it), or maybe that device just doesn't like being probed with MCFG 
somehow.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

