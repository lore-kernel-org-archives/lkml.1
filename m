Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbXIPKrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbXIPKrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 06:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbXIPKrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 06:47:17 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:44771 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbXIPKrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 06:47:17 -0400
Date: Sun, 16 Sep 2007 13:47:13 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: TSC && HPET calibration
Message-ID: <20070916104713.i3gu2p43ciifjc55@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-09-13)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

/var/log # grep -Ei "hpet|tsc" dmesg-2.6.19.7 dmesg.2.6.22.6-x86_64 
dmesg-2.6.19.7:ACPI: HPET (v001 INTEL  DQ965GF  0x000015db MSFT 0x01000013) @ 0x3e6f2000
dmesg-2.6.19.7:ACPI: HPET id: 0x8086a201 base: 0xfed00000
dmesg-2.6.19.7:[   34.337155] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
dmesg-2.6.19.7:[   34.337296] hpet0: 3 64-bit timers, 14318180 Hz [*]
dmesg-2.6.19.7:[   34.338350] Using HPET for base-timer
dmesg-2.6.19.7:[   34.594096] checking TSC synchronization across 2 CPUs: passed.
dmesg-2.6.19.7:[    0.215896] hpet_resources: 0xfed00000 is busy
dmesg-2.6.19.7:[    7.794166] Time: tsc clocksource has been installed.
dmesg.2.6.22.6-x86_64:ACPI: HPET 3E6F2000, 0038 (r1 INTEL  DQ965GF      1741 MSFT  1000013)
dmesg.2.6.22.6-x86_64:ACPI: HPET id: 0x8086a201 base: 0xfed00000
dmesg.2.6.22.6-x86_64:[    0.000000] hpet clockevent registered
dmesg.2.6.22.6-x86_64:[    0.000000] TSC calibrated against HPET
dmesg.2.6.22.6-x86_64:[   23.917469] checking TSC synchronization [CPU#0 -> CPU#1]:
dmesg.2.6.22.6-x86_64:[   23.937970] Measured 196 cycles TSC warp between CPUs, turning off TSC clock.
dmesg.2.6.22.6-x86_64:[   23.938030] Marking TSC unstable due to check_tsc_sync_source failed
dmesg.2.6.22.6-x86_64:[   23.968187] Time: hpet clocksource has been installed.
dmesg.2.6.22.6-x86_64:[   23.997754] hpet_acpi_add: no address or irqs in _CRS

# grep MHz /proc/cpuinfo 
cpu MHz         : 2797.203
cpu MHz         : 2797.203

# calc 2797203000/196
        ~14271443.87755102040816326531 [*]

so, does TSC calibration against HPET screw up TSC synchronization?

I have Intel(R) Pentium(R) D CPU 2.80GHz and
DQ965GF motherboard, BIOS v.5953.

-- 
Do what you love because life is too short for anything else.

