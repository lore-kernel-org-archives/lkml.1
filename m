Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbXKTR2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbXKTR2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbXKTR2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:28:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:10756 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbXKTR2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:28:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=evVNOfYOITPEfNnaYvBpTcUUVnJpSBJrYyKT/K9alqJ2ga+aRlC4w2tW/23zakXw3nuJQ3lCsbk5Q0+YFs3sdAhKsCYtNOX0ZNii4yhrYGdVcFVC4rTCO9vQO7b4f37+T2bVje3wK5P+eMAuBHBJEBLkjyM/XLMJcX6806itPT0=
Date: Tue, 20 Nov 2007 20:28:33 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH] SPARC64: check for possible NULL pointer dereference
Message-ID: <20071120172833.GB7275@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch adds checking for possible NULL pointer dereference
if of_find_property() failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
I'm not sure about the message being printed in worst case.
Check please.

 arch/sparc64/kernel/pci_sun4v.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index 8c4875b..e587a37 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -1022,6 +1022,10 @@ void __init sun4v_pci_init(struct device_node *dp, char *model_name)
 	}
 
 	prop = of_find_property(dp, "reg", NULL);
+	if (!prop) {
+		prom_printf("SUN4V_PCI: Could not find config registers\n");
+		prom_halt();
+	}
 	regs = prop->value;
 
 	devhandle = (regs->phys_addr >> 32UL) & 0x0fffffff;
