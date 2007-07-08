Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbXGIH0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbXGIH0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 03:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXGIHZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 03:25:49 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:33757 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbXGIHZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 03:25:48 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Initialize filp->private_data only once in em28xx_v4l2_open
Date: Sun, 8 Jul 2007 18:03:44 +0200
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org
References: <200707081754.03824.eike-kernel@sf-tec.de>
In-Reply-To: <200707081754.03824.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707081803.44377.eike-kernel@sf-tec.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some lines later filp->private_data is initialized to dev again. Since there
are some checks that might fail in the mean time keep the later version.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit 7103e0b114b01a16d7c1ea71914d5069d974167d
tree 6b976d7ce4e872b32805d7df73dd13b5349d439f
parent 39c068bce1d63f6c1345c1ddfda1841d9fd20c74
author Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 25 Jul 2006 17:55:34 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 25 Jul 2006 17:55:34 +0200

 drivers/media/video/em28xx/em28xx-video.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 2a461dd..b2ae0c8 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -268,8 +268,6 @@ static int em28xx_v4l2_open(struct inode *inode, struct file *filp)
 	if (NULL == dev)
 		return -ENODEV;
 
-	filp->private_data=dev;
-
 	em28xx_videodbg("open minor=%d type=%s users=%d\n",
 				minor,v4l2_type_names[dev->type],dev->users);
 
