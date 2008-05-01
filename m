Return-Path: <linux-kernel-owner+w=401wt.eu-S1765864AbYEAWuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765864AbYEAWuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYEAWt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:49:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64813 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbYEAWt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:49:58 -0400
Date: Thu, 1 May 2008 18:49:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: akpm@osdl.org, Gerd Knorr <kraxel@bytesex.org>
Subject: [PATCH] fix irq flags in saa7134
Message-ID: <Pine.LNX.4.58.0805011849020.12785@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some files in the drivers/media/video/saa7134 directory uses "int" for flags.
This can cause hard to find bugs on some architectures. This patch converts the
flags to use "long" instead.

This bug was discovered by doing an allyesconfig make on the -rt kernel
where checks are done to ensure all flags are of size sizeof(long).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 drivers/media/video/saa7134/saa7134-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-compile.git/drivers/media/video/saa7134/saa7134-video.c
===================================================================
--- linux-compile.git.orig/drivers/media/video/saa7134/saa7134-video.c	2008-05-01 16:58:39.000000000 -0400
+++ linux-compile.git/drivers/media/video/saa7134/saa7134-video.c	2008-05-01 18:37:57.000000000 -0400
@@ -1634,7 +1634,7 @@ static int saa7134_s_fmt_overlay(struct
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
 	int err;
-	unsigned int flags;
+	unsigned long flags;

 	if (saa7134_no_overlay > 0) {
 		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");

