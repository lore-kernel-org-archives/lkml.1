Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXDFUCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXDFUCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbXDFUCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:02:35 -0400
Received: from www.osadl.org ([213.239.205.134]:37013 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932493AbXDFUCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:02:34 -0400
Subject: [PATCH] Replace deprecated SA_xxx interrupt flags
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1175888217.28263.465.camel@localhost.localdomain>
References: <20070114081905.135797900@inhelltoy.tec.linutronix.de>
	 <20070114081926.912658228@inhelltoy.tec.linutronix.de>
	 <20070123120245.ec3b0772.akpm@osdl.org>
	 <1169584278.21181.86.camel@localhost.localdomain>
	 <1175867366.28263.454.camel@localhost.localdomain>
	 <20070406122228.3dc06c79.akpm@linux-foundation.org>
	 <1175888217.28263.465.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 22:03:01 +0200
Message-Id: <1175889782.28263.470.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the last refractory users of the deprecated SA_xxx interrupt flags.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/mips/sni/irq.c b/arch/mips/sni/irq.c
index ad5fc47..9ccffdf 100644
--- a/arch/mips/sni/irq.c
+++ b/arch/mips/sni/irq.c
@@ -42,7 +42,7 @@ static irqreturn_t sni_isa_irq_handler(int dummy, void *p)
 struct irqaction sni_isa_irq = {
 	.handler = sni_isa_irq_handler,
 	.name = "ISA",
-	.flags = SA_SHIRQ
+	.flags = IRQF_SHARED
 };
 
 /*
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 6bc5051..a7dfb65 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -98,7 +98,7 @@ static int __init snirm710_probe(struct platform_device *dev)
 	host->this_id = 7;
 	host->base = base;
 	host->irq = platform_get_irq(dev, 0);
-	if(request_irq(host->irq, NCR_700_intr, SA_SHIRQ, "snirm710", host)) {
+	if(request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "snirm710", host)) {
 		printk(KERN_ERR "snirm710: request_irq failed!\n");
 		goto out_put_host;
 	}


