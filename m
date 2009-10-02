Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZJBHd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZJBHd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbZJBHd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:33:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:55768 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZJBHd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:33:57 -0400
Date: Fri, 2 Oct 2009 09:34:00 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Patch "USB: Work around BIOS bugs by quiescing USB controllers earlier" causes MCEs
Message-ID: <20091002073400.GV6327@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Your patch db8be50c4307dac2b37305fc59c8dc0f978d09ea is causing my
ia64 Altix system to die with an MCE in early boot.

Good dmesg looks like this:
ACPI: PCI Root Bridge [P001] (0001:00)
pci 0001:00:01.0: reg 10 io port: [0x1000-0x10ff]
pci 0001:00:01.0: reg 14 64bit mmio: [0x700000-0x703fff]
pci 0001:00:01.0: reg 1c 64bit mmio: [0x710000-0x71ffff]
pci 0001:00:01.0: reg 30 32bit mmio pref: [0x800000-0x8fffff]
pci 0001:00:01.0: supports D1 D2
pci 0001:00:02.0: reg 10 64bit mmio: [0x720000-0x72ffff]
pci 0001:00:02.0: PME# supported from D3hot
pci 0001:00:02.0: PME# disabled
pci 0001:00:02.1: reg 10 64bit mmio: [0x730000-0x73ffff]
pci 0001:00:02.1: PME# supported from D3hot
pci 0001:00:02.1: PME# disabled
pci 0001:00:03.0: reg 10 64bit mmio pref: [0x900000-0x9fffff]
pci 0001:01:01.0: reg 10 32bit mmio: [0xa00000-0xa00fff]
pci 0001:01:01.0: supports D1 D2

Bad (which is less verbose because it came from a console output):
ACPI: PCI Root Bridge [P001] (0001:00)
pci 0001:00:02.0: PME# supported from D3hot
pci 0001:00:02.0: PME# disabled
pci 0001:00:02.1: PME# supported from D3hot
pci 0001:00:02.1: PME# disabled
Entered OS MCA handler. PSP=20000000fff21120 cpu=2 monarch=1
<6>cpu 2, MCA inconsistent r12 and r13, original stack not modified
<6>Entered OS MCA handler. PSP=20000000fff21120 cpu=1 monarch=0
<6>cpu 1, MCA inconsistent r12 and r13, original stack not modified
<6>Entered OS MCA handler. PSP=20000000fff21120 cpu=0 monarch=0
<6>cpu 0, MCA inconsistent r12 and r13, original stack not modified
<6>Entered OS MCA handler. PSP=20000000fff21120 cpu=3 monarch=0
<6>cpu 3, MCA inconsistent r12 and r13, original stack not modified
<6>All OS MCA slaves have reached rendezvous
mlogbuf_finish: printing switched to urgent mode, MCA/INIT might be dodgy or fail.
Delaying for 5 seconds...

Relevant pci devices:
0001:00:03.0 PCI bridge: IBM PCI-X to PCI-X Bridge (rev 03)
0001:01:01.0 USB Controller: NEC Corporation USB (rev 43)
0001:01:01.1 USB Controller: NEC Corporation USB (rev 43)
0001:01:01.2 USB Controller: NEC Corporation USB 2.0 (rev 04)


Let me know any more info I can provide.

