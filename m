Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbYKDR0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbYKDR0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYKDR0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:26:06 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50670 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbYKDR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:26:05 -0500
Date: Wed, 5 Nov 2008 02:26:00 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial/8250: fix uninitialized warnings
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081105022353.7CB0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix following warnings.

drivers/serial/8250.c: In function ‘serial8250_shutdown’:
drivers/serial/8250.c:1612: warnings: ‘i’ may be used uninitialized in this function


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-serial@vger.kernel.org
---
 drivers/serial/8250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/serial/8250.c
===================================================================
--- a/drivers/serial/8250.c	2008-11-05 01:10:11.000000000 +0900
+++ b/drivers/serial/8250.c	2008-11-05 01:38:39.000000000 +0900
@@ -1609,7 +1609,7 @@ static int serial_link_irq_chain(struct 
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i;
+	struct irq_info *i = NULL;
 	struct hlist_node *n;
 	struct hlist_head *h;
 


