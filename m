Return-Path: <linux-kernel-owner+w=401wt.eu-S932621AbXHWXvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbXHWXvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761807AbXHWXvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:51:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:54564 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824AbXHWXvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=qwchboW3Uj9y1OZZ6PTZtmpFX4Nj4FceEG8vwKeLG1AJhj6g4BgN579WbJutgJEa9Jx9HEN6Faief2l7JkAVdHwO2Cox4Z5rovXCeBcUwRRlDy5gTQ7u7HWnmAhIOoSsNO8gvEVTDuY2qmJ9BL1psgGRq+CVzfEONvM04YbRHio=
Message-Id: <6f21fd93088e3f3b8876b322ab6f87f824472696.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:48:36 +0200
Subject: [PATCH 06/30] i2o: No need to cast kmalloc() return value in cfg_open()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/message/i2o/i2o_config.c::cfg_open() there's a completely
pointless cast of kmalloc()'s return value. This patch removes it.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/message/i2o/i2o_config.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index 84e046e..fb8c668 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -1053,10 +1053,9 @@ static int i2o_cfg_ioctl(struct inode *inode, struct file *fp, unsigned int cmd,
 
 static int cfg_open(struct inode *inode, struct file *file)
 {
-	struct i2o_cfg_info *tmp =
-	    (struct i2o_cfg_info *)kmalloc(sizeof(struct i2o_cfg_info),
-					   GFP_KERNEL);
 	unsigned long flags;
+	struct i2o_cfg_info *tmp =
+		kmalloc(sizeof(struct i2o_cfg_info), GFP_KERNEL);
 
 	if (!tmp)
 		return -ENOMEM;
-- 
1.5.2.2

