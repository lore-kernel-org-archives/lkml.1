Return-Path: <linux-kernel-owner+w=401wt.eu-S1767006AbXDEOO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767006AbXDEOO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766997AbXDEOO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:14:28 -0400
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:57594 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767006AbXDEOO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:14:27 -0400
Date: Thu, 5 Apr 2007 10:14:26 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: IRQ splitting
Message-ID: <20070405141426.GE3510@csclub.uwaterloo.ca>
References: <Pine.LNX.4.61.0704051231280.22282@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704051231280.22282@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 12:40:57PM +0200, Jan Engelhardt wrote:
> let's take the following /proc/interrupts dump (CPU2,CPU3 trimmed)...
> 
>            CPU0       CPU1
>   0:   37041766   37038991  IO-APIC-edge  timer
>   1:         10          2  IO-APIC-edge  i8042
>   8:          0          0  IO-APIC-edge  rtc
>   9:          0          0  IO-APIC-level  acpi
>  12:        114          0  IO-APIC-edge  i8042
>  14:      25219    5800049  IO-APIC-edge  ide0
> 201:     260381     238454  IO-APIC-level  aacraid
> 209:          0          0  IO-APIC-level  ohci_hcd:usb1
> 217:          0          0  IO-APIC-level  ehci_hcd:usb2
> 225:   57531742          0  IO-APIC-level  eth0,radeon@pci:0000:03:00.0
> 233:         26          0  IO-APIC-level  eth1
> NMI:       1661       1397
> LOC:  147579966  147579949
> ERR:          0
> MIS:          0
> 
> My question is whether it is possible that eth0's interrupts go to CPU0
> and radeon's to CPU1, and if so, how I would enable that. Alternatively,
> is it possible to just move eth0 or radeon to a different interrupt?

Check the motherboard manual.  Sometimes they explictly list which slots
share IRQs (And by share I mean are physically tied to the same wire).
I know many Asus boards have that information in the manual.

So in many cases other than changing slots, there is nothing you can do
to change the IRQ sharing, since the slots are physically sharing the
interrupt.

--
Len Sorensen
