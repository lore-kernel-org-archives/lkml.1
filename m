Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZFPPes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZFPPes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZFPPei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:34:38 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:41318 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbZFPPeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:34:37 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch6bh43j)
X-WSS-ID: 0KLC8L4-04-6I6-01
Date: Tue, 16 Jun 2009 17:34:17 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: jesse.brandeburg@intel.com
CC: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: dma-debug warning with ixgbe
Message-ID: <20090616153417.GN5139@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Jun 2009 15:34:18.0076 (UTC) FILETIME=[E97151C0:01C9EE97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

today I got this dma-debug warning with the ixgbe driver with a kernel
near 2.6.30-rc8.

------------[ cut here ]------------
WARNING: at /data/repos/linux-2.6-iommu/lib/dma-debug.c:806
check_unmap+0x214/0x5c3()
Hardware name: Toonie
ixgbe 0000:02:00.0: DMA-API: device driver frees DMA memory with
different size [device address=0x0000000000045c12] [map size=258
bytes] [unmap size=256 bytes]
Modules linked in: loop i2c_piix4 tpm_infineon rtc_cmos tpm
tpm_bios rtc_core rtc_lib button ata_generic pata_acpi usbhid
pata_atiixp ixgbe hid dca bnx2
Pid: 4391, comm: ifconfig Not tainted 2.6.30-rc81 #1
Call Trace:
 [<ffffffff8039125a>] ? check_unmap+0x214/0x5c3
 [<ffffffff80238d72>] warn_slowpath_common+0x77/0xa4
 [<ffffffff80238e14>] warn_slowpath_fmt+0x64/0x66
 [<ffffffff80391134>] ? check_unmap+0xee/0x5c3
 [<ffffffff8058970b>] ? _spin_lock_irqsave+0x3f/0x4b
 [<ffffffff80391134>] ? check_unmap+0xee/0x5c3
 [<ffffffff8039125a>] check_unmap+0x214/0x5c3
 [<ffffffff80391813>] debug_dma_unmap_page+0x51/0x53
 [<ffffffffa002e29c>] ixgbe_clean_rx_ring+0xb9/0x1e4 [ixgbe]
 [<ffffffffa002f2f6>] ixgbe_down+0x2f8/0x34e [ixgbe]
 [<ffffffffa00307a8>] ixgbe_reinit_locked+0x59/0x70 [ixgbe]
 [<ffffffffa0030837>] ixgbe_change_mtu+0x78/0x82 [ixgbe]
 [<ffffffff804f56b5>] dev_set_mtu+0x3a/0x69
 [<ffffffff804f688c>] dev_ifsioc+0xcf/0x2cc
 [<ffffffff804f7018>] dev_ioctl+0x58f/0x647
 [<ffffffff80351978>] ? avc_has_perm+0x4e/0x60
 [<ffffffff804e4e7f>] sock_ioctl+0x21f/0x231
 [<ffffffff802cb478>] vfs_ioctl+0x2a/0x78
 [<ffffffff802cb934>] do_vfs_ioctl+0x46e/0x4aa
 [<ffffffff80250521>] ? up_read+0x26/0x2b
 [<ffffffff802cb9c5>] sys_ioctl+0x55/0x77
 [<ffffffff8020afab>] system_call_fastpath+0x16/0x1b
---[ end trace f560e4a00a9d5d32 ]---
Mapped at:
 [<ffffffff80391bca>] debug_dma_map_page+0x7c/0x11f
 [<ffffffffa002b3ba>] ixgbe_alloc_rx_buffers+0x247/0x316 [ixgbe]
 [<ffffffffa002bc5a>] ixgbe_configure+0x7d1/0x7e3 [ixgbe]
 [<ffffffffa002ffb9>] ixgbe_open+0xed/0x63b [ixgbe]
 [<ffffffff804f5d48>] dev_open+0x7c/0xc2

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

