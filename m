Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbZDWXUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbZDWXUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZDWXUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:20:00 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:62244 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZDWXT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:19:59 -0400
Date: Thu, 23 Apr 2009 19:19:42 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, x86@kernel.org
Subject: [PATCH] HPET: stop soliciting hpet=force users on ICH4M
In-reply-to: <alpine.LFD.2.00.0904231917030.15843@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0904231918510.15843@localhost.localdomain>
References: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain>
 <alpine.LFD.2.00.0904231917030.15843@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The HPET in the ICH4M is not documented in the data sheet
because it was not officially validated.

While it is fine for hackers to continue to use "hpet=force"
to enable the hardware that they have, it is not prudent to
solicit additional "hpet=force" users on this hardware.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/quirks.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index e95022e..7563b31 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -261,8 +261,6 @@ static void old_ich_force_enable_hpet_user(struct pci_dev *dev)
 {
 	if (hpet_force_user)
 		old_ich_force_enable_hpet(dev);
-	else
-		hpet_print_force_info();
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_1,
-- 
1.6.3.rc1.34.g0be9b


