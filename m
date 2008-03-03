Return-Path: <linux-kernel-owner+w=401wt.eu-S1762335AbYCCT1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335AbYCCT1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbYCCT1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:27:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:35620 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbYCCT1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:27:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dglhmW6RahBTAi+cshcnhqRUxWXtngv+yBsU0hrqm8kPd7xLeWkNcYHiHKmIJqYwuQ1W3H6MT6X3GRR+a97pIZbbnmMBSAE8ouIzVXuAg+bNFtP+gx+isbqCIFuNSKgcRa5QePCYA+NsjqYzoWvOu1BKqt3gwATik/M8ExF/hzo=
Subject: [PATCH] sparc: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 11:27:22 -0800
Message-Id: <1204572442.3266.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sparc/kernel/ebus.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/ebus.c b/arch/sparc/kernel/ebus.c
index d850785..96344ff 100644
--- a/arch/sparc/kernel/ebus.c
+++ b/arch/sparc/kernel/ebus.c
@@ -101,7 +101,7 @@ void __init fill_ebus_child(struct device_node *dp,
 			prom_printf("UGH: property for %s was %d, need < %d\n",
 				    dev->prom_node->name, len,
 				    dev->parent->num_addrs);
-			panic(__FUNCTION__);
+			panic(__func__);
 		}
 
 		/* XXX resource */
@@ -162,7 +162,7 @@ void __init fill_ebus_device(struct device_node *dp, struct linux_ebus_device *d
 		prom_printf("UGH: proplen for %s was %d, need multiple of %d\n",
 			    dev->prom_node->name, len,
 			    (int)sizeof(struct linux_prom_registers));
-		panic(__FUNCTION__);
+		panic(__func__);
 	}
 	dev->num_addrs = len / sizeof(struct linux_prom_registers);
 
@@ -324,7 +324,7 @@ void __init ebus_init(void)
 		regs = of_get_property(dp, "reg", &len);
 		if (!regs) {
 			prom_printf("%s: can't find reg property\n",
-				    __FUNCTION__);
+				    __func__);
 			prom_halt();
 		}
 		nreg = len / sizeof(struct linux_prom_pci_registers);
-- 
1.5.4.3.500.g83a2c



