Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYKDRdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYKDRdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYKDRdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:33:24 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:56745 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbYKDRdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:33:23 -0500
Date: Tue, 4 Nov 2008 18:33:00 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081104173300.GF6134@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 04 Nov 2008 18:32:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

not sure whether this is already reported or not. However, in 2.6.28-rc3
I discovered about 10 secs delay before mounting the root fs and running init
(not sure whether the delay is caused by mount or init). It did not appear in
2.6.27. I did not try any previous 2.6.28-rcX.

This is from dmesg in 2.6.28-rc3. 

[    7.880966] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    8.103116] input: TPPS/2 IBM TrackPoint as
/devices/platform/i8042/serio1/serio2/input/input7
[   28.993523] kjournald starting.  Commit interval 5 seconds
[   28.993581] EXT3-fs: mounted filesystem with ordered data mode.
[   28.993638] VFS: Mounted root (ext3 filesystem) readonly.
[   28.993675] Freeing unused kernel memory: 332k freed
[   37.697648] uhci_hcd: USB Universal Host Controller Interface driver
[   37.697740] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ
20
[   37.697779] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   37.697785] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   37.698005] drivers/usb/core/inode.c: creating file 'devices'
[   37.698008] drivers/usb/core/inode.c: creating file '001'
[   37.698131] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus
number 1
[   37.698176] uhci_hcd 0000:00:1a.0: detected 2 ports
[   37.698205] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000


This is from 2.6.27 kernel:
[    8.215972] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    8.452174] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input7
[    9.016605] kjournald starting.  Commit interval 5 seconds
[    9.016634] EXT3-fs: mounted filesystem with ordered data mode.
[    9.016663] VFS: Mounted root (ext3 filesystem) readonly.
[    9.016756] Freeing unused kernel memory: 296k freed
[   18.963410] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   18.963461] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
[   18.969726] USB Universal Host Controller Interface driver v3.0
[   18.987703] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[   18.987732] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   19.023978] sdhci: Secure Digital Host Controller Interface driver
[   19.024017] sdhci: Copyright(c) Pierre Ossman
[   19.084812] input: PC Speaker as /devices/platform/pcspkr/input/input8
[   19.366304] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   19.372539] ACPI: WMI: Mapper loaded
[   19.570065] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1a:6b:d2:bd:81
[   19.570105] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   19.570172] 0000:00:19.0: eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
[   19.570301] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   19.570343] uhci_hcd 0000:00:1a.0: UHCI Host Controller

-- 
Luká¹ Hejtmánek
