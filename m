Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZISVo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZISVo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZISVo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:44:27 -0400
Received: from kroah.org ([198.145.64.141]:40567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbZISVoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:44:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 70/79] tty: Char: mxser, use THRE for ASPP_OQUEUE ioctl
Date: Sat, 19 Sep 2009 14:37:15 -0700
Message-Id: <1253396244-7885-70-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

In moxa specific ASPP_OQUEUE ioctl command, they apparently want
only know whether there is space in transmitter hold register.

So switch UART_LSR_TEMT to UART_LSR_THRE in that specific case
according to the change in 1.14 moxa drivers.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.4.2

