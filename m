Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYKKKqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYKKKqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYKKKqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:46:34 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:45611 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbYKKKqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:46:33 -0500
Message-Id: <491970BA.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 11 Nov 2008 10:47:06 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-pci@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] fix multi_msi_enable()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And isn't multi_msi_enable(), though unused (since msi_{en,dis}able() are
unused), broken altogether (shifting num right by 1 instead of taking the
binary log)?

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/pci/msi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.28-rc4/drivers/pci/msi.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.28-rc4-pci-multi-msi-enable/drivers/pci/msi.h	2008-11-07 09:13:09.000000000 +0100
@@ -23,7 +23,7 @@
 #define multi_msi_capable(control) \
 	(1 << ((control & PCI_MSI_FLAGS_QMASK) >> 1))
 #define multi_msi_enable(control, num) \
-	control |= (((num >> 1) << 4) & PCI_MSI_FLAGS_QSIZE);
+	control |= ((fls((num) - 1) << 4) & PCI_MSI_FLAGS_QSIZE)
 #define is_64bit_address(control)	(!!(control & PCI_MSI_FLAGS_64BIT))
 #define is_mask_bit_support(control)	(!!(control & PCI_MSI_FLAGS_MASKBIT))
 #define msi_enable(control, num) multi_msi_enable(control, num); \



