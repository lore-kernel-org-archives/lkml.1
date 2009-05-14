Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbZENKLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbZENKLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 06:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZENKL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 06:11:26 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:38538 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbZENKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 06:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=MYnCovgyB2kNM97Ehac4NRZGWEUFz3JZEO9A3nUbwaMT9Dpa2JdoGNa7494VFQ7b8M
         gSTKPShVxgsUwWMdeip2gsAemMoIO2yM4gV+MerLV5obgDaT5N8WDVWLZhpetF45XOhh
         6BdsAavqYSWaahwwqYmYKEJXxEMDax2zwcACg=
Message-ID: <4A0BEE4C.30600@gmail.com>
Date: Thu, 14 May 2009 12:11:24 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: alan@redhat.com
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] gs: missing parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`|' has a higher precedence than `?' so add parentheses.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 518f2a2..1f63add 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -979,8 +979,8 @@ static int sx_set_real_termios(void *ptr)
 			(I_IXANY(port->gs.port.tty) ? SP_TANY : 0) | SP_DCEN);
 
 	sx_write_channel_byte(port, hi_break,
-			(I_IGNBRK(port->gs.port.tty) ? BR_IGN : 0 |
-			I_BRKINT(port->gs.port.tty) ? BR_INT : 0));
+			(I_IGNBRK(port->gs.port.tty) ? BR_IGN : 0) |
+			(I_BRKINT(port->gs.port.tty) ? BR_INT : 0));
 
 	sx_write_channel_byte(port, hi_txon, START_CHAR(port->gs.port.tty));
 	sx_write_channel_byte(port, hi_rxon, START_CHAR(port->gs.port.tty));
