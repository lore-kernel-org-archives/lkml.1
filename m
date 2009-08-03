Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZHCLpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZHCLpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZHCLpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:45:21 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51410 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbZHCLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ma7a0sbLaE9LI+3r/sY2e7WEI6vN21NJsvj7HDr3WSDO/1uNnPueODBLfFtDtbtIe1
         FZDyLXnY8s1NJq5OS380ojCAsudU5xoHEbfDPXAulWHvV8Rnv6YGvOctR1sCSuz9jsaT
         my4X40r4Y4kWmeE6eyYky1Bhs5KaAq1ZE5HJE=
Message-ID: <4A76CE92.8090208@gmail.com>
Date: Mon, 03 Aug 2009 13:48:34 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Bernd Petrovitsch <bernd@firmix.at>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] powerpc: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether index is within bounds before grabbing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index 2989056..793b236 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -1230,11 +1230,12 @@ static struct tty_driver *hvsi_console_device(struct console *console,
 
 static int __init hvsi_console_setup(struct console *console, char *options)
 {
-	struct hvsi_struct *hp = &hvsi_ports[console->index];
+	struct hvsi_struct *hp;
 	int ret;
 
 	if (console->index < 0 || console->index >= hvsi_count)
 		return -1;
+	hp = &hvsi_ports[console->index];
 
 	/* give the FSP a chance to change the baud rate when we re-open */
 	hvsi_close_protocol(hp);
