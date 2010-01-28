Return-Path: <linux-kernel-owner+w=401wt.eu-S932249Ab0A1My4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab0A1My4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732Ab0A1Myx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:54:53 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:54032 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab0A1Myv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ezSfQgsoPBLDlqtE5PwC7mpip1wXi8jeneTXV2W8RAtrAAlK/Dvwipb31EvFToqHf/
         2g9gfIamvTx8StAfSdzu+HNbttxTDAPViJM9dpKUWiooE6NSQ22LmhxlD7a1XohrXa89
         G+33UkRBD4RDLmZscJuHXROdhRCCW0Eq/s6XE=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: eric.y.miao@gmail.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com, lethal@linux-sh.org, ben-linux@fluff.org,
       Magnus Damm <magnus.damm@gmail.com>,
       linux-arm-kernel@lists.infradead.org
Date: Thu, 28 Jan 2010 21:41:21 +0900
Message-Id: <20100128124121.8982.71803.sendpatchset@rxone.opensource.se>
In-Reply-To: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
Subject: [PATCH 05/06] sh: Let INTC set IRQF_VALID on ARM platforms
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Reuse the SuperH INTC code on ARM by using set_irq_flags()
to set IRQF_VALID on ARM platforms. Reworking the shared ARM
interrupt code and removing IRQF_VALID is another option.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/sh/intc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- 0001/drivers/sh/intc.c
+++ work/drivers/sh/intc.c	2010-01-21 19:53:15.000000000 +0900
@@ -658,6 +658,11 @@ static void __init intc_register_irq(str
 
 	if (desc->ack_regs)
 		ack_handle[irq] = intc_ack_data(desc, d, enum_id);
+
+	/* Set IRQF_VALID to enable IRQ on ARM systems */
+#ifdef CONFIG_ARCH_SHMOBILE
+	set_irq_flags(irq, IRQF_VALID);
+#endif
 }
 
 static unsigned int __init save_reg(struct intc_desc_int *d,
