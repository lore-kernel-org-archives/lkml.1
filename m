Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399Ab0AIWEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab0AIWEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 17:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118Ab0AIWEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 17:04:22 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:54560 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0AIWEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 17:04:21 -0500
Subject: Re: ACPI quirks - acpi_osi="!Windows 2006" required on FSC Amilo
 notebooks to enable brightness keys
From: Peter Paul <abnominales@web.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100109202642.GA18657@srcf.ucam.org>
References: <539929391@web.de>  <20100109202642.GA18657@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Jan 2010 22:48:21 +0100
Message-ID: <1263073701.6497.75.camel@rechenknecht2k7>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18BaJVGTshR0Lilh5/dpTHfoC9fXG4ikuOkIsF3
	jS5TYuMsnCITE+jJ3h1I+U8pcVujNfqDMnNWXuZAc1lMugTBu1
	4T1ZV4PVw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09.01.2010, 20:26 +0000 Matthew Garrett wrote:
> On Sat, Jan 09, 2010 at 08:14:59PM +0100, Peter Paul wrote:
> 
> &gt; Nope, neither with nor without acpi_osi="!Windows 2006", there is nothing in dmesg, no output in acpi_listen and no event in xev.
> &gt; I've compared the ACPI messages in dmesg with and without the parameter, the only change is the rather obvious 
> &gt; ACPI: Deleted _OSI(Windows 2006)
> 
> And /proc/interrupts doesn't change when you hit those keys?
> 

/proc/interrupts does change all the time
The only backlight related interrupt seems to be IO-APIC-fasteoi (9) - I
get 5-7 interrupts there when pressing either Fn+F8 (brightness down) or
Fn+F7 (brightness up), but only when brightness has not reached a
maximim level in the direction I want to go.
Brightness changes not.
When adding the acpi_osi parameter, I get 10 interrupts for brightness
every key press as long as brighness has not reached it's maximum resp.
minimum.
Brightness changes.

When using a userspace application like brightness-applet, I get >100
interrupts, brightness changes.

Every once in a while I also get some interrupts there without touching
anything (but brightness does not change)


           CPU0       CPU1       
  0:     149418          0   IO-APIC-edge      timer
  1:        200          0   IO-APIC-edge      i8042
  8:        174          0   IO-APIC-edge      rtc0
  9:       3066          0   IO-APIC-fasteoi   acpi
 12:       7712          0   IO-APIC-edge      i8042
 14:      34368          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 18:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1,
uhci_hcd:usb6
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 22:        280          0   IO-APIC-fasteoi   HDA Intel
 23:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4,
ehci_hcd:usb7
 27:       6472          0   PCI-MSI-edge      i915
 28:       8369          0   PCI-MSI-edge      ahci
 29:       2852          0   PCI-MSI-edge      eth0
 30:      47238          0   PCI-MSI-edge      iwl3945
NMI:          0          0   Non-maskable interrupts
LOC:      30854      62124   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
PND:          0          0   Performance pending work
RES:      51052      49567   Rescheduling interrupts
CAL:         18         27   Function call interrupts
TLB:       3098       3001   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          8          8   Machine check polls
ERR:          0
MIS:          0


