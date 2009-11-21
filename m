Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZKUNlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZKUNlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZKUNkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:40:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41031 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbZKUNkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:40:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=YMncNKr5LOj3QFkd8T12y8HwRCuea2Co63ndUj5Jbm0Hy+isEasl6Yo31zOiZ/dOnB
         QNJNBE7CP7c6LJakoJvAjUF81fmWkwi+TYsgEhr+oqMg+1hdXvbWhTHzSiCc9dvDpL5H
         aVbNmyY9M8UlSKw44Ej9dAIpPeHZutsT8R4W8=
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [RFC PATCH 6/9] Serial: sc26xx simplify timeout calculation
To: tsbogend@alpha.franken.de, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2009 14:40:15 +0100
Message-ID: <20091121134015.16090.21264.stgit@srv002.fuzzey.net>
In-Reply-To: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
References: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have the baud rate - no need to calculate it again.

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 drivers/serial/sc26xx.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/sc26xx.c b/drivers/serial/sc26xx.c
index 1b47443..316d110 100644
--- a/drivers/serial/sc26xx.c
+++ b/drivers/serial/sc26xx.c
@@ -401,7 +401,6 @@ static void sc26xx_set_termios(struct uart_port *port, struct ktermios *termios,
 			      struct ktermios *old)
 {
 	unsigned int baud = uart_get_baud_rate(port, termios, old, 0, 4000000);
-	unsigned int quot = uart_get_divisor(port, baud);
 	unsigned int iflag, cflag;
 	unsigned long flags;
 	u8 mr1, mr2, csr;
@@ -505,9 +504,7 @@ static void sc26xx_set_termios(struct uart_port *port, struct ktermios *termios,
 	while ((READ_SC_PORT(port, SR) & ((1 << 3) | (1 << 2))) != 0xc)
 		udelay(2);
 
-	/* XXX */
-	uart_update_timeout(port, cflag,
-			    (port->uartclk / (16 * quot)));
+	uart_update_timeout(port, cflag, baud);
 
 	spin_unlock_irqrestore(&port->lock, flags);
 }

