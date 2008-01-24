Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYAXMoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYAXMoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbYAXMmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:42:13 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55052 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753311AbYAXMmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:42:02 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>, Marc Pignat <marc.pignat@hevs.ch>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH -mm v4 9/9] atmel_serial: Show tty name in /proc/interrupts
Date: Thu, 24 Jan 2008 13:41:51 +0100
Message-Id: <1201178511-12133-10-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201178511-12133-9-git-send-email-hskinnemoen@atmel.com>
References: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-2-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-3-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-4-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-5-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-6-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-7-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-8-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-9-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When possible, pass the tty name to request_irq() so that the user can
easily distinguish the different serial ports in /proc/interrupts.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 2ff92b9..63505cc 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -795,6 +795,7 @@ static void atmel_tasklet_func(unsigned long data)
 static int atmel_startup(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+	struct tty_struct *tty = port->info->tty;
 	int retval;
 
 	/*
@@ -808,7 +809,7 @@ static int atmel_startup(struct uart_port *port)
 	 * Allocate the IRQ
 	 */
 	retval = request_irq(port->irq, atmel_interrupt, IRQF_SHARED,
-			"atmel_serial", port);
+			tty ? tty->name : "atmel_serial", port);
 	if (retval) {
 		printk("atmel_serial: atmel_startup - Can't get irq\n");
 		return retval;
-- 
1.5.3.8

