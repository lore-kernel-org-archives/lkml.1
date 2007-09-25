Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbXIYMGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbXIYMGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXIYMGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:06:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34171 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbXIYMGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:06:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents
Date: Tue, 25 Sep 2007 14:20:43 +0200
User-Agent: KMail/1.9.5
Cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>
References: <20070925101418.68d30a72@localhost> <1190707673.4035.275.camel@chaos> <1190712618.4035.286.camel@chaos>
In-Reply-To: <1190712618.4035.286.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251420.44345.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Tuesday, 25 September 2007 11:30, Thomas Gleixner wrote:
> Rafael,
> 
> On Tue, 2007-09-25 at 10:07 +0200, Thomas Gleixner wrote:
> > On Tue, 2007-09-25 at 10:14 +0400, Mikhail Kshevetskiy wrote:
> > > Hello Thomas, Rafael
> > > 
> > > > We know, that
> > > > - disabling local apic timers work
> > > 
> > > As i can see from the log, you are booting on computer with dualcore AMD
> > > processor. Do you have C1E feature enabled? 

That's possible, how to check?

> > > i386 kernel disable lapic on dualcore AMD with C1E support (see 
> > > http://lkml.org/lkml/2007/3/29/199). x86_64 kernel do not have this
> > > patch still (it's required for tickless kernel only).
> > 
> > Well it is required for non tickless mode as well.
> > 
> > >  As result, if
> > > you run x86_64 kernel with hrt patch on such computer, the system
> > > will stall during boot on lapic timer calibration.
> > 
> > Thanks for the reminder. I have a look into this.
> 
> Can you please boot mainline and provide the output of:
> 
> # cat /proc/interrupts; sleep 10; cat /proc/interrupts

albercik:~ # cat /proc/interrupts; sleep 10; cat /proc/interrupts
           CPU0       CPU1
  0:    1159492          0  local-APIC-edge      timer
  1:       6892       1692   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
 12:        156        110   IO-APIC-edge      i8042
 14:      29613      11409   IO-APIC-edge      ide0
 16:      23365      21934   IO-APIC-fasteoi   sata_sil, HDA Intel
 18:        196      88386   IO-APIC-fasteoi   bcm43xx
 19:     744874     279433   IO-APIC-fasteoi   ohci_hcd:usb1, ohci_hcd:usb2, ehci_hcd:usb3
 20:          2          4   IO-APIC-fasteoi   ohci1394, yenta, tifm_7xx1, sdhci:slot0
 21:       1408        592   IO-APIC-fasteoi   acpi
NMI:          0          0   Non-maskable interrupts
LOC:          0    1158220   Local interrupts
RES:     260520     295387   Rescheduling interrupts
CAL:        419        652   function call interrupts
TLB:        864        541   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:         13
           CPU0       CPU1
  0:    1161996          0  local-APIC-edge      timer
  1:       6893       1692   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
 12:        156        110   IO-APIC-edge      i8042
 14:      29703      11409   IO-APIC-edge      ide0
 16:      23393      21934   IO-APIC-fasteoi   sata_sil, HDA Intel
 18:        196      88490   IO-APIC-fasteoi   bcm43xx
 19:     747268     279433   IO-APIC-fasteoi   ohci_hcd:usb1, ohci_hcd:usb2, ehci_hcd:usb3
 20:          2          4   IO-APIC-fasteoi   ohci1394, yenta, tifm_7xx1, sdhci:slot0
 21:       1412        592   IO-APIC-fasteoi   acpi
NMI:          0          0   Non-maskable interrupts
LOC:          0    1160723   Local interrupts
RES:     260567     295433   Rescheduling interrupts
CAL:        419        652   function call interrupts
TLB:        866        543   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:         13
albercik:~ #
