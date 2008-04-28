Return-Path: <linux-kernel-owner+w=401wt.eu-S938113AbYD1VOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938113AbYD1VOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965262AbYD1VNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:13:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:20776 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936080AbYD1VNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:13:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mjgJwEodCbn9Uls2BLxBC1olSoqyDY17hjq24g82Qyx/oVLWtozApsAKY/LMfi6thBcydkRFTlXibIZ1nXFfUA+vFq278QytLvKW5w7idLLd99WVmpNLkryaGpEmZxg77rxVZMVpeCrPU5BLuzrKzhCCm4/6r6gLs72Gv8FrULQ=
Subject: [PATCH 4/4] drivers: atm, char fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 14:13:20 -0700
Message-Id: <1209417200.14173.103.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/atm/nicstar.c:418:25: warning: Using plain integer as NULL pointer
drivers/char/drm/r128_cce.c:820:25: warning: Using plain integer as NULL pointer
drivers/char/tty_io.c:1183:10: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/atm/nicstar.c       |    2 +-
 drivers/char/drm/r128_cce.c |    2 +-
 drivers/char/tty_io.c       |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 38c769f..3da804b 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -415,7 +415,7 @@ static int __devinit ns_init_card(int i, struct pci_dev *pcidev)
    card->pcidev = pcidev;
    membase = pci_resource_start(pcidev, 1);
    card->membase = ioremap(membase, NS_IOREMAP_SIZE);
-   if (card->membase == 0)
+   if (!card->membase)
    {
       printk("nicstar%d: can't ioremap() membase.\n",i);
       error = 3;
diff --git a/drivers/char/drm/r128_cce.c b/drivers/char/drm/r128_cce.c
index f36adbd..c31afbd 100644
--- a/drivers/char/drm/r128_cce.c
+++ b/drivers/char/drm/r128_cce.c
@@ -817,7 +817,7 @@ static struct drm_buf *r128_freelist_get(struct drm_device * dev)
 	for (i = 0; i < dma->buf_count; i++) {
 		buf = dma->buflist[i];
 		buf_priv = buf->dev_private;
-		if (buf->file_priv == 0)
+		if (!buf->file_priv)
 			return buf;
 	}
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 4d3c701..98b65a2 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1180,7 +1180,7 @@ struct tty_driver *tty_find_polling_driver(char *name, int *line)
 		if (*str == ',')
 			str++;
 		if (*str == '\0')
-			str = 0;
+			str = NULL;
 
 		if (tty_line >= 0 && tty_line <= p->num && p->poll_init &&
 				!p->poll_init(p, tty_line, str)) {
-- 
1.5.5.1.270.g89765

