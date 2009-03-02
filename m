Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZCJQrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZCJQrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbZCJQnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:49 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34596 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZCJQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:39 -0400
Message-Id: <a2efad1bc1a4db7cfa3c5bcec52728dcecf08a4b.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:32:15 +0000
Subject: [PATCH 18/31] cyclades: Auto-load cyclades module when device opened.
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cyclades module is missing the char-major-19-* alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/cyclades.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 6a59f72..4e89d49 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -646,6 +646,7 @@
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
 #include <linux/firmware.h>
+#include <linux/device.h>
 
 #include <asm/system.h>
 #include <linux/io.h>
@@ -5422,3 +5423,4 @@ module_exit(cy_cleanup_module);
 
 MODULE_LICENSE("GPL");
 MODULE_VERSION(CY_VERSION);
+MODULE_ALIAS_CHARDEV_MAJOR(CYCLADES_MAJOR);
-- 
1.6.0.5

