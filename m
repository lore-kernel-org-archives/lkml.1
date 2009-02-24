Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZBXQBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZBXQBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758571AbZBXQA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:00:56 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:33847 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757166AbZBXQAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:00:55 -0500
Message-ID: <49A419B1.1040507@lwfinger.net>
Date: Tue, 24 Feb 2009 10:00:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>
Subject: How to diagnose unexpected IRQ Trap
References: <banggh.3o0n20@no-mx.forums.opensuse.org> <owfol.11723$5N1.4454@kovat.provo.novell.com> <banggh.3o0ugn@no-mx.forums.opensuse.org> <rMhol.11750$5N1.10757@kovat.provo.novell.com> <banggh.3o2581@no-mx.forums.opensuse.org> <0CAol.11902$5N1.5194@kovat.provo.novell.com> <banggh.3o2xxb@no-mx.forums.opensuse.org> <jVFol.12$Ht3.3@kovat.provo.novell.com> <banggh.3o3ten@no-mx.forums.opensuse.org>
In-Reply-To: <banggh.3o3ten@no-mx.forums.opensuse.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In helping troubleshoot a wireless problem with an RTL8187L (USB) device on the
openSUSE forums, the following excerpt from the dmesg output was reported:

=================================================
unexpected IRQ trap at vector a3
irq 163, desc: c053af00, depth: 1, count: 0, unhandled: 0
->handle_irq():  c0166904, handle_bad_irq+0x0/0x1e8
->chip(): c051ae9c, no_irq_chip+0x0/0x40
->action(): 00000000
IRQ_DISABLED set
unexpected IRQ trap at vector a3
irq 163, desc: c053af00, depth: 1, count: 0, unhandled: 0
->handle_irq():  c0166904, handle_bad_irq+0x0/0x1e8
->chip(): c051ae9c, no_irq_chip+0x0/0x40
->action(): 00000000
IRQ_DISABLED set
==================================================

After seeing this info, I asked for the results of 'cat /proc/interrupts' and
got the following:

===================================================

bang@resolver:~> cat /proc/interrupts
CPU0       CPU1
0:         92          0   IO-APIC-edge      timer
1:         14          0   IO-APIC-edge      i8042
4:          1          0   IO-APIC-edge
6:          5          0   IO-APIC-edge      floppy
7:          0          0   IO-APIC-edge      parport0
8:          0          0   IO-APIC-edge      rtc0
9:          0          0   IO-APIC-fasteoi   acpi
14:          0          0   IO-APIC-edge      pata_via
15:       8655          0   IO-APIC-edge      pata_via
17:      69762          0   IO-APIC-fasteoi   HDA Intel, eth1
18:          0          0   IO-APIC-fasteoi   saa7134[0]
20:       8439          0   IO-APIC-fasteoi   uhci_hcd:usb1
21:      27348          0   IO-APIC-fasteoi   sata_via, uhci_hcd:usb3,
ehci_hcd:usb5
22:          9          0   IO-APIC-fasteoi   uhci_hcd:usb2
23:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
28:     247256          0   IO-APIC-fasteoi   ahci
29:          0          0   IO-APIC-fasteoi   pata_jmicron
163:   22423122          0      none-<NULL>
222:          0          0   PCI-MSI-edge      aerdrv
223:          0          0   PCI-MSI-edge      aerdrv
NMI:          0          0   Non-maskable interrupts
LOC:     221651     239972   Local timer interrupts
RES:      21767      19731   Rescheduling interrupts
CAL:        380        273   function call interrupts
TLB:       1435       2561   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0
===========================================================

The kernel in question is reported as 2.6.27.7-9-pae. I don't know what the
hardware is.

What information should I get to help resolve this problem?

Thanks,

Larry



