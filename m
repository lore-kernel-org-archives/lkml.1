Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZA3QWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZA3QWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZA3QV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:21:59 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34892 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZA3QV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:21:58 -0500
Subject: [PATCH 1/1] Add enable_ms to jsm driver
From: Paul Larson <pl@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Scott.Kilau@digi.com
Content-Type: text/plain
Date: Fri, 30 Jan 2009 10:21:49 -0600
Message-Id: <1233332509.8792.4.camel@plap>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes a crash observed when non-existant enable_ms function is
called for jsm driver.

Signed-off-by: Scott Kilau <Scott.Kilau@digi.com>
Signed-off-by: Paul Larson <pl@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm_tty.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index 3547558..324c74d 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -161,6 +161,11 @@ static void jsm_tty_stop_rx(struct uart_port *port)
 	channel->ch_bd->bd_ops->disable_receiver(channel);
 }
 
+static void jsm_tty_enable_ms(struct uart_port *port)
+{
+	/* Nothing needed */
+}
+
 static void jsm_tty_break(struct uart_port *port, int break_state)
 {
 	unsigned long lock_flags;
@@ -345,6 +350,7 @@ static struct uart_ops jsm_ops = {
 	.start_tx	= jsm_tty_start_tx,
 	.send_xchar	= jsm_tty_send_xchar,
 	.stop_rx	= jsm_tty_stop_rx,
+	.enable_ms	= jsm_tty_enable_ms,
 	.break_ctl	= jsm_tty_break,
 	.startup	= jsm_tty_open,
 	.shutdown	= jsm_tty_close,
-- 




