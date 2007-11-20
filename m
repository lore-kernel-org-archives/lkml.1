Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbXKTPOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbXKTPOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbXKTPOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:14:33 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:54130 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbXKTPOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:14:33 -0500
Date: Tue, 20 Nov 2007 16:14:31 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: VIA spurious hang on 2.6.23.1
Message-ID: <Pine.LNX.4.64.0711201606330.32378@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I've got some semi-embedded device here, a plain consumer-grade x86 with 
a VIA Nehemiah/Eden C7. After a while it just locks up, but neither is 
that deterministic nor does it give out kernel messages. CPU Frequency 
Scaling (which has been known to be a problem with this CPU) is already 
disabled.

I tried the "nohz" boot option to but until it finally hangs (which may 
take hours or days) I can't say for sure whether it works. It shall be 
noticed that watching the interrupts in /proc/interrupts (using 
/usr/bin/watch e.g.) shows that the IRQ0 interrupt does not fire at 100 
Hz, even with nohz, but more like 40-60 Hz. Also, the LOC line in 
/proc/interrupts is not increasing at all (presumable due to the APIC 
emulation).

dmesg:
[    0.000000] No local APIC present or hardware disabled
[    0.000000] mapped APIC to ffffb000 (011ec000)
[   39.983680] Local APIC not detected. Using dummy APIC emulation.
[   39.983426] CPU0: Centaur VIA Nehemiah stepping 08
[   40.545396] PCI: VIA PCI bridge detected. Disabling DAC.
[   40.545564] PCI: Bypassing VIA 8237 APIC De-Assert Message
[   41.803665] PCI: VIA VLink IRQ fixup for 0000:00:0f.0, from 255 to 5

Ideas be welcome, although I guess it's pretty much trial-and-error on 
my side :(
2.6.21 seemed to be a last known good one, though I'd stick with a 
distro kernel as usual.


thanks,
Jan
