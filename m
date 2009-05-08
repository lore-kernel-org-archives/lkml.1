Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbZEHIeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbZEHIeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZEHIeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:34:04 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43807 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbZEHIdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:33:55 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH 1/2] Char: rocket, fix ASYNC flags
Date: Fri,  8 May 2009 10:32:43 +0200
Message-Id: <1241771564-31133-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <8763gcsa5e.fsf@tac.ki.iif.hu>
References: <8763gcsa5e.fsf@tac.ki.iif.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASYNC_* flags are not bits, but rather constants, use ilog2 to obtain
bit positions and stay atomic.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ferenc Wagner <wferi@niif.hu>
---
 drivers/char/rocket.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 7399188..38c18d3 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -939,7 +939,7 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 	/*
 	 * Info->count is now 1; so it's safe to sleep now.
 	 */
-	if (!test_bit(ASYNC_INITIALIZED, &port->flags)) {
+	if (!test_bit(ilog2(ASYNC_INITIALIZED), &port->flags)) {
 		cp = &info->channel;
 		sSetRxTrigger(cp, TRIG_1);
 		if (sGetChanStatus(cp) & CD_ACT)
@@ -963,7 +963,7 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 		sEnRxFIFO(cp);
 		sEnTransmit(cp);
 
-		set_bit(ASYNC_INITIALIZED, &info->port.flags);
+		set_bit(ilog2(ASYNC_INITIALIZED), &info->port.flags);
 
 		/*
 		 * Set up the tty->alt_speed kludge
@@ -1646,7 +1646,7 @@ static int rp_write(struct tty_struct *tty,
 	/*  Write remaining data into the port's xmit_buf */
 	while (1) {
 		/* Hung up ? */
-		if (!test_bit(ASYNC_NORMAL_ACTIVE, &info->port.flags))
+		if (!test_bit(ilog2(ASYNC_NORMAL_ACTIVE), &info->port.flags))
 			goto end;
 		c = min(count, XMIT_BUF_SIZE - info->xmit_cnt - 1);
 		c = min(c, XMIT_BUF_SIZE - info->xmit_head);
-- 
1.6.2.4

