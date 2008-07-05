Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYGENaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYGENaN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 09:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYGENaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 09:30:00 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:57575 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYGEN37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 09:29:59 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/4] Char: ip2, fix sparse warnings
Date: Sat,  5 Jul 2008 15:28:25 +0200
Message-Id: <1215264506-32455-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215264506-32455-2-git-send-email-jirislaby@gmail.com>
References: <1215264506-32455-1-git-send-email-jirislaby@gmail.com>
 <1215264506-32455-2-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/ip2/ip2main.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 4174c65..d9b30ab 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -375,9 +375,7 @@ have_requested_irq( char irq )
 /* handle subsequent installations of the driver. All memory allocated by the */
 /* driver should be returned since it may be unloaded from memory.            */
 /******************************************************************************/
-#ifdef MODULE
-void __exit
-ip2_cleanup_module(void)
+static void __exit ip2_cleanup_module(void)
 {
 	int err;
 	int i;
@@ -431,7 +429,8 @@ ip2_cleanup_module(void)
 			ip2config.pci_dev[i] = NULL;
 		}
 #endif
-		if ((pB = i2BoardPtrTable[i]) != 0 ) {
+		pB = i2BoardPtrTable[i];
+		if (pB != NULL) {
 			kfree ( pB );
 			i2BoardPtrTable[i] = NULL;
 		}
@@ -448,7 +447,6 @@ ip2_cleanup_module(void)
 #endif
 }
 module_exit(ip2_cleanup_module);
-#endif /* MODULE */
 
 static const struct tty_operations ip2_ops = {
 	.open            = ip2_open,
@@ -1253,9 +1251,8 @@ ip2_polled_interrupt(void)
 {
 	int i;
 	i2eBordStrPtr  pB;
-	const int irq = 0;
 
-	ip2trace (ITRC_NO_PORT, ITRC_INTR, 99, 1, irq );
+	ip2trace(ITRC_NO_PORT, ITRC_INTR, 99, 1, 0);
 
 	/* Service just the boards on the list using this irq */
 	for( i = 0; i < i2nBoards; ++i ) {
@@ -1264,9 +1261,8 @@ ip2_polled_interrupt(void)
 //		Only process those boards which match our IRQ.
 //			IRQ = 0 for polled boards, we won't poll "IRQ" boards
 
-		if ( pB && (pB->i2eUsingIrq == irq) ) {
+		if (pB && pB->i2eUsingIrq == 0)
 			ip2_irq_work(pB);
-		}
 	}
 
 	++irq_counter;
-- 
1.5.5.1

