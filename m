Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZEKNxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZEKNxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZEKNxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:53:17 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:56210 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbZEKNxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:53:13 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH 2/3] Char: rocket, fix test_bit parameters
Date: Mon, 11 May 2009 15:50:59 +0200
Message-Id: <1242049860-29501-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242049860-29501-1-git-send-email-jirislaby@gmail.com>
References: <1242049860-29501-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from ASYNC_* to ASYNCB_*, because {test,set}_bit expect
bit number, not mask.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ferenc Wagner <wferi@niif.hu>
---
 drivers/char/rocket.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 7399188..63d5b62 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -939,7 +939,7 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 	/*
 	 * Info->count is now 1; so it's safe to sleep now.
 	 */
-	if (!test_bit(ASYNC_INITIALIZED, &port->flags)) {
+	if (!test_bit(ASYNCB_INITIALIZED, &port->flags)) {
 		cp = &info->channel;
 		sSetRxTrigger(cp, TRIG_1);
 		if (sGetChanStatus(cp) & CD_ACT)
@@ -963,7 +963,7 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 		sEnRxFIFO(cp);
 		sEnTransmit(cp);
 
-		set_bit(ASYNC_INITIALIZED, &info->port.flags);
+		set_bit(ASYNCB_INITIALIZED, &info->port.flags);
 
 		/*
 		 * Set up the tty->alt_speed kludge
@@ -1646,7 +1646,7 @@ static int rp_write(struct tty_struct *tty,
 	/*  Write remaining data into the port's xmit_buf */
 	while (1) {
 		/* Hung up ? */
-		if (!test_bit(ASYNC_NORMAL_ACTIVE, &info->port.flags))
+		if (!test_bit(ASYNCB_NORMAL_ACTIVE, &info->port.flags))
 			goto end;
 		c = min(count, XMIT_BUF_SIZE - info->xmit_cnt - 1);
 		c = min(c, XMIT_BUF_SIZE - info->xmit_head);
-- 
1.6.3

