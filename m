Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbZABKmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbZABKmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbZABKlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:39 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:34092 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZABKlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:36 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: apollo core - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:15 +0100
Message-Id: <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/apollo/config.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/apollo/config.c b/arch/m68k/apollo/config.c
index cf215a0..8d3eafa 100644
--- a/arch/m68k/apollo/config.c
+++ b/arch/m68k/apollo/config.c
@@ -200,7 +200,8 @@ void dn_sched_init(irq_handler_t timer_routine)
 	printk("*(0x10803) %02x\n",*(volatile unsigned char *)(timer+0x3));
 #endif
 
-	request_irq(IRQ_APOLLO, dn_timer_int, 0, "time", timer_routine);
+	if (request_irq(IRQ_APOLLO, dn_timer_int, 0, "time", timer_routine))
+		pr_err("Couldn't register timer interrupt\n");
 }
 
 unsigned long dn_gettimeoffset(void) {
-- 
1.5.6.5

