Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbYI1TrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbYI1TrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 15:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYI1TrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 15:47:05 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:17715 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbYI1TrD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 15:47:03 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: sdhci: Loads of scary messages during suspend/resume with SD card inserted
Date: Sun, 28 Sep 2008 21:46:57 +0200
User-Agent: KMail/1.9.9
Cc: drzeus-mmc@drzeus.cx, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809282146.57960.elendil@planet.nl>
X-OriginalArrivalTime: 28 Sep 2008 19:46:58.0781 (UTC) FILETIME=[F81C90D0:01C921A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My HP 2510p has an SD card slot and a few days ago I bought one to be able
to add support for SD cards in the Debian Installer.

Whilst playing with it, I found the following messages in my logs during
suspend. At the time the card was inserted, but nothing on it was mounted.

There also seems to be a problem while resuming, especially:
mmc mmc0:8879: parent mmc0 should not be sleeping
More context at the bottom of the mail.

>From lspci -vvv:
02:06.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
        Subsystem: Hewlett-Packard Company Device 30c9
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 20
        Region 0: Memory at e0102000 (32-bit, non-prefetchable) [size=256]
        Capabilities: <access denied>
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci

02:06.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev ff) (prog-if ff)
        !!! Unknown header type 7f
        Kernel driver in use: ricoh-mmc
        Kernel modules: ricoh_mmc

Cheers,
FJP

Messages from kern.log during suspend:
Sep 28 23:12:39 aragorn kernel: Suspending console(s) (use no_console_suspend to debug)
Sep 28 23:12:39 aragorn kernel: pci 0000:00:02.0: PCI INT A disabled
Sep 28 23:12:39 aragorn kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
Sep 28 23:12:39 aragorn kernel: sd 0:0:0:0: [sda] Stopping disk
Sep 28 23:12:39 aragorn kernel: ACPI handle has no context!
Sep 28 23:12:39 aragorn kernel: ricoh-mmc: Suspending.
Sep 28 23:12:39 aragorn kernel: ricoh-mmc: Controller is now re-enabled.
Sep 28 23:12:39 aragorn kernel: mmc0: card 8879 removed
Sep 28 23:12:39 aragorn kernel: MMC: killing requests for dead queue
Sep 28 23:12:39 aragorn kernel: ACPI handle has no context!
Sep 28 23:12:39 aragorn kernel: sdhci-pci 0000:02:06.2: PCI INT C disabled
Sep 28 23:12:39 aragorn kernel: ACPI handle has no context!
Sep 28 23:12:39 aragorn kernel: ACPI handle has no context!
Sep 28 23:12:39 aragorn kernel: iwlagn 0000:10:00.0: PCI INT A disabled
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: ata2: port disabled. ignoring.
Sep 28 23:12:39 aragorn kernel: ata_piix 0000:00:1f.1: PCI INT A disabled
Sep 28 23:12:39 aragorn kernel: ehci_hcd 0000:00:1d.7: PCI INT A disabled
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: uhci_hcd 0000:00:1d.2: PCI INT C disabled
Sep 28 23:12:39 aragorn kernel: uhci_hcd 0000:00:1d.1: PCI INT B disabled
Sep 28 23:12:39 aragorn kernel: uhci_hcd 0000:00:1d.0: PCI INT A disabled
Sep 28 23:12:39 aragorn kernel: HDA Intel 0000:00:1b.0: PCI INT A disabled
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: HDA Intel 0000:00:1b.0: power state changed by ACPI to D3
Sep 28 23:12:39 aragorn kernel: ehci_hcd 0000:00:1a.7: PCI INT C disabled
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: uhci_hcd 0000:00:1a.1: PCI INT B disabled
Sep 28 23:12:39 aragorn kernel: uhci_hcd 0000:00:1a.0: PCI INT A disabled
Sep 28 23:12:39 aragorn kernel: ACPI handle has no context!
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Controller never released inhibit bit(s).
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x2 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x4 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: mmc0: Reset 0x1 never completed.
Sep 28 23:12:39 aragorn kernel: sdhci: ============== REGISTER DUMP ==============
Sep 28 23:12:39 aragorn kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
Sep 28 23:12:39 aragorn kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
Sep 28 23:12:39 aragorn kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
Sep 28 23:12:39 aragorn kernel: sdhci: ===========================================
Sep 28 23:12:39 aragorn kernel: ACPI: Preparing to enter system sleep state S3
Sep 28 23:12:39 aragorn kernel: Disabling non-boot CPUs ...
Sep 28 23:12:39 aragorn kernel: CPU 1 is now offline
Sep 28 23:12:39 aragorn kernel: SMP alternatives: switching to UP code
Sep 28 23:12:39 aragorn kernel: CPU0 attaching NULL sched-domain.
Sep 28 23:12:39 aragorn kernel: CPU1 attaching NULL sched-domain.
Sep 28 23:12:39 aragorn kernel: CPU0 attaching NULL sched-domain.
Sep 28 23:12:39 aragorn kernel: CPU1 is down

Messages from kern.log during resume:
Sep 28 23:12:39 aragorn kernel: sdhci-pci 0000:02:06.2: restoring config space at offset 0xf (was 0x300, writing 0x30a)
Sep 28 23:12:39 aragorn kernel: sdhci-pci 0000:02:06.2: restoring config space at offset 0x4 (was 0x0, writing 0xe0102000)
Sep 28 23:12:39 aragorn kernel: sdhci-pci 0000:02:06.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
Sep 28 23:12:39 aragorn kernel: sdhci-pci 0000:02:06.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
Sep 28 23:12:39 aragorn kernel: sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
Sep 28 23:12:39 aragorn kernel: ricoh-mmc: Resuming.
Sep 28 23:12:39 aragorn kernel: ricoh-mmc: Controller is now disabled.
Sep 28 23:12:39 aragorn kernel: sd 0:0:0:0: [sda] Starting disk
Sep 28 23:12:39 aragorn kernel: mmc0: new SD card at address 8879
Sep 28 23:12:39 aragorn kernel: mmc mmc0:8879: parent mmc0 should not be sleeping
Sep 28 23:12:39 aragorn kernel: mmcblk0: mmc0:8879 SU02G 1985024KiB
Sep 28 23:12:39 aragorn kernel:  mmcblk0: p1

