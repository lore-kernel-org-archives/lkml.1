Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZLBMVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZLBMVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZLBMVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:21:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39670 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbZLBMVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:organization
         :to:cc:content-type:content-transfer-encoding:message-id;
        b=cxVxW/9tp3p/BeZTv+t9J2Rm1quNTPYionKPyS+HWBYEmn2H6mByBaqArpFP8PtD3Z
         iXKHO5/lv6tpgU2pzqBzK2+bUVfAO9d4aDRBFBEYUjshycYGj2tX7AQU2YzCn1SZeatf
         z41KdzS5k9QZllLNkGhj6yP9cJwfoxqQ2W2Ik=
From: Florian Fainelli <florian@openwrt.org>
Date: Wed, 2 Dec 2009 13:21:23 +0100
Subject: [PATCH] rc32434_wdt: fix compilation failure
MIME-Version: 1.0
X-Length: 1439
Organization: OpenWrt
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912021321.24198.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

This is a pretty critical fix, please try to get it in 2.6.32. Thank you
very much!
---
From: Florian Fainelli <florian@openwrt.org>
Subject: [PATCH] rc32434_wdt: fix compilation failure

This patch fixes the compilation failure of
rc32434 due to a bad module parameter description.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index f6cccc9..47588de 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -62,7 +62,7 @@ extern unsigned int idt_cpu_freq;
 static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Watchdog timeout value, in seconds (default="
-		WATCHDOG_TIMEOUT ")");
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
