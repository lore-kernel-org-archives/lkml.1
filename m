Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbXEFUYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbXEFUYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbXEFUYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:24:47 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:30997 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755280AbXEFUYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:24:46 -0400
Message-ID: <463E3985.6030002@interia.pl>
Date: Sun, 06 May 2007 22:24:37 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk
Subject: [PATCH] Longhaul - Broken again
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-EMID: f6f8acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not so long ago Longhaul was marked broken, because to protect system 
from lockup it was clearing BMDMA master bit on each device. Later I came 
with patches which make use of hardware support present in VIA north and 
south bridges. Unfortunately after some time this support seems to be broken 
for many cases. First report was for older model of Epia mainboard and seemed 
to be only case. There is no explanation for it. Hardware is exactly the same 
as for my M10000, with exception of one additional NIC. There is no way to 
detect broken chipsets. All hardware revisions are exactly the same as on 
perfectly working system.

Yesterday Longhaul was reported as broken for VIA Eden ESP 7000 CPU 
(http://lkml.org/lkml/2007/5/4/115). Transition is successful, but lock up is 
only question of short time. CPU has Nehemiah core and it is claiming that it 
is supporting Longhaul MSR. And it is true. Info in Longhaul MSR is correct.

Yesterday Longhaul was reported to cause lockup. Looks like chipset is blocking 
AGP DMA, internal PCI DMA and processor access to PCI bus, but it is granting 
DMA request to additional PCI card (Hauppauge PVR150). Reported by Wander 
Winkelhorst.

Yesterday Longhaul was reported to cause lockup after 2 or 3 hours of use
(http://lkml.org/lkml/2007/5/4/513). It may sound great on Windows(tm) based 
systems, but for Linux it is unacceptable short time.

Probably there are many more systems on which Longhaul is causing trouble 
directly, by lockup during transition, or triggering bug in other hardware. 
Simply it wasn't reported as broken so far. Even if there are systems on 
which Longhaul is perfectly OK (I'm writting from such system now) there is 
no place for it in the kernel because there is no way to know how to setup 
hardware to correct state (looks like it is more than one bit or register) 
and there is no way to detect broken hardware (looks like there is more then 
one revision).

Signed-off-by: Rafal Bilski <rafalbilski@interia.pl>
---
 arch/i386/kernel/cpu/cpufreq/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/cpu/cpufreq/Kconfig b/arch/i386/kernel/cpu/cpufreq/Kconfig
--- a/arch/i386/kernel/cpu/cpufreq/Kconfig
+++ b/arch/i386/kernel/cpu/cpufreq/Kconfig
@@ -206,7 +206,7 @@ config X86_LONGRUN
 config X86_LONGHAUL
 	tristate "VIA Cyrix III Longhaul"
 	select CPU_FREQ_TABLE
-	depends on ACPI_PROCESSOR
+	depends on ACPI_PROCESSOR && BROKEN
 	help
 	  This adds the CPUFreq driver for VIA Samuel/CyrixIII,
 	  VIA Cyrix Samuel/C3, VIA Cyrix Ezra and VIA Cyrix Ezra-T
-- 



----------------------------------------------------------------------
Kasia Cichopek eksponuje biust  
>>> http://link.interia.pl/f1a6f

