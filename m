Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYFAXdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYFAXdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbYFAX2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:28:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:25723 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbYFAX2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=ioJXfQK/i7w1q+jJv8aE/MD2R6z6cSRkLFSsYSiOAgZcgty8rc94vhrirTv+dGzoz3wHblQbIkt4fjqskYXZd4llaKrwyYGA9PovSyBAL/JAG8Ho6opusmeOvtT/A8PYTVRj38Jj653AtqtTxTuUKs1f82eEiVN8TgTAk4+b9lI=
Message-Id: <20080601231628.820854976@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:47 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [patch -v2 18/23] aty: use memory_read_from_buffer
Content-Disposition: inline; filename=aty-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-fbdev-devel@lists.sourceforge.net
---
 drivers/video/aty/radeon_base.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

Index: 2.6-git/drivers/video/aty/radeon_base.c
===================================================================
--- 2.6-git.orig/drivers/video/aty/radeon_base.c
+++ 2.6-git/drivers/video/aty/radeon_base.c
@@ -70,6 +70,7 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/device.h>
+#include <linux/fs.h>
 
 #include <asm/io.h>
 #include <linux/uaccess.h>
@@ -2098,15 +2099,7 @@ static void radeon_identify_vram(struct 
 
 static ssize_t radeon_show_one_edid(char *buf, loff_t off, size_t count, const u8 *edid)
 {
-	if (off > EDID_LENGTH)
-		return 0;
-
-	if (off + count > EDID_LENGTH)
-		count = EDID_LENGTH - off;
-
-	memcpy(buf, edid + off, count);
-
-	return count;
+	return memory_read_from_buffer(buf, count, &off, edid, EDID_LENGTH);
 }
 
 

-- 
