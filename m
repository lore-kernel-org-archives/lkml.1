Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbZGGNev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbZGGNev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbZGGNen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:34:43 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:33885 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbZGGNem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:34:42 -0400
Date: Tue, 7 Jul 2009 19:04:39 +0530
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ankita@in.ibm.com
Subject: [PATCH] Use do_IRQ in lkdtm
Message-ID: <20090707133439.GB28829@in.ibm.com>
Reply-To: mohan@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I already posted this patch to Linus two weeks back. But this patch was
not merged with the recent rc releases, So I am sending it to you.



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

