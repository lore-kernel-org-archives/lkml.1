Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYAXSMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYAXSMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 13:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbYAXSMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 13:12:07 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37835 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYAXSMG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:12:06 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc8-mm1 - Tons of extra interrupts..
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201198324_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jan 2008 13:12:04 -0500
Message-ID: <31145.1201198324@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201198324_2846P
Content-Type: text/plain; charset=us-ascii

Dell Latitude D820 laptop, T7200 Core2 Duo, x86_64 kernel built with
PREEMPT, NO_HZ, and HZ=1000. It's running basically idle with an X desktop session.

I'm seeing large masses of rescheduling interrupts that are basically killing
the C3 residency rate for no obvious reason/gain. I'm taking close to 500
interrupts/second, of which close to 350 are unexplained and apparently
gratuitous. Anybody have suggestions/clues on how to find out why I'm seeing
this? (Quite possibly, I've got something misconfigured because I misunderstood
the documentation - which would still indicate that the doc needs fixing at the
least...)

powertop reports:

     PowerTOP version 1.9       (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 5.6%)         2.00 Ghz     1.2%
C1                0.0ms ( 0.0%)         1.67 Ghz     0.0%
C2                0.7ms ( 5.1%)         1333 Mhz     0.0%
C3                2.1ms (89.3%)         1000 Mhz    98.8%


Wakeups-from-idle per second : 494.9    interval: 10.0s
no ACPI power usage estimate available

Top causes for wakeups:
  43.9% (190.3)      <kernel IPI> : Rescheduling interrupts 
  29.4% (127.4)       <interrupt> : extra timer interrupt 
   5.9% ( 25.6)                 X : do_setitimer (it_real_fn) 
   5.0% ( 21.7)           gkrellm : schedule_timeout (process_timeout) 
   3.9% ( 16.7)     group_balance : schedule_timeout (process_timeout) 
   3.0% ( 13.2)       <interrupt> : iwl3945 
   2.3% ( 10.0)     <kernel core> : ehci_work (ehci_watchdog) 

/proc/interrupts (after about 10 hours of uptime, most of which was mostly
idle and "fetchmail check the mail server every 5 minutes"):

           CPU0       CPU1       
  0:   14507246          0   IO-APIC-edge      timer
  1:      10748          0   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
  9:          3          0   IO-APIC-fasteoi   acpi
 12:         86          0   IO-APIC-edge      i8042
 14:     147067          0   IO-APIC-edge      ata_piix
 15:         45          0   IO-APIC-edge      ata_piix
 16:      91584          0   IO-APIC-fasteoi   nvidia
 19:          9          0   IO-APIC-fasteoi   ohci1394, yenta
 20:      51139          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 21:      34708          0   IO-APIC-fasteoi   uhci_hcd:usb3, HDA Intel
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 23:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
312:     164320          0   PCI-MSI-edge      eth0
313:     385582          0   PCI-MSI-edge      iwl3945
314:       1343          0      none-edge    
NMI:          0          0   Non-maskable interrupts
LOC:    1263420    5737965   Local timer interrupts
RES:    2285220    2305246   Rescheduling interrupts
CAL:       4068       6172   function call interrupts
TLB:      41441      44272   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

Any ideas/hints?

--==_Exmh_1201198324_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmNT0cC3lWbTT17ARAsPoAJ9ahyUhHevrNsIbHNzJl5ANI7gpTwCcD0gg
wXV/mRVMdMlORJ1mu/yFVg8=
=ISNs
-----END PGP SIGNATURE-----

--==_Exmh_1201198324_2846P--
