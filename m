Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066Ab0AGAWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0AGAWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309Ab0AGAWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:22:00 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34596 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0AGAV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cFlKWbdRTPECIM9q8jLJiED1+Tcxlz2ysrMbPCN0Ckx4Vw/r53X1awWCA++5huY6rg
         aowADiFfXG5nrIdnoTv+XhQmRbLguhZZtRMuUCK2YGq+MymdQ1LfBBPc6kW2tnFuHzT7
         i3xMGKt2Ldswcxxq+7Fu+LifHLfI73j9Zyoh0=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] staging: cx25821: avoid NULL pointer dereference
Date: Thu,  7 Jan 2010 03:21:48 +0300
Message-Id: <1262823708-28664-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign dev only if fh is not NULL.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/cx25821/cx25821-audups11.c |    3 ++-
 drivers/staging/cx25821/cx25821-video.c    |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audups11.c b/drivers/staging/cx25821/cx25821-audups11.c
index 89c8fe2..46c7f78 100644
--- a/drivers/staging/cx25821/cx25821-audups11.c
+++ b/drivers/staging/cx25821/cx25821-audups11.c
@@ -343,10 +343,11 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 			 struct v4l2_control *ctl)
 {
 	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_dev *dev;
 	int err;
 
 	if (fh) {
+		dev = fh->dev;
 		err = v4l2_prio_check(&dev->prio, &fh->prio);
 		if (0 != err)
 			return err;
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index c7c14c7..9bcece7 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -963,10 +963,11 @@ int cx25821_set_freq(struct cx25821_dev *dev, struct v4l2_frequency *f)
 int vidioc_s_frequency(struct file *file, void *priv, struct v4l2_frequency *f)
 {
 	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_dev *dev;
 	int err;
 
 	if (fh) {
+		dev = fh->dev;
 		err = v4l2_prio_check(&dev->prio, &fh->prio);
 		if (0 != err)
 			return err;
-- 
1.6.6

