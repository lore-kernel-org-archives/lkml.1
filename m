Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZKUNkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZKUNkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZKUNkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:40:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41031 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbZKUNkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=aC9CTKFIB3iH0i4I1GZXap7v+1QvZgLrcn0pTlUzZq0WqL5TurRA5Gvi1d+mJYgiB+
         xb2Fd1clf9AqzJxn9ZkX82c41066DMiP3Atk5APcP3o1zJf2xjh/1g3wj4zsbWU9+Smx
         HD7kOpf0j21aMCLDS8VNrvP12Vn8BZQzKEpVI=
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [RFC PATCH 7/9] Serial: sc26xx - simplify port initialisation.
To: tsbogend@alpha.franken.de, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2009 14:40:19 +0100
Message-ID: <20091121134019.16090.69797.stgit@srv002.fuzzey.net>
In-Reply-To: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
References: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use a memcpy

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 drivers/serial/sc26xx.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/sc26xx.c b/drivers/serial/sc26xx.c
index 316d110..69b7ae7 100644
--- a/drivers/serial/sc26xx.c
+++ b/drivers/serial/sc26xx.c
@@ -680,17 +680,8 @@ static int __devinit sc26xx_probe(struct platform_device *dev)
 
 	sc26xx_port = &up->port[0];
 
+	memcpy(&up->port[1], &up->port[0], sizeof(up->port[0]));
 	up->port[1].line = 1;
-	up->port[1].ops = &sc26xx_ops;
-	up->port[1].type = PORT_SC26XX;
-	up->port[1].uartclk = (29491200 / 16); /* arbitrary */
-
-	up->port[1].mapbase = up->port[0].mapbase;
-	up->port[1].membase = up->port[0].membase;
-	up->port[1].iotype = UPIO_MEM;
-	up->port[1].irq = up->port[0].irq;
-
-	up->port[1].dev = &dev->dev;
 
 	sc26xx_init_masks(up, 1, sc26xx_data[1]);
 

