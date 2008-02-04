Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYBDR1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYBDR1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbYBDR1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:27:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:6561 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbYBDR1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:27:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=A6R/cr4o9XgEBFIS/i8AGnquOi3YaiAsQxhyiEQpN8Mc4eW0h3JNpMxITUt+FVh60itLhiUqC6eTQt3dpa338Y5HLP5gSo7OOzNDvLeDdVS3Oiyc5GRYKQV+wxB6J1GpzVSI9OftHo308juLGBCaagwR7LntdbI0In4PX7lIBYE=
Message-ID: <47A74B02.8050704@gmail.com>
Date: Mon, 04 Feb 2008 18:27:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: David Brownell <dbrownell@users.sourceforge.net>
CC: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, Dave Airlie <airlied@linux.ie>
Subject: DMAR EHCI failures
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have this in dmesg:
DMAR:[DMA Write] Request device [00:02.0] fault addr ee1512000
DMAR:[fault reason 05] PTE Write access is not set
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
DMAR:[DMA Read] Request device [00:1d.7] fault addr 7d5f0000
DMAR:[fault reason 06] PTE Read access is not set
DMAR:[DMA Read] Request device [00:1a.7] fault addr 7d5f1000
DMAR:[fault reason 06] PTE Read access is not set
PCI-GART: No AMD northbridge found.
DMAR:[DMA Read] Request device [00:1a.2] fault addr 7d5f7000
DMAR:[fault reason 06] PTE Read access is not set

CONFIG_DMAR=y
CONFIG_DMAR_GFX_WA=y
CONFIG_DMAR_FLOPPY_WA=y

Without the gfx workaround, there is much more output regarding 00:02.0. Is 
there problem with broken hw, bios or drivers?

/sys/firmware/acpi/tables/DMAR:
http://www.fi.muni.cz/~xslaby/sklad/DMAR.bin
dmesg:
http://www.fi.muni.cz/~xslaby/sklad/DMAR.dmesg

# for a in 00:02.0 00:1d.7 00:1a.7 00:1a.2; do lspci -vxxx -s $a; done
00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express 
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
         Subsystem: Intel Corporation 82G33/G31 Express Integrated Graphics 
Controller
         Flags: bus master, fast devsel, latency 0, IRQ 16
         Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
         I/O ports at ec00 [size=8]
         Memory at d0000000 (32-bit, prefetchable) [size=256M]
         Memory at ff900000 (32-bit, non-prefetchable) [size=1M]
         Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 
Enable-
         Capabilities: [d0] Power Management version 2
00: 86 80 c2 29 07 00 90 00 02 00 00 03 00 00 00 00
10: 00 00 a8 ff 01 ec 00 00 08 00 00 d0 00 00 90 ff
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 c2 29
30: 00 00 00 00 90 00 00 00 00 00 00 00 0a 01 00 00
40: 09 00 0b 01 00 00 00 00 01 00 00 00 00 00 00 00
50: 00 00 30 02 49 03 00 00 00 00 00 00 00 00 80 7d
60: 00 00 02 03 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 05 d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 11 11 00 00 00 00 06 03 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 00 22 00 00 00 00 00 00 00 00 00 00 01 02 00
e0: 00 00 00 00 00 00 00 00 00 80 00 00 00 00 00 00
f0: 12 00 03 00 00 00 00 00 90 0f 03 00 e4 e0 5b 7d

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1 (rev 02) (prog-if 20 [EHCI])
         Subsystem: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1
         Flags: bus master, medium devsel, latency 0, IRQ 23
         Memory at ffa7b000 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Capabilities: [98] Vendor Specific Information <?>
         Kernel driver in use: ehci_hcd
         Kernel modules: ehci-hcd
00: 86 80 3a 29 06 00 90 22 02 20 03 0c 00 00 00 00
10: 00 b0 a7 ff 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 3a 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 ff 01 00 00 00 00 01 00 00 01 00 00 08 00
70: 00 00 cf 0f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 09 00 06 20 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 88 85 40 00 86 0f 02 00 06 17 02 20

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #2 (rev 02) (prog-if 20 [EHCI])
         Subsystem: Intel Corporation Optiplex 755
         Flags: bus master, medium devsel, latency 0, IRQ 19
         Memory at ffa7b400 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Capabilities: [98] Vendor Specific Information <?>
         Kernel driver in use: ehci_hcd
         Kernel modules: ehci-hcd
00: 86 80 3c 29 06 00 90 22 02 20 03 0c 00 00 00 00
10: 00 b4 a7 ff 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 3c 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 03 04 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 ff 01 00 00 00 00 01 00 00 01 00 00 08 00
70: 00 00 cf 0f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 09 00 06 20 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 88 85 40 00 86 0f 02 00 06 17 02 20

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #6 (rev 02) (prog-if 00 [UHCI])
         Subsystem: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6
         Flags: bus master, medium devsel, latency 0, IRQ 18
         I/O ports at d480 [size=32]
         Capabilities: [50] Vendor Specific Information <?>
         Kernel driver in use: uhci_hcd
00: 86 80 39 29 05 00 90 22 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 d4 00 00 00 00 00 00 00 00 00 00 86 80 39 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 0c 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 09 00 06 20 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
