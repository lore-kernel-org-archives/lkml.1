Return-Path: <linux-kernel-owner+w=401wt.eu-S936415AbYCSWpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936415AbYCSWpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765058AbYCSVQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:16:06 -0400
Received: from tur.go2.pl ([193.17.41.50]:58883 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936698AbYCSVQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:16:03 -0400
From: Zbigniew Luszpinski <zbiggy@o2.pl>
Date: Wed, 19 Mar 2008 15:51:50 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Subject: [PATCH] arch/x86/kernel/quirks.c, kernel 2.6.24.3, hpet clock enable on nVidia nForce 430
To: linux-kernel@vger.kernel.org
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GiS4HWAO0nciyjw"
Message-Id: <200803191551.50538.zbiggy@o2.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_GiS4HWAO0nciyjw
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

this patch allows hpet=force on nVidia nForce 430 southbridge.
This patch was tested by me on my old Asus A8N-VM CSM (where bios does not 
support hpet and does not advertise it via acpi entry). My nForce430 version:
lspci -nn | grep LPC
00:0a.0 ISA bridge [0601]: nVidia Corporation MCP51 LPC Bridge [10de:0260] 
(rev a2)

Kernel 2.6.24.3 after patching and using hpet=force reports this:
dmesg | grep -i hpet
Kernel command line: root=/dev/sda8 ro vga=773 video=vesafb:mtrr:4,ywrap 
vt.default_utf8=0 hpet=force
Force enabled HPET at base address 0xfed00000
hpet clockevent registered
Time: hpet clocksource has been installed.

grep -i hpet /proc/timer_list
Clock Event Device: hpet
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode

grep Clock /proc/timer_list (before patching)
Clock Event Device: pit
Clock Event Device: lapic

grep Clock /proc/timer_list (after patching)
Clock Event Device: hpet
Clock Event Device: lapic

have a nice day,
Zbigniew 'zbiggy' Luszpinski

--Boundary-00=_GiS4HWAO0nciyjw
Content-Type: text/x-diff;
  charset="us-ascii";
  name="nforce430.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="nforce430.patch"

--- linux-2.6.24.3/arch/x86/kernel/quirks.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24.3/arch/x86/kernel/quirks.c	2008-03-13 03:01:19.000000000 +0100
@@ -355,6 +355,8 @@
 			nvidia_force_enable_hpet);
 
 /* LPC bridges */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0260,
+			nvidia_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0360,
 			nvidia_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0361,

--Boundary-00=_GiS4HWAO0nciyjw--
