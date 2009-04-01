Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbZDAOJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbZDAOJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765816AbZDAOFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:05:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37769 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765916AbZDAOFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:05:50 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/24] cyclades: Auto-load cyclades module when device opened.
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:06:02 +0100
Message-ID: <20090401140559.22882.91443.stgit@localhost.localdomain>
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

The cyclades module is missing the char-major-19-* alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
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

