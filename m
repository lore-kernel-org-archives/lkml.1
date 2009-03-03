Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbZCJQx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbZCJQx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbZCJQoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:44:07 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34597 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbZCJQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:39 -0400
Message-Id: <c1503a7cbc64d44ce1edcc9736cc16757364fb86.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Tue, 3 Mar 2009 15:37:16 +0000
Subject: [PATCH 19/31] riscom8: Auto-load riscom8 module when device opened.
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The riscom8 module is missing the char-major-48-* alias that would cause
it to be auto-loaded when a device of that type is opened.  This patch
adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/riscom8.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 9af8d74..2176604 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -48,6 +48,7 @@
 #include <linux/delay.h>
 #include <linux/tty_flip.h>
 #include <linux/spinlock.h>
+#include <linux/device.h>
 
 #include <linux/uaccess.h>
 
@@ -1524,6 +1525,7 @@ module_param(iobase2, int, 0);
 module_param(iobase3, int, 0);
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(RISCOM8_NORMAL_MAJOR);
 #endif /* MODULE */
 
 /*
-- 
1.6.0.5

