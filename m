Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYBRCnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYBRCnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 21:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYBRCni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 21:43:38 -0500
Received: from manwe.elfove.cz ([217.31.52.168]:54657 "EHLO manwe.elfove.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYBRCnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 21:43:37 -0500
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 21:43:37 EST
Message-ID: <47B8EBB2.7060807@elfove.cz>
Date: Mon, 18 Feb 2008 03:21:38 +0100
From: Tomas Hlavacek <brill@elfove.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: shannon.nelson@intel.com, linux-kernel@vger.kernel.org
Subject: ioatdma Self-test copy timeout
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short description: In 2.6.25-rc2 ioatdma driver fails to initialize due 
to Self-test timeout when the ioatdma is linked into the kernel.


Long descr: When I select to compile ioatdma into the kernel I get:

ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:08.0 to 64
ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine found, 4 channels, 
device version 0x12, driver version 2.04
ioatdma: ioat_dma_test_callback(0000000000008086)
ioatdma 0000:00:08.0: Self-test copy timed out, disabling
ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine initialization failed
ACPI: PCI interrupt for device 0000:00:08.0 disabled

As a kernel module ioatdma initializes just fine with the same kernel on 
the same HW without any other changes than selecting it to be a module. 
And it also succeeded to initialize when i tried to do this:

--- a/drivers/dma/ioat_dma.c    2008-02-17 01:52:19.000000000 +0100
+++ b/drivers/dma/ioat_dma.c    2008-02-18 02:47:27.000000000 +0100
@@ -1089,7 +1089,7 @@
                goto free_resources;
        }
        device->common.device_issue_pending(dma_chan);
-       msleep(1);
+       msleep(100);
 
        if (device->common.device_is_tx_complete(dma_chan, cookie, NULL, 
NULL)
                                        != DMA_SUCCESS) {


My lspci:
00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller 
Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 2-3 (rev b1)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 4-5 (rev b1)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 6-7 (rev b1)
00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA 
Engine (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev b1)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #3 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC 
Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller 
(rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus 
Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Upstream Port (rev 01)
01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to 
PCI-X Bridge (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E1 (rev 01)
02:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E2 (rev 01)
02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E3 (rev 01)
05:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit 
Ethernet Controller (Copper) (rev 01)
05:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit 
Ethernet Controller (Copper) (rev 01)
07:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet 
Controller (rev 06)
07:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet 
Controller (rev 06)
09:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

I placed my full dmesg output here: 
http://manwe.elfove.cz/~brill/tmp/dmesg-2.6.25-rc2

-- 
Tomas Hlavacek <brill@elfove.cz>

