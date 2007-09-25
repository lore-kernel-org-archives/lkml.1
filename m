Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbXIYUuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbXIYUuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXIYUuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:50:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:65215 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXIYUuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=qlTVLvDTlz/1p8YDVN+hInKBbkwJJIcQvdvsjc1OeVO8iXZEsSfZsJWRIrFs8a4HwuFI/wG5gOLEfaFdhGQnXSoPzYuThdz1BYeS4dpdlCsTo6ahKSxpeX8T5u7UwhrU4HiTOTFdUMUDNyZvQ1Au/eDNle4QYjbNyFLV1zgbj6s=
Date: Wed, 26 Sep 2007 00:50:06 +0400
To: venkatesh.pallipadi@intel.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc8-mm1: somewhat broken forced HPET on ICH5
Message-ID: <20070925205006.GA1766@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
is causing the following on Etch boot:

	[initscripts as usual]
	Setting system clock:
	[nothing happens for several seconds]
	select to /dev/rtc to wait for clock tick timed out
	[initscripts as usual]

Then clock is skewed for 3 hours (GMT/MSK difference).

Here is dmesg diff (with junk dropped, mind you) and lspci output and
config snippets:

--- rc8.dmesg
+++ mm.dmesg
@@ -103,0 +200 @@
+Force enabled HPET at base address 0xfed00000
@@ -125,0 +223,3 @@
+hpet clockevent registered
+hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
+hpet0: 3 64-bit timers, 14318180 Hz
@@ -159,0 +260 @@
+Switched to high resolution mode on CPU 0 /* wo-hoo, officially tickless! */


00:00.0 Host bridge [0600]: Intel Corporation 82865G/PE/P DRAM Controller/Host-Hub Interface [8086:2570] (rev 02)
00:01.0 PCI bridge [0604]: Intel Corporation 82865G/PE/P PCI to AGP Controller [8086:2571] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #1 [8086:24d2] (rev 02)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #2 [8086:24d4] (rev 02)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #3 [8086:24d7] (rev 02)
00:1d.3 USB Controller [0c03]: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #4 [8086:24de] (rev 02)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI Controller [8086:24dd] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev c2)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface Bridge [8086:24d0] (rev 02)
00:1f.1 IDE interface [0101]: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller [8086:24db] (rev 02)
00:1f.2 IDE interface [0101]: Intel Corporation 82801EB (ICH5) SATA Controller [8086:24d1] (rev 02)
00:1f.3 SMBus [0c05]: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller [8086:24d3] (rev 02)
00:1f.5 Multimedia audio controller [0401]: Intel Corporation 82801EB/ER (ICH5/ICH5R) AC'97 Audio Controller [8086:24d5] (rev 02)
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV350 AP [Radeon 9600] [1002:4150]
01:00.1 Display controller [0380]: ATI Technologies Inc RV350 AP [Radeon 9600] (Secondary) [1002:4170]
02:03.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)
02:04.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)


CONFIG_HPET_TIMER=y
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_RTC=m
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_RTC_CLASS is not set
