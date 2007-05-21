Return-Path: <linux-kernel-owner+w=401wt.eu-S934052AbXEUUWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbXEUUWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbXEUUWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:22:30 -0400
Received: from outbound-mail-27.bluehost.com ([69.89.17.193]:39625 "HELO
	outbound-mail-27.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755512AbXEUUW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:22:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Mon, 21 May 2007 13:22:18 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <4651F26C.7010405@shaw.ca> <200705211307.14868.jbarnes@virtuousgeek.org>
In-Reply-To: <200705211307.14868.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211322.18937.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007, Jesse Barnes wrote:
> Yeah, I've got that data... just a sec while I make sure it's
> reproducable...
>
> Aha, I hadn't decoded the devfn before, looks like it's dying on an
> access to the graphics device (bus 0, slot 2, device 0):
>
> ...
> pci_mmcfg_read: 0, 0, 0x10, 0x18, 4 = 0xc000000c
> pci_mmcfg_read: 0, 0, 0x10, 0x18, 4 = <hang>
> ...
>
> Offset 0x18 into the graphics config space should be the graphics memory
> range address, and 0xc000000c is the correct value.  But for some reason
> it hangs on the second access.
>
> It hangs here everytime.

That register is in the config space BAR region, so it should be ok to 
write 0xffffffff to it and read it back to size the register.  However, 
it's after writing the 0xffffffff to it and trying to read it back that 
the machine hangs.  I didn't see any accesses to the command register to 
disable decoding (at least not via the mmconfig methods), so maybe that's 
broken during MCFG based probing?

Jesse
