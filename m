Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbXGOUAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbXGOUAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbXGOT7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:59:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39913 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbXGOT7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:59:52 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ieee1394: forgotten dereference...
Cc: linux-kernel@vger.kernel.org, ben.collins@ubuntu.com
Message-Id: <E1IAAFz-00053t-Tt@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 20:59:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Going through the string and waiting for _pointer_ to become '\0'
is not what the authors meant...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ieee1394/nodemgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index c4d3d41..51a1206 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -283,7 +283,7 @@ static ssize_t fw_show_##class##_##td_kv (struct device *dev, struct device_attr
 	memcpy(buf,							\
 	       CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA(class->td_kv),	\
 	       len);							\
-	while ((buf + len - 1) == '\0')					\
+	while (buf[len - 1] == '\0')					\
 		len--;							\
 	buf[len++] = '\n';						\
 	buf[len] = '\0';						\
-- 
1.5.3.GIT


