Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbZABKn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbZABKn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbZABKlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:44 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:47499 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbZABKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:37 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: sun3 core - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:20 +0100
Message-Id: <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/sun3/sun3ints.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 7364cd6..ad90393 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -105,7 +105,10 @@ void __init sun3_init_IRQ(void)
 	m68k_setup_irq_controller(&sun3_irq_controller, IRQ_AUTO_1, 7);
 	m68k_setup_user_interrupt(VEC_USER, 128, NULL);
 
-	request_irq(IRQ_AUTO_5, sun3_int5, 0, "int5", NULL);
-	request_irq(IRQ_AUTO_7, sun3_int7, 0, "int7", NULL);
-	request_irq(IRQ_USER+127, sun3_vec255, 0, "vec255", NULL);
+	if (request_irq(IRQ_AUTO_5, sun3_int5, 0, "int5", NULL))
+		pr_err("Couldn't register %s interrupt\n", "int5");
+	if (request_irq(IRQ_AUTO_7, sun3_int7, 0, "int7", NULL))
+		pr_err("Couldn't register %s interrupt\n", "int7");
+	if (request_irq(IRQ_USER+127, sun3_vec255, 0, "vec255", NULL))
+		pr_err("Couldn't register %s interrupt\n", "vec255");
 }
-- 
1.5.6.5

