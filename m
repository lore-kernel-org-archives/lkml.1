Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbZE1Uyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbZE1Uyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbZE1Uys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:54:48 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:60022 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbZE1Uyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:54:47 -0400
Message-ID: <4A1EFA0E.90000@linux.vnet.ibm.com>
Date: Thu, 28 May 2009 17:54:38 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] icom: fixing a if clause spaghetti
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adapter->version can only be ADAPTER_V2 or ADAPTER_V1. So, 
that OR operand in the "if" clause is non-sense and can be removed.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index a461b3b..fd5fd23 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -408,7 +408,7 @@ static void load_code(struct icom_port *icom_port)
 	release_firmware(fw);
 
 	/* Set Hardware level */
-	if ((icom_port->adapter->version | ADAPTER_V2) == ADAPTER_V2)
+	if (icom_port->adapter->version == ADAPTER_V2)
 		writeb(V2_HARDWARE, &(icom_port->dram->misc_flags));
 
 	/* Start the processor in Adapter */
@@ -861,7 +861,7 @@ static irqreturn_t icom_interrupt(int irq, void *dev_id)
 	/* find icom_port for this interrupt */
 	icom_adapter = (struct icom_adapter *) dev_id;
 
-	if ((icom_adapter->version | ADAPTER_V2) == ADAPTER_V2) {
+	if (icom_adapter->version == ADAPTER_V2) {
 		int_reg = icom_adapter->base_addr + 0x8024;
 
 		adapter_interrupts = readl(int_reg);
