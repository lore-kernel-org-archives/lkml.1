Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXCEEhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXCEEhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXCEEhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:37:12 -0500
Received: from rtr.ca ([64.26.128.89]:4429 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbXCEEhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:37:08 -0500
Message-ID: <45EB9E72.6040107@rtr.ca>
Date: Sun, 04 Mar 2007 23:37:06 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: drzeus-sdhci@drzeus.cx, sdhci-devel@list.drzeus.cx
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] sdhci regression in 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca>
In-Reply-To: <45EB9DC6.8010403@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Another regression, for Pierre Ossman this time.

My syslog gets spammed like this (below) on suspend/resume (to RAM) cycles.
Worked fine, without all of the noise, in all previous kernels up to 2.6.20+.


Mar  4 23:28:45 silvy logger: suspending
Mar  4 23:29:09 silvy kernel: Stopping tasks ... done.
Mar  4 23:29:09 silvy kernel: Suspending console(s)
Mar  4 23:29:09 silvy kernel: pl2303 5-1.3:1.0: no suspend for driver pl2303?
Mar  4 23:29:09 silvy kernel: ACPI: PCI interrupt for device 0000:03:01.2 disabled
Mar  4 23:29:09 silvy kernel: ACPI: PCI interrupt for device 0000:03:00.0 disabled
Mar  4 23:29:09 silvy kernel: ACPI: PCI interrupt for device 0000:00:1f.2 disabled
Mar  4 23:29:09 silvy kernel: ACPI: PCI interrupt for device 0000:00:1e.2 disabled
Mar  4 23:29:09 silvy kernel: ACPI: PCI interrupt for device 0000:00:1d.7 disabled
Mar  4 23:29:09 silvy kernel: ACPI: PCI interrupt for device 0000:00:1d.3 disabled
Mar  4 23:29:09 silvy kernel: ACPI: PCI interrupt for device 0000:00:1d.2 disabled
Mar  4 23:29:09 silvy kernel: ACPI: PCI interrupt for device 0000:00:1d.1 disabled
Mar  4 23:29:09 silvy kernel: ACPI: PCI interrupt for device 0000:00:1d.0 disabled
Mar  4 23:29:09 silvy kernel: Intel machine check architecture supported.
Mar  4 23:29:09 silvy kernel: Intel machine check reporting enabled on CPU#0.
Mar  4 23:29:09 silvy kernel: Back to C!
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 2000d0d0, writing d0d0)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:01.0 at offset 3 (was 10000, writing 10010)
Mar  4 23:29:09 silvy kernel: PCI: Setting latency timer of device 0000:00:01.0 to 64
Mar  4 23:29:09 silvy kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
Mar  4 23:29:09 silvy kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64
Mar  4 23:29:09 silvy kernel: usb usb1: root hub lost power or was reset
Mar  4 23:29:09 silvy kernel: PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
Mar  4 23:29:09 silvy kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 18
Mar  4 23:29:09 silvy kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20a)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1d.1 at offset 8 (was 1, writing bf61)
Mar  4 23:29:09 silvy kernel: usb usb2: root hub lost power or was reset
Mar  4 23:29:09 silvy kernel: PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
Mar  4 23:29:09 silvy kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
Mar  4 23:29:09 silvy kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 309)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1d.2 at offset 8 (was 1, writing bf41)
Mar  4 23:29:09 silvy kernel: usb usb3: root hub lost power or was reset
Mar  4 23:29:09 silvy kernel: PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
Mar  4 23:29:09 silvy kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 17
Mar  4 23:29:09 silvy kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 407)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1d.3 at offset 8 (was 1, writing bf21)
Mar  4 23:29:09 silvy kernel: usb usb4: root hub lost power or was reset
Mar  4 23:29:09 silvy kernel: mmc0: Got command interrupt even though no command operation was in progress.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Card is consuming too much power!
Mar  4 23:29:09 silvy kernel: mmc0: Unexpected interrupt 0x00800000.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 16 (level, low) -> IRQ 16
Mar  4 23:29:09 silvy kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64
Mar  4 23:29:09 silvy kernel: usb usb5: root hub lost power or was reset
Mar  4 23:29:09 silvy kernel: ehci_hcd 0000:00:1d.7: debug port 1
Mar  4 23:29:09 silvy kernel: PCI: cache line size of 32 is not supported by device 0000:00:1d.7
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 10001, writing 8bf18801)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 8 (was 0, writing dfc0dfc0)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was 2280e0f0, writing 22802020)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 6 (was 20030300, writing 20070300)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100107)
Mar  4 23:29:09 silvy kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.2 at offset f (was 100, writing 10b)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 7 (was 0, writing dffffd00)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 6 (was 0, writing dffffe00)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 5 (was 1, writing ec41)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 4 (was 1, writing ed01)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 1 (was 2900000, writing 2900003)
Mar  4 23:29:09 silvy kernel: ACPI: PCI Interrupt 0000:00:1e.2[A] -> GSI 16 (level, low) -> IRQ 16
Mar  4 23:29:09 silvy kernel: PCI: Setting latency timer of device 0000:00:1e.2 to 64
Mar  4 23:29:09 silvy kernel: mmc0: Controller never released inhibit bit(s).
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x2 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x4 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Controller never released inhibit bit(s).
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x2 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x4 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Controller never released inhibit bit(s).
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x2 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x4 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Controller never released inhibit bit(s).
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x2 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x4 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Controller never released inhibit bit(s).
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x2 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x4 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Controller never released inhibit bit(s).
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x2 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x4 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Controller never released inhibit bit(s).
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x2 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x4 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: mmc0: Reset 0x1 never completed.
Mar  4 23:29:09 silvy kernel: sdhci: ============== REGISTER DUMP ==============
Mar  4 23:29:09 silvy kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Mar  4 23:29:09 silvy kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Mar  4 23:29:09 silvy kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Mar  4 23:29:09 silvy kernel: sdhci: ===========================================
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1f.0 at offset 1 (was 2000007, writing 2000107)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1f.2 at offset f (was 200, writing 20a)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1f.2 at offset 9 (was d0000, writing 0)
Mar  4 23:29:09 silvy kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 18
Mar  4 23:29:09 silvy kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1f.3 at offset f (was 200, writing 20a)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:00:1f.3 at offset 1 (was 2800001, writing 2800101)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:01:00.0 at offset f (was 1ff, writing 10b)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:01:00.0 at offset c (was 0, writing dfe00000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:01:00.0 at offset 3 (was 0, writing 10)
Mar  4 23:29:09 silvy kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:00.0 at offset f (was 100, writing 109)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:00.0 at offset 4 (was 0, writing dfcfe000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:00.0 at offset 3 (was 0, writing 4000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100000, writing 100106)
Mar  4 23:29:09 silvy kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 19
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset f (was 7800100, writing 58001ff)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset e (was 0, writing 24fc)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset d (was 0, writing 2400)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset c (was 0, writing 20fc)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset b (was 0, writing 2000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset a (was 0, writing 8ffff000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset 9 (was 0, writing 8c000000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset 8 (was 0, writing 8bfff000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset 7 (was 0, writing 88000000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset 6 (was 0, writing b0070403)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset 4 (was 0, writing dfc00000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.0 at offset 3 (was 820000, writing 82a800)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.1 at offset 4 (was 0, writing dfcfc800)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.1 at offset 3 (was 800000, writing 804000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.1 at offset 1 (was 2100000, writing 2100106)
Mar  4 23:29:09 silvy kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[dfcfc800-dfcfcfff]  Max Packet=[2048]  IR/IT contexts=[4/4]
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.2 at offset 4 (was 0, writing dfcfc700)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.2 at offset 3 (was 800000, writing 804000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:01.2 at offset 1 (was 2100000, writing 2100106)
Mar  4 23:29:09 silvy kernel: ACPI: PCI Interrupt 0000:03:01.2[C] -> GSI 17 (level, low) -> IRQ 18
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:03.0 at offset f (was 18030100, writing 1803010a)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:03.0 at offset 4 (was 0, writing dfcfd000)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:03.0 at offset 3 (was 0, writing 4010)
Mar  4 23:29:09 silvy kernel: PM: Writing back config space on device 0000:03:03.0 at offset 1 (was 2900000, writing 2900112)
Mar  4 23:29:09 silvy kernel: pnp: Device 00:04 does not support activation.
Mar  4 23:29:09 silvy kernel: pnp: Device 00:05 does not support activation.
Mar  4 23:29:09 silvy kernel:  usbdev5.2_ep00: PM: resume from 0, parent 5-1 still 2
Mar  4 23:29:09 silvy kernel: hub 5-1:1.0: PM: resume from 2, parent 5-1 still 2
Mar  4 23:29:09 silvy kernel:  usbdev5.2_ep81: PM: resume from 0, parent 5-1:1.0 still 2
Mar  4 23:29:09 silvy kernel:  usbdev5.2: PM: resume from 0, parent 5-1 still 2
Mar  4 23:29:09 silvy kernel: usb 5-1.3: PM: resume from 2, parent 5-1 still 2
Mar  4 23:29:09 silvy kernel:  usbdev5.3_ep00: PM: resume from 0, parent 5-1.3 still 2
Mar  4 23:29:09 silvy kernel: pl2303 5-1.3:1.0: PM: resume from 2, parent 5-1.3 still 2
Mar  4 23:29:09 silvy kernel:  usbdev5.3_ep81: PM: resume from 0, parent 5-1.3:1.0 still 2
Mar  4 23:29:09 silvy kernel:  usbdev5.3_ep02: PM: resume from 0, parent 5-1.3:1.0 still 2
Mar  4 23:29:09 silvy kernel:  usbdev5.3_ep83: PM: resume from 0, parent 5-1.3:1.0 still 2
Mar  4 23:29:09 silvy kernel:  usbdev5.3: PM: resume from 0, parent 5-1.3 still 2
Mar  4 23:29:09 silvy kernel: usb 5-1.4: PM: resume from 2, parent 5-1 still 2
Mar  4 23:29:09 silvy kernel:  usbdev5.4_ep00: PM: resume from 0, parent 5-1.4 still 2
Mar  4 23:29:09 silvy kernel: usbhid 5-1.4:1.0: PM: resume from 2, parent 5-1.4 still 2
Mar  4 23:29:09 silvy kernel:  usbdev5.4_ep81: PM: resume from 0, parent 5-1.4:1.0 still 2
Mar  4 23:29:09 silvy kernel:  usbdev5.4: PM: resume from 0, parent 5-1.4 still 2
Mar  4 23:29:09 silvy kernel: pl2303 ttyUSB0: PM: resume from 0, parent 5-1.3:1.0 still 2
Mar  4 23:29:09 silvy kernel: Restarting tasks ... done.
Mar  4 23:29:09 silvy NetworkManager: <information>^ISWITCH: terminating current connection 'eth0' because it's no longer valid. 
Mar  4 23:29:09 silvy NetworkManager: <information>^IDeactivating device eth0. 
Mar  4 23:29:09 silvy kernel: usb 5-1: USB disconnect, address 2
Mar  4 23:29:09 silvy kernel: usb 5-1.3: USB disconnect, address 3
Mar  4 23:29:09 silvy kernel: pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
Mar  4 23:29:09 silvy kernel: pl2303 5-1.3:1.0: device disconnected
Mar  4 23:29:09 silvy kernel: usb 5-1.4: USB disconnect, address 4
Mar  4 23:29:09 silvy kernel: ata1.00: configured for UDMA/100
Mar  4 23:29:09 silvy kernel: SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
Mar  4 23:29:09 silvy kernel: sda: Write Protect is off
Mar  4 23:29:09 silvy kernel: sda: Mode Sense: 00 3a 00 00
Mar  4 23:29:09 silvy kernel: SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  4 23:29:09 silvy dhclient: DHCPRELEASE on eth0 to 10.0.0.2 port 67
Mar  4 23:29:09 silvy kernel: usb 5-1: new high speed USB device using ehci_hcd and address 5
Mar  4 23:29:09 silvy dhcdbd: dhco_value_from_text: Non ascii char outside valid hex string:  0 
Mar  4 23:29:09 silvy dhcdbd: dhco_input_option: Value silvy cannot be converted to type X 
Mar  4 23:29:09 silvy dhcdbd: dhco_parse_option_settings: bad option setting: old_host_name = silvy 
Mar  4 23:29:10 silvy kernel: usb 5-1: configuration #1 chosen from 1 choice
Mar  4 23:29:10 silvy kernel: hub 5-1:1.0: USB hub found
Mar  4 23:29:10 silvy kernel: hub 5-1:1.0: 4 ports detected
Mar  4 23:29:10 silvy kernel: ata2.00: configured for UDMA/33
Mar  4 23:29:10 silvy kernel: [drm] Loading R300 Microcode
Mar  4 23:29:10 silvy kernel: usb 5-1.3: new full speed USB device using ehci_hcd and address 6
Mar  4 23:29:10 silvy kernel: usb 5-1.3: configuration #1 chosen from 1 choice
Mar  4 23:29:10 silvy kernel: pl2303 5-1.3:1.0: pl2303 converter detected
Mar  4 23:29:10 silvy kernel: usb 5-1.3: pl2303 converter now attached to ttyUSB0
Mar  4 23:29:10 silvy NetworkManager: nm_device_is_802_3_ethernet: assertion `dev != NULL' failed
Mar  4 23:29:10 silvy NetworkManager: nm_device_is_802_11_wireless: assertion `dev != NULL' failed
Mar  4 23:29:10 silvy NetworkManager: <information>^Imatch 
Mar  4 23:29:10 silvy NetworkManager: <information>^Imatch 
Mar  4 23:29:10 silvy kernel: usb 5-1.4: new low speed USB device using ehci_hcd and address 7
Mar  4 23:29:10 silvy kernel: usb 5-1.4: configuration #1 chosen from 1 choice
Mar  4 23:29:10 silvy kernel: input: Logitech Optical USB Mouse as /class/input/input8
Mar  4 23:29:10 silvy kernel: input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.7-1.4
Mar  4 23:29:11 silvy kernel: b44: eth0: Link is up at 100 Mbps, full duplex.
Mar  4 23:29:11 silvy kernel: b44: eth0: Flow control is off for TX and off for RX.
Mar  4 23:29:11 silvy NetworkManager: <information>^IWill activate wired connection 'eth0' because it now has a link. 
Mar  4 23:29:11 silvy NetworkManager: <information>^ISWITCH: no current connection, found better connection 'eth0'. 
Mar  4 23:29:11 silvy NetworkManager: <information>^IWill activate connection 'eth0'. 
Mar  4 23:29:11 silvy NetworkManager: <information>^IDevice eth0 activation scheduled... 
Mar  4 23:29:11 silvy NetworkManager: <information>^IActivation (eth0) started... 
Mar  4 23:29:11 silvy NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) scheduled... 
Mar  4 23:29:11 silvy NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) started... 
Mar  4 23:29:11 silvy NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) scheduled... 
Mar  4 23:29:11 silvy NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) complete. 
Mar  4 23:29:11 silvy NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) starting... 
Mar  4 23:29:11 silvy NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) successful. 
Mar  4 23:29:11 silvy NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) scheduled. 
Mar  4 23:29:11 silvy NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) complete. 
Mar  4 23:29:11 silvy NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) started... 
Mar  4 23:29:11 silvy NetworkManager: <information>^Imatch 
Mar  4 23:29:12 silvy NetworkManager: <information>^IActivation (eth0) Beginning DHCP transaction. 
Mar  4 23:29:12 silvy NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) complete. 
Mar  4 23:29:12 silvy NetworkManager: <information>^IDHCP daemon state is now 12 (successfully started) for interface eth0 
Mar  4 23:29:13 silvy NetworkManager: <information>^IDHCP daemon state is now 1 (starting) for interface eth0 
Mar  4 23:29:15 silvy dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 5
Mar  4 23:29:15 silvy dhclient: DHCPOFFER from 10.0.0.2
Mar  4 23:29:15 silvy dhclient: DHCPREQUEST on eth0 to 255.255.255.255 port 67
Mar  4 23:29:15 silvy dhclient: DHCPACK from 10.0.0.2
Mar  4 23:29:15 silvy dhcdbd: dhco_value_from_text: Non ascii char outside valid hex string:  0 
Mar  4 23:29:15 silvy dhcdbd: dhco_input_option: Value silvy cannot be converted to type X 
Mar  4 23:29:15 silvy dhcdbd: dhco_parse_option_settings: bad option setting: new_host_name = silvy 
Mar  4 23:29:15 silvy dhcdbd: dhco_value_from_text: Non ascii char outside valid hex string:  0 
Mar  4 23:29:15 silvy dhcdbd: dhco_input_option: Value silvy cannot be converted to type X 
Mar  4 23:29:15 silvy dhcdbd: dhco_parse_option_settings: bad option setting: old_host_name = silvy 
Mar  4 23:29:15 silvy NetworkManager: <information>^IDHCP daemon state is now 2 (bound) for interface eth0 
Mar  4 23:29:15 silvy NetworkManager: <information>^IActivation (eth0) Stage 4 of 5 (IP Configure Get) scheduled... 
Mar  4 23:29:15 silvy NetworkManager: <information>^IActivation (eth0) Stage 4 of 5 (IP Configure Get) started... 
Mar  4 23:29:15 silvy dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.host_name
Mar  4 23:29:15 silvy dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_domain
Mar  4 23:29:15 silvy dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_servers
Mar  4 23:29:15 silvy NetworkManager: <information>^IRetrieved the following IP4 configuration from the DHCP daemon: 
Mar  4 23:29:15 silvy NetworkManager: <information>^I  address 10.0.0.14 
Mar  4 23:29:15 silvy NetworkManager: <information>^I  netmask 255.255.255.0 
Mar  4 23:29:15 silvy NetworkManager: <information>^I  broadcast 10.0.0.255 
Mar  4 23:29:15 silvy NetworkManager: <information>^I  gateway 10.0.0.2 
Mar  4 23:29:15 silvy NetworkManager: <information>^I  nameserver 10.0.0.2 
Mar  4 23:29:15 silvy NetworkManager: <information>^I  nameserver 206.191.0.140 
Mar  4 23:29:15 silvy NetworkManager: <information>^I  nameserver 206.191.0.210 
Mar  4 23:29:15 silvy NetworkManager: <information>^I  domain name 'localnet.' 
Mar  4 23:29:15 silvy NetworkManager: <information>^IActivation (eth0) Stage 5 of 5 (IP Configure Commit) scheduled... 
Mar  4 23:29:15 silvy NetworkManager: <information>^IActivation (eth0) Stage 4 of 5 (IP Configure Get) complete. 
Mar  4 23:29:15 silvy NetworkManager: <information>^IActivation (eth0) Stage 5 of 5 (IP Configure Commit) started... 
Mar  4 23:29:15 silvy dhclient: bound to 10.0.0.14 -- renewal in 37786 seconds.
Mar  4 23:29:16 silvy NetworkManager: <information>^IDHCP returned name servers but system has disabled dynamic modification! 
Mar  4 23:29:16 silvy NetworkManager: <information>^IActivation (eth0) successful, device activated. 
Mar  4 23:29:16 silvy NetworkManager: <information>^Imatch 
Mar  4 23:29:16 silvy NetworkManager: <information>^IActivation (eth0) Finish handler scheduled. 
Mar  4 23:29:16 silvy NetworkManager: <information>^IActivation (eth0) Stage 5 of 5 (IP Configure Commit) complete. 
