Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbYA0OdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbYA0OdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 09:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbYA0OdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 09:33:04 -0500
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:52112 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbYA0OdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 09:33:03 -0500
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alistair John Strachan <alistair@devzero.co.uk>
Subject: [PATCH] Force enable HPET on (some?) ICH9 boards
Date: Sun, 27 Jan 2008 14:32:59 +0000
Message-Id: <1201444379-4223-1-git-send-email-alistair@devzero.co.uk>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some consumer ICH9 boards (such as the Abit IP35 Pro) do not provide a BIOS
option for enabling the HPET. The same ICH workaround used for 6,7,8 can be
applied to 9. Here I enable the only PCI id that was visible on my system.

I have confirmed the HPETs work both from userspace and as a clocksource for
the running kernel (2.6.24 here) after applying this patch.

Force enabled HPET at base address 0xfed00000
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz

Signed-off-by: Alistair John Strachan <alistair@devzero.co.uk>

---
 arch/x86/kernel/quirks.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index fab30e1..150ba29 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -162,6 +162,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_31,
 			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_1,
 			 ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_7,
+			 ich_force_enable_hpet);
 
 
 static struct pci_dev *cached_dev;

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
