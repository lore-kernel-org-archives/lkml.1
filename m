Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbYFDMPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbYFDMPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYFDMKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:53 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:64902 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760305AbYFDMKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=B7K3aZAytBst0H4P8W0mzFbfY6zFlEpVKzQTkKGlgDmZCu1IOGxuLm4v2xM+GT5d+/
         C9rcflO3Zx8AjK+3y8VC/PHkshhFRjBnMIOCo/BO0zd+eOIMcgk8z0hzWz3F++JUscSa
         j++3fIA1IA2ZlrfK7VwUvcUV2Uvb7+fQs2QuE=
Message-Id: <20080604115828.992854080@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:50 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [patch -v3 17/22] aty: use memory_read_from_buffer
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
