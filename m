Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbYAYItg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbYAYItg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbYAYIqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:46:00 -0500
Received: from l1ms.rz.uni-kiel.de ([134.245.11.86]:7576 "EHLO
	l1ms.rz.uni-kiel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068AbYAYIp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:45:57 -0500
X-Greylist: delayed 2178 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 03:45:57 EST
To: linux-kernel@vger.kernel.org
Subject: parport_ieee1284_epp_read_addr patch
From: Stephan Boettcher <boettcher@physik.uni-kiel.de>
Date: Fri, 25 Jan 2008 09:09:33 +0100
Message-ID: <s6n3asmqqbm.fsf@blaulicht.switch.brux>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tim,

Please consider the included patch to fix a 1-bit bug in the software
emulation of parport epp addr read mode.

I am not subscribed to the LKML.

Thanks
Stephan


--- linux-2.6.24-rc6/drivers/parport/ieee1284_ops.c~	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.24-rc6/drivers/parport/ieee1284_ops.c	2008-01-24 22:15:05.000000000 +0100
@@ -888,7 +888,7 @@
 
 		/* Event 59: set nSelectIn (nAStrb) high */
 		parport_frob_control (port, PARPORT_CONTROL_SELECT,
-				      PARPORT_CONTROL_SELECT);
+				      0);
 
 		/* Event 60: wait for Busy to go low */
 		if (parport_poll_peripheral (port, PARPORT_STATUS_BUSY, 

Background:  

We bought cheep notebooks to control our custom data acquisition
system, which requires EPP mode (read/write, data/addr).  The bios
does not offer EPP mode, and indeed hardware EPP mode appears not to
work, although the parport driver tries to use it.  EPPSWE mode does
work for data r/w and addr write, but addr read requires this
patch. 

(stephan)rshgse3: lspci

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controller AHCI (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8055 PCI-E Gigabit Ethernet Controller (rev 12)
05:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
08:03.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b3)
08:03.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 08)
08:03.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 17)

(stephan)rshgse3: grep . /proc/sys/dev/parport/parport0/*

/proc/sys/dev/parport/parport0/base-addr:888    1912
/proc/sys/dev/parport/parport0/dma:-1
/proc/sys/dev/parport/parport0/irq:7
/proc/sys/dev/parport/parport0/modes:PCSPP,TRISTATE,EPP
/proc/sys/dev/parport/parport0/spintime:500

-- 
Stephan Böttcher                     FAX: +49-431-85660
Extraterrestrische Physik            Tel: +49-431-880-2508
I.f.Exp.u.Angew.Physik               mailto:boettcher@physik.uni-kiel.de
Leibnizstr. 11, 24118 Kiel, Germany
