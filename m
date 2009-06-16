Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbZFPPEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbZFPPEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbZFPPEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:04:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44053 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759720AbZFPPEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:04:39 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 9/9] imx: Check for NULL pointer deref before calling
	tty_encode_baud_rate
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jun 2009 17:02:15 +0100
Message-ID: <20090616160208.10041.85297.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
References: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/imx.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 285b414..5d7b58f 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -924,11 +924,13 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 	rational_best_approximation(16 * div * baud, sport->port.uartclk,
 		1 << 16, 1 << 16, &num, &denom);
 
-	tdiv64 = sport->port.uartclk;
-	tdiv64 *= num;
-	do_div(tdiv64, denom * 16 * div);
-	tty_encode_baud_rate(sport->port.info->port.tty,
-		(speed_t)tdiv64, (speed_t)tdiv64);
+	if (port->info && port->info->port.tty) {
+		tdiv64 = sport->port.uartclk;
+		tdiv64 *= num;
+		do_div(tdiv64, denom * 16 * div);
+		tty_encode_baud_rate(sport->port.info->port.tty,
+				(speed_t)tdiv64, (speed_t)tdiv64);
+	}
 
 	num -= 1;
 	denom -= 1;

