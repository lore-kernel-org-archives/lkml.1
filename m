Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYH1ANV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYH1ANV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbYH1ANE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:13:04 -0400
Received: from 181-30.bbned.dsl.internl.net ([82.215.30.181]:56066 "HELO
	hubble.stokkie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754019AbYH1ANB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:13:01 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2008 20:13:01 EDT
Date: Thu, 28 Aug 2008 02:06:19 +0200 (CEST)
From: "Robert M. Stockmann" <stock@stokkie.net>
To: linux-kernel@vger.kernel.org
Subject: libata, Sound on same IRQ : flaky sound
Message-ID: <Pine.LNX.4.44.0808280147230.1242-100000@hubble.stokkie.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiVirus: scanned for viruses by AMaViS 0.2.4 (ftp://crashrecovery.org/pub/linux/amavis/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have a couple of AMD64 machines with onboard sound devices running 
and they all have one thing in common : flaky sound when one is 
doing some heavy disk I/O on the SATA disks. Interesting enough 
/proc/interrupts shows that libata is using the same IRQ as the sound 
devices :

model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
stepping        : 3
cpu MHz         : 3014.679
cache size      : 1024 KB

# cat /proc/interrupts 
           CPU0       CPU1       
  0:      55869  154467838    IO-APIC-edge  timer
  8:          0          0    IO-APIC-edge  rtc
  9:          0          0   IO-APIC-level  acpi
 16:       1453     499686   IO-APIC-level  libata, NVidia CK8S
 17:          0          0   IO-APIC-level  ehci_hcd:usb1
 18:      27633   69978987   IO-APIC-level  eth0
NMI:      10718      12112 
LOC:  154533874  154533852 
ERR:          0
MIS:          0

model name      : AMD Opteron(tm) Processor 246
stepping        : 10
cpu MHz         : 1991.355
cache size      : 1024 KB

# cat /proc/interrupts 
           CPU0       CPU1       
  0:      18108   19856365    IO-APIC-edge  timer
  1:         16       7915    IO-APIC-edge  i8042
  3:          0         56    IO-APIC-edge  serial
  4:          0         56    IO-APIC-edge  serial
  8:          0          0    IO-APIC-edge  rtc
  9:          0          0   IO-APIC-level  acpi
 12:        346      62269    IO-APIC-edge  i8042
 14:          0        190    IO-APIC-edge  ide0
 15:          1        189    IO-APIC-edge  ide1
 16:        827     358917   IO-APIC-level  libata, AMD AMD8111
 17:          0         18   IO-APIC-level  ohci_hcd:usb1, ohci_hcd:usb2
 18:        555     231470   IO-APIC-level  HiSax, nvidia
 19:      15179    3489796   IO-APIC-level  eth0
NMI:        211        511 
LOC:   19871720   19871628 
ERR:          0
MIS:          0

Kernel is 2.6.15,

Preemption Model is (Preemptible Kernel (Low-Latency Desktop)), Memory 
model is (Flat Memory), [*] Preempt The Big Kernel Lock is switched on. 
Timer frequency is (1000 HZ) or (100 HZ), but changing this value is 
of no influence. One of the machines is a genuine dual Opteron machine
but i'm rather disappointed with the NUMA capabilities of
the 2.6.15 kernel. It does do NUMA, but thats all it does, it doesn't
add anything compared to a SMP kernel with NUMA switched off.

Does one really need the PREEMPT_RT approach to get rock solid
sound as described here ? :

"A realtime preemption overview"
 by Paul McKenney, August 10, 2005
http://lwn.net/Articles/146861/

How about giving your sound device a proper seperate IRQ number?
At least libata should like eth0 have its own kernel resources.

Regards,

Robert
PS. please also cc: to my email address.
-- 
Robert M. Stockmann - RHCE
Network Engineer - UNIX/Linux Specialist
crashrecovery.org  stock@stokkie.net

