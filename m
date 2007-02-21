Return-Path: <linux-kernel-owner+w=401wt.eu-S1423035AbXBUXTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423035AbXBUXTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423248AbXBUXTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:19:43 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:5817 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423035AbXBUXTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:19:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LLRVATNHH601DEe6OioVSE7T6ON68YIqGt1CUfta7fV94A1NpXGNlodaryj52w0uJapa+usw08fbD/xlpE7CPXa1sAr1hxgLW4/dgDoOAZYiaEaccYbQ2065PF696LpYyubTCRSq4ZdBez/Q+81VLGAprSOcw4uCyrtBNJ2ArZY=
Message-ID: <68676e00702211519k68104e31ia2ae38a14eb27c1f@mail.gmail.com>
Date: Thu, 22 Feb 2007 00:19:41 +0100
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: tglx@linutronix.de
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1172099859.25076.132.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221230409.GA1158@dreamland.darkstar.lan>
	 <1172099859.25076.132.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 2007-02-22 at 00:04 +0100, Luca Tettamanti wrote:
> > Hi Thomas,
> > I'm testing NO_HZ on my machines. On the laptop I see that the timer
> > interrupt counter is incremented (though slower than HZ). This machine
> > is running UP kernel.
> >
> > On my desktop I see this:
> >
> >            CPU0       CPU1
> >   0:        114          0   IO-APIC-edge      timer
> >   1:       1624      10771   IO-APIC-edge      i8042
> >   6:          3          0   IO-APIC-edge      floppy
> >   7:          0          0   IO-APIC-edge      parport0
> >   9:          0          0   IO-APIC-fasteoi   acpi
> >  12:      40111     184047   IO-APIC-edge      i8042
> >  16:      75624     998858   IO-APIC-fasteoi   radeon@pci:0000:01:00.0, uhci_hcd:usb1
> >  17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
> >  18:        711       5487   IO-APIC-fasteoi   ide1, libata, ehci_hcd:usb7, uhci_hcd:usb3
> >  19:        617       2254   IO-APIC-fasteoi   libata, uhci_hcd:usb2
> >  20:          0          0   IO-APIC-fasteoi   ehci_hcd:usb6, uhci_hcd:usb5
> >  21:    2483869          0   IO-APIC-fasteoi   eth0
> >  22:          2          0   IO-APIC-fasteoi   ohci1394
> > 218:      28872     360643   PCI-MSI-edge      HDA Intel
> > 219:      32932     138196   PCI-MSI-edge      libata
> > NMI:          0          0
> > LOC:    2761191    2827539
> > ERR:          0
> > MIS:          0
> >
> > Interrupt 0 is stuck at 114 (the number is consistent across reboots). I
> > don't experience any problem, time is running fine. Still it's strange
> > that the timer is doing nothing; maybe something other than the PIT is
> > used for time keeping?
>
> Yes, we switch away from PIT and use the local APIC timer. (LOC)

Ok, thanks for the clarification.

Luca
