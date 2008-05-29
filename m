Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYE2WFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYE2WFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYE2WEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:04:53 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54819 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052AbYE2WEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:04:50 -0400
Date: Fri, 30 May 2008 01:04:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh/kernel/cpu/irq/intc-sh5.c build fix
Message-ID: <20080529220449.GA1763@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error caused by
commit a1dc4b59fa4af97ae68ee214d4d72bbd7c7ec1dc
(sh: intc_sh5 depends on cayman board for IRQ priority table.):

<--  snip  -->

...
  CC      arch/sh/kernel/cpu/irq/intc-sh5.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c: In function 'plat_irq_setup':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c:257: error: expected declaration or statement at end of input
make[4]: *** [arch/sh/kernel/cpu/irq/intc-sh5.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0d194eca3c8d5bddb10c9e61ab290e6e5aceab3f diff --git a/arch/sh/kernel/cpu/irq/intc-sh5.c b/arch/sh/kernel/cpu/irq/intc-sh5.c
index de45c6a..79baa47 100644
--- a/arch/sh/kernel/cpu/irq/intc-sh5.c
+++ b/arch/sh/kernel/cpu/irq/intc-sh5.c
@@ -242,6 +242,7 @@ void __init plat_irq_setup(void)
 				reg += 8;
 			}
 		}
+	}
 #endif
 
 	/*

