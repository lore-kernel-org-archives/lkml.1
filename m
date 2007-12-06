Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbXLFUYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbXLFUYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXLFUYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:24:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44220 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbXLFUYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:24:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47585A4D.8060307@s5r6.in-berlin.de>
Date: Thu, 06 Dec 2007 21:23:41 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Bernhard Kaindl <bk@suse.de>
CC: Andi Kleen <ak@suse.de>, Bernhard Kaindl <bkaindl@ffii.org>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Thomas Renninger <trenn@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Early boot debugging via FireWire (ohci1394_dma=early)
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de> <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org> <4755D186.20204@s5r6.in-berlin.de> <4755D612.1090103@s5r6.in-berlin.de> <4755D757.7060002@s5r6.in-berlin.de> <alpine.LNX.0.9999-openSUSE-1.0712061732280.21849@jbgna.fhfr.qr> <alpine.LNX.0.9999-openSUSE-1.0712061936370.21849@jbgna.fhfr.qr>
In-Reply-To: <alpine.LNX.0.9999-openSUSE-1.0712061936370.21849@jbgna.fhfr.qr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Kaindl wrote:
>    after summing up the discussion on previous patches, I'm now submitting the
> patch below for formal review and adoption on branches for mainline inclusion.

I will look a bit more into the details later; for now I have just a
quick comment on the documentation.

> --- linux-2.6.24-rc4/Documentation/debugging-via-ohci1394.txt
> +++ linux-2.6.24-rc4/Documentation/debugging-via-ohci1394.txt
> @@ -0,0 +1,179 @@
> +
> +  Using physical DMA provided by OHCI-1394 FireWire controllers for debugging
> +  ---------------------------------------------------------------------------
> +
> +Introduction
> +------------

There are some really long sentences in it.
Try to use the "." character more often.  :-)

> +Basically all FireWire controllers which are in use today are compliant
> +to the OHCI-1394 specification which defines the controller to be a PCI
> +bus master which uses DMA to offload data transfers from the CPU and has
> +a "Physical Response Unit" which executes specific requests by employing
> +PCI-Bus master DMA after applying filters defined by the OHCI-1394 driver.
> +
> +Once properly configured, remote machines can send these requests to
> +ask the OHCI-1394 controller to perform read and write requests on
> +physical system memory and, for read requests, send the result of
> +the physical memory read back to the requester.

In other words, the FireWire controller can be configured to work as a
bus bridge between FireWire bus and local bus (PCI or PCIe).

And yes, there are security implications.

[...]
> +The OHCI-1394 drivers in drivers/firewire and drivers/ieee1394 initialize
> +the OHCI-1394 controllers to a working state and can be used to enable
> +physical DMA. By default you only have to load the driver, and physical
> +DMA access will be granted to all remote nodes, but it can be turned off
> +when using the ohci1394 driver.

This is correct for ohci1394, and it's a bug.
http://bugzilla.kernel.org/show_bug.cgi?id=7794

firewire-ohci however implements filtered physical DMA.  The only user
of that is the firewire-sbp2 driver which grants SBP-2 targets access
through the physical response unit.  firewire-ohci has at the moment no
option for either unfiltered physical DMA (as needed by firescope at al,
tracked at http://wiki.linux1394.org/ToDo) nor to completely disable
physical DMA.
-- 
Stefan Richter
-=====-=-=== ==-- --==-
http://arcgraph.de/sr/
