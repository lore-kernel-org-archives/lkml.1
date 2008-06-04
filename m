Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYFDB4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYFDB4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 21:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbYFDB4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 21:56:07 -0400
Received: from bizon.gios.gov.pl ([212.244.124.8]:41596 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYFDB4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 21:56:06 -0400
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 21:56:05 EDT
Date: Wed, 04 Jun 2008 03:40:17 +0200
From: Krzysztof Oledzki <ole@ans.pl>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Subject: [PATCH]  Add another PCI ID for ICH6 force hpet.
Message-ID: <4845f281.8dQsWzXdrYDR2glC%ole@ans.pl>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4c01199fa9cd9e5871ca96cd243a03aeae0d0f48 Mon Sep 17 00:00:00 2001
From: Krzysztof Piotr Oledzki <ole@ans.pl>
Date: Wed, 4 Jun 2008 03:30:26 +0200
Subject: [HPET] Add another PCI ID for ICH6 force hpet.

Tested on Asus P5GDC-V

$ lspci -n -n |grep ISA
00:1f.0 ISA bridge [0601]: Intel Corporation 82801FB/FR (ICH6/ICH6R) LPC Interface Bridge [8086:2640] (rev 03)

Force enabled HPET at base address 0xfed00000
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
---
 arch/x86/kernel/quirks.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index d89a648..06e1fd6 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -158,6 +158,8 @@ static void ich_force_enable_hpet(struct pci_dev *dev)
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,
 			 ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_0,
+			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
 			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0,
-- 
1.5.5.3

