Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbYFIKPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbYFIKPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760022AbYFIKPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:15:04 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:59606 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759967AbYFIKPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:15:02 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Char: mxser, various cleanups
Date: Mon,  9 Jun 2008 12:08:32 +0200
Message-Id: <1213006112-25965-7-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213006112-25965-1-git-send-email-jirislaby@gmail.com>
References: <1213006112-25965-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove unused macro
- some whitespace cleanup
- useless debug prints removal

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 8f7afdc..3ccec49 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -48,7 +48,6 @@
 
 #define	MXSER_VERSION	"2.0.4"		/* 1.12 */
 #define	MXSERMAJOR	 174
-#define	MXSERCUMAJOR	 175
 
 #define MXSER_BOARDS		4	/* Max. boards */
 #define MXSER_PORTS_PER_BOARD	8	/* Max. ports per board */
@@ -191,7 +190,6 @@ struct mxser_log {
 	unsigned long txcnt[MXSER_PORTS];
 };
 
-
 struct mxser_mon {
 	unsigned long rxcnt;
 	unsigned long txcnt;
@@ -1314,13 +1312,9 @@ static void mxser_flush_chars(struct tty_struct *tty)
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
-	if (info->xmit_cnt <= 0 ||
-			tty->stopped ||
-			!info->xmit_buf ||
-			(tty->hw_stopped &&
-			 (info->type != PORT_16550A) &&
-			 (!info->board->chip_flag)
-			))
+	if (info->xmit_cnt <= 0 || tty->stopped || !info->xmit_buf ||
+			(tty->hw_stopped && info->type != PORT_16550A &&
+			 !info->board->chip_flag))
 		return;
 
 	spin_lock_irqsave(&info->slock, flags);
@@ -1338,9 +1332,7 @@ static int mxser_write_room(struct tty_struct *tty)
 	int ret;
 
 	ret = SERIAL_XMIT_SIZE - info->xmit_cnt - 1;
-	if (ret < 0)
-		ret = 0;
-	return ret;
+	return ret < 0 ? 0 : ret;
 }
 
 static int mxser_chars_in_buffer(struct tty_struct *tty)
@@ -2771,8 +2763,6 @@ static int __init mxser_module_init(void)
 	unsigned int b, i, m;
 	int retval;
 
-	pr_debug("Loading module mxser ...\n");
-
 	mxvar_sdriver = alloc_tty_driver(MXSER_PORTS + 1);
 	if (!mxvar_sdriver)
 		return -ENOMEM;
@@ -2838,8 +2828,6 @@ static int __init mxser_module_init(void)
 		} /* else: we have some ISA cards under control */
 	}
 
-	pr_debug("Done.\n");
-
 	return 0;
 err_unr:
 	tty_unregister_driver(mxvar_sdriver);
@@ -2852,8 +2840,6 @@ static void __exit mxser_module_exit(void)
 {
 	unsigned int i, j;
 
-	pr_debug("Unloading module mxser ...\n");
-
 	pci_unregister_driver(&mxser_driver);
 
 	for (i = 0; i < MXSER_BOARDS; i++) /* ISA remains */
@@ -2867,8 +2853,6 @@ static void __exit mxser_module_exit(void)
 	for (i = 0; i < MXSER_BOARDS; i++)
 		if (mxser_boards[i].info != NULL)
 			mxser_release_res(&mxser_boards[i], NULL, 1);
-
-	pr_debug("Done.\n");
 }
 
 module_init(mxser_module_init);
-- 
1.5.4.5

