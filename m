Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZIJKUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZIJKUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbZIJKUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:20:01 -0400
Received: from server1.wserver.cz ([82.113.45.157]:47407 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZIJKT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:19:59 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] Char: mxser, use THRE for ASPP_OQUEUE ioctl
Date: Thu, 10 Sep 2009 12:20:08 +0200
Message-Id: <1252578008-6207-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252578008-6207-1-git-send-email-jirislaby@gmail.com>
References: <1252578008-6207-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In moxa specific ASPP_OQUEUE ioctl command, they apparently want
only know whether there is space in transmitter hold register.

So switch UART_LSR_TEMT to UART_LSR_THRE in that specific case
according to the change in 1.14 moxa drivers.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index e218ae2..5e28d39 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1806,7 +1806,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 
 		lock_kernel();
 		len = mxser_chars_in_buffer(tty);
-		lsr = inb(info->ioaddr + UART_LSR) & UART_LSR_TEMT;
+		lsr = inb(info->ioaddr + UART_LSR) & UART_LSR_THRE;
 		len += (lsr ? 0 : 1);
 		unlock_kernel();
 
-- 
1.6.3.3

