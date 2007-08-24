Return-Path: <linux-kernel-owner+w=401wt.eu-S964952AbXHXAZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964952AbXHXAZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760211AbXHXAZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:25:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:17545 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764508AbXHXAZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:25:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=oYuQGK3Cq1XpgerSgjzesZhI9AHYvp4ySIN2ipAZPJqGaJO9Y9FpSTpp0YX6paPoqunytRAt82me34qKf0ParCjmEYdFBr208wmscPmbjHeZgReIwGJOhoMJsoDUnlsH/k8kfpCoVDslC2+Ca/PnVB4Moqg2Sq6m4uOE8YOkT28=
Message-Id: <81d634fd6bc878d5b150b90556808dfc57d2bd8a.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:22:15 +0200
Subject: [PATCH 23/30] video: Remove pointless kmalloc() return value cast in Zoran PCI controller driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: video4linux-list@redhat.com, Ronald Bultje <rbultje@ronald.bitfreak.net>,
       mjpeg-users@lists.sourceforge.net, Serguei Miridonov <mirsev@cicese.mx>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No need to cast the void pointer returned by kmalloc() in
drivers/media/video/zoran_driver.c::v4l_fbuffer_alloc().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/media/video/zoran_driver.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/zoran_driver.c b/drivers/media/video/zoran_driver.c
index 72a037b..bc2e5b3 100644
--- a/drivers/media/video/zoran_driver.c
+++ b/drivers/media/video/zoran_driver.c
@@ -347,10 +347,7 @@ v4l_fbuffer_alloc (struct file *file)
 		if (fh->v4l_buffers.buffer_size <= MAX_KMALLOC_MEM) {
 			/* Use kmalloc */
 
-			mem =
-			    (unsigned char *) kmalloc(fh->v4l_buffers.
-						      buffer_size,
-						      GFP_KERNEL);
+			mem = kmalloc(fh->v4l_buffers.buffer_size, GFP_KERNEL);
 			if (mem == 0) {
 				dprintk(1,
 					KERN_ERR
-- 
1.5.2.2

