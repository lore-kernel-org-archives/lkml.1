Return-Path: <linux-kernel-owner+w=401wt.eu-S1765682AbZDAOLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765682AbZDAOLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932132AbZDAOGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:06:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37774 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765948AbZDAOGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:06:08 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 14/24] riscom8: Auto-load riscom8 module when device opened.
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:06:24 +0100
Message-ID: <20090401140621.22882.63064.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
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

