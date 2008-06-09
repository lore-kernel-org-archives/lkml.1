Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbYFINPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbYFINPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYFINPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:15:11 -0400
Received: from main.gmane.org ([80.91.229.2]:60064 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYFINPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:15:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Joe Buehler <aspam@cox.net>
Subject: [PATCH]  Add PCI ID for 6300ESB force hpet
Date: Mon, 09 Jun 2008 08:55:20 -0400
Message-ID: <g2j97o$es2$1@ger.gmane.org>
References: <4845f281.8dQsWzXdrYDR2glC%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: netrokpix001.spirentcom.com
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
In-Reply-To: <4845f281.8dQsWzXdrYDR2glC%ole@ans.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on Supermicro X6DVA-EG2.

# lspci
00:1f.0 ISA bridge: Intel Corporation 6300ESB LPC Interface Controller (rev 02)
# lspci -n
00:1f.0 Class 0601: 8086:25a1 (rev 02)

kernel: pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
kernel: hpet clockevent registered
kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
kernel: hpet0: 3 64-bit timers, 14318180 Hz

--- linux-2.6.25.3/arch/x86/kernel/quirks.c.~1~	2008-05-10 00:48:50.000000000 -0400
+++ linux-2.6.25.3/arch/x86/kernel/quirks.c	2008-06-04 14:54:55.000000000 -0400
@@ -255,6 +255,8 @@
  		old_ich_force_enable_hpet(dev);
  }

+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_1,
+			 old_ich_force_enable_hpet_user);
  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_0,
  			 old_ich_force_enable_hpet_user);
  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_12,

-- 
Joe Buehler

