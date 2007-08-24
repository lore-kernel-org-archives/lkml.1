Return-Path: <linux-kernel-owner+w=401wt.eu-S965137AbXHXA2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137AbXHXA2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764697AbXHXA2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:28:34 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:20009 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764243AbXHXA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=Gj5h1ZJ2WhcUu3TDxWteG1o8Kw0RCxo7WrgKA0Rtp2fNaUiZwSnWU7qqfg4D/xZxlZ7wLSNQPPIULxPyRMDlzwmpcNqO75uTkR1aYH0211YMeZDubbNaxWmssdKu+pRzopVke1gQVH3JdxD76yXt7M8B1hwl3OqjeCKAQ60YKz8=
Message-Id: <746a412d8118b494f0bc6adafd014178a48adc37.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:25:38 +0200
Subject: [PATCH 24/30] dvb: remove some unneeded vmalloc() return value casts from av7110
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
       Christian Theiss <mistert@rz.fh-augsburg.de>, mocm@metzlerbros.de,
       Ralph Metzler <rjkm@thp.uni-koeln.de>,
       Holger Waechtler <holger@convergence.de>,
       Oliver Endriss <o.endriss@gmx.de>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns void * - no need to cast it.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/media/dvb/ttpci/av7110.c    |    2 +-
 drivers/media/dvb/ttpci/av7110_ir.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 8178832..27fa5f8 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -1543,7 +1543,7 @@ static int get_firmware(struct av7110* av7110)
 	}
 
 	/* check if the firmware is available */
-	av7110->bin_fw = (unsigned char *) vmalloc(fw->size);
+	av7110->bin_fw = vmalloc(fw->size);
 	if (NULL == av7110->bin_fw) {
 		dprintk(1, "out of memory\n");
 		release_firmware(fw);
diff --git a/drivers/media/dvb/ttpci/av7110_ir.c b/drivers/media/dvb/ttpci/av7110_ir.c
index 6322800..651863b 100644
--- a/drivers/media/dvb/ttpci/av7110_ir.c
+++ b/drivers/media/dvb/ttpci/av7110_ir.c
@@ -280,7 +280,7 @@ static int av7110_ir_write_proc(struct file *file, const char __user *buffer,
 	if (count < size)
 		return -EINVAL;
 
-	page = (char *) vmalloc(size);
+	page = vmalloc(size);
 	if (!page)
 		return -ENOMEM;
 
-- 
1.5.2.2

