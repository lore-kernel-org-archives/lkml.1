Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbZB0Kms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbZB0Kms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbZB0Kmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:42:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:43472 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZB0Kmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:42:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=gueECvr4MlOgH8Ctv41CdFAbPuWtfGtZyaVaYepSlcHspAxmESAFAJv0ozrB+I0A80
         m0051AHETqXxCGCi+qn7qHEetjDiLfnMsUR0Ggrqk+tbrMmORUjWjEANNNFPuCvET2iL
         xQejSAF6Churyw68w7fcFBc+16dB1gv+l/m5Q=
MIME-Version: 1.0
Date: Fri, 27 Feb 2009 16:12:31 +0530
Message-ID: <f1c9d250902270242j64cc9f59g56ce68ca2a832564@mail.gmail.com>
Subject: [PATCH] Add proper list function
From: Tej <bewith.tej@gmail.com>
To: Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanup, where list_del and list_add_tail is replaced by
list_move_tail...


Signed-off-by: Tej Parkash <tej.parkash@hcl.in>

diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index f5420f9..30f52c2 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -208,8 +208,7 @@ static irqreturn_t msm_datamover_irq_handler(int
irq, void *dev_id)
                        PRINT_FLOW("msm_datamover_irq_handler id %d,
status %x\n", id, ch_status);
                        if ((ch_status & DMOV_STATUS_CMD_PTR_RDY) &&
!list_empty(&ready_commands[id])) {
                                cmd =
list_entry(ready_commands[id].next, typeof(*cmd), list);
-                               list_del(&cmd->list);
-                               list_add_tail(&cmd->list, &active_commands[id]);
+                               list_move_tail(&cmd->list,
&active_commands[id]);
                                PRINT_FLOW("msm_datamover_irq_handler
id %d, start command\n", id);
                                writel(cmd->cmdptr, DMOV_CMD_PTR(id));
                        }
