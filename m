Return-Path: <linux-kernel-owner+w=401wt.eu-S1945907AbXBUXMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945907AbXBUXMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945900AbXBUXMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:12:34 -0500
Received: from www.osadl.org ([213.239.205.134]:56892 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1945907AbXBUXMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:12:34 -0500
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070221230409.GA1158@dreamland.darkstar.lan>
References: <20070221230409.GA1158@dreamland.darkstar.lan>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 00:17:39 +0100
Message-Id: <1172099859.25076.132.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 00:04 +0100, Luca Tettamanti wrote:
> Hi Thomas,
> I'm testing NO_HZ on my machines. On the laptop I see that the timer
> interrupt counter is incremented (though slower than HZ). This machine
> is running UP kernel.
> 
> On my desktop I see this:
> 
>            CPU0       CPU1       
>   0:        114          0   IO-APIC-edge      timer
>   1:       1624      10771   IO-APIC-edge      i8042
>   6:          3          0   IO-APIC-edge      floppy
>   7:          0          0   IO-APIC-edge      parport0
>   9:          0          0   IO-APIC-fasteoi   acpi
>  12:      40111     184047   IO-APIC-edge      i8042
>  16:      75624     998858   IO-APIC-fasteoi   radeon@pci:0000:01:00.0, uhci_hcd:usb1
>  17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  18:        711       5487   IO-APIC-fasteoi   ide1, libata, ehci_hcd:usb7, uhci_hcd:usb3
>  19:        617       2254   IO-APIC-fasteoi   libata, uhci_hcd:usb2
>  20:          0          0   IO-APIC-fasteoi   ehci_hcd:usb6, uhci_hcd:usb5
>  21:    2483869          0   IO-APIC-fasteoi   eth0
>  22:          2          0   IO-APIC-fasteoi   ohci1394
> 218:      28872     360643   PCI-MSI-edge      HDA Intel
> 219:      32932     138196   PCI-MSI-edge      libata
> NMI:          0          0 
> LOC:    2761191    2827539 
> ERR:          0
> MIS:          0
> 
> Interrupt 0 is stuck at 114 (the number is consistent across reboots). I
> don't experience any problem, time is running fine. Still it's strange
> that the timer is doing nothing; maybe something other than the PIT is
> used for time keeping?

Yes, we switch away from PIT and use the local APIC timer. (LOC)

	tglx


