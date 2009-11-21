Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZKUNkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZKUNkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZKUNj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:39:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41031 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbZKUNj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:39:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=PghdO59Gfk6d92uwebghJIpvX/5qmlqT1WQ/i7Tr90hAeDkUHx/UxetGaJFWRn0TpB
         vA2XWEWSgdnFdvuKoFWIQdF8b6gSKD8NlaSxb4AmlODAcJ3dd1SG0b5W+wLL65pviKDB
         6mvW5fNPwz8fL6EJ0F0CAKMIrr6s1iTj8iefM=
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [RFC PATCH 2/9] Serial: sc26xx fix build errors.
To: tsbogend@alpha.franken.de, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2009 14:39:59 +0100
Message-ID: <20091121133959.16090.39414.stgit@srv002.fuzzey.net>
In-Reply-To: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
References: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing include.
Use __devexit rather than __exit to allow building in kernel.

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 drivers/serial/sc26xx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/sc26xx.c b/drivers/serial/sc26xx.c
index 75038ad..dc09682 100644
--- a/drivers/serial/sc26xx.c
+++ b/drivers/serial/sc26xx.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/irq.h>
+#include <linux/io.h>
 
 #if defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
@@ -709,7 +710,7 @@ out_free_port:
 }
 
 
-static int __exit sc26xx_driver_remove(struct platform_device *dev)
+static int __devexit sc26xx_driver_remove(struct platform_device *dev)
 {
 	struct uart_sc26xx_port *up = dev_get_drvdata(&dev->dev);
 

