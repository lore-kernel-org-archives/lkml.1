Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbZACSng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbZACSng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 13:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759118AbZACSnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 13:43:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:42938 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbZACSnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 13:43:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=VStX5r8FtkRxjeZTk3ZCoQBRc8/36WgTlP0ZkyFjoFomCj0/t3SsAAOqyhuFZ5pve+
         efozynJkMtMQOGgfhWOwkKCdQOcRRbViBMmk1Z92s0+pYuE370mclt4oHhSmxACc4ha7
         wwWgslKo/4AvW3Igk8xB+n80KXGTn9Aoy+w38=
Message-ID: <495FB1CC.5090506@gmail.com>
Date: Sat, 03 Jan 2009 19:43:24 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: fix SONIC_READ definition
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/jazzsonic.c:56:
#define SONIC_READ(reg) (*((volatile unsigned int *)dev->base_addr+reg))

drivers/net/sonic.h:53:
#define SONIC_CAP0             0x24

so drivers/net/jazzsonic.c:143:
val = SONIC_READ(SONIC_CAP0-i);

becomes

val = (*((volatile unsigned int *)dev->base_addr+0x24-i));

That is wrong, isn't it?
------------->8---------8<------------------
Fix SONIC_READ definition

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/jazzsonic.c b/drivers/net/jazzsonic.c
index 334ff9e..b872f23 100644
--- a/drivers/net/jazzsonic.c
+++ b/drivers/net/jazzsonic.c
@@ -53,7 +53,7 @@ static char jazz_sonic_string[] = "jazzsonic";
 /*
  * Macros to access SONIC registers
  */
-#define SONIC_READ(reg) (*((volatile unsigned int *)dev->base_addr+reg))
+#define SONIC_READ(reg) (*((volatile unsigned int *)dev->base_addr+(reg)))
 
 #define SONIC_WRITE(reg,val)						\
 do {									\
