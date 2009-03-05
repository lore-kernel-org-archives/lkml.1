Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbZCJQrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbZCJQrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZCJQnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:51 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34633 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbZCJQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:42 -0400
Message-Id: <6a6e566959d30a7e03d677bcb5f68f71d1988e9d.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 4 Mar 2009 20:55:52 -0700
Subject: [PATCH 29/31] esp: Auto-load esp module when device opened.
To: linux-kernel@vger.kernel.org
Cc: arobinso@nyx.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The esp module is missing the char-major-57-* alias that would cause it
to be auto-loaded when a device of that type is opened.  This patch adds
the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/esp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/esp.c b/drivers/char/esp.c
index 45ec263..0a643f6 100644
--- a/drivers/char/esp.c
+++ b/drivers/char/esp.c
@@ -51,6 +51,7 @@
 #include <linux/serialP.h>
 #include <linux/serial_reg.h>
 #include <linux/major.h>
+#include <linux/device.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
 #include <linux/ptrace.h>
@@ -85,6 +86,8 @@ static unsigned int rx_timeout = ESP_RX_TMOUT;
 static unsigned int pio_threshold = ESP_PIO_THRESHOLD;
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(ESP_IN_MAJOR);
+
 
 module_param_array(irq, int, NULL, 0);
 module_param_array(divisor, uint, NULL, 0);
-- 
1.6.0.5

