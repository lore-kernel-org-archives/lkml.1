Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZBFI0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZBFI0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZBFI0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:26:07 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:12424 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbZBFI0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:26:06 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82424721"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] tty: fix bug - kernel can't be pinged through when bootargs console=null
Date: Fri,  6 Feb 2009 16:27:57 +0800
Message-Id: <1233908877-7729-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

when pass bootargs console=null into kernel from u-boot, the booted up
kernel can't be pinged through. This happens after the kernel is upgraded
to 2.6.28.

Should check if tty_driver is NULL before call kref_get() in tty_driver_kref_get().

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 include/linux/tty_driver.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 08e0883..2a602a8 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -312,7 +312,8 @@ extern struct tty_driver *tty_find_polling_driver(char *name, int *line);
 extern void tty_driver_kref_put(struct tty_driver *driver);
 extern inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
 {
-	kref_get(&d->kref);
+	if (d)
+		kref_get(&d->kref);
 	return d;
 }
 
-- 
1.5.6.3
