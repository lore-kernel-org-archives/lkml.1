Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYDLPnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYDLPnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYDLPm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:42:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:49755 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYDLPm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=flb8+5tSMGLCoKTEJPQCaD2PBR16TDAAkgKrWcVsng1Neovt6N22UeLIYYmfeUNzryAGYaDyPeJ6hSVQE2wFshvr7AzOwqH4HFZlj94Gik6pKxsGwWZ2hd/r+FdJuImgkrsm/oufeVvoMHfhAJsNTFrpk6JKBoLMdEvxjWbmam0=
Date: Sat, 12 Apr 2008 23:39:14 +0800 (CST)
Message-Id: <20080412.233914.54446044.xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] UML: Fix another build error
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3CFcTEB006107


This patch fixes the following build error.

  CC      arch/um/drivers/mconsole_kern.o
/home/wangcong/projects/linux-2.6/arch/um/drivers/mconsole_kern.c:337: error: redefinition of â€˜mconsole_register_devâ€™
/home/wangcong/projects/linux-2.6/arch/um/include/mconsole_kern.h:47: error: previous definition of â€˜mconsole_register_devâ€™ was here
make[2]: *** [arch/um/drivers/mconsole_kern.o] Error 1
make[1]: *** [arch/um/drivers/mconsole_kern.ko] Error 2
make: *** [sub-make] Error 2

Compile testing passed.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
 arch/um/drivers/mconsole_kern.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 19d579d..e94ccb8 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -330,9 +330,12 @@ void mconsole_stop(struct mc_request *req)
 	mconsole_reply(req, "", 0, 0);
 }
 
-static DEFINE_SPINLOCK(mc_devices_lock);
 static LIST_HEAD(mconsole_devices);
 
+#ifdef CONFIG_MCONSOLE
+
+static DEFINE_SPINLOCK(mc_devices_lock);
+
 void mconsole_register_dev(struct mc_device *new)
 {
 	spin_lock(&mc_devices_lock);
@@ -340,6 +343,7 @@ void mconsole_register_dev(struct mc_device *new)
 	list_add(&new->list, &mconsole_devices);
 	spin_unlock(&mc_devices_lock);
 }
+#endif
 
 static struct mc_device *mconsole_find_dev(char *name)
 {
-- 
1.5.2.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
