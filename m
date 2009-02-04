Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbZBDVnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbZBDVnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbZBDVnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:43:10 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:43352 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbZBDVnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:43:08 -0500
Date: Wed, 4 Feb 2009 22:43:04 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: galak@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/powerpc: Eliminate double sizeof
Message-ID: <Pine.LNX.4.64.0902042236200.3091@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Taking sizeof the result of sizeof is quite strange and does not seem to be
what is wanted here.

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
@@

- sizeof (
  sizeof (E)
- )

@@
type T;
@@

- sizeof (
  sizeof (T)
- )
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
--- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -186,7 +186,7 @@ out_unmap_regs:
 	iounmap(priv->regs);
 out_free_bootmem:
 	free_bootmem((unsigned long)priv,
-	             sizeof(sizeof(struct pq2ads_pci_pic)));
+	             sizeof(struct pq2ads_pci_pic));
 	of_node_put(np);
 out_unmap_irq:
 	irq_dispose_mapping(irq);
