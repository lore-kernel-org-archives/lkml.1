Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYE2PRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYE2PRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYE2PQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:16:18 -0400
Received: from smtp.movial.fi ([62.236.91.34]:35035 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbYE2PQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:16:17 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] [MIPS] unexport {allocate,free}_irqno
Date: Thu, 29 May 2008 17:57:11 +0300
Message-Id: <12120730324097-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.4.4.3
In-Reply-To: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi>
References: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following routines

allocate_irqno()
free_irqno()

seem not to be used outside of the core kernel code, hence
exporting these functions is pointless. This patch removes
the export.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 arch/mips/kernel/irq.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index ba4e331..ffd80de 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -44,8 +44,6 @@ again:
 	return irq;
 }
 
-EXPORT_SYMBOL_GPL(allocate_irqno);
-
 void free_irqno(unsigned int irq)
 {
 	smp_mb__before_clear_bit();
@@ -53,8 +51,6 @@ void free_irqno(unsigned int irq)
 	smp_mb__after_clear_bit();
 }
 
-EXPORT_SYMBOL_GPL(free_irqno);
-
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
-- 
1.4.4.3

