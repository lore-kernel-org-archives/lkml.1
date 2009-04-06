Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbZDFPht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbZDFPht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZDFPfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:35:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56984 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172AbZDFPfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:35:07 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 14/27] riscom8: Auto-load riscom8 module when device opened.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:33:26 +0100
Message-ID: <20090406163323.12934.89371.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott James Remnant <scott@canonical.com>

The riscom8 module is missing the char-major-48-* alias that would cause
it to be auto-loaded when a device of that type is opened.  This patch
adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
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

