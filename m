Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYLPBf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYLPBf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYLPBfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:35:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47954 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYLPBfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:35:13 -0500
Date: Tue, 16 Dec 2008 02:35:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Allow HPET force enable on ICH10 HPET
Message-ID: <20081216013547.GA24992@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow HPET force enable on ICH10 HPET

Intel "Smackover" x58 BIOS don't have HPET enabled in the BIOS, so allow
to force enable it at least. The register layout is the same
as in other recent ICHs, so all the code can be reused.

Using numerical PCI-ID because it's unlikely the PCI-ID will be used
anywhere else.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/quirks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.28-rc4-test/arch/x86/kernel/quirks.c
===================================================================
--- linux-2.6.28-rc4-test.orig/arch/x86/kernel/quirks.c	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-rc4-test/arch/x86/kernel/quirks.c	2008-12-15 17:31:24.000000000 +0100
@@ -170,7 +170,8 @@
 			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_7,
 			 ich_force_enable_hpet);
-
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x3a16,	/* ICH10 */
+			 ich_force_enable_hpet);
 
 static struct pci_dev *cached_dev;
 
