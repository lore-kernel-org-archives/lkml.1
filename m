Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYJUTQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYJUTQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYJUTPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:15:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:44703 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551AbYJUTPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:15:12 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       alan@lxorguk.ukuu.org.uk
Subject: [PATCH 4/7] kgdboc, 8250: Add the rx polling hook to 8250 driver
Date: Tue, 21 Oct 2008 14:14:50 -0500
Message-Id: <1224616493-23237-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1224616493-23237-4-git-send-email-jason.wessel@windriver.com>
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-2-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-3-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 21 Oct 2008 19:14:58.0279 (UTC) FILETIME=[4EE77770:01C933B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RX polling hook allows the debugger to hook character input so as
to allow entry to the kernel debugger with a control-c as an example.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/8250.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 303272a..4f7343e 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1361,6 +1361,10 @@ receive_chars(struct uart_8250_port *up, unsigned int *status)
 			else if (lsr & UART_LSR_FE)
 				flag = TTY_FRAME;
 		}
+#ifdef CONFIG_CONSOLE_POLL
+		if (up->port.poll_rx_cb && up->port.poll_rx_cb(ch))
+			goto ignore_char;
+#endif
 		if (uart_handle_sysrq_char(&up->port, ch))
 			goto ignore_char;
 
-- 
1.6.0.2

