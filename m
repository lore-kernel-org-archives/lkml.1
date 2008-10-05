Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYJEQK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYJEQK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYJEQHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:07:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54868 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754480AbYJEQHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:07:05 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 18/76] ip2, fix sparse warnings
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:07:04 +0100
Message-ID: <20081005160701.1997.90240.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/ip2/ip2main.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 1d46284..098c9de 100644
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
@@ -1255,9 +1253,8 @@ ip2_polled_interrupt(void)
 {
 	int i;
 	i2eBordStrPtr  pB;
-	const int irq = 0;
 
-	ip2trace (ITRC_NO_PORT, ITRC_INTR, 99, 1, irq );
+	ip2trace(ITRC_NO_PORT, ITRC_INTR, 99, 1, 0);
 
 	/* Service just the boards on the list using this irq */
 	for( i = 0; i < i2nBoards; ++i ) {
@@ -1266,9 +1263,8 @@ ip2_polled_interrupt(void)
 //		Only process those boards which match our IRQ.
 //			IRQ = 0 for polled boards, we won't poll "IRQ" boards
 
-		if ( pB && (pB->i2eUsingIrq == irq) ) {
+		if (pB && pB->i2eUsingIrq == 0)
 			ip2_irq_work(pB);
-		}
 	}
 
 	++irq_counter;

