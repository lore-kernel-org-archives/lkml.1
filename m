Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYGTJOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYGTJOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 05:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbYGTJOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 05:14:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:44545 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbYGTJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 05:14:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Cqu93KdBgIP19muG15F8xnpw3Xvt0qdff+OCFem+OzRleXnkdxqFa6Eh0jvyjPXYXT
         cpAh17jOQ3s47bEmUMuUAZr35Z1mxkCWFksQgA9GwOrOZ63MAiQSp8frCnICZlDEf9cb
         7wUQ5cci7ClGijJudHAjMYdNQesHt3oLfeoMs=
Message-ID: <488301EC.7070204@gmail.com>
Date: Sun, 20 Jul 2008 05:14:20 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: pfg@sgi.com
CC: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Altix serial: fix 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch was not tested on hardware
---
In function sn_sal_switch_to_asynch(): drivers/serial/sn_console.c:713:

HZ * SN_SAL_UART_FIFO_DEPTH / SN_SAL_UART_FIFO_SPEED_CPS;

After preprocessing (see defines in patch) this becomes HZ * 16 / 9600 / 10
(associativity from left to right), not equivalent to HZ * 16 / 960.
---
diff --git a/drivers/serial/sn_console.c b/drivers/serial/sn_console.c
index 019da2e..3a2683b 100644
--- a/drivers/serial/sn_console.c
+++ b/drivers/serial/sn_console.c
@@ -61,7 +61,7 @@
 #define SN_SAL_BUFFER_SIZE (64 * (1 << 10))
 
 #define SN_SAL_UART_FIFO_DEPTH 16
-#define SN_SAL_UART_FIFO_SPEED_CPS 9600/10
+#define SN_SAL_UART_FIFO_SPEED_CPS (9600/10)
 
 /* sn_transmit_chars() calling args */
 #define TRANSMIT_BUFFERED    0

