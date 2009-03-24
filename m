Return-Path: <linux-kernel-owner+w=401wt.eu-S1760551AbZCXOKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760551AbZCXOKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758967AbZCXOEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:04:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48976 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758777AbZCXOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:04:42 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 19/30] riscom8: Auto-load riscom8 module when device opened.
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:05:04 +0000
Message-ID: <20090324140459.12735.78437.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
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

