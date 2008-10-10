Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYJJKxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYJJKxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbYJJKu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:50:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47589 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759317AbYJJKuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:50:25 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 18/27] ip2, fix sparse warnings
To: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Date: Fri, 10 Oct 2008 11:50:22 +0100
Message-ID: <20081010105016.31597.30633.stgit@localhost.localdomain>
In-Reply-To: <20081010103447.31597.42992.stgit@localhost.localdomain>
References: <20081010103447.31597.42992.stgit@localhost.localdomain>
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

