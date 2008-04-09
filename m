Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYDIKAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYDIKAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 06:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYDIKAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 06:00:30 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:52579 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYDIKAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 06:00:30 -0400
Message-ID: <47FC93BC.5020201@tiscali.nl>
Date: Wed, 09 Apr 2008 12:00:28 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] dz: test after postfix decrement fails in dz_console_putchar()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When loops reaches 0 the postfix decrement still subtracts, so the test fails

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/serial/dz.c b/drivers/serial/dz.c
index 116211f..0dddd68 100644
--- a/drivers/serial/dz.c
+++ b/drivers/serial/dz.c
@@ -819,7 +819,7 @@ static void dz_console_putchar(struct uart_port *uport, int ch)
 		dz_out(dport, DZ_TCR, mask);
 		iob();
 		udelay(2);
-	} while (loops--);
+	} while (--loops);
 
 	if (loops)				/* Cannot send otherwise. */
 		dz_out(dport, DZ_TDR, ch);
