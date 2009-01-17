Return-Path: <linux-kernel-owner+w=401wt.eu-S932577AbZAQWr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbZAQWr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 17:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761143AbZAQWrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 17:47:16 -0500
Received: from aun.it.uu.se ([130.238.12.36]:34444 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014AbZAQWrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 17:47:16 -0500
Date: Sat, 17 Jan 2009 23:46:57 +0100 (MET)
Message-Id: <200901172246.n0HMkvrv004832@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: benh@kernel.crashing.org
Subject: [BUG] 2.6.28-git12: "powerpc/pci: Reserve legacy regions on PCI" broke my G3
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.29-rc kernels hang during boot on my PowerMac G3 (Beige).
The last messages I see on the console are

Kernel command line: ramdisk_size=8192
irq: Found primary Apple PIC /pci/mac-io for 64 irqs
irq: System has 64 possible interrupts

and then it hangs until I reboot it. Unfortunately I don't have a serial cable
compatible with the G3's serial port so I can't set up a serial console.

Eventually I narrowed the cause down to "powerpc/pci: Reserve legacy regions on PCI"
(commit c1f343028d35ba4e88cd4a3c44e0d8b8a84264ee) in 2.6.28-git12. Reverting that
from 2.6.29-rc2 results in a kernel that boots ok and works reliably.

The problem seems system specific as both my G5 and my G4 had no problems at all
with 2.6.29-rc1.

/Mikael
