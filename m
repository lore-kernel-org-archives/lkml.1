Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbXLFQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbXLFQcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXLFQcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:32:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:57031 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXLFQcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:32:23 -0500
Date: Thu, 6 Dec 2007 17:32:19 +0100 (CET)
From: Bernhard Kaindl <bk@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: remote debugging via FireWire * __fast__ firedump!
In-Reply-To: <4755D186.20204@s5r6.in-berlin.de>
Message-ID: <alpine.LNX.0.9999-openSUSE-1.0712061713560.21849@jbgna.fhfr.qr>
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de> <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org> <4755D186.20204@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007, Stefan Richter wrote:
>
> A quick note to this text from
> http://www.suse.de/~bk/firewire/ohci1394_dma_early.diff :
>> +	  As all changes to the FireWire bus such as enabling and disabling
>> +	  devices cause a bus reset and thereby disable remote DMA for all
>> +	  devices, be sure to have FireWire enabled on the debug host (and
>> +	  the cable plugged) before booting the debug target for debugging.
>
> Bus resets are also caused by bus managing software, which Linux' old
> and new FireWire stacks and the stacks of all other FireWire capable
> desktop OSs are to varying degrees.

Yes, I can also trigger it raw1394_reset_bus() from libraw1394.

>                                      I wonder if the following could
> happen:  The two PCs are directly connected, only the PHY of the
> debugging PC is active, then the PHY of the debugged PC is activated,
> becomes root node, debugging PC examines the bus, then resets the bus to
> force its own PHY to become root node in order to get a working
> isochronous resource manager.  This bus reset would switch remote DMA on
> the debugged PC off.

Yes, that's the case. The PHY of the debugging PC must be active before the
booting a kernel with the early OHCI-1394 initialisation on the debugged
machine.

I tried to to instruct users to do exactly that in that part of the help
text, but changed the wording now in to hope to make it clearer:

+	  [...] be sure to have the cable plugged and FireWire enabled on
+	  the debugging host before booting the debug target for debugging.

and I added new file, installed as Documentation/debugging-via-ohci1394.txt
to give a more detailed HOWTO with links to all available tools and a step
by step guide on how to create a setup for using firescope.

ftp://ftp.suse.de/private/bk/firewire/kernel/ohci1394_dma_early-v2.diff

I'll submit that patch for full review in my next mail.

Bernhard
