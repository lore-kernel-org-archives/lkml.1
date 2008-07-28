Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYG1T7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYG1T7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYG1T7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:59:04 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55986 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYG1T7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:59:03 -0400
Date: Mon, 28 Jul 2008 22:58:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix drivers/media/video/arv.c compilation
Message-ID: <20080728195819.GB7713@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile errors:

<--  snip  -->

...
  CC [M]  drivers/media/video/arv.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/arv.c: In function 'ar_ioctl':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/arv.c:544: error: implicit declaration of function 'video_usercopy'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/arv.c: At top level:
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/arv.c:758: error: unknown field 'type' specified in initializer
make[4]: *** [drivers/media/video/arv.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/arv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

0745b77aceec2e450f4d4ca4c8e59f1bfbacd977 
diff --git a/drivers/media/video/arv.c b/drivers/media/video/arv.c
index 56ebfd5..9e436ad 100644
--- a/drivers/media/video/arv.c
+++ b/drivers/media/video/arv.c
@@ -29,6 +29,7 @@
 #include <linux/sched.h>
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
 #include <linux/mutex.h>
 
 #include <asm/uaccess.h>
@@ -755,7 +756,6 @@ static const struct file_operations ar_fops = {
 
 static struct video_device ar_template = {
 	.name		= "Colour AR VGA",
-	.type		= VID_TYPE_CAPTURE,
 	.fops		= &ar_fops,
 	.release	= ar_release,
 	.minor		= -1,

