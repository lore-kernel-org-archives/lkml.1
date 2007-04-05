Return-Path: <linux-kernel-owner+w=401wt.eu-S1767236AbXDET02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767236AbXDET02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 15:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767245AbXDET02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 15:26:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:36714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767236AbXDET01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 15:26:27 -0400
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: IRQ splitting
Date: Thu, 5 Apr 2007 12:23:41 -0700
Organization: OSDL
Message-ID: <20070405122341.482f5e26@freekitty>
References: <fa.21iotKLTgoLpkKhrbSxrjy5v7hM@ifi.uio.no>
	<46150913.4000406@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1175801104 27345 10.8.0.202 (5 Apr 2007 19:25:04 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Thu, 5 Apr 2007 19:25:04 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 08:34:59 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Jan Engelhardt wrote:
> > Hello list,
> > 
> > 
> > 
> > let's take the following /proc/interrupts dump (CPU2,CPU3 trimmed)...
> > 
> >            CPU0       CPU1
> >   0:   37041766   37038991  IO-APIC-edge  timer
> >   1:         10          2  IO-APIC-edge  i8042
> >   8:          0          0  IO-APIC-edge  rtc
> >   9:          0          0  IO-APIC-level  acpi
> >  12:        114          0  IO-APIC-edge  i8042
> >  14:      25219    5800049  IO-APIC-edge  ide0
> > 201:     260381     238454  IO-APIC-level  aacraid
> > 209:          0          0  IO-APIC-level  ohci_hcd:usb1
> > 217:          0          0  IO-APIC-level  ehci_hcd:usb2
> > 225:   57531742          0  IO-APIC-level  eth0,radeon@pci:0000:03:00.0
> > 233:         26          0  IO-APIC-level  eth1
> > NMI:       1661       1397
> > LOC:  147579966  147579949
> > ERR:          0
> > MIS:          0
> > 
> > My question is whether it is possible that eth0's interrupts go to CPU0
> > and radeon's to CPU1, and if so, how I would enable that. Alternatively,
> > is it possible to just move eth0 or radeon to a different interrupt?
> 
> Generally (at least in APIC mode) the IRQ assignments are based on 
> hard-wired interrupt lines on the board. In this case, the slots that 
> the Radeon and eth0 card are in likely share a physical interrupt line 
> and there is no way to separate them in software. You can try moving the 
>   card(s) to different slots..
> 

If the radeon and/or the Ethernet driver support MSI, that would split
out the IRQ's as well.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
