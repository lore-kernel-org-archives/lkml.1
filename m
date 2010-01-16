Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0APN0O (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 08:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531Ab0APN0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 08:26:13 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:36939 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab0APN0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 08:26:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=W3zVrKtGEwcMbf9kwSt1Z+WkLxGJPkosTNz5ICJannhZBAvw8x4eJL8FXWQ4Cd+MlE
         ovbUp5YkEbwCdcLKar4SgPMGRZu3SnXrZysdQHG++iCI+txmT5wqSZxhzFPxxUDMBaSa
         CGj5/tpsJWMhqal/gFa4FA/lBJjHxwsMwmCaQ=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Janne Grunau <j@jannau.net>, Patrick Boettcher <pboettcher@dibcom.fr>,
        tstrelar@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH] dvb-core: remove unnecessary casting of kmalloc.
Date: Sat, 16 Jan 2010 08:25:38 -0500
Message-Id: <5d6d41f6f7ebbb3c358bb804e01cbc0b7ca8859e.1263648089.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.103.g699d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 0746122..8eb4a3b 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1536,8 +1536,7 @@ static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
 		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = (struct dtv_property *) kmalloc(tvps->num *
-			sizeof(struct dtv_property), GFP_KERNEL);
+		tvp = kmalloc(tvps->num * sizeof(struct dtv_property), GFP_KERNEL);
 		if (!tvp) {
 			err = -ENOMEM;
 			goto out;
@@ -1569,8 +1568,7 @@ static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
 		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = (struct dtv_property *) kmalloc(tvps->num *
-			sizeof(struct dtv_property), GFP_KERNEL);
+		tvp = kmalloc(tvps->num * sizeof(struct dtv_property), GFP_KERNEL);
 		if (!tvp) {
 			err = -ENOMEM;
 			goto out;
-- 
1.6.6.103.g699d2

