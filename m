Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbZFXO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbZFXO2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZFXO2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:28:07 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51651 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZFXO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:28:06 -0400
Date: Wed, 24 Jun 2009 19:58:01 +0530
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ankita@in.ibm.com
Subject: [PATCH] Use do_IRQ in lkdtm
Message-ID: <20090624142801.GC8664@in.ibm.com>
Reply-To: mohan@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Use do_IRQ in lkdtm

Current lkdtm code puts a probe on __do_IRQ for some of the kdump test
cases. Since __do_IRQ is deprecated, change lkdtm code to use do_IRQ
function.

Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
Cc: Ankita Garg <ankita@in.ibm.com>
---
 drivers/misc/lkdtm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 1bfe5d1..3648b23 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -283,7 +283,7 @@ static int __init lkdtm_module_init(void)
 
 	switch (cpoint) {
 	case INT_HARDWARE_ENTRY:
-		lkdtm.kp.symbol_name = "__do_IRQ";
+		lkdtm.kp.symbol_name = "do_IRQ";
 		lkdtm.entry = (kprobe_opcode_t*) jp_do_irq;
 		break;
 	case INT_HW_IRQ_EN:
-- 
1.6.2.2

