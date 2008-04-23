Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYDWQvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYDWQvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYDWQv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:51:29 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:34399 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYDWQv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:51:29 -0400
Message-ID: <480F6905.3070808@tiscali.nl>
Date: Wed, 23 Apr 2008 18:51:17 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: paulus@samba.org, linuxppc-dev@ozlabs.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc: mpic_pasemi_msi: failed allocation unnoticed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bitmap_find_free_region(), called by mpic_msi_alloc_hwirqs() may
return -ENOMEM, but hwirq of type irq_hw_number_t which is unsigned.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
The functions can be found respectively in:
//---[ vi lib/bitmap.c +807 ]---
//---[ vi arch/powerpc/sysdev/mpic_msi.c +39 ]---

diff --git a/arch/powerpc/sysdev/mpic_pasemi_msi.c b/arch/powerpc/sysdev/mpic_pasemi_msi.c
index 33cbfb2..a15ac5c 100644
--- a/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ b/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -109,7 +109,7 @@ static int pasemi_msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		 * sources can be changed independently.
 		 */
 		hwirq = mpic_msi_alloc_hwirqs(msi_mpic, ALLOC_CHUNK);
-		if (hwirq < 0) {
+		if (hwirq == -ENOMEM) {
 			pr_debug("pasemi_msi: failed allocating hwirq\n");
 			return hwirq;
 		}
