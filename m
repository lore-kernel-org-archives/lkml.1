Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZICP5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZICP5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 11:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbZICP5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 11:57:30 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43107 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbZICP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 11:57:29 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] powerpc: Fix i8259 interrupt driver kernel crash on ML510
To: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: Roderick Colenbrander <thunderbird2k@gmail.com>,
       Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 03 Sep 2009 09:57:23 -0600
Message-ID: <20090903155208.18009.73841.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roderick Colenbrander <thunderbird2k@gmail.com>

This patch fixes a null pointer exception caused by removal of
'ack()' for level interrupts in the Xilinx interrupt driver.  A recent
change to the xilinx interrupt controller removed the ack hook for
level irqs.

Signed-off-by: Roderick Colenbrander <thunderbird2k@gmail.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Hi Ben & Linus,

This is a last minute bug fix must go into 2.6.31.  This patch
is needed to prevent a kernel panic on Xilinx ml510 boards.

I've also pushed the patch out to my git tree if you'd prefer to pull:

The following changes since commit 326ba5010a5429a5a528b268b36a5900d4ab0eba:
  Linus Torvalds (1):
        Linux 2.6.31-rc8

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge

Roderick Colenbrander (1):
      powerpc: Fix i8259 interrupt driver kernel crash on ML510

 arch/powerpc/sysdev/xilinx_intc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)



diff --git a/arch/powerpc/sysdev/xilinx_intc.c b/arch/powerpc/sysdev/xilinx_intc.c
index 3ee1fd3..40edad5 100644
--- a/arch/powerpc/sysdev/xilinx_intc.c
+++ b/arch/powerpc/sysdev/xilinx_intc.c
@@ -234,7 +234,6 @@ static void xilinx_i8259_cascade(unsigned int irq, struct irq_desc *desc)
 		generic_handle_irq(cascade_irq);
 
 	/* Let xilinx_intc end the interrupt */
-	desc->chip->ack(irq);
 	desc->chip->unmask(irq);
 }
 

